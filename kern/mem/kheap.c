#include "kheap.h"

#include <inc/memlayout.h>
#include <inc/dynamic_allocator.h>
#include <kern/conc/sleeplock.h>
#include <kern/proc/user_environment.h>
#include <kern/mem/memory_manager.h>
#include "../conc/kspinlock.h"

//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

//==============================================
// [1] INITIALIZE KERNEL HEAP:
//==============================================
//TODO: [PROJECT'25.GM#2] KERNEL HEAP - #0 kheap_init [GIVEN]
//Remember to initialize locks (if any)
void kheap_init()
{
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		initialize_dynamic_allocator(KERNEL_HEAP_START, KERNEL_HEAP_START + DYN_ALLOC_MAX_SIZE);
		set_kheap_strategy(KHP_PLACE_CUSTOMFIT);
		kheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
		kheapPageAllocBreak = kheapPageAllocStart;
	}
	//==================================================================================
	//==================================================================================
}

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
	int ret = alloc_page(ptr_page_directory, ROUNDDOWN((uint32)va, PAGE_SIZE), PERM_WRITEABLE, 1);
	if (ret < 0)
		panic("get_page() in kern: failed to allocate page from the kernel");
	return 0;
}

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
	unmap_frame(ptr_page_directory, ROUNDDOWN((uint32)va, PAGE_SIZE));
}

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
//===================================
// [1] ALLOCATE SPACE IN KERNEL HEAP:
//===================================


int is_page_free(uint32 *pd, uint32 va) {
    uint32 *pt = NULL;
    struct FrameInfo *fi = get_frame_info(pd, va, &pt);
    return (fi == NULL) ? 1 : 0; // Unmapped = free
}

// Global data 
struct PageAlloc {
    uint32 va;
    uint32 size;
    struct PageAlloc *next;
};
struct PageAlloc *page_alloc_list = NULL;


void* kmalloc(unsigned int size)
{
    // TODO: [PROJECT'25.GM#2] KERNEL HEAP - #1 kmalloc
    if (size == 0) return NULL; // 
    if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
        return alloc_block(size); // Small allocations via dynamic allocator
    }
    uint32 rounded_size = ROUNDUP(size, PAGE_SIZE);
    if (rounded_size > KERNEL_HEAP_MAX - kheapPageAllocBreak) {
        return NULL; // bigger than the kernel space
    }
    uint32 needed_pages = rounded_size / PAGE_SIZE;
    uint32 current_start = (uint32)-1, max_start = (uint32)-1;
    uint32 current_sum = 0, max_contiguous = 0;
    uint32 va = 0;
    uint32 *pd = ptr_page_directory;
    // Scan for first exact or worstfit
    for (uint32 i = kheapPageAllocStart; i < kheapPageAllocBreak; i += PAGE_SIZE) {
        if (!is_page_free(pd, i)) {
            // End of hole
            if (current_sum == needed_pages) {
                va = current_start;
                break; // First exact , return 
            }
            if (current_sum >= needed_pages && current_sum > max_contiguous) {
                max_contiguous = current_sum;
                max_start = current_start;
            }
            // reset
            current_start = (uint32)-1;
            current_sum = 0;
            continue;
        }
        // start of new hole
        if (current_start == (uint32)-1) {
            current_start = i;
        }
        current_sum++;
    }
    // Trailing hole check
    if (current_sum > 0) {
        if (current_sum == needed_pages) {
            va = current_start;
            // No break needed, end of loop
        } else if (current_sum >= needed_pages && current_sum > max_contiguous) {
            max_contiguous = current_sum;
            max_start = current_start;
        }
    }
    if (va == 0) {
        if (max_contiguous >= needed_pages) {
            va = max_start; // Worst fit hole
        } else {
            // Expand: append at break
            uint32 new_break = kheapPageAllocBreak + rounded_size;
            if (new_break > KERNEL_HEAP_MAX) {
                return NULL; // Can't grow
            }
            va = kheapPageAllocBreak;
            kheapPageAllocBreak = new_break;
        }
    }
    // Map the range: alloc frames + wire VAs (rollback on fail)
    for (uint32 j = 0; j < needed_pages; j++) {
        uint32 cur_va = va + (j * PAGE_SIZE);
        struct FrameInfo *fi = NULL;
        if (allocate_frame(&fi) != 0) { // E_NO_MEM?
            // Rollback mapped pages
            for (uint32 k = 0; k < j; k++) {
                unmap_frame(pd, va + (k * PAGE_SIZE));
            }
            if (va == kheapPageAllocBreak - rounded_size) { 
                kheapPageAllocBreak -= rounded_size;
            }
            return NULL;
        }
        if (map_frame(pd, fi, cur_va, PERM_PRESENT | PERM_WRITEABLE) != 0) { // Already mapped? Fail
            free_frame(fi); // Back to list
            // Rollback
            for (uint32 k = 0; k < j; k++) {
                unmap_frame(pd, va + (k * PAGE_SIZE));
            }
            if (va == kheapPageAllocBreak - rounded_size) { 
                kheapPageAllocBreak -= rounded_size;
            }
            return NULL;
        }
    }
    //  metadata for page allocation
    struct PageAlloc *new_alloc = alloc_block(sizeof(struct PageAlloc));
    if (new_alloc == NULL) {
        // Rollback the mapping (free frames and unmap)
        for (uint32 k = 0; k < needed_pages; k++) {
            // Assuming unmap_frame frees the frame - if not, add explicit free_frame here
            unmap_frame(pd, va + (k * PAGE_SIZE));
        }
        if (va == kheapPageAllocBreak - rounded_size) {
            kheapPageAllocBreak -= rounded_size;
        }
        return NULL;
    }
    new_alloc->va = va;
    new_alloc->size = rounded_size;
    new_alloc->next = page_alloc_list;
    page_alloc_list = new_alloc;
    // TODO: [PROJECT'25.BONUS#3] FAST PAGE ALLOCATOR
    return (void *)va;
}
//=================================
// [2] FREE SPACE FROM KERNEL HEAP:
//=================================
void kfree(void* virtual_address)
{
	void kfree(void* virtual_address) {
    if (virtual_address == NULL) return;
    uint32 va = (uint32)virtual_address;
    if (va >= KERNEL_HEAP_START && va < kheapPageAllocStart) {
        free_block(virtual_address); // deligate to dynalloc
        return;
    }
    if (va < kheapPageAllocStart || va >= kheapPageAllocBreak) return; // Invalid

    // use global data
    struct PageAlloc *prev = NULL, *curr = page_alloc_list;
    uint32 size = 0;
    while (curr) {
        if (curr->va == va) {
            size = curr->size;
            if (prev) prev->next = curr->next;
            else page_alloc_list = curr->next;
            free_block(curr); // Recycle meta
            break;
        }
        prev = curr;
        curr = curr->next;
    }
    if (size == 0) return; // Not found

    // Unmap
    uint32 needed_pages = size / PAGE_SIZE;
    uint32 *pd = ptr_page_directory;
    for (uint32 j = 0; j < needed_pages; j++) {
        uint32 cur_va = va + (j * PAGE_SIZE);
        unmap_frame(pd, cur_va);
    }

    // Shrink if tail (existing check)
    if (va + size == kheapPageAllocBreak) {
        kheapPageAllocBreak -= size;
    }

    uint32 trim_count = 0;
    uint32 check_va = kheapPageAllocBreak - PAGE_SIZE;
    while (check_va >= kheapPageAllocStart && check_va < kheapPageAllocBreak && // Safety: < break
           is_page_free(pd, check_va)) {
        trim_count++;
        if (check_va < PAGE_SIZE) break; // Prevent underflow
        check_va -= PAGE_SIZE;
    }
    if (trim_count > 0) {
        kheapPageAllocBreak -= (trim_count * PAGE_SIZE);
    }
}
}

//=================================
// [3] FIND VA OF GIVEN PA:
//=================================
unsigned int kheap_virtual_address(unsigned int physical_address)
{
	//TODO: [PROJECT'25.GM#2] KERNEL HEAP - #3 kheap_virtual_address
	//Your code is here
	//Comment the following line
	panic("kheap_virtual_address() is not implemented yet...!!");

	/*EFFICIENT IMPLEMENTATION ~O(1) IS REQUIRED */
}

//=================================
// [4] FIND PA OF GIVEN VA:
//=================================
unsigned int kheap_physical_address(unsigned int virtual_address)
{
	//TODO: [PROJECT'25.GM#2] KERNEL HEAP - #4 kheap_physical_address
	//Your code is here
	//Comment the following line
	panic("kheap_physical_address() is not implemented yet...!!");

	/*EFFICIENT IMPLEMENTATION ~O(1) IS REQUIRED */
}

//=================================================================================//
//============================== BONUS FUNCTION ===================================//
//=================================================================================//
// krealloc():

//	Attempts to resize the allocated space at "virtual_address" to "new_size" bytes,
//	possibly moving it in the heap.
//	If successful, returns the new virtual_address, in which case the old virtual_address must no longer be accessed.
//	On failure, returns a null pointer, and the old virtual_address remains valid.

//	A call with virtual_address = null is equivalent to kmalloc().
//	A call with new_size = zero is equivalent to kfree().

extern __inline__ uint32 get_block_size(void *va);

void *krealloc(void *virtual_address, uint32 new_size)
{
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - krealloc
	//Your code is here
	//Comment the following line
	panic("krealloc() is not implemented yet...!!");
}

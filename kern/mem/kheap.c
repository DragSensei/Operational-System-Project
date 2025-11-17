#include "kheap.h"

#include <inc/memlayout.h>
#include <inc/dynamic_allocator.h>
#include <kern/conc/sleeplock.h>
#include <kern/proc/user_environment.h>
#include <kern/mem/memory_manager.h>
#include "../conc/kspinlock.h"
#include <kern/conc/kspinlock.h>

//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//
struct kspinlock kheap_lock;

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
	init_kspinlock(&kheap_lock, "kheap_lock");
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
	acquire_kspinlock(&kheap_lock);

	// TODO: [PROJECT'25.GM#2] KERNEL HEAP - #1 kmalloc
	if (size == 0) {
		release_kspinlock(&kheap_lock); 
		return NULL; 
	}
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
		void* block = alloc_block(size); // Small allocations via dynamic allocator
		release_kspinlock(&kheap_lock); 
		return block;
	}
	uint32 rounded_size = ROUNDUP(size, PAGE_SIZE);
	if (rounded_size > KERNEL_HEAP_MAX - kheapPageAllocBreak) {
		release_kspinlock(&kheap_lock); 
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
				break; 
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
				release_kspinlock(&kheap_lock); // ADDED
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
			release_kspinlock(&kheap_lock); 
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
			release_kspinlock(&kheap_lock); 
			return NULL;
		}
	}
	// 	metadata for page allocation
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
		release_kspinlock(&kheap_lock); 
		return NULL;
	}
	new_alloc->va = va;
	new_alloc->size = rounded_size;
	new_alloc->next = page_alloc_list;
	page_alloc_list = new_alloc;
	// TODO: [PROJECT'25.BONUS#3] FAST PAGE ALLOCATOR
	
	release_kspinlock(&kheap_lock);
	return (void *)va;
}
//=================================
// [2] FREE SPACE FROM KERNEL HEAP:
//=================================

void kfree(void* virtual_address) {
	acquire_kspinlock(&kheap_lock);

	if (virtual_address == NULL) {
		release_kspinlock(&kheap_lock); 
		return;
	}
	uint32 va = (uint32)virtual_address;
	if (va >= KERNEL_HEAP_START && va < kheapPageAllocStart) {
		free_block(virtual_address); 
		release_kspinlock(&kheap_lock); 
		return;
	}
	if (va < kheapPageAllocStart || va >= kheapPageAllocBreak) {
		release_kspinlock(&kheap_lock); 
		return; // Invalid
	}

	// use global data
	struct PageAlloc *prev = NULL, *curr = page_alloc_list;
	uint32 size = 0;
	while (curr) {
		if (curr->va == va) {
			size = curr->size;
			if (prev) prev->next = curr->next;
			else page_alloc_list = curr->next;
			free_block(curr); 
			break;
		}
		prev = curr;
		curr = curr->next;
	}
	if (size == 0) {
		release_kspinlock(&kheap_lock); 
		return; 
	}

	// Unmap
	uint32 needed_pages = size / PAGE_SIZE;
	uint32 *pd = ptr_page_directory;
	for (uint32 j = 0; j < needed_pages; j++) {
		uint32 cur_va = va + (j * PAGE_SIZE);
		unmap_frame(pd, cur_va);
	}
	

	uint32 trim_count = 0;
	uint32 check_va = kheapPageAllocBreak - PAGE_SIZE;
	while (check_va >= kheapPageAllocStart && check_va < kheapPageAllocBreak && 
			is_page_free(pd, check_va)) {
		trim_count++;
		if (check_va < PAGE_SIZE) break; 
		check_va -= PAGE_SIZE;
	}
	if (trim_count > 0) {
		kheapPageAllocBreak -= (trim_count * PAGE_SIZE);
	}

	release_kspinlock(&kheap_lock);
}


//=================================
// [3] FIND VA OF GIVEN PA:
//=================================
unsigned int kheap_virtual_address(unsigned int physical_address)
{
	acquire_kspinlock(&kheap_lock);

	//TODO: [PROJECT'25.GM#2] KERNEL HEAP - #3 kheap_virtual_address
	//Your code is here
	if(physical_address == 0)
	{
		release_kspinlock(&kheap_lock); 
		return 0;
	}

	uint32 offset = physical_address & 0xFFF;
	struct FrameInfo *ptr_frame_info = to_frame_info(physical_address);

	if(ptr_frame_info == NULL || ptr_frame_info->va == 0)
	{
		release_kspinlock(&kheap_lock); 
		return 0;
	}

	uint32 va = ptr_frame_info->va + offset;
	release_kspinlock(&kheap_lock); 
	return va;
	//Comment the following line
	// panic("kheap_virtual_address() is not implemented yet...!!");

	/*EFFICIENT IMPLEMENTATION ~O(1) IS REQUIRED */
}

//=================================
// [4] FIND PA OF GIVEN VA:
//=================================
unsigned int kheap_physical_address(unsigned int virtual_address)
{
	acquire_kspinlock(&kheap_lock);

	//TODO: [PROJECT'25.GM#2] KERNEL HEAP - #4 kheap_physical_address
	//Your code is here
	if(virtual_address < KERNEL_HEAP_START ||virtual_address >= KERNEL_HEAP_MAX)
		{
			release_kspinlock(&kheap_lock); 
			return 0;
		}

	uint32 *ptr_page_table = NULL;
	get_page_table(ptr_page_directory, virtual_address, &ptr_page_table);

	if(ptr_page_table == NULL)
	{
		release_kspinlock(&kheap_lock); 
		return 0;
	}

	uint32 pte = ptr_page_table[PTX(virtual_address)];
	if(pte == 0)
	{
		release_kspinlock(&kheap_lock); 
		return 0;
	}

	uint32 page_offset 	= virtual_address & 0xFFF;
	uint32 frame_number = pte & 0xFFFFF000;
	
	uint32 pa = frame_number | page_offset;
	release_kspinlock(&kheap_lock); 
	return pa;
	//Comment the following line
	// panic("kheap_physical_address() is not implemented yet...!!");

	/*EFFICIENT IMPLEMENTATION ~O(1) IS REQUIRED */
}

//=================================================================================//
//============================== BONUS FUNCTION ===================================//
//=================================================================================//


extern __inline__ uint32 get_block_size(void *va);

void *krealloc(void *virtual_address, uint32 new_size)
{
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - krealloc
	//Your code is here
	//Comment the following line
	panic("krealloc() is not implemented yet...!!");
}
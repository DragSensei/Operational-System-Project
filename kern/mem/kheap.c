#include "kheap.h"

#include <inc/memlayout.h>
#include <inc/dynamic_allocator.h>
#include <kern/conc/sleeplock.h>
#include <kern/proc/user_environment.h>
#include <kern/mem/memory_manager.h>
#include "../conc/kspinlock.h"
#include <kern/conc/kspinlock.h>

#define KHEAP_START_ADDR (KERNEL_HEAP_START + DYN_ALLOC_MAX_SIZE)
#define MAX_KHEAP_PAGES ((KERNEL_HEAP_MAX - KHEAP_START_ADDR) / PAGE_SIZE)

uint32 kheap_allocations[MAX_KHEAP_PAGES];
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//
struct kspinlock kheap_lock;

//==============================================
// [1] INITIALIZE KERNEL HEAP:
//==============================================
// TODO: [PROJECT'25.GM#2] KERNEL HEAP - #0 kheap_init [GIVEN]
// Remember to initialize locks (if any)
void kheap_init()
{
	//==================================================================================
	// DON'T CHANGE THESE LINES==========================================================
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
int get_page(void *va)
{
	int ret = alloc_page(ptr_page_directory, ROUNDDOWN((uint32)va, PAGE_SIZE), PERM_WRITEABLE, 1);
	if (ret < 0)
		panic("get_page() in kern: failed to allocate page from the kernel");
	return 0;
}

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void *va)
{
	unmap_frame(ptr_page_directory, ROUNDDOWN((uint32)va, PAGE_SIZE));
}

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
//===================================
// [1] ALLOCATE SPACE IN KERNEL HEAP:
//===================================

void kheap_mark_pages(uint32 start_va, uint32 size)
{
	uint32 start_idx = (start_va - KHEAP_START_ADDR) / PAGE_SIZE;
	uint32 num_pages = size / PAGE_SIZE;

	kheap_allocations[start_idx] = size;

	for (int i = 1; i < num_pages; i++)
	{
		kheap_allocations[start_idx + i] = 1;
	}
}

void kheap_clear_pages(uint32 start_va, uint32 size)
{
	uint32 start_idx = (start_va - KHEAP_START_ADDR) / PAGE_SIZE;
	uint32 num_pages = size / PAGE_SIZE;

	for (int i = 0; i < num_pages; i++)
	{
		kheap_allocations[start_idx + i] = 0;
	}
}

// int is_page_free(uint32 *pd, uint32 va) {
// 	uint32 *pt = NULL;
// 	struct FrameInfo *fi = get_frame_info(pd, va, &pt);
// 	return (fi == NULL) ? 1 : 0; // Unmapped = free
// }

// // Global data
// struct PageAlloc {
// 	uint32 va;
// 	uint32 size;
// 	struct PageAlloc *next;
// };
// struct PageAlloc *page_alloc_list = NULL;

void *kmalloc(unsigned int size)
{
	acquire_kspinlock(&kheap_lock);

	// TODO: [PROJECT'25.GM#2] KERNEL HEAP - #1 kmalloc
	if (size == 0)
	{
		release_kspinlock(&kheap_lock);
		return NULL;
	}
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
	{
		void *block = alloc_block(size); // Small allocations via dynamic allocator
		release_kspinlock(&kheap_lock);
		return block;
	}
	uint32 rounded_size = ROUNDUP(size, PAGE_SIZE);
	if (rounded_size > KERNEL_HEAP_MAX - kheapPageAllocBreak)
	{
		release_kspinlock(&kheap_lock);
		return NULL; // bigger than the kernel space
	}

	uint32 needed_pages = rounded_size / PAGE_SIZE;

	uint32 start_idx = (kheapPageAllocStart - KHEAP_START_ADDR) / PAGE_SIZE;
	uint32 break_idx = (kheapPageAllocBreak - KHEAP_START_ADDR) / PAGE_SIZE;

	uint32 current_hole_start_idx = -1;
	uint32 current_hole_size = 0;

	uint32 worst_fit_idx = -1;
	uint32 worst_fit_size = 0;

	uint32 found_va = 0;

	for (uint32 i = start_idx; i < break_idx; i++)
	{
		if (kheap_allocations[i] == 0)
		{
			if (current_hole_size == 0)
				current_hole_start_idx = i;
			current_hole_size++;
		}
		else
		{
			if (current_hole_size > 0)
			{
				if (current_hole_size == needed_pages)
				{
					found_va = KHEAP_START_ADDR + (current_hole_start_idx * PAGE_SIZE);
				}
				if (current_hole_size > needed_pages)
				{
					if (current_hole_size > worst_fit_size)
					{
						worst_fit_size = current_hole_size;
						worst_fit_idx = current_hole_start_idx;
					}
				}

				current_hole_size = 0;
				current_hole_start_idx = -1;
			}
		}
	}

	if (found_va == 0 && current_hole_size > 0)
	{
		if (current_hole_size == needed_pages)
		{
			found_va = KHEAP_START_ADDR + (current_hole_start_idx * PAGE_SIZE);
		}
		else if (current_hole_size > needed_pages)
		{
			if (current_hole_size > worst_fit_size)
			{
				worst_fit_size = current_hole_size;
				worst_fit_idx = current_hole_start_idx;
			}
		}
	}

	if (found_va == 0)
	{
		if (worst_fit_idx != -1)
		{
			found_va = KHEAP_START_ADDR + (worst_fit_idx * PAGE_SIZE);
		}
		else
		{
			if (kheapPageAllocBreak + rounded_size > KERNEL_HEAP_MAX)
			{
				release_kspinlock(&kheap_lock);
				return NULL;
			}
			found_va = kheapPageAllocBreak;
			kheapPageAllocBreak += rounded_size;
		}
	}

	uint32 *pd = ptr_page_directory;

	for (uint32 i = 0; i < needed_pages; i++)
	{
		uint32 va_to_map = found_va + (i * PAGE_SIZE);
		struct FrameInfo *fi = NULL;

		int ret = allocate_frame(&fi);
		if (ret != 0)
		{
			for (uint32 k = 0; k < i; k++)
			{
				unmap_frame(pd, found_va + (k * PAGE_SIZE));
			}

			if (found_va == kheapPageAllocBreak - rounded_size)
			{
				kheapPageAllocBreak -= rounded_size;
			}
			release_kspinlock(&kheap_lock);
			return NULL;
		}

		ret = map_frame(pd, fi, va_to_map, PERM_WRITEABLE | PERM_PRESENT);
		if (ret != 0)
		{
			free_frame(fi);
			for (uint32 k = 0; k < i; k++)
			{
				unmap_frame(pd, found_va + (k * PAGE_SIZE));
			}

			if (found_va == kheapPageAllocBreak - rounded_size)
			{
				kheapPageAllocBreak -= rounded_size;
			}
			release_kspinlock(&kheap_lock);
			return NULL;
		}
	}

	kheap_mark_pages(found_va, rounded_size);

	release_kspinlock(&kheap_lock);
	return (void *)found_va;
}
//=================================
// [2] FREE SPACE FROM KERNEL HEAP:
//=================================

void kfree(void *virtual_address)
{
	acquire_kspinlock(&kheap_lock);

	if (virtual_address == NULL)
	{
		release_kspinlock(&kheap_lock);
		return;
	}
	uint32 va = (uint32)virtual_address;
	if (va >= KERNEL_HEAP_START && va < kheapPageAllocStart)
	{
		free_block(virtual_address);
		release_kspinlock(&kheap_lock);
		return;
	}
	if (va < kheapPageAllocStart || va >= kheapPageAllocBreak || (va % PAGE_SIZE != 0))
	{
		release_kspinlock(&kheap_lock);
		return;
	}

	uint32 idx = (va - KHEAP_START_ADDR) / PAGE_SIZE;
	uint32 size = kheap_allocations[idx];

	if (size <= 1)
	{
		release_kspinlock(&kheap_lock);
		return;
	}

	uint32 num_pages = size / PAGE_SIZE;
	for (uint32 i = 0; i < num_pages; i++)
	{
		unmap_frame(ptr_page_directory, va + (i * PAGE_SIZE));
	}

	kheap_clear_pages(va, size);

	uint32 current_break_idx = (kheapPageAllocBreak - KHEAP_START_ADDR) / PAGE_SIZE;
	uint32 start_alloc_idx = (kheapPageAllocStart - KHEAP_START_ADDR) / PAGE_SIZE;

	uint32 free_count = 0;
	if (current_break_idx > start_alloc_idx)
	{
		uint32 i = current_break_idx - 1;
		while (i >= start_alloc_idx && kheap_allocations[i] == 0)
		{
			free_count++;
			if (i == 0)
				break;
			i--;
		}
	}

	if (free_count > 0)
	{
		kheapPageAllocBreak -= (free_count * PAGE_SIZE);
	}

	release_kspinlock(&kheap_lock);
}

//=================================
// [3] FIND VA OF GIVEN PA:
//=================================
unsigned int kheap_virtual_address(unsigned int physical_address)
{
	acquire_kspinlock(&kheap_lock);

	// TODO: [PROJECT'25.GM#2] KERNEL HEAP - #3 kheap_virtual_address
	// Your code is here
	if (physical_address == 0)
	{
		release_kspinlock(&kheap_lock);
		return 0;
	}

	uint32 offset = physical_address & 0xFFF;
	struct FrameInfo *ptr_frame_info = to_frame_info(physical_address);

	if (ptr_frame_info == NULL || ptr_frame_info->va == 0)
	{
		release_kspinlock(&kheap_lock);
		return 0;
	}

	uint32 va = ptr_frame_info->va + offset;
	release_kspinlock(&kheap_lock);
	return va;
	// Comment the following line
	//  panic("kheap_virtual_address() is not implemented yet...!!");

	/*EFFICIENT IMPLEMENTATION ~O(1) IS REQUIRED */
}

//=================================
// [4] FIND PA OF GIVEN VA:
//=================================
unsigned int kheap_physical_address(unsigned int virtual_address)
{
	acquire_kspinlock(&kheap_lock);

	// TODO: [PROJECT'25.GM#2] KERNEL HEAP - #4 kheap_physical_address
	// Your code is here
	if (virtual_address < KERNEL_HEAP_START || virtual_address >= KERNEL_HEAP_MAX)
	{
		release_kspinlock(&kheap_lock);
		return 0;
	}

	uint32 *ptr_page_table = NULL;
	get_page_table(ptr_page_directory, virtual_address, &ptr_page_table);

	if (ptr_page_table == NULL)
	{
		release_kspinlock(&kheap_lock);
		return 0;
	}

	uint32 pte = ptr_page_table[PTX(virtual_address)];
	if (pte == 0)
	{
		release_kspinlock(&kheap_lock);
		return 0;
	}

	uint32 page_offset = virtual_address & 0xFFF;
	uint32 frame_number = pte & 0xFFFFF000;

	uint32 pa = frame_number | page_offset;
	release_kspinlock(&kheap_lock);
	return pa;
	// Comment the following line
	//  panic("kheap_physical_address() is not implemented yet...!!");

	/*EFFICIENT IMPLEMENTATION ~O(1) IS REQUIRED */
}

//=================================================================================//
//============================== BONUS FUNCTION ===================================//
//=================================================================================//

extern __inline__ uint32 get_block_size(void *va);

void *krealloc(void *virtual_address, uint32 new_size)
{
	// //TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - krealloc
	// //Your code is here
	// /*
	// 	Notes:
	// 		1. If we recieve va = NULL, call kmalloc
	// 		2. If we recieve size = 0, call kfree
	// 		3. if the size is smaller than the one we have allocated, we free the rest.
	// 		4. if its bigger, we try to expand the virtual address, if we cant we move the info and free the old va
	// 		5. return null if failed
	// 		6. return va if success
	// */

	// if (virtual_address == NULL)
	// {
	// 	uint32 va = kmalloc(new_size);
	// 	return va;
	// }
	// else if (new_size == 0)
	// {
	// 	kfree(virtual_address);
	// 	return;
	// }
	// else if (new_size <= DYN_ALLOC_MAX_SIZE)
	// {
	// 	uint32 va = alloc_block(new_size);
	// 	kfree(virtual_address);
	// 	return va;
	// }

	// uint32 rounded_size = ROUNDUP(new_size, PAGE_SIZE);
	// uint32 needed_pages =rounded_size / PAGE_SIZE;

	// uint32 start_ptr = (kheapPageAllocStart - KHEAP_START_ADDR) / PAGE_SIZE;
	// uint32 break_ptr = (kheapPageAllocBreak - KHEAP_START_ADDR) / PAGE_SIZE;

	// uint32 current_hole_start_idx = -1;
	// uint32 current_hole_size = 0;

	// uint32 worst_fit_idx = -1;
	// uint32 worst_fit_size = 0;

	// uint32 found_va = 0;

	// Comment the following line
	panic("krealloc() is not implemented yet...!!");
}
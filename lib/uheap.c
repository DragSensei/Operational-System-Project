#include <inc/lib.h>
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
struct UserHeapAlloc {
	uint32 va;
	uint32 size;
};
#define MAX_UHEAP_ALLOCS 10000
struct UserHeapAlloc uheap_allocs[MAX_UHEAP_ALLOCS];
int uheap_alloc_count = 0;

uint32 BLK_ALLOC_LIMIT = USER_HEAP_START + DYN_ALLOC_MAX_SIZE;
int __firstTimeFlag = 1;
void uheap_init()
{
	if(__firstTimeFlag)
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
		uheapPlaceStrategy = sys_get_uheap_strategy();
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
		uheapPageAllocBreak = uheapPageAllocStart;

		__firstTimeFlag = 0;
	}
}

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
	if (ret < 0)
		panic("get_page() in user: failed to allocate page from the kernel");
	return 0;
}

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
	if (ret < 0)
		panic("return_page() in user: failed to return a page to the kernel");
}

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
	//==============================================================
	//==============================================================
	uheap_init();
	if (size == 0) return NULL ;
	//==============================================================
	//==============================================================

	if (size > DYN_ALLOC_MAX_BLOCK_SIZE) {
		uint32 rounded_size = ROUNDUP(size, PAGE_SIZE); uint32 num_of_pages = rounded_size / PAGE_SIZE;
		uint32 str_ptr = BLK_ALLOC_LIMIT + PAGE_SIZE;
		uint32 end_ptr = USER_HEAP_MAX;
		uint32 found_va = 0; uint32 counter = 0;

		for (uint32 i = str_ptr; i < end_ptr; i += PAGE_SIZE) 
		{
			if ((vpd[PDX(i)] & PERM_PRESENT) == 0) 
			{
				if (counter == 0) 
					found_va = i;
				counter++;
			}
			else
			{
				if ((vpt[VPN(i)] & (PERM_PRESENT | PERM_AVAILABLE)) == 0) 
				{
					if (counter == 0)
						found_va = i;
					counter++;
				}
				else 
				{
					counter = 0;
					found_va = 0;
				}
			}
			if (counter == num_of_pages)
				break;
		}

		if (counter < num_of_pages) 
		{
			return NULL;
		}

		sys_allocate_user_mem(found_va, rounded_size);

		if (uheap_alloc_count < MAX_UHEAP_ALLOCS) {
			uheap_allocs[uheap_alloc_count].va = found_va;
			uheap_allocs[uheap_alloc_count].size = rounded_size;
			uheap_alloc_count++;
		}

		if (found_va + rounded_size > uheapPageAllocBreak)
		{
			uheapPageAllocBreak = found_va + rounded_size;
		}
		return (void*) found_va;
		
	}
	else {
		return (void*) alloc_block(size);
	}
	return NULL;
	//Comment the following line
	// panic("malloc() is not implemented yet...!!");
}

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
	//==================================================================================//
	//============================== GIVEN FUNCTIONS ===================================//
	//==================================================================================//
	if (virtual_address == NULL)
	{
		return;
	}

	// Zone 1: The Block Allocator (Small Allocations)
	if ((uint32)virtual_address >= USER_HEAP_START && (uint32)virtual_address < USER_HEAP_START + DYN_ALLOC_MAX_SIZE)
	{
		free_block(virtual_address);
		return;
	}
	// Zone 2: The Page Allocator (Large Allocations)
	else if ((uint32)virtual_address >= USER_HEAP_START + DYN_ALLOC_MAX_SIZE && (uint32)virtual_address < USER_HEAP_MAX)
	{
		uint32 size = 0;
		int found_idx = -1;
		for (int i = 0; i < uheap_alloc_count; i++) {
			if (uheap_allocs[i].va == (uint32)virtual_address) {
				size = uheap_allocs[i].size;
				found_idx = i;
				break;
			}
		}

		if (found_idx != -1) {
			uheap_allocs[found_idx] = uheap_allocs[uheap_alloc_count - 1];
			uheap_alloc_count--;
			sys_free_user_mem((uint32)virtual_address, size);
		} else {
			return;
		}
	}
	// Zone 3: Invalid
	else
	{
		panic("Invalid free address");
	}
}

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
	if (size == 0) return NULL ;
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
}

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
}


//==================================================================================//
//============================== BONUS FUNCTIONS ===================================//
//==================================================================================//


//=================================
// REALLOC USER SPACE:
//=================================
//	Attempts to resize the allocated space at "virtual_address" to "new_size" bytes,
//	possibly moving it in the heap.
//	If successful, returns the new virtual_address, in which case the old virtual_address must no longer be accessed.
//	On failure, returns a null pointer, and the old virtual_address remains valid.

//	A call with virtual_address = null is equivalent to malloc().
//	A call with new_size = zero is equivalent to free().

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
	//==============================================================
	panic("realloc() is not implemented yet...!!");
}


//=================================
// FREE SHARED VARIABLE:
//=================================
//	This function frees the shared variable at the given virtual_address
//	To do this, we need to switch to the kernel, free the pages AND "EMPTY" PAGE TABLES
//	from main memory then switch back to the user again.
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");

	//	1) you should find the ID of the shared variable at the given address
	//	2) you need to call sys_freeSharedObject()
}


//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

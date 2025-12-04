#include <inc/lib.h>
#define UHEAP_PAGES ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)
//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

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

int get_page(void* va)
{
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
	if (ret < 0)
		panic("get_page() in user: failed to allocate page from the kernel");
		return 0;
}
	
void return_page(void* va)
{
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
	if (ret < 0)
	panic("return_page() in user: failed to return a page to the kernel");
}
	
//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
// struct FREE_SIZE_OF_PAGES 
// {
// 	uint32 curr_hole_va;
// 	uint32 curr_hole_size;
// 	uint32 worst_fit_addr;
// 	uint32 worst_fit_size;
// 	int hole;
// };

// struct PageAlloc {
// 	uint32 va;
// 	uint32 size;
// 	struct PageAlloc *next;
// };
// struct PageAlloc *alloc_list = NULL;

uint32 allocations[UHEAP_PAGES];

uint32 oldAllocBreak = 0; // for the free function

uint32 is_user_page_free(void* va)
{
	uint32 index = ((uint32)va - USER_HEAP_START) / PAGE_SIZE;
	if (allocations[index] == 0)
		return 1;
	return 0;
}

void ARRAY_ADD(uint32 va, uint32 size)
{
	uint32 index = (va - USER_HEAP_START) / PAGE_SIZE;
	allocations[index] = size;
	MARK_INDEX_BUSY(size / PAGE_SIZE, index);
}

void MARK_INDEX_BUSY(uint32 num_pages, uint32 index)
{
	for (int i = 1; i < num_pages; i++)
	{
		allocations[index + i] = 1;
	}
}

void MARK_INDEX_FREE(uint32 num_pages, uint32 index)
{
	for (int i = 0; i < num_pages; i++)
	{
		allocations[index + i] = 0;
	}
}


void* CUSTOM_FIT_STRAT(struct FREE_SIZE_OF_PAGES* info, uint32 str_ptr, uint32 end_ptr, uint32 num_pages, uint32 rounded_size)
{
	for (uint32 i = str_ptr; i < end_ptr; i += PAGE_SIZE)
	{
		if (is_user_page_free((void*)i))
		{
			if (!info->hole)
			{
				info->curr_hole_va = i;
				info->curr_hole_size = 0;
				info->hole = 1;
			}
			info->curr_hole_size++;
		}
		else
		{
			if (info->hole)
			{
				if (info->curr_hole_size == num_pages)
				{
					// cprintf("ANA FEL if (info.hole)\n");

					ARRAY_ADD(info->curr_hole_va, rounded_size);
					return (void*) info->curr_hole_va;
				}
				if (info->curr_hole_size > num_pages)
				{
					if (info->curr_hole_size > info->worst_fit_size)
					{
						info->worst_fit_size = info->curr_hole_size;
						info->worst_fit_addr = info->curr_hole_va;
					}
				}

				info->hole = 0;
				info->curr_hole_size = 0;
			}
		}
	}

	return NULL;
}
//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
	
	uheap_init();
	if (size == 0) return NULL;

	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
	{
		// cprintf("ANA HENAAAAAAAAAA 1\n");
		return alloc_block(size);
	}

	// Page Allocator Logic
	uint32 rounded_size = ROUNDUP(size, PAGE_SIZE);
	uint32 num_pages = rounded_size / PAGE_SIZE;
	uint32 str_ptr = uheapPageAllocStart, end_ptr = uheapPageAllocBreak;
	uint32 limit = USER_HEAP_MAX;

	struct FREE_SIZE_OF_PAGES info;
	info.curr_hole_size = 0;
	info.curr_hole_va = 0;
	info.worst_fit_size = 0;
	info.worst_fit_addr = 0;
	info.hole = 0;

	void* allocated_address = CUSTOM_FIT_STRAT(&info, str_ptr, end_ptr, num_pages, rounded_size);

	if (allocated_address != NULL)
	{
		sys_allocate_user_mem((uint32)allocated_address, rounded_size);
		return allocated_address;
	}

	if (info.curr_hole_size == num_pages)
	{
		// cprintf("ANA FEL (info.curr_hole_size == num_pages)\n");

		ARRAY_ADD(info.curr_hole_va, rounded_size);

		sys_allocate_user_mem((uint32) info.curr_hole_va, rounded_size);
		return (void*) info.curr_hole_va;	
	}
	if (info.curr_hole_size > info.worst_fit_size)
	{
		info.worst_fit_size = info.curr_hole_size;
		info.worst_fit_addr = info.curr_hole_va;
	}
	if (info.worst_fit_addr != 0)
	{
		// cprintf("ANA FEL (info.curr_hole_size == num_pages)\n");

		ARRAY_ADD(info.worst_fit_addr, rounded_size);

		sys_allocate_user_mem((uint32) info.worst_fit_addr, rounded_size);
		return (void*) info.worst_fit_addr;	
	}
	if ((limit - end_ptr) >= rounded_size) // 
	{
		uint32 extend_block = end_ptr;
		uheapPageAllocBreak += rounded_size;


		ARRAY_ADD(extend_block, rounded_size);

		sys_allocate_user_mem(extend_block, rounded_size);
		return (void*) extend_block;	
	}

	return NULL;
}

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
	uheap_init();
	uint32 va = (uint32) virtual_address;
	if (virtual_address == NULL) return;
	else if (va > USER_HEAP_MAX || va < USER_HEAP_START) return;
	else if (is_user_page_free(virtual_address)) return;
	else if (va >= USER_HEAP_START && va < dynAllocEnd)
	{
		free_block(virtual_address);
		return;
	}

	// uint32 rounded_size = curr->size;
	int index = (va - USER_HEAP_START) / PAGE_SIZE;
	uint32 size = allocations[index];

	MARK_INDEX_FREE((allocations[index] / PAGE_SIZE), index);
	if (size == 0) return;

	if (uheapPageAllocBreak == (va + size))
	{
		uheapPageAllocBreak = va;
		// cprintf("break is being shrunk!!\n");

		while (uheapPageAllocBreak > uheapPageAllocStart && is_user_page_free((void*)(uheapPageAllocBreak - PAGE_SIZE))) 
		{
			uheapPageAllocBreak -= PAGE_SIZE;
			// if (uheapPageAllocBreak == oldAllocBreak) break;
		}
	}

	sys_free_user_mem(va, size);

}

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
	uheap_init();
	uint32 rounded_size = ROUNDUP(size, PAGE_SIZE);
	uint32 num_pages = rounded_size / PAGE_SIZE;
	uint32 str_ptr = uheapPageAllocStart, end_ptr = uheapPageAllocBreak;
	uint32 limit = USER_HEAP_MAX;

	struct FREE_SIZE_OF_PAGES info;
	info.curr_hole_size = 0;
	info.curr_hole_va = 0;
	info.worst_fit_size = 0;
	info.worst_fit_addr = 0;
	info.hole = 0;

	void* allocated_address = CUSTOM_FIT_STRAT(&info, str_ptr, end_ptr, num_pages, rounded_size);
	if (allocated_address != NULL)
	{
		uint32 ret = sys_create_shared_object(sharedVarName, rounded_size, isWritable, allocated_address);
		if(ret== E_NO_SHARE || ret == E_SHARED_MEM_EXISTS){
			return NULL;
		}
		return allocated_address;
	}

	if (info.curr_hole_size == num_pages)
	{
		// cprintf("ANA FEL (info.curr_hole_size == num_pages)\n");

		ARRAY_ADD(info.curr_hole_va, rounded_size);

		uint32 ret = sys_create_shared_object(sharedVarName, rounded_size, isWritable, (uint32) info.curr_hole_va);
		if(ret== E_NO_SHARE || ret == E_SHARED_MEM_EXISTS){
			return NULL;
		}
		return (void*) info.curr_hole_va;	
	}
	if (info.curr_hole_size > info.worst_fit_size)
	{
		info.worst_fit_size = info.curr_hole_size;
		info.worst_fit_addr = info.curr_hole_va;
	}
	if (info.worst_fit_addr != 0)
	{
		// cprintf("ANA FEL (info.curr_hole_size == num_pages)\n");

		ARRAY_ADD(info.worst_fit_addr, rounded_size);
		
		uint32 ret = sys_create_shared_object(sharedVarName, rounded_size, isWritable, (uint32) info.worst_fit_addr);
		if(ret== E_NO_SHARE || ret == E_SHARED_MEM_EXISTS){
			return NULL;
		}
		return (void*) info.worst_fit_addr;	
	}
	if ((limit - end_ptr) >= rounded_size) // 
	{
		uint32 extend_block = end_ptr;
		uheapPageAllocBreak += rounded_size;


		ARRAY_ADD(extend_block, rounded_size);
		
			uint32 ret = sys_create_shared_object(sharedVarName, rounded_size, isWritable, (uint32) extend_block);
		if(ret== E_NO_SHARE || ret == E_SHARED_MEM_EXISTS){
			return NULL;
		}
		return (void*) extend_block;	
	}
	// panic("smalloc() is not implemented yet...!!");
	cprintf("Returning Null!\n");
	return NULL;
}

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
	uheap_init();
	uint32 size = sys_size_of_shared_object(ownerEnvID, sharedVarName);
	if (size == E_SHARED_MEM_NOT_EXISTS) return NULL;
	uint32 rounded_size = ROUNDUP(size, PAGE_SIZE);
	uint32 num_pages = rounded_size / PAGE_SIZE;
	uint32 str_ptr = uheapPageAllocStart, end_ptr = uheapPageAllocBreak;
	uint32 limit = USER_HEAP_MAX;

	struct FREE_SIZE_OF_PAGES info;
	info.curr_hole_size = 0;
	info.curr_hole_va = 0;
	info.worst_fit_size = 0;
	info.worst_fit_addr = 0;
	info.hole = 0;

	void* allocated_address = CUSTOM_FIT_STRAT(&info, str_ptr, end_ptr, num_pages, rounded_size);
	if (allocated_address != NULL)
	{
		uint32 ret = sys_get_shared_object(ownerEnvID, sharedVarName, allocated_address);
		if(ret == E_SHARED_MEM_EXISTS){
			return NULL;
		}
		return allocated_address;
	}

	if (info.curr_hole_size == num_pages)
	{
		// cprintf("ANA FEL (info.curr_hole_size == num_pages)\n");

		ARRAY_ADD(info.curr_hole_va, rounded_size);

		uint32 ret = sys_get_shared_object(ownerEnvID, sharedVarName, (uint32) info.curr_hole_va);
		if(ret == E_SHARED_MEM_EXISTS){
			return NULL;
		}

		return (void*) info.curr_hole_va;	
	}
	if (info.curr_hole_size > info.worst_fit_size)
	{
		info.worst_fit_size = info.curr_hole_size;
		info.worst_fit_addr = info.curr_hole_va;
	}
	if (info.worst_fit_addr != 0)
	{
		// cprintf("ANA FEL (info.curr_hole_size == num_pages)\n");

		ARRAY_ADD(info.worst_fit_addr, rounded_size);
		
		uint32 ret = sys_get_shared_object(ownerEnvID, sharedVarName, (uint32) info.worst_fit_addr);
		if(ret == E_SHARED_MEM_EXISTS){
			return NULL;
		}
		return (void*) info.worst_fit_addr;	
	}
	if ((limit - end_ptr) >= rounded_size) // 
	{
		uint32 extend_block = end_ptr;
		uheapPageAllocBreak += rounded_size;


		ARRAY_ADD(extend_block, rounded_size);
		
			uint32 ret = sys_get_shared_object(ownerEnvID, sharedVarName, (uint32) extend_block);
		if(ret == E_SHARED_MEM_EXISTS){
			return NULL;
		}
		return (void*) extend_block;	
	}
	// panic("smalloc() is not implemented yet...!!");
	cprintf("Returning Null!\n");
	return NULL;
}

//=================================
// REALLOC USER SPACE:
//=================================
//Attempts to resize the allocated space at "virtual_address" to "new_size" bytes,
//possibly moving it in the heap.
//If successful, returns the new virtual_address, in which case the old virtual_address must no longer be accessed.
//On failure, returns a null pointer, and the old virtual_address remains valid.
//A call with virtual_address = null is equivalent to malloc().
//A call with new_size = zero is equivalent to free().
// Hint: you may need to use the sys_move_user_mem(...)
//which switches to the kernel mode, calls move_user_mem(...)
//in "kern/mem/chunk_operations.c", then switch back to the user mode here
//the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size){
    uheap_init();
    panic("realloc() is not implemented yet...!!");
}
//=================================
// FREE SHARED VARIABLE:
//=================================
//    This function frees the shared variable at the given virtual_address
//    To do this, we need to switch to the kernel, free the pages AND "EMPTY" PAGE TABLES
//    from main memory then switch back to the user again.
//
//    use sys_delete_shared_object(...); which switches to the kernel mode,
//    calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//    the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address){
    //TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
    //Your code is here
    //Comment the following line
    panic("sfree() is not implemented yet...!!");
    //1) you should find the ID of the shared variable at the given address
    //2) you need to call sys_freeSharedObject()
}
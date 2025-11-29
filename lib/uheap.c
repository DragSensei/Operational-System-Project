#include <inc/lib.h>

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
struct FREE_SIZE_OF_PAGES 
{
	uint32 curr_hole_va;
	uint32 curr_hole_size;
	uint32 worst_fit_addr;
	uint32 worst_fit_size;
	int hole;
};

struct PageAlloc {
	uint32 va;
	uint32 size;
	struct PageAlloc *next;
};
struct PageAlloc *page_alloc_list = NULL;

uint32 oldAllocBreak = 0; // for the free function


int is_page_free(void *va)
{
	struct PageAlloc *ptr = page_alloc_list;
	while (ptr != NULL)
	{
		uint32 start_va = ptr->va;
		uint32 end_va = ptr->size + ptr->va;

		if ((uint32*)va >= (uint32*)start_va && (uint32*)va < (uint32*)end_va )
		{
			return 0;
		}
		
		ptr = ptr->next;
	}
	
	return 1;
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

	uint32 str_ptr = uheapPageAllocStart, end_ptr = uheapPageAllocBreak, oldAllocBreak = end_ptr;
	uint32 limit = USER_HEAP_MAX;
	uint32 counter = 0;
	struct FREE_SIZE_OF_PAGES info;
	info.curr_hole_size = 0;
	info.curr_hole_va = 0;
	info.worst_fit_size = 0;
	info.worst_fit_addr = 0;
	info.hole = 0;

	for (uint32 i = str_ptr; i < end_ptr; i += PAGE_SIZE)
	{
		if (is_page_free((void*)i))
		{
			if (!info.hole)
			{
				info.curr_hole_va = i;
				info.curr_hole_size = 0;
				info.hole = 1;
			}
			info.curr_hole_size++;
		}
		else
		{
			if (info.hole)
			{
				if (info.curr_hole_size == num_pages)
				{
					// cprintf("ANA FEL if (info.hole)\n");
					struct PageAlloc* alloc_page = alloc_block(sizeof(struct PageAlloc));
					if (!alloc_page) return NULL;

					alloc_page->va = info.curr_hole_va;
					alloc_page->size = rounded_size;
					alloc_page->next = page_alloc_list;
					page_alloc_list = alloc_page;

					sys_allocate_user_mem(info.curr_hole_va, rounded_size);
					return (void*) info.curr_hole_va;
				}
				if (info.curr_hole_size > num_pages)
				{
					if (info.curr_hole_size > info.worst_fit_size)
					{
						info.worst_fit_size = info.curr_hole_size;
						info.worst_fit_addr = info.curr_hole_va;
					}
				}

				info.hole = 0;
				info.curr_hole_size = 0;
			}
		}
	}

	if (info.curr_hole_size == num_pages)
	{
		// cprintf("ANA FEL (info.curr_hole_size == num_pages)\n");

		struct PageAlloc* alloc_page = alloc_block(sizeof(struct PageAlloc));
		if (!alloc_page) return NULL;

		alloc_page->va = info.curr_hole_va;
		alloc_page->size = rounded_size;
		alloc_page->next = page_alloc_list;
		page_alloc_list = alloc_page;

		sys_allocate_user_mem(info.curr_hole_va, rounded_size);
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
		struct PageAlloc* alloc_page = alloc_block(sizeof(struct PageAlloc));
		if (!alloc_page) return NULL;

		alloc_page->va = info.worst_fit_addr;
		alloc_page->size = rounded_size;
		alloc_page->next = page_alloc_list;
		page_alloc_list = alloc_page;

		sys_allocate_user_mem(info.worst_fit_addr, rounded_size);
		return (void*) info.worst_fit_addr;	
	}
	if (end_ptr + rounded_size < limit)
	{
		uint32 extend_block = end_ptr;
		uheapPageAllocBreak += rounded_size;

		// cprintf("ANA FEL (end_ptr + rounded_size < limit)\n");
		struct PageAlloc* alloc_page = alloc_block(sizeof(struct PageAlloc));
		if (!alloc_page) return NULL;

		alloc_page->va = extend_block;
		alloc_page->size = rounded_size;
		alloc_page->next = page_alloc_list;
		page_alloc_list = alloc_page;

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
	if (virtual_address == NULL) return;
	else if (virtual_address > USER_HEAP_MAX || virtual_address < USER_HEAP_START) return;
	else if (virtual_address >= USER_HEAP_START && virtual_address < dynAllocEnd) 
	{
		free_block(virtual_address);
		return;
	}

	struct PageAlloc *prev = NULL, *curr = page_alloc_list;
	
	while (curr != NULL && curr->va != (uint32)virtual_address)
	{
		prev = curr;
		curr = curr->next;
	}

	if (curr == NULL)
	{
		return;
	}

	if (prev == NULL)
	{
		page_alloc_list = curr->next;
	}
	else
	{
		prev->next = curr->next;
	}

	uint32 rounded_size = curr->size;
	if (uheapPageAllocBreak == (curr->va + curr->size))
	{
		uheapPageAllocBreak = curr->va;
		cprintf("break is being shrunk!!\n");

		while (uheapPageAllocBreak > USER_HEAP_START && is_page_free((void*)(uheapPageAllocBreak - PAGE_SIZE))) uheapPageAllocBreak -= PAGE_SIZE;
	}
	sys_free_user_mem(curr->va, rounded_size);

	free_block(curr);
}

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
	panic("smalloc() is not implemented yet...!!");
	return NULL;
}

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
	panic("sget() is not implemented yet...!!");
	return NULL;
}

void *realloc(void *virtual_address, uint32 new_size)
{
	panic("realloc() is not implemented yet...!!");
	return NULL;
}

void sfree(void* virtual_address)
{
	panic("sfree() is not implemented yet...!!");
}
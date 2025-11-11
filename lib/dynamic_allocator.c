/*
 * dynamic_allocator.c
 *
 *  Created on: Sep 21, 2023
 *      Author: HP
 */
#include <inc/assert.h>
#include <inc/string.h>
#include "../inc/dynamic_allocator.h"

//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
}



//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
		is_initialized = 1;
	}
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	dynAllocStart = daStart; dynAllocEnd = daEnd;
	uint32 TotalPages = (daEnd - daStart) / PAGE_SIZE;
	
	for (int i = 0; i <= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++) {
		LIST_INIT(&freeBlockLists[i]);
	}

	LIST_INIT(&freePagesList);
	for (int i = get_index(dynAllocStart); i < get_index(dynAllocEnd); i++) {
		pageBlockInfoArr[i].block_size = 0;
		pageBlockInfoArr[i].num_of_free_blocks = 0;
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}

	//Comment the following line
	// panic("initialize_dynamic_allocator() Not implemented yet");

}

int get_index(void* va) {
	int index = ROUNDDOWN(va, PAGE_SIZE) - dynAllocStart;
	index = index >> PGSHIFT;
	return index;
}

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	struct PageInfoElement ptrPageInfo = pageBlockInfoArr[get_index((uint32)va)];


	return ptrPageInfo.block_size;
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}

//===========================
// 3) ALLOCATE BLOCK:
//===========================

int log2(int number) {
    if (number <= 1) return 0;
    uint32 a = 0;
    number--;
    while (number > 0) {
        number >>= 1;
        a++;
    }
    return a;
}

void *alloc_block(uint32 size) // 9.5 --> 16 2^4
{
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
	}

	if (!size) return NULL;
	
	int index = log2(MAX(size, DYN_ALLOC_MIN_BLOCK_SIZE)) - LOG2_MIN_SIZE;
	int blockSize = 1 << log2(MAX(size, DYN_ALLOC_MIN_BLOCK_SIZE));
	
	if (!LIST_EMPTY(&freeBlockLists[index])) {
		struct BlockElement* ptrBlock = LIST_FIRST(&freeBlockLists[index]);
		LIST_REMOVE(&freeBlockLists[index], ptrBlock);

		int tmp = get_index(ptrBlock);
		pageBlockInfoArr[tmp].num_of_free_blocks--;
		return ptrBlock;
	}
	else if (!LIST_EMPTY(&freePagesList)) {
		struct PageInfoElement* ptrPage = LIST_FIRST(&freePagesList);
		LIST_REMOVE(&freePagesList, ptrPage);

		get_page(to_page_va(ptrPage));

		ptrPage->block_size = blockSize;
		ptrPage->num_of_free_blocks =(PAGE_SIZE / blockSize) - 1;
		
		uint32 pageAddress = to_page_va(ptrPage);
		for (int i = 1; i < (PAGE_SIZE / blockSize); i++) {
			struct BlockElement* ptrBlock =  
				(struct BlockElement*)(pageAddress + (i* blockSize));
			LIST_INSERT_TAIL(&freeBlockLists[index], ptrBlock);
		}

		return pageAddress;
	}


	while (LIST_EMPTY(&freeBlockLists[index]) && index <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE)) {
		index++;
	}
	if (index > (LOG2_MAX_SIZE - LOG2_MIN_SIZE))
		panic("No Free Blocks!");

	struct BlockElement* ptrBlock = LIST_FIRST(&freeBlockLists[index]);
	LIST_REMOVE(&freeBlockLists[index], ptrBlock);

	int tmp = get_index(ptrBlock);
	pageBlockInfoArr[tmp].num_of_free_blocks--;
	return ptrBlock;
}

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
	}
	//==================================================================================
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	int page_index = get_index(va);
	struct PageInfoElement* page_info = &pageBlockInfoArr[page_index];
	uint32 block_size = page_info->block_size;

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
    
	struct BlockElement* block_to_free = (struct BlockElement*)va;
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block_to_free);
	page_info->num_of_free_blocks++;

	uint32 total_blocks_on_page = PAGE_SIZE / block_size;
	if (page_info->num_of_free_blocks == total_blocks_on_page){
		uint32 page_va = to_page_va(page_info);
        for (int i = 0; i < total_blocks_on_page; i++){
			struct BlockElement* block_to_remove = (struct BlockElement*)(page_va + (i*block_size));
			LIST_REMOVE(&freeBlockLists[list_index], block_to_remove);	
		}
		return_page(page_va);
		LIST_INSERT_TAIL(&freePagesList, page_info);
		page_info->block_size = 0;
		page_info->num_of_free_blocks = 0;
	}

	//Comment the following line
	//panic("free_block() Not implemented yet");
}

//==================================================================================//
//============================== BONUS FUNCTIONS ===================================//
//==================================================================================//

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
}

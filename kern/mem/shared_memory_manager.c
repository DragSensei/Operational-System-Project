#include <inc/memlayout.h>
#include "shared_memory_manager.h"

#include <inc/mmu.h>
#include <inc/error.h>
#include <inc/string.h>
#include <inc/assert.h>
#include <inc/queue.h>
#include <inc/environment_definitions.h>

#include <kern/proc/user_environment.h>
#include <kern/trap/syscall.h>
#include "kheap.h"
#include "memory_manager.h"

//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

//===========================
// [1] INITIALIZE SHARES:
//===========================
// Initialize the list and the corresponding lock
void sharing_init()
{
#if USE_KHEAP
	LIST_INIT(&AllShares.shares_list);
	init_kspinlock(&AllShares.shareslock, "shares lock");
	// init_sleeplock(&AllShares.sharessleeplock, "shares sleep lock");
#else
	panic("not handled when KERN HEAP is disabled");
#endif
}

//=========================
// [2] Find Share Object:
//=========================
// Search for the given shared object in the "shares_list"
// Return:
//	a) if found: ptr to Share object
//	b) else: NULL
struct Share *find_share(int32 ownerID, char *name)
{
#if USE_KHEAP
	struct Share *ret = NULL;
	bool wasHeld = holding_kspinlock(&(AllShares.shareslock));
	if (!wasHeld)
	{
		acquire_kspinlock(&(AllShares.shareslock));
	}
	{
		struct Share *shr;
		LIST_FOREACH(shr, &(AllShares.shares_list))
		{
			// cprintf("shared var name = %s compared with %s\n", name, shr->name);
			if (shr->ownerID == ownerID && strcmp(name, shr->name) == 0)
			{
				// cprintf("%s found\n", name);
				ret = shr;
				break;
			}
		}
	}
	if (!wasHeld)
	{
		release_kspinlock(&(AllShares.shareslock));
	}
	return ret;
#else
	panic("not handled when KERN HEAP is disabled");
#endif
}

//==============================
// [3] Get Size of Share Object:
//==============================
int size_of_shared_object(int32 ownerID, char *shareName)
{
	// This function should return the size of the given shared object
	// RETURN:
	//	a) If found, return size of shared object
	//	b) Else, return E_SHARED_MEM_NOT_EXISTS
	//
	struct Share *ptr_share = find_share(ownerID, shareName);
	if (ptr_share == NULL)
		return E_SHARED_MEM_NOT_EXISTS;
	else
		return ptr_share->size;

	return 0;
}
//===========================================================

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

//=====================================
// [1] Alloc & Initialize Share Object:
//=====================================
// Allocates a new shared object and initialize its member
// It dynamically creates the "framesStorage"
// Return: allocatedObject (pointer to struct Share) passed by reference
struct Share *alloc_share(int32 ownerID, char *shareName, uint32 size, uint8 isWritable)
{
	// TODO: [PROJECT'25.IM#3] SHARED MEMORY - #1 alloc_share
	// Your code is here
	uint32 rounded_size = ROUNDUP(size, PAGE_SIZE);
	uint32 needed_pages = rounded_size / PAGE_SIZE;
#if USE_KHEAP
	struct Share *new_share = (struct Share *)kmalloc(sizeof(struct Share));

	if (new_share == NULL)
	{
		return NULL;
	}

	new_share->framesStorage = (struct FrameInfo **)kmalloc(needed_pages * sizeof(struct FrameTnfo *));

	if (new_share->framesStorage == NULL)
	{
		kfree(new_share);
		return NULL;
	}

	new_share->ownerID = ownerID;
	strcpy(new_share->name, shareName);
	new_share->size = rounded_size;
	new_share->isWritable = isWritable;
	new_share->ID = (uint32)new_share & 0x7FFFFFFF;
	new_share->references = 0;

	for (uint32 i = 0; i < needed_pages; i++)
	{
		new_share->framesStorage[i] = NULL;
	}

	return new_share;
#endif
	// Comment the following line
	panic("alloc_share() is not implemented yet...!!");
}

//=========================
// [4] Create Share Object:
//=========================
int create_shared_object(int32 ownerID, char *shareName, uint32 size, uint8 isWritable, void *virtual_address)
{
	// TODO: [PROJECT'25.IM#3] SHARED MEMORY - #3 create_shared_object
	// Your code is here
	struct Env *myenv = get_cpu_proc(); // The calling environment
#if USE_KHEAP
	struct Share *check_list = find_share(ownerID, shareName);
	if (check_list != NULL)
	{
		return E_SHARED_MEM_EXISTS;
	}
	struct Share *call_alloc = alloc_share(ownerID, shareName, size, isWritable);
	if (call_alloc == NULL)
	{
		return E_NO_SHARE;
	}
	acquire_kspinlock(&(AllShares.shareslock));
	LIST_INSERT_HEAD(&AllShares.shares_list, call_alloc);
	release_kspinlock(&(AllShares.shareslock));

	uint32 num_of_PagesNeeded = (ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE);

	for (int i = 0; i < num_of_PagesNeeded; i++)
	{
		// a. Allocate a new physical frame
		struct FrameInfo *framePtr = NULL;
		allocate_frame(&framePtr);

		uint32 va = ((uint32)virtual_address + (i * PAGE_SIZE));

		map_frame(myenv->env_page_directory, framePtr, va, PERM_WRITEABLE | PERM_UHPAGE | PERM_USER);
		call_alloc->framesStorage[i] = framePtr;
		// the bellow comm i didn't do yet!
		//  e. ERROR HANDLING (Bonus/Robustness):
		//     If allocate_frame or map_frame fails in the middle of the loop,
		//     you should technically free everything you just did and return E_NO_MEM.
	}

	return call_alloc->ID;
#endif
	// Comment the following line
	panic("create_shared_object() is not implemented yet...!!");

	// This function should create the shared object at the given virtual address with the given size
	// and return the ShareObjectID
	// RETURN:
	//	a) ID of the shared object (its VA after masking out its msb) if success
	//	b) E_SHARED_MEM_EXISTS if the shared object already exists
	//	c) E_NO_SHARE if failed to create a shared object
}

//======================
// [5] Get Share Object:
//======================
int get_shared_object(int32 ownerID, char *shareName, void *virtual_address)
{
	// TODO: [PROJECT'25.IM#3] SHARED MEMORY - #5 get_shared_object
	// Your code is here
	struct Env *myenv = get_cpu_proc(); // The calling environment
#if USE_KHEAP
	struct Share *get_obj = find_share(ownerID, shareName);
	if (get_obj == NULL)
	{

		return E_SHARED_MEM_NOT_EXISTS;
	}

	uint32 num_PagesNeeded = (ROUNDUP(get_obj->size, PAGE_SIZE) / PAGE_SIZE);

	for (int i = 0; i < num_PagesNeeded; i++)
	{
		struct FrameInfo *ptr_get = get_obj->framesStorage[i];
		uint32 va = ((uint32)virtual_address + (i * PAGE_SIZE));

		if (get_obj->isWritable)
		{
			map_frame(myenv->env_page_directory, ptr_get, va, PERM_USER | PERM_UHPAGE | PERM_WRITEABLE);
		}
		else
		{
			map_frame(myenv->env_page_directory, ptr_get, va, PERM_USER | PERM_UHPAGE);
		}
	}

	acquire_kspinlock(&(AllShares.shareslock));
	get_obj->references++;
	release_kspinlock(&(AllShares.shareslock));

	return get_obj->ID;
#endif
	// Comment the following line
	panic("get_shared_object() is not implemented yet...!!");
	//  	This function should share the required object in the heap of the current environment
	//	starting from the given virtual_address with the specified permissions of the object: read_only/writable
	//  	and return the ShareObjectID
	//  RETURN:
	//	a) ID of the shared object (its VA after masking out its msb) if success
	//	b) E_SHARED_MEM_NOT_EXISTS if the shared object is not exists
}
//==================================================================================//
//============================== BONUS FUNCTIONS ===================================//
//==================================================================================//
//=========================
// [1] Delete Share Object:
//=========================
// delete the given shared object from the "shares_list"
// it should free its framesStorage and the share object itself
void free_share(struct Share *ptrShare)
{
// TODO: [PROJECT'25.BONUS#5] EXIT #2 - free_share
// Your code is here
#if USE_KHEAP
	acquire_kspinlock(&(AllShares.shareslock));
	LIST_REMOVE(&AllShares.shares_list, ptrShare);
	release_kspinlock(&(AllShares.shareslock));
	if (ptrShare->framesStorage != NULL)
	{
		int num_pages = ROUNDUP(ptrShare->size, PAGE_SIZE) / PAGE_SIZE;
		for (int i = 0; i < num_pages; i++)
		{
		    struct FrameInfo *frame = ptrShare->framesStorage[i];
		    if (frame != NULL)
		    {
		        // Decrease reference / Free the frame
		        free_frame(frame);
		    }
		}
		kfree(ptrShare->framesStorage);
	}
	kfree(ptrShare);
	tlbflush();
#endif
	// Comment the following line
	// panic("free_share() is not implemented yet...!!");
}

//=========================
// [2] Free Share Object:
//=========================
int delete_shared_object(int32 sharedObjectID, void *startVA)
{
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - delete_shared_object
	//Your code is here
	#if USE_KHEAP
	struct Env* myenv = get_cpu_proc(); //The calling environment
	acquire_kspinlock(&(AllShares.shareslock));
	struct Share* ptr = NULL;
	struct Share* t = NULL;
	LIST_FOREACH(ptr, &(AllShares.shares_list)){
		if(t->ID == sharedObjectID){
			ptr = t;
			break;
		}

	}

	release_kspinlock(&(AllShares.shareslock));

	if(ptr == NULL){
		return E_SHARED_MEM_NOT_EXISTS;
	}

	uint32 num_PagesNeeded = (ROUNDUP(ptr->size, PAGE_SIZE) / PAGE_SIZE);
	for(int i = 0; i < num_PagesNeeded; i++){
		uint32 *ptr_table = NULL;
		uint32 va = (uint32) startVA + (i * PAGE_SIZE);

		unmap_frame(myenv->env_page_directory, va);
		get_page_table(myenv->env_page_directory, va, &ptr_table);
		if(ptr_table != NULL){
			uint32 is_empty = 1;
            pt_clear_page_table_entry(myenv->env_page_directory, va);

			for(int l = 0; l < 1024; l++){
				uint32 *pt = NULL;
				uint32 perm = ptr_table[l] & 0x00000FFF;
				if(perm & PERM_PRESENT){
					is_empty = 0;
					break;
				}
			}

			if(is_empty){
				pd_clear_page_dir_entry(myenv->env_page_directory, va);
				kfree(ptr_table);
			}
		}
	}

	acquire_kspinlock(&(AllShares.shareslock));
	ptr->references--;
	release_kspinlock(&(AllShares.shareslock));

	if(ptr->references == 0){
		free_share(ptr);
		return 0;
	}

	tlbflush();
	return 0;
	#endif
	//Comment the following line
	panic("delete_shared_object() is not implemented yet...!!");

	// This function should free (delete) the shared object from the User Heapof the current environment
	// If this is the last shared env, then the "frames_store" should be cleared and the shared object should be deleted
	// RETURN:
	//	a) 0 if success
	//	b) E_SHARED_MEM_NOT_EXISTS if the shared object is not exists

	// Steps:
	//	1) Get the shared object from the "shares" array (use get_share_object_ID())
	//	2) Unmap it from the current environment "myenv"
	//	3) If one or more table becomes empty, remove it
	//	4) Update references
	//	5) If this is the last share, delete the share object (use free_share())
	//	6) Flush the cache "tlbflush()"

}

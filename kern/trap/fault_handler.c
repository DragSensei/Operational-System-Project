/*
 * fault_handler.c
 *
 *  Created on: Oct 12, 2022
 *      Author: HP
 */

#include "trap.h"
#include <kern/proc/user_environment.h>
#include <kern/cpu/sched.h>
#include <kern/cpu/cpu.h>
#include <kern/disk/pagefile_manager.h>
#include <kern/mem/memory_manager.h>
#include <kern/mem/kheap.h>

// 2014 Test Free(): Set it to bypass the PAGE FAULT on an instruction with this length and continue executing the next one
//  0 means don't bypass the PAGE FAULT
uint8 bypassInstrLength = 0;

//===============================
// REPLACEMENT STRATEGIES
//===============================
// 2020
void setPageReplacmentAlgorithmLRU(int LRU_TYPE)
{
	assert(LRU_TYPE == PG_REP_LRU_TIME_APPROX || LRU_TYPE == PG_REP_LRU_LISTS_APPROX);
	_PageRepAlgoType = LRU_TYPE;
}
void setPageReplacmentAlgorithmCLOCK() { _PageRepAlgoType = PG_REP_CLOCK; }
void setPageReplacmentAlgorithmFIFO() { _PageRepAlgoType = PG_REP_FIFO; }
void setPageReplacmentAlgorithmModifiedCLOCK() { _PageRepAlgoType = PG_REP_MODIFIEDCLOCK; }
/*2018*/ void setPageReplacmentAlgorithmDynamicLocal() { _PageRepAlgoType = PG_REP_DYNAMIC_LOCAL; }
/*2021*/ void setPageReplacmentAlgorithmNchanceCLOCK(int PageWSMaxSweeps)
{
	_PageRepAlgoType = PG_REP_NchanceCLOCK;
	page_WS_max_sweeps = PageWSMaxSweeps;
}
/*2024*/ void setFASTNchanceCLOCK(bool fast) { FASTNchanceCLOCK = fast; };
/*2025*/ void setPageReplacmentAlgorithmOPTIMAL() { _PageRepAlgoType = PG_REP_OPTIMAL; };

// 2020
uint32 isPageReplacmentAlgorithmLRU(int LRU_TYPE) { return _PageRepAlgoType == LRU_TYPE ? 1 : 0; }
uint32 isPageReplacmentAlgorithmCLOCK()
{
	if (_PageRepAlgoType == PG_REP_CLOCK)
		return 1;
	return 0;
}
uint32 isPageReplacmentAlgorithmFIFO()
{
	if (_PageRepAlgoType == PG_REP_FIFO)
		return 1;
	return 0;
}
uint32 isPageReplacmentAlgorithmModifiedCLOCK()
{
	if (_PageRepAlgoType == PG_REP_MODIFIEDCLOCK)
		return 1;
	return 0;
}
/*2018*/ uint32 isPageReplacmentAlgorithmDynamicLocal()
{
	if (_PageRepAlgoType == PG_REP_DYNAMIC_LOCAL)
		return 1;
	return 0;
}
/*2021*/ uint32 isPageReplacmentAlgorithmNchanceCLOCK()
{
	if (_PageRepAlgoType == PG_REP_NchanceCLOCK)
		return 1;
	return 0;
}
/*2021*/ uint32 isPageReplacmentAlgorithmOPTIMAL()
{
	if (_PageRepAlgoType == PG_REP_OPTIMAL)
		return 1;
	return 0;
}

//===============================
// PAGE BUFFERING
//===============================
void enableModifiedBuffer(uint32 enableIt) { _EnableModifiedBuffer = enableIt; }
uint8 isModifiedBufferEnabled() { return _EnableModifiedBuffer; }

void enableBuffering(uint32 enableIt) { _EnableBuffering = enableIt; }
uint8 isBufferingEnabled() { return _EnableBuffering; }

void setModifiedBufferLength(uint32 length) { _ModifiedBufferLength = length; }
uint32 getModifiedBufferLength() { return _ModifiedBufferLength; }

//===============================
// FAULT HANDLERS
//===============================

//==================
// [0] INIT HANDLER:
//==================
void fault_handler_init()
{
	// setPageReplacmentAlgorithmLRU(PG_REP_LRU_TIME_APPROX);
	// setPageReplacmentAlgorithmOPTIMAL();
	setPageReplacmentAlgorithmCLOCK();
	// setPageReplacmentAlgorithmModifiedCLOCK();
	enableBuffering(0);
	enableModifiedBuffer(0);
	setModifiedBufferLength(1000);
}
//==================
// [1] MAIN HANDLER:
//==================
/*2022*/
uint32 last_eip = 0;
uint32 before_last_eip = 0;
uint32 last_fault_va = 0;
uint32 before_last_fault_va = 0;
uint8 num_repeated_fault = 0;
extern uint32 sys_calculate_free_frames();

struct Env *last_faulted_env = NULL;
void fault_handler(struct Trapframe *tf)
{
	/******************************************************/
	// Read processor's CR2 register to find the faulting address
	uint32 fault_va = rcr2();
	// cprintf("************Faulted VA = %x************\n", fault_va);
	//	print_trapframe(tf);
	/******************************************************/

	// If same fault va for 3 times, then panic
	// UPDATE: 3 FAULTS MUST come from the same environment (or the kernel)
	struct Env *cur_env = get_cpu_proc();
	if (last_fault_va == fault_va && last_faulted_env == cur_env)

	{
		num_repeated_fault++;
		if (num_repeated_fault == 3)
		{
			print_trapframe(tf);
			panic("Failed to handle fault! fault @ at va = %x from eip = %x causes va (%x) to be faulted for 3 successive times\n", before_last_fault_va, before_last_eip, fault_va);
		}
	}
	else
	{
		before_last_fault_va = last_fault_va;
		before_last_eip = last_eip;
		num_repeated_fault = 0;
	}
	last_eip = (uint32)tf->tf_eip;
	last_fault_va = fault_va;
	last_faulted_env = cur_env;
	/******************************************************/
	// 2017: Check stack overflow for Kernel
	int userTrap = 0;
	if ((tf->tf_cs & 3) == 3)
	{
		userTrap = 1;
	}
	if (!userTrap)
	{
		struct cpu *c = mycpu();
		// cprintf("trap from KERNEL\n");
		if (cur_env && fault_va >= (uint32)cur_env->kstack && fault_va < (uint32)cur_env->kstack + PAGE_SIZE)
			panic("User Kernel Stack: overflow exception!");
		else if (fault_va >= (uint32)c->stack && fault_va < (uint32)c->stack + PAGE_SIZE)
			panic("Sched Kernel Stack of CPU #%d: overflow exception!", c - CPUS);
#if USE_KHEAP
		if (fault_va >= KERNEL_HEAP_MAX)
			panic("Kernel: heap overflow exception!");
#endif
	}
	// 2017: Check stack underflow for User
	else
	{
		// cprintf("trap from USER\n");
		if (fault_va >= USTACKTOP && fault_va < USER_TOP)
			panic("User: stack underflow exception!");
	}

	// get a pointer to the environment that caused the fault at runtime
	// cprintf("curenv = %x\n", curenv);
	struct Env *faulted_env = cur_env;
	if (faulted_env == NULL)
	{
		cprintf("\nFaulted VA = %x\n", fault_va);
		print_trapframe(tf);
		panic("faulted env == NULL!");
	}
	// check the faulted address, is it a table or not ?
	// If the directory entry of the faulted address is NOT PRESENT then
	if ((faulted_env->env_page_directory[PDX(fault_va)] & PERM_PRESENT) != PERM_PRESENT)
	{
		faulted_env->tableFaultsCounter++;
		table_fault_handler(faulted_env, fault_va);
	}
	else
	{
		if (userTrap) // youssef
		{

			// (1) Pointing to UNMARKED page in user heap (i.e., PERM_UHPAGE = 0)
			// (2) Pointing to KERNEL
			// (3) Exists with READ-ONLY permissions while writing
			// If any invalid case occurs: exit process using env_exit()
			int perm;
			perm = pt_get_page_permissions(faulted_env->env_page_directory, fault_va);

			if (fault_va >= USER_LIMIT)
			{
				env_exit();
			}
			else if ((perm & PERM_WRITEABLE) || (perm & PERM_PRESENT))
			{
				env_exit();
			}

			else if (fault_va >= USER_HEAP_START)
			{
				if (fault_va < USER_HEAP_MAX)
				{
					if (!(perm & PERM_AVAILABLE))
					{
						env_exit();
					}
				}
			}
		}

		/*2022: Check if fault due to Access Rights */
		int perms = pt_get_page_permissions(faulted_env->env_page_directory, fault_va);
		if (perms & PERM_PRESENT)
			panic("Page @va=%x is exist! page fault due to violation of ACCESS RIGHTS\n", fault_va);
		/*============================================================================================*/

		// we have normal page fault =============================================================
		faulted_env->pageFaultsCounter++;

		//				cprintf("[%08s] user PAGE fault va %08x\n", faulted_env->prog_name, fault_va);
		//				cprintf("\nPage working set BEFORE fault handler...\n");
		//				env_page_ws_print(faulted_env);
		// int ffb = sys_calculate_free_frames();

		if (isBufferingEnabled())
		{
			__page_fault_handler_with_buffering(faulted_env, fault_va);
		}
		else
		{
			page_fault_handler(faulted_env, fault_va);
		}

		//		cprintf("\nPage working set AFTER fault handler...\n");
		//		env_page_ws_print(faulted_env);
		//		int ffa = sys_calculate_free_frames();
		//		cprintf("fault handling @%x: difference in free frames (after - before = %d)\n", fault_va, ffa - ffb);
	}

	/*************************************************************/
	// Refresh the TLB cache
	tlbflush();
	/*************************************************************/
}

//=========================
// [2] TABLE FAULT HANDLER:
//=========================
void table_fault_handler(struct Env *curenv, uint32 fault_va)
{
	// panic("table_fault_handler() is not implemented yet...!!");
	// Check if it's a stack page
	uint32 *ptr_table;
#if USE_KHEAP
	{
		ptr_table = create_page_table(curenv->env_page_directory, (uint32)fault_va);
	}
#else
	{
		__static_cpt(curenv->env_page_directory, (uint32)fault_va, &ptr_table);
	}
#endif
}

//=========================
// [3] PAGE FAULT HANDLER:
//=========================
/* Calculate the number of page faults according th the OPTIMAL replacement strategy
 * Given:
 * 	1. Initial Working Set List (that the process started with)
 * 	2. Max Working Set Size
 * 	3. Page References List (contains the stream of referenced VAs till the process finished)
 *
 * 	IMPORTANT: This function SHOULD NOT change any of the given lists
 */

#define INT_MAX 2147483647

int get_optimal_num_faults(struct WS_List *initWorkingSet, int maxWSSize, struct PageRef_List *pageReferences)
{
	// TODO: [PROJECT'25.IM#1] FAULT HANDLER II - #2 get_optimal_num_faults
	// Your code is here

	// [1] Copy initial WS
	struct WS_List copyWS;
	LIST_INIT(&copyWS);
	int currentWSsize = 0;

	struct WorkingSetElement *ws_it;
	LIST_FOREACH(ws_it, initWorkingSet)
	{
		if (currentWSsize >= maxWSSize)
		{
			break;
		}

		struct WorkingSetElement *copy = (struct WorkingSetElement *)kmalloc(sizeof(struct WorkingSetElement));
		copy->virtual_address = ws_it->virtual_address;

		LIST_INSERT_TAIL(&copyWS, copy);

		currentWSsize++;
	}

	int faults = 0;

	//  [2] Trace the Reference Stream
	struct PageRefElement *ref_it;
	LIST_FOREACH(ref_it, pageReferences)
	{
		uint32 ref_va = ROUNDDOWN(ref_it->virtual_address, PAGE_SIZE);

		int hit = 0;
		LIST_FOREACH(ws_it, &copyWS)
		{
			if (ws_it->virtual_address == ref_va)
			{
				hit = 1;
				break;
			}
		}
		if (hit)
		{
			continue;
		}

		faults++;

		if (currentWSsize < maxWSSize)
		{
			struct WorkingSetElement *new_ws_element_1 = (struct WorkingSetElement *)kmalloc(sizeof(struct WorkingSetElement));
			new_ws_element_1->virtual_address = ref_va;
			LIST_INSERT_TAIL(&copyWS, new_ws_element_1);
			currentWSsize++;
			continue;
		}

		// [3] OPTIMAL Replacement
		struct WorkingSetElement *victim = NULL;
		int farthest = -1;

		LIST_FOREACH(ws_it, &copyWS)
		{
			int distance = 0;
			int found = 0;

			struct PageRefElement *look = LIST_NEXT(ref_it);

			while (look != NULL)
			{

				uint32 next_va = ROUNDDOWN(look->virtual_address, PAGE_SIZE);
				if (next_va == ws_it->virtual_address)
				{
					found = 1;
					break;
				}
				distance++;
				look = LIST_NEXT(look);
			}

			int next_use;

			if (found)
			{
				next_use = distance;
			}
			else
			{
				next_use = INT_MAX;
			}

			if (next_use > farthest)
			{
				farthest = next_use;
				victim = ws_it;
			}
		}

		// Remove victim
		LIST_REMOVE(&copyWS, victim);
		kfree(victim);
		currentWSsize--;

		// Insert new page
		struct WorkingSetElement *new_ws_element_2 = (struct WorkingSetElement *)kmalloc(sizeof(struct WorkingSetElement));
		new_ws_element_2->virtual_address = ref_va;
		LIST_INSERT_TAIL(&copyWS, new_ws_element_2);
		currentWSsize++;
	}

	// [4] Cleanup
	struct WorkingSetElement *temp;
	LIST_FOREACH_SAFE(temp, &copyWS, WorkingSetElement)
	{
		LIST_REMOVE(&copyWS, temp);
		kfree(temp);
	}

	return faults;

	// Comment the following line
	// panic("get_optimal_num_faults() is not implemented yet...!!");
}

struct WS_List activeWS;
struct Env *activeWS_owner = NULL;
int activeWS_init = 0;

void page_fault_handler(struct Env *faulted_env, uint32 fault_va)
{
#if USE_KHEAP
	if (isPageReplacmentAlgorithmOPTIMAL())
	{
		// TODO: [PROJECT'25.IM#1] FAULT HANDLER II - #1 Optimal Reference Stream
		// Your code is here

		fault_va = ROUNDDOWN(fault_va, PAGE_SIZE);

		// [1] Keep track of the Active WS
		if (activeWS_owner != faulted_env)
		{
			if (activeWS_init && activeWS_owner != NULL)
			{
				{
					struct WorkingSetElement *temp_ws;
					LIST_FOREACH_SAFE(temp_ws, &activeWS, WorkingSetElement)
					{
						LIST_REMOVE(&activeWS, temp_ws);
						kfree(temp_ws);
					}
				}

				{

					struct PageRefElement *temp_ref;
					LIST_FOREACH_SAFE(temp_ref, &(activeWS_owner->referenceStreamList), PageRefElement)
					{
						LIST_REMOVE(&(activeWS_owner->referenceStreamList), temp_ref);
						kfree(temp_ref);
					}
				}

				activeWS_init = 0;
			}

			LIST_INIT(&activeWS);
			struct WorkingSetElement *ws_it_1;
			LIST_FOREACH(ws_it_1, &(faulted_env->page_WS_list))
			{
				struct WorkingSetElement *copy = env_page_ws_list_create_element(faulted_env, ws_it_1->virtual_address);
				if (copy == NULL)
				{
					panic("ActiveWS copy failed");
				}
				LIST_INSERT_TAIL(&activeWS, copy);
			}

			activeWS_owner = faulted_env;
			activeWS_init = 1;
		}

		// [2] If faulted page not in memory, read it from disk & Else, just set its present bit
		uint32 *ptr_page_table = NULL;
		struct FrameInfo *ptr_frame_info_exist = get_frame_info(faulted_env->env_page_directory, fault_va, &ptr_page_table);

		if (ptr_frame_info_exist != NULL)
		{
			pt_set_page_permissions(faulted_env->env_page_directory, fault_va, PERM_PRESENT | PERM_USER | PERM_WRITEABLE, 0);
		}
		else
		{
			struct FrameInfo *ptr_frame_info = NULL;
			int ret_allocate = allocate_frame(&ptr_frame_info);
			if (ret_allocate == E_NO_MEM)
			{
				panic("No free frame available");
			}

			map_frame(faulted_env->env_page_directory, ptr_frame_info, fault_va, PERM_USER | PERM_WRITEABLE | PERM_PRESENT);

			int ret_pf_read = pf_read_env_page(faulted_env, (void *)fault_va);
			if (ret_pf_read == E_PAGE_NOT_EXIST_IN_PF)
			{
				if (!((fault_va >= USTACKBOTTOM && fault_va < USTACKTOP) || (fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX)))
				{
					unmap_frame(faulted_env->env_page_directory, fault_va);
					env_exit();
				}
			}
		}

		// [3] If the faulted page in the Active WS, do nothing & Else, if Active WS is FULL, reset present & delete all its pages
		int found_in_activeWS = 0;
		struct WorkingSetElement *ws_it_2;
		LIST_FOREACH(ws_it_2, &activeWS)
		{
			if (ws_it_2->virtual_address == fault_va)
			{
				found_in_activeWS = 1;
				break;
			}
		}

		if (!found_in_activeWS && LIST_SIZE(&activeWS) == faulted_env->page_WS_max_size)
		{
			{
				struct WorkingSetElement *ws_it_3;
				LIST_FOREACH_SAFE(ws_it_3, &activeWS, WorkingSetElement)
				{
					pt_set_page_permissions(faulted_env->env_page_directory, ws_it_3->virtual_address, 0, PERM_PRESENT);
					LIST_REMOVE(&activeWS, ws_it_3);
					kfree(ws_it_3);
				}
			}
		}

		// [4] Add the faulted page to the Active WS
		struct WorkingSetElement *new_ws_element = env_page_ws_list_create_element(faulted_env, fault_va);
		if (new_ws_element == NULL)
		{
			panic("Can't Create ws element");
		}
		LIST_INSERT_TAIL(&activeWS, new_ws_element);

		// [5] Add faulted page to the end of the reference stream list
		struct PageRefElement *new_ref_element = (struct PageRefElement *)kmalloc(sizeof(struct PageRefElement));
		if (new_ref_element != NULL)
		{
			new_ref_element->virtual_address = fault_va;
			LIST_INSERT_TAIL(&(faulted_env->referenceStreamList), new_ref_element);
		}

		return;

		// Comment the following line
		// panic("page_fault_handler().REPLACEMENT is not implemented yet...!!");
	}
	else
	{
		struct WorkingSetElement *victimWSElement = NULL;
		uint32 wsSize = LIST_SIZE(&(faulted_env->page_WS_list));
		if (wsSize < (faulted_env->page_WS_max_size))
		{
			// TODO: [PROJECT'25.GM#3] FAULT HANDLER I - #3 placement
			// Your code is here

			fault_va = ROUNDDOWN(fault_va, PAGE_SIZE);

			struct FrameInfo *ptr_frame_info = NULL;
			int ret_allocate = allocate_frame(&ptr_frame_info);
			if (ret_allocate == E_NO_MEM)
			{
				panic("No free frame available");
			}

			map_frame(faulted_env->env_page_directory, ptr_frame_info, fault_va, PERM_USER | PERM_WRITEABLE | PERM_PRESENT);

			int ret_pf_read = pf_read_env_page(faulted_env, (void *)fault_va);
			if (ret_pf_read == E_PAGE_NOT_EXIST_IN_PF)
			{
				if (!((fault_va >= USTACKBOTTOM && fault_va < USTACKTOP) || (fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX)))
				{
					unmap_frame(faulted_env->env_page_directory, fault_va);
					env_exit();
				}
			}

			struct WorkingSetElement *new_ws_element = env_page_ws_list_create_element(faulted_env, fault_va);
			if (new_ws_element == NULL)
			{
				panic("Can't Create ws element");
			}

			if (faulted_env->page_last_WS_element != NULL)
			{
				LIST_INSERT_BEFORE(&(faulted_env->page_WS_list), faulted_env->page_last_WS_element, new_ws_element);
			}
			else
			{
				LIST_INSERT_TAIL(&(faulted_env->page_WS_list), new_ws_element);
			}
			if (LIST_SIZE(&(faulted_env->page_WS_list)) == faulted_env->page_WS_max_size)
			{
				if (faulted_env->page_last_WS_element == NULL)
				{
					faulted_env->page_last_WS_element = LIST_FIRST(&(faulted_env->page_WS_list));
				}
			}

			return;

			// Comment the following line
			// panic("page_fault_handler().PLACEMENT is not implemented yet...!!");
		}
		else
		{
			if (isPageReplacmentAlgorithmCLOCK())
			{
				// TODO: [PROJECT'25.IM#6] FAULT HANDLER II - #3 Clock
				// Your code is here

				fault_va = ROUNDDOWN(fault_va, PAGE_SIZE);

				// [1] Initialize clock pointer
				struct WorkingSetElement *clock_ptr = faulted_env->page_last_WS_element;
				if (clock_ptr == NULL)
					clock_ptr = LIST_FIRST(&(faulted_env->page_WS_list));

				if (clock_ptr == NULL)
					panic("Empty WS on replacement");

				// [2] Find victim
				int ws_size = LIST_SIZE(&(faulted_env->page_WS_list));
				int scanned = 0;
				struct WorkingSetElement *victim = NULL;

				while (scanned < ws_size)
				{
					uint32 candidate_va = ROUNDDOWN(clock_ptr->virtual_address, PAGE_SIZE);

					uint32 *candidate_page_table = NULL;
					struct FrameInfo *candidate_frame_info = get_frame_info(faulted_env->env_page_directory, candidate_va, &candidate_page_table);

					uint32 candidate_pte = 0;
					if (candidate_page_table != NULL)
					{
						int candidate_ptx = PTX(candidate_va);
						candidate_pte = candidate_page_table[candidate_ptx];
					}

					if (candidate_pte & PERM_USED)
					{
						pt_set_page_permissions(faulted_env->env_page_directory, candidate_va, 0, PERM_USED);

						struct WorkingSetElement *next_element = LIST_NEXT(clock_ptr);
						if (next_element == NULL)
						{
							next_element = LIST_FIRST(&(faulted_env->page_WS_list));
						}

						clock_ptr = next_element;
						scanned++;
						continue;
					}
					else
					{
						victim = clock_ptr;
						break;
					}
				}

				if (victim == NULL)
				{
					victim = clock_ptr;
				}

				// [3] Update memory & remove victim mapping
				uint32 victim_va = ROUNDDOWN(victim->virtual_address, PAGE_SIZE);

				uint32 *victim_page_table = NULL;
				struct FrameInfo *victim_frame_info = get_frame_info(faulted_env->env_page_directory, victim_va, &victim_page_table);
				if (victim_page_table != NULL)
				{
					int victim_ptx = PTX(victim_va);
					uint32 victim_pte = victim_page_table[victim_ptx];
					if (victim_pte & PERM_MODIFIED)
					{
						int update_result = pf_update_env_page(faulted_env, victim_va, victim_frame_info);
					}
				}

				struct WorkingSetElement *prev_element = LIST_PREV(victim);
				struct WorkingSetElement *next_element = LIST_NEXT(victim);

				unmap_frame(faulted_env->env_page_directory, victim_va);
				LIST_REMOVE(&(faulted_env->page_WS_list), victim);
				kfree(victim);

				// [4] Allocate frame and map new page
				struct FrameInfo *ptr_frame_info = NULL;
				int ret_allocate = allocate_frame(&ptr_frame_info);
				if (ret_allocate == E_NO_MEM)
				{
					panic("No free frame available");
				}

				map_frame(faulted_env->env_page_directory, ptr_frame_info, fault_va, PERM_USER | PERM_WRITEABLE | PERM_PRESENT);

				int ret_pf_read = pf_read_env_page(faulted_env, (void *)fault_va);
				if (ret_pf_read == E_PAGE_NOT_EXIST_IN_PF)
				{
					if (!((fault_va >= USTACKBOTTOM && fault_va < USTACKTOP) || (fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX)))
					{
						unmap_frame(faulted_env->env_page_directory, fault_va);
						env_exit();
					}
				}

				pt_set_page_permissions(faulted_env->env_page_directory, fault_va, PERM_PRESENT | PERM_USER | PERM_WRITEABLE, 0);

				// [5] create new WS element
				struct WorkingSetElement *new_ws_element = env_page_ws_list_create_element(faulted_env, fault_va);
				if (new_ws_element == NULL)
				{
					panic("Can't create new WS element");
				}

				if (prev_element != NULL)
				{
					LIST_INSERT_AFTER(&(faulted_env->page_WS_list), prev_element, new_ws_element);
				}
				else if (next_element != NULL)
				{
					LIST_INSERT_BEFORE(&(faulted_env->page_WS_list), next_element, new_ws_element);
				}
				else
				{
					LIST_INSERT_TAIL(&(faulted_env->page_WS_list), new_ws_element);
				}

				// [6] update page_last_WS_element
				struct WorkingSetElement *after_new = LIST_NEXT(new_ws_element);
				if (after_new == NULL)
				{
					after_new = LIST_FIRST(&(faulted_env->page_WS_list));
				}
				faulted_env->page_last_WS_element = after_new;

				return;

				// Comment the following line
				// panic("page_fault_handler().REPLACEMENT is not implemented yet...!!");
			}
			else if (isPageReplacmentAlgorithmLRU(PG_REP_LRU_TIME_APPROX))
			{
				// TODO: [PROJECT'25.IM#6] FAULT HANDLER II - #2 LRU Aging Replacement
				// Your code is here
				// Comment the following line
				panic("page_fault_handler().REPLACEMENT is not implemented yet...!!");
			}
			else if (isPageReplacmentAlgorithmModifiedCLOCK())
			{
				// TODO: [PROJECT'25.IM#6] FAULT HANDLER II - #3 Modified Clock Replacement
				// Your code is here
				// Comment the following line
				panic("page_fault_handler().REPLACEMENT is not implemented yet...!!");
			}
		}
	}
#endif
}

void __page_fault_handler_with_buffering(struct Env *curenv, uint32 fault_va)
{
	panic("this function is not required...!!");
}

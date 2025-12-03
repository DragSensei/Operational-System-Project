/*
 * channel.c
 *
 *  Created on: Sep 22, 2024
 *      Author: HP
 */
#include "channel.h"
#include <kern/proc/user_environment.h>
#include <kern/cpu/sched.h>
#include <inc/string.h>
#include <inc/disk.h>

//===============================
// 1) INITIALIZE THE CHANNEL:
//===============================
// initialize its lock & queue
void init_channel(struct Channel *chan, char *name)
{
	strcpy(chan->name, name);
	init_queue(&(chan->queue));
}

//===============================
// 2) SLEEP ON A GIVEN CHANNEL:
//===============================
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
// Ref: xv6-x86 OS code

//===============================
// 1) SLEEP ON A GIVEN CHANNEL:
//===============================
//===============================
// 2) SLEEP ON A GIVEN CHANNEL:
//===============================
// ...existing code...
void sleep(struct Channel *chan, struct kspinlock* lk)
{
    struct Env *cur = get_cpu_proc();
    if (cur == NULL)
        panic("sleep: no current process");
    
    acquire_kspinlock(&(ProcessQueues.qlock));
    cur->env_status = ENV_BLOCKED;
    LIST_INSERT_TAIL(&(chan->queue), cur);
    release_kspinlock(lk);  // Release the caller's lock first
    sched();  // Called WHILE holding ProcessQueues.qlock
    acquire_kspinlock(lk);
    release_kspinlock(&(ProcessQueues.qlock));  // Release after wakeup
}

void wakeup_one(struct Channel *chan)
{
    acquire_kspinlock(&(ProcessQueues.qlock));
    struct Env *p = LIST_FIRST(&(chan->queue));
    if (p != NULL)
    {
        LIST_REMOVE(&(chan->queue), p);
        p->env_status = ENV_READY;
        sched_insert_ready(p);
    }
    release_kspinlock(&(ProcessQueues.qlock));
}

void wakeup_all(struct Channel *chan)
{
    // Acquire lock to protect both queues
    acquire_kspinlock(&(ProcessQueues.qlock));
    
    struct Env *p;
    // Loop while there are processes in the channel queue
    while ((p = LIST_FIRST(&(chan->queue))) != NULL)
    {
        // Remove process from channel queue
        LIST_REMOVE(&(chan->queue), p);
        
        // Mark as ready for scheduling
        p->env_status = ENV_READY;
        
        // Add to ready queue
        sched_insert_ready(p);
    }
    
    // Release lock after all processes woken
    release_kspinlock(&(ProcessQueues.qlock));
}

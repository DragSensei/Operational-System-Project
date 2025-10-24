
obj/user/tst_envfree6:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 a1 02 00 00       	call   8002d7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	// Testing scenario 6: Semaphores & shared variables
	// Testing removing the shared variables and semaphores
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  800044:	83 ec 04             	sub    $0x4,%esp
  800047:	6a 01                	push   $0x1
  800049:	6a 04                	push   $0x4
  80004b:	68 20 22 80 00       	push   $0x802220
  800050:	e8 0a 17 00 00       	call   80175f <smalloc>
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*numOfFinished = 0 ;
  80005b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80005e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	char getksbrkCmd[100] = "__getKernelSBreak__";
  800064:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80006a:	bb 21 24 80 00       	mov    $0x802421,%ebx
  80006f:	ba 05 00 00 00       	mov    $0x5,%edx
  800074:	89 c7                	mov    %eax,%edi
  800076:	89 de                	mov    %ebx,%esi
  800078:	89 d1                	mov    %edx,%ecx
  80007a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80007c:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  800082:	b9 14 00 00 00       	mov    $0x14,%ecx
  800087:	b8 00 00 00 00       	mov    $0x0,%eax
  80008c:	89 d7                	mov    %edx,%edi
  80008e:	f3 ab                	rep stos %eax,%es:(%edi)
	uint32 ksbrk_before ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_before);
  800090:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	50                   	push   %eax
  80009a:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  8000a0:	50                   	push   %eax
  8000a1:	e8 69 1c 00 00       	call   801d0f <sys_utilities>
  8000a6:	83 c4 10             	add    $0x10,%esp

	int freeFrames_before = sys_calculate_free_frames() ;
  8000a9:	e8 62 18 00 00       	call   801910 <sys_calculate_free_frames>
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  8000b1:	e8 a5 18 00 00       	call   80195b <sys_pf_calculate_allocated_pages>
  8000b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bf:	68 30 22 80 00       	push   $0x802230
  8000c4:	e8 8c 06 00 00       	call   800755 <cprintf>
  8000c9:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", myEnv->page_WS_max_size, (myEnv->SecondListSize),50);
  8000cc:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d1:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8000d7:	89 c2                	mov    %eax,%edx
  8000d9:	a1 20 30 80 00       	mov    0x803020,%eax
  8000de:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000e4:	6a 32                	push   $0x32
  8000e6:	52                   	push   %edx
  8000e7:	50                   	push   %eax
  8000e8:	68 63 22 80 00       	push   $0x802263
  8000ed:	e8 79 19 00 00       	call   801a6b <sys_create_env>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdProcessB = sys_create_env("ef_midterm", myEnv->page_WS_max_size,(myEnv->SecondListSize), 50);
  8000f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8000fd:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800103:	89 c2                	mov    %eax,%edx
  800105:	a1 20 30 80 00       	mov    0x803020,%eax
  80010a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800110:	6a 32                	push   $0x32
  800112:	52                   	push   %edx
  800113:	50                   	push   %eax
  800114:	68 6c 22 80 00       	push   $0x80226c
  800119:	e8 4d 19 00 00       	call   801a6b <sys_create_env>
  80011e:	83 c4 10             	add    $0x10,%esp
  800121:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	sys_run_env(envIdProcessA);
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	ff 75 d8             	pushl  -0x28(%ebp)
  80012a:	e8 5a 19 00 00       	call   801a89 <sys_run_env>
  80012f:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  800132:	83 ec 0c             	sub    $0xc,%esp
  800135:	68 10 27 00 00       	push   $0x2710
  80013a:	e8 a4 1d 00 00       	call   801ee3 <env_sleep>
  80013f:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800142:	83 ec 0c             	sub    $0xc,%esp
  800145:	ff 75 d4             	pushl  -0x2c(%ebp)
  800148:	e8 3c 19 00 00       	call   801a89 <sys_run_env>
  80014d:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  800150:	90                   	nop
  800151:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800154:	8b 00                	mov    (%eax),%eax
  800156:	83 f8 02             	cmp    $0x2,%eax
  800159:	75 f6                	jne    800151 <_main+0x119>

	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  80015b:	e8 b0 17 00 00       	call   801910 <sys_calculate_free_frames>
  800160:	83 ec 08             	sub    $0x8,%esp
  800163:	50                   	push   %eax
  800164:	68 78 22 80 00       	push   $0x802278
  800169:	e8 e7 05 00 00       	call   800755 <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp

	uint32 ksbrk_after ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_after);
  800171:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800177:	83 ec 08             	sub    $0x8,%esp
  80017a:	50                   	push   %eax
  80017b:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800181:	50                   	push   %eax
  800182:	e8 88 1b 00 00       	call   801d0f <sys_utilities>
  800187:	83 c4 10             	add    $0x10,%esp

	//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
	//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
	//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
	//	2. changing the # free frames
	char changeIntCmd[100] = "__changeInterruptStatus__";
  80018a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800190:	bb 85 24 80 00       	mov    $0x802485,%ebx
  800195:	ba 1a 00 00 00       	mov    $0x1a,%edx
  80019a:	89 c7                	mov    %eax,%edi
  80019c:	89 de                	mov    %ebx,%esi
  80019e:	89 d1                	mov    %edx,%ecx
  8001a0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001a2:	8d 95 02 ff ff ff    	lea    -0xfe(%ebp),%edx
  8001a8:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  8001ad:	b0 00                	mov    $0x0,%al
  8001af:	89 d7                	mov    %edx,%edi
  8001b1:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(changeIntCmd, 0);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	6a 00                	push   $0x0
  8001b8:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001be:	50                   	push   %eax
  8001bf:	e8 4b 1b 00 00       	call   801d0f <sys_utilities>
  8001c4:	83 c4 10             	add    $0x10,%esp
	{
		sys_destroy_env(envIdProcessA);
  8001c7:	83 ec 0c             	sub    $0xc,%esp
  8001ca:	ff 75 d8             	pushl  -0x28(%ebp)
  8001cd:	e8 d3 18 00 00       	call   801aa5 <sys_destroy_env>
  8001d2:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001db:	e8 c5 18 00 00       	call   801aa5 <sys_destroy_env>
  8001e0:	83 c4 10             	add    $0x10,%esp
	}
	sys_utilities(changeIntCmd, 1);
  8001e3:	83 ec 08             	sub    $0x8,%esp
  8001e6:	6a 01                	push   $0x1
  8001e8:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001ee:	50                   	push   %eax
  8001ef:	e8 1b 1b 00 00       	call   801d0f <sys_utilities>
  8001f4:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8001f7:	e8 14 17 00 00       	call   801910 <sys_calculate_free_frames>
  8001fc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8001ff:	e8 57 17 00 00       	call   80195b <sys_pf_calculate_allocated_pages>
  800204:	89 45 cc             	mov    %eax,-0x34(%ebp)

	int expected = (ROUNDUP((uint32)ksbrk_after, PAGE_SIZE) - ROUNDUP((uint32)ksbrk_before, PAGE_SIZE)) / PAGE_SIZE;
  800207:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  80020e:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  800214:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800217:	01 d0                	add    %edx,%eax
  800219:	48                   	dec    %eax
  80021a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80021d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800220:	ba 00 00 00 00       	mov    $0x0,%edx
  800225:	f7 75 c8             	divl   -0x38(%ebp)
  800228:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80022b:	29 d0                	sub    %edx,%eax
  80022d:	89 c1                	mov    %eax,%ecx
  80022f:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  800236:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  80023c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80023f:	01 d0                	add    %edx,%eax
  800241:	48                   	dec    %eax
  800242:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800245:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800248:	ba 00 00 00 00       	mov    $0x0,%edx
  80024d:	f7 75 c0             	divl   -0x40(%ebp)
  800250:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800253:	29 d0                	sub    %edx,%eax
  800255:	29 c1                	sub    %eax,%ecx
  800257:	89 c8                	mov    %ecx,%eax
  800259:	c1 e8 0c             	shr    $0xc,%eax
  80025c:	89 45 b8             	mov    %eax,-0x48(%ebp)
	cprintf("expected = %d\n",expected);
  80025f:	83 ec 08             	sub    $0x8,%esp
  800262:	ff 75 b8             	pushl  -0x48(%ebp)
  800265:	68 aa 22 80 00       	push   $0x8022aa
  80026a:	e8 e6 04 00 00       	call   800755 <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
	if ((freeFrames_before - freeFrames_after) != expected) {
  800272:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800275:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800278:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80027b:	74 2e                	je     8002ab <_main+0x273>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d, expected = %d\n",
  80027d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800280:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800283:	ff 75 b8             	pushl  -0x48(%ebp)
  800286:	50                   	push   %eax
  800287:	ff 75 d0             	pushl  -0x30(%ebp)
  80028a:	68 bc 22 80 00       	push   $0x8022bc
  80028f:	e8 c1 04 00 00       	call   800755 <cprintf>
  800294:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before, expected);
		panic("env_free() does not work correctly... check it again.");
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	68 2c 23 80 00       	push   $0x80232c
  80029f:	6a 36                	push   $0x36
  8002a1:	68 62 23 80 00       	push   $0x802362
  8002a6:	e8 dc 01 00 00       	call   800487 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  8002ab:	83 ec 08             	sub    $0x8,%esp
  8002ae:	ff 75 d0             	pushl  -0x30(%ebp)
  8002b1:	68 78 23 80 00       	push   $0x802378
  8002b6:	e8 9a 04 00 00       	call   800755 <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 6 for envfree completed successfully.\n");
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	68 d8 23 80 00       	push   $0x8023d8
  8002c6:	e8 8a 04 00 00       	call   800755 <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
	return;
  8002ce:	90                   	nop
}
  8002cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d2:	5b                   	pop    %ebx
  8002d3:	5e                   	pop    %esi
  8002d4:	5f                   	pop    %edi
  8002d5:	5d                   	pop    %ebp
  8002d6:	c3                   	ret    

008002d7 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002d7:	55                   	push   %ebp
  8002d8:	89 e5                	mov    %esp,%ebp
  8002da:	57                   	push   %edi
  8002db:	56                   	push   %esi
  8002dc:	53                   	push   %ebx
  8002dd:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002e0:	e8 f4 17 00 00       	call   801ad9 <sys_getenvindex>
  8002e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002eb:	89 d0                	mov    %edx,%eax
  8002ed:	c1 e0 02             	shl    $0x2,%eax
  8002f0:	01 d0                	add    %edx,%eax
  8002f2:	c1 e0 03             	shl    $0x3,%eax
  8002f5:	01 d0                	add    %edx,%eax
  8002f7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002fe:	01 d0                	add    %edx,%eax
  800300:	c1 e0 02             	shl    $0x2,%eax
  800303:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800308:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80030d:	a1 20 30 80 00       	mov    0x803020,%eax
  800312:	8a 40 20             	mov    0x20(%eax),%al
  800315:	84 c0                	test   %al,%al
  800317:	74 0d                	je     800326 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800319:	a1 20 30 80 00       	mov    0x803020,%eax
  80031e:	83 c0 20             	add    $0x20,%eax
  800321:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800326:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80032a:	7e 0a                	jle    800336 <libmain+0x5f>
		binaryname = argv[0];
  80032c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800336:	83 ec 08             	sub    $0x8,%esp
  800339:	ff 75 0c             	pushl  0xc(%ebp)
  80033c:	ff 75 08             	pushl  0x8(%ebp)
  80033f:	e8 f4 fc ff ff       	call   800038 <_main>
  800344:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800347:	a1 00 30 80 00       	mov    0x803000,%eax
  80034c:	85 c0                	test   %eax,%eax
  80034e:	0f 84 01 01 00 00    	je     800455 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800354:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80035a:	bb e4 25 80 00       	mov    $0x8025e4,%ebx
  80035f:	ba 0e 00 00 00       	mov    $0xe,%edx
  800364:	89 c7                	mov    %eax,%edi
  800366:	89 de                	mov    %ebx,%esi
  800368:	89 d1                	mov    %edx,%ecx
  80036a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80036c:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80036f:	b9 56 00 00 00       	mov    $0x56,%ecx
  800374:	b0 00                	mov    $0x0,%al
  800376:	89 d7                	mov    %edx,%edi
  800378:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80037a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800381:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800384:	83 ec 08             	sub    $0x8,%esp
  800387:	50                   	push   %eax
  800388:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80038e:	50                   	push   %eax
  80038f:	e8 7b 19 00 00       	call   801d0f <sys_utilities>
  800394:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800397:	e8 c4 14 00 00       	call   801860 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80039c:	83 ec 0c             	sub    $0xc,%esp
  80039f:	68 04 25 80 00       	push   $0x802504
  8003a4:	e8 ac 03 00 00       	call   800755 <cprintf>
  8003a9:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003af:	85 c0                	test   %eax,%eax
  8003b1:	74 18                	je     8003cb <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003b3:	e8 75 19 00 00       	call   801d2d <sys_get_optimal_num_faults>
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	50                   	push   %eax
  8003bc:	68 2c 25 80 00       	push   $0x80252c
  8003c1:	e8 8f 03 00 00       	call   800755 <cprintf>
  8003c6:	83 c4 10             	add    $0x10,%esp
  8003c9:	eb 59                	jmp    800424 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003cb:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d0:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8003d6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003db:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8003e1:	83 ec 04             	sub    $0x4,%esp
  8003e4:	52                   	push   %edx
  8003e5:	50                   	push   %eax
  8003e6:	68 50 25 80 00       	push   $0x802550
  8003eb:	e8 65 03 00 00       	call   800755 <cprintf>
  8003f0:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003f3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f8:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8003fe:	a1 20 30 80 00       	mov    0x803020,%eax
  800403:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800409:	a1 20 30 80 00       	mov    0x803020,%eax
  80040e:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800414:	51                   	push   %ecx
  800415:	52                   	push   %edx
  800416:	50                   	push   %eax
  800417:	68 78 25 80 00       	push   $0x802578
  80041c:	e8 34 03 00 00       	call   800755 <cprintf>
  800421:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800424:	a1 20 30 80 00       	mov    0x803020,%eax
  800429:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80042f:	83 ec 08             	sub    $0x8,%esp
  800432:	50                   	push   %eax
  800433:	68 d0 25 80 00       	push   $0x8025d0
  800438:	e8 18 03 00 00       	call   800755 <cprintf>
  80043d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800440:	83 ec 0c             	sub    $0xc,%esp
  800443:	68 04 25 80 00       	push   $0x802504
  800448:	e8 08 03 00 00       	call   800755 <cprintf>
  80044d:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800450:	e8 25 14 00 00       	call   80187a <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800455:	e8 1f 00 00 00       	call   800479 <exit>
}
  80045a:	90                   	nop
  80045b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80045e:	5b                   	pop    %ebx
  80045f:	5e                   	pop    %esi
  800460:	5f                   	pop    %edi
  800461:	5d                   	pop    %ebp
  800462:	c3                   	ret    

00800463 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800463:	55                   	push   %ebp
  800464:	89 e5                	mov    %esp,%ebp
  800466:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800469:	83 ec 0c             	sub    $0xc,%esp
  80046c:	6a 00                	push   $0x0
  80046e:	e8 32 16 00 00       	call   801aa5 <sys_destroy_env>
  800473:	83 c4 10             	add    $0x10,%esp
}
  800476:	90                   	nop
  800477:	c9                   	leave  
  800478:	c3                   	ret    

00800479 <exit>:

void
exit(void)
{
  800479:	55                   	push   %ebp
  80047a:	89 e5                	mov    %esp,%ebp
  80047c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80047f:	e8 87 16 00 00       	call   801b0b <sys_exit_env>
}
  800484:	90                   	nop
  800485:	c9                   	leave  
  800486:	c3                   	ret    

00800487 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800487:	55                   	push   %ebp
  800488:	89 e5                	mov    %esp,%ebp
  80048a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80048d:	8d 45 10             	lea    0x10(%ebp),%eax
  800490:	83 c0 04             	add    $0x4,%eax
  800493:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800496:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80049b:	85 c0                	test   %eax,%eax
  80049d:	74 16                	je     8004b5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80049f:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8004a4:	83 ec 08             	sub    $0x8,%esp
  8004a7:	50                   	push   %eax
  8004a8:	68 48 26 80 00       	push   $0x802648
  8004ad:	e8 a3 02 00 00       	call   800755 <cprintf>
  8004b2:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004b5:	a1 04 30 80 00       	mov    0x803004,%eax
  8004ba:	83 ec 0c             	sub    $0xc,%esp
  8004bd:	ff 75 0c             	pushl  0xc(%ebp)
  8004c0:	ff 75 08             	pushl  0x8(%ebp)
  8004c3:	50                   	push   %eax
  8004c4:	68 50 26 80 00       	push   $0x802650
  8004c9:	6a 74                	push   $0x74
  8004cb:	e8 b2 02 00 00       	call   800782 <cprintf_colored>
  8004d0:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004dc:	50                   	push   %eax
  8004dd:	e8 04 02 00 00       	call   8006e6 <vcprintf>
  8004e2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004e5:	83 ec 08             	sub    $0x8,%esp
  8004e8:	6a 00                	push   $0x0
  8004ea:	68 78 26 80 00       	push   $0x802678
  8004ef:	e8 f2 01 00 00       	call   8006e6 <vcprintf>
  8004f4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004f7:	e8 7d ff ff ff       	call   800479 <exit>

	// should not return here
	while (1) ;
  8004fc:	eb fe                	jmp    8004fc <_panic+0x75>

008004fe <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004fe:	55                   	push   %ebp
  8004ff:	89 e5                	mov    %esp,%ebp
  800501:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800504:	a1 20 30 80 00       	mov    0x803020,%eax
  800509:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80050f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800512:	39 c2                	cmp    %eax,%edx
  800514:	74 14                	je     80052a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800516:	83 ec 04             	sub    $0x4,%esp
  800519:	68 7c 26 80 00       	push   $0x80267c
  80051e:	6a 26                	push   $0x26
  800520:	68 c8 26 80 00       	push   $0x8026c8
  800525:	e8 5d ff ff ff       	call   800487 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80052a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800531:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800538:	e9 c5 00 00 00       	jmp    800602 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80053d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800540:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800547:	8b 45 08             	mov    0x8(%ebp),%eax
  80054a:	01 d0                	add    %edx,%eax
  80054c:	8b 00                	mov    (%eax),%eax
  80054e:	85 c0                	test   %eax,%eax
  800550:	75 08                	jne    80055a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800552:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800555:	e9 a5 00 00 00       	jmp    8005ff <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80055a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800561:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800568:	eb 69                	jmp    8005d3 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80056a:	a1 20 30 80 00       	mov    0x803020,%eax
  80056f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800575:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800578:	89 d0                	mov    %edx,%eax
  80057a:	01 c0                	add    %eax,%eax
  80057c:	01 d0                	add    %edx,%eax
  80057e:	c1 e0 03             	shl    $0x3,%eax
  800581:	01 c8                	add    %ecx,%eax
  800583:	8a 40 04             	mov    0x4(%eax),%al
  800586:	84 c0                	test   %al,%al
  800588:	75 46                	jne    8005d0 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80058a:	a1 20 30 80 00       	mov    0x803020,%eax
  80058f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800595:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800598:	89 d0                	mov    %edx,%eax
  80059a:	01 c0                	add    %eax,%eax
  80059c:	01 d0                	add    %edx,%eax
  80059e:	c1 e0 03             	shl    $0x3,%eax
  8005a1:	01 c8                	add    %ecx,%eax
  8005a3:	8b 00                	mov    (%eax),%eax
  8005a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005b0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bf:	01 c8                	add    %ecx,%eax
  8005c1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005c3:	39 c2                	cmp    %eax,%edx
  8005c5:	75 09                	jne    8005d0 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005c7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005ce:	eb 15                	jmp    8005e5 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005d0:	ff 45 e8             	incl   -0x18(%ebp)
  8005d3:	a1 20 30 80 00       	mov    0x803020,%eax
  8005d8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e1:	39 c2                	cmp    %eax,%edx
  8005e3:	77 85                	ja     80056a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005e9:	75 14                	jne    8005ff <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005eb:	83 ec 04             	sub    $0x4,%esp
  8005ee:	68 d4 26 80 00       	push   $0x8026d4
  8005f3:	6a 3a                	push   $0x3a
  8005f5:	68 c8 26 80 00       	push   $0x8026c8
  8005fa:	e8 88 fe ff ff       	call   800487 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005ff:	ff 45 f0             	incl   -0x10(%ebp)
  800602:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800605:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800608:	0f 8c 2f ff ff ff    	jl     80053d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80060e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800615:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80061c:	eb 26                	jmp    800644 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80061e:	a1 20 30 80 00       	mov    0x803020,%eax
  800623:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800629:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80062c:	89 d0                	mov    %edx,%eax
  80062e:	01 c0                	add    %eax,%eax
  800630:	01 d0                	add    %edx,%eax
  800632:	c1 e0 03             	shl    $0x3,%eax
  800635:	01 c8                	add    %ecx,%eax
  800637:	8a 40 04             	mov    0x4(%eax),%al
  80063a:	3c 01                	cmp    $0x1,%al
  80063c:	75 03                	jne    800641 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80063e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800641:	ff 45 e0             	incl   -0x20(%ebp)
  800644:	a1 20 30 80 00       	mov    0x803020,%eax
  800649:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80064f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800652:	39 c2                	cmp    %eax,%edx
  800654:	77 c8                	ja     80061e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800659:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80065c:	74 14                	je     800672 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80065e:	83 ec 04             	sub    $0x4,%esp
  800661:	68 28 27 80 00       	push   $0x802728
  800666:	6a 44                	push   $0x44
  800668:	68 c8 26 80 00       	push   $0x8026c8
  80066d:	e8 15 fe ff ff       	call   800487 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800672:	90                   	nop
  800673:	c9                   	leave  
  800674:	c3                   	ret    

00800675 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800675:	55                   	push   %ebp
  800676:	89 e5                	mov    %esp,%ebp
  800678:	53                   	push   %ebx
  800679:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80067c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	8d 48 01             	lea    0x1(%eax),%ecx
  800684:	8b 55 0c             	mov    0xc(%ebp),%edx
  800687:	89 0a                	mov    %ecx,(%edx)
  800689:	8b 55 08             	mov    0x8(%ebp),%edx
  80068c:	88 d1                	mov    %dl,%cl
  80068e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800691:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800695:	8b 45 0c             	mov    0xc(%ebp),%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80069f:	75 30                	jne    8006d1 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006a1:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006a7:	a0 44 30 80 00       	mov    0x803044,%al
  8006ac:	0f b6 c0             	movzbl %al,%eax
  8006af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006b2:	8b 09                	mov    (%ecx),%ecx
  8006b4:	89 cb                	mov    %ecx,%ebx
  8006b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006b9:	83 c1 08             	add    $0x8,%ecx
  8006bc:	52                   	push   %edx
  8006bd:	50                   	push   %eax
  8006be:	53                   	push   %ebx
  8006bf:	51                   	push   %ecx
  8006c0:	e8 57 11 00 00       	call   80181c <sys_cputs>
  8006c5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d4:	8b 40 04             	mov    0x4(%eax),%eax
  8006d7:	8d 50 01             	lea    0x1(%eax),%edx
  8006da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006dd:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006e0:	90                   	nop
  8006e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006e4:	c9                   	leave  
  8006e5:	c3                   	ret    

008006e6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006e6:	55                   	push   %ebp
  8006e7:	89 e5                	mov    %esp,%ebp
  8006e9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006ef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006f6:	00 00 00 
	b.cnt = 0;
  8006f9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800700:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800703:	ff 75 0c             	pushl  0xc(%ebp)
  800706:	ff 75 08             	pushl  0x8(%ebp)
  800709:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80070f:	50                   	push   %eax
  800710:	68 75 06 80 00       	push   $0x800675
  800715:	e8 5a 02 00 00       	call   800974 <vprintfmt>
  80071a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80071d:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800723:	a0 44 30 80 00       	mov    0x803044,%al
  800728:	0f b6 c0             	movzbl %al,%eax
  80072b:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800731:	52                   	push   %edx
  800732:	50                   	push   %eax
  800733:	51                   	push   %ecx
  800734:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80073a:	83 c0 08             	add    $0x8,%eax
  80073d:	50                   	push   %eax
  80073e:	e8 d9 10 00 00       	call   80181c <sys_cputs>
  800743:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800746:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  80074d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800753:	c9                   	leave  
  800754:	c3                   	ret    

00800755 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800755:	55                   	push   %ebp
  800756:	89 e5                	mov    %esp,%ebp
  800758:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80075b:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800762:	8d 45 0c             	lea    0xc(%ebp),%eax
  800765:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
  80076b:	83 ec 08             	sub    $0x8,%esp
  80076e:	ff 75 f4             	pushl  -0xc(%ebp)
  800771:	50                   	push   %eax
  800772:	e8 6f ff ff ff       	call   8006e6 <vcprintf>
  800777:	83 c4 10             	add    $0x10,%esp
  80077a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80077d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800780:	c9                   	leave  
  800781:	c3                   	ret    

00800782 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800782:	55                   	push   %ebp
  800783:	89 e5                	mov    %esp,%ebp
  800785:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800788:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	c1 e0 08             	shl    $0x8,%eax
  800795:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  80079a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80079d:	83 c0 04             	add    $0x4,%eax
  8007a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a6:	83 ec 08             	sub    $0x8,%esp
  8007a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ac:	50                   	push   %eax
  8007ad:	e8 34 ff ff ff       	call   8006e6 <vcprintf>
  8007b2:	83 c4 10             	add    $0x10,%esp
  8007b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007b8:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8007bf:	07 00 00 

	return cnt;
  8007c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007c5:	c9                   	leave  
  8007c6:	c3                   	ret    

008007c7 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007c7:	55                   	push   %ebp
  8007c8:	89 e5                	mov    %esp,%ebp
  8007ca:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007cd:	e8 8e 10 00 00       	call   801860 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007d2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e1:	50                   	push   %eax
  8007e2:	e8 ff fe ff ff       	call   8006e6 <vcprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
  8007ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007ed:	e8 88 10 00 00       	call   80187a <sys_unlock_cons>
	return cnt;
  8007f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007f5:	c9                   	leave  
  8007f6:	c3                   	ret    

008007f7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007f7:	55                   	push   %ebp
  8007f8:	89 e5                	mov    %esp,%ebp
  8007fa:	53                   	push   %ebx
  8007fb:	83 ec 14             	sub    $0x14,%esp
  8007fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800801:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800804:	8b 45 14             	mov    0x14(%ebp),%eax
  800807:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80080a:	8b 45 18             	mov    0x18(%ebp),%eax
  80080d:	ba 00 00 00 00       	mov    $0x0,%edx
  800812:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800815:	77 55                	ja     80086c <printnum+0x75>
  800817:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80081a:	72 05                	jb     800821 <printnum+0x2a>
  80081c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80081f:	77 4b                	ja     80086c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800821:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800824:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800827:	8b 45 18             	mov    0x18(%ebp),%eax
  80082a:	ba 00 00 00 00       	mov    $0x0,%edx
  80082f:	52                   	push   %edx
  800830:	50                   	push   %eax
  800831:	ff 75 f4             	pushl  -0xc(%ebp)
  800834:	ff 75 f0             	pushl  -0x10(%ebp)
  800837:	e8 68 17 00 00       	call   801fa4 <__udivdi3>
  80083c:	83 c4 10             	add    $0x10,%esp
  80083f:	83 ec 04             	sub    $0x4,%esp
  800842:	ff 75 20             	pushl  0x20(%ebp)
  800845:	53                   	push   %ebx
  800846:	ff 75 18             	pushl  0x18(%ebp)
  800849:	52                   	push   %edx
  80084a:	50                   	push   %eax
  80084b:	ff 75 0c             	pushl  0xc(%ebp)
  80084e:	ff 75 08             	pushl  0x8(%ebp)
  800851:	e8 a1 ff ff ff       	call   8007f7 <printnum>
  800856:	83 c4 20             	add    $0x20,%esp
  800859:	eb 1a                	jmp    800875 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80085b:	83 ec 08             	sub    $0x8,%esp
  80085e:	ff 75 0c             	pushl  0xc(%ebp)
  800861:	ff 75 20             	pushl  0x20(%ebp)
  800864:	8b 45 08             	mov    0x8(%ebp),%eax
  800867:	ff d0                	call   *%eax
  800869:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80086c:	ff 4d 1c             	decl   0x1c(%ebp)
  80086f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800873:	7f e6                	jg     80085b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800875:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800878:	bb 00 00 00 00       	mov    $0x0,%ebx
  80087d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800880:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800883:	53                   	push   %ebx
  800884:	51                   	push   %ecx
  800885:	52                   	push   %edx
  800886:	50                   	push   %eax
  800887:	e8 28 18 00 00       	call   8020b4 <__umoddi3>
  80088c:	83 c4 10             	add    $0x10,%esp
  80088f:	05 94 29 80 00       	add    $0x802994,%eax
  800894:	8a 00                	mov    (%eax),%al
  800896:	0f be c0             	movsbl %al,%eax
  800899:	83 ec 08             	sub    $0x8,%esp
  80089c:	ff 75 0c             	pushl  0xc(%ebp)
  80089f:	50                   	push   %eax
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	ff d0                	call   *%eax
  8008a5:	83 c4 10             	add    $0x10,%esp
}
  8008a8:	90                   	nop
  8008a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008ac:	c9                   	leave  
  8008ad:	c3                   	ret    

008008ae <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008ae:	55                   	push   %ebp
  8008af:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008b1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008b5:	7e 1c                	jle    8008d3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	8b 00                	mov    (%eax),%eax
  8008bc:	8d 50 08             	lea    0x8(%eax),%edx
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	89 10                	mov    %edx,(%eax)
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	8b 00                	mov    (%eax),%eax
  8008c9:	83 e8 08             	sub    $0x8,%eax
  8008cc:	8b 50 04             	mov    0x4(%eax),%edx
  8008cf:	8b 00                	mov    (%eax),%eax
  8008d1:	eb 40                	jmp    800913 <getuint+0x65>
	else if (lflag)
  8008d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008d7:	74 1e                	je     8008f7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	8d 50 04             	lea    0x4(%eax),%edx
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	89 10                	mov    %edx,(%eax)
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	8b 00                	mov    (%eax),%eax
  8008eb:	83 e8 04             	sub    $0x4,%eax
  8008ee:	8b 00                	mov    (%eax),%eax
  8008f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f5:	eb 1c                	jmp    800913 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	8d 50 04             	lea    0x4(%eax),%edx
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	89 10                	mov    %edx,(%eax)
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	8b 00                	mov    (%eax),%eax
  800909:	83 e8 04             	sub    $0x4,%eax
  80090c:	8b 00                	mov    (%eax),%eax
  80090e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800913:	5d                   	pop    %ebp
  800914:	c3                   	ret    

00800915 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800918:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80091c:	7e 1c                	jle    80093a <getint+0x25>
		return va_arg(*ap, long long);
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	8d 50 08             	lea    0x8(%eax),%edx
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	89 10                	mov    %edx,(%eax)
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	8b 00                	mov    (%eax),%eax
  800930:	83 e8 08             	sub    $0x8,%eax
  800933:	8b 50 04             	mov    0x4(%eax),%edx
  800936:	8b 00                	mov    (%eax),%eax
  800938:	eb 38                	jmp    800972 <getint+0x5d>
	else if (lflag)
  80093a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80093e:	74 1a                	je     80095a <getint+0x45>
		return va_arg(*ap, long);
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	8b 00                	mov    (%eax),%eax
  800945:	8d 50 04             	lea    0x4(%eax),%edx
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	89 10                	mov    %edx,(%eax)
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	8b 00                	mov    (%eax),%eax
  800952:	83 e8 04             	sub    $0x4,%eax
  800955:	8b 00                	mov    (%eax),%eax
  800957:	99                   	cltd   
  800958:	eb 18                	jmp    800972 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	8b 00                	mov    (%eax),%eax
  80095f:	8d 50 04             	lea    0x4(%eax),%edx
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	89 10                	mov    %edx,(%eax)
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	8b 00                	mov    (%eax),%eax
  80096c:	83 e8 04             	sub    $0x4,%eax
  80096f:	8b 00                	mov    (%eax),%eax
  800971:	99                   	cltd   
}
  800972:	5d                   	pop    %ebp
  800973:	c3                   	ret    

00800974 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800974:	55                   	push   %ebp
  800975:	89 e5                	mov    %esp,%ebp
  800977:	56                   	push   %esi
  800978:	53                   	push   %ebx
  800979:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80097c:	eb 17                	jmp    800995 <vprintfmt+0x21>
			if (ch == '\0')
  80097e:	85 db                	test   %ebx,%ebx
  800980:	0f 84 c1 03 00 00    	je     800d47 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800986:	83 ec 08             	sub    $0x8,%esp
  800989:	ff 75 0c             	pushl  0xc(%ebp)
  80098c:	53                   	push   %ebx
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	ff d0                	call   *%eax
  800992:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800995:	8b 45 10             	mov    0x10(%ebp),%eax
  800998:	8d 50 01             	lea    0x1(%eax),%edx
  80099b:	89 55 10             	mov    %edx,0x10(%ebp)
  80099e:	8a 00                	mov    (%eax),%al
  8009a0:	0f b6 d8             	movzbl %al,%ebx
  8009a3:	83 fb 25             	cmp    $0x25,%ebx
  8009a6:	75 d6                	jne    80097e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009a8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009ac:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009b3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009ba:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009c1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009cb:	8d 50 01             	lea    0x1(%eax),%edx
  8009ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8009d1:	8a 00                	mov    (%eax),%al
  8009d3:	0f b6 d8             	movzbl %al,%ebx
  8009d6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009d9:	83 f8 5b             	cmp    $0x5b,%eax
  8009dc:	0f 87 3d 03 00 00    	ja     800d1f <vprintfmt+0x3ab>
  8009e2:	8b 04 85 b8 29 80 00 	mov    0x8029b8(,%eax,4),%eax
  8009e9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009eb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009ef:	eb d7                	jmp    8009c8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009f1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009f5:	eb d1                	jmp    8009c8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a01:	89 d0                	mov    %edx,%eax
  800a03:	c1 e0 02             	shl    $0x2,%eax
  800a06:	01 d0                	add    %edx,%eax
  800a08:	01 c0                	add    %eax,%eax
  800a0a:	01 d8                	add    %ebx,%eax
  800a0c:	83 e8 30             	sub    $0x30,%eax
  800a0f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a12:	8b 45 10             	mov    0x10(%ebp),%eax
  800a15:	8a 00                	mov    (%eax),%al
  800a17:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a1a:	83 fb 2f             	cmp    $0x2f,%ebx
  800a1d:	7e 3e                	jle    800a5d <vprintfmt+0xe9>
  800a1f:	83 fb 39             	cmp    $0x39,%ebx
  800a22:	7f 39                	jg     800a5d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a24:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a27:	eb d5                	jmp    8009fe <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a29:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2c:	83 c0 04             	add    $0x4,%eax
  800a2f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a32:	8b 45 14             	mov    0x14(%ebp),%eax
  800a35:	83 e8 04             	sub    $0x4,%eax
  800a38:	8b 00                	mov    (%eax),%eax
  800a3a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a3d:	eb 1f                	jmp    800a5e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a3f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a43:	79 83                	jns    8009c8 <vprintfmt+0x54>
				width = 0;
  800a45:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a4c:	e9 77 ff ff ff       	jmp    8009c8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a51:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a58:	e9 6b ff ff ff       	jmp    8009c8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a5d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a5e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a62:	0f 89 60 ff ff ff    	jns    8009c8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a6b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a6e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a75:	e9 4e ff ff ff       	jmp    8009c8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a7a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a7d:	e9 46 ff ff ff       	jmp    8009c8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a82:	8b 45 14             	mov    0x14(%ebp),%eax
  800a85:	83 c0 04             	add    $0x4,%eax
  800a88:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8e:	83 e8 04             	sub    $0x4,%eax
  800a91:	8b 00                	mov    (%eax),%eax
  800a93:	83 ec 08             	sub    $0x8,%esp
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	50                   	push   %eax
  800a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9d:	ff d0                	call   *%eax
  800a9f:	83 c4 10             	add    $0x10,%esp
			break;
  800aa2:	e9 9b 02 00 00       	jmp    800d42 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800aa7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aaa:	83 c0 04             	add    $0x4,%eax
  800aad:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab3:	83 e8 04             	sub    $0x4,%eax
  800ab6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ab8:	85 db                	test   %ebx,%ebx
  800aba:	79 02                	jns    800abe <vprintfmt+0x14a>
				err = -err;
  800abc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800abe:	83 fb 64             	cmp    $0x64,%ebx
  800ac1:	7f 0b                	jg     800ace <vprintfmt+0x15a>
  800ac3:	8b 34 9d 00 28 80 00 	mov    0x802800(,%ebx,4),%esi
  800aca:	85 f6                	test   %esi,%esi
  800acc:	75 19                	jne    800ae7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ace:	53                   	push   %ebx
  800acf:	68 a5 29 80 00       	push   $0x8029a5
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	ff 75 08             	pushl  0x8(%ebp)
  800ada:	e8 70 02 00 00       	call   800d4f <printfmt>
  800adf:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ae2:	e9 5b 02 00 00       	jmp    800d42 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ae7:	56                   	push   %esi
  800ae8:	68 ae 29 80 00       	push   $0x8029ae
  800aed:	ff 75 0c             	pushl  0xc(%ebp)
  800af0:	ff 75 08             	pushl  0x8(%ebp)
  800af3:	e8 57 02 00 00       	call   800d4f <printfmt>
  800af8:	83 c4 10             	add    $0x10,%esp
			break;
  800afb:	e9 42 02 00 00       	jmp    800d42 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b00:	8b 45 14             	mov    0x14(%ebp),%eax
  800b03:	83 c0 04             	add    $0x4,%eax
  800b06:	89 45 14             	mov    %eax,0x14(%ebp)
  800b09:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0c:	83 e8 04             	sub    $0x4,%eax
  800b0f:	8b 30                	mov    (%eax),%esi
  800b11:	85 f6                	test   %esi,%esi
  800b13:	75 05                	jne    800b1a <vprintfmt+0x1a6>
				p = "(null)";
  800b15:	be b1 29 80 00       	mov    $0x8029b1,%esi
			if (width > 0 && padc != '-')
  800b1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b1e:	7e 6d                	jle    800b8d <vprintfmt+0x219>
  800b20:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b24:	74 67                	je     800b8d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b29:	83 ec 08             	sub    $0x8,%esp
  800b2c:	50                   	push   %eax
  800b2d:	56                   	push   %esi
  800b2e:	e8 1e 03 00 00       	call   800e51 <strnlen>
  800b33:	83 c4 10             	add    $0x10,%esp
  800b36:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b39:	eb 16                	jmp    800b51 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b3b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b3f:	83 ec 08             	sub    $0x8,%esp
  800b42:	ff 75 0c             	pushl  0xc(%ebp)
  800b45:	50                   	push   %eax
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	ff d0                	call   *%eax
  800b4b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b4e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b51:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b55:	7f e4                	jg     800b3b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b57:	eb 34                	jmp    800b8d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b59:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b5d:	74 1c                	je     800b7b <vprintfmt+0x207>
  800b5f:	83 fb 1f             	cmp    $0x1f,%ebx
  800b62:	7e 05                	jle    800b69 <vprintfmt+0x1f5>
  800b64:	83 fb 7e             	cmp    $0x7e,%ebx
  800b67:	7e 12                	jle    800b7b <vprintfmt+0x207>
					putch('?', putdat);
  800b69:	83 ec 08             	sub    $0x8,%esp
  800b6c:	ff 75 0c             	pushl  0xc(%ebp)
  800b6f:	6a 3f                	push   $0x3f
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	ff d0                	call   *%eax
  800b76:	83 c4 10             	add    $0x10,%esp
  800b79:	eb 0f                	jmp    800b8a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b7b:	83 ec 08             	sub    $0x8,%esp
  800b7e:	ff 75 0c             	pushl  0xc(%ebp)
  800b81:	53                   	push   %ebx
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	ff d0                	call   *%eax
  800b87:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b8a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b8d:	89 f0                	mov    %esi,%eax
  800b8f:	8d 70 01             	lea    0x1(%eax),%esi
  800b92:	8a 00                	mov    (%eax),%al
  800b94:	0f be d8             	movsbl %al,%ebx
  800b97:	85 db                	test   %ebx,%ebx
  800b99:	74 24                	je     800bbf <vprintfmt+0x24b>
  800b9b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b9f:	78 b8                	js     800b59 <vprintfmt+0x1e5>
  800ba1:	ff 4d e0             	decl   -0x20(%ebp)
  800ba4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ba8:	79 af                	jns    800b59 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800baa:	eb 13                	jmp    800bbf <vprintfmt+0x24b>
				putch(' ', putdat);
  800bac:	83 ec 08             	sub    $0x8,%esp
  800baf:	ff 75 0c             	pushl  0xc(%ebp)
  800bb2:	6a 20                	push   $0x20
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	ff d0                	call   *%eax
  800bb9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bbc:	ff 4d e4             	decl   -0x1c(%ebp)
  800bbf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bc3:	7f e7                	jg     800bac <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bc5:	e9 78 01 00 00       	jmp    800d42 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bca:	83 ec 08             	sub    $0x8,%esp
  800bcd:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd0:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd3:	50                   	push   %eax
  800bd4:	e8 3c fd ff ff       	call   800915 <getint>
  800bd9:	83 c4 10             	add    $0x10,%esp
  800bdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bdf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800be2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be8:	85 d2                	test   %edx,%edx
  800bea:	79 23                	jns    800c0f <vprintfmt+0x29b>
				putch('-', putdat);
  800bec:	83 ec 08             	sub    $0x8,%esp
  800bef:	ff 75 0c             	pushl  0xc(%ebp)
  800bf2:	6a 2d                	push   $0x2d
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	ff d0                	call   *%eax
  800bf9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c02:	f7 d8                	neg    %eax
  800c04:	83 d2 00             	adc    $0x0,%edx
  800c07:	f7 da                	neg    %edx
  800c09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c0c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c0f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c16:	e9 bc 00 00 00       	jmp    800cd7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c1b:	83 ec 08             	sub    $0x8,%esp
  800c1e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c21:	8d 45 14             	lea    0x14(%ebp),%eax
  800c24:	50                   	push   %eax
  800c25:	e8 84 fc ff ff       	call   8008ae <getuint>
  800c2a:	83 c4 10             	add    $0x10,%esp
  800c2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c30:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c33:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c3a:	e9 98 00 00 00       	jmp    800cd7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c3f:	83 ec 08             	sub    $0x8,%esp
  800c42:	ff 75 0c             	pushl  0xc(%ebp)
  800c45:	6a 58                	push   $0x58
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	ff d0                	call   *%eax
  800c4c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c4f:	83 ec 08             	sub    $0x8,%esp
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	6a 58                	push   $0x58
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c5f:	83 ec 08             	sub    $0x8,%esp
  800c62:	ff 75 0c             	pushl  0xc(%ebp)
  800c65:	6a 58                	push   $0x58
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	ff d0                	call   *%eax
  800c6c:	83 c4 10             	add    $0x10,%esp
			break;
  800c6f:	e9 ce 00 00 00       	jmp    800d42 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c74:	83 ec 08             	sub    $0x8,%esp
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	6a 30                	push   $0x30
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	ff d0                	call   *%eax
  800c81:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c84:	83 ec 08             	sub    $0x8,%esp
  800c87:	ff 75 0c             	pushl  0xc(%ebp)
  800c8a:	6a 78                	push   $0x78
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	ff d0                	call   *%eax
  800c91:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c94:	8b 45 14             	mov    0x14(%ebp),%eax
  800c97:	83 c0 04             	add    $0x4,%eax
  800c9a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca0:	83 e8 04             	sub    $0x4,%eax
  800ca3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ca5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800caf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cb6:	eb 1f                	jmp    800cd7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cb8:	83 ec 08             	sub    $0x8,%esp
  800cbb:	ff 75 e8             	pushl  -0x18(%ebp)
  800cbe:	8d 45 14             	lea    0x14(%ebp),%eax
  800cc1:	50                   	push   %eax
  800cc2:	e8 e7 fb ff ff       	call   8008ae <getuint>
  800cc7:	83 c4 10             	add    $0x10,%esp
  800cca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ccd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cd0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cd7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cde:	83 ec 04             	sub    $0x4,%esp
  800ce1:	52                   	push   %edx
  800ce2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ce5:	50                   	push   %eax
  800ce6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ce9:	ff 75 f0             	pushl  -0x10(%ebp)
  800cec:	ff 75 0c             	pushl  0xc(%ebp)
  800cef:	ff 75 08             	pushl  0x8(%ebp)
  800cf2:	e8 00 fb ff ff       	call   8007f7 <printnum>
  800cf7:	83 c4 20             	add    $0x20,%esp
			break;
  800cfa:	eb 46                	jmp    800d42 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cfc:	83 ec 08             	sub    $0x8,%esp
  800cff:	ff 75 0c             	pushl  0xc(%ebp)
  800d02:	53                   	push   %ebx
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	ff d0                	call   *%eax
  800d08:	83 c4 10             	add    $0x10,%esp
			break;
  800d0b:	eb 35                	jmp    800d42 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d0d:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800d14:	eb 2c                	jmp    800d42 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d16:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800d1d:	eb 23                	jmp    800d42 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d1f:	83 ec 08             	sub    $0x8,%esp
  800d22:	ff 75 0c             	pushl  0xc(%ebp)
  800d25:	6a 25                	push   $0x25
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	ff d0                	call   *%eax
  800d2c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d2f:	ff 4d 10             	decl   0x10(%ebp)
  800d32:	eb 03                	jmp    800d37 <vprintfmt+0x3c3>
  800d34:	ff 4d 10             	decl   0x10(%ebp)
  800d37:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3a:	48                   	dec    %eax
  800d3b:	8a 00                	mov    (%eax),%al
  800d3d:	3c 25                	cmp    $0x25,%al
  800d3f:	75 f3                	jne    800d34 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d41:	90                   	nop
		}
	}
  800d42:	e9 35 fc ff ff       	jmp    80097c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d47:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d48:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d4b:	5b                   	pop    %ebx
  800d4c:	5e                   	pop    %esi
  800d4d:	5d                   	pop    %ebp
  800d4e:	c3                   	ret    

00800d4f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d4f:	55                   	push   %ebp
  800d50:	89 e5                	mov    %esp,%ebp
  800d52:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d55:	8d 45 10             	lea    0x10(%ebp),%eax
  800d58:	83 c0 04             	add    $0x4,%eax
  800d5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d61:	ff 75 f4             	pushl  -0xc(%ebp)
  800d64:	50                   	push   %eax
  800d65:	ff 75 0c             	pushl  0xc(%ebp)
  800d68:	ff 75 08             	pushl  0x8(%ebp)
  800d6b:	e8 04 fc ff ff       	call   800974 <vprintfmt>
  800d70:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d73:	90                   	nop
  800d74:	c9                   	leave  
  800d75:	c3                   	ret    

00800d76 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d76:	55                   	push   %ebp
  800d77:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7c:	8b 40 08             	mov    0x8(%eax),%eax
  800d7f:	8d 50 01             	lea    0x1(%eax),%edx
  800d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d85:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8b:	8b 10                	mov    (%eax),%edx
  800d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d90:	8b 40 04             	mov    0x4(%eax),%eax
  800d93:	39 c2                	cmp    %eax,%edx
  800d95:	73 12                	jae    800da9 <sprintputch+0x33>
		*b->buf++ = ch;
  800d97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9a:	8b 00                	mov    (%eax),%eax
  800d9c:	8d 48 01             	lea    0x1(%eax),%ecx
  800d9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da2:	89 0a                	mov    %ecx,(%edx)
  800da4:	8b 55 08             	mov    0x8(%ebp),%edx
  800da7:	88 10                	mov    %dl,(%eax)
}
  800da9:	90                   	nop
  800daa:	5d                   	pop    %ebp
  800dab:	c3                   	ret    

00800dac <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
  800db5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800db8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	01 d0                	add    %edx,%eax
  800dc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dcd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dd1:	74 06                	je     800dd9 <vsnprintf+0x2d>
  800dd3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd7:	7f 07                	jg     800de0 <vsnprintf+0x34>
		return -E_INVAL;
  800dd9:	b8 03 00 00 00       	mov    $0x3,%eax
  800dde:	eb 20                	jmp    800e00 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800de0:	ff 75 14             	pushl  0x14(%ebp)
  800de3:	ff 75 10             	pushl  0x10(%ebp)
  800de6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800de9:	50                   	push   %eax
  800dea:	68 76 0d 80 00       	push   $0x800d76
  800def:	e8 80 fb ff ff       	call   800974 <vprintfmt>
  800df4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800df7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dfa:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e00:	c9                   	leave  
  800e01:	c3                   	ret    

00800e02 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e08:	8d 45 10             	lea    0x10(%ebp),%eax
  800e0b:	83 c0 04             	add    $0x4,%eax
  800e0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e11:	8b 45 10             	mov    0x10(%ebp),%eax
  800e14:	ff 75 f4             	pushl  -0xc(%ebp)
  800e17:	50                   	push   %eax
  800e18:	ff 75 0c             	pushl  0xc(%ebp)
  800e1b:	ff 75 08             	pushl  0x8(%ebp)
  800e1e:	e8 89 ff ff ff       	call   800dac <vsnprintf>
  800e23:	83 c4 10             	add    $0x10,%esp
  800e26:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e2c:	c9                   	leave  
  800e2d:	c3                   	ret    

00800e2e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e3b:	eb 06                	jmp    800e43 <strlen+0x15>
		n++;
  800e3d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e40:	ff 45 08             	incl   0x8(%ebp)
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
  800e46:	8a 00                	mov    (%eax),%al
  800e48:	84 c0                	test   %al,%al
  800e4a:	75 f1                	jne    800e3d <strlen+0xf>
		n++;
	return n;
  800e4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e4f:	c9                   	leave  
  800e50:	c3                   	ret    

00800e51 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e51:	55                   	push   %ebp
  800e52:	89 e5                	mov    %esp,%ebp
  800e54:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e57:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e5e:	eb 09                	jmp    800e69 <strnlen+0x18>
		n++;
  800e60:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e63:	ff 45 08             	incl   0x8(%ebp)
  800e66:	ff 4d 0c             	decl   0xc(%ebp)
  800e69:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e6d:	74 09                	je     800e78 <strnlen+0x27>
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	8a 00                	mov    (%eax),%al
  800e74:	84 c0                	test   %al,%al
  800e76:	75 e8                	jne    800e60 <strnlen+0xf>
		n++;
	return n;
  800e78:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e89:	90                   	nop
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8d 50 01             	lea    0x1(%eax),%edx
  800e90:	89 55 08             	mov    %edx,0x8(%ebp)
  800e93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e96:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e99:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e9c:	8a 12                	mov    (%edx),%dl
  800e9e:	88 10                	mov    %dl,(%eax)
  800ea0:	8a 00                	mov    (%eax),%al
  800ea2:	84 c0                	test   %al,%al
  800ea4:	75 e4                	jne    800e8a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ea6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea9:	c9                   	leave  
  800eaa:	c3                   	ret    

00800eab <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
  800eae:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800eb7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ebe:	eb 1f                	jmp    800edf <strncpy+0x34>
		*dst++ = *src;
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	8d 50 01             	lea    0x1(%eax),%edx
  800ec6:	89 55 08             	mov    %edx,0x8(%ebp)
  800ec9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ecc:	8a 12                	mov    (%edx),%dl
  800ece:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ed0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed3:	8a 00                	mov    (%eax),%al
  800ed5:	84 c0                	test   %al,%al
  800ed7:	74 03                	je     800edc <strncpy+0x31>
			src++;
  800ed9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800edc:	ff 45 fc             	incl   -0x4(%ebp)
  800edf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ee5:	72 d9                	jb     800ec0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ee7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800eea:	c9                   	leave  
  800eeb:	c3                   	ret    

00800eec <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ef8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800efc:	74 30                	je     800f2e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800efe:	eb 16                	jmp    800f16 <strlcpy+0x2a>
			*dst++ = *src++;
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	8d 50 01             	lea    0x1(%eax),%edx
  800f06:	89 55 08             	mov    %edx,0x8(%ebp)
  800f09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f0c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f0f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f12:	8a 12                	mov    (%edx),%dl
  800f14:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f16:	ff 4d 10             	decl   0x10(%ebp)
  800f19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1d:	74 09                	je     800f28 <strlcpy+0x3c>
  800f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	84 c0                	test   %al,%al
  800f26:	75 d8                	jne    800f00 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f34:	29 c2                	sub    %eax,%edx
  800f36:	89 d0                	mov    %edx,%eax
}
  800f38:	c9                   	leave  
  800f39:	c3                   	ret    

00800f3a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f3d:	eb 06                	jmp    800f45 <strcmp+0xb>
		p++, q++;
  800f3f:	ff 45 08             	incl   0x8(%ebp)
  800f42:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f45:	8b 45 08             	mov    0x8(%ebp),%eax
  800f48:	8a 00                	mov    (%eax),%al
  800f4a:	84 c0                	test   %al,%al
  800f4c:	74 0e                	je     800f5c <strcmp+0x22>
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	8a 10                	mov    (%eax),%dl
  800f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	38 c2                	cmp    %al,%dl
  800f5a:	74 e3                	je     800f3f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	8a 00                	mov    (%eax),%al
  800f61:	0f b6 d0             	movzbl %al,%edx
  800f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	0f b6 c0             	movzbl %al,%eax
  800f6c:	29 c2                	sub    %eax,%edx
  800f6e:	89 d0                	mov    %edx,%eax
}
  800f70:	5d                   	pop    %ebp
  800f71:	c3                   	ret    

00800f72 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f72:	55                   	push   %ebp
  800f73:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f75:	eb 09                	jmp    800f80 <strncmp+0xe>
		n--, p++, q++;
  800f77:	ff 4d 10             	decl   0x10(%ebp)
  800f7a:	ff 45 08             	incl   0x8(%ebp)
  800f7d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f84:	74 17                	je     800f9d <strncmp+0x2b>
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	84 c0                	test   %al,%al
  800f8d:	74 0e                	je     800f9d <strncmp+0x2b>
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 10                	mov    (%eax),%dl
  800f94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f97:	8a 00                	mov    (%eax),%al
  800f99:	38 c2                	cmp    %al,%dl
  800f9b:	74 da                	je     800f77 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa1:	75 07                	jne    800faa <strncmp+0x38>
		return 0;
  800fa3:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa8:	eb 14                	jmp    800fbe <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	0f b6 d0             	movzbl %al,%edx
  800fb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb5:	8a 00                	mov    (%eax),%al
  800fb7:	0f b6 c0             	movzbl %al,%eax
  800fba:	29 c2                	sub    %eax,%edx
  800fbc:	89 d0                	mov    %edx,%eax
}
  800fbe:	5d                   	pop    %ebp
  800fbf:	c3                   	ret    

00800fc0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	83 ec 04             	sub    $0x4,%esp
  800fc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fcc:	eb 12                	jmp    800fe0 <strchr+0x20>
		if (*s == c)
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fd6:	75 05                	jne    800fdd <strchr+0x1d>
			return (char *) s;
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	eb 11                	jmp    800fee <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fdd:	ff 45 08             	incl   0x8(%ebp)
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	84 c0                	test   %al,%al
  800fe7:	75 e5                	jne    800fce <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fe9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fee:	c9                   	leave  
  800fef:	c3                   	ret    

00800ff0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ff0:	55                   	push   %ebp
  800ff1:	89 e5                	mov    %esp,%ebp
  800ff3:	83 ec 04             	sub    $0x4,%esp
  800ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ffc:	eb 0d                	jmp    80100b <strfind+0x1b>
		if (*s == c)
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801006:	74 0e                	je     801016 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801008:	ff 45 08             	incl   0x8(%ebp)
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	84 c0                	test   %al,%al
  801012:	75 ea                	jne    800ffe <strfind+0xe>
  801014:	eb 01                	jmp    801017 <strfind+0x27>
		if (*s == c)
			break;
  801016:	90                   	nop
	return (char *) s;
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80101a:	c9                   	leave  
  80101b:	c3                   	ret    

0080101c <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801028:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80102c:	76 63                	jbe    801091 <memset+0x75>
		uint64 data_block = c;
  80102e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801031:	99                   	cltd   
  801032:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801035:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801038:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80103b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103e:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801042:	c1 e0 08             	shl    $0x8,%eax
  801045:	09 45 f0             	or     %eax,-0x10(%ebp)
  801048:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80104b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80104e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801051:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801055:	c1 e0 10             	shl    $0x10,%eax
  801058:	09 45 f0             	or     %eax,-0x10(%ebp)
  80105b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80105e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801061:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801064:	89 c2                	mov    %eax,%edx
  801066:	b8 00 00 00 00       	mov    $0x0,%eax
  80106b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80106e:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801071:	eb 18                	jmp    80108b <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801073:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801076:	8d 41 08             	lea    0x8(%ecx),%eax
  801079:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80107c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80107f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801082:	89 01                	mov    %eax,(%ecx)
  801084:	89 51 04             	mov    %edx,0x4(%ecx)
  801087:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80108b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80108f:	77 e2                	ja     801073 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801091:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801095:	74 23                	je     8010ba <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801097:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80109d:	eb 0e                	jmp    8010ad <memset+0x91>
			*p8++ = (uint8)c;
  80109f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a2:	8d 50 01             	lea    0x1(%eax),%edx
  8010a5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ab:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b3:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b6:	85 c0                	test   %eax,%eax
  8010b8:	75 e5                	jne    80109f <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010bd:	c9                   	leave  
  8010be:	c3                   	ret    

008010bf <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
  8010c2:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010d1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010d5:	76 24                	jbe    8010fb <memcpy+0x3c>
		while(n >= 8){
  8010d7:	eb 1c                	jmp    8010f5 <memcpy+0x36>
			*d64 = *s64;
  8010d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010dc:	8b 50 04             	mov    0x4(%eax),%edx
  8010df:	8b 00                	mov    (%eax),%eax
  8010e1:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010e4:	89 01                	mov    %eax,(%ecx)
  8010e6:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010e9:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010ed:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010f1:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010f5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010f9:	77 de                	ja     8010d9 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ff:	74 31                	je     801132 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801101:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801104:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801107:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80110d:	eb 16                	jmp    801125 <memcpy+0x66>
			*d8++ = *s8++;
  80110f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801112:	8d 50 01             	lea    0x1(%eax),%edx
  801115:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801118:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80111e:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801121:	8a 12                	mov    (%edx),%dl
  801123:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801125:	8b 45 10             	mov    0x10(%ebp),%eax
  801128:	8d 50 ff             	lea    -0x1(%eax),%edx
  80112b:	89 55 10             	mov    %edx,0x10(%ebp)
  80112e:	85 c0                	test   %eax,%eax
  801130:	75 dd                	jne    80110f <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801135:	c9                   	leave  
  801136:	c3                   	ret    

00801137 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80113d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801140:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801149:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80114f:	73 50                	jae    8011a1 <memmove+0x6a>
  801151:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801154:	8b 45 10             	mov    0x10(%ebp),%eax
  801157:	01 d0                	add    %edx,%eax
  801159:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80115c:	76 43                	jbe    8011a1 <memmove+0x6a>
		s += n;
  80115e:	8b 45 10             	mov    0x10(%ebp),%eax
  801161:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801164:	8b 45 10             	mov    0x10(%ebp),%eax
  801167:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80116a:	eb 10                	jmp    80117c <memmove+0x45>
			*--d = *--s;
  80116c:	ff 4d f8             	decl   -0x8(%ebp)
  80116f:	ff 4d fc             	decl   -0x4(%ebp)
  801172:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801175:	8a 10                	mov    (%eax),%dl
  801177:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80117c:	8b 45 10             	mov    0x10(%ebp),%eax
  80117f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801182:	89 55 10             	mov    %edx,0x10(%ebp)
  801185:	85 c0                	test   %eax,%eax
  801187:	75 e3                	jne    80116c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801189:	eb 23                	jmp    8011ae <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80118b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118e:	8d 50 01             	lea    0x1(%eax),%edx
  801191:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801194:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801197:	8d 4a 01             	lea    0x1(%edx),%ecx
  80119a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80119d:	8a 12                	mov    (%edx),%dl
  80119f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8011aa:	85 c0                	test   %eax,%eax
  8011ac:	75 dd                	jne    80118b <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011b1:	c9                   	leave  
  8011b2:	c3                   	ret    

008011b3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011b3:	55                   	push   %ebp
  8011b4:	89 e5                	mov    %esp,%ebp
  8011b6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011c5:	eb 2a                	jmp    8011f1 <memcmp+0x3e>
		if (*s1 != *s2)
  8011c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ca:	8a 10                	mov    (%eax),%dl
  8011cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	38 c2                	cmp    %al,%dl
  8011d3:	74 16                	je     8011eb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	0f b6 d0             	movzbl %al,%edx
  8011dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	0f b6 c0             	movzbl %al,%eax
  8011e5:	29 c2                	sub    %eax,%edx
  8011e7:	89 d0                	mov    %edx,%eax
  8011e9:	eb 18                	jmp    801203 <memcmp+0x50>
		s1++, s2++;
  8011eb:	ff 45 fc             	incl   -0x4(%ebp)
  8011ee:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011f7:	89 55 10             	mov    %edx,0x10(%ebp)
  8011fa:	85 c0                	test   %eax,%eax
  8011fc:	75 c9                	jne    8011c7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801203:	c9                   	leave  
  801204:	c3                   	ret    

00801205 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80120b:	8b 55 08             	mov    0x8(%ebp),%edx
  80120e:	8b 45 10             	mov    0x10(%ebp),%eax
  801211:	01 d0                	add    %edx,%eax
  801213:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801216:	eb 15                	jmp    80122d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801218:	8b 45 08             	mov    0x8(%ebp),%eax
  80121b:	8a 00                	mov    (%eax),%al
  80121d:	0f b6 d0             	movzbl %al,%edx
  801220:	8b 45 0c             	mov    0xc(%ebp),%eax
  801223:	0f b6 c0             	movzbl %al,%eax
  801226:	39 c2                	cmp    %eax,%edx
  801228:	74 0d                	je     801237 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80122a:	ff 45 08             	incl   0x8(%ebp)
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801233:	72 e3                	jb     801218 <memfind+0x13>
  801235:	eb 01                	jmp    801238 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801237:	90                   	nop
	return (void *) s;
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80123b:	c9                   	leave  
  80123c:	c3                   	ret    

0080123d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
  801240:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801243:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80124a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801251:	eb 03                	jmp    801256 <strtol+0x19>
		s++;
  801253:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	8a 00                	mov    (%eax),%al
  80125b:	3c 20                	cmp    $0x20,%al
  80125d:	74 f4                	je     801253 <strtol+0x16>
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	3c 09                	cmp    $0x9,%al
  801266:	74 eb                	je     801253 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	8a 00                	mov    (%eax),%al
  80126d:	3c 2b                	cmp    $0x2b,%al
  80126f:	75 05                	jne    801276 <strtol+0x39>
		s++;
  801271:	ff 45 08             	incl   0x8(%ebp)
  801274:	eb 13                	jmp    801289 <strtol+0x4c>
	else if (*s == '-')
  801276:	8b 45 08             	mov    0x8(%ebp),%eax
  801279:	8a 00                	mov    (%eax),%al
  80127b:	3c 2d                	cmp    $0x2d,%al
  80127d:	75 0a                	jne    801289 <strtol+0x4c>
		s++, neg = 1;
  80127f:	ff 45 08             	incl   0x8(%ebp)
  801282:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801289:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80128d:	74 06                	je     801295 <strtol+0x58>
  80128f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801293:	75 20                	jne    8012b5 <strtol+0x78>
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	8a 00                	mov    (%eax),%al
  80129a:	3c 30                	cmp    $0x30,%al
  80129c:	75 17                	jne    8012b5 <strtol+0x78>
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	40                   	inc    %eax
  8012a2:	8a 00                	mov    (%eax),%al
  8012a4:	3c 78                	cmp    $0x78,%al
  8012a6:	75 0d                	jne    8012b5 <strtol+0x78>
		s += 2, base = 16;
  8012a8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012ac:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012b3:	eb 28                	jmp    8012dd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b9:	75 15                	jne    8012d0 <strtol+0x93>
  8012bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012be:	8a 00                	mov    (%eax),%al
  8012c0:	3c 30                	cmp    $0x30,%al
  8012c2:	75 0c                	jne    8012d0 <strtol+0x93>
		s++, base = 8;
  8012c4:	ff 45 08             	incl   0x8(%ebp)
  8012c7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012ce:	eb 0d                	jmp    8012dd <strtol+0xa0>
	else if (base == 0)
  8012d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012d4:	75 07                	jne    8012dd <strtol+0xa0>
		base = 10;
  8012d6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e0:	8a 00                	mov    (%eax),%al
  8012e2:	3c 2f                	cmp    $0x2f,%al
  8012e4:	7e 19                	jle    8012ff <strtol+0xc2>
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	8a 00                	mov    (%eax),%al
  8012eb:	3c 39                	cmp    $0x39,%al
  8012ed:	7f 10                	jg     8012ff <strtol+0xc2>
			dig = *s - '0';
  8012ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f2:	8a 00                	mov    (%eax),%al
  8012f4:	0f be c0             	movsbl %al,%eax
  8012f7:	83 e8 30             	sub    $0x30,%eax
  8012fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012fd:	eb 42                	jmp    801341 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801302:	8a 00                	mov    (%eax),%al
  801304:	3c 60                	cmp    $0x60,%al
  801306:	7e 19                	jle    801321 <strtol+0xe4>
  801308:	8b 45 08             	mov    0x8(%ebp),%eax
  80130b:	8a 00                	mov    (%eax),%al
  80130d:	3c 7a                	cmp    $0x7a,%al
  80130f:	7f 10                	jg     801321 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	8a 00                	mov    (%eax),%al
  801316:	0f be c0             	movsbl %al,%eax
  801319:	83 e8 57             	sub    $0x57,%eax
  80131c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80131f:	eb 20                	jmp    801341 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801321:	8b 45 08             	mov    0x8(%ebp),%eax
  801324:	8a 00                	mov    (%eax),%al
  801326:	3c 40                	cmp    $0x40,%al
  801328:	7e 39                	jle    801363 <strtol+0x126>
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
  80132d:	8a 00                	mov    (%eax),%al
  80132f:	3c 5a                	cmp    $0x5a,%al
  801331:	7f 30                	jg     801363 <strtol+0x126>
			dig = *s - 'A' + 10;
  801333:	8b 45 08             	mov    0x8(%ebp),%eax
  801336:	8a 00                	mov    (%eax),%al
  801338:	0f be c0             	movsbl %al,%eax
  80133b:	83 e8 37             	sub    $0x37,%eax
  80133e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801344:	3b 45 10             	cmp    0x10(%ebp),%eax
  801347:	7d 19                	jge    801362 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801349:	ff 45 08             	incl   0x8(%ebp)
  80134c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801353:	89 c2                	mov    %eax,%edx
  801355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801358:	01 d0                	add    %edx,%eax
  80135a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80135d:	e9 7b ff ff ff       	jmp    8012dd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801362:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801363:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801367:	74 08                	je     801371 <strtol+0x134>
		*endptr = (char *) s;
  801369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136c:	8b 55 08             	mov    0x8(%ebp),%edx
  80136f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801371:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801375:	74 07                	je     80137e <strtol+0x141>
  801377:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80137a:	f7 d8                	neg    %eax
  80137c:	eb 03                	jmp    801381 <strtol+0x144>
  80137e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801381:	c9                   	leave  
  801382:	c3                   	ret    

00801383 <ltostr>:

void
ltostr(long value, char *str)
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
  801386:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801389:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801390:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801397:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80139b:	79 13                	jns    8013b0 <ltostr+0x2d>
	{
		neg = 1;
  80139d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013aa:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013ad:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013b8:	99                   	cltd   
  8013b9:	f7 f9                	idiv   %ecx
  8013bb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c1:	8d 50 01             	lea    0x1(%eax),%edx
  8013c4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013c7:	89 c2                	mov    %eax,%edx
  8013c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cc:	01 d0                	add    %edx,%eax
  8013ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013d1:	83 c2 30             	add    $0x30,%edx
  8013d4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013d9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013de:	f7 e9                	imul   %ecx
  8013e0:	c1 fa 02             	sar    $0x2,%edx
  8013e3:	89 c8                	mov    %ecx,%eax
  8013e5:	c1 f8 1f             	sar    $0x1f,%eax
  8013e8:	29 c2                	sub    %eax,%edx
  8013ea:	89 d0                	mov    %edx,%eax
  8013ec:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013f3:	75 bb                	jne    8013b0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ff:	48                   	dec    %eax
  801400:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801403:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801407:	74 3d                	je     801446 <ltostr+0xc3>
		start = 1 ;
  801409:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801410:	eb 34                	jmp    801446 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801412:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801415:	8b 45 0c             	mov    0xc(%ebp),%eax
  801418:	01 d0                	add    %edx,%eax
  80141a:	8a 00                	mov    (%eax),%al
  80141c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80141f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801422:	8b 45 0c             	mov    0xc(%ebp),%eax
  801425:	01 c2                	add    %eax,%edx
  801427:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80142a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142d:	01 c8                	add    %ecx,%eax
  80142f:	8a 00                	mov    (%eax),%al
  801431:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801433:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801436:	8b 45 0c             	mov    0xc(%ebp),%eax
  801439:	01 c2                	add    %eax,%edx
  80143b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80143e:	88 02                	mov    %al,(%edx)
		start++ ;
  801440:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801443:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801449:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80144c:	7c c4                	jl     801412 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80144e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801451:	8b 45 0c             	mov    0xc(%ebp),%eax
  801454:	01 d0                	add    %edx,%eax
  801456:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801459:	90                   	nop
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801462:	ff 75 08             	pushl  0x8(%ebp)
  801465:	e8 c4 f9 ff ff       	call   800e2e <strlen>
  80146a:	83 c4 04             	add    $0x4,%esp
  80146d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801470:	ff 75 0c             	pushl  0xc(%ebp)
  801473:	e8 b6 f9 ff ff       	call   800e2e <strlen>
  801478:	83 c4 04             	add    $0x4,%esp
  80147b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80147e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801485:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80148c:	eb 17                	jmp    8014a5 <strcconcat+0x49>
		final[s] = str1[s] ;
  80148e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801491:	8b 45 10             	mov    0x10(%ebp),%eax
  801494:	01 c2                	add    %eax,%edx
  801496:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	01 c8                	add    %ecx,%eax
  80149e:	8a 00                	mov    (%eax),%al
  8014a0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014a2:	ff 45 fc             	incl   -0x4(%ebp)
  8014a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014a8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014ab:	7c e1                	jl     80148e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014ad:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014bb:	eb 1f                	jmp    8014dc <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c0:	8d 50 01             	lea    0x1(%eax),%edx
  8014c3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014c6:	89 c2                	mov    %eax,%edx
  8014c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cb:	01 c2                	add    %eax,%edx
  8014cd:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d3:	01 c8                	add    %ecx,%eax
  8014d5:	8a 00                	mov    (%eax),%al
  8014d7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014d9:	ff 45 f8             	incl   -0x8(%ebp)
  8014dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014e2:	7c d9                	jl     8014bd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ea:	01 d0                	add    %edx,%eax
  8014ec:	c6 00 00             	movb   $0x0,(%eax)
}
  8014ef:	90                   	nop
  8014f0:	c9                   	leave  
  8014f1:	c3                   	ret    

008014f2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014f2:	55                   	push   %ebp
  8014f3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801501:	8b 00                	mov    (%eax),%eax
  801503:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80150a:	8b 45 10             	mov    0x10(%ebp),%eax
  80150d:	01 d0                	add    %edx,%eax
  80150f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801515:	eb 0c                	jmp    801523 <strsplit+0x31>
			*string++ = 0;
  801517:	8b 45 08             	mov    0x8(%ebp),%eax
  80151a:	8d 50 01             	lea    0x1(%eax),%edx
  80151d:	89 55 08             	mov    %edx,0x8(%ebp)
  801520:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	8a 00                	mov    (%eax),%al
  801528:	84 c0                	test   %al,%al
  80152a:	74 18                	je     801544 <strsplit+0x52>
  80152c:	8b 45 08             	mov    0x8(%ebp),%eax
  80152f:	8a 00                	mov    (%eax),%al
  801531:	0f be c0             	movsbl %al,%eax
  801534:	50                   	push   %eax
  801535:	ff 75 0c             	pushl  0xc(%ebp)
  801538:	e8 83 fa ff ff       	call   800fc0 <strchr>
  80153d:	83 c4 08             	add    $0x8,%esp
  801540:	85 c0                	test   %eax,%eax
  801542:	75 d3                	jne    801517 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	8a 00                	mov    (%eax),%al
  801549:	84 c0                	test   %al,%al
  80154b:	74 5a                	je     8015a7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80154d:	8b 45 14             	mov    0x14(%ebp),%eax
  801550:	8b 00                	mov    (%eax),%eax
  801552:	83 f8 0f             	cmp    $0xf,%eax
  801555:	75 07                	jne    80155e <strsplit+0x6c>
		{
			return 0;
  801557:	b8 00 00 00 00       	mov    $0x0,%eax
  80155c:	eb 66                	jmp    8015c4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80155e:	8b 45 14             	mov    0x14(%ebp),%eax
  801561:	8b 00                	mov    (%eax),%eax
  801563:	8d 48 01             	lea    0x1(%eax),%ecx
  801566:	8b 55 14             	mov    0x14(%ebp),%edx
  801569:	89 0a                	mov    %ecx,(%edx)
  80156b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801572:	8b 45 10             	mov    0x10(%ebp),%eax
  801575:	01 c2                	add    %eax,%edx
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80157c:	eb 03                	jmp    801581 <strsplit+0x8f>
			string++;
  80157e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801581:	8b 45 08             	mov    0x8(%ebp),%eax
  801584:	8a 00                	mov    (%eax),%al
  801586:	84 c0                	test   %al,%al
  801588:	74 8b                	je     801515 <strsplit+0x23>
  80158a:	8b 45 08             	mov    0x8(%ebp),%eax
  80158d:	8a 00                	mov    (%eax),%al
  80158f:	0f be c0             	movsbl %al,%eax
  801592:	50                   	push   %eax
  801593:	ff 75 0c             	pushl  0xc(%ebp)
  801596:	e8 25 fa ff ff       	call   800fc0 <strchr>
  80159b:	83 c4 08             	add    $0x8,%esp
  80159e:	85 c0                	test   %eax,%eax
  8015a0:	74 dc                	je     80157e <strsplit+0x8c>
			string++;
	}
  8015a2:	e9 6e ff ff ff       	jmp    801515 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015a7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ab:	8b 00                	mov    (%eax),%eax
  8015ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b7:	01 d0                	add    %edx,%eax
  8015b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015bf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015c4:	c9                   	leave  
  8015c5:	c3                   	ret    

008015c6 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015d9:	eb 4a                	jmp    801625 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015de:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e1:	01 c2                	add    %eax,%edx
  8015e3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e9:	01 c8                	add    %ecx,%eax
  8015eb:	8a 00                	mov    (%eax),%al
  8015ed:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f5:	01 d0                	add    %edx,%eax
  8015f7:	8a 00                	mov    (%eax),%al
  8015f9:	3c 40                	cmp    $0x40,%al
  8015fb:	7e 25                	jle    801622 <str2lower+0x5c>
  8015fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801600:	8b 45 0c             	mov    0xc(%ebp),%eax
  801603:	01 d0                	add    %edx,%eax
  801605:	8a 00                	mov    (%eax),%al
  801607:	3c 5a                	cmp    $0x5a,%al
  801609:	7f 17                	jg     801622 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80160b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160e:	8b 45 08             	mov    0x8(%ebp),%eax
  801611:	01 d0                	add    %edx,%eax
  801613:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801616:	8b 55 08             	mov    0x8(%ebp),%edx
  801619:	01 ca                	add    %ecx,%edx
  80161b:	8a 12                	mov    (%edx),%dl
  80161d:	83 c2 20             	add    $0x20,%edx
  801620:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801622:	ff 45 fc             	incl   -0x4(%ebp)
  801625:	ff 75 0c             	pushl  0xc(%ebp)
  801628:	e8 01 f8 ff ff       	call   800e2e <strlen>
  80162d:	83 c4 04             	add    $0x4,%esp
  801630:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801633:	7f a6                	jg     8015db <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801635:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801640:	a1 08 30 80 00       	mov    0x803008,%eax
  801645:	85 c0                	test   %eax,%eax
  801647:	74 42                	je     80168b <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801649:	83 ec 08             	sub    $0x8,%esp
  80164c:	68 00 00 00 82       	push   $0x82000000
  801651:	68 00 00 00 80       	push   $0x80000000
  801656:	e8 8c 07 00 00       	call   801de7 <initialize_dynamic_allocator>
  80165b:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80165e:	e8 e7 05 00 00       	call   801c4a <sys_get_uheap_strategy>
  801663:	a3 60 b0 81 00       	mov    %eax,0x81b060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801668:	a1 40 30 80 00       	mov    0x803040,%eax
  80166d:	05 00 10 00 00       	add    $0x1000,%eax
  801672:	a3 10 b1 81 00       	mov    %eax,0x81b110
		uheapPageAllocBreak = uheapPageAllocStart;
  801677:	a1 10 b1 81 00       	mov    0x81b110,%eax
  80167c:	a3 68 b0 81 00       	mov    %eax,0x81b068

		__firstTimeFlag = 0;
  801681:	c7 05 08 30 80 00 00 	movl   $0x0,0x803008
  801688:	00 00 00 
	}
}
  80168b:	90                   	nop
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801694:	8b 45 08             	mov    0x8(%ebp),%eax
  801697:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80169a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016a2:	83 ec 08             	sub    $0x8,%esp
  8016a5:	68 06 04 00 00       	push   $0x406
  8016aa:	50                   	push   %eax
  8016ab:	e8 e4 01 00 00       	call   801894 <__sys_allocate_page>
  8016b0:	83 c4 10             	add    $0x10,%esp
  8016b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016ba:	79 14                	jns    8016d0 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8016bc:	83 ec 04             	sub    $0x4,%esp
  8016bf:	68 28 2b 80 00       	push   $0x802b28
  8016c4:	6a 1f                	push   $0x1f
  8016c6:	68 64 2b 80 00       	push   $0x802b64
  8016cb:	e8 b7 ed ff ff       	call   800487 <_panic>
	return 0;
  8016d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016eb:	83 ec 0c             	sub    $0xc,%esp
  8016ee:	50                   	push   %eax
  8016ef:	e8 e7 01 00 00       	call   8018db <__sys_unmap_frame>
  8016f4:	83 c4 10             	add    $0x10,%esp
  8016f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016fe:	79 14                	jns    801714 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801700:	83 ec 04             	sub    $0x4,%esp
  801703:	68 70 2b 80 00       	push   $0x802b70
  801708:	6a 2a                	push   $0x2a
  80170a:	68 64 2b 80 00       	push   $0x802b64
  80170f:	e8 73 ed ff ff       	call   800487 <_panic>
}
  801714:	90                   	nop
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80171d:	e8 18 ff ff ff       	call   80163a <uheap_init>
	if (size == 0) return NULL ;
  801722:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801726:	75 07                	jne    80172f <malloc+0x18>
  801728:	b8 00 00 00 00       	mov    $0x0,%eax
  80172d:	eb 14                	jmp    801743 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  80172f:	83 ec 04             	sub    $0x4,%esp
  801732:	68 b0 2b 80 00       	push   $0x802bb0
  801737:	6a 3e                	push   $0x3e
  801739:	68 64 2b 80 00       	push   $0x802b64
  80173e:	e8 44 ed ff ff       	call   800487 <_panic>
}
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  80174b:	83 ec 04             	sub    $0x4,%esp
  80174e:	68 d8 2b 80 00       	push   $0x802bd8
  801753:	6a 49                	push   $0x49
  801755:	68 64 2b 80 00       	push   $0x802b64
  80175a:	e8 28 ed ff ff       	call   800487 <_panic>

0080175f <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
  801762:	83 ec 18             	sub    $0x18,%esp
  801765:	8b 45 10             	mov    0x10(%ebp),%eax
  801768:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80176b:	e8 ca fe ff ff       	call   80163a <uheap_init>
	if (size == 0) return NULL ;
  801770:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801774:	75 07                	jne    80177d <smalloc+0x1e>
  801776:	b8 00 00 00 00       	mov    $0x0,%eax
  80177b:	eb 14                	jmp    801791 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  80177d:	83 ec 04             	sub    $0x4,%esp
  801780:	68 fc 2b 80 00       	push   $0x802bfc
  801785:	6a 5a                	push   $0x5a
  801787:	68 64 2b 80 00       	push   $0x802b64
  80178c:	e8 f6 ec ff ff       	call   800487 <_panic>
}
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
  801796:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801799:	e8 9c fe ff ff       	call   80163a <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  80179e:	83 ec 04             	sub    $0x4,%esp
  8017a1:	68 24 2c 80 00       	push   $0x802c24
  8017a6:	6a 6a                	push   $0x6a
  8017a8:	68 64 2b 80 00       	push   $0x802b64
  8017ad:	e8 d5 ec ff ff       	call   800487 <_panic>

008017b2 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
  8017b5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8017b8:	e8 7d fe ff ff       	call   80163a <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8017bd:	83 ec 04             	sub    $0x4,%esp
  8017c0:	68 48 2c 80 00       	push   $0x802c48
  8017c5:	68 88 00 00 00       	push   $0x88
  8017ca:	68 64 2b 80 00       	push   $0x802b64
  8017cf:	e8 b3 ec ff ff       	call   800487 <_panic>

008017d4 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8017da:	83 ec 04             	sub    $0x4,%esp
  8017dd:	68 70 2c 80 00       	push   $0x802c70
  8017e2:	68 9b 00 00 00       	push   $0x9b
  8017e7:	68 64 2b 80 00       	push   $0x802b64
  8017ec:	e8 96 ec ff ff       	call   800487 <_panic>

008017f1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
  8017f4:	57                   	push   %edi
  8017f5:	56                   	push   %esi
  8017f6:	53                   	push   %ebx
  8017f7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801800:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801803:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801806:	8b 7d 18             	mov    0x18(%ebp),%edi
  801809:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80180c:	cd 30                	int    $0x30
  80180e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801811:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801814:	83 c4 10             	add    $0x10,%esp
  801817:	5b                   	pop    %ebx
  801818:	5e                   	pop    %esi
  801819:	5f                   	pop    %edi
  80181a:	5d                   	pop    %ebp
  80181b:	c3                   	ret    

0080181c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 04             	sub    $0x4,%esp
  801822:	8b 45 10             	mov    0x10(%ebp),%eax
  801825:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801828:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80182b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	6a 00                	push   $0x0
  801834:	51                   	push   %ecx
  801835:	52                   	push   %edx
  801836:	ff 75 0c             	pushl  0xc(%ebp)
  801839:	50                   	push   %eax
  80183a:	6a 00                	push   $0x0
  80183c:	e8 b0 ff ff ff       	call   8017f1 <syscall>
  801841:	83 c4 18             	add    $0x18,%esp
}
  801844:	90                   	nop
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <sys_cgetc>:

int
sys_cgetc(void)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 02                	push   $0x2
  801856:	e8 96 ff ff ff       	call   8017f1 <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 03                	push   $0x3
  80186f:	e8 7d ff ff ff       	call   8017f1 <syscall>
  801874:	83 c4 18             	add    $0x18,%esp
}
  801877:	90                   	nop
  801878:	c9                   	leave  
  801879:	c3                   	ret    

0080187a <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 04                	push   $0x4
  801889:	e8 63 ff ff ff       	call   8017f1 <syscall>
  80188e:	83 c4 18             	add    $0x18,%esp
}
  801891:	90                   	nop
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801897:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189a:	8b 45 08             	mov    0x8(%ebp),%eax
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	52                   	push   %edx
  8018a4:	50                   	push   %eax
  8018a5:	6a 08                	push   $0x8
  8018a7:	e8 45 ff ff ff       	call   8017f1 <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp
}
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
  8018b4:	56                   	push   %esi
  8018b5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018b6:	8b 75 18             	mov    0x18(%ebp),%esi
  8018b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c5:	56                   	push   %esi
  8018c6:	53                   	push   %ebx
  8018c7:	51                   	push   %ecx
  8018c8:	52                   	push   %edx
  8018c9:	50                   	push   %eax
  8018ca:	6a 09                	push   $0x9
  8018cc:	e8 20 ff ff ff       	call   8017f1 <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
}
  8018d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d7:	5b                   	pop    %ebx
  8018d8:	5e                   	pop    %esi
  8018d9:	5d                   	pop    %ebp
  8018da:	c3                   	ret    

008018db <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	ff 75 08             	pushl  0x8(%ebp)
  8018e9:	6a 0a                	push   $0xa
  8018eb:	e8 01 ff ff ff       	call   8017f1 <syscall>
  8018f0:	83 c4 18             	add    $0x18,%esp
}
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	ff 75 0c             	pushl  0xc(%ebp)
  801901:	ff 75 08             	pushl  0x8(%ebp)
  801904:	6a 0b                	push   $0xb
  801906:	e8 e6 fe ff ff       	call   8017f1 <syscall>
  80190b:	83 c4 18             	add    $0x18,%esp
}
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 0c                	push   $0xc
  80191f:	e8 cd fe ff ff       	call   8017f1 <syscall>
  801924:	83 c4 18             	add    $0x18,%esp
}
  801927:	c9                   	leave  
  801928:	c3                   	ret    

00801929 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 0d                	push   $0xd
  801938:	e8 b4 fe ff ff       	call   8017f1 <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 0e                	push   $0xe
  801951:	e8 9b fe ff ff       	call   8017f1 <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 0f                	push   $0xf
  80196a:	e8 82 fe ff ff       	call   8017f1 <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	ff 75 08             	pushl  0x8(%ebp)
  801982:	6a 10                	push   $0x10
  801984:	e8 68 fe ff ff       	call   8017f1 <syscall>
  801989:	83 c4 18             	add    $0x18,%esp
}
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 11                	push   $0x11
  80199d:	e8 4f fe ff ff       	call   8017f1 <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	90                   	nop
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <sys_cputc>:

void
sys_cputc(const char c)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
  8019ab:	83 ec 04             	sub    $0x4,%esp
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019b4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	50                   	push   %eax
  8019c1:	6a 01                	push   $0x1
  8019c3:	e8 29 fe ff ff       	call   8017f1 <syscall>
  8019c8:	83 c4 18             	add    $0x18,%esp
}
  8019cb:	90                   	nop
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 14                	push   $0x14
  8019dd:	e8 0f fe ff ff       	call   8017f1 <syscall>
  8019e2:	83 c4 18             	add    $0x18,%esp
}
  8019e5:	90                   	nop
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	83 ec 04             	sub    $0x4,%esp
  8019ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019f4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019f7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fe:	6a 00                	push   $0x0
  801a00:	51                   	push   %ecx
  801a01:	52                   	push   %edx
  801a02:	ff 75 0c             	pushl  0xc(%ebp)
  801a05:	50                   	push   %eax
  801a06:	6a 15                	push   $0x15
  801a08:	e8 e4 fd ff ff       	call   8017f1 <syscall>
  801a0d:	83 c4 18             	add    $0x18,%esp
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	52                   	push   %edx
  801a22:	50                   	push   %eax
  801a23:	6a 16                	push   $0x16
  801a25:	e8 c7 fd ff ff       	call   8017f1 <syscall>
  801a2a:	83 c4 18             	add    $0x18,%esp
}
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a32:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	51                   	push   %ecx
  801a40:	52                   	push   %edx
  801a41:	50                   	push   %eax
  801a42:	6a 17                	push   $0x17
  801a44:	e8 a8 fd ff ff       	call   8017f1 <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
}
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	52                   	push   %edx
  801a5e:	50                   	push   %eax
  801a5f:	6a 18                	push   $0x18
  801a61:	e8 8b fd ff ff       	call   8017f1 <syscall>
  801a66:	83 c4 18             	add    $0x18,%esp
}
  801a69:	c9                   	leave  
  801a6a:	c3                   	ret    

00801a6b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	6a 00                	push   $0x0
  801a73:	ff 75 14             	pushl  0x14(%ebp)
  801a76:	ff 75 10             	pushl  0x10(%ebp)
  801a79:	ff 75 0c             	pushl  0xc(%ebp)
  801a7c:	50                   	push   %eax
  801a7d:	6a 19                	push   $0x19
  801a7f:	e8 6d fd ff ff       	call   8017f1 <syscall>
  801a84:	83 c4 18             	add    $0x18,%esp
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	50                   	push   %eax
  801a98:	6a 1a                	push   $0x1a
  801a9a:	e8 52 fd ff ff       	call   8017f1 <syscall>
  801a9f:	83 c4 18             	add    $0x18,%esp
}
  801aa2:	90                   	nop
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	50                   	push   %eax
  801ab4:	6a 1b                	push   $0x1b
  801ab6:	e8 36 fd ff ff       	call   8017f1 <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 05                	push   $0x5
  801acf:	e8 1d fd ff ff       	call   8017f1 <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
}
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 06                	push   $0x6
  801ae8:	e8 04 fd ff ff       	call   8017f1 <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 07                	push   $0x7
  801b01:	e8 eb fc ff ff       	call   8017f1 <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <sys_exit_env>:


void sys_exit_env(void)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 1c                	push   $0x1c
  801b1a:	e8 d2 fc ff ff       	call   8017f1 <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
}
  801b22:	90                   	nop
  801b23:	c9                   	leave  
  801b24:	c3                   	ret    

00801b25 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
  801b28:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b2b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b2e:	8d 50 04             	lea    0x4(%eax),%edx
  801b31:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	52                   	push   %edx
  801b3b:	50                   	push   %eax
  801b3c:	6a 1d                	push   $0x1d
  801b3e:	e8 ae fc ff ff       	call   8017f1 <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
	return result;
  801b46:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b49:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b4c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b4f:	89 01                	mov    %eax,(%ecx)
  801b51:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	c9                   	leave  
  801b58:	c2 04 00             	ret    $0x4

00801b5b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	ff 75 10             	pushl  0x10(%ebp)
  801b65:	ff 75 0c             	pushl  0xc(%ebp)
  801b68:	ff 75 08             	pushl  0x8(%ebp)
  801b6b:	6a 13                	push   $0x13
  801b6d:	e8 7f fc ff ff       	call   8017f1 <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
	return ;
  801b75:	90                   	nop
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 1e                	push   $0x1e
  801b87:	e8 65 fc ff ff       	call   8017f1 <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
  801b94:	83 ec 04             	sub    $0x4,%esp
  801b97:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b9d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	50                   	push   %eax
  801baa:	6a 1f                	push   $0x1f
  801bac:	e8 40 fc ff ff       	call   8017f1 <syscall>
  801bb1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb4:	90                   	nop
}
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <rsttst>:
void rsttst()
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 21                	push   $0x21
  801bc6:	e8 26 fc ff ff       	call   8017f1 <syscall>
  801bcb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bce:	90                   	nop
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
  801bd4:	83 ec 04             	sub    $0x4,%esp
  801bd7:	8b 45 14             	mov    0x14(%ebp),%eax
  801bda:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bdd:	8b 55 18             	mov    0x18(%ebp),%edx
  801be0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801be4:	52                   	push   %edx
  801be5:	50                   	push   %eax
  801be6:	ff 75 10             	pushl  0x10(%ebp)
  801be9:	ff 75 0c             	pushl  0xc(%ebp)
  801bec:	ff 75 08             	pushl  0x8(%ebp)
  801bef:	6a 20                	push   $0x20
  801bf1:	e8 fb fb ff ff       	call   8017f1 <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf9:	90                   	nop
}
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <chktst>:
void chktst(uint32 n)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	ff 75 08             	pushl  0x8(%ebp)
  801c0a:	6a 22                	push   $0x22
  801c0c:	e8 e0 fb ff ff       	call   8017f1 <syscall>
  801c11:	83 c4 18             	add    $0x18,%esp
	return ;
  801c14:	90                   	nop
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <inctst>:

void inctst()
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 23                	push   $0x23
  801c26:	e8 c6 fb ff ff       	call   8017f1 <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2e:	90                   	nop
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <gettst>:
uint32 gettst()
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 24                	push   $0x24
  801c40:	e8 ac fb ff ff       	call   8017f1 <syscall>
  801c45:	83 c4 18             	add    $0x18,%esp
}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 25                	push   $0x25
  801c59:	e8 93 fb ff ff       	call   8017f1 <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
  801c61:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801c66:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801c6b:	c9                   	leave  
  801c6c:	c3                   	ret    

00801c6d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801c70:	8b 45 08             	mov    0x8(%ebp),%eax
  801c73:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	ff 75 08             	pushl  0x8(%ebp)
  801c83:	6a 26                	push   $0x26
  801c85:	e8 67 fb ff ff       	call   8017f1 <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8d:	90                   	nop
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c94:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c97:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca0:	6a 00                	push   $0x0
  801ca2:	53                   	push   %ebx
  801ca3:	51                   	push   %ecx
  801ca4:	52                   	push   %edx
  801ca5:	50                   	push   %eax
  801ca6:	6a 27                	push   $0x27
  801ca8:	e8 44 fb ff ff       	call   8017f1 <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
}
  801cb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	52                   	push   %edx
  801cc5:	50                   	push   %eax
  801cc6:	6a 28                	push   $0x28
  801cc8:	e8 24 fb ff ff       	call   8017f1 <syscall>
  801ccd:	83 c4 18             	add    $0x18,%esp
}
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801cd5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cde:	6a 00                	push   $0x0
  801ce0:	51                   	push   %ecx
  801ce1:	ff 75 10             	pushl  0x10(%ebp)
  801ce4:	52                   	push   %edx
  801ce5:	50                   	push   %eax
  801ce6:	6a 29                	push   $0x29
  801ce8:	e8 04 fb ff ff       	call   8017f1 <syscall>
  801ced:	83 c4 18             	add    $0x18,%esp
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	ff 75 10             	pushl  0x10(%ebp)
  801cfc:	ff 75 0c             	pushl  0xc(%ebp)
  801cff:	ff 75 08             	pushl  0x8(%ebp)
  801d02:	6a 12                	push   $0x12
  801d04:	e8 e8 fa ff ff       	call   8017f1 <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0c:	90                   	nop
}
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d15:	8b 45 08             	mov    0x8(%ebp),%eax
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	52                   	push   %edx
  801d1f:	50                   	push   %eax
  801d20:	6a 2a                	push   $0x2a
  801d22:	e8 ca fa ff ff       	call   8017f1 <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
	return;
  801d2a:	90                   	nop
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 2b                	push   $0x2b
  801d3c:	e8 b0 fa ff ff       	call   8017f1 <syscall>
  801d41:	83 c4 18             	add    $0x18,%esp
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	ff 75 0c             	pushl  0xc(%ebp)
  801d52:	ff 75 08             	pushl  0x8(%ebp)
  801d55:	6a 2d                	push   $0x2d
  801d57:	e8 95 fa ff ff       	call   8017f1 <syscall>
  801d5c:	83 c4 18             	add    $0x18,%esp
	return;
  801d5f:	90                   	nop
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	ff 75 0c             	pushl  0xc(%ebp)
  801d6e:	ff 75 08             	pushl  0x8(%ebp)
  801d71:	6a 2c                	push   $0x2c
  801d73:	e8 79 fa ff ff       	call   8017f1 <syscall>
  801d78:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7b:	90                   	nop
}
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
  801d81:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801d84:	83 ec 04             	sub    $0x4,%esp
  801d87:	68 94 2c 80 00       	push   $0x802c94
  801d8c:	68 25 01 00 00       	push   $0x125
  801d91:	68 c7 2c 80 00       	push   $0x802cc7
  801d96:	e8 ec e6 ff ff       	call   800487 <_panic>

00801d9b <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801da1:	8b 45 08             	mov    0x8(%ebp),%eax
  801da4:	ba 60 30 80 00       	mov    $0x803060,%edx
  801da9:	29 d0                	sub    %edx,%eax
  801dab:	c1 f8 02             	sar    $0x2,%eax
  801dae:	89 c2                	mov    %eax,%edx
  801db0:	89 d0                	mov    %edx,%eax
  801db2:	c1 e0 02             	shl    $0x2,%eax
  801db5:	01 d0                	add    %edx,%eax
  801db7:	c1 e0 02             	shl    $0x2,%eax
  801dba:	01 d0                	add    %edx,%eax
  801dbc:	c1 e0 02             	shl    $0x2,%eax
  801dbf:	01 d0                	add    %edx,%eax
  801dc1:	89 c1                	mov    %eax,%ecx
  801dc3:	c1 e1 08             	shl    $0x8,%ecx
  801dc6:	01 c8                	add    %ecx,%eax
  801dc8:	89 c1                	mov    %eax,%ecx
  801dca:	c1 e1 10             	shl    $0x10,%ecx
  801dcd:	01 c8                	add    %ecx,%eax
  801dcf:	01 c0                	add    %eax,%eax
  801dd1:	01 d0                	add    %edx,%eax
  801dd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801dd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dd9:	c1 e0 0c             	shl    $0xc,%eax
  801ddc:	89 c2                	mov    %eax,%edx
  801dde:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801de3:	01 d0                	add    %edx,%eax
}
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801ded:	8b 45 08             	mov    0x8(%ebp),%eax
  801df0:	05 00 00 00 02       	add    $0x2000000,%eax
  801df5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801df8:	73 16                	jae    801e10 <initialize_dynamic_allocator+0x29>
  801dfa:	68 d8 2c 80 00       	push   $0x802cd8
  801dff:	68 fe 2c 80 00       	push   $0x802cfe
  801e04:	6a 26                	push   $0x26
  801e06:	68 13 2d 80 00       	push   $0x802d13
  801e0b:	e8 77 e6 ff ff       	call   800487 <_panic>
		is_initialized = 1;
  801e10:	c7 05 24 30 80 00 01 	movl   $0x1,0x803024
  801e17:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  801e1a:	83 ec 04             	sub    $0x4,%esp
  801e1d:	68 2c 2d 80 00       	push   $0x802d2c
  801e22:	6a 2e                	push   $0x2e
  801e24:	68 13 2d 80 00       	push   $0x802d13
  801e29:	e8 59 e6 ff ff       	call   800487 <_panic>

00801e2e <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
  801e31:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  801e34:	83 ec 04             	sub    $0x4,%esp
  801e37:	68 60 2d 80 00       	push   $0x802d60
  801e3c:	6a 3a                	push   $0x3a
  801e3e:	68 13 2d 80 00       	push   $0x802d13
  801e43:	e8 3f e6 ff ff       	call   800487 <_panic>

00801e48 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
  801e4b:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801e4e:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801e55:	76 16                	jbe    801e6d <alloc_block+0x25>
  801e57:	68 88 2d 80 00       	push   $0x802d88
  801e5c:	68 fe 2c 80 00       	push   $0x802cfe
  801e61:	6a 46                	push   $0x46
  801e63:	68 13 2d 80 00       	push   $0x802d13
  801e68:	e8 1a e6 ff ff       	call   800487 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  801e6d:	83 ec 04             	sub    $0x4,%esp
  801e70:	68 ac 2d 80 00       	push   $0x802dac
  801e75:	6a 4d                	push   $0x4d
  801e77:	68 13 2d 80 00       	push   $0x802d13
  801e7c:	e8 06 e6 ff ff       	call   800487 <_panic>

00801e81 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  801e87:	8b 55 08             	mov    0x8(%ebp),%edx
  801e8a:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801e8f:	39 c2                	cmp    %eax,%edx
  801e91:	72 0c                	jb     801e9f <free_block+0x1e>
  801e93:	8b 55 08             	mov    0x8(%ebp),%edx
  801e96:	a1 40 30 80 00       	mov    0x803040,%eax
  801e9b:	39 c2                	cmp    %eax,%edx
  801e9d:	72 16                	jb     801eb5 <free_block+0x34>
  801e9f:	68 d0 2d 80 00       	push   $0x802dd0
  801ea4:	68 fe 2c 80 00       	push   $0x802cfe
  801ea9:	6a 5b                	push   $0x5b
  801eab:	68 13 2d 80 00       	push   $0x802d13
  801eb0:	e8 d2 e5 ff ff       	call   800487 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  801eb5:	83 ec 04             	sub    $0x4,%esp
  801eb8:	68 08 2e 80 00       	push   $0x802e08
  801ebd:	6a 63                	push   $0x63
  801ebf:	68 13 2d 80 00       	push   $0x802d13
  801ec4:	e8 be e5 ff ff       	call   800487 <_panic>

00801ec9 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
  801ecc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  801ecf:	83 ec 04             	sub    $0x4,%esp
  801ed2:	68 2c 2e 80 00       	push   $0x802e2c
  801ed7:	6a 72                	push   $0x72
  801ed9:	68 13 2d 80 00       	push   $0x802d13
  801ede:	e8 a4 e5 ff ff       	call   800487 <_panic>

00801ee3 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
  801ee6:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801ee9:	8b 55 08             	mov    0x8(%ebp),%edx
  801eec:	89 d0                	mov    %edx,%eax
  801eee:	c1 e0 02             	shl    $0x2,%eax
  801ef1:	01 d0                	add    %edx,%eax
  801ef3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801efa:	01 d0                	add    %edx,%eax
  801efc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f03:	01 d0                	add    %edx,%eax
  801f05:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f0c:	01 d0                	add    %edx,%eax
  801f0e:	c1 e0 04             	shl    $0x4,%eax
  801f11:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801f14:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801f1b:	0f 31                	rdtsc  
  801f1d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f20:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801f23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f26:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f2c:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801f2f:	eb 46                	jmp    801f77 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801f31:	0f 31                	rdtsc  
  801f33:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801f36:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801f39:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f3c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801f3f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801f42:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801f45:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f4b:	29 c2                	sub    %eax,%edx
  801f4d:	89 d0                	mov    %edx,%eax
  801f4f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801f52:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f58:	89 d1                	mov    %edx,%ecx
  801f5a:	29 c1                	sub    %eax,%ecx
  801f5c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f62:	39 c2                	cmp    %eax,%edx
  801f64:	0f 97 c0             	seta   %al
  801f67:	0f b6 c0             	movzbl %al,%eax
  801f6a:	29 c1                	sub    %eax,%ecx
  801f6c:	89 c8                	mov    %ecx,%eax
  801f6e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801f71:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801f77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f7a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801f7d:	72 b2                	jb     801f31 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801f7f:	90                   	nop
  801f80:	c9                   	leave  
  801f81:	c3                   	ret    

00801f82 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801f82:	55                   	push   %ebp
  801f83:	89 e5                	mov    %esp,%ebp
  801f85:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801f88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801f8f:	eb 03                	jmp    801f94 <busy_wait+0x12>
  801f91:	ff 45 fc             	incl   -0x4(%ebp)
  801f94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f97:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f9a:	72 f5                	jb     801f91 <busy_wait+0xf>
	return i;
  801f9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f9f:	c9                   	leave  
  801fa0:	c3                   	ret    
  801fa1:	66 90                	xchg   %ax,%ax
  801fa3:	90                   	nop

00801fa4 <__udivdi3>:
  801fa4:	55                   	push   %ebp
  801fa5:	57                   	push   %edi
  801fa6:	56                   	push   %esi
  801fa7:	53                   	push   %ebx
  801fa8:	83 ec 1c             	sub    $0x1c,%esp
  801fab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801faf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801fb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801fb7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fbb:	89 ca                	mov    %ecx,%edx
  801fbd:	89 f8                	mov    %edi,%eax
  801fbf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801fc3:	85 f6                	test   %esi,%esi
  801fc5:	75 2d                	jne    801ff4 <__udivdi3+0x50>
  801fc7:	39 cf                	cmp    %ecx,%edi
  801fc9:	77 65                	ja     802030 <__udivdi3+0x8c>
  801fcb:	89 fd                	mov    %edi,%ebp
  801fcd:	85 ff                	test   %edi,%edi
  801fcf:	75 0b                	jne    801fdc <__udivdi3+0x38>
  801fd1:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd6:	31 d2                	xor    %edx,%edx
  801fd8:	f7 f7                	div    %edi
  801fda:	89 c5                	mov    %eax,%ebp
  801fdc:	31 d2                	xor    %edx,%edx
  801fde:	89 c8                	mov    %ecx,%eax
  801fe0:	f7 f5                	div    %ebp
  801fe2:	89 c1                	mov    %eax,%ecx
  801fe4:	89 d8                	mov    %ebx,%eax
  801fe6:	f7 f5                	div    %ebp
  801fe8:	89 cf                	mov    %ecx,%edi
  801fea:	89 fa                	mov    %edi,%edx
  801fec:	83 c4 1c             	add    $0x1c,%esp
  801fef:	5b                   	pop    %ebx
  801ff0:	5e                   	pop    %esi
  801ff1:	5f                   	pop    %edi
  801ff2:	5d                   	pop    %ebp
  801ff3:	c3                   	ret    
  801ff4:	39 ce                	cmp    %ecx,%esi
  801ff6:	77 28                	ja     802020 <__udivdi3+0x7c>
  801ff8:	0f bd fe             	bsr    %esi,%edi
  801ffb:	83 f7 1f             	xor    $0x1f,%edi
  801ffe:	75 40                	jne    802040 <__udivdi3+0x9c>
  802000:	39 ce                	cmp    %ecx,%esi
  802002:	72 0a                	jb     80200e <__udivdi3+0x6a>
  802004:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802008:	0f 87 9e 00 00 00    	ja     8020ac <__udivdi3+0x108>
  80200e:	b8 01 00 00 00       	mov    $0x1,%eax
  802013:	89 fa                	mov    %edi,%edx
  802015:	83 c4 1c             	add    $0x1c,%esp
  802018:	5b                   	pop    %ebx
  802019:	5e                   	pop    %esi
  80201a:	5f                   	pop    %edi
  80201b:	5d                   	pop    %ebp
  80201c:	c3                   	ret    
  80201d:	8d 76 00             	lea    0x0(%esi),%esi
  802020:	31 ff                	xor    %edi,%edi
  802022:	31 c0                	xor    %eax,%eax
  802024:	89 fa                	mov    %edi,%edx
  802026:	83 c4 1c             	add    $0x1c,%esp
  802029:	5b                   	pop    %ebx
  80202a:	5e                   	pop    %esi
  80202b:	5f                   	pop    %edi
  80202c:	5d                   	pop    %ebp
  80202d:	c3                   	ret    
  80202e:	66 90                	xchg   %ax,%ax
  802030:	89 d8                	mov    %ebx,%eax
  802032:	f7 f7                	div    %edi
  802034:	31 ff                	xor    %edi,%edi
  802036:	89 fa                	mov    %edi,%edx
  802038:	83 c4 1c             	add    $0x1c,%esp
  80203b:	5b                   	pop    %ebx
  80203c:	5e                   	pop    %esi
  80203d:	5f                   	pop    %edi
  80203e:	5d                   	pop    %ebp
  80203f:	c3                   	ret    
  802040:	bd 20 00 00 00       	mov    $0x20,%ebp
  802045:	89 eb                	mov    %ebp,%ebx
  802047:	29 fb                	sub    %edi,%ebx
  802049:	89 f9                	mov    %edi,%ecx
  80204b:	d3 e6                	shl    %cl,%esi
  80204d:	89 c5                	mov    %eax,%ebp
  80204f:	88 d9                	mov    %bl,%cl
  802051:	d3 ed                	shr    %cl,%ebp
  802053:	89 e9                	mov    %ebp,%ecx
  802055:	09 f1                	or     %esi,%ecx
  802057:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80205b:	89 f9                	mov    %edi,%ecx
  80205d:	d3 e0                	shl    %cl,%eax
  80205f:	89 c5                	mov    %eax,%ebp
  802061:	89 d6                	mov    %edx,%esi
  802063:	88 d9                	mov    %bl,%cl
  802065:	d3 ee                	shr    %cl,%esi
  802067:	89 f9                	mov    %edi,%ecx
  802069:	d3 e2                	shl    %cl,%edx
  80206b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80206f:	88 d9                	mov    %bl,%cl
  802071:	d3 e8                	shr    %cl,%eax
  802073:	09 c2                	or     %eax,%edx
  802075:	89 d0                	mov    %edx,%eax
  802077:	89 f2                	mov    %esi,%edx
  802079:	f7 74 24 0c          	divl   0xc(%esp)
  80207d:	89 d6                	mov    %edx,%esi
  80207f:	89 c3                	mov    %eax,%ebx
  802081:	f7 e5                	mul    %ebp
  802083:	39 d6                	cmp    %edx,%esi
  802085:	72 19                	jb     8020a0 <__udivdi3+0xfc>
  802087:	74 0b                	je     802094 <__udivdi3+0xf0>
  802089:	89 d8                	mov    %ebx,%eax
  80208b:	31 ff                	xor    %edi,%edi
  80208d:	e9 58 ff ff ff       	jmp    801fea <__udivdi3+0x46>
  802092:	66 90                	xchg   %ax,%ax
  802094:	8b 54 24 08          	mov    0x8(%esp),%edx
  802098:	89 f9                	mov    %edi,%ecx
  80209a:	d3 e2                	shl    %cl,%edx
  80209c:	39 c2                	cmp    %eax,%edx
  80209e:	73 e9                	jae    802089 <__udivdi3+0xe5>
  8020a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8020a3:	31 ff                	xor    %edi,%edi
  8020a5:	e9 40 ff ff ff       	jmp    801fea <__udivdi3+0x46>
  8020aa:	66 90                	xchg   %ax,%ax
  8020ac:	31 c0                	xor    %eax,%eax
  8020ae:	e9 37 ff ff ff       	jmp    801fea <__udivdi3+0x46>
  8020b3:	90                   	nop

008020b4 <__umoddi3>:
  8020b4:	55                   	push   %ebp
  8020b5:	57                   	push   %edi
  8020b6:	56                   	push   %esi
  8020b7:	53                   	push   %ebx
  8020b8:	83 ec 1c             	sub    $0x1c,%esp
  8020bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8020bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020c7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8020cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020d3:	89 f3                	mov    %esi,%ebx
  8020d5:	89 fa                	mov    %edi,%edx
  8020d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020db:	89 34 24             	mov    %esi,(%esp)
  8020de:	85 c0                	test   %eax,%eax
  8020e0:	75 1a                	jne    8020fc <__umoddi3+0x48>
  8020e2:	39 f7                	cmp    %esi,%edi
  8020e4:	0f 86 a2 00 00 00    	jbe    80218c <__umoddi3+0xd8>
  8020ea:	89 c8                	mov    %ecx,%eax
  8020ec:	89 f2                	mov    %esi,%edx
  8020ee:	f7 f7                	div    %edi
  8020f0:	89 d0                	mov    %edx,%eax
  8020f2:	31 d2                	xor    %edx,%edx
  8020f4:	83 c4 1c             	add    $0x1c,%esp
  8020f7:	5b                   	pop    %ebx
  8020f8:	5e                   	pop    %esi
  8020f9:	5f                   	pop    %edi
  8020fa:	5d                   	pop    %ebp
  8020fb:	c3                   	ret    
  8020fc:	39 f0                	cmp    %esi,%eax
  8020fe:	0f 87 ac 00 00 00    	ja     8021b0 <__umoddi3+0xfc>
  802104:	0f bd e8             	bsr    %eax,%ebp
  802107:	83 f5 1f             	xor    $0x1f,%ebp
  80210a:	0f 84 ac 00 00 00    	je     8021bc <__umoddi3+0x108>
  802110:	bf 20 00 00 00       	mov    $0x20,%edi
  802115:	29 ef                	sub    %ebp,%edi
  802117:	89 fe                	mov    %edi,%esi
  802119:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80211d:	89 e9                	mov    %ebp,%ecx
  80211f:	d3 e0                	shl    %cl,%eax
  802121:	89 d7                	mov    %edx,%edi
  802123:	89 f1                	mov    %esi,%ecx
  802125:	d3 ef                	shr    %cl,%edi
  802127:	09 c7                	or     %eax,%edi
  802129:	89 e9                	mov    %ebp,%ecx
  80212b:	d3 e2                	shl    %cl,%edx
  80212d:	89 14 24             	mov    %edx,(%esp)
  802130:	89 d8                	mov    %ebx,%eax
  802132:	d3 e0                	shl    %cl,%eax
  802134:	89 c2                	mov    %eax,%edx
  802136:	8b 44 24 08          	mov    0x8(%esp),%eax
  80213a:	d3 e0                	shl    %cl,%eax
  80213c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802140:	8b 44 24 08          	mov    0x8(%esp),%eax
  802144:	89 f1                	mov    %esi,%ecx
  802146:	d3 e8                	shr    %cl,%eax
  802148:	09 d0                	or     %edx,%eax
  80214a:	d3 eb                	shr    %cl,%ebx
  80214c:	89 da                	mov    %ebx,%edx
  80214e:	f7 f7                	div    %edi
  802150:	89 d3                	mov    %edx,%ebx
  802152:	f7 24 24             	mull   (%esp)
  802155:	89 c6                	mov    %eax,%esi
  802157:	89 d1                	mov    %edx,%ecx
  802159:	39 d3                	cmp    %edx,%ebx
  80215b:	0f 82 87 00 00 00    	jb     8021e8 <__umoddi3+0x134>
  802161:	0f 84 91 00 00 00    	je     8021f8 <__umoddi3+0x144>
  802167:	8b 54 24 04          	mov    0x4(%esp),%edx
  80216b:	29 f2                	sub    %esi,%edx
  80216d:	19 cb                	sbb    %ecx,%ebx
  80216f:	89 d8                	mov    %ebx,%eax
  802171:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802175:	d3 e0                	shl    %cl,%eax
  802177:	89 e9                	mov    %ebp,%ecx
  802179:	d3 ea                	shr    %cl,%edx
  80217b:	09 d0                	or     %edx,%eax
  80217d:	89 e9                	mov    %ebp,%ecx
  80217f:	d3 eb                	shr    %cl,%ebx
  802181:	89 da                	mov    %ebx,%edx
  802183:	83 c4 1c             	add    $0x1c,%esp
  802186:	5b                   	pop    %ebx
  802187:	5e                   	pop    %esi
  802188:	5f                   	pop    %edi
  802189:	5d                   	pop    %ebp
  80218a:	c3                   	ret    
  80218b:	90                   	nop
  80218c:	89 fd                	mov    %edi,%ebp
  80218e:	85 ff                	test   %edi,%edi
  802190:	75 0b                	jne    80219d <__umoddi3+0xe9>
  802192:	b8 01 00 00 00       	mov    $0x1,%eax
  802197:	31 d2                	xor    %edx,%edx
  802199:	f7 f7                	div    %edi
  80219b:	89 c5                	mov    %eax,%ebp
  80219d:	89 f0                	mov    %esi,%eax
  80219f:	31 d2                	xor    %edx,%edx
  8021a1:	f7 f5                	div    %ebp
  8021a3:	89 c8                	mov    %ecx,%eax
  8021a5:	f7 f5                	div    %ebp
  8021a7:	89 d0                	mov    %edx,%eax
  8021a9:	e9 44 ff ff ff       	jmp    8020f2 <__umoddi3+0x3e>
  8021ae:	66 90                	xchg   %ax,%ax
  8021b0:	89 c8                	mov    %ecx,%eax
  8021b2:	89 f2                	mov    %esi,%edx
  8021b4:	83 c4 1c             	add    $0x1c,%esp
  8021b7:	5b                   	pop    %ebx
  8021b8:	5e                   	pop    %esi
  8021b9:	5f                   	pop    %edi
  8021ba:	5d                   	pop    %ebp
  8021bb:	c3                   	ret    
  8021bc:	3b 04 24             	cmp    (%esp),%eax
  8021bf:	72 06                	jb     8021c7 <__umoddi3+0x113>
  8021c1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8021c5:	77 0f                	ja     8021d6 <__umoddi3+0x122>
  8021c7:	89 f2                	mov    %esi,%edx
  8021c9:	29 f9                	sub    %edi,%ecx
  8021cb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8021cf:	89 14 24             	mov    %edx,(%esp)
  8021d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021d6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8021da:	8b 14 24             	mov    (%esp),%edx
  8021dd:	83 c4 1c             	add    $0x1c,%esp
  8021e0:	5b                   	pop    %ebx
  8021e1:	5e                   	pop    %esi
  8021e2:	5f                   	pop    %edi
  8021e3:	5d                   	pop    %ebp
  8021e4:	c3                   	ret    
  8021e5:	8d 76 00             	lea    0x0(%esi),%esi
  8021e8:	2b 04 24             	sub    (%esp),%eax
  8021eb:	19 fa                	sbb    %edi,%edx
  8021ed:	89 d1                	mov    %edx,%ecx
  8021ef:	89 c6                	mov    %eax,%esi
  8021f1:	e9 71 ff ff ff       	jmp    802167 <__umoddi3+0xb3>
  8021f6:	66 90                	xchg   %ax,%ax
  8021f8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8021fc:	72 ea                	jb     8021e8 <__umoddi3+0x134>
  8021fe:	89 d9                	mov    %ebx,%ecx
  802200:	e9 62 ff ff ff       	jmp    802167 <__umoddi3+0xb3>


obj/user/tst_envfree5_2:     file format elf32-i386


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
  800031:	e8 7b 02 00 00       	call   8002b1 <libmain>
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
	// Testing removing the shared variables
	// Testing scenario 5_2: Kill programs have already shared variables and they free it [include scenario 5_1]
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  800044:	83 ec 04             	sub    $0x4,%esp
  800047:	6a 01                	push   $0x1
  800049:	6a 04                	push   $0x4
  80004b:	68 e0 21 80 00       	push   $0x8021e0
  800050:	e8 e4 16 00 00       	call   801739 <smalloc>
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*numOfFinished = 0 ;
  80005b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80005e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	char getksbrkCmd[100] = "__getKernelSBreak__";
  800064:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80006a:	bb e3 23 80 00       	mov    $0x8023e3,%ebx
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
  8000a1:	e8 43 1c 00 00       	call   801ce9 <sys_utilities>
  8000a6:	83 c4 10             	add    $0x10,%esp

	int freeFrames_before = sys_calculate_free_frames() ;
  8000a9:	e8 3c 18 00 00       	call   8018ea <sys_calculate_free_frames>
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  8000b1:	e8 7f 18 00 00       	call   801935 <sys_pf_calculate_allocated_pages>
  8000b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bf:	68 f0 21 80 00       	push   $0x8021f0
  8000c4:	e8 66 06 00 00       	call   80072f <cprintf>
  8000c9:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 3000,100, 50);
  8000cc:	6a 32                	push   $0x32
  8000ce:	6a 64                	push   $0x64
  8000d0:	68 b8 0b 00 00       	push   $0xbb8
  8000d5:	68 23 22 80 00       	push   $0x802223
  8000da:	e8 66 19 00 00       	call   801a45 <sys_create_env>
  8000df:	83 c4 10             	add    $0x10,%esp
  8000e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr5", 3000,100, 50);
  8000e5:	6a 32                	push   $0x32
  8000e7:	6a 64                	push   $0x64
  8000e9:	68 b8 0b 00 00       	push   $0xbb8
  8000ee:	68 2c 22 80 00       	push   $0x80222c
  8000f3:	e8 4d 19 00 00       	call   801a45 <sys_create_env>
  8000f8:	83 c4 10             	add    $0x10,%esp
  8000fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	sys_run_env(envIdProcessA);
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	ff 75 d8             	pushl  -0x28(%ebp)
  800104:	e8 5a 19 00 00       	call   801a63 <sys_run_env>
  800109:	83 c4 10             	add    $0x10,%esp
	env_sleep(15000);
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	68 98 3a 00 00       	push   $0x3a98
  800114:	e8 a4 1d 00 00       	call   801ebd <env_sleep>
  800119:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  80011c:	83 ec 0c             	sub    $0xc,%esp
  80011f:	ff 75 d4             	pushl  -0x2c(%ebp)
  800122:	e8 3c 19 00 00       	call   801a63 <sys_run_env>
  800127:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  80012a:	90                   	nop
  80012b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80012e:	8b 00                	mov    (%eax),%eax
  800130:	83 f8 02             	cmp    $0x2,%eax
  800133:	75 f6                	jne    80012b <_main+0xf3>

	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  800135:	e8 b0 17 00 00       	call   8018ea <sys_calculate_free_frames>
  80013a:	83 ec 08             	sub    $0x8,%esp
  80013d:	50                   	push   %eax
  80013e:	68 38 22 80 00       	push   $0x802238
  800143:	e8 e7 05 00 00       	call   80072f <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp

	uint32 ksbrk_after ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_after);
  80014b:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800151:	83 ec 08             	sub    $0x8,%esp
  800154:	50                   	push   %eax
  800155:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80015b:	50                   	push   %eax
  80015c:	e8 88 1b 00 00       	call   801ce9 <sys_utilities>
  800161:	83 c4 10             	add    $0x10,%esp

	//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
	//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
	//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
	//	2. changing the # free frames
	char changeIntCmd[100] = "__changeInterruptStatus__";
  800164:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80016a:	bb 47 24 80 00       	mov    $0x802447,%ebx
  80016f:	ba 1a 00 00 00       	mov    $0x1a,%edx
  800174:	89 c7                	mov    %eax,%edi
  800176:	89 de                	mov    %ebx,%esi
  800178:	89 d1                	mov    %edx,%ecx
  80017a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80017c:	8d 95 02 ff ff ff    	lea    -0xfe(%ebp),%edx
  800182:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  800187:	b0 00                	mov    $0x0,%al
  800189:	89 d7                	mov    %edx,%edi
  80018b:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(changeIntCmd, 0);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	6a 00                	push   $0x0
  800192:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800198:	50                   	push   %eax
  800199:	e8 4b 1b 00 00       	call   801ce9 <sys_utilities>
  80019e:	83 c4 10             	add    $0x10,%esp
	{
		sys_destroy_env(envIdProcessA);
  8001a1:	83 ec 0c             	sub    $0xc,%esp
  8001a4:	ff 75 d8             	pushl  -0x28(%ebp)
  8001a7:	e8 d3 18 00 00       	call   801a7f <sys_destroy_env>
  8001ac:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001af:	83 ec 0c             	sub    $0xc,%esp
  8001b2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001b5:	e8 c5 18 00 00       	call   801a7f <sys_destroy_env>
  8001ba:	83 c4 10             	add    $0x10,%esp
	}
	sys_utilities(changeIntCmd, 1);
  8001bd:	83 ec 08             	sub    $0x8,%esp
  8001c0:	6a 01                	push   $0x1
  8001c2:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001c8:	50                   	push   %eax
  8001c9:	e8 1b 1b 00 00       	call   801ce9 <sys_utilities>
  8001ce:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8001d1:	e8 14 17 00 00       	call   8018ea <sys_calculate_free_frames>
  8001d6:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8001d9:	e8 57 17 00 00       	call   801935 <sys_pf_calculate_allocated_pages>
  8001de:	89 45 cc             	mov    %eax,-0x34(%ebp)

	int expected = (ROUNDUP((uint32)ksbrk_after, PAGE_SIZE) - ROUNDUP((uint32)ksbrk_before, PAGE_SIZE)) / PAGE_SIZE;
  8001e1:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  8001e8:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  8001ee:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001f1:	01 d0                	add    %edx,%eax
  8001f3:	48                   	dec    %eax
  8001f4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8001f7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8001ff:	f7 75 c8             	divl   -0x38(%ebp)
  800202:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800205:	29 d0                	sub    %edx,%eax
  800207:	89 c1                	mov    %eax,%ecx
  800209:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  800210:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  800216:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800219:	01 d0                	add    %edx,%eax
  80021b:	48                   	dec    %eax
  80021c:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80021f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800222:	ba 00 00 00 00       	mov    $0x0,%edx
  800227:	f7 75 c0             	divl   -0x40(%ebp)
  80022a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80022d:	29 d0                	sub    %edx,%eax
  80022f:	29 c1                	sub    %eax,%ecx
  800231:	89 c8                	mov    %ecx,%eax
  800233:	c1 e8 0c             	shr    $0xc,%eax
  800236:	89 45 b8             	mov    %eax,-0x48(%ebp)
	cprintf("expected = %d\n",expected);
  800239:	83 ec 08             	sub    $0x8,%esp
  80023c:	ff 75 b8             	pushl  -0x48(%ebp)
  80023f:	68 6a 22 80 00       	push   $0x80226a
  800244:	e8 e6 04 00 00       	call   80072f <cprintf>
  800249:	83 c4 10             	add    $0x10,%esp
	if ((freeFrames_before - freeFrames_after) != expected) {
  80024c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80024f:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800252:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800255:	74 2e                	je     800285 <_main+0x24d>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d, expected = %d\n",
  800257:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80025a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80025d:	ff 75 b8             	pushl  -0x48(%ebp)
  800260:	50                   	push   %eax
  800261:	ff 75 d0             	pushl  -0x30(%ebp)
  800264:	68 7c 22 80 00       	push   $0x80227c
  800269:	e8 c1 04 00 00       	call   80072f <cprintf>
  80026e:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before, expected);
		panic("env_free() does not work correctly... check it again.");
  800271:	83 ec 04             	sub    $0x4,%esp
  800274:	68 ec 22 80 00       	push   $0x8022ec
  800279:	6a 36                	push   $0x36
  80027b:	68 22 23 80 00       	push   $0x802322
  800280:	e8 dc 01 00 00       	call   800461 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800285:	83 ec 08             	sub    $0x8,%esp
  800288:	ff 75 d0             	pushl  -0x30(%ebp)
  80028b:	68 38 23 80 00       	push   $0x802338
  800290:	e8 9a 04 00 00       	call   80072f <cprintf>
  800295:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_2 for envfree completed successfully.\n");
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	68 98 23 80 00       	push   $0x802398
  8002a0:	e8 8a 04 00 00       	call   80072f <cprintf>
  8002a5:	83 c4 10             	add    $0x10,%esp
	return;
  8002a8:	90                   	nop
}
  8002a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ac:	5b                   	pop    %ebx
  8002ad:	5e                   	pop    %esi
  8002ae:	5f                   	pop    %edi
  8002af:	5d                   	pop    %ebp
  8002b0:	c3                   	ret    

008002b1 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	57                   	push   %edi
  8002b5:	56                   	push   %esi
  8002b6:	53                   	push   %ebx
  8002b7:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002ba:	e8 f4 17 00 00       	call   801ab3 <sys_getenvindex>
  8002bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002c5:	89 d0                	mov    %edx,%eax
  8002c7:	c1 e0 02             	shl    $0x2,%eax
  8002ca:	01 d0                	add    %edx,%eax
  8002cc:	c1 e0 03             	shl    $0x3,%eax
  8002cf:	01 d0                	add    %edx,%eax
  8002d1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002d8:	01 d0                	add    %edx,%eax
  8002da:	c1 e0 02             	shl    $0x2,%eax
  8002dd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e2:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002e7:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ec:	8a 40 20             	mov    0x20(%eax),%al
  8002ef:	84 c0                	test   %al,%al
  8002f1:	74 0d                	je     800300 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8002f3:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f8:	83 c0 20             	add    $0x20,%eax
  8002fb:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800300:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800304:	7e 0a                	jle    800310 <libmain+0x5f>
		binaryname = argv[0];
  800306:	8b 45 0c             	mov    0xc(%ebp),%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800310:	83 ec 08             	sub    $0x8,%esp
  800313:	ff 75 0c             	pushl  0xc(%ebp)
  800316:	ff 75 08             	pushl  0x8(%ebp)
  800319:	e8 1a fd ff ff       	call   800038 <_main>
  80031e:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800321:	a1 00 30 80 00       	mov    0x803000,%eax
  800326:	85 c0                	test   %eax,%eax
  800328:	0f 84 01 01 00 00    	je     80042f <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80032e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800334:	bb a4 25 80 00       	mov    $0x8025a4,%ebx
  800339:	ba 0e 00 00 00       	mov    $0xe,%edx
  80033e:	89 c7                	mov    %eax,%edi
  800340:	89 de                	mov    %ebx,%esi
  800342:	89 d1                	mov    %edx,%ecx
  800344:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800346:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800349:	b9 56 00 00 00       	mov    $0x56,%ecx
  80034e:	b0 00                	mov    $0x0,%al
  800350:	89 d7                	mov    %edx,%edi
  800352:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800354:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80035b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80035e:	83 ec 08             	sub    $0x8,%esp
  800361:	50                   	push   %eax
  800362:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800368:	50                   	push   %eax
  800369:	e8 7b 19 00 00       	call   801ce9 <sys_utilities>
  80036e:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800371:	e8 c4 14 00 00       	call   80183a <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800376:	83 ec 0c             	sub    $0xc,%esp
  800379:	68 c4 24 80 00       	push   $0x8024c4
  80037e:	e8 ac 03 00 00       	call   80072f <cprintf>
  800383:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800386:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800389:	85 c0                	test   %eax,%eax
  80038b:	74 18                	je     8003a5 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80038d:	e8 75 19 00 00       	call   801d07 <sys_get_optimal_num_faults>
  800392:	83 ec 08             	sub    $0x8,%esp
  800395:	50                   	push   %eax
  800396:	68 ec 24 80 00       	push   $0x8024ec
  80039b:	e8 8f 03 00 00       	call   80072f <cprintf>
  8003a0:	83 c4 10             	add    $0x10,%esp
  8003a3:	eb 59                	jmp    8003fe <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003a5:	a1 20 30 80 00       	mov    0x803020,%eax
  8003aa:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8003b0:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b5:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8003bb:	83 ec 04             	sub    $0x4,%esp
  8003be:	52                   	push   %edx
  8003bf:	50                   	push   %eax
  8003c0:	68 10 25 80 00       	push   $0x802510
  8003c5:	e8 65 03 00 00       	call   80072f <cprintf>
  8003ca:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003cd:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d2:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8003d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8003dd:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8003e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e8:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8003ee:	51                   	push   %ecx
  8003ef:	52                   	push   %edx
  8003f0:	50                   	push   %eax
  8003f1:	68 38 25 80 00       	push   $0x802538
  8003f6:	e8 34 03 00 00       	call   80072f <cprintf>
  8003fb:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003fe:	a1 20 30 80 00       	mov    0x803020,%eax
  800403:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800409:	83 ec 08             	sub    $0x8,%esp
  80040c:	50                   	push   %eax
  80040d:	68 90 25 80 00       	push   $0x802590
  800412:	e8 18 03 00 00       	call   80072f <cprintf>
  800417:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80041a:	83 ec 0c             	sub    $0xc,%esp
  80041d:	68 c4 24 80 00       	push   $0x8024c4
  800422:	e8 08 03 00 00       	call   80072f <cprintf>
  800427:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80042a:	e8 25 14 00 00       	call   801854 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80042f:	e8 1f 00 00 00       	call   800453 <exit>
}
  800434:	90                   	nop
  800435:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800438:	5b                   	pop    %ebx
  800439:	5e                   	pop    %esi
  80043a:	5f                   	pop    %edi
  80043b:	5d                   	pop    %ebp
  80043c:	c3                   	ret    

0080043d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80043d:	55                   	push   %ebp
  80043e:	89 e5                	mov    %esp,%ebp
  800440:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800443:	83 ec 0c             	sub    $0xc,%esp
  800446:	6a 00                	push   $0x0
  800448:	e8 32 16 00 00       	call   801a7f <sys_destroy_env>
  80044d:	83 c4 10             	add    $0x10,%esp
}
  800450:	90                   	nop
  800451:	c9                   	leave  
  800452:	c3                   	ret    

00800453 <exit>:

void
exit(void)
{
  800453:	55                   	push   %ebp
  800454:	89 e5                	mov    %esp,%ebp
  800456:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800459:	e8 87 16 00 00       	call   801ae5 <sys_exit_env>
}
  80045e:	90                   	nop
  80045f:	c9                   	leave  
  800460:	c3                   	ret    

00800461 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800461:	55                   	push   %ebp
  800462:	89 e5                	mov    %esp,%ebp
  800464:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800467:	8d 45 10             	lea    0x10(%ebp),%eax
  80046a:	83 c0 04             	add    $0x4,%eax
  80046d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800470:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800475:	85 c0                	test   %eax,%eax
  800477:	74 16                	je     80048f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800479:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80047e:	83 ec 08             	sub    $0x8,%esp
  800481:	50                   	push   %eax
  800482:	68 08 26 80 00       	push   $0x802608
  800487:	e8 a3 02 00 00       	call   80072f <cprintf>
  80048c:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80048f:	a1 04 30 80 00       	mov    0x803004,%eax
  800494:	83 ec 0c             	sub    $0xc,%esp
  800497:	ff 75 0c             	pushl  0xc(%ebp)
  80049a:	ff 75 08             	pushl  0x8(%ebp)
  80049d:	50                   	push   %eax
  80049e:	68 10 26 80 00       	push   $0x802610
  8004a3:	6a 74                	push   $0x74
  8004a5:	e8 b2 02 00 00       	call   80075c <cprintf_colored>
  8004aa:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b0:	83 ec 08             	sub    $0x8,%esp
  8004b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8004b6:	50                   	push   %eax
  8004b7:	e8 04 02 00 00       	call   8006c0 <vcprintf>
  8004bc:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004bf:	83 ec 08             	sub    $0x8,%esp
  8004c2:	6a 00                	push   $0x0
  8004c4:	68 38 26 80 00       	push   $0x802638
  8004c9:	e8 f2 01 00 00       	call   8006c0 <vcprintf>
  8004ce:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004d1:	e8 7d ff ff ff       	call   800453 <exit>

	// should not return here
	while (1) ;
  8004d6:	eb fe                	jmp    8004d6 <_panic+0x75>

008004d8 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004d8:	55                   	push   %ebp
  8004d9:	89 e5                	mov    %esp,%ebp
  8004db:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004de:	a1 20 30 80 00       	mov    0x803020,%eax
  8004e3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ec:	39 c2                	cmp    %eax,%edx
  8004ee:	74 14                	je     800504 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 3c 26 80 00       	push   $0x80263c
  8004f8:	6a 26                	push   $0x26
  8004fa:	68 88 26 80 00       	push   $0x802688
  8004ff:	e8 5d ff ff ff       	call   800461 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800504:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80050b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800512:	e9 c5 00 00 00       	jmp    8005dc <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80051a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800521:	8b 45 08             	mov    0x8(%ebp),%eax
  800524:	01 d0                	add    %edx,%eax
  800526:	8b 00                	mov    (%eax),%eax
  800528:	85 c0                	test   %eax,%eax
  80052a:	75 08                	jne    800534 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80052c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80052f:	e9 a5 00 00 00       	jmp    8005d9 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800534:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800542:	eb 69                	jmp    8005ad <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800544:	a1 20 30 80 00       	mov    0x803020,%eax
  800549:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80054f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800552:	89 d0                	mov    %edx,%eax
  800554:	01 c0                	add    %eax,%eax
  800556:	01 d0                	add    %edx,%eax
  800558:	c1 e0 03             	shl    $0x3,%eax
  80055b:	01 c8                	add    %ecx,%eax
  80055d:	8a 40 04             	mov    0x4(%eax),%al
  800560:	84 c0                	test   %al,%al
  800562:	75 46                	jne    8005aa <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800564:	a1 20 30 80 00       	mov    0x803020,%eax
  800569:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80056f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800572:	89 d0                	mov    %edx,%eax
  800574:	01 c0                	add    %eax,%eax
  800576:	01 d0                	add    %edx,%eax
  800578:	c1 e0 03             	shl    $0x3,%eax
  80057b:	01 c8                	add    %ecx,%eax
  80057d:	8b 00                	mov    (%eax),%eax
  80057f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800582:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800585:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80058a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80058c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80058f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800596:	8b 45 08             	mov    0x8(%ebp),%eax
  800599:	01 c8                	add    %ecx,%eax
  80059b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80059d:	39 c2                	cmp    %eax,%edx
  80059f:	75 09                	jne    8005aa <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005a1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005a8:	eb 15                	jmp    8005bf <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005aa:	ff 45 e8             	incl   -0x18(%ebp)
  8005ad:	a1 20 30 80 00       	mov    0x803020,%eax
  8005b2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005bb:	39 c2                	cmp    %eax,%edx
  8005bd:	77 85                	ja     800544 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005c3:	75 14                	jne    8005d9 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005c5:	83 ec 04             	sub    $0x4,%esp
  8005c8:	68 94 26 80 00       	push   $0x802694
  8005cd:	6a 3a                	push   $0x3a
  8005cf:	68 88 26 80 00       	push   $0x802688
  8005d4:	e8 88 fe ff ff       	call   800461 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005d9:	ff 45 f0             	incl   -0x10(%ebp)
  8005dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005df:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005e2:	0f 8c 2f ff ff ff    	jl     800517 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ef:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005f6:	eb 26                	jmp    80061e <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005f8:	a1 20 30 80 00       	mov    0x803020,%eax
  8005fd:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800603:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800606:	89 d0                	mov    %edx,%eax
  800608:	01 c0                	add    %eax,%eax
  80060a:	01 d0                	add    %edx,%eax
  80060c:	c1 e0 03             	shl    $0x3,%eax
  80060f:	01 c8                	add    %ecx,%eax
  800611:	8a 40 04             	mov    0x4(%eax),%al
  800614:	3c 01                	cmp    $0x1,%al
  800616:	75 03                	jne    80061b <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800618:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80061b:	ff 45 e0             	incl   -0x20(%ebp)
  80061e:	a1 20 30 80 00       	mov    0x803020,%eax
  800623:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800629:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80062c:	39 c2                	cmp    %eax,%edx
  80062e:	77 c8                	ja     8005f8 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800633:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800636:	74 14                	je     80064c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800638:	83 ec 04             	sub    $0x4,%esp
  80063b:	68 e8 26 80 00       	push   $0x8026e8
  800640:	6a 44                	push   $0x44
  800642:	68 88 26 80 00       	push   $0x802688
  800647:	e8 15 fe ff ff       	call   800461 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80064c:	90                   	nop
  80064d:	c9                   	leave  
  80064e:	c3                   	ret    

0080064f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80064f:	55                   	push   %ebp
  800650:	89 e5                	mov    %esp,%ebp
  800652:	53                   	push   %ebx
  800653:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800656:	8b 45 0c             	mov    0xc(%ebp),%eax
  800659:	8b 00                	mov    (%eax),%eax
  80065b:	8d 48 01             	lea    0x1(%eax),%ecx
  80065e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800661:	89 0a                	mov    %ecx,(%edx)
  800663:	8b 55 08             	mov    0x8(%ebp),%edx
  800666:	88 d1                	mov    %dl,%cl
  800668:	8b 55 0c             	mov    0xc(%ebp),%edx
  80066b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80066f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	3d ff 00 00 00       	cmp    $0xff,%eax
  800679:	75 30                	jne    8006ab <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80067b:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800681:	a0 44 30 80 00       	mov    0x803044,%al
  800686:	0f b6 c0             	movzbl %al,%eax
  800689:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80068c:	8b 09                	mov    (%ecx),%ecx
  80068e:	89 cb                	mov    %ecx,%ebx
  800690:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800693:	83 c1 08             	add    $0x8,%ecx
  800696:	52                   	push   %edx
  800697:	50                   	push   %eax
  800698:	53                   	push   %ebx
  800699:	51                   	push   %ecx
  80069a:	e8 57 11 00 00       	call   8017f6 <sys_cputs>
  80069f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ae:	8b 40 04             	mov    0x4(%eax),%eax
  8006b1:	8d 50 01             	lea    0x1(%eax),%edx
  8006b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006ba:	90                   	nop
  8006bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006be:	c9                   	leave  
  8006bf:	c3                   	ret    

008006c0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006c0:	55                   	push   %ebp
  8006c1:	89 e5                	mov    %esp,%ebp
  8006c3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006c9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006d0:	00 00 00 
	b.cnt = 0;
  8006d3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006da:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006dd:	ff 75 0c             	pushl  0xc(%ebp)
  8006e0:	ff 75 08             	pushl  0x8(%ebp)
  8006e3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006e9:	50                   	push   %eax
  8006ea:	68 4f 06 80 00       	push   $0x80064f
  8006ef:	e8 5a 02 00 00       	call   80094e <vprintfmt>
  8006f4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006f7:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006fd:	a0 44 30 80 00       	mov    0x803044,%al
  800702:	0f b6 c0             	movzbl %al,%eax
  800705:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80070b:	52                   	push   %edx
  80070c:	50                   	push   %eax
  80070d:	51                   	push   %ecx
  80070e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800714:	83 c0 08             	add    $0x8,%eax
  800717:	50                   	push   %eax
  800718:	e8 d9 10 00 00       	call   8017f6 <sys_cputs>
  80071d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800720:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800727:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80072d:	c9                   	leave  
  80072e:	c3                   	ret    

0080072f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
  800732:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800735:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80073c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80073f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800742:	8b 45 08             	mov    0x8(%ebp),%eax
  800745:	83 ec 08             	sub    $0x8,%esp
  800748:	ff 75 f4             	pushl  -0xc(%ebp)
  80074b:	50                   	push   %eax
  80074c:	e8 6f ff ff ff       	call   8006c0 <vcprintf>
  800751:	83 c4 10             	add    $0x10,%esp
  800754:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800757:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80075a:	c9                   	leave  
  80075b:	c3                   	ret    

0080075c <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800762:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	c1 e0 08             	shl    $0x8,%eax
  80076f:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800774:	8d 45 0c             	lea    0xc(%ebp),%eax
  800777:	83 c0 04             	add    $0x4,%eax
  80077a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80077d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800780:	83 ec 08             	sub    $0x8,%esp
  800783:	ff 75 f4             	pushl  -0xc(%ebp)
  800786:	50                   	push   %eax
  800787:	e8 34 ff ff ff       	call   8006c0 <vcprintf>
  80078c:	83 c4 10             	add    $0x10,%esp
  80078f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800792:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800799:	07 00 00 

	return cnt;
  80079c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80079f:	c9                   	leave  
  8007a0:	c3                   	ret    

008007a1 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007a1:	55                   	push   %ebp
  8007a2:	89 e5                	mov    %esp,%ebp
  8007a4:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007a7:	e8 8e 10 00 00       	call   80183a <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007ac:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007af:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007bb:	50                   	push   %eax
  8007bc:	e8 ff fe ff ff       	call   8006c0 <vcprintf>
  8007c1:	83 c4 10             	add    $0x10,%esp
  8007c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007c7:	e8 88 10 00 00       	call   801854 <sys_unlock_cons>
	return cnt;
  8007cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007cf:	c9                   	leave  
  8007d0:	c3                   	ret    

008007d1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007d1:	55                   	push   %ebp
  8007d2:	89 e5                	mov    %esp,%ebp
  8007d4:	53                   	push   %ebx
  8007d5:	83 ec 14             	sub    $0x14,%esp
  8007d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8007db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007de:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007e4:	8b 45 18             	mov    0x18(%ebp),%eax
  8007e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ec:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ef:	77 55                	ja     800846 <printnum+0x75>
  8007f1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007f4:	72 05                	jb     8007fb <printnum+0x2a>
  8007f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007f9:	77 4b                	ja     800846 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007fb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007fe:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800801:	8b 45 18             	mov    0x18(%ebp),%eax
  800804:	ba 00 00 00 00       	mov    $0x0,%edx
  800809:	52                   	push   %edx
  80080a:	50                   	push   %eax
  80080b:	ff 75 f4             	pushl  -0xc(%ebp)
  80080e:	ff 75 f0             	pushl  -0x10(%ebp)
  800811:	e8 66 17 00 00       	call   801f7c <__udivdi3>
  800816:	83 c4 10             	add    $0x10,%esp
  800819:	83 ec 04             	sub    $0x4,%esp
  80081c:	ff 75 20             	pushl  0x20(%ebp)
  80081f:	53                   	push   %ebx
  800820:	ff 75 18             	pushl  0x18(%ebp)
  800823:	52                   	push   %edx
  800824:	50                   	push   %eax
  800825:	ff 75 0c             	pushl  0xc(%ebp)
  800828:	ff 75 08             	pushl  0x8(%ebp)
  80082b:	e8 a1 ff ff ff       	call   8007d1 <printnum>
  800830:	83 c4 20             	add    $0x20,%esp
  800833:	eb 1a                	jmp    80084f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800835:	83 ec 08             	sub    $0x8,%esp
  800838:	ff 75 0c             	pushl  0xc(%ebp)
  80083b:	ff 75 20             	pushl  0x20(%ebp)
  80083e:	8b 45 08             	mov    0x8(%ebp),%eax
  800841:	ff d0                	call   *%eax
  800843:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800846:	ff 4d 1c             	decl   0x1c(%ebp)
  800849:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80084d:	7f e6                	jg     800835 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80084f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800852:	bb 00 00 00 00       	mov    $0x0,%ebx
  800857:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80085a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80085d:	53                   	push   %ebx
  80085e:	51                   	push   %ecx
  80085f:	52                   	push   %edx
  800860:	50                   	push   %eax
  800861:	e8 26 18 00 00       	call   80208c <__umoddi3>
  800866:	83 c4 10             	add    $0x10,%esp
  800869:	05 54 29 80 00       	add    $0x802954,%eax
  80086e:	8a 00                	mov    (%eax),%al
  800870:	0f be c0             	movsbl %al,%eax
  800873:	83 ec 08             	sub    $0x8,%esp
  800876:	ff 75 0c             	pushl  0xc(%ebp)
  800879:	50                   	push   %eax
  80087a:	8b 45 08             	mov    0x8(%ebp),%eax
  80087d:	ff d0                	call   *%eax
  80087f:	83 c4 10             	add    $0x10,%esp
}
  800882:	90                   	nop
  800883:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800886:	c9                   	leave  
  800887:	c3                   	ret    

00800888 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80088b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80088f:	7e 1c                	jle    8008ad <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800891:	8b 45 08             	mov    0x8(%ebp),%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	8d 50 08             	lea    0x8(%eax),%edx
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	89 10                	mov    %edx,(%eax)
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	8b 00                	mov    (%eax),%eax
  8008a3:	83 e8 08             	sub    $0x8,%eax
  8008a6:	8b 50 04             	mov    0x4(%eax),%edx
  8008a9:	8b 00                	mov    (%eax),%eax
  8008ab:	eb 40                	jmp    8008ed <getuint+0x65>
	else if (lflag)
  8008ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008b1:	74 1e                	je     8008d1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b6:	8b 00                	mov    (%eax),%eax
  8008b8:	8d 50 04             	lea    0x4(%eax),%edx
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	89 10                	mov    %edx,(%eax)
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	8b 00                	mov    (%eax),%eax
  8008c5:	83 e8 04             	sub    $0x4,%eax
  8008c8:	8b 00                	mov    (%eax),%eax
  8008ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8008cf:	eb 1c                	jmp    8008ed <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	8b 00                	mov    (%eax),%eax
  8008d6:	8d 50 04             	lea    0x4(%eax),%edx
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	89 10                	mov    %edx,(%eax)
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	8b 00                	mov    (%eax),%eax
  8008e3:	83 e8 04             	sub    $0x4,%eax
  8008e6:	8b 00                	mov    (%eax),%eax
  8008e8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008ed:	5d                   	pop    %ebp
  8008ee:	c3                   	ret    

008008ef <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008ef:	55                   	push   %ebp
  8008f0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008f2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008f6:	7e 1c                	jle    800914 <getint+0x25>
		return va_arg(*ap, long long);
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	8b 00                	mov    (%eax),%eax
  8008fd:	8d 50 08             	lea    0x8(%eax),%edx
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	89 10                	mov    %edx,(%eax)
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	8b 00                	mov    (%eax),%eax
  80090a:	83 e8 08             	sub    $0x8,%eax
  80090d:	8b 50 04             	mov    0x4(%eax),%edx
  800910:	8b 00                	mov    (%eax),%eax
  800912:	eb 38                	jmp    80094c <getint+0x5d>
	else if (lflag)
  800914:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800918:	74 1a                	je     800934 <getint+0x45>
		return va_arg(*ap, long);
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	8d 50 04             	lea    0x4(%eax),%edx
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	89 10                	mov    %edx,(%eax)
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	8b 00                	mov    (%eax),%eax
  80092c:	83 e8 04             	sub    $0x4,%eax
  80092f:	8b 00                	mov    (%eax),%eax
  800931:	99                   	cltd   
  800932:	eb 18                	jmp    80094c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	8b 00                	mov    (%eax),%eax
  800939:	8d 50 04             	lea    0x4(%eax),%edx
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	89 10                	mov    %edx,(%eax)
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	83 e8 04             	sub    $0x4,%eax
  800949:	8b 00                	mov    (%eax),%eax
  80094b:	99                   	cltd   
}
  80094c:	5d                   	pop    %ebp
  80094d:	c3                   	ret    

0080094e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80094e:	55                   	push   %ebp
  80094f:	89 e5                	mov    %esp,%ebp
  800951:	56                   	push   %esi
  800952:	53                   	push   %ebx
  800953:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800956:	eb 17                	jmp    80096f <vprintfmt+0x21>
			if (ch == '\0')
  800958:	85 db                	test   %ebx,%ebx
  80095a:	0f 84 c1 03 00 00    	je     800d21 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800960:	83 ec 08             	sub    $0x8,%esp
  800963:	ff 75 0c             	pushl  0xc(%ebp)
  800966:	53                   	push   %ebx
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	ff d0                	call   *%eax
  80096c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096f:	8b 45 10             	mov    0x10(%ebp),%eax
  800972:	8d 50 01             	lea    0x1(%eax),%edx
  800975:	89 55 10             	mov    %edx,0x10(%ebp)
  800978:	8a 00                	mov    (%eax),%al
  80097a:	0f b6 d8             	movzbl %al,%ebx
  80097d:	83 fb 25             	cmp    $0x25,%ebx
  800980:	75 d6                	jne    800958 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800982:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800986:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80098d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800994:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80099b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a5:	8d 50 01             	lea    0x1(%eax),%edx
  8009a8:	89 55 10             	mov    %edx,0x10(%ebp)
  8009ab:	8a 00                	mov    (%eax),%al
  8009ad:	0f b6 d8             	movzbl %al,%ebx
  8009b0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009b3:	83 f8 5b             	cmp    $0x5b,%eax
  8009b6:	0f 87 3d 03 00 00    	ja     800cf9 <vprintfmt+0x3ab>
  8009bc:	8b 04 85 78 29 80 00 	mov    0x802978(,%eax,4),%eax
  8009c3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009c5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009c9:	eb d7                	jmp    8009a2 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009cb:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009cf:	eb d1                	jmp    8009a2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009db:	89 d0                	mov    %edx,%eax
  8009dd:	c1 e0 02             	shl    $0x2,%eax
  8009e0:	01 d0                	add    %edx,%eax
  8009e2:	01 c0                	add    %eax,%eax
  8009e4:	01 d8                	add    %ebx,%eax
  8009e6:	83 e8 30             	sub    $0x30,%eax
  8009e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ef:	8a 00                	mov    (%eax),%al
  8009f1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009f4:	83 fb 2f             	cmp    $0x2f,%ebx
  8009f7:	7e 3e                	jle    800a37 <vprintfmt+0xe9>
  8009f9:	83 fb 39             	cmp    $0x39,%ebx
  8009fc:	7f 39                	jg     800a37 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009fe:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a01:	eb d5                	jmp    8009d8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a03:	8b 45 14             	mov    0x14(%ebp),%eax
  800a06:	83 c0 04             	add    $0x4,%eax
  800a09:	89 45 14             	mov    %eax,0x14(%ebp)
  800a0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0f:	83 e8 04             	sub    $0x4,%eax
  800a12:	8b 00                	mov    (%eax),%eax
  800a14:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a17:	eb 1f                	jmp    800a38 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a19:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a1d:	79 83                	jns    8009a2 <vprintfmt+0x54>
				width = 0;
  800a1f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a26:	e9 77 ff ff ff       	jmp    8009a2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a2b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a32:	e9 6b ff ff ff       	jmp    8009a2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a37:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a38:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3c:	0f 89 60 ff ff ff    	jns    8009a2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a48:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a4f:	e9 4e ff ff ff       	jmp    8009a2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a54:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a57:	e9 46 ff ff ff       	jmp    8009a2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5f:	83 c0 04             	add    $0x4,%eax
  800a62:	89 45 14             	mov    %eax,0x14(%ebp)
  800a65:	8b 45 14             	mov    0x14(%ebp),%eax
  800a68:	83 e8 04             	sub    $0x4,%eax
  800a6b:	8b 00                	mov    (%eax),%eax
  800a6d:	83 ec 08             	sub    $0x8,%esp
  800a70:	ff 75 0c             	pushl  0xc(%ebp)
  800a73:	50                   	push   %eax
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	ff d0                	call   *%eax
  800a79:	83 c4 10             	add    $0x10,%esp
			break;
  800a7c:	e9 9b 02 00 00       	jmp    800d1c <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a81:	8b 45 14             	mov    0x14(%ebp),%eax
  800a84:	83 c0 04             	add    $0x4,%eax
  800a87:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8d:	83 e8 04             	sub    $0x4,%eax
  800a90:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a92:	85 db                	test   %ebx,%ebx
  800a94:	79 02                	jns    800a98 <vprintfmt+0x14a>
				err = -err;
  800a96:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a98:	83 fb 64             	cmp    $0x64,%ebx
  800a9b:	7f 0b                	jg     800aa8 <vprintfmt+0x15a>
  800a9d:	8b 34 9d c0 27 80 00 	mov    0x8027c0(,%ebx,4),%esi
  800aa4:	85 f6                	test   %esi,%esi
  800aa6:	75 19                	jne    800ac1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aa8:	53                   	push   %ebx
  800aa9:	68 65 29 80 00       	push   $0x802965
  800aae:	ff 75 0c             	pushl  0xc(%ebp)
  800ab1:	ff 75 08             	pushl  0x8(%ebp)
  800ab4:	e8 70 02 00 00       	call   800d29 <printfmt>
  800ab9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800abc:	e9 5b 02 00 00       	jmp    800d1c <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ac1:	56                   	push   %esi
  800ac2:	68 6e 29 80 00       	push   $0x80296e
  800ac7:	ff 75 0c             	pushl  0xc(%ebp)
  800aca:	ff 75 08             	pushl  0x8(%ebp)
  800acd:	e8 57 02 00 00       	call   800d29 <printfmt>
  800ad2:	83 c4 10             	add    $0x10,%esp
			break;
  800ad5:	e9 42 02 00 00       	jmp    800d1c <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ada:	8b 45 14             	mov    0x14(%ebp),%eax
  800add:	83 c0 04             	add    $0x4,%eax
  800ae0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae6:	83 e8 04             	sub    $0x4,%eax
  800ae9:	8b 30                	mov    (%eax),%esi
  800aeb:	85 f6                	test   %esi,%esi
  800aed:	75 05                	jne    800af4 <vprintfmt+0x1a6>
				p = "(null)";
  800aef:	be 71 29 80 00       	mov    $0x802971,%esi
			if (width > 0 && padc != '-')
  800af4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af8:	7e 6d                	jle    800b67 <vprintfmt+0x219>
  800afa:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800afe:	74 67                	je     800b67 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b03:	83 ec 08             	sub    $0x8,%esp
  800b06:	50                   	push   %eax
  800b07:	56                   	push   %esi
  800b08:	e8 1e 03 00 00       	call   800e2b <strnlen>
  800b0d:	83 c4 10             	add    $0x10,%esp
  800b10:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b13:	eb 16                	jmp    800b2b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b15:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b19:	83 ec 08             	sub    $0x8,%esp
  800b1c:	ff 75 0c             	pushl  0xc(%ebp)
  800b1f:	50                   	push   %eax
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	ff d0                	call   *%eax
  800b25:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b28:	ff 4d e4             	decl   -0x1c(%ebp)
  800b2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2f:	7f e4                	jg     800b15 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b31:	eb 34                	jmp    800b67 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b33:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b37:	74 1c                	je     800b55 <vprintfmt+0x207>
  800b39:	83 fb 1f             	cmp    $0x1f,%ebx
  800b3c:	7e 05                	jle    800b43 <vprintfmt+0x1f5>
  800b3e:	83 fb 7e             	cmp    $0x7e,%ebx
  800b41:	7e 12                	jle    800b55 <vprintfmt+0x207>
					putch('?', putdat);
  800b43:	83 ec 08             	sub    $0x8,%esp
  800b46:	ff 75 0c             	pushl  0xc(%ebp)
  800b49:	6a 3f                	push   $0x3f
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	ff d0                	call   *%eax
  800b50:	83 c4 10             	add    $0x10,%esp
  800b53:	eb 0f                	jmp    800b64 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b55:	83 ec 08             	sub    $0x8,%esp
  800b58:	ff 75 0c             	pushl  0xc(%ebp)
  800b5b:	53                   	push   %ebx
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	ff d0                	call   *%eax
  800b61:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b64:	ff 4d e4             	decl   -0x1c(%ebp)
  800b67:	89 f0                	mov    %esi,%eax
  800b69:	8d 70 01             	lea    0x1(%eax),%esi
  800b6c:	8a 00                	mov    (%eax),%al
  800b6e:	0f be d8             	movsbl %al,%ebx
  800b71:	85 db                	test   %ebx,%ebx
  800b73:	74 24                	je     800b99 <vprintfmt+0x24b>
  800b75:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b79:	78 b8                	js     800b33 <vprintfmt+0x1e5>
  800b7b:	ff 4d e0             	decl   -0x20(%ebp)
  800b7e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b82:	79 af                	jns    800b33 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b84:	eb 13                	jmp    800b99 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b86:	83 ec 08             	sub    $0x8,%esp
  800b89:	ff 75 0c             	pushl  0xc(%ebp)
  800b8c:	6a 20                	push   $0x20
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	ff d0                	call   *%eax
  800b93:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b96:	ff 4d e4             	decl   -0x1c(%ebp)
  800b99:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b9d:	7f e7                	jg     800b86 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b9f:	e9 78 01 00 00       	jmp    800d1c <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ba4:	83 ec 08             	sub    $0x8,%esp
  800ba7:	ff 75 e8             	pushl  -0x18(%ebp)
  800baa:	8d 45 14             	lea    0x14(%ebp),%eax
  800bad:	50                   	push   %eax
  800bae:	e8 3c fd ff ff       	call   8008ef <getint>
  800bb3:	83 c4 10             	add    $0x10,%esp
  800bb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc2:	85 d2                	test   %edx,%edx
  800bc4:	79 23                	jns    800be9 <vprintfmt+0x29b>
				putch('-', putdat);
  800bc6:	83 ec 08             	sub    $0x8,%esp
  800bc9:	ff 75 0c             	pushl  0xc(%ebp)
  800bcc:	6a 2d                	push   $0x2d
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	ff d0                	call   *%eax
  800bd3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bdc:	f7 d8                	neg    %eax
  800bde:	83 d2 00             	adc    $0x0,%edx
  800be1:	f7 da                	neg    %edx
  800be3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800be9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bf0:	e9 bc 00 00 00       	jmp    800cb1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bf5:	83 ec 08             	sub    $0x8,%esp
  800bf8:	ff 75 e8             	pushl  -0x18(%ebp)
  800bfb:	8d 45 14             	lea    0x14(%ebp),%eax
  800bfe:	50                   	push   %eax
  800bff:	e8 84 fc ff ff       	call   800888 <getuint>
  800c04:	83 c4 10             	add    $0x10,%esp
  800c07:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c0a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c0d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c14:	e9 98 00 00 00       	jmp    800cb1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c19:	83 ec 08             	sub    $0x8,%esp
  800c1c:	ff 75 0c             	pushl  0xc(%ebp)
  800c1f:	6a 58                	push   $0x58
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	ff d0                	call   *%eax
  800c26:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c29:	83 ec 08             	sub    $0x8,%esp
  800c2c:	ff 75 0c             	pushl  0xc(%ebp)
  800c2f:	6a 58                	push   $0x58
  800c31:	8b 45 08             	mov    0x8(%ebp),%eax
  800c34:	ff d0                	call   *%eax
  800c36:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c39:	83 ec 08             	sub    $0x8,%esp
  800c3c:	ff 75 0c             	pushl  0xc(%ebp)
  800c3f:	6a 58                	push   $0x58
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	ff d0                	call   *%eax
  800c46:	83 c4 10             	add    $0x10,%esp
			break;
  800c49:	e9 ce 00 00 00       	jmp    800d1c <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c4e:	83 ec 08             	sub    $0x8,%esp
  800c51:	ff 75 0c             	pushl  0xc(%ebp)
  800c54:	6a 30                	push   $0x30
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	ff d0                	call   *%eax
  800c5b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c5e:	83 ec 08             	sub    $0x8,%esp
  800c61:	ff 75 0c             	pushl  0xc(%ebp)
  800c64:	6a 78                	push   $0x78
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	ff d0                	call   *%eax
  800c6b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c71:	83 c0 04             	add    $0x4,%eax
  800c74:	89 45 14             	mov    %eax,0x14(%ebp)
  800c77:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7a:	83 e8 04             	sub    $0x4,%eax
  800c7d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c89:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c90:	eb 1f                	jmp    800cb1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c92:	83 ec 08             	sub    $0x8,%esp
  800c95:	ff 75 e8             	pushl  -0x18(%ebp)
  800c98:	8d 45 14             	lea    0x14(%ebp),%eax
  800c9b:	50                   	push   %eax
  800c9c:	e8 e7 fb ff ff       	call   800888 <getuint>
  800ca1:	83 c4 10             	add    $0x10,%esp
  800ca4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800caa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cb1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cb8:	83 ec 04             	sub    $0x4,%esp
  800cbb:	52                   	push   %edx
  800cbc:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cbf:	50                   	push   %eax
  800cc0:	ff 75 f4             	pushl  -0xc(%ebp)
  800cc3:	ff 75 f0             	pushl  -0x10(%ebp)
  800cc6:	ff 75 0c             	pushl  0xc(%ebp)
  800cc9:	ff 75 08             	pushl  0x8(%ebp)
  800ccc:	e8 00 fb ff ff       	call   8007d1 <printnum>
  800cd1:	83 c4 20             	add    $0x20,%esp
			break;
  800cd4:	eb 46                	jmp    800d1c <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cd6:	83 ec 08             	sub    $0x8,%esp
  800cd9:	ff 75 0c             	pushl  0xc(%ebp)
  800cdc:	53                   	push   %ebx
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	ff d0                	call   *%eax
  800ce2:	83 c4 10             	add    $0x10,%esp
			break;
  800ce5:	eb 35                	jmp    800d1c <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ce7:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800cee:	eb 2c                	jmp    800d1c <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800cf0:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800cf7:	eb 23                	jmp    800d1c <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cf9:	83 ec 08             	sub    $0x8,%esp
  800cfc:	ff 75 0c             	pushl  0xc(%ebp)
  800cff:	6a 25                	push   $0x25
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	ff d0                	call   *%eax
  800d06:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d09:	ff 4d 10             	decl   0x10(%ebp)
  800d0c:	eb 03                	jmp    800d11 <vprintfmt+0x3c3>
  800d0e:	ff 4d 10             	decl   0x10(%ebp)
  800d11:	8b 45 10             	mov    0x10(%ebp),%eax
  800d14:	48                   	dec    %eax
  800d15:	8a 00                	mov    (%eax),%al
  800d17:	3c 25                	cmp    $0x25,%al
  800d19:	75 f3                	jne    800d0e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d1b:	90                   	nop
		}
	}
  800d1c:	e9 35 fc ff ff       	jmp    800956 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d21:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d22:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d25:	5b                   	pop    %ebx
  800d26:	5e                   	pop    %esi
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    

00800d29 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d2f:	8d 45 10             	lea    0x10(%ebp),%eax
  800d32:	83 c0 04             	add    $0x4,%eax
  800d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d38:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d3e:	50                   	push   %eax
  800d3f:	ff 75 0c             	pushl  0xc(%ebp)
  800d42:	ff 75 08             	pushl  0x8(%ebp)
  800d45:	e8 04 fc ff ff       	call   80094e <vprintfmt>
  800d4a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d4d:	90                   	nop
  800d4e:	c9                   	leave  
  800d4f:	c3                   	ret    

00800d50 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d56:	8b 40 08             	mov    0x8(%eax),%eax
  800d59:	8d 50 01             	lea    0x1(%eax),%edx
  800d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d65:	8b 10                	mov    (%eax),%edx
  800d67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6a:	8b 40 04             	mov    0x4(%eax),%eax
  800d6d:	39 c2                	cmp    %eax,%edx
  800d6f:	73 12                	jae    800d83 <sprintputch+0x33>
		*b->buf++ = ch;
  800d71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d74:	8b 00                	mov    (%eax),%eax
  800d76:	8d 48 01             	lea    0x1(%eax),%ecx
  800d79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d7c:	89 0a                	mov    %ecx,(%edx)
  800d7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d81:	88 10                	mov    %dl,(%eax)
}
  800d83:	90                   	nop
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    

00800d86 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d95:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	01 d0                	add    %edx,%eax
  800d9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800da0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800da7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dab:	74 06                	je     800db3 <vsnprintf+0x2d>
  800dad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db1:	7f 07                	jg     800dba <vsnprintf+0x34>
		return -E_INVAL;
  800db3:	b8 03 00 00 00       	mov    $0x3,%eax
  800db8:	eb 20                	jmp    800dda <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dba:	ff 75 14             	pushl  0x14(%ebp)
  800dbd:	ff 75 10             	pushl  0x10(%ebp)
  800dc0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dc3:	50                   	push   %eax
  800dc4:	68 50 0d 80 00       	push   $0x800d50
  800dc9:	e8 80 fb ff ff       	call   80094e <vprintfmt>
  800dce:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dd4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dda:	c9                   	leave  
  800ddb:	c3                   	ret    

00800ddc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800de2:	8d 45 10             	lea    0x10(%ebp),%eax
  800de5:	83 c0 04             	add    $0x4,%eax
  800de8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800deb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dee:	ff 75 f4             	pushl  -0xc(%ebp)
  800df1:	50                   	push   %eax
  800df2:	ff 75 0c             	pushl  0xc(%ebp)
  800df5:	ff 75 08             	pushl  0x8(%ebp)
  800df8:	e8 89 ff ff ff       	call   800d86 <vsnprintf>
  800dfd:	83 c4 10             	add    $0x10,%esp
  800e00:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e06:	c9                   	leave  
  800e07:	c3                   	ret    

00800e08 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e15:	eb 06                	jmp    800e1d <strlen+0x15>
		n++;
  800e17:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e1a:	ff 45 08             	incl   0x8(%ebp)
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	8a 00                	mov    (%eax),%al
  800e22:	84 c0                	test   %al,%al
  800e24:	75 f1                	jne    800e17 <strlen+0xf>
		n++;
	return n;
  800e26:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e29:	c9                   	leave  
  800e2a:	c3                   	ret    

00800e2b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e31:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e38:	eb 09                	jmp    800e43 <strnlen+0x18>
		n++;
  800e3a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e3d:	ff 45 08             	incl   0x8(%ebp)
  800e40:	ff 4d 0c             	decl   0xc(%ebp)
  800e43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e47:	74 09                	je     800e52 <strnlen+0x27>
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	8a 00                	mov    (%eax),%al
  800e4e:	84 c0                	test   %al,%al
  800e50:	75 e8                	jne    800e3a <strnlen+0xf>
		n++;
	return n;
  800e52:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e55:	c9                   	leave  
  800e56:	c3                   	ret    

00800e57 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e57:	55                   	push   %ebp
  800e58:	89 e5                	mov    %esp,%ebp
  800e5a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e63:	90                   	nop
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	8d 50 01             	lea    0x1(%eax),%edx
  800e6a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e70:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e73:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e76:	8a 12                	mov    (%edx),%dl
  800e78:	88 10                	mov    %dl,(%eax)
  800e7a:	8a 00                	mov    (%eax),%al
  800e7c:	84 c0                	test   %al,%al
  800e7e:	75 e4                	jne    800e64 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e83:	c9                   	leave  
  800e84:	c3                   	ret    

00800e85 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e98:	eb 1f                	jmp    800eb9 <strncpy+0x34>
		*dst++ = *src;
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	8d 50 01             	lea    0x1(%eax),%edx
  800ea0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea6:	8a 12                	mov    (%edx),%dl
  800ea8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ead:	8a 00                	mov    (%eax),%al
  800eaf:	84 c0                	test   %al,%al
  800eb1:	74 03                	je     800eb6 <strncpy+0x31>
			src++;
  800eb3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eb6:	ff 45 fc             	incl   -0x4(%ebp)
  800eb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ebc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ebf:	72 d9                	jb     800e9a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ec1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ec4:	c9                   	leave  
  800ec5:	c3                   	ret    

00800ec6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ec6:	55                   	push   %ebp
  800ec7:	89 e5                	mov    %esp,%ebp
  800ec9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ed2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed6:	74 30                	je     800f08 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ed8:	eb 16                	jmp    800ef0 <strlcpy+0x2a>
			*dst++ = *src++;
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	8d 50 01             	lea    0x1(%eax),%edx
  800ee0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eec:	8a 12                	mov    (%edx),%dl
  800eee:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ef0:	ff 4d 10             	decl   0x10(%ebp)
  800ef3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef7:	74 09                	je     800f02 <strlcpy+0x3c>
  800ef9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efc:	8a 00                	mov    (%eax),%al
  800efe:	84 c0                	test   %al,%al
  800f00:	75 d8                	jne    800eda <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f08:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0e:	29 c2                	sub    %eax,%edx
  800f10:	89 d0                	mov    %edx,%eax
}
  800f12:	c9                   	leave  
  800f13:	c3                   	ret    

00800f14 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f17:	eb 06                	jmp    800f1f <strcmp+0xb>
		p++, q++;
  800f19:	ff 45 08             	incl   0x8(%ebp)
  800f1c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	84 c0                	test   %al,%al
  800f26:	74 0e                	je     800f36 <strcmp+0x22>
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	8a 10                	mov    (%eax),%dl
  800f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f30:	8a 00                	mov    (%eax),%al
  800f32:	38 c2                	cmp    %al,%dl
  800f34:	74 e3                	je     800f19 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	8a 00                	mov    (%eax),%al
  800f3b:	0f b6 d0             	movzbl %al,%edx
  800f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f41:	8a 00                	mov    (%eax),%al
  800f43:	0f b6 c0             	movzbl %al,%eax
  800f46:	29 c2                	sub    %eax,%edx
  800f48:	89 d0                	mov    %edx,%eax
}
  800f4a:	5d                   	pop    %ebp
  800f4b:	c3                   	ret    

00800f4c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f4f:	eb 09                	jmp    800f5a <strncmp+0xe>
		n--, p++, q++;
  800f51:	ff 4d 10             	decl   0x10(%ebp)
  800f54:	ff 45 08             	incl   0x8(%ebp)
  800f57:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f5a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5e:	74 17                	je     800f77 <strncmp+0x2b>
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	8a 00                	mov    (%eax),%al
  800f65:	84 c0                	test   %al,%al
  800f67:	74 0e                	je     800f77 <strncmp+0x2b>
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	8a 10                	mov    (%eax),%dl
  800f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f71:	8a 00                	mov    (%eax),%al
  800f73:	38 c2                	cmp    %al,%dl
  800f75:	74 da                	je     800f51 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7b:	75 07                	jne    800f84 <strncmp+0x38>
		return 0;
  800f7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f82:	eb 14                	jmp    800f98 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f84:	8b 45 08             	mov    0x8(%ebp),%eax
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	0f b6 d0             	movzbl %al,%edx
  800f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8f:	8a 00                	mov    (%eax),%al
  800f91:	0f b6 c0             	movzbl %al,%eax
  800f94:	29 c2                	sub    %eax,%edx
  800f96:	89 d0                	mov    %edx,%eax
}
  800f98:	5d                   	pop    %ebp
  800f99:	c3                   	ret    

00800f9a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
  800f9d:	83 ec 04             	sub    $0x4,%esp
  800fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fa6:	eb 12                	jmp    800fba <strchr+0x20>
		if (*s == c)
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	8a 00                	mov    (%eax),%al
  800fad:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fb0:	75 05                	jne    800fb7 <strchr+0x1d>
			return (char *) s;
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	eb 11                	jmp    800fc8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fb7:	ff 45 08             	incl   0x8(%ebp)
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	84 c0                	test   %al,%al
  800fc1:	75 e5                	jne    800fa8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc8:	c9                   	leave  
  800fc9:	c3                   	ret    

00800fca <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fca:	55                   	push   %ebp
  800fcb:	89 e5                	mov    %esp,%ebp
  800fcd:	83 ec 04             	sub    $0x4,%esp
  800fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fd6:	eb 0d                	jmp    800fe5 <strfind+0x1b>
		if (*s == c)
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fe0:	74 0e                	je     800ff0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fe2:	ff 45 08             	incl   0x8(%ebp)
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8a 00                	mov    (%eax),%al
  800fea:	84 c0                	test   %al,%al
  800fec:	75 ea                	jne    800fd8 <strfind+0xe>
  800fee:	eb 01                	jmp    800ff1 <strfind+0x27>
		if (*s == c)
			break;
  800ff0:	90                   	nop
	return (char *) s;
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    

00800ff6 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801002:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801006:	76 63                	jbe    80106b <memset+0x75>
		uint64 data_block = c;
  801008:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100b:	99                   	cltd   
  80100c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80100f:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801012:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801015:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801018:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80101c:	c1 e0 08             	shl    $0x8,%eax
  80101f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801022:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801025:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801028:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80102b:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80102f:	c1 e0 10             	shl    $0x10,%eax
  801032:	09 45 f0             	or     %eax,-0x10(%ebp)
  801035:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801038:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80103b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80103e:	89 c2                	mov    %eax,%edx
  801040:	b8 00 00 00 00       	mov    $0x0,%eax
  801045:	09 45 f0             	or     %eax,-0x10(%ebp)
  801048:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80104b:	eb 18                	jmp    801065 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80104d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801050:	8d 41 08             	lea    0x8(%ecx),%eax
  801053:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801056:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801059:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80105c:	89 01                	mov    %eax,(%ecx)
  80105e:	89 51 04             	mov    %edx,0x4(%ecx)
  801061:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801065:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801069:	77 e2                	ja     80104d <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80106b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80106f:	74 23                	je     801094 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801071:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801074:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801077:	eb 0e                	jmp    801087 <memset+0x91>
			*p8++ = (uint8)c;
  801079:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107c:	8d 50 01             	lea    0x1(%eax),%edx
  80107f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801082:	8b 55 0c             	mov    0xc(%ebp),%edx
  801085:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801087:	8b 45 10             	mov    0x10(%ebp),%eax
  80108a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80108d:	89 55 10             	mov    %edx,0x10(%ebp)
  801090:	85 c0                	test   %eax,%eax
  801092:	75 e5                	jne    801079 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801097:	c9                   	leave  
  801098:	c3                   	ret    

00801099 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80109f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010ab:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010af:	76 24                	jbe    8010d5 <memcpy+0x3c>
		while(n >= 8){
  8010b1:	eb 1c                	jmp    8010cf <memcpy+0x36>
			*d64 = *s64;
  8010b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b6:	8b 50 04             	mov    0x4(%eax),%edx
  8010b9:	8b 00                	mov    (%eax),%eax
  8010bb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010be:	89 01                	mov    %eax,(%ecx)
  8010c0:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010c3:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010c7:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010cb:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010cf:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010d3:	77 de                	ja     8010b3 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d9:	74 31                	je     80110c <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010de:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8010e7:	eb 16                	jmp    8010ff <memcpy+0x66>
			*d8++ = *s8++;
  8010e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010ec:	8d 50 01             	lea    0x1(%eax),%edx
  8010ef:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8010f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010f8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8010fb:	8a 12                	mov    (%edx),%dl
  8010fd:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8010ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801102:	8d 50 ff             	lea    -0x1(%eax),%edx
  801105:	89 55 10             	mov    %edx,0x10(%ebp)
  801108:	85 c0                	test   %eax,%eax
  80110a:	75 dd                	jne    8010e9 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80110f:	c9                   	leave  
  801110:	c3                   	ret    

00801111 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
  801114:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801117:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801123:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801126:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801129:	73 50                	jae    80117b <memmove+0x6a>
  80112b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80112e:	8b 45 10             	mov    0x10(%ebp),%eax
  801131:	01 d0                	add    %edx,%eax
  801133:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801136:	76 43                	jbe    80117b <memmove+0x6a>
		s += n;
  801138:	8b 45 10             	mov    0x10(%ebp),%eax
  80113b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80113e:	8b 45 10             	mov    0x10(%ebp),%eax
  801141:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801144:	eb 10                	jmp    801156 <memmove+0x45>
			*--d = *--s;
  801146:	ff 4d f8             	decl   -0x8(%ebp)
  801149:	ff 4d fc             	decl   -0x4(%ebp)
  80114c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114f:	8a 10                	mov    (%eax),%dl
  801151:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801154:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801156:	8b 45 10             	mov    0x10(%ebp),%eax
  801159:	8d 50 ff             	lea    -0x1(%eax),%edx
  80115c:	89 55 10             	mov    %edx,0x10(%ebp)
  80115f:	85 c0                	test   %eax,%eax
  801161:	75 e3                	jne    801146 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801163:	eb 23                	jmp    801188 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801165:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801168:	8d 50 01             	lea    0x1(%eax),%edx
  80116b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80116e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801171:	8d 4a 01             	lea    0x1(%edx),%ecx
  801174:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801177:	8a 12                	mov    (%edx),%dl
  801179:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80117b:	8b 45 10             	mov    0x10(%ebp),%eax
  80117e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801181:	89 55 10             	mov    %edx,0x10(%ebp)
  801184:	85 c0                	test   %eax,%eax
  801186:	75 dd                	jne    801165 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80118b:	c9                   	leave  
  80118c:	c3                   	ret    

0080118d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80119f:	eb 2a                	jmp    8011cb <memcmp+0x3e>
		if (*s1 != *s2)
  8011a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a4:	8a 10                	mov    (%eax),%dl
  8011a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a9:	8a 00                	mov    (%eax),%al
  8011ab:	38 c2                	cmp    %al,%dl
  8011ad:	74 16                	je     8011c5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b2:	8a 00                	mov    (%eax),%al
  8011b4:	0f b6 d0             	movzbl %al,%edx
  8011b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	0f b6 c0             	movzbl %al,%eax
  8011bf:	29 c2                	sub    %eax,%edx
  8011c1:	89 d0                	mov    %edx,%eax
  8011c3:	eb 18                	jmp    8011dd <memcmp+0x50>
		s1++, s2++;
  8011c5:	ff 45 fc             	incl   -0x4(%ebp)
  8011c8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ce:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8011d4:	85 c0                	test   %eax,%eax
  8011d6:	75 c9                	jne    8011a1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011dd:	c9                   	leave  
  8011de:	c3                   	ret    

008011df <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011df:	55                   	push   %ebp
  8011e0:	89 e5                	mov    %esp,%ebp
  8011e2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011eb:	01 d0                	add    %edx,%eax
  8011ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011f0:	eb 15                	jmp    801207 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	0f b6 d0             	movzbl %al,%edx
  8011fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fd:	0f b6 c0             	movzbl %al,%eax
  801200:	39 c2                	cmp    %eax,%edx
  801202:	74 0d                	je     801211 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801204:	ff 45 08             	incl   0x8(%ebp)
  801207:	8b 45 08             	mov    0x8(%ebp),%eax
  80120a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80120d:	72 e3                	jb     8011f2 <memfind+0x13>
  80120f:	eb 01                	jmp    801212 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801211:	90                   	nop
	return (void *) s;
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801215:	c9                   	leave  
  801216:	c3                   	ret    

00801217 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801217:	55                   	push   %ebp
  801218:	89 e5                	mov    %esp,%ebp
  80121a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80121d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801224:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80122b:	eb 03                	jmp    801230 <strtol+0x19>
		s++;
  80122d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	8a 00                	mov    (%eax),%al
  801235:	3c 20                	cmp    $0x20,%al
  801237:	74 f4                	je     80122d <strtol+0x16>
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	8a 00                	mov    (%eax),%al
  80123e:	3c 09                	cmp    $0x9,%al
  801240:	74 eb                	je     80122d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	8a 00                	mov    (%eax),%al
  801247:	3c 2b                	cmp    $0x2b,%al
  801249:	75 05                	jne    801250 <strtol+0x39>
		s++;
  80124b:	ff 45 08             	incl   0x8(%ebp)
  80124e:	eb 13                	jmp    801263 <strtol+0x4c>
	else if (*s == '-')
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	3c 2d                	cmp    $0x2d,%al
  801257:	75 0a                	jne    801263 <strtol+0x4c>
		s++, neg = 1;
  801259:	ff 45 08             	incl   0x8(%ebp)
  80125c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801263:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801267:	74 06                	je     80126f <strtol+0x58>
  801269:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80126d:	75 20                	jne    80128f <strtol+0x78>
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	8a 00                	mov    (%eax),%al
  801274:	3c 30                	cmp    $0x30,%al
  801276:	75 17                	jne    80128f <strtol+0x78>
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	40                   	inc    %eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	3c 78                	cmp    $0x78,%al
  801280:	75 0d                	jne    80128f <strtol+0x78>
		s += 2, base = 16;
  801282:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801286:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80128d:	eb 28                	jmp    8012b7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80128f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801293:	75 15                	jne    8012aa <strtol+0x93>
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	8a 00                	mov    (%eax),%al
  80129a:	3c 30                	cmp    $0x30,%al
  80129c:	75 0c                	jne    8012aa <strtol+0x93>
		s++, base = 8;
  80129e:	ff 45 08             	incl   0x8(%ebp)
  8012a1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012a8:	eb 0d                	jmp    8012b7 <strtol+0xa0>
	else if (base == 0)
  8012aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ae:	75 07                	jne    8012b7 <strtol+0xa0>
		base = 10;
  8012b0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	8a 00                	mov    (%eax),%al
  8012bc:	3c 2f                	cmp    $0x2f,%al
  8012be:	7e 19                	jle    8012d9 <strtol+0xc2>
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	8a 00                	mov    (%eax),%al
  8012c5:	3c 39                	cmp    $0x39,%al
  8012c7:	7f 10                	jg     8012d9 <strtol+0xc2>
			dig = *s - '0';
  8012c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cc:	8a 00                	mov    (%eax),%al
  8012ce:	0f be c0             	movsbl %al,%eax
  8012d1:	83 e8 30             	sub    $0x30,%eax
  8012d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012d7:	eb 42                	jmp    80131b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	3c 60                	cmp    $0x60,%al
  8012e0:	7e 19                	jle    8012fb <strtol+0xe4>
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	3c 7a                	cmp    $0x7a,%al
  8012e9:	7f 10                	jg     8012fb <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	8a 00                	mov    (%eax),%al
  8012f0:	0f be c0             	movsbl %al,%eax
  8012f3:	83 e8 57             	sub    $0x57,%eax
  8012f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012f9:	eb 20                	jmp    80131b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	8a 00                	mov    (%eax),%al
  801300:	3c 40                	cmp    $0x40,%al
  801302:	7e 39                	jle    80133d <strtol+0x126>
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	8a 00                	mov    (%eax),%al
  801309:	3c 5a                	cmp    $0x5a,%al
  80130b:	7f 30                	jg     80133d <strtol+0x126>
			dig = *s - 'A' + 10;
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	8a 00                	mov    (%eax),%al
  801312:	0f be c0             	movsbl %al,%eax
  801315:	83 e8 37             	sub    $0x37,%eax
  801318:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80131b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80131e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801321:	7d 19                	jge    80133c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801323:	ff 45 08             	incl   0x8(%ebp)
  801326:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801329:	0f af 45 10          	imul   0x10(%ebp),%eax
  80132d:	89 c2                	mov    %eax,%edx
  80132f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801332:	01 d0                	add    %edx,%eax
  801334:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801337:	e9 7b ff ff ff       	jmp    8012b7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80133c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80133d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801341:	74 08                	je     80134b <strtol+0x134>
		*endptr = (char *) s;
  801343:	8b 45 0c             	mov    0xc(%ebp),%eax
  801346:	8b 55 08             	mov    0x8(%ebp),%edx
  801349:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80134b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80134f:	74 07                	je     801358 <strtol+0x141>
  801351:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801354:	f7 d8                	neg    %eax
  801356:	eb 03                	jmp    80135b <strtol+0x144>
  801358:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <ltostr>:

void
ltostr(long value, char *str)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801363:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80136a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801371:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801375:	79 13                	jns    80138a <ltostr+0x2d>
	{
		neg = 1;
  801377:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80137e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801381:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801384:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801387:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80138a:	8b 45 08             	mov    0x8(%ebp),%eax
  80138d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801392:	99                   	cltd   
  801393:	f7 f9                	idiv   %ecx
  801395:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801398:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80139b:	8d 50 01             	lea    0x1(%eax),%edx
  80139e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013a1:	89 c2                	mov    %eax,%edx
  8013a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a6:	01 d0                	add    %edx,%eax
  8013a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013ab:	83 c2 30             	add    $0x30,%edx
  8013ae:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013b3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013b8:	f7 e9                	imul   %ecx
  8013ba:	c1 fa 02             	sar    $0x2,%edx
  8013bd:	89 c8                	mov    %ecx,%eax
  8013bf:	c1 f8 1f             	sar    $0x1f,%eax
  8013c2:	29 c2                	sub    %eax,%edx
  8013c4:	89 d0                	mov    %edx,%eax
  8013c6:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013cd:	75 bb                	jne    80138a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d9:	48                   	dec    %eax
  8013da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013e1:	74 3d                	je     801420 <ltostr+0xc3>
		start = 1 ;
  8013e3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013ea:	eb 34                	jmp    801420 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f2:	01 d0                	add    %edx,%eax
  8013f4:	8a 00                	mov    (%eax),%al
  8013f6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ff:	01 c2                	add    %eax,%edx
  801401:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801404:	8b 45 0c             	mov    0xc(%ebp),%eax
  801407:	01 c8                	add    %ecx,%eax
  801409:	8a 00                	mov    (%eax),%al
  80140b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80140d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801410:	8b 45 0c             	mov    0xc(%ebp),%eax
  801413:	01 c2                	add    %eax,%edx
  801415:	8a 45 eb             	mov    -0x15(%ebp),%al
  801418:	88 02                	mov    %al,(%edx)
		start++ ;
  80141a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80141d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801423:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801426:	7c c4                	jl     8013ec <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801428:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80142b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142e:	01 d0                	add    %edx,%eax
  801430:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801433:	90                   	nop
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
  801439:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80143c:	ff 75 08             	pushl  0x8(%ebp)
  80143f:	e8 c4 f9 ff ff       	call   800e08 <strlen>
  801444:	83 c4 04             	add    $0x4,%esp
  801447:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80144a:	ff 75 0c             	pushl  0xc(%ebp)
  80144d:	e8 b6 f9 ff ff       	call   800e08 <strlen>
  801452:	83 c4 04             	add    $0x4,%esp
  801455:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801458:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80145f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801466:	eb 17                	jmp    80147f <strcconcat+0x49>
		final[s] = str1[s] ;
  801468:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80146b:	8b 45 10             	mov    0x10(%ebp),%eax
  80146e:	01 c2                	add    %eax,%edx
  801470:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	01 c8                	add    %ecx,%eax
  801478:	8a 00                	mov    (%eax),%al
  80147a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80147c:	ff 45 fc             	incl   -0x4(%ebp)
  80147f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801482:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801485:	7c e1                	jl     801468 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801487:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80148e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801495:	eb 1f                	jmp    8014b6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801497:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80149a:	8d 50 01             	lea    0x1(%eax),%edx
  80149d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014a0:	89 c2                	mov    %eax,%edx
  8014a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a5:	01 c2                	add    %eax,%edx
  8014a7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ad:	01 c8                	add    %ecx,%eax
  8014af:	8a 00                	mov    (%eax),%al
  8014b1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014b3:	ff 45 f8             	incl   -0x8(%ebp)
  8014b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014bc:	7c d9                	jl     801497 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c4:	01 d0                	add    %edx,%eax
  8014c6:	c6 00 00             	movb   $0x0,(%eax)
}
  8014c9:	90                   	nop
  8014ca:	c9                   	leave  
  8014cb:	c3                   	ret    

008014cc <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014db:	8b 00                	mov    (%eax),%eax
  8014dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e7:	01 d0                	add    %edx,%eax
  8014e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014ef:	eb 0c                	jmp    8014fd <strsplit+0x31>
			*string++ = 0;
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	8d 50 01             	lea    0x1(%eax),%edx
  8014f7:	89 55 08             	mov    %edx,0x8(%ebp)
  8014fa:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	8a 00                	mov    (%eax),%al
  801502:	84 c0                	test   %al,%al
  801504:	74 18                	je     80151e <strsplit+0x52>
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	8a 00                	mov    (%eax),%al
  80150b:	0f be c0             	movsbl %al,%eax
  80150e:	50                   	push   %eax
  80150f:	ff 75 0c             	pushl  0xc(%ebp)
  801512:	e8 83 fa ff ff       	call   800f9a <strchr>
  801517:	83 c4 08             	add    $0x8,%esp
  80151a:	85 c0                	test   %eax,%eax
  80151c:	75 d3                	jne    8014f1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	8a 00                	mov    (%eax),%al
  801523:	84 c0                	test   %al,%al
  801525:	74 5a                	je     801581 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801527:	8b 45 14             	mov    0x14(%ebp),%eax
  80152a:	8b 00                	mov    (%eax),%eax
  80152c:	83 f8 0f             	cmp    $0xf,%eax
  80152f:	75 07                	jne    801538 <strsplit+0x6c>
		{
			return 0;
  801531:	b8 00 00 00 00       	mov    $0x0,%eax
  801536:	eb 66                	jmp    80159e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801538:	8b 45 14             	mov    0x14(%ebp),%eax
  80153b:	8b 00                	mov    (%eax),%eax
  80153d:	8d 48 01             	lea    0x1(%eax),%ecx
  801540:	8b 55 14             	mov    0x14(%ebp),%edx
  801543:	89 0a                	mov    %ecx,(%edx)
  801545:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80154c:	8b 45 10             	mov    0x10(%ebp),%eax
  80154f:	01 c2                	add    %eax,%edx
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801556:	eb 03                	jmp    80155b <strsplit+0x8f>
			string++;
  801558:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	8a 00                	mov    (%eax),%al
  801560:	84 c0                	test   %al,%al
  801562:	74 8b                	je     8014ef <strsplit+0x23>
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	8a 00                	mov    (%eax),%al
  801569:	0f be c0             	movsbl %al,%eax
  80156c:	50                   	push   %eax
  80156d:	ff 75 0c             	pushl  0xc(%ebp)
  801570:	e8 25 fa ff ff       	call   800f9a <strchr>
  801575:	83 c4 08             	add    $0x8,%esp
  801578:	85 c0                	test   %eax,%eax
  80157a:	74 dc                	je     801558 <strsplit+0x8c>
			string++;
	}
  80157c:	e9 6e ff ff ff       	jmp    8014ef <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801581:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801582:	8b 45 14             	mov    0x14(%ebp),%eax
  801585:	8b 00                	mov    (%eax),%eax
  801587:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80158e:	8b 45 10             	mov    0x10(%ebp),%eax
  801591:	01 d0                	add    %edx,%eax
  801593:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801599:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015b3:	eb 4a                	jmp    8015ff <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bb:	01 c2                	add    %eax,%edx
  8015bd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c3:	01 c8                	add    %ecx,%eax
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cf:	01 d0                	add    %edx,%eax
  8015d1:	8a 00                	mov    (%eax),%al
  8015d3:	3c 40                	cmp    $0x40,%al
  8015d5:	7e 25                	jle    8015fc <str2lower+0x5c>
  8015d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015dd:	01 d0                	add    %edx,%eax
  8015df:	8a 00                	mov    (%eax),%al
  8015e1:	3c 5a                	cmp    $0x5a,%al
  8015e3:	7f 17                	jg     8015fc <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8015e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015eb:	01 d0                	add    %edx,%eax
  8015ed:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8015f3:	01 ca                	add    %ecx,%edx
  8015f5:	8a 12                	mov    (%edx),%dl
  8015f7:	83 c2 20             	add    $0x20,%edx
  8015fa:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8015fc:	ff 45 fc             	incl   -0x4(%ebp)
  8015ff:	ff 75 0c             	pushl  0xc(%ebp)
  801602:	e8 01 f8 ff ff       	call   800e08 <strlen>
  801607:	83 c4 04             	add    $0x4,%esp
  80160a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80160d:	7f a6                	jg     8015b5 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80160f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801612:	c9                   	leave  
  801613:	c3                   	ret    

00801614 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80161a:	a1 08 30 80 00       	mov    0x803008,%eax
  80161f:	85 c0                	test   %eax,%eax
  801621:	74 42                	je     801665 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801623:	83 ec 08             	sub    $0x8,%esp
  801626:	68 00 00 00 82       	push   $0x82000000
  80162b:	68 00 00 00 80       	push   $0x80000000
  801630:	e8 8c 07 00 00       	call   801dc1 <initialize_dynamic_allocator>
  801635:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801638:	e8 e7 05 00 00       	call   801c24 <sys_get_uheap_strategy>
  80163d:	a3 60 b0 81 00       	mov    %eax,0x81b060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801642:	a1 40 30 80 00       	mov    0x803040,%eax
  801647:	05 00 10 00 00       	add    $0x1000,%eax
  80164c:	a3 10 b1 81 00       	mov    %eax,0x81b110
		uheapPageAllocBreak = uheapPageAllocStart;
  801651:	a1 10 b1 81 00       	mov    0x81b110,%eax
  801656:	a3 68 b0 81 00       	mov    %eax,0x81b068

		__firstTimeFlag = 0;
  80165b:	c7 05 08 30 80 00 00 	movl   $0x0,0x803008
  801662:	00 00 00 
	}
}
  801665:	90                   	nop
  801666:	c9                   	leave  
  801667:	c3                   	ret    

00801668 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
  80166b:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80166e:	8b 45 08             	mov    0x8(%ebp),%eax
  801671:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801677:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80167c:	83 ec 08             	sub    $0x8,%esp
  80167f:	68 06 04 00 00       	push   $0x406
  801684:	50                   	push   %eax
  801685:	e8 e4 01 00 00       	call   80186e <__sys_allocate_page>
  80168a:	83 c4 10             	add    $0x10,%esp
  80168d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801690:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801694:	79 14                	jns    8016aa <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801696:	83 ec 04             	sub    $0x4,%esp
  801699:	68 e8 2a 80 00       	push   $0x802ae8
  80169e:	6a 1f                	push   $0x1f
  8016a0:	68 24 2b 80 00       	push   $0x802b24
  8016a5:	e8 b7 ed ff ff       	call   800461 <_panic>
	return 0;
  8016aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
  8016b4:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016c5:	83 ec 0c             	sub    $0xc,%esp
  8016c8:	50                   	push   %eax
  8016c9:	e8 e7 01 00 00       	call   8018b5 <__sys_unmap_frame>
  8016ce:	83 c4 10             	add    $0x10,%esp
  8016d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016d8:	79 14                	jns    8016ee <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8016da:	83 ec 04             	sub    $0x4,%esp
  8016dd:	68 30 2b 80 00       	push   $0x802b30
  8016e2:	6a 2a                	push   $0x2a
  8016e4:	68 24 2b 80 00       	push   $0x802b24
  8016e9:	e8 73 ed ff ff       	call   800461 <_panic>
}
  8016ee:	90                   	nop
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
  8016f4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8016f7:	e8 18 ff ff ff       	call   801614 <uheap_init>
	if (size == 0) return NULL ;
  8016fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801700:	75 07                	jne    801709 <malloc+0x18>
  801702:	b8 00 00 00 00       	mov    $0x0,%eax
  801707:	eb 14                	jmp    80171d <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801709:	83 ec 04             	sub    $0x4,%esp
  80170c:	68 70 2b 80 00       	push   $0x802b70
  801711:	6a 3e                	push   $0x3e
  801713:	68 24 2b 80 00       	push   $0x802b24
  801718:	e8 44 ed ff ff       	call   800461 <_panic>
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801725:	83 ec 04             	sub    $0x4,%esp
  801728:	68 98 2b 80 00       	push   $0x802b98
  80172d:	6a 49                	push   $0x49
  80172f:	68 24 2b 80 00       	push   $0x802b24
  801734:	e8 28 ed ff ff       	call   800461 <_panic>

00801739 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	83 ec 18             	sub    $0x18,%esp
  80173f:	8b 45 10             	mov    0x10(%ebp),%eax
  801742:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801745:	e8 ca fe ff ff       	call   801614 <uheap_init>
	if (size == 0) return NULL ;
  80174a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80174e:	75 07                	jne    801757 <smalloc+0x1e>
  801750:	b8 00 00 00 00       	mov    $0x0,%eax
  801755:	eb 14                	jmp    80176b <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801757:	83 ec 04             	sub    $0x4,%esp
  80175a:	68 bc 2b 80 00       	push   $0x802bbc
  80175f:	6a 5a                	push   $0x5a
  801761:	68 24 2b 80 00       	push   $0x802b24
  801766:	e8 f6 ec ff ff       	call   800461 <_panic>
}
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801773:	e8 9c fe ff ff       	call   801614 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801778:	83 ec 04             	sub    $0x4,%esp
  80177b:	68 e4 2b 80 00       	push   $0x802be4
  801780:	6a 6a                	push   $0x6a
  801782:	68 24 2b 80 00       	push   $0x802b24
  801787:	e8 d5 ec ff ff       	call   800461 <_panic>

0080178c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
  80178f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801792:	e8 7d fe ff ff       	call   801614 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801797:	83 ec 04             	sub    $0x4,%esp
  80179a:	68 08 2c 80 00       	push   $0x802c08
  80179f:	68 88 00 00 00       	push   $0x88
  8017a4:	68 24 2b 80 00       	push   $0x802b24
  8017a9:	e8 b3 ec ff ff       	call   800461 <_panic>

008017ae <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
  8017b1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8017b4:	83 ec 04             	sub    $0x4,%esp
  8017b7:	68 30 2c 80 00       	push   $0x802c30
  8017bc:	68 9b 00 00 00       	push   $0x9b
  8017c1:	68 24 2b 80 00       	push   $0x802b24
  8017c6:	e8 96 ec ff ff       	call   800461 <_panic>

008017cb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	57                   	push   %edi
  8017cf:	56                   	push   %esi
  8017d0:	53                   	push   %ebx
  8017d1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017dd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017e0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017e3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017e6:	cd 30                	int    $0x30
  8017e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8017eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017ee:	83 c4 10             	add    $0x10,%esp
  8017f1:	5b                   	pop    %ebx
  8017f2:	5e                   	pop    %esi
  8017f3:	5f                   	pop    %edi
  8017f4:	5d                   	pop    %ebp
  8017f5:	c3                   	ret    

008017f6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	83 ec 04             	sub    $0x4,%esp
  8017fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801802:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801805:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801809:	8b 45 08             	mov    0x8(%ebp),%eax
  80180c:	6a 00                	push   $0x0
  80180e:	51                   	push   %ecx
  80180f:	52                   	push   %edx
  801810:	ff 75 0c             	pushl  0xc(%ebp)
  801813:	50                   	push   %eax
  801814:	6a 00                	push   $0x0
  801816:	e8 b0 ff ff ff       	call   8017cb <syscall>
  80181b:	83 c4 18             	add    $0x18,%esp
}
  80181e:	90                   	nop
  80181f:	c9                   	leave  
  801820:	c3                   	ret    

00801821 <sys_cgetc>:

int
sys_cgetc(void)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 02                	push   $0x2
  801830:	e8 96 ff ff ff       	call   8017cb <syscall>
  801835:	83 c4 18             	add    $0x18,%esp
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sys_lock_cons>:

void sys_lock_cons(void)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 03                	push   $0x3
  801849:	e8 7d ff ff ff       	call   8017cb <syscall>
  80184e:	83 c4 18             	add    $0x18,%esp
}
  801851:	90                   	nop
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 04                	push   $0x4
  801863:	e8 63 ff ff ff       	call   8017cb <syscall>
  801868:	83 c4 18             	add    $0x18,%esp
}
  80186b:	90                   	nop
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801871:	8b 55 0c             	mov    0xc(%ebp),%edx
  801874:	8b 45 08             	mov    0x8(%ebp),%eax
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	52                   	push   %edx
  80187e:	50                   	push   %eax
  80187f:	6a 08                	push   $0x8
  801881:	e8 45 ff ff ff       	call   8017cb <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
}
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
  80188e:	56                   	push   %esi
  80188f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801890:	8b 75 18             	mov    0x18(%ebp),%esi
  801893:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801896:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801899:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189c:	8b 45 08             	mov    0x8(%ebp),%eax
  80189f:	56                   	push   %esi
  8018a0:	53                   	push   %ebx
  8018a1:	51                   	push   %ecx
  8018a2:	52                   	push   %edx
  8018a3:	50                   	push   %eax
  8018a4:	6a 09                	push   $0x9
  8018a6:	e8 20 ff ff ff       	call   8017cb <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
}
  8018ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b1:	5b                   	pop    %ebx
  8018b2:	5e                   	pop    %esi
  8018b3:	5d                   	pop    %ebp
  8018b4:	c3                   	ret    

008018b5 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	ff 75 08             	pushl  0x8(%ebp)
  8018c3:	6a 0a                	push   $0xa
  8018c5:	e8 01 ff ff ff       	call   8017cb <syscall>
  8018ca:	83 c4 18             	add    $0x18,%esp
}
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	ff 75 0c             	pushl  0xc(%ebp)
  8018db:	ff 75 08             	pushl  0x8(%ebp)
  8018de:	6a 0b                	push   $0xb
  8018e0:	e8 e6 fe ff ff       	call   8017cb <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 0c                	push   $0xc
  8018f9:	e8 cd fe ff ff       	call   8017cb <syscall>
  8018fe:	83 c4 18             	add    $0x18,%esp
}
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 0d                	push   $0xd
  801912:	e8 b4 fe ff ff       	call   8017cb <syscall>
  801917:	83 c4 18             	add    $0x18,%esp
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 0e                	push   $0xe
  80192b:	e8 9b fe ff ff       	call   8017cb <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 0f                	push   $0xf
  801944:	e8 82 fe ff ff       	call   8017cb <syscall>
  801949:	83 c4 18             	add    $0x18,%esp
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	ff 75 08             	pushl  0x8(%ebp)
  80195c:	6a 10                	push   $0x10
  80195e:	e8 68 fe ff ff       	call   8017cb <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
}
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 11                	push   $0x11
  801977:	e8 4f fe ff ff       	call   8017cb <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
}
  80197f:	90                   	nop
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <sys_cputc>:

void
sys_cputc(const char c)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
  801985:	83 ec 04             	sub    $0x4,%esp
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80198e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	50                   	push   %eax
  80199b:	6a 01                	push   $0x1
  80199d:	e8 29 fe ff ff       	call   8017cb <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	90                   	nop
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 14                	push   $0x14
  8019b7:	e8 0f fe ff ff       	call   8017cb <syscall>
  8019bc:	83 c4 18             	add    $0x18,%esp
}
  8019bf:	90                   	nop
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
  8019c5:	83 ec 04             	sub    $0x4,%esp
  8019c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019cb:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019ce:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019d1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	6a 00                	push   $0x0
  8019da:	51                   	push   %ecx
  8019db:	52                   	push   %edx
  8019dc:	ff 75 0c             	pushl  0xc(%ebp)
  8019df:	50                   	push   %eax
  8019e0:	6a 15                	push   $0x15
  8019e2:	e8 e4 fd ff ff       	call   8017cb <syscall>
  8019e7:	83 c4 18             	add    $0x18,%esp
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	52                   	push   %edx
  8019fc:	50                   	push   %eax
  8019fd:	6a 16                	push   $0x16
  8019ff:	e8 c7 fd ff ff       	call   8017cb <syscall>
  801a04:	83 c4 18             	add    $0x18,%esp
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a0c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	51                   	push   %ecx
  801a1a:	52                   	push   %edx
  801a1b:	50                   	push   %eax
  801a1c:	6a 17                	push   $0x17
  801a1e:	e8 a8 fd ff ff       	call   8017cb <syscall>
  801a23:	83 c4 18             	add    $0x18,%esp
}
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	52                   	push   %edx
  801a38:	50                   	push   %eax
  801a39:	6a 18                	push   $0x18
  801a3b:	e8 8b fd ff ff       	call   8017cb <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a48:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4b:	6a 00                	push   $0x0
  801a4d:	ff 75 14             	pushl  0x14(%ebp)
  801a50:	ff 75 10             	pushl  0x10(%ebp)
  801a53:	ff 75 0c             	pushl  0xc(%ebp)
  801a56:	50                   	push   %eax
  801a57:	6a 19                	push   $0x19
  801a59:	e8 6d fd ff ff       	call   8017cb <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a66:	8b 45 08             	mov    0x8(%ebp),%eax
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	50                   	push   %eax
  801a72:	6a 1a                	push   $0x1a
  801a74:	e8 52 fd ff ff       	call   8017cb <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	90                   	nop
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a82:	8b 45 08             	mov    0x8(%ebp),%eax
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	50                   	push   %eax
  801a8e:	6a 1b                	push   $0x1b
  801a90:	e8 36 fd ff ff       	call   8017cb <syscall>
  801a95:	83 c4 18             	add    $0x18,%esp
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 05                	push   $0x5
  801aa9:	e8 1d fd ff ff       	call   8017cb <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 06                	push   $0x6
  801ac2:	e8 04 fd ff ff       	call   8017cb <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 07                	push   $0x7
  801adb:	e8 eb fc ff ff       	call   8017cb <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_exit_env>:


void sys_exit_env(void)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 1c                	push   $0x1c
  801af4:	e8 d2 fc ff ff       	call   8017cb <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
}
  801afc:	90                   	nop
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
  801b02:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b05:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b08:	8d 50 04             	lea    0x4(%eax),%edx
  801b0b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	52                   	push   %edx
  801b15:	50                   	push   %eax
  801b16:	6a 1d                	push   $0x1d
  801b18:	e8 ae fc ff ff       	call   8017cb <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
	return result;
  801b20:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b23:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b26:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b29:	89 01                	mov    %eax,(%ecx)
  801b2b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b31:	c9                   	leave  
  801b32:	c2 04 00             	ret    $0x4

00801b35 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	ff 75 10             	pushl  0x10(%ebp)
  801b3f:	ff 75 0c             	pushl  0xc(%ebp)
  801b42:	ff 75 08             	pushl  0x8(%ebp)
  801b45:	6a 13                	push   $0x13
  801b47:	e8 7f fc ff ff       	call   8017cb <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4f:	90                   	nop
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 1e                	push   $0x1e
  801b61:	e8 65 fc ff ff       	call   8017cb <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
}
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
  801b6e:	83 ec 04             	sub    $0x4,%esp
  801b71:	8b 45 08             	mov    0x8(%ebp),%eax
  801b74:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b77:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	50                   	push   %eax
  801b84:	6a 1f                	push   $0x1f
  801b86:	e8 40 fc ff ff       	call   8017cb <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8e:	90                   	nop
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <rsttst>:
void rsttst()
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 21                	push   $0x21
  801ba0:	e8 26 fc ff ff       	call   8017cb <syscall>
  801ba5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba8:	90                   	nop
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
  801bae:	83 ec 04             	sub    $0x4,%esp
  801bb1:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bb7:	8b 55 18             	mov    0x18(%ebp),%edx
  801bba:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bbe:	52                   	push   %edx
  801bbf:	50                   	push   %eax
  801bc0:	ff 75 10             	pushl  0x10(%ebp)
  801bc3:	ff 75 0c             	pushl  0xc(%ebp)
  801bc6:	ff 75 08             	pushl  0x8(%ebp)
  801bc9:	6a 20                	push   $0x20
  801bcb:	e8 fb fb ff ff       	call   8017cb <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd3:	90                   	nop
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <chktst>:
void chktst(uint32 n)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	ff 75 08             	pushl  0x8(%ebp)
  801be4:	6a 22                	push   $0x22
  801be6:	e8 e0 fb ff ff       	call   8017cb <syscall>
  801beb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bee:	90                   	nop
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <inctst>:

void inctst()
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 23                	push   $0x23
  801c00:	e8 c6 fb ff ff       	call   8017cb <syscall>
  801c05:	83 c4 18             	add    $0x18,%esp
	return ;
  801c08:	90                   	nop
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <gettst>:
uint32 gettst()
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 24                	push   $0x24
  801c1a:	e8 ac fb ff ff       	call   8017cb <syscall>
  801c1f:	83 c4 18             	add    $0x18,%esp
}
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    

00801c24 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 25                	push   $0x25
  801c33:	e8 93 fb ff ff       	call   8017cb <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
  801c3b:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801c40:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4d:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	ff 75 08             	pushl  0x8(%ebp)
  801c5d:	6a 26                	push   $0x26
  801c5f:	e8 67 fb ff ff       	call   8017cb <syscall>
  801c64:	83 c4 18             	add    $0x18,%esp
	return ;
  801c67:	90                   	nop
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
  801c6d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c6e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c71:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c74:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	6a 00                	push   $0x0
  801c7c:	53                   	push   %ebx
  801c7d:	51                   	push   %ecx
  801c7e:	52                   	push   %edx
  801c7f:	50                   	push   %eax
  801c80:	6a 27                	push   $0x27
  801c82:	e8 44 fb ff ff       	call   8017cb <syscall>
  801c87:	83 c4 18             	add    $0x18,%esp
}
  801c8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c95:	8b 45 08             	mov    0x8(%ebp),%eax
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	52                   	push   %edx
  801c9f:	50                   	push   %eax
  801ca0:	6a 28                	push   $0x28
  801ca2:	e8 24 fb ff ff       	call   8017cb <syscall>
  801ca7:	83 c4 18             	add    $0x18,%esp
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801caf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb8:	6a 00                	push   $0x0
  801cba:	51                   	push   %ecx
  801cbb:	ff 75 10             	pushl  0x10(%ebp)
  801cbe:	52                   	push   %edx
  801cbf:	50                   	push   %eax
  801cc0:	6a 29                	push   $0x29
  801cc2:	e8 04 fb ff ff       	call   8017cb <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	ff 75 10             	pushl  0x10(%ebp)
  801cd6:	ff 75 0c             	pushl  0xc(%ebp)
  801cd9:	ff 75 08             	pushl  0x8(%ebp)
  801cdc:	6a 12                	push   $0x12
  801cde:	e8 e8 fa ff ff       	call   8017cb <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce6:	90                   	nop
}
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801cec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cef:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	52                   	push   %edx
  801cf9:	50                   	push   %eax
  801cfa:	6a 2a                	push   $0x2a
  801cfc:	e8 ca fa ff ff       	call   8017cb <syscall>
  801d01:	83 c4 18             	add    $0x18,%esp
	return;
  801d04:	90                   	nop
}
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 2b                	push   $0x2b
  801d16:	e8 b0 fa ff ff       	call   8017cb <syscall>
  801d1b:	83 c4 18             	add    $0x18,%esp
}
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    

00801d20 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	ff 75 0c             	pushl  0xc(%ebp)
  801d2c:	ff 75 08             	pushl  0x8(%ebp)
  801d2f:	6a 2d                	push   $0x2d
  801d31:	e8 95 fa ff ff       	call   8017cb <syscall>
  801d36:	83 c4 18             	add    $0x18,%esp
	return;
  801d39:	90                   	nop
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	ff 75 0c             	pushl  0xc(%ebp)
  801d48:	ff 75 08             	pushl  0x8(%ebp)
  801d4b:	6a 2c                	push   $0x2c
  801d4d:	e8 79 fa ff ff       	call   8017cb <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
	return ;
  801d55:	90                   	nop
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
  801d5b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801d5e:	83 ec 04             	sub    $0x4,%esp
  801d61:	68 54 2c 80 00       	push   $0x802c54
  801d66:	68 25 01 00 00       	push   $0x125
  801d6b:	68 87 2c 80 00       	push   $0x802c87
  801d70:	e8 ec e6 ff ff       	call   800461 <_panic>

00801d75 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7e:	ba 60 30 80 00       	mov    $0x803060,%edx
  801d83:	29 d0                	sub    %edx,%eax
  801d85:	c1 f8 02             	sar    $0x2,%eax
  801d88:	89 c2                	mov    %eax,%edx
  801d8a:	89 d0                	mov    %edx,%eax
  801d8c:	c1 e0 02             	shl    $0x2,%eax
  801d8f:	01 d0                	add    %edx,%eax
  801d91:	c1 e0 02             	shl    $0x2,%eax
  801d94:	01 d0                	add    %edx,%eax
  801d96:	c1 e0 02             	shl    $0x2,%eax
  801d99:	01 d0                	add    %edx,%eax
  801d9b:	89 c1                	mov    %eax,%ecx
  801d9d:	c1 e1 08             	shl    $0x8,%ecx
  801da0:	01 c8                	add    %ecx,%eax
  801da2:	89 c1                	mov    %eax,%ecx
  801da4:	c1 e1 10             	shl    $0x10,%ecx
  801da7:	01 c8                	add    %ecx,%eax
  801da9:	01 c0                	add    %eax,%eax
  801dab:	01 d0                	add    %edx,%eax
  801dad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801db0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801db3:	c1 e0 0c             	shl    $0xc,%eax
  801db6:	89 c2                	mov    %eax,%edx
  801db8:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801dbd:	01 d0                	add    %edx,%eax
}
  801dbf:	c9                   	leave  
  801dc0:	c3                   	ret    

00801dc1 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dca:	05 00 00 00 02       	add    $0x2000000,%eax
  801dcf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801dd2:	73 16                	jae    801dea <initialize_dynamic_allocator+0x29>
  801dd4:	68 98 2c 80 00       	push   $0x802c98
  801dd9:	68 be 2c 80 00       	push   $0x802cbe
  801dde:	6a 26                	push   $0x26
  801de0:	68 d3 2c 80 00       	push   $0x802cd3
  801de5:	e8 77 e6 ff ff       	call   800461 <_panic>
		is_initialized = 1;
  801dea:	c7 05 24 30 80 00 01 	movl   $0x1,0x803024
  801df1:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  801df4:	83 ec 04             	sub    $0x4,%esp
  801df7:	68 ec 2c 80 00       	push   $0x802cec
  801dfc:	6a 2e                	push   $0x2e
  801dfe:	68 d3 2c 80 00       	push   $0x802cd3
  801e03:	e8 59 e6 ff ff       	call   800461 <_panic>

00801e08 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
  801e0b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  801e0e:	83 ec 04             	sub    $0x4,%esp
  801e11:	68 20 2d 80 00       	push   $0x802d20
  801e16:	6a 3a                	push   $0x3a
  801e18:	68 d3 2c 80 00       	push   $0x802cd3
  801e1d:	e8 3f e6 ff ff       	call   800461 <_panic>

00801e22 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801e28:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801e2f:	76 16                	jbe    801e47 <alloc_block+0x25>
  801e31:	68 48 2d 80 00       	push   $0x802d48
  801e36:	68 be 2c 80 00       	push   $0x802cbe
  801e3b:	6a 46                	push   $0x46
  801e3d:	68 d3 2c 80 00       	push   $0x802cd3
  801e42:	e8 1a e6 ff ff       	call   800461 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  801e47:	83 ec 04             	sub    $0x4,%esp
  801e4a:	68 6c 2d 80 00       	push   $0x802d6c
  801e4f:	6a 4d                	push   $0x4d
  801e51:	68 d3 2c 80 00       	push   $0x802cd3
  801e56:	e8 06 e6 ff ff       	call   800461 <_panic>

00801e5b <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  801e61:	8b 55 08             	mov    0x8(%ebp),%edx
  801e64:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801e69:	39 c2                	cmp    %eax,%edx
  801e6b:	72 0c                	jb     801e79 <free_block+0x1e>
  801e6d:	8b 55 08             	mov    0x8(%ebp),%edx
  801e70:	a1 40 30 80 00       	mov    0x803040,%eax
  801e75:	39 c2                	cmp    %eax,%edx
  801e77:	72 16                	jb     801e8f <free_block+0x34>
  801e79:	68 90 2d 80 00       	push   $0x802d90
  801e7e:	68 be 2c 80 00       	push   $0x802cbe
  801e83:	6a 5b                	push   $0x5b
  801e85:	68 d3 2c 80 00       	push   $0x802cd3
  801e8a:	e8 d2 e5 ff ff       	call   800461 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  801e8f:	83 ec 04             	sub    $0x4,%esp
  801e92:	68 c8 2d 80 00       	push   $0x802dc8
  801e97:	6a 63                	push   $0x63
  801e99:	68 d3 2c 80 00       	push   $0x802cd3
  801e9e:	e8 be e5 ff ff       	call   800461 <_panic>

00801ea3 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
  801ea6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  801ea9:	83 ec 04             	sub    $0x4,%esp
  801eac:	68 ec 2d 80 00       	push   $0x802dec
  801eb1:	6a 72                	push   $0x72
  801eb3:	68 d3 2c 80 00       	push   $0x802cd3
  801eb8:	e8 a4 e5 ff ff       	call   800461 <_panic>

00801ebd <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801ec3:	8b 55 08             	mov    0x8(%ebp),%edx
  801ec6:	89 d0                	mov    %edx,%eax
  801ec8:	c1 e0 02             	shl    $0x2,%eax
  801ecb:	01 d0                	add    %edx,%eax
  801ecd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ed4:	01 d0                	add    %edx,%eax
  801ed6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801edd:	01 d0                	add    %edx,%eax
  801edf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ee6:	01 d0                	add    %edx,%eax
  801ee8:	c1 e0 04             	shl    $0x4,%eax
  801eeb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801eee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801ef5:	0f 31                	rdtsc  
  801ef7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801efa:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801efd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f00:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f06:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801f09:	eb 46                	jmp    801f51 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801f0b:	0f 31                	rdtsc  
  801f0d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801f10:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801f13:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f16:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801f19:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801f1c:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801f1f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f25:	29 c2                	sub    %eax,%edx
  801f27:	89 d0                	mov    %edx,%eax
  801f29:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801f2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f32:	89 d1                	mov    %edx,%ecx
  801f34:	29 c1                	sub    %eax,%ecx
  801f36:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f3c:	39 c2                	cmp    %eax,%edx
  801f3e:	0f 97 c0             	seta   %al
  801f41:	0f b6 c0             	movzbl %al,%eax
  801f44:	29 c1                	sub    %eax,%ecx
  801f46:	89 c8                	mov    %ecx,%eax
  801f48:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801f4b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801f51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f54:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801f57:	72 b2                	jb     801f0b <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801f59:	90                   	nop
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801f62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801f69:	eb 03                	jmp    801f6e <busy_wait+0x12>
  801f6b:	ff 45 fc             	incl   -0x4(%ebp)
  801f6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f71:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f74:	72 f5                	jb     801f6b <busy_wait+0xf>
	return i;
  801f76:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f79:	c9                   	leave  
  801f7a:	c3                   	ret    
  801f7b:	90                   	nop

00801f7c <__udivdi3>:
  801f7c:	55                   	push   %ebp
  801f7d:	57                   	push   %edi
  801f7e:	56                   	push   %esi
  801f7f:	53                   	push   %ebx
  801f80:	83 ec 1c             	sub    $0x1c,%esp
  801f83:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801f87:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801f8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f8f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f93:	89 ca                	mov    %ecx,%edx
  801f95:	89 f8                	mov    %edi,%eax
  801f97:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801f9b:	85 f6                	test   %esi,%esi
  801f9d:	75 2d                	jne    801fcc <__udivdi3+0x50>
  801f9f:	39 cf                	cmp    %ecx,%edi
  801fa1:	77 65                	ja     802008 <__udivdi3+0x8c>
  801fa3:	89 fd                	mov    %edi,%ebp
  801fa5:	85 ff                	test   %edi,%edi
  801fa7:	75 0b                	jne    801fb4 <__udivdi3+0x38>
  801fa9:	b8 01 00 00 00       	mov    $0x1,%eax
  801fae:	31 d2                	xor    %edx,%edx
  801fb0:	f7 f7                	div    %edi
  801fb2:	89 c5                	mov    %eax,%ebp
  801fb4:	31 d2                	xor    %edx,%edx
  801fb6:	89 c8                	mov    %ecx,%eax
  801fb8:	f7 f5                	div    %ebp
  801fba:	89 c1                	mov    %eax,%ecx
  801fbc:	89 d8                	mov    %ebx,%eax
  801fbe:	f7 f5                	div    %ebp
  801fc0:	89 cf                	mov    %ecx,%edi
  801fc2:	89 fa                	mov    %edi,%edx
  801fc4:	83 c4 1c             	add    $0x1c,%esp
  801fc7:	5b                   	pop    %ebx
  801fc8:	5e                   	pop    %esi
  801fc9:	5f                   	pop    %edi
  801fca:	5d                   	pop    %ebp
  801fcb:	c3                   	ret    
  801fcc:	39 ce                	cmp    %ecx,%esi
  801fce:	77 28                	ja     801ff8 <__udivdi3+0x7c>
  801fd0:	0f bd fe             	bsr    %esi,%edi
  801fd3:	83 f7 1f             	xor    $0x1f,%edi
  801fd6:	75 40                	jne    802018 <__udivdi3+0x9c>
  801fd8:	39 ce                	cmp    %ecx,%esi
  801fda:	72 0a                	jb     801fe6 <__udivdi3+0x6a>
  801fdc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801fe0:	0f 87 9e 00 00 00    	ja     802084 <__udivdi3+0x108>
  801fe6:	b8 01 00 00 00       	mov    $0x1,%eax
  801feb:	89 fa                	mov    %edi,%edx
  801fed:	83 c4 1c             	add    $0x1c,%esp
  801ff0:	5b                   	pop    %ebx
  801ff1:	5e                   	pop    %esi
  801ff2:	5f                   	pop    %edi
  801ff3:	5d                   	pop    %ebp
  801ff4:	c3                   	ret    
  801ff5:	8d 76 00             	lea    0x0(%esi),%esi
  801ff8:	31 ff                	xor    %edi,%edi
  801ffa:	31 c0                	xor    %eax,%eax
  801ffc:	89 fa                	mov    %edi,%edx
  801ffe:	83 c4 1c             	add    $0x1c,%esp
  802001:	5b                   	pop    %ebx
  802002:	5e                   	pop    %esi
  802003:	5f                   	pop    %edi
  802004:	5d                   	pop    %ebp
  802005:	c3                   	ret    
  802006:	66 90                	xchg   %ax,%ax
  802008:	89 d8                	mov    %ebx,%eax
  80200a:	f7 f7                	div    %edi
  80200c:	31 ff                	xor    %edi,%edi
  80200e:	89 fa                	mov    %edi,%edx
  802010:	83 c4 1c             	add    $0x1c,%esp
  802013:	5b                   	pop    %ebx
  802014:	5e                   	pop    %esi
  802015:	5f                   	pop    %edi
  802016:	5d                   	pop    %ebp
  802017:	c3                   	ret    
  802018:	bd 20 00 00 00       	mov    $0x20,%ebp
  80201d:	89 eb                	mov    %ebp,%ebx
  80201f:	29 fb                	sub    %edi,%ebx
  802021:	89 f9                	mov    %edi,%ecx
  802023:	d3 e6                	shl    %cl,%esi
  802025:	89 c5                	mov    %eax,%ebp
  802027:	88 d9                	mov    %bl,%cl
  802029:	d3 ed                	shr    %cl,%ebp
  80202b:	89 e9                	mov    %ebp,%ecx
  80202d:	09 f1                	or     %esi,%ecx
  80202f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802033:	89 f9                	mov    %edi,%ecx
  802035:	d3 e0                	shl    %cl,%eax
  802037:	89 c5                	mov    %eax,%ebp
  802039:	89 d6                	mov    %edx,%esi
  80203b:	88 d9                	mov    %bl,%cl
  80203d:	d3 ee                	shr    %cl,%esi
  80203f:	89 f9                	mov    %edi,%ecx
  802041:	d3 e2                	shl    %cl,%edx
  802043:	8b 44 24 08          	mov    0x8(%esp),%eax
  802047:	88 d9                	mov    %bl,%cl
  802049:	d3 e8                	shr    %cl,%eax
  80204b:	09 c2                	or     %eax,%edx
  80204d:	89 d0                	mov    %edx,%eax
  80204f:	89 f2                	mov    %esi,%edx
  802051:	f7 74 24 0c          	divl   0xc(%esp)
  802055:	89 d6                	mov    %edx,%esi
  802057:	89 c3                	mov    %eax,%ebx
  802059:	f7 e5                	mul    %ebp
  80205b:	39 d6                	cmp    %edx,%esi
  80205d:	72 19                	jb     802078 <__udivdi3+0xfc>
  80205f:	74 0b                	je     80206c <__udivdi3+0xf0>
  802061:	89 d8                	mov    %ebx,%eax
  802063:	31 ff                	xor    %edi,%edi
  802065:	e9 58 ff ff ff       	jmp    801fc2 <__udivdi3+0x46>
  80206a:	66 90                	xchg   %ax,%ax
  80206c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802070:	89 f9                	mov    %edi,%ecx
  802072:	d3 e2                	shl    %cl,%edx
  802074:	39 c2                	cmp    %eax,%edx
  802076:	73 e9                	jae    802061 <__udivdi3+0xe5>
  802078:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80207b:	31 ff                	xor    %edi,%edi
  80207d:	e9 40 ff ff ff       	jmp    801fc2 <__udivdi3+0x46>
  802082:	66 90                	xchg   %ax,%ax
  802084:	31 c0                	xor    %eax,%eax
  802086:	e9 37 ff ff ff       	jmp    801fc2 <__udivdi3+0x46>
  80208b:	90                   	nop

0080208c <__umoddi3>:
  80208c:	55                   	push   %ebp
  80208d:	57                   	push   %edi
  80208e:	56                   	push   %esi
  80208f:	53                   	push   %ebx
  802090:	83 ec 1c             	sub    $0x1c,%esp
  802093:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802097:	8b 74 24 34          	mov    0x34(%esp),%esi
  80209b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80209f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8020a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020ab:	89 f3                	mov    %esi,%ebx
  8020ad:	89 fa                	mov    %edi,%edx
  8020af:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020b3:	89 34 24             	mov    %esi,(%esp)
  8020b6:	85 c0                	test   %eax,%eax
  8020b8:	75 1a                	jne    8020d4 <__umoddi3+0x48>
  8020ba:	39 f7                	cmp    %esi,%edi
  8020bc:	0f 86 a2 00 00 00    	jbe    802164 <__umoddi3+0xd8>
  8020c2:	89 c8                	mov    %ecx,%eax
  8020c4:	89 f2                	mov    %esi,%edx
  8020c6:	f7 f7                	div    %edi
  8020c8:	89 d0                	mov    %edx,%eax
  8020ca:	31 d2                	xor    %edx,%edx
  8020cc:	83 c4 1c             	add    $0x1c,%esp
  8020cf:	5b                   	pop    %ebx
  8020d0:	5e                   	pop    %esi
  8020d1:	5f                   	pop    %edi
  8020d2:	5d                   	pop    %ebp
  8020d3:	c3                   	ret    
  8020d4:	39 f0                	cmp    %esi,%eax
  8020d6:	0f 87 ac 00 00 00    	ja     802188 <__umoddi3+0xfc>
  8020dc:	0f bd e8             	bsr    %eax,%ebp
  8020df:	83 f5 1f             	xor    $0x1f,%ebp
  8020e2:	0f 84 ac 00 00 00    	je     802194 <__umoddi3+0x108>
  8020e8:	bf 20 00 00 00       	mov    $0x20,%edi
  8020ed:	29 ef                	sub    %ebp,%edi
  8020ef:	89 fe                	mov    %edi,%esi
  8020f1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020f5:	89 e9                	mov    %ebp,%ecx
  8020f7:	d3 e0                	shl    %cl,%eax
  8020f9:	89 d7                	mov    %edx,%edi
  8020fb:	89 f1                	mov    %esi,%ecx
  8020fd:	d3 ef                	shr    %cl,%edi
  8020ff:	09 c7                	or     %eax,%edi
  802101:	89 e9                	mov    %ebp,%ecx
  802103:	d3 e2                	shl    %cl,%edx
  802105:	89 14 24             	mov    %edx,(%esp)
  802108:	89 d8                	mov    %ebx,%eax
  80210a:	d3 e0                	shl    %cl,%eax
  80210c:	89 c2                	mov    %eax,%edx
  80210e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802112:	d3 e0                	shl    %cl,%eax
  802114:	89 44 24 04          	mov    %eax,0x4(%esp)
  802118:	8b 44 24 08          	mov    0x8(%esp),%eax
  80211c:	89 f1                	mov    %esi,%ecx
  80211e:	d3 e8                	shr    %cl,%eax
  802120:	09 d0                	or     %edx,%eax
  802122:	d3 eb                	shr    %cl,%ebx
  802124:	89 da                	mov    %ebx,%edx
  802126:	f7 f7                	div    %edi
  802128:	89 d3                	mov    %edx,%ebx
  80212a:	f7 24 24             	mull   (%esp)
  80212d:	89 c6                	mov    %eax,%esi
  80212f:	89 d1                	mov    %edx,%ecx
  802131:	39 d3                	cmp    %edx,%ebx
  802133:	0f 82 87 00 00 00    	jb     8021c0 <__umoddi3+0x134>
  802139:	0f 84 91 00 00 00    	je     8021d0 <__umoddi3+0x144>
  80213f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802143:	29 f2                	sub    %esi,%edx
  802145:	19 cb                	sbb    %ecx,%ebx
  802147:	89 d8                	mov    %ebx,%eax
  802149:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80214d:	d3 e0                	shl    %cl,%eax
  80214f:	89 e9                	mov    %ebp,%ecx
  802151:	d3 ea                	shr    %cl,%edx
  802153:	09 d0                	or     %edx,%eax
  802155:	89 e9                	mov    %ebp,%ecx
  802157:	d3 eb                	shr    %cl,%ebx
  802159:	89 da                	mov    %ebx,%edx
  80215b:	83 c4 1c             	add    $0x1c,%esp
  80215e:	5b                   	pop    %ebx
  80215f:	5e                   	pop    %esi
  802160:	5f                   	pop    %edi
  802161:	5d                   	pop    %ebp
  802162:	c3                   	ret    
  802163:	90                   	nop
  802164:	89 fd                	mov    %edi,%ebp
  802166:	85 ff                	test   %edi,%edi
  802168:	75 0b                	jne    802175 <__umoddi3+0xe9>
  80216a:	b8 01 00 00 00       	mov    $0x1,%eax
  80216f:	31 d2                	xor    %edx,%edx
  802171:	f7 f7                	div    %edi
  802173:	89 c5                	mov    %eax,%ebp
  802175:	89 f0                	mov    %esi,%eax
  802177:	31 d2                	xor    %edx,%edx
  802179:	f7 f5                	div    %ebp
  80217b:	89 c8                	mov    %ecx,%eax
  80217d:	f7 f5                	div    %ebp
  80217f:	89 d0                	mov    %edx,%eax
  802181:	e9 44 ff ff ff       	jmp    8020ca <__umoddi3+0x3e>
  802186:	66 90                	xchg   %ax,%ax
  802188:	89 c8                	mov    %ecx,%eax
  80218a:	89 f2                	mov    %esi,%edx
  80218c:	83 c4 1c             	add    $0x1c,%esp
  80218f:	5b                   	pop    %ebx
  802190:	5e                   	pop    %esi
  802191:	5f                   	pop    %edi
  802192:	5d                   	pop    %ebp
  802193:	c3                   	ret    
  802194:	3b 04 24             	cmp    (%esp),%eax
  802197:	72 06                	jb     80219f <__umoddi3+0x113>
  802199:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80219d:	77 0f                	ja     8021ae <__umoddi3+0x122>
  80219f:	89 f2                	mov    %esi,%edx
  8021a1:	29 f9                	sub    %edi,%ecx
  8021a3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8021a7:	89 14 24             	mov    %edx,(%esp)
  8021aa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021ae:	8b 44 24 04          	mov    0x4(%esp),%eax
  8021b2:	8b 14 24             	mov    (%esp),%edx
  8021b5:	83 c4 1c             	add    $0x1c,%esp
  8021b8:	5b                   	pop    %ebx
  8021b9:	5e                   	pop    %esi
  8021ba:	5f                   	pop    %edi
  8021bb:	5d                   	pop    %ebp
  8021bc:	c3                   	ret    
  8021bd:	8d 76 00             	lea    0x0(%esi),%esi
  8021c0:	2b 04 24             	sub    (%esp),%eax
  8021c3:	19 fa                	sbb    %edi,%edx
  8021c5:	89 d1                	mov    %edx,%ecx
  8021c7:	89 c6                	mov    %eax,%esi
  8021c9:	e9 71 ff ff ff       	jmp    80213f <__umoddi3+0xb3>
  8021ce:	66 90                	xchg   %ax,%ax
  8021d0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8021d4:	72 ea                	jb     8021c0 <__umoddi3+0x134>
  8021d6:	89 d9                	mov    %ebx,%ecx
  8021d8:	e9 62 ff ff ff       	jmp    80213f <__umoddi3+0xb3>

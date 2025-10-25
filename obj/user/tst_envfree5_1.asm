
obj/user/tst_envfree5_1:     file format elf32-i386


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
  800031:	e8 17 01 00 00       	call   80014d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	// Testing removing the shared variables
	// Testing scenario 5_1: Kill ONE program has shared variables and it frees them
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 c0 1f 80 00       	push   $0x801fc0
  80004a:	e8 86 15 00 00       	call   8015d5 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 23 17 00 00       	call   801786 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 66 17 00 00       	call   8017d1 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 d0 1f 80 00       	push   $0x801fd0
  800079:	e8 4d 05 00 00       	call   8005cb <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 3000,(myEnv->SecondListSize), 50);
  800081:	a1 20 30 80 00       	mov    0x803020,%eax
  800086:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 b8 0b 00 00       	push   $0xbb8
  800094:	68 03 20 80 00       	push   $0x802003
  800099:	e8 43 18 00 00       	call   8018e1 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000aa:	e8 50 18 00 00       	call   8018ff <sys_run_env>
  8000af:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000b2:	90                   	nop
  8000b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b6:	8b 00                	mov    (%eax),%eax
  8000b8:	83 f8 01             	cmp    $0x1,%eax
  8000bb:	75 f6                	jne    8000b3 <_main+0x7b>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000bd:	e8 c4 16 00 00       	call   801786 <sys_calculate_free_frames>
  8000c2:	83 ec 08             	sub    $0x8,%esp
  8000c5:	50                   	push   %eax
  8000c6:	68 0c 20 80 00       	push   $0x80200c
  8000cb:	e8 fb 04 00 00       	call   8005cb <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d9:	e8 3d 18 00 00       	call   80191b <sys_destroy_env>
  8000de:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000e1:	e8 a0 16 00 00       	call   801786 <sys_calculate_free_frames>
  8000e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e9:	e8 e3 16 00 00       	call   8017d1 <sys_pf_calculate_allocated_pages>
  8000ee:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f7:	74 2e                	je     800127 <_main+0xef>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d\n",
  8000f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000fc:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8000ff:	83 ec 04             	sub    $0x4,%esp
  800102:	50                   	push   %eax
  800103:	ff 75 e4             	pushl  -0x1c(%ebp)
  800106:	68 40 20 80 00       	push   $0x802040
  80010b:	e8 bb 04 00 00       	call   8005cb <cprintf>
  800110:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before);
		panic("env_free() does not work correctly... check it again.");
  800113:	83 ec 04             	sub    $0x4,%esp
  800116:	68 a0 20 80 00       	push   $0x8020a0
  80011b:	6a 1f                	push   $0x1f
  80011d:	68 d6 20 80 00       	push   $0x8020d6
  800122:	e8 d6 01 00 00       	call   8002fd <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800127:	83 ec 08             	sub    $0x8,%esp
  80012a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80012d:	68 ec 20 80 00       	push   $0x8020ec
  800132:	e8 94 04 00 00       	call   8005cb <cprintf>
  800137:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_1 for envfree completed successfully.\n");
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	68 4c 21 80 00       	push   $0x80214c
  800142:	e8 84 04 00 00       	call   8005cb <cprintf>
  800147:	83 c4 10             	add    $0x10,%esp
	return;
  80014a:	90                   	nop
}
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    

0080014d <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	57                   	push   %edi
  800151:	56                   	push   %esi
  800152:	53                   	push   %ebx
  800153:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800156:	e8 f4 17 00 00       	call   80194f <sys_getenvindex>
  80015b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80015e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800161:	89 d0                	mov    %edx,%eax
  800163:	c1 e0 02             	shl    $0x2,%eax
  800166:	01 d0                	add    %edx,%eax
  800168:	c1 e0 03             	shl    $0x3,%eax
  80016b:	01 d0                	add    %edx,%eax
  80016d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800174:	01 d0                	add    %edx,%eax
  800176:	c1 e0 02             	shl    $0x2,%eax
  800179:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80017e:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800183:	a1 20 30 80 00       	mov    0x803020,%eax
  800188:	8a 40 20             	mov    0x20(%eax),%al
  80018b:	84 c0                	test   %al,%al
  80018d:	74 0d                	je     80019c <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80018f:	a1 20 30 80 00       	mov    0x803020,%eax
  800194:	83 c0 20             	add    $0x20,%eax
  800197:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80019c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001a0:	7e 0a                	jle    8001ac <libmain+0x5f>
		binaryname = argv[0];
  8001a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a5:	8b 00                	mov    (%eax),%eax
  8001a7:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8001ac:	83 ec 08             	sub    $0x8,%esp
  8001af:	ff 75 0c             	pushl  0xc(%ebp)
  8001b2:	ff 75 08             	pushl  0x8(%ebp)
  8001b5:	e8 7e fe ff ff       	call   800038 <_main>
  8001ba:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001bd:	a1 00 30 80 00       	mov    0x803000,%eax
  8001c2:	85 c0                	test   %eax,%eax
  8001c4:	0f 84 01 01 00 00    	je     8002cb <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001ca:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001d0:	bb 90 22 80 00       	mov    $0x802290,%ebx
  8001d5:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001da:	89 c7                	mov    %eax,%edi
  8001dc:	89 de                	mov    %ebx,%esi
  8001de:	89 d1                	mov    %edx,%ecx
  8001e0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001e2:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001e5:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001ea:	b0 00                	mov    $0x0,%al
  8001ec:	89 d7                	mov    %edx,%edi
  8001ee:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001f0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001f7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001fa:	83 ec 08             	sub    $0x8,%esp
  8001fd:	50                   	push   %eax
  8001fe:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800204:	50                   	push   %eax
  800205:	e8 7b 19 00 00       	call   801b85 <sys_utilities>
  80020a:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80020d:	e8 c4 14 00 00       	call   8016d6 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	68 b0 21 80 00       	push   $0x8021b0
  80021a:	e8 ac 03 00 00       	call   8005cb <cprintf>
  80021f:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800222:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800225:	85 c0                	test   %eax,%eax
  800227:	74 18                	je     800241 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800229:	e8 75 19 00 00       	call   801ba3 <sys_get_optimal_num_faults>
  80022e:	83 ec 08             	sub    $0x8,%esp
  800231:	50                   	push   %eax
  800232:	68 d8 21 80 00       	push   $0x8021d8
  800237:	e8 8f 03 00 00       	call   8005cb <cprintf>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	eb 59                	jmp    80029a <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800241:	a1 20 30 80 00       	mov    0x803020,%eax
  800246:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80024c:	a1 20 30 80 00       	mov    0x803020,%eax
  800251:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800257:	83 ec 04             	sub    $0x4,%esp
  80025a:	52                   	push   %edx
  80025b:	50                   	push   %eax
  80025c:	68 fc 21 80 00       	push   $0x8021fc
  800261:	e8 65 03 00 00       	call   8005cb <cprintf>
  800266:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800269:	a1 20 30 80 00       	mov    0x803020,%eax
  80026e:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800274:	a1 20 30 80 00       	mov    0x803020,%eax
  800279:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80027f:	a1 20 30 80 00       	mov    0x803020,%eax
  800284:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80028a:	51                   	push   %ecx
  80028b:	52                   	push   %edx
  80028c:	50                   	push   %eax
  80028d:	68 24 22 80 00       	push   $0x802224
  800292:	e8 34 03 00 00       	call   8005cb <cprintf>
  800297:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80029a:	a1 20 30 80 00       	mov    0x803020,%eax
  80029f:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8002a5:	83 ec 08             	sub    $0x8,%esp
  8002a8:	50                   	push   %eax
  8002a9:	68 7c 22 80 00       	push   $0x80227c
  8002ae:	e8 18 03 00 00       	call   8005cb <cprintf>
  8002b3:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002b6:	83 ec 0c             	sub    $0xc,%esp
  8002b9:	68 b0 21 80 00       	push   $0x8021b0
  8002be:	e8 08 03 00 00       	call   8005cb <cprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002c6:	e8 25 14 00 00       	call   8016f0 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002cb:	e8 1f 00 00 00       	call   8002ef <exit>
}
  8002d0:	90                   	nop
  8002d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d4:	5b                   	pop    %ebx
  8002d5:	5e                   	pop    %esi
  8002d6:	5f                   	pop    %edi
  8002d7:	5d                   	pop    %ebp
  8002d8:	c3                   	ret    

008002d9 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002d9:	55                   	push   %ebp
  8002da:	89 e5                	mov    %esp,%ebp
  8002dc:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002df:	83 ec 0c             	sub    $0xc,%esp
  8002e2:	6a 00                	push   $0x0
  8002e4:	e8 32 16 00 00       	call   80191b <sys_destroy_env>
  8002e9:	83 c4 10             	add    $0x10,%esp
}
  8002ec:	90                   	nop
  8002ed:	c9                   	leave  
  8002ee:	c3                   	ret    

008002ef <exit>:

void
exit(void)
{
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002f5:	e8 87 16 00 00       	call   801981 <sys_exit_env>
}
  8002fa:	90                   	nop
  8002fb:	c9                   	leave  
  8002fc:	c3                   	ret    

008002fd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002fd:	55                   	push   %ebp
  8002fe:	89 e5                	mov    %esp,%ebp
  800300:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800303:	8d 45 10             	lea    0x10(%ebp),%eax
  800306:	83 c0 04             	add    $0x4,%eax
  800309:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80030c:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800311:	85 c0                	test   %eax,%eax
  800313:	74 16                	je     80032b <_panic+0x2e>
		cprintf("%s: ", argv0);
  800315:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80031a:	83 ec 08             	sub    $0x8,%esp
  80031d:	50                   	push   %eax
  80031e:	68 f4 22 80 00       	push   $0x8022f4
  800323:	e8 a3 02 00 00       	call   8005cb <cprintf>
  800328:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80032b:	a1 04 30 80 00       	mov    0x803004,%eax
  800330:	83 ec 0c             	sub    $0xc,%esp
  800333:	ff 75 0c             	pushl  0xc(%ebp)
  800336:	ff 75 08             	pushl  0x8(%ebp)
  800339:	50                   	push   %eax
  80033a:	68 fc 22 80 00       	push   $0x8022fc
  80033f:	6a 74                	push   $0x74
  800341:	e8 b2 02 00 00       	call   8005f8 <cprintf_colored>
  800346:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800349:	8b 45 10             	mov    0x10(%ebp),%eax
  80034c:	83 ec 08             	sub    $0x8,%esp
  80034f:	ff 75 f4             	pushl  -0xc(%ebp)
  800352:	50                   	push   %eax
  800353:	e8 04 02 00 00       	call   80055c <vcprintf>
  800358:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80035b:	83 ec 08             	sub    $0x8,%esp
  80035e:	6a 00                	push   $0x0
  800360:	68 24 23 80 00       	push   $0x802324
  800365:	e8 f2 01 00 00       	call   80055c <vcprintf>
  80036a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80036d:	e8 7d ff ff ff       	call   8002ef <exit>

	// should not return here
	while (1) ;
  800372:	eb fe                	jmp    800372 <_panic+0x75>

00800374 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800374:	55                   	push   %ebp
  800375:	89 e5                	mov    %esp,%ebp
  800377:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80037a:	a1 20 30 80 00       	mov    0x803020,%eax
  80037f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800385:	8b 45 0c             	mov    0xc(%ebp),%eax
  800388:	39 c2                	cmp    %eax,%edx
  80038a:	74 14                	je     8003a0 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80038c:	83 ec 04             	sub    $0x4,%esp
  80038f:	68 28 23 80 00       	push   $0x802328
  800394:	6a 26                	push   $0x26
  800396:	68 74 23 80 00       	push   $0x802374
  80039b:	e8 5d ff ff ff       	call   8002fd <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003ae:	e9 c5 00 00 00       	jmp    800478 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c0:	01 d0                	add    %edx,%eax
  8003c2:	8b 00                	mov    (%eax),%eax
  8003c4:	85 c0                	test   %eax,%eax
  8003c6:	75 08                	jne    8003d0 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003c8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003cb:	e9 a5 00 00 00       	jmp    800475 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003d0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003de:	eb 69                	jmp    800449 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e5:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003ee:	89 d0                	mov    %edx,%eax
  8003f0:	01 c0                	add    %eax,%eax
  8003f2:	01 d0                	add    %edx,%eax
  8003f4:	c1 e0 03             	shl    $0x3,%eax
  8003f7:	01 c8                	add    %ecx,%eax
  8003f9:	8a 40 04             	mov    0x4(%eax),%al
  8003fc:	84 c0                	test   %al,%al
  8003fe:	75 46                	jne    800446 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800400:	a1 20 30 80 00       	mov    0x803020,%eax
  800405:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80040b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80040e:	89 d0                	mov    %edx,%eax
  800410:	01 c0                	add    %eax,%eax
  800412:	01 d0                	add    %edx,%eax
  800414:	c1 e0 03             	shl    $0x3,%eax
  800417:	01 c8                	add    %ecx,%eax
  800419:	8b 00                	mov    (%eax),%eax
  80041b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80041e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800421:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800426:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800428:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800432:	8b 45 08             	mov    0x8(%ebp),%eax
  800435:	01 c8                	add    %ecx,%eax
  800437:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800439:	39 c2                	cmp    %eax,%edx
  80043b:	75 09                	jne    800446 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80043d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800444:	eb 15                	jmp    80045b <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800446:	ff 45 e8             	incl   -0x18(%ebp)
  800449:	a1 20 30 80 00       	mov    0x803020,%eax
  80044e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800454:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800457:	39 c2                	cmp    %eax,%edx
  800459:	77 85                	ja     8003e0 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80045b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80045f:	75 14                	jne    800475 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800461:	83 ec 04             	sub    $0x4,%esp
  800464:	68 80 23 80 00       	push   $0x802380
  800469:	6a 3a                	push   $0x3a
  80046b:	68 74 23 80 00       	push   $0x802374
  800470:	e8 88 fe ff ff       	call   8002fd <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800475:	ff 45 f0             	incl   -0x10(%ebp)
  800478:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80047b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80047e:	0f 8c 2f ff ff ff    	jl     8003b3 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800484:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80048b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800492:	eb 26                	jmp    8004ba <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800494:	a1 20 30 80 00       	mov    0x803020,%eax
  800499:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80049f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004a2:	89 d0                	mov    %edx,%eax
  8004a4:	01 c0                	add    %eax,%eax
  8004a6:	01 d0                	add    %edx,%eax
  8004a8:	c1 e0 03             	shl    $0x3,%eax
  8004ab:	01 c8                	add    %ecx,%eax
  8004ad:	8a 40 04             	mov    0x4(%eax),%al
  8004b0:	3c 01                	cmp    $0x1,%al
  8004b2:	75 03                	jne    8004b7 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004b4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004b7:	ff 45 e0             	incl   -0x20(%ebp)
  8004ba:	a1 20 30 80 00       	mov    0x803020,%eax
  8004bf:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c8:	39 c2                	cmp    %eax,%edx
  8004ca:	77 c8                	ja     800494 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004cf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004d2:	74 14                	je     8004e8 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004d4:	83 ec 04             	sub    $0x4,%esp
  8004d7:	68 d4 23 80 00       	push   $0x8023d4
  8004dc:	6a 44                	push   $0x44
  8004de:	68 74 23 80 00       	push   $0x802374
  8004e3:	e8 15 fe ff ff       	call   8002fd <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004e8:	90                   	nop
  8004e9:	c9                   	leave  
  8004ea:	c3                   	ret    

008004eb <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004eb:	55                   	push   %ebp
  8004ec:	89 e5                	mov    %esp,%ebp
  8004ee:	53                   	push   %ebx
  8004ef:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f5:	8b 00                	mov    (%eax),%eax
  8004f7:	8d 48 01             	lea    0x1(%eax),%ecx
  8004fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004fd:	89 0a                	mov    %ecx,(%edx)
  8004ff:	8b 55 08             	mov    0x8(%ebp),%edx
  800502:	88 d1                	mov    %dl,%cl
  800504:	8b 55 0c             	mov    0xc(%ebp),%edx
  800507:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80050b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050e:	8b 00                	mov    (%eax),%eax
  800510:	3d ff 00 00 00       	cmp    $0xff,%eax
  800515:	75 30                	jne    800547 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800517:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80051d:	a0 44 30 80 00       	mov    0x803044,%al
  800522:	0f b6 c0             	movzbl %al,%eax
  800525:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800528:	8b 09                	mov    (%ecx),%ecx
  80052a:	89 cb                	mov    %ecx,%ebx
  80052c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80052f:	83 c1 08             	add    $0x8,%ecx
  800532:	52                   	push   %edx
  800533:	50                   	push   %eax
  800534:	53                   	push   %ebx
  800535:	51                   	push   %ecx
  800536:	e8 57 11 00 00       	call   801692 <sys_cputs>
  80053b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80053e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800541:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800547:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054a:	8b 40 04             	mov    0x4(%eax),%eax
  80054d:	8d 50 01             	lea    0x1(%eax),%edx
  800550:	8b 45 0c             	mov    0xc(%ebp),%eax
  800553:	89 50 04             	mov    %edx,0x4(%eax)
}
  800556:	90                   	nop
  800557:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80055a:	c9                   	leave  
  80055b:	c3                   	ret    

0080055c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80055c:	55                   	push   %ebp
  80055d:	89 e5                	mov    %esp,%ebp
  80055f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800565:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80056c:	00 00 00 
	b.cnt = 0;
  80056f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800576:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800579:	ff 75 0c             	pushl  0xc(%ebp)
  80057c:	ff 75 08             	pushl  0x8(%ebp)
  80057f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800585:	50                   	push   %eax
  800586:	68 eb 04 80 00       	push   $0x8004eb
  80058b:	e8 5a 02 00 00       	call   8007ea <vprintfmt>
  800590:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800593:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800599:	a0 44 30 80 00       	mov    0x803044,%al
  80059e:	0f b6 c0             	movzbl %al,%eax
  8005a1:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8005a7:	52                   	push   %edx
  8005a8:	50                   	push   %eax
  8005a9:	51                   	push   %ecx
  8005aa:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005b0:	83 c0 08             	add    $0x8,%eax
  8005b3:	50                   	push   %eax
  8005b4:	e8 d9 10 00 00       	call   801692 <sys_cputs>
  8005b9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005bc:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8005c3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005c9:	c9                   	leave  
  8005ca:	c3                   	ret    

008005cb <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005cb:	55                   	push   %ebp
  8005cc:	89 e5                	mov    %esp,%ebp
  8005ce:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005d1:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8005d8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005de:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e1:	83 ec 08             	sub    $0x8,%esp
  8005e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e7:	50                   	push   %eax
  8005e8:	e8 6f ff ff ff       	call   80055c <vcprintf>
  8005ed:	83 c4 10             	add    $0x10,%esp
  8005f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f6:	c9                   	leave  
  8005f7:	c3                   	ret    

008005f8 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005f8:	55                   	push   %ebp
  8005f9:	89 e5                	mov    %esp,%ebp
  8005fb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005fe:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800605:	8b 45 08             	mov    0x8(%ebp),%eax
  800608:	c1 e0 08             	shl    $0x8,%eax
  80060b:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800610:	8d 45 0c             	lea    0xc(%ebp),%eax
  800613:	83 c0 04             	add    $0x4,%eax
  800616:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800619:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061c:	83 ec 08             	sub    $0x8,%esp
  80061f:	ff 75 f4             	pushl  -0xc(%ebp)
  800622:	50                   	push   %eax
  800623:	e8 34 ff ff ff       	call   80055c <vcprintf>
  800628:	83 c4 10             	add    $0x10,%esp
  80062b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80062e:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800635:	07 00 00 

	return cnt;
  800638:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80063b:	c9                   	leave  
  80063c:	c3                   	ret    

0080063d <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80063d:	55                   	push   %ebp
  80063e:	89 e5                	mov    %esp,%ebp
  800640:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800643:	e8 8e 10 00 00       	call   8016d6 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800648:	8d 45 0c             	lea    0xc(%ebp),%eax
  80064b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	ff 75 f4             	pushl  -0xc(%ebp)
  800657:	50                   	push   %eax
  800658:	e8 ff fe ff ff       	call   80055c <vcprintf>
  80065d:	83 c4 10             	add    $0x10,%esp
  800660:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800663:	e8 88 10 00 00       	call   8016f0 <sys_unlock_cons>
	return cnt;
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80066b:	c9                   	leave  
  80066c:	c3                   	ret    

0080066d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80066d:	55                   	push   %ebp
  80066e:	89 e5                	mov    %esp,%ebp
  800670:	53                   	push   %ebx
  800671:	83 ec 14             	sub    $0x14,%esp
  800674:	8b 45 10             	mov    0x10(%ebp),%eax
  800677:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80067a:	8b 45 14             	mov    0x14(%ebp),%eax
  80067d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800680:	8b 45 18             	mov    0x18(%ebp),%eax
  800683:	ba 00 00 00 00       	mov    $0x0,%edx
  800688:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80068b:	77 55                	ja     8006e2 <printnum+0x75>
  80068d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800690:	72 05                	jb     800697 <printnum+0x2a>
  800692:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800695:	77 4b                	ja     8006e2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800697:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80069a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80069d:	8b 45 18             	mov    0x18(%ebp),%eax
  8006a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a5:	52                   	push   %edx
  8006a6:	50                   	push   %eax
  8006a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8006aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8006ad:	e8 aa 16 00 00       	call   801d5c <__udivdi3>
  8006b2:	83 c4 10             	add    $0x10,%esp
  8006b5:	83 ec 04             	sub    $0x4,%esp
  8006b8:	ff 75 20             	pushl  0x20(%ebp)
  8006bb:	53                   	push   %ebx
  8006bc:	ff 75 18             	pushl  0x18(%ebp)
  8006bf:	52                   	push   %edx
  8006c0:	50                   	push   %eax
  8006c1:	ff 75 0c             	pushl  0xc(%ebp)
  8006c4:	ff 75 08             	pushl  0x8(%ebp)
  8006c7:	e8 a1 ff ff ff       	call   80066d <printnum>
  8006cc:	83 c4 20             	add    $0x20,%esp
  8006cf:	eb 1a                	jmp    8006eb <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006d1:	83 ec 08             	sub    $0x8,%esp
  8006d4:	ff 75 0c             	pushl  0xc(%ebp)
  8006d7:	ff 75 20             	pushl  0x20(%ebp)
  8006da:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dd:	ff d0                	call   *%eax
  8006df:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006e2:	ff 4d 1c             	decl   0x1c(%ebp)
  8006e5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006e9:	7f e6                	jg     8006d1 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006eb:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006f9:	53                   	push   %ebx
  8006fa:	51                   	push   %ecx
  8006fb:	52                   	push   %edx
  8006fc:	50                   	push   %eax
  8006fd:	e8 6a 17 00 00       	call   801e6c <__umoddi3>
  800702:	83 c4 10             	add    $0x10,%esp
  800705:	05 34 26 80 00       	add    $0x802634,%eax
  80070a:	8a 00                	mov    (%eax),%al
  80070c:	0f be c0             	movsbl %al,%eax
  80070f:	83 ec 08             	sub    $0x8,%esp
  800712:	ff 75 0c             	pushl  0xc(%ebp)
  800715:	50                   	push   %eax
  800716:	8b 45 08             	mov    0x8(%ebp),%eax
  800719:	ff d0                	call   *%eax
  80071b:	83 c4 10             	add    $0x10,%esp
}
  80071e:	90                   	nop
  80071f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800722:	c9                   	leave  
  800723:	c3                   	ret    

00800724 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800724:	55                   	push   %ebp
  800725:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800727:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80072b:	7e 1c                	jle    800749 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80072d:	8b 45 08             	mov    0x8(%ebp),%eax
  800730:	8b 00                	mov    (%eax),%eax
  800732:	8d 50 08             	lea    0x8(%eax),%edx
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	89 10                	mov    %edx,(%eax)
  80073a:	8b 45 08             	mov    0x8(%ebp),%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	83 e8 08             	sub    $0x8,%eax
  800742:	8b 50 04             	mov    0x4(%eax),%edx
  800745:	8b 00                	mov    (%eax),%eax
  800747:	eb 40                	jmp    800789 <getuint+0x65>
	else if (lflag)
  800749:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80074d:	74 1e                	je     80076d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	8d 50 04             	lea    0x4(%eax),%edx
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	89 10                	mov    %edx,(%eax)
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	8b 00                	mov    (%eax),%eax
  800761:	83 e8 04             	sub    $0x4,%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	ba 00 00 00 00       	mov    $0x0,%edx
  80076b:	eb 1c                	jmp    800789 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	8d 50 04             	lea    0x4(%eax),%edx
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	89 10                	mov    %edx,(%eax)
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	83 e8 04             	sub    $0x4,%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800789:	5d                   	pop    %ebp
  80078a:	c3                   	ret    

0080078b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80078b:	55                   	push   %ebp
  80078c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80078e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800792:	7e 1c                	jle    8007b0 <getint+0x25>
		return va_arg(*ap, long long);
  800794:	8b 45 08             	mov    0x8(%ebp),%eax
  800797:	8b 00                	mov    (%eax),%eax
  800799:	8d 50 08             	lea    0x8(%eax),%edx
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	89 10                	mov    %edx,(%eax)
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	83 e8 08             	sub    $0x8,%eax
  8007a9:	8b 50 04             	mov    0x4(%eax),%edx
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	eb 38                	jmp    8007e8 <getint+0x5d>
	else if (lflag)
  8007b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007b4:	74 1a                	je     8007d0 <getint+0x45>
		return va_arg(*ap, long);
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	8d 50 04             	lea    0x4(%eax),%edx
  8007be:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c1:	89 10                	mov    %edx,(%eax)
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	83 e8 04             	sub    $0x4,%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	99                   	cltd   
  8007ce:	eb 18                	jmp    8007e8 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	8b 00                	mov    (%eax),%eax
  8007d5:	8d 50 04             	lea    0x4(%eax),%edx
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	89 10                	mov    %edx,(%eax)
  8007dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	83 e8 04             	sub    $0x4,%eax
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	99                   	cltd   
}
  8007e8:	5d                   	pop    %ebp
  8007e9:	c3                   	ret    

008007ea <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007ea:	55                   	push   %ebp
  8007eb:	89 e5                	mov    %esp,%ebp
  8007ed:	56                   	push   %esi
  8007ee:	53                   	push   %ebx
  8007ef:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007f2:	eb 17                	jmp    80080b <vprintfmt+0x21>
			if (ch == '\0')
  8007f4:	85 db                	test   %ebx,%ebx
  8007f6:	0f 84 c1 03 00 00    	je     800bbd <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007fc:	83 ec 08             	sub    $0x8,%esp
  8007ff:	ff 75 0c             	pushl  0xc(%ebp)
  800802:	53                   	push   %ebx
  800803:	8b 45 08             	mov    0x8(%ebp),%eax
  800806:	ff d0                	call   *%eax
  800808:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80080b:	8b 45 10             	mov    0x10(%ebp),%eax
  80080e:	8d 50 01             	lea    0x1(%eax),%edx
  800811:	89 55 10             	mov    %edx,0x10(%ebp)
  800814:	8a 00                	mov    (%eax),%al
  800816:	0f b6 d8             	movzbl %al,%ebx
  800819:	83 fb 25             	cmp    $0x25,%ebx
  80081c:	75 d6                	jne    8007f4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80081e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800822:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800829:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800830:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800837:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80083e:	8b 45 10             	mov    0x10(%ebp),%eax
  800841:	8d 50 01             	lea    0x1(%eax),%edx
  800844:	89 55 10             	mov    %edx,0x10(%ebp)
  800847:	8a 00                	mov    (%eax),%al
  800849:	0f b6 d8             	movzbl %al,%ebx
  80084c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80084f:	83 f8 5b             	cmp    $0x5b,%eax
  800852:	0f 87 3d 03 00 00    	ja     800b95 <vprintfmt+0x3ab>
  800858:	8b 04 85 58 26 80 00 	mov    0x802658(,%eax,4),%eax
  80085f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800861:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800865:	eb d7                	jmp    80083e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800867:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80086b:	eb d1                	jmp    80083e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80086d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800874:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800877:	89 d0                	mov    %edx,%eax
  800879:	c1 e0 02             	shl    $0x2,%eax
  80087c:	01 d0                	add    %edx,%eax
  80087e:	01 c0                	add    %eax,%eax
  800880:	01 d8                	add    %ebx,%eax
  800882:	83 e8 30             	sub    $0x30,%eax
  800885:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800888:	8b 45 10             	mov    0x10(%ebp),%eax
  80088b:	8a 00                	mov    (%eax),%al
  80088d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800890:	83 fb 2f             	cmp    $0x2f,%ebx
  800893:	7e 3e                	jle    8008d3 <vprintfmt+0xe9>
  800895:	83 fb 39             	cmp    $0x39,%ebx
  800898:	7f 39                	jg     8008d3 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80089a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80089d:	eb d5                	jmp    800874 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80089f:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a2:	83 c0 04             	add    $0x4,%eax
  8008a5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ab:	83 e8 04             	sub    $0x4,%eax
  8008ae:	8b 00                	mov    (%eax),%eax
  8008b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008b3:	eb 1f                	jmp    8008d4 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b9:	79 83                	jns    80083e <vprintfmt+0x54>
				width = 0;
  8008bb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008c2:	e9 77 ff ff ff       	jmp    80083e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008c7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008ce:	e9 6b ff ff ff       	jmp    80083e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008d3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008d8:	0f 89 60 ff ff ff    	jns    80083e <vprintfmt+0x54>
				width = precision, precision = -1;
  8008de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008e4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008eb:	e9 4e ff ff ff       	jmp    80083e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008f0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008f3:	e9 46 ff ff ff       	jmp    80083e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fb:	83 c0 04             	add    $0x4,%eax
  8008fe:	89 45 14             	mov    %eax,0x14(%ebp)
  800901:	8b 45 14             	mov    0x14(%ebp),%eax
  800904:	83 e8 04             	sub    $0x4,%eax
  800907:	8b 00                	mov    (%eax),%eax
  800909:	83 ec 08             	sub    $0x8,%esp
  80090c:	ff 75 0c             	pushl  0xc(%ebp)
  80090f:	50                   	push   %eax
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	ff d0                	call   *%eax
  800915:	83 c4 10             	add    $0x10,%esp
			break;
  800918:	e9 9b 02 00 00       	jmp    800bb8 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80091d:	8b 45 14             	mov    0x14(%ebp),%eax
  800920:	83 c0 04             	add    $0x4,%eax
  800923:	89 45 14             	mov    %eax,0x14(%ebp)
  800926:	8b 45 14             	mov    0x14(%ebp),%eax
  800929:	83 e8 04             	sub    $0x4,%eax
  80092c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80092e:	85 db                	test   %ebx,%ebx
  800930:	79 02                	jns    800934 <vprintfmt+0x14a>
				err = -err;
  800932:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800934:	83 fb 64             	cmp    $0x64,%ebx
  800937:	7f 0b                	jg     800944 <vprintfmt+0x15a>
  800939:	8b 34 9d a0 24 80 00 	mov    0x8024a0(,%ebx,4),%esi
  800940:	85 f6                	test   %esi,%esi
  800942:	75 19                	jne    80095d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800944:	53                   	push   %ebx
  800945:	68 45 26 80 00       	push   $0x802645
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	ff 75 08             	pushl  0x8(%ebp)
  800950:	e8 70 02 00 00       	call   800bc5 <printfmt>
  800955:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800958:	e9 5b 02 00 00       	jmp    800bb8 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80095d:	56                   	push   %esi
  80095e:	68 4e 26 80 00       	push   $0x80264e
  800963:	ff 75 0c             	pushl  0xc(%ebp)
  800966:	ff 75 08             	pushl  0x8(%ebp)
  800969:	e8 57 02 00 00       	call   800bc5 <printfmt>
  80096e:	83 c4 10             	add    $0x10,%esp
			break;
  800971:	e9 42 02 00 00       	jmp    800bb8 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800976:	8b 45 14             	mov    0x14(%ebp),%eax
  800979:	83 c0 04             	add    $0x4,%eax
  80097c:	89 45 14             	mov    %eax,0x14(%ebp)
  80097f:	8b 45 14             	mov    0x14(%ebp),%eax
  800982:	83 e8 04             	sub    $0x4,%eax
  800985:	8b 30                	mov    (%eax),%esi
  800987:	85 f6                	test   %esi,%esi
  800989:	75 05                	jne    800990 <vprintfmt+0x1a6>
				p = "(null)";
  80098b:	be 51 26 80 00       	mov    $0x802651,%esi
			if (width > 0 && padc != '-')
  800990:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800994:	7e 6d                	jle    800a03 <vprintfmt+0x219>
  800996:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80099a:	74 67                	je     800a03 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80099c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80099f:	83 ec 08             	sub    $0x8,%esp
  8009a2:	50                   	push   %eax
  8009a3:	56                   	push   %esi
  8009a4:	e8 1e 03 00 00       	call   800cc7 <strnlen>
  8009a9:	83 c4 10             	add    $0x10,%esp
  8009ac:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009af:	eb 16                	jmp    8009c7 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009b1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009b5:	83 ec 08             	sub    $0x8,%esp
  8009b8:	ff 75 0c             	pushl  0xc(%ebp)
  8009bb:	50                   	push   %eax
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	ff d0                	call   *%eax
  8009c1:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009c4:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009cb:	7f e4                	jg     8009b1 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009cd:	eb 34                	jmp    800a03 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009cf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009d3:	74 1c                	je     8009f1 <vprintfmt+0x207>
  8009d5:	83 fb 1f             	cmp    $0x1f,%ebx
  8009d8:	7e 05                	jle    8009df <vprintfmt+0x1f5>
  8009da:	83 fb 7e             	cmp    $0x7e,%ebx
  8009dd:	7e 12                	jle    8009f1 <vprintfmt+0x207>
					putch('?', putdat);
  8009df:	83 ec 08             	sub    $0x8,%esp
  8009e2:	ff 75 0c             	pushl  0xc(%ebp)
  8009e5:	6a 3f                	push   $0x3f
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	ff d0                	call   *%eax
  8009ec:	83 c4 10             	add    $0x10,%esp
  8009ef:	eb 0f                	jmp    800a00 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009f1:	83 ec 08             	sub    $0x8,%esp
  8009f4:	ff 75 0c             	pushl  0xc(%ebp)
  8009f7:	53                   	push   %ebx
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	ff d0                	call   *%eax
  8009fd:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a00:	ff 4d e4             	decl   -0x1c(%ebp)
  800a03:	89 f0                	mov    %esi,%eax
  800a05:	8d 70 01             	lea    0x1(%eax),%esi
  800a08:	8a 00                	mov    (%eax),%al
  800a0a:	0f be d8             	movsbl %al,%ebx
  800a0d:	85 db                	test   %ebx,%ebx
  800a0f:	74 24                	je     800a35 <vprintfmt+0x24b>
  800a11:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a15:	78 b8                	js     8009cf <vprintfmt+0x1e5>
  800a17:	ff 4d e0             	decl   -0x20(%ebp)
  800a1a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a1e:	79 af                	jns    8009cf <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a20:	eb 13                	jmp    800a35 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a22:	83 ec 08             	sub    $0x8,%esp
  800a25:	ff 75 0c             	pushl  0xc(%ebp)
  800a28:	6a 20                	push   $0x20
  800a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2d:	ff d0                	call   *%eax
  800a2f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a32:	ff 4d e4             	decl   -0x1c(%ebp)
  800a35:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a39:	7f e7                	jg     800a22 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a3b:	e9 78 01 00 00       	jmp    800bb8 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a40:	83 ec 08             	sub    $0x8,%esp
  800a43:	ff 75 e8             	pushl  -0x18(%ebp)
  800a46:	8d 45 14             	lea    0x14(%ebp),%eax
  800a49:	50                   	push   %eax
  800a4a:	e8 3c fd ff ff       	call   80078b <getint>
  800a4f:	83 c4 10             	add    $0x10,%esp
  800a52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a55:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a5e:	85 d2                	test   %edx,%edx
  800a60:	79 23                	jns    800a85 <vprintfmt+0x29b>
				putch('-', putdat);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 0c             	pushl  0xc(%ebp)
  800a68:	6a 2d                	push   $0x2d
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	ff d0                	call   *%eax
  800a6f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a78:	f7 d8                	neg    %eax
  800a7a:	83 d2 00             	adc    $0x0,%edx
  800a7d:	f7 da                	neg    %edx
  800a7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a82:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a85:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a8c:	e9 bc 00 00 00       	jmp    800b4d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a91:	83 ec 08             	sub    $0x8,%esp
  800a94:	ff 75 e8             	pushl  -0x18(%ebp)
  800a97:	8d 45 14             	lea    0x14(%ebp),%eax
  800a9a:	50                   	push   %eax
  800a9b:	e8 84 fc ff ff       	call   800724 <getuint>
  800aa0:	83 c4 10             	add    $0x10,%esp
  800aa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800aa9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ab0:	e9 98 00 00 00       	jmp    800b4d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ab5:	83 ec 08             	sub    $0x8,%esp
  800ab8:	ff 75 0c             	pushl  0xc(%ebp)
  800abb:	6a 58                	push   $0x58
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	ff d0                	call   *%eax
  800ac2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ac5:	83 ec 08             	sub    $0x8,%esp
  800ac8:	ff 75 0c             	pushl  0xc(%ebp)
  800acb:	6a 58                	push   $0x58
  800acd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad0:	ff d0                	call   *%eax
  800ad2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ad5:	83 ec 08             	sub    $0x8,%esp
  800ad8:	ff 75 0c             	pushl  0xc(%ebp)
  800adb:	6a 58                	push   $0x58
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	ff d0                	call   *%eax
  800ae2:	83 c4 10             	add    $0x10,%esp
			break;
  800ae5:	e9 ce 00 00 00       	jmp    800bb8 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800aea:	83 ec 08             	sub    $0x8,%esp
  800aed:	ff 75 0c             	pushl  0xc(%ebp)
  800af0:	6a 30                	push   $0x30
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	ff d0                	call   *%eax
  800af7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800afa:	83 ec 08             	sub    $0x8,%esp
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	6a 78                	push   $0x78
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	ff d0                	call   *%eax
  800b07:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0d:	83 c0 04             	add    $0x4,%eax
  800b10:	89 45 14             	mov    %eax,0x14(%ebp)
  800b13:	8b 45 14             	mov    0x14(%ebp),%eax
  800b16:	83 e8 04             	sub    $0x4,%eax
  800b19:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b25:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b2c:	eb 1f                	jmp    800b4d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 e8             	pushl  -0x18(%ebp)
  800b34:	8d 45 14             	lea    0x14(%ebp),%eax
  800b37:	50                   	push   %eax
  800b38:	e8 e7 fb ff ff       	call   800724 <getuint>
  800b3d:	83 c4 10             	add    $0x10,%esp
  800b40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b43:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b46:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b4d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b54:	83 ec 04             	sub    $0x4,%esp
  800b57:	52                   	push   %edx
  800b58:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b5b:	50                   	push   %eax
  800b5c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b5f:	ff 75 f0             	pushl  -0x10(%ebp)
  800b62:	ff 75 0c             	pushl  0xc(%ebp)
  800b65:	ff 75 08             	pushl  0x8(%ebp)
  800b68:	e8 00 fb ff ff       	call   80066d <printnum>
  800b6d:	83 c4 20             	add    $0x20,%esp
			break;
  800b70:	eb 46                	jmp    800bb8 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b72:	83 ec 08             	sub    $0x8,%esp
  800b75:	ff 75 0c             	pushl  0xc(%ebp)
  800b78:	53                   	push   %ebx
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	ff d0                	call   *%eax
  800b7e:	83 c4 10             	add    $0x10,%esp
			break;
  800b81:	eb 35                	jmp    800bb8 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b83:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b8a:	eb 2c                	jmp    800bb8 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b8c:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b93:	eb 23                	jmp    800bb8 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b95:	83 ec 08             	sub    $0x8,%esp
  800b98:	ff 75 0c             	pushl  0xc(%ebp)
  800b9b:	6a 25                	push   $0x25
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	ff d0                	call   *%eax
  800ba2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ba5:	ff 4d 10             	decl   0x10(%ebp)
  800ba8:	eb 03                	jmp    800bad <vprintfmt+0x3c3>
  800baa:	ff 4d 10             	decl   0x10(%ebp)
  800bad:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb0:	48                   	dec    %eax
  800bb1:	8a 00                	mov    (%eax),%al
  800bb3:	3c 25                	cmp    $0x25,%al
  800bb5:	75 f3                	jne    800baa <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800bb7:	90                   	nop
		}
	}
  800bb8:	e9 35 fc ff ff       	jmp    8007f2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bbd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    

00800bc5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bcb:	8d 45 10             	lea    0x10(%ebp),%eax
  800bce:	83 c0 04             	add    $0x4,%eax
  800bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bda:	50                   	push   %eax
  800bdb:	ff 75 0c             	pushl  0xc(%ebp)
  800bde:	ff 75 08             	pushl  0x8(%ebp)
  800be1:	e8 04 fc ff ff       	call   8007ea <vprintfmt>
  800be6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800be9:	90                   	nop
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf2:	8b 40 08             	mov    0x8(%eax),%eax
  800bf5:	8d 50 01             	lea    0x1(%eax),%edx
  800bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c01:	8b 10                	mov    (%eax),%edx
  800c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c06:	8b 40 04             	mov    0x4(%eax),%eax
  800c09:	39 c2                	cmp    %eax,%edx
  800c0b:	73 12                	jae    800c1f <sprintputch+0x33>
		*b->buf++ = ch;
  800c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c10:	8b 00                	mov    (%eax),%eax
  800c12:	8d 48 01             	lea    0x1(%eax),%ecx
  800c15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c18:	89 0a                	mov    %ecx,(%edx)
  800c1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1d:	88 10                	mov    %dl,(%eax)
}
  800c1f:	90                   	nop
  800c20:	5d                   	pop    %ebp
  800c21:	c3                   	ret    

00800c22 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	01 d0                	add    %edx,%eax
  800c39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c47:	74 06                	je     800c4f <vsnprintf+0x2d>
  800c49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4d:	7f 07                	jg     800c56 <vsnprintf+0x34>
		return -E_INVAL;
  800c4f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c54:	eb 20                	jmp    800c76 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c56:	ff 75 14             	pushl  0x14(%ebp)
  800c59:	ff 75 10             	pushl  0x10(%ebp)
  800c5c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c5f:	50                   	push   %eax
  800c60:	68 ec 0b 80 00       	push   $0x800bec
  800c65:	e8 80 fb ff ff       	call   8007ea <vprintfmt>
  800c6a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c70:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c76:	c9                   	leave  
  800c77:	c3                   	ret    

00800c78 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c7e:	8d 45 10             	lea    0x10(%ebp),%eax
  800c81:	83 c0 04             	add    $0x4,%eax
  800c84:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c87:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8d:	50                   	push   %eax
  800c8e:	ff 75 0c             	pushl  0xc(%ebp)
  800c91:	ff 75 08             	pushl  0x8(%ebp)
  800c94:	e8 89 ff ff ff       	call   800c22 <vsnprintf>
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    

00800ca4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800caa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cb1:	eb 06                	jmp    800cb9 <strlen+0x15>
		n++;
  800cb3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb6:	ff 45 08             	incl   0x8(%ebp)
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	84 c0                	test   %al,%al
  800cc0:	75 f1                	jne    800cb3 <strlen+0xf>
		n++;
	return n;
  800cc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc5:	c9                   	leave  
  800cc6:	c3                   	ret    

00800cc7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ccd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd4:	eb 09                	jmp    800cdf <strnlen+0x18>
		n++;
  800cd6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd9:	ff 45 08             	incl   0x8(%ebp)
  800cdc:	ff 4d 0c             	decl   0xc(%ebp)
  800cdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce3:	74 09                	je     800cee <strnlen+0x27>
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	8a 00                	mov    (%eax),%al
  800cea:	84 c0                	test   %al,%al
  800cec:	75 e8                	jne    800cd6 <strnlen+0xf>
		n++;
	return n;
  800cee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf1:	c9                   	leave  
  800cf2:	c3                   	ret    

00800cf3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cff:	90                   	nop
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	8d 50 01             	lea    0x1(%eax),%edx
  800d06:	89 55 08             	mov    %edx,0x8(%ebp)
  800d09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d0f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d12:	8a 12                	mov    (%edx),%dl
  800d14:	88 10                	mov    %dl,(%eax)
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	84 c0                	test   %al,%al
  800d1a:	75 e4                	jne    800d00 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d1f:	c9                   	leave  
  800d20:	c3                   	ret    

00800d21 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d21:	55                   	push   %ebp
  800d22:	89 e5                	mov    %esp,%ebp
  800d24:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d34:	eb 1f                	jmp    800d55 <strncpy+0x34>
		*dst++ = *src;
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8d 50 01             	lea    0x1(%eax),%edx
  800d3c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d42:	8a 12                	mov    (%edx),%dl
  800d44:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	84 c0                	test   %al,%al
  800d4d:	74 03                	je     800d52 <strncpy+0x31>
			src++;
  800d4f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d52:	ff 45 fc             	incl   -0x4(%ebp)
  800d55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d58:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d5b:	72 d9                	jb     800d36 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d60:	c9                   	leave  
  800d61:	c3                   	ret    

00800d62 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d72:	74 30                	je     800da4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d74:	eb 16                	jmp    800d8c <strlcpy+0x2a>
			*dst++ = *src++;
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8d 50 01             	lea    0x1(%eax),%edx
  800d7c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d82:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d85:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d88:	8a 12                	mov    (%edx),%dl
  800d8a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d8c:	ff 4d 10             	decl   0x10(%ebp)
  800d8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d93:	74 09                	je     800d9e <strlcpy+0x3c>
  800d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	84 c0                	test   %al,%al
  800d9c:	75 d8                	jne    800d76 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800da4:	8b 55 08             	mov    0x8(%ebp),%edx
  800da7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800daa:	29 c2                	sub    %eax,%edx
  800dac:	89 d0                	mov    %edx,%eax
}
  800dae:	c9                   	leave  
  800daf:	c3                   	ret    

00800db0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800db3:	eb 06                	jmp    800dbb <strcmp+0xb>
		p++, q++;
  800db5:	ff 45 08             	incl   0x8(%ebp)
  800db8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	8a 00                	mov    (%eax),%al
  800dc0:	84 c0                	test   %al,%al
  800dc2:	74 0e                	je     800dd2 <strcmp+0x22>
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8a 10                	mov    (%eax),%dl
  800dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	38 c2                	cmp    %al,%dl
  800dd0:	74 e3                	je     800db5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	0f b6 d0             	movzbl %al,%edx
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	0f b6 c0             	movzbl %al,%eax
  800de2:	29 c2                	sub    %eax,%edx
  800de4:	89 d0                	mov    %edx,%eax
}
  800de6:	5d                   	pop    %ebp
  800de7:	c3                   	ret    

00800de8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800deb:	eb 09                	jmp    800df6 <strncmp+0xe>
		n--, p++, q++;
  800ded:	ff 4d 10             	decl   0x10(%ebp)
  800df0:	ff 45 08             	incl   0x8(%ebp)
  800df3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800df6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dfa:	74 17                	je     800e13 <strncmp+0x2b>
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	84 c0                	test   %al,%al
  800e03:	74 0e                	je     800e13 <strncmp+0x2b>
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8a 10                	mov    (%eax),%dl
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	8a 00                	mov    (%eax),%al
  800e0f:	38 c2                	cmp    %al,%dl
  800e11:	74 da                	je     800ded <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e17:	75 07                	jne    800e20 <strncmp+0x38>
		return 0;
  800e19:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1e:	eb 14                	jmp    800e34 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	0f b6 d0             	movzbl %al,%edx
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	0f b6 c0             	movzbl %al,%eax
  800e30:	29 c2                	sub    %eax,%edx
  800e32:	89 d0                	mov    %edx,%eax
}
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	83 ec 04             	sub    $0x4,%esp
  800e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e42:	eb 12                	jmp    800e56 <strchr+0x20>
		if (*s == c)
  800e44:	8b 45 08             	mov    0x8(%ebp),%eax
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e4c:	75 05                	jne    800e53 <strchr+0x1d>
			return (char *) s;
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	eb 11                	jmp    800e64 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e53:	ff 45 08             	incl   0x8(%ebp)
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	8a 00                	mov    (%eax),%al
  800e5b:	84 c0                	test   %al,%al
  800e5d:	75 e5                	jne    800e44 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e64:	c9                   	leave  
  800e65:	c3                   	ret    

00800e66 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	83 ec 04             	sub    $0x4,%esp
  800e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e72:	eb 0d                	jmp    800e81 <strfind+0x1b>
		if (*s == c)
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	8a 00                	mov    (%eax),%al
  800e79:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e7c:	74 0e                	je     800e8c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	84 c0                	test   %al,%al
  800e88:	75 ea                	jne    800e74 <strfind+0xe>
  800e8a:	eb 01                	jmp    800e8d <strfind+0x27>
		if (*s == c)
			break;
  800e8c:	90                   	nop
	return (char *) s;
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e90:	c9                   	leave  
  800e91:	c3                   	ret    

00800e92 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e9e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ea2:	76 63                	jbe    800f07 <memset+0x75>
		uint64 data_block = c;
  800ea4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea7:	99                   	cltd   
  800ea8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eab:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800eae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb4:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800eb8:	c1 e0 08             	shl    $0x8,%eax
  800ebb:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ebe:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ec1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ec4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec7:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ecb:	c1 e0 10             	shl    $0x10,%eax
  800ece:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ed1:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ed4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eda:	89 c2                	mov    %eax,%edx
  800edc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee1:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ee4:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ee7:	eb 18                	jmp    800f01 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ee9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800eec:	8d 41 08             	lea    0x8(%ecx),%eax
  800eef:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ef5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ef8:	89 01                	mov    %eax,(%ecx)
  800efa:	89 51 04             	mov    %edx,0x4(%ecx)
  800efd:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f01:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f05:	77 e2                	ja     800ee9 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f0b:	74 23                	je     800f30 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f10:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f13:	eb 0e                	jmp    800f23 <memset+0x91>
			*p8++ = (uint8)c;
  800f15:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f18:	8d 50 01             	lea    0x1(%eax),%edx
  800f1b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f21:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f23:	8b 45 10             	mov    0x10(%ebp),%eax
  800f26:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f29:	89 55 10             	mov    %edx,0x10(%ebp)
  800f2c:	85 c0                	test   %eax,%eax
  800f2e:	75 e5                	jne    800f15 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f33:	c9                   	leave  
  800f34:	c3                   	ret    

00800f35 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
  800f38:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f47:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f4b:	76 24                	jbe    800f71 <memcpy+0x3c>
		while(n >= 8){
  800f4d:	eb 1c                	jmp    800f6b <memcpy+0x36>
			*d64 = *s64;
  800f4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f52:	8b 50 04             	mov    0x4(%eax),%edx
  800f55:	8b 00                	mov    (%eax),%eax
  800f57:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f5a:	89 01                	mov    %eax,(%ecx)
  800f5c:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f5f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f63:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f67:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f6b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f6f:	77 de                	ja     800f4f <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f75:	74 31                	je     800fa8 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f80:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f83:	eb 16                	jmp    800f9b <memcpy+0x66>
			*d8++ = *s8++;
  800f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f88:	8d 50 01             	lea    0x1(%eax),%edx
  800f8b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f91:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f94:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f97:	8a 12                	mov    (%edx),%dl
  800f99:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa1:	89 55 10             	mov    %edx,0x10(%ebp)
  800fa4:	85 c0                	test   %eax,%eax
  800fa6:	75 dd                	jne    800f85 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fab:	c9                   	leave  
  800fac:	c3                   	ret    

00800fad <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fc5:	73 50                	jae    801017 <memmove+0x6a>
  800fc7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fca:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcd:	01 d0                	add    %edx,%eax
  800fcf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fd2:	76 43                	jbe    801017 <memmove+0x6a>
		s += n;
  800fd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd7:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fda:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdd:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fe0:	eb 10                	jmp    800ff2 <memmove+0x45>
			*--d = *--s;
  800fe2:	ff 4d f8             	decl   -0x8(%ebp)
  800fe5:	ff 4d fc             	decl   -0x4(%ebp)
  800fe8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800feb:	8a 10                	mov    (%eax),%dl
  800fed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff0:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ff2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff8:	89 55 10             	mov    %edx,0x10(%ebp)
  800ffb:	85 c0                	test   %eax,%eax
  800ffd:	75 e3                	jne    800fe2 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fff:	eb 23                	jmp    801024 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801001:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801004:	8d 50 01             	lea    0x1(%eax),%edx
  801007:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80100a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80100d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801010:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801013:	8a 12                	mov    (%edx),%dl
  801015:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801017:	8b 45 10             	mov    0x10(%ebp),%eax
  80101a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101d:	89 55 10             	mov    %edx,0x10(%ebp)
  801020:	85 c0                	test   %eax,%eax
  801022:	75 dd                	jne    801001 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801027:	c9                   	leave  
  801028:	c3                   	ret    

00801029 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801035:	8b 45 0c             	mov    0xc(%ebp),%eax
  801038:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80103b:	eb 2a                	jmp    801067 <memcmp+0x3e>
		if (*s1 != *s2)
  80103d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801040:	8a 10                	mov    (%eax),%dl
  801042:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	38 c2                	cmp    %al,%dl
  801049:	74 16                	je     801061 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80104b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	0f b6 d0             	movzbl %al,%edx
  801053:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	0f b6 c0             	movzbl %al,%eax
  80105b:	29 c2                	sub    %eax,%edx
  80105d:	89 d0                	mov    %edx,%eax
  80105f:	eb 18                	jmp    801079 <memcmp+0x50>
		s1++, s2++;
  801061:	ff 45 fc             	incl   -0x4(%ebp)
  801064:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801067:	8b 45 10             	mov    0x10(%ebp),%eax
  80106a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80106d:	89 55 10             	mov    %edx,0x10(%ebp)
  801070:	85 c0                	test   %eax,%eax
  801072:	75 c9                	jne    80103d <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801074:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801079:	c9                   	leave  
  80107a:	c3                   	ret    

0080107b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80107b:	55                   	push   %ebp
  80107c:	89 e5                	mov    %esp,%ebp
  80107e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801081:	8b 55 08             	mov    0x8(%ebp),%edx
  801084:	8b 45 10             	mov    0x10(%ebp),%eax
  801087:	01 d0                	add    %edx,%eax
  801089:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80108c:	eb 15                	jmp    8010a3 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	8a 00                	mov    (%eax),%al
  801093:	0f b6 d0             	movzbl %al,%edx
  801096:	8b 45 0c             	mov    0xc(%ebp),%eax
  801099:	0f b6 c0             	movzbl %al,%eax
  80109c:	39 c2                	cmp    %eax,%edx
  80109e:	74 0d                	je     8010ad <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010a0:	ff 45 08             	incl   0x8(%ebp)
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010a9:	72 e3                	jb     80108e <memfind+0x13>
  8010ab:	eb 01                	jmp    8010ae <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010ad:	90                   	nop
	return (void *) s;
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b1:	c9                   	leave  
  8010b2:	c3                   	ret    

008010b3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010c7:	eb 03                	jmp    8010cc <strtol+0x19>
		s++;
  8010c9:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	3c 20                	cmp    $0x20,%al
  8010d3:	74 f4                	je     8010c9 <strtol+0x16>
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	3c 09                	cmp    $0x9,%al
  8010dc:	74 eb                	je     8010c9 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	8a 00                	mov    (%eax),%al
  8010e3:	3c 2b                	cmp    $0x2b,%al
  8010e5:	75 05                	jne    8010ec <strtol+0x39>
		s++;
  8010e7:	ff 45 08             	incl   0x8(%ebp)
  8010ea:	eb 13                	jmp    8010ff <strtol+0x4c>
	else if (*s == '-')
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	3c 2d                	cmp    $0x2d,%al
  8010f3:	75 0a                	jne    8010ff <strtol+0x4c>
		s++, neg = 1;
  8010f5:	ff 45 08             	incl   0x8(%ebp)
  8010f8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801103:	74 06                	je     80110b <strtol+0x58>
  801105:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801109:	75 20                	jne    80112b <strtol+0x78>
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	8a 00                	mov    (%eax),%al
  801110:	3c 30                	cmp    $0x30,%al
  801112:	75 17                	jne    80112b <strtol+0x78>
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	40                   	inc    %eax
  801118:	8a 00                	mov    (%eax),%al
  80111a:	3c 78                	cmp    $0x78,%al
  80111c:	75 0d                	jne    80112b <strtol+0x78>
		s += 2, base = 16;
  80111e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801122:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801129:	eb 28                	jmp    801153 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80112b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80112f:	75 15                	jne    801146 <strtol+0x93>
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	8a 00                	mov    (%eax),%al
  801136:	3c 30                	cmp    $0x30,%al
  801138:	75 0c                	jne    801146 <strtol+0x93>
		s++, base = 8;
  80113a:	ff 45 08             	incl   0x8(%ebp)
  80113d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801144:	eb 0d                	jmp    801153 <strtol+0xa0>
	else if (base == 0)
  801146:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80114a:	75 07                	jne    801153 <strtol+0xa0>
		base = 10;
  80114c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	8a 00                	mov    (%eax),%al
  801158:	3c 2f                	cmp    $0x2f,%al
  80115a:	7e 19                	jle    801175 <strtol+0xc2>
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	8a 00                	mov    (%eax),%al
  801161:	3c 39                	cmp    $0x39,%al
  801163:	7f 10                	jg     801175 <strtol+0xc2>
			dig = *s - '0';
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	8a 00                	mov    (%eax),%al
  80116a:	0f be c0             	movsbl %al,%eax
  80116d:	83 e8 30             	sub    $0x30,%eax
  801170:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801173:	eb 42                	jmp    8011b7 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	3c 60                	cmp    $0x60,%al
  80117c:	7e 19                	jle    801197 <strtol+0xe4>
  80117e:	8b 45 08             	mov    0x8(%ebp),%eax
  801181:	8a 00                	mov    (%eax),%al
  801183:	3c 7a                	cmp    $0x7a,%al
  801185:	7f 10                	jg     801197 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	8a 00                	mov    (%eax),%al
  80118c:	0f be c0             	movsbl %al,%eax
  80118f:	83 e8 57             	sub    $0x57,%eax
  801192:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801195:	eb 20                	jmp    8011b7 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	3c 40                	cmp    $0x40,%al
  80119e:	7e 39                	jle    8011d9 <strtol+0x126>
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	3c 5a                	cmp    $0x5a,%al
  8011a7:	7f 30                	jg     8011d9 <strtol+0x126>
			dig = *s - 'A' + 10;
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	0f be c0             	movsbl %al,%eax
  8011b1:	83 e8 37             	sub    $0x37,%eax
  8011b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ba:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011bd:	7d 19                	jge    8011d8 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011bf:	ff 45 08             	incl   0x8(%ebp)
  8011c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c5:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011c9:	89 c2                	mov    %eax,%edx
  8011cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ce:	01 d0                	add    %edx,%eax
  8011d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011d3:	e9 7b ff ff ff       	jmp    801153 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011d8:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011dd:	74 08                	je     8011e7 <strtol+0x134>
		*endptr = (char *) s;
  8011df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011eb:	74 07                	je     8011f4 <strtol+0x141>
  8011ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f0:	f7 d8                	neg    %eax
  8011f2:	eb 03                	jmp    8011f7 <strtol+0x144>
  8011f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011f7:	c9                   	leave  
  8011f8:	c3                   	ret    

008011f9 <ltostr>:

void
ltostr(long value, char *str)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801206:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80120d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801211:	79 13                	jns    801226 <ltostr+0x2d>
	{
		neg = 1;
  801213:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80121a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801220:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801223:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80122e:	99                   	cltd   
  80122f:	f7 f9                	idiv   %ecx
  801231:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801234:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801237:	8d 50 01             	lea    0x1(%eax),%edx
  80123a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80123d:	89 c2                	mov    %eax,%edx
  80123f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801242:	01 d0                	add    %edx,%eax
  801244:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801247:	83 c2 30             	add    $0x30,%edx
  80124a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80124c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80124f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801254:	f7 e9                	imul   %ecx
  801256:	c1 fa 02             	sar    $0x2,%edx
  801259:	89 c8                	mov    %ecx,%eax
  80125b:	c1 f8 1f             	sar    $0x1f,%eax
  80125e:	29 c2                	sub    %eax,%edx
  801260:	89 d0                	mov    %edx,%eax
  801262:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801265:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801269:	75 bb                	jne    801226 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80126b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801272:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801275:	48                   	dec    %eax
  801276:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801279:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80127d:	74 3d                	je     8012bc <ltostr+0xc3>
		start = 1 ;
  80127f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801286:	eb 34                	jmp    8012bc <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801288:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128e:	01 d0                	add    %edx,%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801295:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	01 c2                	add    %eax,%edx
  80129d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a3:	01 c8                	add    %ecx,%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012af:	01 c2                	add    %eax,%edx
  8012b1:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012b4:	88 02                	mov    %al,(%edx)
		start++ ;
  8012b6:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012b9:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012bf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c2:	7c c4                	jl     801288 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012c4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ca:	01 d0                	add    %edx,%eax
  8012cc:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012cf:	90                   	nop
  8012d0:	c9                   	leave  
  8012d1:	c3                   	ret    

008012d2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012d2:	55                   	push   %ebp
  8012d3:	89 e5                	mov    %esp,%ebp
  8012d5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012d8:	ff 75 08             	pushl  0x8(%ebp)
  8012db:	e8 c4 f9 ff ff       	call   800ca4 <strlen>
  8012e0:	83 c4 04             	add    $0x4,%esp
  8012e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012e6:	ff 75 0c             	pushl  0xc(%ebp)
  8012e9:	e8 b6 f9 ff ff       	call   800ca4 <strlen>
  8012ee:	83 c4 04             	add    $0x4,%esp
  8012f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801302:	eb 17                	jmp    80131b <strcconcat+0x49>
		final[s] = str1[s] ;
  801304:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801307:	8b 45 10             	mov    0x10(%ebp),%eax
  80130a:	01 c2                	add    %eax,%edx
  80130c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80130f:	8b 45 08             	mov    0x8(%ebp),%eax
  801312:	01 c8                	add    %ecx,%eax
  801314:	8a 00                	mov    (%eax),%al
  801316:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801318:	ff 45 fc             	incl   -0x4(%ebp)
  80131b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80131e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801321:	7c e1                	jl     801304 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801323:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80132a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801331:	eb 1f                	jmp    801352 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801333:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801336:	8d 50 01             	lea    0x1(%eax),%edx
  801339:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80133c:	89 c2                	mov    %eax,%edx
  80133e:	8b 45 10             	mov    0x10(%ebp),%eax
  801341:	01 c2                	add    %eax,%edx
  801343:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801346:	8b 45 0c             	mov    0xc(%ebp),%eax
  801349:	01 c8                	add    %ecx,%eax
  80134b:	8a 00                	mov    (%eax),%al
  80134d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80134f:	ff 45 f8             	incl   -0x8(%ebp)
  801352:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801355:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801358:	7c d9                	jl     801333 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80135a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80135d:	8b 45 10             	mov    0x10(%ebp),%eax
  801360:	01 d0                	add    %edx,%eax
  801362:	c6 00 00             	movb   $0x0,(%eax)
}
  801365:	90                   	nop
  801366:	c9                   	leave  
  801367:	c3                   	ret    

00801368 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801368:	55                   	push   %ebp
  801369:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80136b:	8b 45 14             	mov    0x14(%ebp),%eax
  80136e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801374:	8b 45 14             	mov    0x14(%ebp),%eax
  801377:	8b 00                	mov    (%eax),%eax
  801379:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801380:	8b 45 10             	mov    0x10(%ebp),%eax
  801383:	01 d0                	add    %edx,%eax
  801385:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80138b:	eb 0c                	jmp    801399 <strsplit+0x31>
			*string++ = 0;
  80138d:	8b 45 08             	mov    0x8(%ebp),%eax
  801390:	8d 50 01             	lea    0x1(%eax),%edx
  801393:	89 55 08             	mov    %edx,0x8(%ebp)
  801396:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	8a 00                	mov    (%eax),%al
  80139e:	84 c0                	test   %al,%al
  8013a0:	74 18                	je     8013ba <strsplit+0x52>
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	8a 00                	mov    (%eax),%al
  8013a7:	0f be c0             	movsbl %al,%eax
  8013aa:	50                   	push   %eax
  8013ab:	ff 75 0c             	pushl  0xc(%ebp)
  8013ae:	e8 83 fa ff ff       	call   800e36 <strchr>
  8013b3:	83 c4 08             	add    $0x8,%esp
  8013b6:	85 c0                	test   %eax,%eax
  8013b8:	75 d3                	jne    80138d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	84 c0                	test   %al,%al
  8013c1:	74 5a                	je     80141d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c6:	8b 00                	mov    (%eax),%eax
  8013c8:	83 f8 0f             	cmp    $0xf,%eax
  8013cb:	75 07                	jne    8013d4 <strsplit+0x6c>
		{
			return 0;
  8013cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d2:	eb 66                	jmp    80143a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d7:	8b 00                	mov    (%eax),%eax
  8013d9:	8d 48 01             	lea    0x1(%eax),%ecx
  8013dc:	8b 55 14             	mov    0x14(%ebp),%edx
  8013df:	89 0a                	mov    %ecx,(%edx)
  8013e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013eb:	01 c2                	add    %eax,%edx
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013f2:	eb 03                	jmp    8013f7 <strsplit+0x8f>
			string++;
  8013f4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fa:	8a 00                	mov    (%eax),%al
  8013fc:	84 c0                	test   %al,%al
  8013fe:	74 8b                	je     80138b <strsplit+0x23>
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	8a 00                	mov    (%eax),%al
  801405:	0f be c0             	movsbl %al,%eax
  801408:	50                   	push   %eax
  801409:	ff 75 0c             	pushl  0xc(%ebp)
  80140c:	e8 25 fa ff ff       	call   800e36 <strchr>
  801411:	83 c4 08             	add    $0x8,%esp
  801414:	85 c0                	test   %eax,%eax
  801416:	74 dc                	je     8013f4 <strsplit+0x8c>
			string++;
	}
  801418:	e9 6e ff ff ff       	jmp    80138b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80141d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80141e:	8b 45 14             	mov    0x14(%ebp),%eax
  801421:	8b 00                	mov    (%eax),%eax
  801423:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80142a:	8b 45 10             	mov    0x10(%ebp),%eax
  80142d:	01 d0                	add    %edx,%eax
  80142f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801435:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80143a:	c9                   	leave  
  80143b:	c3                   	ret    

0080143c <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
  80143f:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801448:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80144f:	eb 4a                	jmp    80149b <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801451:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	01 c2                	add    %eax,%edx
  801459:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80145c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145f:	01 c8                	add    %ecx,%eax
  801461:	8a 00                	mov    (%eax),%al
  801463:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801465:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146b:	01 d0                	add    %edx,%eax
  80146d:	8a 00                	mov    (%eax),%al
  80146f:	3c 40                	cmp    $0x40,%al
  801471:	7e 25                	jle    801498 <str2lower+0x5c>
  801473:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801476:	8b 45 0c             	mov    0xc(%ebp),%eax
  801479:	01 d0                	add    %edx,%eax
  80147b:	8a 00                	mov    (%eax),%al
  80147d:	3c 5a                	cmp    $0x5a,%al
  80147f:	7f 17                	jg     801498 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801481:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801484:	8b 45 08             	mov    0x8(%ebp),%eax
  801487:	01 d0                	add    %edx,%eax
  801489:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80148c:	8b 55 08             	mov    0x8(%ebp),%edx
  80148f:	01 ca                	add    %ecx,%edx
  801491:	8a 12                	mov    (%edx),%dl
  801493:	83 c2 20             	add    $0x20,%edx
  801496:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801498:	ff 45 fc             	incl   -0x4(%ebp)
  80149b:	ff 75 0c             	pushl  0xc(%ebp)
  80149e:	e8 01 f8 ff ff       	call   800ca4 <strlen>
  8014a3:	83 c4 04             	add    $0x4,%esp
  8014a6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014a9:	7f a6                	jg     801451 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014ae:	c9                   	leave  
  8014af:	c3                   	ret    

008014b0 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
  8014b3:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8014b6:	a1 08 30 80 00       	mov    0x803008,%eax
  8014bb:	85 c0                	test   %eax,%eax
  8014bd:	74 42                	je     801501 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8014bf:	83 ec 08             	sub    $0x8,%esp
  8014c2:	68 00 00 00 82       	push   $0x82000000
  8014c7:	68 00 00 00 80       	push   $0x80000000
  8014cc:	e8 8c 07 00 00       	call   801c5d <initialize_dynamic_allocator>
  8014d1:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8014d4:	e8 e7 05 00 00       	call   801ac0 <sys_get_uheap_strategy>
  8014d9:	a3 60 b0 81 00       	mov    %eax,0x81b060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8014de:	a1 40 30 80 00       	mov    0x803040,%eax
  8014e3:	05 00 10 00 00       	add    $0x1000,%eax
  8014e8:	a3 10 b1 81 00       	mov    %eax,0x81b110
		uheapPageAllocBreak = uheapPageAllocStart;
  8014ed:	a1 10 b1 81 00       	mov    0x81b110,%eax
  8014f2:	a3 68 b0 81 00       	mov    %eax,0x81b068

		__firstTimeFlag = 0;
  8014f7:	c7 05 08 30 80 00 00 	movl   $0x0,0x803008
  8014fe:	00 00 00 
	}
}
  801501:	90                   	nop
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801513:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801518:	83 ec 08             	sub    $0x8,%esp
  80151b:	68 06 04 00 00       	push   $0x406
  801520:	50                   	push   %eax
  801521:	e8 e4 01 00 00       	call   80170a <__sys_allocate_page>
  801526:	83 c4 10             	add    $0x10,%esp
  801529:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80152c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801530:	79 14                	jns    801546 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801532:	83 ec 04             	sub    $0x4,%esp
  801535:	68 c8 27 80 00       	push   $0x8027c8
  80153a:	6a 1f                	push   $0x1f
  80153c:	68 04 28 80 00       	push   $0x802804
  801541:	e8 b7 ed ff ff       	call   8002fd <_panic>
	return 0;
  801546:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80154b:	c9                   	leave  
  80154c:	c3                   	ret    

0080154d <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
  801550:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801553:	8b 45 08             	mov    0x8(%ebp),%eax
  801556:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801561:	83 ec 0c             	sub    $0xc,%esp
  801564:	50                   	push   %eax
  801565:	e8 e7 01 00 00       	call   801751 <__sys_unmap_frame>
  80156a:	83 c4 10             	add    $0x10,%esp
  80156d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801570:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801574:	79 14                	jns    80158a <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801576:	83 ec 04             	sub    $0x4,%esp
  801579:	68 10 28 80 00       	push   $0x802810
  80157e:	6a 2a                	push   $0x2a
  801580:	68 04 28 80 00       	push   $0x802804
  801585:	e8 73 ed ff ff       	call   8002fd <_panic>
}
  80158a:	90                   	nop
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
  801590:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801593:	e8 18 ff ff ff       	call   8014b0 <uheap_init>
	if (size == 0) return NULL ;
  801598:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80159c:	75 07                	jne    8015a5 <malloc+0x18>
  80159e:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a3:	eb 14                	jmp    8015b9 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  8015a5:	83 ec 04             	sub    $0x4,%esp
  8015a8:	68 50 28 80 00       	push   $0x802850
  8015ad:	6a 3e                	push   $0x3e
  8015af:	68 04 28 80 00       	push   $0x802804
  8015b4:	e8 44 ed ff ff       	call   8002fd <_panic>
}
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    

008015bb <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
  8015be:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  8015c1:	83 ec 04             	sub    $0x4,%esp
  8015c4:	68 78 28 80 00       	push   $0x802878
  8015c9:	6a 49                	push   $0x49
  8015cb:	68 04 28 80 00       	push   $0x802804
  8015d0:	e8 28 ed ff ff       	call   8002fd <_panic>

008015d5 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	83 ec 18             	sub    $0x18,%esp
  8015db:	8b 45 10             	mov    0x10(%ebp),%eax
  8015de:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8015e1:	e8 ca fe ff ff       	call   8014b0 <uheap_init>
	if (size == 0) return NULL ;
  8015e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015ea:	75 07                	jne    8015f3 <smalloc+0x1e>
  8015ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f1:	eb 14                	jmp    801607 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  8015f3:	83 ec 04             	sub    $0x4,%esp
  8015f6:	68 9c 28 80 00       	push   $0x80289c
  8015fb:	6a 5a                	push   $0x5a
  8015fd:	68 04 28 80 00       	push   $0x802804
  801602:	e8 f6 ec ff ff       	call   8002fd <_panic>
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80160f:	e8 9c fe ff ff       	call   8014b0 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801614:	83 ec 04             	sub    $0x4,%esp
  801617:	68 c4 28 80 00       	push   $0x8028c4
  80161c:	6a 6a                	push   $0x6a
  80161e:	68 04 28 80 00       	push   $0x802804
  801623:	e8 d5 ec ff ff       	call   8002fd <_panic>

00801628 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
  80162b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80162e:	e8 7d fe ff ff       	call   8014b0 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801633:	83 ec 04             	sub    $0x4,%esp
  801636:	68 e8 28 80 00       	push   $0x8028e8
  80163b:	68 88 00 00 00       	push   $0x88
  801640:	68 04 28 80 00       	push   $0x802804
  801645:	e8 b3 ec ff ff       	call   8002fd <_panic>

0080164a <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
  80164d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801650:	83 ec 04             	sub    $0x4,%esp
  801653:	68 10 29 80 00       	push   $0x802910
  801658:	68 9b 00 00 00       	push   $0x9b
  80165d:	68 04 28 80 00       	push   $0x802804
  801662:	e8 96 ec ff ff       	call   8002fd <_panic>

00801667 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
  80166a:	57                   	push   %edi
  80166b:	56                   	push   %esi
  80166c:	53                   	push   %ebx
  80166d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	8b 55 0c             	mov    0xc(%ebp),%edx
  801676:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801679:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80167c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80167f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801682:	cd 30                	int    $0x30
  801684:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801687:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80168a:	83 c4 10             	add    $0x10,%esp
  80168d:	5b                   	pop    %ebx
  80168e:	5e                   	pop    %esi
  80168f:	5f                   	pop    %edi
  801690:	5d                   	pop    %ebp
  801691:	c3                   	ret    

00801692 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
  801695:	83 ec 04             	sub    $0x4,%esp
  801698:	8b 45 10             	mov    0x10(%ebp),%eax
  80169b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80169e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016a1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	6a 00                	push   $0x0
  8016aa:	51                   	push   %ecx
  8016ab:	52                   	push   %edx
  8016ac:	ff 75 0c             	pushl  0xc(%ebp)
  8016af:	50                   	push   %eax
  8016b0:	6a 00                	push   $0x0
  8016b2:	e8 b0 ff ff ff       	call   801667 <syscall>
  8016b7:	83 c4 18             	add    $0x18,%esp
}
  8016ba:	90                   	nop
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <sys_cgetc>:

int
sys_cgetc(void)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 02                	push   $0x2
  8016cc:	e8 96 ff ff ff       	call   801667 <syscall>
  8016d1:	83 c4 18             	add    $0x18,%esp
}
  8016d4:	c9                   	leave  
  8016d5:	c3                   	ret    

008016d6 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 03                	push   $0x3
  8016e5:	e8 7d ff ff ff       	call   801667 <syscall>
  8016ea:	83 c4 18             	add    $0x18,%esp
}
  8016ed:	90                   	nop
  8016ee:	c9                   	leave  
  8016ef:	c3                   	ret    

008016f0 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 04                	push   $0x4
  8016ff:	e8 63 ff ff ff       	call   801667 <syscall>
  801704:	83 c4 18             	add    $0x18,%esp
}
  801707:	90                   	nop
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80170d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801710:	8b 45 08             	mov    0x8(%ebp),%eax
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	52                   	push   %edx
  80171a:	50                   	push   %eax
  80171b:	6a 08                	push   $0x8
  80171d:	e8 45 ff ff ff       	call   801667 <syscall>
  801722:	83 c4 18             	add    $0x18,%esp
}
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
  80172a:	56                   	push   %esi
  80172b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80172c:	8b 75 18             	mov    0x18(%ebp),%esi
  80172f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801732:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801735:	8b 55 0c             	mov    0xc(%ebp),%edx
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	56                   	push   %esi
  80173c:	53                   	push   %ebx
  80173d:	51                   	push   %ecx
  80173e:	52                   	push   %edx
  80173f:	50                   	push   %eax
  801740:	6a 09                	push   $0x9
  801742:	e8 20 ff ff ff       	call   801667 <syscall>
  801747:	83 c4 18             	add    $0x18,%esp
}
  80174a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80174d:	5b                   	pop    %ebx
  80174e:	5e                   	pop    %esi
  80174f:	5d                   	pop    %ebp
  801750:	c3                   	ret    

00801751 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	ff 75 08             	pushl  0x8(%ebp)
  80175f:	6a 0a                	push   $0xa
  801761:	e8 01 ff ff ff       	call   801667 <syscall>
  801766:	83 c4 18             	add    $0x18,%esp
}
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	ff 75 0c             	pushl  0xc(%ebp)
  801777:	ff 75 08             	pushl  0x8(%ebp)
  80177a:	6a 0b                	push   $0xb
  80177c:	e8 e6 fe ff ff       	call   801667 <syscall>
  801781:	83 c4 18             	add    $0x18,%esp
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 0c                	push   $0xc
  801795:	e8 cd fe ff ff       	call   801667 <syscall>
  80179a:	83 c4 18             	add    $0x18,%esp
}
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    

0080179f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 0d                	push   $0xd
  8017ae:	e8 b4 fe ff ff       	call   801667 <syscall>
  8017b3:	83 c4 18             	add    $0x18,%esp
}
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 0e                	push   $0xe
  8017c7:	e8 9b fe ff ff       	call   801667 <syscall>
  8017cc:	83 c4 18             	add    $0x18,%esp
}
  8017cf:	c9                   	leave  
  8017d0:	c3                   	ret    

008017d1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 0f                	push   $0xf
  8017e0:	e8 82 fe ff ff       	call   801667 <syscall>
  8017e5:	83 c4 18             	add    $0x18,%esp
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	ff 75 08             	pushl  0x8(%ebp)
  8017f8:	6a 10                	push   $0x10
  8017fa:	e8 68 fe ff ff       	call   801667 <syscall>
  8017ff:	83 c4 18             	add    $0x18,%esp
}
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 11                	push   $0x11
  801813:	e8 4f fe ff ff       	call   801667 <syscall>
  801818:	83 c4 18             	add    $0x18,%esp
}
  80181b:	90                   	nop
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <sys_cputc>:

void
sys_cputc(const char c)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	83 ec 04             	sub    $0x4,%esp
  801824:	8b 45 08             	mov    0x8(%ebp),%eax
  801827:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80182a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	50                   	push   %eax
  801837:	6a 01                	push   $0x1
  801839:	e8 29 fe ff ff       	call   801667 <syscall>
  80183e:	83 c4 18             	add    $0x18,%esp
}
  801841:	90                   	nop
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 14                	push   $0x14
  801853:	e8 0f fe ff ff       	call   801667 <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
}
  80185b:	90                   	nop
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	83 ec 04             	sub    $0x4,%esp
  801864:	8b 45 10             	mov    0x10(%ebp),%eax
  801867:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80186a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80186d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	6a 00                	push   $0x0
  801876:	51                   	push   %ecx
  801877:	52                   	push   %edx
  801878:	ff 75 0c             	pushl  0xc(%ebp)
  80187b:	50                   	push   %eax
  80187c:	6a 15                	push   $0x15
  80187e:	e8 e4 fd ff ff       	call   801667 <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
}
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80188b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	52                   	push   %edx
  801898:	50                   	push   %eax
  801899:	6a 16                	push   $0x16
  80189b:	e8 c7 fd ff ff       	call   801667 <syscall>
  8018a0:	83 c4 18             	add    $0x18,%esp
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	51                   	push   %ecx
  8018b6:	52                   	push   %edx
  8018b7:	50                   	push   %eax
  8018b8:	6a 17                	push   $0x17
  8018ba:	e8 a8 fd ff ff       	call   801667 <syscall>
  8018bf:	83 c4 18             	add    $0x18,%esp
}
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	52                   	push   %edx
  8018d4:	50                   	push   %eax
  8018d5:	6a 18                	push   $0x18
  8018d7:	e8 8b fd ff ff       	call   801667 <syscall>
  8018dc:	83 c4 18             	add    $0x18,%esp
}
  8018df:	c9                   	leave  
  8018e0:	c3                   	ret    

008018e1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e7:	6a 00                	push   $0x0
  8018e9:	ff 75 14             	pushl  0x14(%ebp)
  8018ec:	ff 75 10             	pushl  0x10(%ebp)
  8018ef:	ff 75 0c             	pushl  0xc(%ebp)
  8018f2:	50                   	push   %eax
  8018f3:	6a 19                	push   $0x19
  8018f5:	e8 6d fd ff ff       	call   801667 <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <sys_run_env>:

void sys_run_env(int32 envId)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801902:	8b 45 08             	mov    0x8(%ebp),%eax
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	50                   	push   %eax
  80190e:	6a 1a                	push   $0x1a
  801910:	e8 52 fd ff ff       	call   801667 <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
}
  801918:	90                   	nop
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80191e:	8b 45 08             	mov    0x8(%ebp),%eax
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	50                   	push   %eax
  80192a:	6a 1b                	push   $0x1b
  80192c:	e8 36 fd ff ff       	call   801667 <syscall>
  801931:	83 c4 18             	add    $0x18,%esp
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 05                	push   $0x5
  801945:	e8 1d fd ff ff       	call   801667 <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
}
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 06                	push   $0x6
  80195e:	e8 04 fd ff ff       	call   801667 <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
}
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 07                	push   $0x7
  801977:	e8 eb fc ff ff       	call   801667 <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
}
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <sys_exit_env>:


void sys_exit_env(void)
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 1c                	push   $0x1c
  801990:	e8 d2 fc ff ff       	call   801667 <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
}
  801998:	90                   	nop
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019a1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019a4:	8d 50 04             	lea    0x4(%eax),%edx
  8019a7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	52                   	push   %edx
  8019b1:	50                   	push   %eax
  8019b2:	6a 1d                	push   $0x1d
  8019b4:	e8 ae fc ff ff       	call   801667 <syscall>
  8019b9:	83 c4 18             	add    $0x18,%esp
	return result;
  8019bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019c5:	89 01                	mov    %eax,(%ecx)
  8019c7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cd:	c9                   	leave  
  8019ce:	c2 04 00             	ret    $0x4

008019d1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	ff 75 10             	pushl  0x10(%ebp)
  8019db:	ff 75 0c             	pushl  0xc(%ebp)
  8019de:	ff 75 08             	pushl  0x8(%ebp)
  8019e1:	6a 13                	push   $0x13
  8019e3:	e8 7f fc ff ff       	call   801667 <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8019eb:	90                   	nop
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <sys_rcr2>:
uint32 sys_rcr2()
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 1e                	push   $0x1e
  8019fd:	e8 65 fc ff ff       	call   801667 <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	83 ec 04             	sub    $0x4,%esp
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a10:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a13:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	50                   	push   %eax
  801a20:	6a 1f                	push   $0x1f
  801a22:	e8 40 fc ff ff       	call   801667 <syscall>
  801a27:	83 c4 18             	add    $0x18,%esp
	return ;
  801a2a:	90                   	nop
}
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    

00801a2d <rsttst>:
void rsttst()
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 21                	push   $0x21
  801a3c:	e8 26 fc ff ff       	call   801667 <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
	return ;
  801a44:	90                   	nop
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	83 ec 04             	sub    $0x4,%esp
  801a4d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a50:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a53:	8b 55 18             	mov    0x18(%ebp),%edx
  801a56:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a5a:	52                   	push   %edx
  801a5b:	50                   	push   %eax
  801a5c:	ff 75 10             	pushl  0x10(%ebp)
  801a5f:	ff 75 0c             	pushl  0xc(%ebp)
  801a62:	ff 75 08             	pushl  0x8(%ebp)
  801a65:	6a 20                	push   $0x20
  801a67:	e8 fb fb ff ff       	call   801667 <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a6f:	90                   	nop
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <chktst>:
void chktst(uint32 n)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	ff 75 08             	pushl  0x8(%ebp)
  801a80:	6a 22                	push   $0x22
  801a82:	e8 e0 fb ff ff       	call   801667 <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
	return ;
  801a8a:	90                   	nop
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <inctst>:

void inctst()
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 23                	push   $0x23
  801a9c:	e8 c6 fb ff ff       	call   801667 <syscall>
  801aa1:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa4:	90                   	nop
}
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <gettst>:
uint32 gettst()
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 24                	push   $0x24
  801ab6:	e8 ac fb ff ff       	call   801667 <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 25                	push   $0x25
  801acf:	e8 93 fb ff ff       	call   801667 <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
  801ad7:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801adc:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae9:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	ff 75 08             	pushl  0x8(%ebp)
  801af9:	6a 26                	push   $0x26
  801afb:	e8 67 fb ff ff       	call   801667 <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
	return ;
  801b03:	90                   	nop
}
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
  801b09:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b0a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b0d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	6a 00                	push   $0x0
  801b18:	53                   	push   %ebx
  801b19:	51                   	push   %ecx
  801b1a:	52                   	push   %edx
  801b1b:	50                   	push   %eax
  801b1c:	6a 27                	push   $0x27
  801b1e:	e8 44 fb ff ff       	call   801667 <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
}
  801b26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	52                   	push   %edx
  801b3b:	50                   	push   %eax
  801b3c:	6a 28                	push   $0x28
  801b3e:	e8 24 fb ff ff       	call   801667 <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
}
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b4b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b51:	8b 45 08             	mov    0x8(%ebp),%eax
  801b54:	6a 00                	push   $0x0
  801b56:	51                   	push   %ecx
  801b57:	ff 75 10             	pushl  0x10(%ebp)
  801b5a:	52                   	push   %edx
  801b5b:	50                   	push   %eax
  801b5c:	6a 29                	push   $0x29
  801b5e:	e8 04 fb ff ff       	call   801667 <syscall>
  801b63:	83 c4 18             	add    $0x18,%esp
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	ff 75 10             	pushl  0x10(%ebp)
  801b72:	ff 75 0c             	pushl  0xc(%ebp)
  801b75:	ff 75 08             	pushl  0x8(%ebp)
  801b78:	6a 12                	push   $0x12
  801b7a:	e8 e8 fa ff ff       	call   801667 <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b82:	90                   	nop
}
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	52                   	push   %edx
  801b95:	50                   	push   %eax
  801b96:	6a 2a                	push   $0x2a
  801b98:	e8 ca fa ff ff       	call   801667 <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
	return;
  801ba0:	90                   	nop
}
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 2b                	push   $0x2b
  801bb2:	e8 b0 fa ff ff       	call   801667 <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
}
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	ff 75 0c             	pushl  0xc(%ebp)
  801bc8:	ff 75 08             	pushl  0x8(%ebp)
  801bcb:	6a 2d                	push   $0x2d
  801bcd:	e8 95 fa ff ff       	call   801667 <syscall>
  801bd2:	83 c4 18             	add    $0x18,%esp
	return;
  801bd5:	90                   	nop
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	ff 75 0c             	pushl  0xc(%ebp)
  801be4:	ff 75 08             	pushl  0x8(%ebp)
  801be7:	6a 2c                	push   $0x2c
  801be9:	e8 79 fa ff ff       	call   801667 <syscall>
  801bee:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf1:	90                   	nop
}
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
  801bf7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801bfa:	83 ec 04             	sub    $0x4,%esp
  801bfd:	68 34 29 80 00       	push   $0x802934
  801c02:	68 25 01 00 00       	push   $0x125
  801c07:	68 67 29 80 00       	push   $0x802967
  801c0c:	e8 ec e6 ff ff       	call   8002fd <_panic>

00801c11 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
  801c14:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801c17:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1a:	ba 60 30 80 00       	mov    $0x803060,%edx
  801c1f:	29 d0                	sub    %edx,%eax
  801c21:	c1 f8 02             	sar    $0x2,%eax
  801c24:	89 c2                	mov    %eax,%edx
  801c26:	89 d0                	mov    %edx,%eax
  801c28:	c1 e0 02             	shl    $0x2,%eax
  801c2b:	01 d0                	add    %edx,%eax
  801c2d:	c1 e0 02             	shl    $0x2,%eax
  801c30:	01 d0                	add    %edx,%eax
  801c32:	c1 e0 02             	shl    $0x2,%eax
  801c35:	01 d0                	add    %edx,%eax
  801c37:	89 c1                	mov    %eax,%ecx
  801c39:	c1 e1 08             	shl    $0x8,%ecx
  801c3c:	01 c8                	add    %ecx,%eax
  801c3e:	89 c1                	mov    %eax,%ecx
  801c40:	c1 e1 10             	shl    $0x10,%ecx
  801c43:	01 c8                	add    %ecx,%eax
  801c45:	01 c0                	add    %eax,%eax
  801c47:	01 d0                	add    %edx,%eax
  801c49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801c4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c4f:	c1 e0 0c             	shl    $0xc,%eax
  801c52:	89 c2                	mov    %eax,%edx
  801c54:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801c59:	01 d0                	add    %edx,%eax
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801c63:	8b 45 08             	mov    0x8(%ebp),%eax
  801c66:	05 00 00 00 02       	add    $0x2000000,%eax
  801c6b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801c6e:	73 16                	jae    801c86 <initialize_dynamic_allocator+0x29>
  801c70:	68 78 29 80 00       	push   $0x802978
  801c75:	68 9e 29 80 00       	push   $0x80299e
  801c7a:	6a 26                	push   $0x26
  801c7c:	68 b3 29 80 00       	push   $0x8029b3
  801c81:	e8 77 e6 ff ff       	call   8002fd <_panic>
		is_initialized = 1;
  801c86:	c7 05 24 30 80 00 01 	movl   $0x1,0x803024
  801c8d:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  801c90:	83 ec 04             	sub    $0x4,%esp
  801c93:	68 cc 29 80 00       	push   $0x8029cc
  801c98:	6a 2e                	push   $0x2e
  801c9a:	68 b3 29 80 00       	push   $0x8029b3
  801c9f:	e8 59 e6 ff ff       	call   8002fd <_panic>

00801ca4 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
  801ca7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  801caa:	83 ec 04             	sub    $0x4,%esp
  801cad:	68 00 2a 80 00       	push   $0x802a00
  801cb2:	6a 3a                	push   $0x3a
  801cb4:	68 b3 29 80 00       	push   $0x8029b3
  801cb9:	e8 3f e6 ff ff       	call   8002fd <_panic>

00801cbe <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
  801cc1:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801cc4:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801ccb:	76 16                	jbe    801ce3 <alloc_block+0x25>
  801ccd:	68 28 2a 80 00       	push   $0x802a28
  801cd2:	68 9e 29 80 00       	push   $0x80299e
  801cd7:	6a 46                	push   $0x46
  801cd9:	68 b3 29 80 00       	push   $0x8029b3
  801cde:	e8 1a e6 ff ff       	call   8002fd <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  801ce3:	83 ec 04             	sub    $0x4,%esp
  801ce6:	68 4c 2a 80 00       	push   $0x802a4c
  801ceb:	6a 4d                	push   $0x4d
  801ced:	68 b3 29 80 00       	push   $0x8029b3
  801cf2:	e8 06 e6 ff ff       	call   8002fd <_panic>

00801cf7 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  801cfd:	8b 55 08             	mov    0x8(%ebp),%edx
  801d00:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801d05:	39 c2                	cmp    %eax,%edx
  801d07:	72 0c                	jb     801d15 <free_block+0x1e>
  801d09:	8b 55 08             	mov    0x8(%ebp),%edx
  801d0c:	a1 40 30 80 00       	mov    0x803040,%eax
  801d11:	39 c2                	cmp    %eax,%edx
  801d13:	72 16                	jb     801d2b <free_block+0x34>
  801d15:	68 70 2a 80 00       	push   $0x802a70
  801d1a:	68 9e 29 80 00       	push   $0x80299e
  801d1f:	6a 5b                	push   $0x5b
  801d21:	68 b3 29 80 00       	push   $0x8029b3
  801d26:	e8 d2 e5 ff ff       	call   8002fd <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  801d2b:	83 ec 04             	sub    $0x4,%esp
  801d2e:	68 a8 2a 80 00       	push   $0x802aa8
  801d33:	6a 63                	push   $0x63
  801d35:	68 b3 29 80 00       	push   $0x8029b3
  801d3a:	e8 be e5 ff ff       	call   8002fd <_panic>

00801d3f <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  801d45:	83 ec 04             	sub    $0x4,%esp
  801d48:	68 cc 2a 80 00       	push   $0x802acc
  801d4d:	6a 72                	push   $0x72
  801d4f:	68 b3 29 80 00       	push   $0x8029b3
  801d54:	e8 a4 e5 ff ff       	call   8002fd <_panic>
  801d59:	66 90                	xchg   %ax,%ax
  801d5b:	90                   	nop

00801d5c <__udivdi3>:
  801d5c:	55                   	push   %ebp
  801d5d:	57                   	push   %edi
  801d5e:	56                   	push   %esi
  801d5f:	53                   	push   %ebx
  801d60:	83 ec 1c             	sub    $0x1c,%esp
  801d63:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d67:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d6f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d73:	89 ca                	mov    %ecx,%edx
  801d75:	89 f8                	mov    %edi,%eax
  801d77:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d7b:	85 f6                	test   %esi,%esi
  801d7d:	75 2d                	jne    801dac <__udivdi3+0x50>
  801d7f:	39 cf                	cmp    %ecx,%edi
  801d81:	77 65                	ja     801de8 <__udivdi3+0x8c>
  801d83:	89 fd                	mov    %edi,%ebp
  801d85:	85 ff                	test   %edi,%edi
  801d87:	75 0b                	jne    801d94 <__udivdi3+0x38>
  801d89:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8e:	31 d2                	xor    %edx,%edx
  801d90:	f7 f7                	div    %edi
  801d92:	89 c5                	mov    %eax,%ebp
  801d94:	31 d2                	xor    %edx,%edx
  801d96:	89 c8                	mov    %ecx,%eax
  801d98:	f7 f5                	div    %ebp
  801d9a:	89 c1                	mov    %eax,%ecx
  801d9c:	89 d8                	mov    %ebx,%eax
  801d9e:	f7 f5                	div    %ebp
  801da0:	89 cf                	mov    %ecx,%edi
  801da2:	89 fa                	mov    %edi,%edx
  801da4:	83 c4 1c             	add    $0x1c,%esp
  801da7:	5b                   	pop    %ebx
  801da8:	5e                   	pop    %esi
  801da9:	5f                   	pop    %edi
  801daa:	5d                   	pop    %ebp
  801dab:	c3                   	ret    
  801dac:	39 ce                	cmp    %ecx,%esi
  801dae:	77 28                	ja     801dd8 <__udivdi3+0x7c>
  801db0:	0f bd fe             	bsr    %esi,%edi
  801db3:	83 f7 1f             	xor    $0x1f,%edi
  801db6:	75 40                	jne    801df8 <__udivdi3+0x9c>
  801db8:	39 ce                	cmp    %ecx,%esi
  801dba:	72 0a                	jb     801dc6 <__udivdi3+0x6a>
  801dbc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801dc0:	0f 87 9e 00 00 00    	ja     801e64 <__udivdi3+0x108>
  801dc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcb:	89 fa                	mov    %edi,%edx
  801dcd:	83 c4 1c             	add    $0x1c,%esp
  801dd0:	5b                   	pop    %ebx
  801dd1:	5e                   	pop    %esi
  801dd2:	5f                   	pop    %edi
  801dd3:	5d                   	pop    %ebp
  801dd4:	c3                   	ret    
  801dd5:	8d 76 00             	lea    0x0(%esi),%esi
  801dd8:	31 ff                	xor    %edi,%edi
  801dda:	31 c0                	xor    %eax,%eax
  801ddc:	89 fa                	mov    %edi,%edx
  801dde:	83 c4 1c             	add    $0x1c,%esp
  801de1:	5b                   	pop    %ebx
  801de2:	5e                   	pop    %esi
  801de3:	5f                   	pop    %edi
  801de4:	5d                   	pop    %ebp
  801de5:	c3                   	ret    
  801de6:	66 90                	xchg   %ax,%ax
  801de8:	89 d8                	mov    %ebx,%eax
  801dea:	f7 f7                	div    %edi
  801dec:	31 ff                	xor    %edi,%edi
  801dee:	89 fa                	mov    %edi,%edx
  801df0:	83 c4 1c             	add    $0x1c,%esp
  801df3:	5b                   	pop    %ebx
  801df4:	5e                   	pop    %esi
  801df5:	5f                   	pop    %edi
  801df6:	5d                   	pop    %ebp
  801df7:	c3                   	ret    
  801df8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801dfd:	89 eb                	mov    %ebp,%ebx
  801dff:	29 fb                	sub    %edi,%ebx
  801e01:	89 f9                	mov    %edi,%ecx
  801e03:	d3 e6                	shl    %cl,%esi
  801e05:	89 c5                	mov    %eax,%ebp
  801e07:	88 d9                	mov    %bl,%cl
  801e09:	d3 ed                	shr    %cl,%ebp
  801e0b:	89 e9                	mov    %ebp,%ecx
  801e0d:	09 f1                	or     %esi,%ecx
  801e0f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801e13:	89 f9                	mov    %edi,%ecx
  801e15:	d3 e0                	shl    %cl,%eax
  801e17:	89 c5                	mov    %eax,%ebp
  801e19:	89 d6                	mov    %edx,%esi
  801e1b:	88 d9                	mov    %bl,%cl
  801e1d:	d3 ee                	shr    %cl,%esi
  801e1f:	89 f9                	mov    %edi,%ecx
  801e21:	d3 e2                	shl    %cl,%edx
  801e23:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e27:	88 d9                	mov    %bl,%cl
  801e29:	d3 e8                	shr    %cl,%eax
  801e2b:	09 c2                	or     %eax,%edx
  801e2d:	89 d0                	mov    %edx,%eax
  801e2f:	89 f2                	mov    %esi,%edx
  801e31:	f7 74 24 0c          	divl   0xc(%esp)
  801e35:	89 d6                	mov    %edx,%esi
  801e37:	89 c3                	mov    %eax,%ebx
  801e39:	f7 e5                	mul    %ebp
  801e3b:	39 d6                	cmp    %edx,%esi
  801e3d:	72 19                	jb     801e58 <__udivdi3+0xfc>
  801e3f:	74 0b                	je     801e4c <__udivdi3+0xf0>
  801e41:	89 d8                	mov    %ebx,%eax
  801e43:	31 ff                	xor    %edi,%edi
  801e45:	e9 58 ff ff ff       	jmp    801da2 <__udivdi3+0x46>
  801e4a:	66 90                	xchg   %ax,%ax
  801e4c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e50:	89 f9                	mov    %edi,%ecx
  801e52:	d3 e2                	shl    %cl,%edx
  801e54:	39 c2                	cmp    %eax,%edx
  801e56:	73 e9                	jae    801e41 <__udivdi3+0xe5>
  801e58:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e5b:	31 ff                	xor    %edi,%edi
  801e5d:	e9 40 ff ff ff       	jmp    801da2 <__udivdi3+0x46>
  801e62:	66 90                	xchg   %ax,%ax
  801e64:	31 c0                	xor    %eax,%eax
  801e66:	e9 37 ff ff ff       	jmp    801da2 <__udivdi3+0x46>
  801e6b:	90                   	nop

00801e6c <__umoddi3>:
  801e6c:	55                   	push   %ebp
  801e6d:	57                   	push   %edi
  801e6e:	56                   	push   %esi
  801e6f:	53                   	push   %ebx
  801e70:	83 ec 1c             	sub    $0x1c,%esp
  801e73:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e77:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e7f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e8b:	89 f3                	mov    %esi,%ebx
  801e8d:	89 fa                	mov    %edi,%edx
  801e8f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e93:	89 34 24             	mov    %esi,(%esp)
  801e96:	85 c0                	test   %eax,%eax
  801e98:	75 1a                	jne    801eb4 <__umoddi3+0x48>
  801e9a:	39 f7                	cmp    %esi,%edi
  801e9c:	0f 86 a2 00 00 00    	jbe    801f44 <__umoddi3+0xd8>
  801ea2:	89 c8                	mov    %ecx,%eax
  801ea4:	89 f2                	mov    %esi,%edx
  801ea6:	f7 f7                	div    %edi
  801ea8:	89 d0                	mov    %edx,%eax
  801eaa:	31 d2                	xor    %edx,%edx
  801eac:	83 c4 1c             	add    $0x1c,%esp
  801eaf:	5b                   	pop    %ebx
  801eb0:	5e                   	pop    %esi
  801eb1:	5f                   	pop    %edi
  801eb2:	5d                   	pop    %ebp
  801eb3:	c3                   	ret    
  801eb4:	39 f0                	cmp    %esi,%eax
  801eb6:	0f 87 ac 00 00 00    	ja     801f68 <__umoddi3+0xfc>
  801ebc:	0f bd e8             	bsr    %eax,%ebp
  801ebf:	83 f5 1f             	xor    $0x1f,%ebp
  801ec2:	0f 84 ac 00 00 00    	je     801f74 <__umoddi3+0x108>
  801ec8:	bf 20 00 00 00       	mov    $0x20,%edi
  801ecd:	29 ef                	sub    %ebp,%edi
  801ecf:	89 fe                	mov    %edi,%esi
  801ed1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ed5:	89 e9                	mov    %ebp,%ecx
  801ed7:	d3 e0                	shl    %cl,%eax
  801ed9:	89 d7                	mov    %edx,%edi
  801edb:	89 f1                	mov    %esi,%ecx
  801edd:	d3 ef                	shr    %cl,%edi
  801edf:	09 c7                	or     %eax,%edi
  801ee1:	89 e9                	mov    %ebp,%ecx
  801ee3:	d3 e2                	shl    %cl,%edx
  801ee5:	89 14 24             	mov    %edx,(%esp)
  801ee8:	89 d8                	mov    %ebx,%eax
  801eea:	d3 e0                	shl    %cl,%eax
  801eec:	89 c2                	mov    %eax,%edx
  801eee:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ef2:	d3 e0                	shl    %cl,%eax
  801ef4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801efc:	89 f1                	mov    %esi,%ecx
  801efe:	d3 e8                	shr    %cl,%eax
  801f00:	09 d0                	or     %edx,%eax
  801f02:	d3 eb                	shr    %cl,%ebx
  801f04:	89 da                	mov    %ebx,%edx
  801f06:	f7 f7                	div    %edi
  801f08:	89 d3                	mov    %edx,%ebx
  801f0a:	f7 24 24             	mull   (%esp)
  801f0d:	89 c6                	mov    %eax,%esi
  801f0f:	89 d1                	mov    %edx,%ecx
  801f11:	39 d3                	cmp    %edx,%ebx
  801f13:	0f 82 87 00 00 00    	jb     801fa0 <__umoddi3+0x134>
  801f19:	0f 84 91 00 00 00    	je     801fb0 <__umoddi3+0x144>
  801f1f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f23:	29 f2                	sub    %esi,%edx
  801f25:	19 cb                	sbb    %ecx,%ebx
  801f27:	89 d8                	mov    %ebx,%eax
  801f29:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801f2d:	d3 e0                	shl    %cl,%eax
  801f2f:	89 e9                	mov    %ebp,%ecx
  801f31:	d3 ea                	shr    %cl,%edx
  801f33:	09 d0                	or     %edx,%eax
  801f35:	89 e9                	mov    %ebp,%ecx
  801f37:	d3 eb                	shr    %cl,%ebx
  801f39:	89 da                	mov    %ebx,%edx
  801f3b:	83 c4 1c             	add    $0x1c,%esp
  801f3e:	5b                   	pop    %ebx
  801f3f:	5e                   	pop    %esi
  801f40:	5f                   	pop    %edi
  801f41:	5d                   	pop    %ebp
  801f42:	c3                   	ret    
  801f43:	90                   	nop
  801f44:	89 fd                	mov    %edi,%ebp
  801f46:	85 ff                	test   %edi,%edi
  801f48:	75 0b                	jne    801f55 <__umoddi3+0xe9>
  801f4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4f:	31 d2                	xor    %edx,%edx
  801f51:	f7 f7                	div    %edi
  801f53:	89 c5                	mov    %eax,%ebp
  801f55:	89 f0                	mov    %esi,%eax
  801f57:	31 d2                	xor    %edx,%edx
  801f59:	f7 f5                	div    %ebp
  801f5b:	89 c8                	mov    %ecx,%eax
  801f5d:	f7 f5                	div    %ebp
  801f5f:	89 d0                	mov    %edx,%eax
  801f61:	e9 44 ff ff ff       	jmp    801eaa <__umoddi3+0x3e>
  801f66:	66 90                	xchg   %ax,%ax
  801f68:	89 c8                	mov    %ecx,%eax
  801f6a:	89 f2                	mov    %esi,%edx
  801f6c:	83 c4 1c             	add    $0x1c,%esp
  801f6f:	5b                   	pop    %ebx
  801f70:	5e                   	pop    %esi
  801f71:	5f                   	pop    %edi
  801f72:	5d                   	pop    %ebp
  801f73:	c3                   	ret    
  801f74:	3b 04 24             	cmp    (%esp),%eax
  801f77:	72 06                	jb     801f7f <__umoddi3+0x113>
  801f79:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801f7d:	77 0f                	ja     801f8e <__umoddi3+0x122>
  801f7f:	89 f2                	mov    %esi,%edx
  801f81:	29 f9                	sub    %edi,%ecx
  801f83:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f87:	89 14 24             	mov    %edx,(%esp)
  801f8a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f8e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f92:	8b 14 24             	mov    (%esp),%edx
  801f95:	83 c4 1c             	add    $0x1c,%esp
  801f98:	5b                   	pop    %ebx
  801f99:	5e                   	pop    %esi
  801f9a:	5f                   	pop    %edi
  801f9b:	5d                   	pop    %ebp
  801f9c:	c3                   	ret    
  801f9d:	8d 76 00             	lea    0x0(%esi),%esi
  801fa0:	2b 04 24             	sub    (%esp),%eax
  801fa3:	19 fa                	sbb    %edi,%edx
  801fa5:	89 d1                	mov    %edx,%ecx
  801fa7:	89 c6                	mov    %eax,%esi
  801fa9:	e9 71 ff ff ff       	jmp    801f1f <__umoddi3+0xb3>
  801fae:	66 90                	xchg   %ax,%ax
  801fb0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801fb4:	72 ea                	jb     801fa0 <__umoddi3+0x134>
  801fb6:	89 d9                	mov    %ebx,%ecx
  801fb8:	e9 62 ff ff ff       	jmp    801f1f <__umoddi3+0xb3>

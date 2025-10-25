
obj/user/ef_tst_semaphore_1slave:     file format elf32-i386


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
  800031:	e8 fa 00 00 00       	call   800130 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program: enter critical section, print it's ID, exit and signal the master program
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 51 17 00 00       	call   801794 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int id = sys_getenvindex();
  800046:	e8 30 17 00 00       	call   80177b <sys_getenvindex>
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("%d: before the critical section\n", id);
  80004e:	83 ec 08             	sub    $0x8,%esp
  800051:	ff 75 f0             	pushl  -0x10(%ebp)
  800054:	68 e0 1d 80 00       	push   $0x801de0
  800059:	e8 50 05 00 00       	call   8005ae <cprintf>
  80005e:	83 c4 10             	add    $0x10,%esp

	struct semaphore cs1 = get_semaphore(parentenvID, "cs1");
  800061:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800064:	83 ec 04             	sub    $0x4,%esp
  800067:	68 01 1e 80 00       	push   $0x801e01
  80006c:	ff 75 f4             	pushl  -0xc(%ebp)
  80006f:	50                   	push   %eax
  800070:	e8 e2 19 00 00       	call   801a57 <get_semaphore>
  800075:	83 c4 0c             	add    $0xc,%esp
	struct semaphore depend1 = get_semaphore(parentenvID, "depend1");
  800078:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80007b:	83 ec 04             	sub    $0x4,%esp
  80007e:	68 05 1e 80 00       	push   $0x801e05
  800083:	ff 75 f4             	pushl  -0xc(%ebp)
  800086:	50                   	push   %eax
  800087:	e8 cb 19 00 00       	call   801a57 <get_semaphore>
  80008c:	83 c4 0c             	add    $0xc,%esp

	wait_semaphore(cs1);
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	ff 75 e8             	pushl  -0x18(%ebp)
  800095:	e8 d7 19 00 00       	call   801a71 <wait_semaphore>
  80009a:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("%d: inside the critical section\n", id) ;
  80009d:	83 ec 08             	sub    $0x8,%esp
  8000a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000a3:	68 10 1e 80 00       	push   $0x801e10
  8000a8:	e8 01 05 00 00       	call   8005ae <cprintf>
  8000ad:	83 c4 10             	add    $0x10,%esp
		cprintf("my ID is %d\n", id);
  8000b0:	83 ec 08             	sub    $0x8,%esp
  8000b3:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b6:	68 31 1e 80 00       	push   $0x801e31
  8000bb:	e8 ee 04 00 00       	call   8005ae <cprintf>
  8000c0:	83 c4 10             	add    $0x10,%esp
		int sem1val = semaphore_count(cs1);
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000c9:	e8 d7 19 00 00       	call   801aa5 <semaphore_count>
  8000ce:	83 c4 10             	add    $0x10,%esp
  8000d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (sem1val > 0)
  8000d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8000d8:	7e 14                	jle    8000ee <_main+0xb6>
			panic("Error: more than 1 process inside the CS... please review your semaphore code again...");
  8000da:	83 ec 04             	sub    $0x4,%esp
  8000dd:	68 40 1e 80 00       	push   $0x801e40
  8000e2:	6a 15                	push   $0x15
  8000e4:	68 98 1e 80 00       	push   $0x801e98
  8000e9:	e8 f2 01 00 00       	call   8002e0 <_panic>
		env_sleep(1000) ;
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	68 e8 03 00 00       	push   $0x3e8
  8000f6:	e8 b5 19 00 00       	call   801ab0 <env_sleep>
  8000fb:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cs1);
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	ff 75 e8             	pushl  -0x18(%ebp)
  800104:	e8 82 19 00 00       	call   801a8b <signal_semaphore>
  800109:	83 c4 10             	add    $0x10,%esp

	cprintf("%d: after the critical section\n", id);
  80010c:	83 ec 08             	sub    $0x8,%esp
  80010f:	ff 75 f0             	pushl  -0x10(%ebp)
  800112:	68 b8 1e 80 00       	push   $0x801eb8
  800117:	e8 92 04 00 00       	call   8005ae <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(depend1);
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	ff 75 e4             	pushl  -0x1c(%ebp)
  800125:	e8 61 19 00 00       	call   801a8b <signal_semaphore>
  80012a:	83 c4 10             	add    $0x10,%esp
	return;
  80012d:	90                   	nop
}
  80012e:	c9                   	leave  
  80012f:	c3                   	ret    

00800130 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800130:	55                   	push   %ebp
  800131:	89 e5                	mov    %esp,%ebp
  800133:	57                   	push   %edi
  800134:	56                   	push   %esi
  800135:	53                   	push   %ebx
  800136:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800139:	e8 3d 16 00 00       	call   80177b <sys_getenvindex>
  80013e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800141:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800144:	89 d0                	mov    %edx,%eax
  800146:	c1 e0 02             	shl    $0x2,%eax
  800149:	01 d0                	add    %edx,%eax
  80014b:	c1 e0 03             	shl    $0x3,%eax
  80014e:	01 d0                	add    %edx,%eax
  800150:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800157:	01 d0                	add    %edx,%eax
  800159:	c1 e0 02             	shl    $0x2,%eax
  80015c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800161:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800166:	a1 20 30 80 00       	mov    0x803020,%eax
  80016b:	8a 40 20             	mov    0x20(%eax),%al
  80016e:	84 c0                	test   %al,%al
  800170:	74 0d                	je     80017f <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800172:	a1 20 30 80 00       	mov    0x803020,%eax
  800177:	83 c0 20             	add    $0x20,%eax
  80017a:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80017f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800183:	7e 0a                	jle    80018f <libmain+0x5f>
		binaryname = argv[0];
  800185:	8b 45 0c             	mov    0xc(%ebp),%eax
  800188:	8b 00                	mov    (%eax),%eax
  80018a:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80018f:	83 ec 08             	sub    $0x8,%esp
  800192:	ff 75 0c             	pushl  0xc(%ebp)
  800195:	ff 75 08             	pushl  0x8(%ebp)
  800198:	e8 9b fe ff ff       	call   800038 <_main>
  80019d:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001a0:	a1 00 30 80 00       	mov    0x803000,%eax
  8001a5:	85 c0                	test   %eax,%eax
  8001a7:	0f 84 01 01 00 00    	je     8002ae <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001ad:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001b3:	bb d0 1f 80 00       	mov    $0x801fd0,%ebx
  8001b8:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001bd:	89 c7                	mov    %eax,%edi
  8001bf:	89 de                	mov    %ebx,%esi
  8001c1:	89 d1                	mov    %edx,%ecx
  8001c3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001c5:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001c8:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001cd:	b0 00                	mov    $0x0,%al
  8001cf:	89 d7                	mov    %edx,%edi
  8001d1:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001d3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001da:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001dd:	83 ec 08             	sub    $0x8,%esp
  8001e0:	50                   	push   %eax
  8001e1:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001e7:	50                   	push   %eax
  8001e8:	e8 c4 17 00 00       	call   8019b1 <sys_utilities>
  8001ed:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001f0:	e8 0d 13 00 00       	call   801502 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 f0 1e 80 00       	push   $0x801ef0
  8001fd:	e8 ac 03 00 00       	call   8005ae <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800205:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800208:	85 c0                	test   %eax,%eax
  80020a:	74 18                	je     800224 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80020c:	e8 be 17 00 00       	call   8019cf <sys_get_optimal_num_faults>
  800211:	83 ec 08             	sub    $0x8,%esp
  800214:	50                   	push   %eax
  800215:	68 18 1f 80 00       	push   $0x801f18
  80021a:	e8 8f 03 00 00       	call   8005ae <cprintf>
  80021f:	83 c4 10             	add    $0x10,%esp
  800222:	eb 59                	jmp    80027d <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800224:	a1 20 30 80 00       	mov    0x803020,%eax
  800229:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80022f:	a1 20 30 80 00       	mov    0x803020,%eax
  800234:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	52                   	push   %edx
  80023e:	50                   	push   %eax
  80023f:	68 3c 1f 80 00       	push   $0x801f3c
  800244:	e8 65 03 00 00       	call   8005ae <cprintf>
  800249:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80024c:	a1 20 30 80 00       	mov    0x803020,%eax
  800251:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800257:	a1 20 30 80 00       	mov    0x803020,%eax
  80025c:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800262:	a1 20 30 80 00       	mov    0x803020,%eax
  800267:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80026d:	51                   	push   %ecx
  80026e:	52                   	push   %edx
  80026f:	50                   	push   %eax
  800270:	68 64 1f 80 00       	push   $0x801f64
  800275:	e8 34 03 00 00       	call   8005ae <cprintf>
  80027a:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80027d:	a1 20 30 80 00       	mov    0x803020,%eax
  800282:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800288:	83 ec 08             	sub    $0x8,%esp
  80028b:	50                   	push   %eax
  80028c:	68 bc 1f 80 00       	push   $0x801fbc
  800291:	e8 18 03 00 00       	call   8005ae <cprintf>
  800296:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	68 f0 1e 80 00       	push   $0x801ef0
  8002a1:	e8 08 03 00 00       	call   8005ae <cprintf>
  8002a6:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002a9:	e8 6e 12 00 00       	call   80151c <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002ae:	e8 1f 00 00 00       	call   8002d2 <exit>
}
  8002b3:	90                   	nop
  8002b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b7:	5b                   	pop    %ebx
  8002b8:	5e                   	pop    %esi
  8002b9:	5f                   	pop    %edi
  8002ba:	5d                   	pop    %ebp
  8002bb:	c3                   	ret    

008002bc <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002c2:	83 ec 0c             	sub    $0xc,%esp
  8002c5:	6a 00                	push   $0x0
  8002c7:	e8 7b 14 00 00       	call   801747 <sys_destroy_env>
  8002cc:	83 c4 10             	add    $0x10,%esp
}
  8002cf:	90                   	nop
  8002d0:	c9                   	leave  
  8002d1:	c3                   	ret    

008002d2 <exit>:

void
exit(void)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002d8:	e8 d0 14 00 00       	call   8017ad <sys_exit_env>
}
  8002dd:	90                   	nop
  8002de:	c9                   	leave  
  8002df:	c3                   	ret    

008002e0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002e6:	8d 45 10             	lea    0x10(%ebp),%eax
  8002e9:	83 c0 04             	add    $0x4,%eax
  8002ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002ef:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002f4:	85 c0                	test   %eax,%eax
  8002f6:	74 16                	je     80030e <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002f8:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002fd:	83 ec 08             	sub    $0x8,%esp
  800300:	50                   	push   %eax
  800301:	68 34 20 80 00       	push   $0x802034
  800306:	e8 a3 02 00 00       	call   8005ae <cprintf>
  80030b:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80030e:	a1 04 30 80 00       	mov    0x803004,%eax
  800313:	83 ec 0c             	sub    $0xc,%esp
  800316:	ff 75 0c             	pushl  0xc(%ebp)
  800319:	ff 75 08             	pushl  0x8(%ebp)
  80031c:	50                   	push   %eax
  80031d:	68 3c 20 80 00       	push   $0x80203c
  800322:	6a 74                	push   $0x74
  800324:	e8 b2 02 00 00       	call   8005db <cprintf_colored>
  800329:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80032c:	8b 45 10             	mov    0x10(%ebp),%eax
  80032f:	83 ec 08             	sub    $0x8,%esp
  800332:	ff 75 f4             	pushl  -0xc(%ebp)
  800335:	50                   	push   %eax
  800336:	e8 04 02 00 00       	call   80053f <vcprintf>
  80033b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	6a 00                	push   $0x0
  800343:	68 64 20 80 00       	push   $0x802064
  800348:	e8 f2 01 00 00       	call   80053f <vcprintf>
  80034d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800350:	e8 7d ff ff ff       	call   8002d2 <exit>

	// should not return here
	while (1) ;
  800355:	eb fe                	jmp    800355 <_panic+0x75>

00800357 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800357:	55                   	push   %ebp
  800358:	89 e5                	mov    %esp,%ebp
  80035a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80035d:	a1 20 30 80 00       	mov    0x803020,%eax
  800362:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800368:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036b:	39 c2                	cmp    %eax,%edx
  80036d:	74 14                	je     800383 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80036f:	83 ec 04             	sub    $0x4,%esp
  800372:	68 68 20 80 00       	push   $0x802068
  800377:	6a 26                	push   $0x26
  800379:	68 b4 20 80 00       	push   $0x8020b4
  80037e:	e8 5d ff ff ff       	call   8002e0 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800383:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80038a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800391:	e9 c5 00 00 00       	jmp    80045b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800396:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800399:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a3:	01 d0                	add    %edx,%eax
  8003a5:	8b 00                	mov    (%eax),%eax
  8003a7:	85 c0                	test   %eax,%eax
  8003a9:	75 08                	jne    8003b3 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003ab:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003ae:	e9 a5 00 00 00       	jmp    800458 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003b3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ba:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003c1:	eb 69                	jmp    80042c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c8:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003ce:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d1:	89 d0                	mov    %edx,%eax
  8003d3:	01 c0                	add    %eax,%eax
  8003d5:	01 d0                	add    %edx,%eax
  8003d7:	c1 e0 03             	shl    $0x3,%eax
  8003da:	01 c8                	add    %ecx,%eax
  8003dc:	8a 40 04             	mov    0x4(%eax),%al
  8003df:	84 c0                	test   %al,%al
  8003e1:	75 46                	jne    800429 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e8:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003ee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003f1:	89 d0                	mov    %edx,%eax
  8003f3:	01 c0                	add    %eax,%eax
  8003f5:	01 d0                	add    %edx,%eax
  8003f7:	c1 e0 03             	shl    $0x3,%eax
  8003fa:	01 c8                	add    %ecx,%eax
  8003fc:	8b 00                	mov    (%eax),%eax
  8003fe:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800401:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800404:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800409:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80040b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80040e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800415:	8b 45 08             	mov    0x8(%ebp),%eax
  800418:	01 c8                	add    %ecx,%eax
  80041a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80041c:	39 c2                	cmp    %eax,%edx
  80041e:	75 09                	jne    800429 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800420:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800427:	eb 15                	jmp    80043e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800429:	ff 45 e8             	incl   -0x18(%ebp)
  80042c:	a1 20 30 80 00       	mov    0x803020,%eax
  800431:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800437:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80043a:	39 c2                	cmp    %eax,%edx
  80043c:	77 85                	ja     8003c3 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80043e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800442:	75 14                	jne    800458 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800444:	83 ec 04             	sub    $0x4,%esp
  800447:	68 c0 20 80 00       	push   $0x8020c0
  80044c:	6a 3a                	push   $0x3a
  80044e:	68 b4 20 80 00       	push   $0x8020b4
  800453:	e8 88 fe ff ff       	call   8002e0 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800458:	ff 45 f0             	incl   -0x10(%ebp)
  80045b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80045e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800461:	0f 8c 2f ff ff ff    	jl     800396 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800467:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800475:	eb 26                	jmp    80049d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800477:	a1 20 30 80 00       	mov    0x803020,%eax
  80047c:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800482:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800485:	89 d0                	mov    %edx,%eax
  800487:	01 c0                	add    %eax,%eax
  800489:	01 d0                	add    %edx,%eax
  80048b:	c1 e0 03             	shl    $0x3,%eax
  80048e:	01 c8                	add    %ecx,%eax
  800490:	8a 40 04             	mov    0x4(%eax),%al
  800493:	3c 01                	cmp    $0x1,%al
  800495:	75 03                	jne    80049a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800497:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80049a:	ff 45 e0             	incl   -0x20(%ebp)
  80049d:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004ab:	39 c2                	cmp    %eax,%edx
  8004ad:	77 c8                	ja     800477 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004b2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004b5:	74 14                	je     8004cb <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004b7:	83 ec 04             	sub    $0x4,%esp
  8004ba:	68 14 21 80 00       	push   $0x802114
  8004bf:	6a 44                	push   $0x44
  8004c1:	68 b4 20 80 00       	push   $0x8020b4
  8004c6:	e8 15 fe ff ff       	call   8002e0 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004cb:	90                   	nop
  8004cc:	c9                   	leave  
  8004cd:	c3                   	ret    

008004ce <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004ce:	55                   	push   %ebp
  8004cf:	89 e5                	mov    %esp,%ebp
  8004d1:	53                   	push   %ebx
  8004d2:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d8:	8b 00                	mov    (%eax),%eax
  8004da:	8d 48 01             	lea    0x1(%eax),%ecx
  8004dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e0:	89 0a                	mov    %ecx,(%edx)
  8004e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8004e5:	88 d1                	mov    %dl,%cl
  8004e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ea:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f1:	8b 00                	mov    (%eax),%eax
  8004f3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004f8:	75 30                	jne    80052a <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004fa:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800500:	a0 44 30 80 00       	mov    0x803044,%al
  800505:	0f b6 c0             	movzbl %al,%eax
  800508:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80050b:	8b 09                	mov    (%ecx),%ecx
  80050d:	89 cb                	mov    %ecx,%ebx
  80050f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800512:	83 c1 08             	add    $0x8,%ecx
  800515:	52                   	push   %edx
  800516:	50                   	push   %eax
  800517:	53                   	push   %ebx
  800518:	51                   	push   %ecx
  800519:	e8 a0 0f 00 00       	call   8014be <sys_cputs>
  80051e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800521:	8b 45 0c             	mov    0xc(%ebp),%eax
  800524:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80052a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052d:	8b 40 04             	mov    0x4(%eax),%eax
  800530:	8d 50 01             	lea    0x1(%eax),%edx
  800533:	8b 45 0c             	mov    0xc(%ebp),%eax
  800536:	89 50 04             	mov    %edx,0x4(%eax)
}
  800539:	90                   	nop
  80053a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80053d:	c9                   	leave  
  80053e:	c3                   	ret    

0080053f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80053f:	55                   	push   %ebp
  800540:	89 e5                	mov    %esp,%ebp
  800542:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800548:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80054f:	00 00 00 
	b.cnt = 0;
  800552:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800559:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80055c:	ff 75 0c             	pushl  0xc(%ebp)
  80055f:	ff 75 08             	pushl  0x8(%ebp)
  800562:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800568:	50                   	push   %eax
  800569:	68 ce 04 80 00       	push   $0x8004ce
  80056e:	e8 5a 02 00 00       	call   8007cd <vprintfmt>
  800573:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800576:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80057c:	a0 44 30 80 00       	mov    0x803044,%al
  800581:	0f b6 c0             	movzbl %al,%eax
  800584:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80058a:	52                   	push   %edx
  80058b:	50                   	push   %eax
  80058c:	51                   	push   %ecx
  80058d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800593:	83 c0 08             	add    $0x8,%eax
  800596:	50                   	push   %eax
  800597:	e8 22 0f 00 00       	call   8014be <sys_cputs>
  80059c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80059f:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8005a6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005ac:	c9                   	leave  
  8005ad:	c3                   	ret    

008005ae <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005ae:	55                   	push   %ebp
  8005af:	89 e5                	mov    %esp,%ebp
  8005b1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005b4:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8005bb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c4:	83 ec 08             	sub    $0x8,%esp
  8005c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ca:	50                   	push   %eax
  8005cb:	e8 6f ff ff ff       	call   80053f <vcprintf>
  8005d0:	83 c4 10             	add    $0x10,%esp
  8005d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005d9:	c9                   	leave  
  8005da:	c3                   	ret    

008005db <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005db:	55                   	push   %ebp
  8005dc:	89 e5                	mov    %esp,%ebp
  8005de:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005e1:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005eb:	c1 e0 08             	shl    $0x8,%eax
  8005ee:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8005f3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005f6:	83 c0 04             	add    $0x4,%eax
  8005f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ff:	83 ec 08             	sub    $0x8,%esp
  800602:	ff 75 f4             	pushl  -0xc(%ebp)
  800605:	50                   	push   %eax
  800606:	e8 34 ff ff ff       	call   80053f <vcprintf>
  80060b:	83 c4 10             	add    $0x10,%esp
  80060e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800611:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800618:	07 00 00 

	return cnt;
  80061b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80061e:	c9                   	leave  
  80061f:	c3                   	ret    

00800620 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800620:	55                   	push   %ebp
  800621:	89 e5                	mov    %esp,%ebp
  800623:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800626:	e8 d7 0e 00 00       	call   801502 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80062b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80062e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800631:	8b 45 08             	mov    0x8(%ebp),%eax
  800634:	83 ec 08             	sub    $0x8,%esp
  800637:	ff 75 f4             	pushl  -0xc(%ebp)
  80063a:	50                   	push   %eax
  80063b:	e8 ff fe ff ff       	call   80053f <vcprintf>
  800640:	83 c4 10             	add    $0x10,%esp
  800643:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800646:	e8 d1 0e 00 00       	call   80151c <sys_unlock_cons>
	return cnt;
  80064b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80064e:	c9                   	leave  
  80064f:	c3                   	ret    

00800650 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800650:	55                   	push   %ebp
  800651:	89 e5                	mov    %esp,%ebp
  800653:	53                   	push   %ebx
  800654:	83 ec 14             	sub    $0x14,%esp
  800657:	8b 45 10             	mov    0x10(%ebp),%eax
  80065a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80065d:	8b 45 14             	mov    0x14(%ebp),%eax
  800660:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800663:	8b 45 18             	mov    0x18(%ebp),%eax
  800666:	ba 00 00 00 00       	mov    $0x0,%edx
  80066b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80066e:	77 55                	ja     8006c5 <printnum+0x75>
  800670:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800673:	72 05                	jb     80067a <printnum+0x2a>
  800675:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800678:	77 4b                	ja     8006c5 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80067a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80067d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800680:	8b 45 18             	mov    0x18(%ebp),%eax
  800683:	ba 00 00 00 00       	mov    $0x0,%edx
  800688:	52                   	push   %edx
  800689:	50                   	push   %eax
  80068a:	ff 75 f4             	pushl  -0xc(%ebp)
  80068d:	ff 75 f0             	pushl  -0x10(%ebp)
  800690:	e8 db 14 00 00       	call   801b70 <__udivdi3>
  800695:	83 c4 10             	add    $0x10,%esp
  800698:	83 ec 04             	sub    $0x4,%esp
  80069b:	ff 75 20             	pushl  0x20(%ebp)
  80069e:	53                   	push   %ebx
  80069f:	ff 75 18             	pushl  0x18(%ebp)
  8006a2:	52                   	push   %edx
  8006a3:	50                   	push   %eax
  8006a4:	ff 75 0c             	pushl  0xc(%ebp)
  8006a7:	ff 75 08             	pushl  0x8(%ebp)
  8006aa:	e8 a1 ff ff ff       	call   800650 <printnum>
  8006af:	83 c4 20             	add    $0x20,%esp
  8006b2:	eb 1a                	jmp    8006ce <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	ff 75 0c             	pushl  0xc(%ebp)
  8006ba:	ff 75 20             	pushl  0x20(%ebp)
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	ff d0                	call   *%eax
  8006c2:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006c5:	ff 4d 1c             	decl   0x1c(%ebp)
  8006c8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006cc:	7f e6                	jg     8006b4 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006ce:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006d1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006dc:	53                   	push   %ebx
  8006dd:	51                   	push   %ecx
  8006de:	52                   	push   %edx
  8006df:	50                   	push   %eax
  8006e0:	e8 9b 15 00 00       	call   801c80 <__umoddi3>
  8006e5:	83 c4 10             	add    $0x10,%esp
  8006e8:	05 74 23 80 00       	add    $0x802374,%eax
  8006ed:	8a 00                	mov    (%eax),%al
  8006ef:	0f be c0             	movsbl %al,%eax
  8006f2:	83 ec 08             	sub    $0x8,%esp
  8006f5:	ff 75 0c             	pushl  0xc(%ebp)
  8006f8:	50                   	push   %eax
  8006f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fc:	ff d0                	call   *%eax
  8006fe:	83 c4 10             	add    $0x10,%esp
}
  800701:	90                   	nop
  800702:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800705:	c9                   	leave  
  800706:	c3                   	ret    

00800707 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800707:	55                   	push   %ebp
  800708:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80070a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80070e:	7e 1c                	jle    80072c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	8b 00                	mov    (%eax),%eax
  800715:	8d 50 08             	lea    0x8(%eax),%edx
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	89 10                	mov    %edx,(%eax)
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	8b 00                	mov    (%eax),%eax
  800722:	83 e8 08             	sub    $0x8,%eax
  800725:	8b 50 04             	mov    0x4(%eax),%edx
  800728:	8b 00                	mov    (%eax),%eax
  80072a:	eb 40                	jmp    80076c <getuint+0x65>
	else if (lflag)
  80072c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800730:	74 1e                	je     800750 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	8b 00                	mov    (%eax),%eax
  800737:	8d 50 04             	lea    0x4(%eax),%edx
  80073a:	8b 45 08             	mov    0x8(%ebp),%eax
  80073d:	89 10                	mov    %edx,(%eax)
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	8b 00                	mov    (%eax),%eax
  800744:	83 e8 04             	sub    $0x4,%eax
  800747:	8b 00                	mov    (%eax),%eax
  800749:	ba 00 00 00 00       	mov    $0x0,%edx
  80074e:	eb 1c                	jmp    80076c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800750:	8b 45 08             	mov    0x8(%ebp),%eax
  800753:	8b 00                	mov    (%eax),%eax
  800755:	8d 50 04             	lea    0x4(%eax),%edx
  800758:	8b 45 08             	mov    0x8(%ebp),%eax
  80075b:	89 10                	mov    %edx,(%eax)
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	83 e8 04             	sub    $0x4,%eax
  800765:	8b 00                	mov    (%eax),%eax
  800767:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80076c:	5d                   	pop    %ebp
  80076d:	c3                   	ret    

0080076e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80076e:	55                   	push   %ebp
  80076f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800771:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800775:	7e 1c                	jle    800793 <getint+0x25>
		return va_arg(*ap, long long);
  800777:	8b 45 08             	mov    0x8(%ebp),%eax
  80077a:	8b 00                	mov    (%eax),%eax
  80077c:	8d 50 08             	lea    0x8(%eax),%edx
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	89 10                	mov    %edx,(%eax)
  800784:	8b 45 08             	mov    0x8(%ebp),%eax
  800787:	8b 00                	mov    (%eax),%eax
  800789:	83 e8 08             	sub    $0x8,%eax
  80078c:	8b 50 04             	mov    0x4(%eax),%edx
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	eb 38                	jmp    8007cb <getint+0x5d>
	else if (lflag)
  800793:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800797:	74 1a                	je     8007b3 <getint+0x45>
		return va_arg(*ap, long);
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	8b 00                	mov    (%eax),%eax
  80079e:	8d 50 04             	lea    0x4(%eax),%edx
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	89 10                	mov    %edx,(%eax)
  8007a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a9:	8b 00                	mov    (%eax),%eax
  8007ab:	83 e8 04             	sub    $0x4,%eax
  8007ae:	8b 00                	mov    (%eax),%eax
  8007b0:	99                   	cltd   
  8007b1:	eb 18                	jmp    8007cb <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	8d 50 04             	lea    0x4(%eax),%edx
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	89 10                	mov    %edx,(%eax)
  8007c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	83 e8 04             	sub    $0x4,%eax
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	99                   	cltd   
}
  8007cb:	5d                   	pop    %ebp
  8007cc:	c3                   	ret    

008007cd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007cd:	55                   	push   %ebp
  8007ce:	89 e5                	mov    %esp,%ebp
  8007d0:	56                   	push   %esi
  8007d1:	53                   	push   %ebx
  8007d2:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d5:	eb 17                	jmp    8007ee <vprintfmt+0x21>
			if (ch == '\0')
  8007d7:	85 db                	test   %ebx,%ebx
  8007d9:	0f 84 c1 03 00 00    	je     800ba0 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007df:	83 ec 08             	sub    $0x8,%esp
  8007e2:	ff 75 0c             	pushl  0xc(%ebp)
  8007e5:	53                   	push   %ebx
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	ff d0                	call   *%eax
  8007eb:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f1:	8d 50 01             	lea    0x1(%eax),%edx
  8007f4:	89 55 10             	mov    %edx,0x10(%ebp)
  8007f7:	8a 00                	mov    (%eax),%al
  8007f9:	0f b6 d8             	movzbl %al,%ebx
  8007fc:	83 fb 25             	cmp    $0x25,%ebx
  8007ff:	75 d6                	jne    8007d7 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800801:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800805:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80080c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800813:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80081a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800821:	8b 45 10             	mov    0x10(%ebp),%eax
  800824:	8d 50 01             	lea    0x1(%eax),%edx
  800827:	89 55 10             	mov    %edx,0x10(%ebp)
  80082a:	8a 00                	mov    (%eax),%al
  80082c:	0f b6 d8             	movzbl %al,%ebx
  80082f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800832:	83 f8 5b             	cmp    $0x5b,%eax
  800835:	0f 87 3d 03 00 00    	ja     800b78 <vprintfmt+0x3ab>
  80083b:	8b 04 85 98 23 80 00 	mov    0x802398(,%eax,4),%eax
  800842:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800844:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800848:	eb d7                	jmp    800821 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80084a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80084e:	eb d1                	jmp    800821 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800850:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800857:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80085a:	89 d0                	mov    %edx,%eax
  80085c:	c1 e0 02             	shl    $0x2,%eax
  80085f:	01 d0                	add    %edx,%eax
  800861:	01 c0                	add    %eax,%eax
  800863:	01 d8                	add    %ebx,%eax
  800865:	83 e8 30             	sub    $0x30,%eax
  800868:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80086b:	8b 45 10             	mov    0x10(%ebp),%eax
  80086e:	8a 00                	mov    (%eax),%al
  800870:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800873:	83 fb 2f             	cmp    $0x2f,%ebx
  800876:	7e 3e                	jle    8008b6 <vprintfmt+0xe9>
  800878:	83 fb 39             	cmp    $0x39,%ebx
  80087b:	7f 39                	jg     8008b6 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80087d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800880:	eb d5                	jmp    800857 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800882:	8b 45 14             	mov    0x14(%ebp),%eax
  800885:	83 c0 04             	add    $0x4,%eax
  800888:	89 45 14             	mov    %eax,0x14(%ebp)
  80088b:	8b 45 14             	mov    0x14(%ebp),%eax
  80088e:	83 e8 04             	sub    $0x4,%eax
  800891:	8b 00                	mov    (%eax),%eax
  800893:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800896:	eb 1f                	jmp    8008b7 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800898:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80089c:	79 83                	jns    800821 <vprintfmt+0x54>
				width = 0;
  80089e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008a5:	e9 77 ff ff ff       	jmp    800821 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008aa:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008b1:	e9 6b ff ff ff       	jmp    800821 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008b6:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008bb:	0f 89 60 ff ff ff    	jns    800821 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008c7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008ce:	e9 4e ff ff ff       	jmp    800821 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008d3:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008d6:	e9 46 ff ff ff       	jmp    800821 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008db:	8b 45 14             	mov    0x14(%ebp),%eax
  8008de:	83 c0 04             	add    $0x4,%eax
  8008e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e7:	83 e8 04             	sub    $0x4,%eax
  8008ea:	8b 00                	mov    (%eax),%eax
  8008ec:	83 ec 08             	sub    $0x8,%esp
  8008ef:	ff 75 0c             	pushl  0xc(%ebp)
  8008f2:	50                   	push   %eax
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	ff d0                	call   *%eax
  8008f8:	83 c4 10             	add    $0x10,%esp
			break;
  8008fb:	e9 9b 02 00 00       	jmp    800b9b <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800900:	8b 45 14             	mov    0x14(%ebp),%eax
  800903:	83 c0 04             	add    $0x4,%eax
  800906:	89 45 14             	mov    %eax,0x14(%ebp)
  800909:	8b 45 14             	mov    0x14(%ebp),%eax
  80090c:	83 e8 04             	sub    $0x4,%eax
  80090f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800911:	85 db                	test   %ebx,%ebx
  800913:	79 02                	jns    800917 <vprintfmt+0x14a>
				err = -err;
  800915:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800917:	83 fb 64             	cmp    $0x64,%ebx
  80091a:	7f 0b                	jg     800927 <vprintfmt+0x15a>
  80091c:	8b 34 9d e0 21 80 00 	mov    0x8021e0(,%ebx,4),%esi
  800923:	85 f6                	test   %esi,%esi
  800925:	75 19                	jne    800940 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800927:	53                   	push   %ebx
  800928:	68 85 23 80 00       	push   $0x802385
  80092d:	ff 75 0c             	pushl  0xc(%ebp)
  800930:	ff 75 08             	pushl  0x8(%ebp)
  800933:	e8 70 02 00 00       	call   800ba8 <printfmt>
  800938:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80093b:	e9 5b 02 00 00       	jmp    800b9b <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800940:	56                   	push   %esi
  800941:	68 8e 23 80 00       	push   $0x80238e
  800946:	ff 75 0c             	pushl  0xc(%ebp)
  800949:	ff 75 08             	pushl  0x8(%ebp)
  80094c:	e8 57 02 00 00       	call   800ba8 <printfmt>
  800951:	83 c4 10             	add    $0x10,%esp
			break;
  800954:	e9 42 02 00 00       	jmp    800b9b <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800959:	8b 45 14             	mov    0x14(%ebp),%eax
  80095c:	83 c0 04             	add    $0x4,%eax
  80095f:	89 45 14             	mov    %eax,0x14(%ebp)
  800962:	8b 45 14             	mov    0x14(%ebp),%eax
  800965:	83 e8 04             	sub    $0x4,%eax
  800968:	8b 30                	mov    (%eax),%esi
  80096a:	85 f6                	test   %esi,%esi
  80096c:	75 05                	jne    800973 <vprintfmt+0x1a6>
				p = "(null)";
  80096e:	be 91 23 80 00       	mov    $0x802391,%esi
			if (width > 0 && padc != '-')
  800973:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800977:	7e 6d                	jle    8009e6 <vprintfmt+0x219>
  800979:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80097d:	74 67                	je     8009e6 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80097f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800982:	83 ec 08             	sub    $0x8,%esp
  800985:	50                   	push   %eax
  800986:	56                   	push   %esi
  800987:	e8 1e 03 00 00       	call   800caa <strnlen>
  80098c:	83 c4 10             	add    $0x10,%esp
  80098f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800992:	eb 16                	jmp    8009aa <vprintfmt+0x1dd>
					putch(padc, putdat);
  800994:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800998:	83 ec 08             	sub    $0x8,%esp
  80099b:	ff 75 0c             	pushl  0xc(%ebp)
  80099e:	50                   	push   %eax
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	ff d0                	call   *%eax
  8009a4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009a7:	ff 4d e4             	decl   -0x1c(%ebp)
  8009aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ae:	7f e4                	jg     800994 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b0:	eb 34                	jmp    8009e6 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009b2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009b6:	74 1c                	je     8009d4 <vprintfmt+0x207>
  8009b8:	83 fb 1f             	cmp    $0x1f,%ebx
  8009bb:	7e 05                	jle    8009c2 <vprintfmt+0x1f5>
  8009bd:	83 fb 7e             	cmp    $0x7e,%ebx
  8009c0:	7e 12                	jle    8009d4 <vprintfmt+0x207>
					putch('?', putdat);
  8009c2:	83 ec 08             	sub    $0x8,%esp
  8009c5:	ff 75 0c             	pushl  0xc(%ebp)
  8009c8:	6a 3f                	push   $0x3f
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	ff d0                	call   *%eax
  8009cf:	83 c4 10             	add    $0x10,%esp
  8009d2:	eb 0f                	jmp    8009e3 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009d4:	83 ec 08             	sub    $0x8,%esp
  8009d7:	ff 75 0c             	pushl  0xc(%ebp)
  8009da:	53                   	push   %ebx
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	ff d0                	call   *%eax
  8009e0:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009e3:	ff 4d e4             	decl   -0x1c(%ebp)
  8009e6:	89 f0                	mov    %esi,%eax
  8009e8:	8d 70 01             	lea    0x1(%eax),%esi
  8009eb:	8a 00                	mov    (%eax),%al
  8009ed:	0f be d8             	movsbl %al,%ebx
  8009f0:	85 db                	test   %ebx,%ebx
  8009f2:	74 24                	je     800a18 <vprintfmt+0x24b>
  8009f4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009f8:	78 b8                	js     8009b2 <vprintfmt+0x1e5>
  8009fa:	ff 4d e0             	decl   -0x20(%ebp)
  8009fd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a01:	79 af                	jns    8009b2 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a03:	eb 13                	jmp    800a18 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a05:	83 ec 08             	sub    $0x8,%esp
  800a08:	ff 75 0c             	pushl  0xc(%ebp)
  800a0b:	6a 20                	push   $0x20
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	ff d0                	call   *%eax
  800a12:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a15:	ff 4d e4             	decl   -0x1c(%ebp)
  800a18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a1c:	7f e7                	jg     800a05 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a1e:	e9 78 01 00 00       	jmp    800b9b <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a23:	83 ec 08             	sub    $0x8,%esp
  800a26:	ff 75 e8             	pushl  -0x18(%ebp)
  800a29:	8d 45 14             	lea    0x14(%ebp),%eax
  800a2c:	50                   	push   %eax
  800a2d:	e8 3c fd ff ff       	call   80076e <getint>
  800a32:	83 c4 10             	add    $0x10,%esp
  800a35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a38:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a41:	85 d2                	test   %edx,%edx
  800a43:	79 23                	jns    800a68 <vprintfmt+0x29b>
				putch('-', putdat);
  800a45:	83 ec 08             	sub    $0x8,%esp
  800a48:	ff 75 0c             	pushl  0xc(%ebp)
  800a4b:	6a 2d                	push   $0x2d
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	ff d0                	call   *%eax
  800a52:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a5b:	f7 d8                	neg    %eax
  800a5d:	83 d2 00             	adc    $0x0,%edx
  800a60:	f7 da                	neg    %edx
  800a62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a65:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a68:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a6f:	e9 bc 00 00 00       	jmp    800b30 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a74:	83 ec 08             	sub    $0x8,%esp
  800a77:	ff 75 e8             	pushl  -0x18(%ebp)
  800a7a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a7d:	50                   	push   %eax
  800a7e:	e8 84 fc ff ff       	call   800707 <getuint>
  800a83:	83 c4 10             	add    $0x10,%esp
  800a86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a89:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a8c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a93:	e9 98 00 00 00       	jmp    800b30 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a98:	83 ec 08             	sub    $0x8,%esp
  800a9b:	ff 75 0c             	pushl  0xc(%ebp)
  800a9e:	6a 58                	push   $0x58
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	ff d0                	call   *%eax
  800aa5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aa8:	83 ec 08             	sub    $0x8,%esp
  800aab:	ff 75 0c             	pushl  0xc(%ebp)
  800aae:	6a 58                	push   $0x58
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	ff d0                	call   *%eax
  800ab5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ab8:	83 ec 08             	sub    $0x8,%esp
  800abb:	ff 75 0c             	pushl  0xc(%ebp)
  800abe:	6a 58                	push   $0x58
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	ff d0                	call   *%eax
  800ac5:	83 c4 10             	add    $0x10,%esp
			break;
  800ac8:	e9 ce 00 00 00       	jmp    800b9b <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800acd:	83 ec 08             	sub    $0x8,%esp
  800ad0:	ff 75 0c             	pushl  0xc(%ebp)
  800ad3:	6a 30                	push   $0x30
  800ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad8:	ff d0                	call   *%eax
  800ada:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800add:	83 ec 08             	sub    $0x8,%esp
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	6a 78                	push   $0x78
  800ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae8:	ff d0                	call   *%eax
  800aea:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800aed:	8b 45 14             	mov    0x14(%ebp),%eax
  800af0:	83 c0 04             	add    $0x4,%eax
  800af3:	89 45 14             	mov    %eax,0x14(%ebp)
  800af6:	8b 45 14             	mov    0x14(%ebp),%eax
  800af9:	83 e8 04             	sub    $0x4,%eax
  800afc:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800afe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b08:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b0f:	eb 1f                	jmp    800b30 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b11:	83 ec 08             	sub    $0x8,%esp
  800b14:	ff 75 e8             	pushl  -0x18(%ebp)
  800b17:	8d 45 14             	lea    0x14(%ebp),%eax
  800b1a:	50                   	push   %eax
  800b1b:	e8 e7 fb ff ff       	call   800707 <getuint>
  800b20:	83 c4 10             	add    $0x10,%esp
  800b23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b26:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b29:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b30:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b37:	83 ec 04             	sub    $0x4,%esp
  800b3a:	52                   	push   %edx
  800b3b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b3e:	50                   	push   %eax
  800b3f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b42:	ff 75 f0             	pushl  -0x10(%ebp)
  800b45:	ff 75 0c             	pushl  0xc(%ebp)
  800b48:	ff 75 08             	pushl  0x8(%ebp)
  800b4b:	e8 00 fb ff ff       	call   800650 <printnum>
  800b50:	83 c4 20             	add    $0x20,%esp
			break;
  800b53:	eb 46                	jmp    800b9b <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b55:	83 ec 08             	sub    $0x8,%esp
  800b58:	ff 75 0c             	pushl  0xc(%ebp)
  800b5b:	53                   	push   %ebx
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	ff d0                	call   *%eax
  800b61:	83 c4 10             	add    $0x10,%esp
			break;
  800b64:	eb 35                	jmp    800b9b <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b66:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b6d:	eb 2c                	jmp    800b9b <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b6f:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b76:	eb 23                	jmp    800b9b <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b78:	83 ec 08             	sub    $0x8,%esp
  800b7b:	ff 75 0c             	pushl  0xc(%ebp)
  800b7e:	6a 25                	push   $0x25
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	ff d0                	call   *%eax
  800b85:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b88:	ff 4d 10             	decl   0x10(%ebp)
  800b8b:	eb 03                	jmp    800b90 <vprintfmt+0x3c3>
  800b8d:	ff 4d 10             	decl   0x10(%ebp)
  800b90:	8b 45 10             	mov    0x10(%ebp),%eax
  800b93:	48                   	dec    %eax
  800b94:	8a 00                	mov    (%eax),%al
  800b96:	3c 25                	cmp    $0x25,%al
  800b98:	75 f3                	jne    800b8d <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b9a:	90                   	nop
		}
	}
  800b9b:	e9 35 fc ff ff       	jmp    8007d5 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ba0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ba1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ba4:	5b                   	pop    %ebx
  800ba5:	5e                   	pop    %esi
  800ba6:	5d                   	pop    %ebp
  800ba7:	c3                   	ret    

00800ba8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ba8:	55                   	push   %ebp
  800ba9:	89 e5                	mov    %esp,%ebp
  800bab:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bae:	8d 45 10             	lea    0x10(%ebp),%eax
  800bb1:	83 c0 04             	add    $0x4,%eax
  800bb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bba:	ff 75 f4             	pushl  -0xc(%ebp)
  800bbd:	50                   	push   %eax
  800bbe:	ff 75 0c             	pushl  0xc(%ebp)
  800bc1:	ff 75 08             	pushl  0x8(%ebp)
  800bc4:	e8 04 fc ff ff       	call   8007cd <vprintfmt>
  800bc9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bcc:	90                   	nop
  800bcd:	c9                   	leave  
  800bce:	c3                   	ret    

00800bcf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd5:	8b 40 08             	mov    0x8(%eax),%eax
  800bd8:	8d 50 01             	lea    0x1(%eax),%edx
  800bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bde:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800be1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be4:	8b 10                	mov    (%eax),%edx
  800be6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be9:	8b 40 04             	mov    0x4(%eax),%eax
  800bec:	39 c2                	cmp    %eax,%edx
  800bee:	73 12                	jae    800c02 <sprintputch+0x33>
		*b->buf++ = ch;
  800bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf3:	8b 00                	mov    (%eax),%eax
  800bf5:	8d 48 01             	lea    0x1(%eax),%ecx
  800bf8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bfb:	89 0a                	mov    %ecx,(%edx)
  800bfd:	8b 55 08             	mov    0x8(%ebp),%edx
  800c00:	88 10                	mov    %dl,(%eax)
}
  800c02:	90                   	nop
  800c03:	5d                   	pop    %ebp
  800c04:	c3                   	ret    

00800c05 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c14:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1a:	01 d0                	add    %edx,%eax
  800c1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c1f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c26:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c2a:	74 06                	je     800c32 <vsnprintf+0x2d>
  800c2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c30:	7f 07                	jg     800c39 <vsnprintf+0x34>
		return -E_INVAL;
  800c32:	b8 03 00 00 00       	mov    $0x3,%eax
  800c37:	eb 20                	jmp    800c59 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c39:	ff 75 14             	pushl  0x14(%ebp)
  800c3c:	ff 75 10             	pushl  0x10(%ebp)
  800c3f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c42:	50                   	push   %eax
  800c43:	68 cf 0b 80 00       	push   $0x800bcf
  800c48:	e8 80 fb ff ff       	call   8007cd <vprintfmt>
  800c4d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c53:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c59:	c9                   	leave  
  800c5a:	c3                   	ret    

00800c5b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c61:	8d 45 10             	lea    0x10(%ebp),%eax
  800c64:	83 c0 04             	add    $0x4,%eax
  800c67:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c70:	50                   	push   %eax
  800c71:	ff 75 0c             	pushl  0xc(%ebp)
  800c74:	ff 75 08             	pushl  0x8(%ebp)
  800c77:	e8 89 ff ff ff       	call   800c05 <vsnprintf>
  800c7c:	83 c4 10             	add    $0x10,%esp
  800c7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c82:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c85:	c9                   	leave  
  800c86:	c3                   	ret    

00800c87 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c94:	eb 06                	jmp    800c9c <strlen+0x15>
		n++;
  800c96:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c99:	ff 45 08             	incl   0x8(%ebp)
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	8a 00                	mov    (%eax),%al
  800ca1:	84 c0                	test   %al,%al
  800ca3:	75 f1                	jne    800c96 <strlen+0xf>
		n++;
	return n;
  800ca5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cb0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cb7:	eb 09                	jmp    800cc2 <strnlen+0x18>
		n++;
  800cb9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cbc:	ff 45 08             	incl   0x8(%ebp)
  800cbf:	ff 4d 0c             	decl   0xc(%ebp)
  800cc2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cc6:	74 09                	je     800cd1 <strnlen+0x27>
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	8a 00                	mov    (%eax),%al
  800ccd:	84 c0                	test   %al,%al
  800ccf:	75 e8                	jne    800cb9 <strnlen+0xf>
		n++;
	return n;
  800cd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd4:	c9                   	leave  
  800cd5:	c3                   	ret    

00800cd6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cd6:	55                   	push   %ebp
  800cd7:	89 e5                	mov    %esp,%ebp
  800cd9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ce2:	90                   	nop
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	8d 50 01             	lea    0x1(%eax),%edx
  800ce9:	89 55 08             	mov    %edx,0x8(%ebp)
  800cec:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cef:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cf2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cf5:	8a 12                	mov    (%edx),%dl
  800cf7:	88 10                	mov    %dl,(%eax)
  800cf9:	8a 00                	mov    (%eax),%al
  800cfb:	84 c0                	test   %al,%al
  800cfd:	75 e4                	jne    800ce3 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d02:	c9                   	leave  
  800d03:	c3                   	ret    

00800d04 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d10:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d17:	eb 1f                	jmp    800d38 <strncpy+0x34>
		*dst++ = *src;
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8d 50 01             	lea    0x1(%eax),%edx
  800d1f:	89 55 08             	mov    %edx,0x8(%ebp)
  800d22:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d25:	8a 12                	mov    (%edx),%dl
  800d27:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	84 c0                	test   %al,%al
  800d30:	74 03                	je     800d35 <strncpy+0x31>
			src++;
  800d32:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d35:	ff 45 fc             	incl   -0x4(%ebp)
  800d38:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d3b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d3e:	72 d9                	jb     800d19 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d40:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d43:	c9                   	leave  
  800d44:	c3                   	ret    

00800d45 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d45:	55                   	push   %ebp
  800d46:	89 e5                	mov    %esp,%ebp
  800d48:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d55:	74 30                	je     800d87 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d57:	eb 16                	jmp    800d6f <strlcpy+0x2a>
			*dst++ = *src++;
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	8d 50 01             	lea    0x1(%eax),%edx
  800d5f:	89 55 08             	mov    %edx,0x8(%ebp)
  800d62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d65:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d68:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d6b:	8a 12                	mov    (%edx),%dl
  800d6d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d6f:	ff 4d 10             	decl   0x10(%ebp)
  800d72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d76:	74 09                	je     800d81 <strlcpy+0x3c>
  800d78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	84 c0                	test   %al,%al
  800d7f:	75 d8                	jne    800d59 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d87:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d8d:	29 c2                	sub    %eax,%edx
  800d8f:	89 d0                	mov    %edx,%eax
}
  800d91:	c9                   	leave  
  800d92:	c3                   	ret    

00800d93 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d96:	eb 06                	jmp    800d9e <strcmp+0xb>
		p++, q++;
  800d98:	ff 45 08             	incl   0x8(%ebp)
  800d9b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8a 00                	mov    (%eax),%al
  800da3:	84 c0                	test   %al,%al
  800da5:	74 0e                	je     800db5 <strcmp+0x22>
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8a 10                	mov    (%eax),%dl
  800dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800daf:	8a 00                	mov    (%eax),%al
  800db1:	38 c2                	cmp    %al,%dl
  800db3:	74 e3                	je     800d98 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	8a 00                	mov    (%eax),%al
  800dba:	0f b6 d0             	movzbl %al,%edx
  800dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc0:	8a 00                	mov    (%eax),%al
  800dc2:	0f b6 c0             	movzbl %al,%eax
  800dc5:	29 c2                	sub    %eax,%edx
  800dc7:	89 d0                	mov    %edx,%eax
}
  800dc9:	5d                   	pop    %ebp
  800dca:	c3                   	ret    

00800dcb <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dce:	eb 09                	jmp    800dd9 <strncmp+0xe>
		n--, p++, q++;
  800dd0:	ff 4d 10             	decl   0x10(%ebp)
  800dd3:	ff 45 08             	incl   0x8(%ebp)
  800dd6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dd9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ddd:	74 17                	je     800df6 <strncmp+0x2b>
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	8a 00                	mov    (%eax),%al
  800de4:	84 c0                	test   %al,%al
  800de6:	74 0e                	je     800df6 <strncmp+0x2b>
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	8a 10                	mov    (%eax),%dl
  800ded:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df0:	8a 00                	mov    (%eax),%al
  800df2:	38 c2                	cmp    %al,%dl
  800df4:	74 da                	je     800dd0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800df6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dfa:	75 07                	jne    800e03 <strncmp+0x38>
		return 0;
  800dfc:	b8 00 00 00 00       	mov    $0x0,%eax
  800e01:	eb 14                	jmp    800e17 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e03:	8b 45 08             	mov    0x8(%ebp),%eax
  800e06:	8a 00                	mov    (%eax),%al
  800e08:	0f b6 d0             	movzbl %al,%edx
  800e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0e:	8a 00                	mov    (%eax),%al
  800e10:	0f b6 c0             	movzbl %al,%eax
  800e13:	29 c2                	sub    %eax,%edx
  800e15:	89 d0                	mov    %edx,%eax
}
  800e17:	5d                   	pop    %ebp
  800e18:	c3                   	ret    

00800e19 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	83 ec 04             	sub    $0x4,%esp
  800e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e22:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e25:	eb 12                	jmp    800e39 <strchr+0x20>
		if (*s == c)
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8a 00                	mov    (%eax),%al
  800e2c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e2f:	75 05                	jne    800e36 <strchr+0x1d>
			return (char *) s;
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	eb 11                	jmp    800e47 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e36:	ff 45 08             	incl   0x8(%ebp)
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	84 c0                	test   %al,%al
  800e40:	75 e5                	jne    800e27 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e47:	c9                   	leave  
  800e48:	c3                   	ret    

00800e49 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	83 ec 04             	sub    $0x4,%esp
  800e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e52:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e55:	eb 0d                	jmp    800e64 <strfind+0x1b>
		if (*s == c)
  800e57:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e5f:	74 0e                	je     800e6f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e61:	ff 45 08             	incl   0x8(%ebp)
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	8a 00                	mov    (%eax),%al
  800e69:	84 c0                	test   %al,%al
  800e6b:	75 ea                	jne    800e57 <strfind+0xe>
  800e6d:	eb 01                	jmp    800e70 <strfind+0x27>
		if (*s == c)
			break;
  800e6f:	90                   	nop
	return (char *) s;
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e73:	c9                   	leave  
  800e74:	c3                   	ret    

00800e75 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e75:	55                   	push   %ebp
  800e76:	89 e5                	mov    %esp,%ebp
  800e78:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e81:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e85:	76 63                	jbe    800eea <memset+0x75>
		uint64 data_block = c;
  800e87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8a:	99                   	cltd   
  800e8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e8e:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e97:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e9b:	c1 e0 08             	shl    $0x8,%eax
  800e9e:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ea1:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ea4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eaa:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800eae:	c1 e0 10             	shl    $0x10,%eax
  800eb1:	09 45 f0             	or     %eax,-0x10(%ebp)
  800eb4:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ebd:	89 c2                	mov    %eax,%edx
  800ebf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec4:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ec7:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800eca:	eb 18                	jmp    800ee4 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ecc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ecf:	8d 41 08             	lea    0x8(%ecx),%eax
  800ed2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ed5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800edb:	89 01                	mov    %eax,(%ecx)
  800edd:	89 51 04             	mov    %edx,0x4(%ecx)
  800ee0:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ee4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ee8:	77 e2                	ja     800ecc <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800eea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eee:	74 23                	je     800f13 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ef0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ef6:	eb 0e                	jmp    800f06 <memset+0x91>
			*p8++ = (uint8)c;
  800ef8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efb:	8d 50 01             	lea    0x1(%eax),%edx
  800efe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f04:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f06:	8b 45 10             	mov    0x10(%ebp),%eax
  800f09:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f0c:	89 55 10             	mov    %edx,0x10(%ebp)
  800f0f:	85 c0                	test   %eax,%eax
  800f11:	75 e5                	jne    800ef8 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
  800f27:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f2a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f2e:	76 24                	jbe    800f54 <memcpy+0x3c>
		while(n >= 8){
  800f30:	eb 1c                	jmp    800f4e <memcpy+0x36>
			*d64 = *s64;
  800f32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f35:	8b 50 04             	mov    0x4(%eax),%edx
  800f38:	8b 00                	mov    (%eax),%eax
  800f3a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f3d:	89 01                	mov    %eax,(%ecx)
  800f3f:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f42:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f46:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f4a:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f4e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f52:	77 de                	ja     800f32 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f54:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f58:	74 31                	je     800f8b <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f60:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f63:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f66:	eb 16                	jmp    800f7e <memcpy+0x66>
			*d8++ = *s8++;
  800f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f6b:	8d 50 01             	lea    0x1(%eax),%edx
  800f6e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f74:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f77:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f7a:	8a 12                	mov    (%edx),%dl
  800f7c:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f81:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f84:	89 55 10             	mov    %edx,0x10(%ebp)
  800f87:	85 c0                	test   %eax,%eax
  800f89:	75 dd                	jne    800f68 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f8b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f8e:	c9                   	leave  
  800f8f:	c3                   	ret    

00800f90 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f90:	55                   	push   %ebp
  800f91:	89 e5                	mov    %esp,%ebp
  800f93:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fa2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa8:	73 50                	jae    800ffa <memmove+0x6a>
  800faa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fad:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb0:	01 d0                	add    %edx,%eax
  800fb2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb5:	76 43                	jbe    800ffa <memmove+0x6a>
		s += n;
  800fb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fba:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc0:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fc3:	eb 10                	jmp    800fd5 <memmove+0x45>
			*--d = *--s;
  800fc5:	ff 4d f8             	decl   -0x8(%ebp)
  800fc8:	ff 4d fc             	decl   -0x4(%ebp)
  800fcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fce:	8a 10                	mov    (%eax),%dl
  800fd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd3:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fdb:	89 55 10             	mov    %edx,0x10(%ebp)
  800fde:	85 c0                	test   %eax,%eax
  800fe0:	75 e3                	jne    800fc5 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fe2:	eb 23                	jmp    801007 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fe4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe7:	8d 50 01             	lea    0x1(%eax),%edx
  800fea:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ff3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ff6:	8a 12                	mov    (%edx),%dl
  800ff8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffd:	8d 50 ff             	lea    -0x1(%eax),%edx
  801000:	89 55 10             	mov    %edx,0x10(%ebp)
  801003:	85 c0                	test   %eax,%eax
  801005:	75 dd                	jne    800fe4 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
  801015:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80101e:	eb 2a                	jmp    80104a <memcmp+0x3e>
		if (*s1 != *s2)
  801020:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801023:	8a 10                	mov    (%eax),%dl
  801025:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801028:	8a 00                	mov    (%eax),%al
  80102a:	38 c2                	cmp    %al,%dl
  80102c:	74 16                	je     801044 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80102e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801031:	8a 00                	mov    (%eax),%al
  801033:	0f b6 d0             	movzbl %al,%edx
  801036:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	0f b6 c0             	movzbl %al,%eax
  80103e:	29 c2                	sub    %eax,%edx
  801040:	89 d0                	mov    %edx,%eax
  801042:	eb 18                	jmp    80105c <memcmp+0x50>
		s1++, s2++;
  801044:	ff 45 fc             	incl   -0x4(%ebp)
  801047:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80104a:	8b 45 10             	mov    0x10(%ebp),%eax
  80104d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801050:	89 55 10             	mov    %edx,0x10(%ebp)
  801053:	85 c0                	test   %eax,%eax
  801055:	75 c9                	jne    801020 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801057:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80105c:	c9                   	leave  
  80105d:	c3                   	ret    

0080105e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80105e:	55                   	push   %ebp
  80105f:	89 e5                	mov    %esp,%ebp
  801061:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801064:	8b 55 08             	mov    0x8(%ebp),%edx
  801067:	8b 45 10             	mov    0x10(%ebp),%eax
  80106a:	01 d0                	add    %edx,%eax
  80106c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80106f:	eb 15                	jmp    801086 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	8a 00                	mov    (%eax),%al
  801076:	0f b6 d0             	movzbl %al,%edx
  801079:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107c:	0f b6 c0             	movzbl %al,%eax
  80107f:	39 c2                	cmp    %eax,%edx
  801081:	74 0d                	je     801090 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801083:	ff 45 08             	incl   0x8(%ebp)
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
  801089:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80108c:	72 e3                	jb     801071 <memfind+0x13>
  80108e:	eb 01                	jmp    801091 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801090:	90                   	nop
	return (void *) s;
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801094:	c9                   	leave  
  801095:	c3                   	ret    

00801096 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801096:	55                   	push   %ebp
  801097:	89 e5                	mov    %esp,%ebp
  801099:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80109c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010aa:	eb 03                	jmp    8010af <strtol+0x19>
		s++;
  8010ac:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	8a 00                	mov    (%eax),%al
  8010b4:	3c 20                	cmp    $0x20,%al
  8010b6:	74 f4                	je     8010ac <strtol+0x16>
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8a 00                	mov    (%eax),%al
  8010bd:	3c 09                	cmp    $0x9,%al
  8010bf:	74 eb                	je     8010ac <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	3c 2b                	cmp    $0x2b,%al
  8010c8:	75 05                	jne    8010cf <strtol+0x39>
		s++;
  8010ca:	ff 45 08             	incl   0x8(%ebp)
  8010cd:	eb 13                	jmp    8010e2 <strtol+0x4c>
	else if (*s == '-')
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	3c 2d                	cmp    $0x2d,%al
  8010d6:	75 0a                	jne    8010e2 <strtol+0x4c>
		s++, neg = 1;
  8010d8:	ff 45 08             	incl   0x8(%ebp)
  8010db:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e6:	74 06                	je     8010ee <strtol+0x58>
  8010e8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010ec:	75 20                	jne    80110e <strtol+0x78>
  8010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f1:	8a 00                	mov    (%eax),%al
  8010f3:	3c 30                	cmp    $0x30,%al
  8010f5:	75 17                	jne    80110e <strtol+0x78>
  8010f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fa:	40                   	inc    %eax
  8010fb:	8a 00                	mov    (%eax),%al
  8010fd:	3c 78                	cmp    $0x78,%al
  8010ff:	75 0d                	jne    80110e <strtol+0x78>
		s += 2, base = 16;
  801101:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801105:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80110c:	eb 28                	jmp    801136 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80110e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801112:	75 15                	jne    801129 <strtol+0x93>
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	8a 00                	mov    (%eax),%al
  801119:	3c 30                	cmp    $0x30,%al
  80111b:	75 0c                	jne    801129 <strtol+0x93>
		s++, base = 8;
  80111d:	ff 45 08             	incl   0x8(%ebp)
  801120:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801127:	eb 0d                	jmp    801136 <strtol+0xa0>
	else if (base == 0)
  801129:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80112d:	75 07                	jne    801136 <strtol+0xa0>
		base = 10;
  80112f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	8a 00                	mov    (%eax),%al
  80113b:	3c 2f                	cmp    $0x2f,%al
  80113d:	7e 19                	jle    801158 <strtol+0xc2>
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	3c 39                	cmp    $0x39,%al
  801146:	7f 10                	jg     801158 <strtol+0xc2>
			dig = *s - '0';
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	0f be c0             	movsbl %al,%eax
  801150:	83 e8 30             	sub    $0x30,%eax
  801153:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801156:	eb 42                	jmp    80119a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	8a 00                	mov    (%eax),%al
  80115d:	3c 60                	cmp    $0x60,%al
  80115f:	7e 19                	jle    80117a <strtol+0xe4>
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	8a 00                	mov    (%eax),%al
  801166:	3c 7a                	cmp    $0x7a,%al
  801168:	7f 10                	jg     80117a <strtol+0xe4>
			dig = *s - 'a' + 10;
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
  80116d:	8a 00                	mov    (%eax),%al
  80116f:	0f be c0             	movsbl %al,%eax
  801172:	83 e8 57             	sub    $0x57,%eax
  801175:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801178:	eb 20                	jmp    80119a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
  80117d:	8a 00                	mov    (%eax),%al
  80117f:	3c 40                	cmp    $0x40,%al
  801181:	7e 39                	jle    8011bc <strtol+0x126>
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	8a 00                	mov    (%eax),%al
  801188:	3c 5a                	cmp    $0x5a,%al
  80118a:	7f 30                	jg     8011bc <strtol+0x126>
			dig = *s - 'A' + 10;
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	0f be c0             	movsbl %al,%eax
  801194:	83 e8 37             	sub    $0x37,%eax
  801197:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80119a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80119d:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011a0:	7d 19                	jge    8011bb <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011a2:	ff 45 08             	incl   0x8(%ebp)
  8011a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a8:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011ac:	89 c2                	mov    %eax,%edx
  8011ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b1:	01 d0                	add    %edx,%eax
  8011b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011b6:	e9 7b ff ff ff       	jmp    801136 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011bb:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011c0:	74 08                	je     8011ca <strtol+0x134>
		*endptr = (char *) s;
  8011c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c8:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011ce:	74 07                	je     8011d7 <strtol+0x141>
  8011d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d3:	f7 d8                	neg    %eax
  8011d5:	eb 03                	jmp    8011da <strtol+0x144>
  8011d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011da:	c9                   	leave  
  8011db:	c3                   	ret    

008011dc <ltostr>:

void
ltostr(long value, char *str)
{
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
  8011df:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011e9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011f4:	79 13                	jns    801209 <ltostr+0x2d>
	{
		neg = 1;
  8011f6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801200:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801203:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801206:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801211:	99                   	cltd   
  801212:	f7 f9                	idiv   %ecx
  801214:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801217:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121a:	8d 50 01             	lea    0x1(%eax),%edx
  80121d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801220:	89 c2                	mov    %eax,%edx
  801222:	8b 45 0c             	mov    0xc(%ebp),%eax
  801225:	01 d0                	add    %edx,%eax
  801227:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80122a:	83 c2 30             	add    $0x30,%edx
  80122d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80122f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801232:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801237:	f7 e9                	imul   %ecx
  801239:	c1 fa 02             	sar    $0x2,%edx
  80123c:	89 c8                	mov    %ecx,%eax
  80123e:	c1 f8 1f             	sar    $0x1f,%eax
  801241:	29 c2                	sub    %eax,%edx
  801243:	89 d0                	mov    %edx,%eax
  801245:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801248:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80124c:	75 bb                	jne    801209 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80124e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801255:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801258:	48                   	dec    %eax
  801259:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80125c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801260:	74 3d                	je     80129f <ltostr+0xc3>
		start = 1 ;
  801262:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801269:	eb 34                	jmp    80129f <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80126b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80126e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801271:	01 d0                	add    %edx,%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801278:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80127b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127e:	01 c2                	add    %eax,%edx
  801280:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801283:	8b 45 0c             	mov    0xc(%ebp),%eax
  801286:	01 c8                	add    %ecx,%eax
  801288:	8a 00                	mov    (%eax),%al
  80128a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80128c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80128f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801292:	01 c2                	add    %eax,%edx
  801294:	8a 45 eb             	mov    -0x15(%ebp),%al
  801297:	88 02                	mov    %al,(%edx)
		start++ ;
  801299:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80129c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80129f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012a5:	7c c4                	jl     80126b <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ad:	01 d0                	add    %edx,%eax
  8012af:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012b2:	90                   	nop
  8012b3:	c9                   	leave  
  8012b4:	c3                   	ret    

008012b5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012b5:	55                   	push   %ebp
  8012b6:	89 e5                	mov    %esp,%ebp
  8012b8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012bb:	ff 75 08             	pushl  0x8(%ebp)
  8012be:	e8 c4 f9 ff ff       	call   800c87 <strlen>
  8012c3:	83 c4 04             	add    $0x4,%esp
  8012c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012c9:	ff 75 0c             	pushl  0xc(%ebp)
  8012cc:	e8 b6 f9 ff ff       	call   800c87 <strlen>
  8012d1:	83 c4 04             	add    $0x4,%esp
  8012d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012e5:	eb 17                	jmp    8012fe <strcconcat+0x49>
		final[s] = str1[s] ;
  8012e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ed:	01 c2                	add    %eax,%edx
  8012ef:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	01 c8                	add    %ecx,%eax
  8012f7:	8a 00                	mov    (%eax),%al
  8012f9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012fb:	ff 45 fc             	incl   -0x4(%ebp)
  8012fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801301:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801304:	7c e1                	jl     8012e7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801306:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80130d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801314:	eb 1f                	jmp    801335 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801316:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801319:	8d 50 01             	lea    0x1(%eax),%edx
  80131c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80131f:	89 c2                	mov    %eax,%edx
  801321:	8b 45 10             	mov    0x10(%ebp),%eax
  801324:	01 c2                	add    %eax,%edx
  801326:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801329:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132c:	01 c8                	add    %ecx,%eax
  80132e:	8a 00                	mov    (%eax),%al
  801330:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801332:	ff 45 f8             	incl   -0x8(%ebp)
  801335:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801338:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80133b:	7c d9                	jl     801316 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80133d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801340:	8b 45 10             	mov    0x10(%ebp),%eax
  801343:	01 d0                	add    %edx,%eax
  801345:	c6 00 00             	movb   $0x0,(%eax)
}
  801348:	90                   	nop
  801349:	c9                   	leave  
  80134a:	c3                   	ret    

0080134b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80134e:	8b 45 14             	mov    0x14(%ebp),%eax
  801351:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801357:	8b 45 14             	mov    0x14(%ebp),%eax
  80135a:	8b 00                	mov    (%eax),%eax
  80135c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801363:	8b 45 10             	mov    0x10(%ebp),%eax
  801366:	01 d0                	add    %edx,%eax
  801368:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80136e:	eb 0c                	jmp    80137c <strsplit+0x31>
			*string++ = 0;
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8d 50 01             	lea    0x1(%eax),%edx
  801376:	89 55 08             	mov    %edx,0x8(%ebp)
  801379:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	8a 00                	mov    (%eax),%al
  801381:	84 c0                	test   %al,%al
  801383:	74 18                	je     80139d <strsplit+0x52>
  801385:	8b 45 08             	mov    0x8(%ebp),%eax
  801388:	8a 00                	mov    (%eax),%al
  80138a:	0f be c0             	movsbl %al,%eax
  80138d:	50                   	push   %eax
  80138e:	ff 75 0c             	pushl  0xc(%ebp)
  801391:	e8 83 fa ff ff       	call   800e19 <strchr>
  801396:	83 c4 08             	add    $0x8,%esp
  801399:	85 c0                	test   %eax,%eax
  80139b:	75 d3                	jne    801370 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80139d:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a0:	8a 00                	mov    (%eax),%al
  8013a2:	84 c0                	test   %al,%al
  8013a4:	74 5a                	je     801400 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a9:	8b 00                	mov    (%eax),%eax
  8013ab:	83 f8 0f             	cmp    $0xf,%eax
  8013ae:	75 07                	jne    8013b7 <strsplit+0x6c>
		{
			return 0;
  8013b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b5:	eb 66                	jmp    80141d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ba:	8b 00                	mov    (%eax),%eax
  8013bc:	8d 48 01             	lea    0x1(%eax),%ecx
  8013bf:	8b 55 14             	mov    0x14(%ebp),%edx
  8013c2:	89 0a                	mov    %ecx,(%edx)
  8013c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ce:	01 c2                	add    %eax,%edx
  8013d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013d5:	eb 03                	jmp    8013da <strsplit+0x8f>
			string++;
  8013d7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dd:	8a 00                	mov    (%eax),%al
  8013df:	84 c0                	test   %al,%al
  8013e1:	74 8b                	je     80136e <strsplit+0x23>
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	0f be c0             	movsbl %al,%eax
  8013eb:	50                   	push   %eax
  8013ec:	ff 75 0c             	pushl  0xc(%ebp)
  8013ef:	e8 25 fa ff ff       	call   800e19 <strchr>
  8013f4:	83 c4 08             	add    $0x8,%esp
  8013f7:	85 c0                	test   %eax,%eax
  8013f9:	74 dc                	je     8013d7 <strsplit+0x8c>
			string++;
	}
  8013fb:	e9 6e ff ff ff       	jmp    80136e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801400:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801401:	8b 45 14             	mov    0x14(%ebp),%eax
  801404:	8b 00                	mov    (%eax),%eax
  801406:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80140d:	8b 45 10             	mov    0x10(%ebp),%eax
  801410:	01 d0                	add    %edx,%eax
  801412:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801418:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80141d:	c9                   	leave  
  80141e:	c3                   	ret    

0080141f <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80142b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801432:	eb 4a                	jmp    80147e <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801434:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
  80143a:	01 c2                	add    %eax,%edx
  80143c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80143f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801442:	01 c8                	add    %ecx,%eax
  801444:	8a 00                	mov    (%eax),%al
  801446:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801448:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80144b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144e:	01 d0                	add    %edx,%eax
  801450:	8a 00                	mov    (%eax),%al
  801452:	3c 40                	cmp    $0x40,%al
  801454:	7e 25                	jle    80147b <str2lower+0x5c>
  801456:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801459:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145c:	01 d0                	add    %edx,%eax
  80145e:	8a 00                	mov    (%eax),%al
  801460:	3c 5a                	cmp    $0x5a,%al
  801462:	7f 17                	jg     80147b <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801464:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
  80146a:	01 d0                	add    %edx,%eax
  80146c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80146f:	8b 55 08             	mov    0x8(%ebp),%edx
  801472:	01 ca                	add    %ecx,%edx
  801474:	8a 12                	mov    (%edx),%dl
  801476:	83 c2 20             	add    $0x20,%edx
  801479:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80147b:	ff 45 fc             	incl   -0x4(%ebp)
  80147e:	ff 75 0c             	pushl  0xc(%ebp)
  801481:	e8 01 f8 ff ff       	call   800c87 <strlen>
  801486:	83 c4 04             	add    $0x4,%esp
  801489:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80148c:	7f a6                	jg     801434 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80148e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801491:	c9                   	leave  
  801492:	c3                   	ret    

00801493 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
  801496:	57                   	push   %edi
  801497:	56                   	push   %esi
  801498:	53                   	push   %ebx
  801499:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80149c:	8b 45 08             	mov    0x8(%ebp),%eax
  80149f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014a5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014a8:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014ab:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014ae:	cd 30                	int    $0x30
  8014b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8014b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014b6:	83 c4 10             	add    $0x10,%esp
  8014b9:	5b                   	pop    %ebx
  8014ba:	5e                   	pop    %esi
  8014bb:	5f                   	pop    %edi
  8014bc:	5d                   	pop    %ebp
  8014bd:	c3                   	ret    

008014be <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
  8014c1:	83 ec 04             	sub    $0x4,%esp
  8014c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8014ca:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014cd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	6a 00                	push   $0x0
  8014d6:	51                   	push   %ecx
  8014d7:	52                   	push   %edx
  8014d8:	ff 75 0c             	pushl  0xc(%ebp)
  8014db:	50                   	push   %eax
  8014dc:	6a 00                	push   $0x0
  8014de:	e8 b0 ff ff ff       	call   801493 <syscall>
  8014e3:	83 c4 18             	add    $0x18,%esp
}
  8014e6:	90                   	nop
  8014e7:	c9                   	leave  
  8014e8:	c3                   	ret    

008014e9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 02                	push   $0x2
  8014f8:	e8 96 ff ff ff       	call   801493 <syscall>
  8014fd:	83 c4 18             	add    $0x18,%esp
}
  801500:	c9                   	leave  
  801501:	c3                   	ret    

00801502 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 03                	push   $0x3
  801511:	e8 7d ff ff ff       	call   801493 <syscall>
  801516:	83 c4 18             	add    $0x18,%esp
}
  801519:	90                   	nop
  80151a:	c9                   	leave  
  80151b:	c3                   	ret    

0080151c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80151c:	55                   	push   %ebp
  80151d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80151f:	6a 00                	push   $0x0
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 04                	push   $0x4
  80152b:	e8 63 ff ff ff       	call   801493 <syscall>
  801530:	83 c4 18             	add    $0x18,%esp
}
  801533:	90                   	nop
  801534:	c9                   	leave  
  801535:	c3                   	ret    

00801536 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801539:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153c:	8b 45 08             	mov    0x8(%ebp),%eax
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	52                   	push   %edx
  801546:	50                   	push   %eax
  801547:	6a 08                	push   $0x8
  801549:	e8 45 ff ff ff       	call   801493 <syscall>
  80154e:	83 c4 18             	add    $0x18,%esp
}
  801551:	c9                   	leave  
  801552:	c3                   	ret    

00801553 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	56                   	push   %esi
  801557:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801558:	8b 75 18             	mov    0x18(%ebp),%esi
  80155b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80155e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801561:	8b 55 0c             	mov    0xc(%ebp),%edx
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	56                   	push   %esi
  801568:	53                   	push   %ebx
  801569:	51                   	push   %ecx
  80156a:	52                   	push   %edx
  80156b:	50                   	push   %eax
  80156c:	6a 09                	push   $0x9
  80156e:	e8 20 ff ff ff       	call   801493 <syscall>
  801573:	83 c4 18             	add    $0x18,%esp
}
  801576:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801579:	5b                   	pop    %ebx
  80157a:	5e                   	pop    %esi
  80157b:	5d                   	pop    %ebp
  80157c:	c3                   	ret    

0080157d <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	ff 75 08             	pushl  0x8(%ebp)
  80158b:	6a 0a                	push   $0xa
  80158d:	e8 01 ff ff ff       	call   801493 <syscall>
  801592:	83 c4 18             	add    $0x18,%esp
}
  801595:	c9                   	leave  
  801596:	c3                   	ret    

00801597 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	ff 75 0c             	pushl  0xc(%ebp)
  8015a3:	ff 75 08             	pushl  0x8(%ebp)
  8015a6:	6a 0b                	push   $0xb
  8015a8:	e8 e6 fe ff ff       	call   801493 <syscall>
  8015ad:	83 c4 18             	add    $0x18,%esp
}
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 0c                	push   $0xc
  8015c1:	e8 cd fe ff ff       	call   801493 <syscall>
  8015c6:	83 c4 18             	add    $0x18,%esp
}
  8015c9:	c9                   	leave  
  8015ca:	c3                   	ret    

008015cb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 0d                	push   $0xd
  8015da:	e8 b4 fe ff ff       	call   801493 <syscall>
  8015df:	83 c4 18             	add    $0x18,%esp
}
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 0e                	push   $0xe
  8015f3:	e8 9b fe ff ff       	call   801493 <syscall>
  8015f8:	83 c4 18             	add    $0x18,%esp
}
  8015fb:	c9                   	leave  
  8015fc:	c3                   	ret    

008015fd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 0f                	push   $0xf
  80160c:	e8 82 fe ff ff       	call   801493 <syscall>
  801611:	83 c4 18             	add    $0x18,%esp
}
  801614:	c9                   	leave  
  801615:	c3                   	ret    

00801616 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	ff 75 08             	pushl  0x8(%ebp)
  801624:	6a 10                	push   $0x10
  801626:	e8 68 fe ff ff       	call   801493 <syscall>
  80162b:	83 c4 18             	add    $0x18,%esp
}
  80162e:	c9                   	leave  
  80162f:	c3                   	ret    

00801630 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 11                	push   $0x11
  80163f:	e8 4f fe ff ff       	call   801493 <syscall>
  801644:	83 c4 18             	add    $0x18,%esp
}
  801647:	90                   	nop
  801648:	c9                   	leave  
  801649:	c3                   	ret    

0080164a <sys_cputc>:

void
sys_cputc(const char c)
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
  80164d:	83 ec 04             	sub    $0x4,%esp
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801656:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	50                   	push   %eax
  801663:	6a 01                	push   $0x1
  801665:	e8 29 fe ff ff       	call   801493 <syscall>
  80166a:	83 c4 18             	add    $0x18,%esp
}
  80166d:	90                   	nop
  80166e:	c9                   	leave  
  80166f:	c3                   	ret    

00801670 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 14                	push   $0x14
  80167f:	e8 0f fe ff ff       	call   801493 <syscall>
  801684:	83 c4 18             	add    $0x18,%esp
}
  801687:	90                   	nop
  801688:	c9                   	leave  
  801689:	c3                   	ret    

0080168a <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
  80168d:	83 ec 04             	sub    $0x4,%esp
  801690:	8b 45 10             	mov    0x10(%ebp),%eax
  801693:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801696:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801699:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	6a 00                	push   $0x0
  8016a2:	51                   	push   %ecx
  8016a3:	52                   	push   %edx
  8016a4:	ff 75 0c             	pushl  0xc(%ebp)
  8016a7:	50                   	push   %eax
  8016a8:	6a 15                	push   $0x15
  8016aa:	e8 e4 fd ff ff       	call   801493 <syscall>
  8016af:	83 c4 18             	add    $0x18,%esp
}
  8016b2:	c9                   	leave  
  8016b3:	c3                   	ret    

008016b4 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	52                   	push   %edx
  8016c4:	50                   	push   %eax
  8016c5:	6a 16                	push   $0x16
  8016c7:	e8 c7 fd ff ff       	call   801493 <syscall>
  8016cc:	83 c4 18             	add    $0x18,%esp
}
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	51                   	push   %ecx
  8016e2:	52                   	push   %edx
  8016e3:	50                   	push   %eax
  8016e4:	6a 17                	push   $0x17
  8016e6:	e8 a8 fd ff ff       	call   801493 <syscall>
  8016eb:	83 c4 18             	add    $0x18,%esp
}
  8016ee:	c9                   	leave  
  8016ef:	c3                   	ret    

008016f0 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	52                   	push   %edx
  801700:	50                   	push   %eax
  801701:	6a 18                	push   $0x18
  801703:	e8 8b fd ff ff       	call   801493 <syscall>
  801708:	83 c4 18             	add    $0x18,%esp
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801710:	8b 45 08             	mov    0x8(%ebp),%eax
  801713:	6a 00                	push   $0x0
  801715:	ff 75 14             	pushl  0x14(%ebp)
  801718:	ff 75 10             	pushl  0x10(%ebp)
  80171b:	ff 75 0c             	pushl  0xc(%ebp)
  80171e:	50                   	push   %eax
  80171f:	6a 19                	push   $0x19
  801721:	e8 6d fd ff ff       	call   801493 <syscall>
  801726:	83 c4 18             	add    $0x18,%esp
}
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <sys_run_env>:

void sys_run_env(int32 envId)
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80172e:	8b 45 08             	mov    0x8(%ebp),%eax
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	50                   	push   %eax
  80173a:	6a 1a                	push   $0x1a
  80173c:	e8 52 fd ff ff       	call   801493 <syscall>
  801741:	83 c4 18             	add    $0x18,%esp
}
  801744:	90                   	nop
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	50                   	push   %eax
  801756:	6a 1b                	push   $0x1b
  801758:	e8 36 fd ff ff       	call   801493 <syscall>
  80175d:	83 c4 18             	add    $0x18,%esp
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 05                	push   $0x5
  801771:	e8 1d fd ff ff       	call   801493 <syscall>
  801776:	83 c4 18             	add    $0x18,%esp
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 06                	push   $0x6
  80178a:	e8 04 fd ff ff       	call   801493 <syscall>
  80178f:	83 c4 18             	add    $0x18,%esp
}
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 07                	push   $0x7
  8017a3:	e8 eb fc ff ff       	call   801493 <syscall>
  8017a8:	83 c4 18             	add    $0x18,%esp
}
  8017ab:	c9                   	leave  
  8017ac:	c3                   	ret    

008017ad <sys_exit_env>:


void sys_exit_env(void)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 1c                	push   $0x1c
  8017bc:	e8 d2 fc ff ff       	call   801493 <syscall>
  8017c1:	83 c4 18             	add    $0x18,%esp
}
  8017c4:	90                   	nop
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017cd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017d0:	8d 50 04             	lea    0x4(%eax),%edx
  8017d3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	52                   	push   %edx
  8017dd:	50                   	push   %eax
  8017de:	6a 1d                	push   $0x1d
  8017e0:	e8 ae fc ff ff       	call   801493 <syscall>
  8017e5:	83 c4 18             	add    $0x18,%esp
	return result;
  8017e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017f1:	89 01                	mov    %eax,(%ecx)
  8017f3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f9:	c9                   	leave  
  8017fa:	c2 04 00             	ret    $0x4

008017fd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	ff 75 10             	pushl  0x10(%ebp)
  801807:	ff 75 0c             	pushl  0xc(%ebp)
  80180a:	ff 75 08             	pushl  0x8(%ebp)
  80180d:	6a 13                	push   $0x13
  80180f:	e8 7f fc ff ff       	call   801493 <syscall>
  801814:	83 c4 18             	add    $0x18,%esp
	return ;
  801817:	90                   	nop
}
  801818:	c9                   	leave  
  801819:	c3                   	ret    

0080181a <sys_rcr2>:
uint32 sys_rcr2()
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 1e                	push   $0x1e
  801829:	e8 65 fc ff ff       	call   801493 <syscall>
  80182e:	83 c4 18             	add    $0x18,%esp
}
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	83 ec 04             	sub    $0x4,%esp
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80183f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	50                   	push   %eax
  80184c:	6a 1f                	push   $0x1f
  80184e:	e8 40 fc ff ff       	call   801493 <syscall>
  801853:	83 c4 18             	add    $0x18,%esp
	return ;
  801856:	90                   	nop
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <rsttst>:
void rsttst()
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 21                	push   $0x21
  801868:	e8 26 fc ff ff       	call   801493 <syscall>
  80186d:	83 c4 18             	add    $0x18,%esp
	return ;
  801870:	90                   	nop
}
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
  801876:	83 ec 04             	sub    $0x4,%esp
  801879:	8b 45 14             	mov    0x14(%ebp),%eax
  80187c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80187f:	8b 55 18             	mov    0x18(%ebp),%edx
  801882:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801886:	52                   	push   %edx
  801887:	50                   	push   %eax
  801888:	ff 75 10             	pushl  0x10(%ebp)
  80188b:	ff 75 0c             	pushl  0xc(%ebp)
  80188e:	ff 75 08             	pushl  0x8(%ebp)
  801891:	6a 20                	push   $0x20
  801893:	e8 fb fb ff ff       	call   801493 <syscall>
  801898:	83 c4 18             	add    $0x18,%esp
	return ;
  80189b:	90                   	nop
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <chktst>:
void chktst(uint32 n)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	ff 75 08             	pushl  0x8(%ebp)
  8018ac:	6a 22                	push   $0x22
  8018ae:	e8 e0 fb ff ff       	call   801493 <syscall>
  8018b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b6:	90                   	nop
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <inctst>:

void inctst()
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 23                	push   $0x23
  8018c8:	e8 c6 fb ff ff       	call   801493 <syscall>
  8018cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d0:	90                   	nop
}
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <gettst>:
uint32 gettst()
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 24                	push   $0x24
  8018e2:	e8 ac fb ff ff       	call   801493 <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp
}
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    

008018ec <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 25                	push   $0x25
  8018fb:	e8 93 fb ff ff       	call   801493 <syscall>
  801900:	83 c4 18             	add    $0x18,%esp
  801903:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801908:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	ff 75 08             	pushl  0x8(%ebp)
  801925:	6a 26                	push   $0x26
  801927:	e8 67 fb ff ff       	call   801493 <syscall>
  80192c:	83 c4 18             	add    $0x18,%esp
	return ;
  80192f:	90                   	nop
}
  801930:	c9                   	leave  
  801931:	c3                   	ret    

00801932 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
  801935:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801936:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801939:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80193c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	6a 00                	push   $0x0
  801944:	53                   	push   %ebx
  801945:	51                   	push   %ecx
  801946:	52                   	push   %edx
  801947:	50                   	push   %eax
  801948:	6a 27                	push   $0x27
  80194a:	e8 44 fb ff ff       	call   801493 <syscall>
  80194f:	83 c4 18             	add    $0x18,%esp
}
  801952:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80195a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195d:	8b 45 08             	mov    0x8(%ebp),%eax
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	52                   	push   %edx
  801967:	50                   	push   %eax
  801968:	6a 28                	push   $0x28
  80196a:	e8 24 fb ff ff       	call   801493 <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801977:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80197a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	6a 00                	push   $0x0
  801982:	51                   	push   %ecx
  801983:	ff 75 10             	pushl  0x10(%ebp)
  801986:	52                   	push   %edx
  801987:	50                   	push   %eax
  801988:	6a 29                	push   $0x29
  80198a:	e8 04 fb ff ff       	call   801493 <syscall>
  80198f:	83 c4 18             	add    $0x18,%esp
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	ff 75 10             	pushl  0x10(%ebp)
  80199e:	ff 75 0c             	pushl  0xc(%ebp)
  8019a1:	ff 75 08             	pushl  0x8(%ebp)
  8019a4:	6a 12                	push   $0x12
  8019a6:	e8 e8 fa ff ff       	call   801493 <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ae:	90                   	nop
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8019b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	52                   	push   %edx
  8019c1:	50                   	push   %eax
  8019c2:	6a 2a                	push   $0x2a
  8019c4:	e8 ca fa ff ff       	call   801493 <syscall>
  8019c9:	83 c4 18             	add    $0x18,%esp
	return;
  8019cc:	90                   	nop
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 2b                	push   $0x2b
  8019de:	e8 b0 fa ff ff       	call   801493 <syscall>
  8019e3:	83 c4 18             	add    $0x18,%esp
}
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	ff 75 0c             	pushl  0xc(%ebp)
  8019f4:	ff 75 08             	pushl  0x8(%ebp)
  8019f7:	6a 2d                	push   $0x2d
  8019f9:	e8 95 fa ff ff       	call   801493 <syscall>
  8019fe:	83 c4 18             	add    $0x18,%esp
	return;
  801a01:	90                   	nop
}
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	ff 75 0c             	pushl  0xc(%ebp)
  801a10:	ff 75 08             	pushl  0x8(%ebp)
  801a13:	6a 2c                	push   $0x2c
  801a15:	e8 79 fa ff ff       	call   801493 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a1d:	90                   	nop
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801a26:	83 ec 04             	sub    $0x4,%esp
  801a29:	68 08 25 80 00       	push   $0x802508
  801a2e:	68 25 01 00 00       	push   $0x125
  801a33:	68 3b 25 80 00       	push   $0x80253b
  801a38:	e8 a3 e8 ff ff       	call   8002e0 <_panic>

00801a3d <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
  801a40:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  801a43:	83 ec 04             	sub    $0x4,%esp
  801a46:	68 4c 25 80 00       	push   $0x80254c
  801a4b:	6a 07                	push   $0x7
  801a4d:	68 7b 25 80 00       	push   $0x80257b
  801a52:	e8 89 e8 ff ff       	call   8002e0 <_panic>

00801a57 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  801a5d:	83 ec 04             	sub    $0x4,%esp
  801a60:	68 8c 25 80 00       	push   $0x80258c
  801a65:	6a 0b                	push   $0xb
  801a67:	68 7b 25 80 00       	push   $0x80257b
  801a6c:	e8 6f e8 ff ff       	call   8002e0 <_panic>

00801a71 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  801a77:	83 ec 04             	sub    $0x4,%esp
  801a7a:	68 b8 25 80 00       	push   $0x8025b8
  801a7f:	6a 10                	push   $0x10
  801a81:	68 7b 25 80 00       	push   $0x80257b
  801a86:	e8 55 e8 ff ff       	call   8002e0 <_panic>

00801a8b <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  801a91:	83 ec 04             	sub    $0x4,%esp
  801a94:	68 e8 25 80 00       	push   $0x8025e8
  801a99:	6a 15                	push   $0x15
  801a9b:	68 7b 25 80 00       	push   $0x80257b
  801aa0:	e8 3b e8 ff ff       	call   8002e0 <_panic>

00801aa5 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aab:	8b 40 10             	mov    0x10(%eax),%eax
}
  801aae:	5d                   	pop    %ebp
  801aaf:	c3                   	ret    

00801ab0 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801ab6:	8b 55 08             	mov    0x8(%ebp),%edx
  801ab9:	89 d0                	mov    %edx,%eax
  801abb:	c1 e0 02             	shl    $0x2,%eax
  801abe:	01 d0                	add    %edx,%eax
  801ac0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ac7:	01 d0                	add    %edx,%eax
  801ac9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ad0:	01 d0                	add    %edx,%eax
  801ad2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ad9:	01 d0                	add    %edx,%eax
  801adb:	c1 e0 04             	shl    $0x4,%eax
  801ade:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801ae1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801ae8:	0f 31                	rdtsc  
  801aea:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801aed:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801af0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801af3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801af6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801af9:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801afc:	eb 46                	jmp    801b44 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801afe:	0f 31                	rdtsc  
  801b00:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801b03:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801b06:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b09:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801b0c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801b0f:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801b12:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b18:	29 c2                	sub    %eax,%edx
  801b1a:	89 d0                	mov    %edx,%eax
  801b1c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801b1f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b25:	89 d1                	mov    %edx,%ecx
  801b27:	29 c1                	sub    %eax,%ecx
  801b29:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b2f:	39 c2                	cmp    %eax,%edx
  801b31:	0f 97 c0             	seta   %al
  801b34:	0f b6 c0             	movzbl %al,%eax
  801b37:	29 c1                	sub    %eax,%ecx
  801b39:	89 c8                	mov    %ecx,%eax
  801b3b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801b3e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801b44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b47:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b4a:	72 b2                	jb     801afe <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801b4c:	90                   	nop
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801b55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801b5c:	eb 03                	jmp    801b61 <busy_wait+0x12>
  801b5e:	ff 45 fc             	incl   -0x4(%ebp)
  801b61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b64:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b67:	72 f5                	jb     801b5e <busy_wait+0xf>
	return i;
  801b69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    
  801b6e:	66 90                	xchg   %ax,%ax

00801b70 <__udivdi3>:
  801b70:	55                   	push   %ebp
  801b71:	57                   	push   %edi
  801b72:	56                   	push   %esi
  801b73:	53                   	push   %ebx
  801b74:	83 ec 1c             	sub    $0x1c,%esp
  801b77:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b7b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b83:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b87:	89 ca                	mov    %ecx,%edx
  801b89:	89 f8                	mov    %edi,%eax
  801b8b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b8f:	85 f6                	test   %esi,%esi
  801b91:	75 2d                	jne    801bc0 <__udivdi3+0x50>
  801b93:	39 cf                	cmp    %ecx,%edi
  801b95:	77 65                	ja     801bfc <__udivdi3+0x8c>
  801b97:	89 fd                	mov    %edi,%ebp
  801b99:	85 ff                	test   %edi,%edi
  801b9b:	75 0b                	jne    801ba8 <__udivdi3+0x38>
  801b9d:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba2:	31 d2                	xor    %edx,%edx
  801ba4:	f7 f7                	div    %edi
  801ba6:	89 c5                	mov    %eax,%ebp
  801ba8:	31 d2                	xor    %edx,%edx
  801baa:	89 c8                	mov    %ecx,%eax
  801bac:	f7 f5                	div    %ebp
  801bae:	89 c1                	mov    %eax,%ecx
  801bb0:	89 d8                	mov    %ebx,%eax
  801bb2:	f7 f5                	div    %ebp
  801bb4:	89 cf                	mov    %ecx,%edi
  801bb6:	89 fa                	mov    %edi,%edx
  801bb8:	83 c4 1c             	add    $0x1c,%esp
  801bbb:	5b                   	pop    %ebx
  801bbc:	5e                   	pop    %esi
  801bbd:	5f                   	pop    %edi
  801bbe:	5d                   	pop    %ebp
  801bbf:	c3                   	ret    
  801bc0:	39 ce                	cmp    %ecx,%esi
  801bc2:	77 28                	ja     801bec <__udivdi3+0x7c>
  801bc4:	0f bd fe             	bsr    %esi,%edi
  801bc7:	83 f7 1f             	xor    $0x1f,%edi
  801bca:	75 40                	jne    801c0c <__udivdi3+0x9c>
  801bcc:	39 ce                	cmp    %ecx,%esi
  801bce:	72 0a                	jb     801bda <__udivdi3+0x6a>
  801bd0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bd4:	0f 87 9e 00 00 00    	ja     801c78 <__udivdi3+0x108>
  801bda:	b8 01 00 00 00       	mov    $0x1,%eax
  801bdf:	89 fa                	mov    %edi,%edx
  801be1:	83 c4 1c             	add    $0x1c,%esp
  801be4:	5b                   	pop    %ebx
  801be5:	5e                   	pop    %esi
  801be6:	5f                   	pop    %edi
  801be7:	5d                   	pop    %ebp
  801be8:	c3                   	ret    
  801be9:	8d 76 00             	lea    0x0(%esi),%esi
  801bec:	31 ff                	xor    %edi,%edi
  801bee:	31 c0                	xor    %eax,%eax
  801bf0:	89 fa                	mov    %edi,%edx
  801bf2:	83 c4 1c             	add    $0x1c,%esp
  801bf5:	5b                   	pop    %ebx
  801bf6:	5e                   	pop    %esi
  801bf7:	5f                   	pop    %edi
  801bf8:	5d                   	pop    %ebp
  801bf9:	c3                   	ret    
  801bfa:	66 90                	xchg   %ax,%ax
  801bfc:	89 d8                	mov    %ebx,%eax
  801bfe:	f7 f7                	div    %edi
  801c00:	31 ff                	xor    %edi,%edi
  801c02:	89 fa                	mov    %edi,%edx
  801c04:	83 c4 1c             	add    $0x1c,%esp
  801c07:	5b                   	pop    %ebx
  801c08:	5e                   	pop    %esi
  801c09:	5f                   	pop    %edi
  801c0a:	5d                   	pop    %ebp
  801c0b:	c3                   	ret    
  801c0c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c11:	89 eb                	mov    %ebp,%ebx
  801c13:	29 fb                	sub    %edi,%ebx
  801c15:	89 f9                	mov    %edi,%ecx
  801c17:	d3 e6                	shl    %cl,%esi
  801c19:	89 c5                	mov    %eax,%ebp
  801c1b:	88 d9                	mov    %bl,%cl
  801c1d:	d3 ed                	shr    %cl,%ebp
  801c1f:	89 e9                	mov    %ebp,%ecx
  801c21:	09 f1                	or     %esi,%ecx
  801c23:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c27:	89 f9                	mov    %edi,%ecx
  801c29:	d3 e0                	shl    %cl,%eax
  801c2b:	89 c5                	mov    %eax,%ebp
  801c2d:	89 d6                	mov    %edx,%esi
  801c2f:	88 d9                	mov    %bl,%cl
  801c31:	d3 ee                	shr    %cl,%esi
  801c33:	89 f9                	mov    %edi,%ecx
  801c35:	d3 e2                	shl    %cl,%edx
  801c37:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c3b:	88 d9                	mov    %bl,%cl
  801c3d:	d3 e8                	shr    %cl,%eax
  801c3f:	09 c2                	or     %eax,%edx
  801c41:	89 d0                	mov    %edx,%eax
  801c43:	89 f2                	mov    %esi,%edx
  801c45:	f7 74 24 0c          	divl   0xc(%esp)
  801c49:	89 d6                	mov    %edx,%esi
  801c4b:	89 c3                	mov    %eax,%ebx
  801c4d:	f7 e5                	mul    %ebp
  801c4f:	39 d6                	cmp    %edx,%esi
  801c51:	72 19                	jb     801c6c <__udivdi3+0xfc>
  801c53:	74 0b                	je     801c60 <__udivdi3+0xf0>
  801c55:	89 d8                	mov    %ebx,%eax
  801c57:	31 ff                	xor    %edi,%edi
  801c59:	e9 58 ff ff ff       	jmp    801bb6 <__udivdi3+0x46>
  801c5e:	66 90                	xchg   %ax,%ax
  801c60:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c64:	89 f9                	mov    %edi,%ecx
  801c66:	d3 e2                	shl    %cl,%edx
  801c68:	39 c2                	cmp    %eax,%edx
  801c6a:	73 e9                	jae    801c55 <__udivdi3+0xe5>
  801c6c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c6f:	31 ff                	xor    %edi,%edi
  801c71:	e9 40 ff ff ff       	jmp    801bb6 <__udivdi3+0x46>
  801c76:	66 90                	xchg   %ax,%ax
  801c78:	31 c0                	xor    %eax,%eax
  801c7a:	e9 37 ff ff ff       	jmp    801bb6 <__udivdi3+0x46>
  801c7f:	90                   	nop

00801c80 <__umoddi3>:
  801c80:	55                   	push   %ebp
  801c81:	57                   	push   %edi
  801c82:	56                   	push   %esi
  801c83:	53                   	push   %ebx
  801c84:	83 ec 1c             	sub    $0x1c,%esp
  801c87:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c8b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c8f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c93:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c97:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c9b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c9f:	89 f3                	mov    %esi,%ebx
  801ca1:	89 fa                	mov    %edi,%edx
  801ca3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ca7:	89 34 24             	mov    %esi,(%esp)
  801caa:	85 c0                	test   %eax,%eax
  801cac:	75 1a                	jne    801cc8 <__umoddi3+0x48>
  801cae:	39 f7                	cmp    %esi,%edi
  801cb0:	0f 86 a2 00 00 00    	jbe    801d58 <__umoddi3+0xd8>
  801cb6:	89 c8                	mov    %ecx,%eax
  801cb8:	89 f2                	mov    %esi,%edx
  801cba:	f7 f7                	div    %edi
  801cbc:	89 d0                	mov    %edx,%eax
  801cbe:	31 d2                	xor    %edx,%edx
  801cc0:	83 c4 1c             	add    $0x1c,%esp
  801cc3:	5b                   	pop    %ebx
  801cc4:	5e                   	pop    %esi
  801cc5:	5f                   	pop    %edi
  801cc6:	5d                   	pop    %ebp
  801cc7:	c3                   	ret    
  801cc8:	39 f0                	cmp    %esi,%eax
  801cca:	0f 87 ac 00 00 00    	ja     801d7c <__umoddi3+0xfc>
  801cd0:	0f bd e8             	bsr    %eax,%ebp
  801cd3:	83 f5 1f             	xor    $0x1f,%ebp
  801cd6:	0f 84 ac 00 00 00    	je     801d88 <__umoddi3+0x108>
  801cdc:	bf 20 00 00 00       	mov    $0x20,%edi
  801ce1:	29 ef                	sub    %ebp,%edi
  801ce3:	89 fe                	mov    %edi,%esi
  801ce5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ce9:	89 e9                	mov    %ebp,%ecx
  801ceb:	d3 e0                	shl    %cl,%eax
  801ced:	89 d7                	mov    %edx,%edi
  801cef:	89 f1                	mov    %esi,%ecx
  801cf1:	d3 ef                	shr    %cl,%edi
  801cf3:	09 c7                	or     %eax,%edi
  801cf5:	89 e9                	mov    %ebp,%ecx
  801cf7:	d3 e2                	shl    %cl,%edx
  801cf9:	89 14 24             	mov    %edx,(%esp)
  801cfc:	89 d8                	mov    %ebx,%eax
  801cfe:	d3 e0                	shl    %cl,%eax
  801d00:	89 c2                	mov    %eax,%edx
  801d02:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d06:	d3 e0                	shl    %cl,%eax
  801d08:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d0c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d10:	89 f1                	mov    %esi,%ecx
  801d12:	d3 e8                	shr    %cl,%eax
  801d14:	09 d0                	or     %edx,%eax
  801d16:	d3 eb                	shr    %cl,%ebx
  801d18:	89 da                	mov    %ebx,%edx
  801d1a:	f7 f7                	div    %edi
  801d1c:	89 d3                	mov    %edx,%ebx
  801d1e:	f7 24 24             	mull   (%esp)
  801d21:	89 c6                	mov    %eax,%esi
  801d23:	89 d1                	mov    %edx,%ecx
  801d25:	39 d3                	cmp    %edx,%ebx
  801d27:	0f 82 87 00 00 00    	jb     801db4 <__umoddi3+0x134>
  801d2d:	0f 84 91 00 00 00    	je     801dc4 <__umoddi3+0x144>
  801d33:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d37:	29 f2                	sub    %esi,%edx
  801d39:	19 cb                	sbb    %ecx,%ebx
  801d3b:	89 d8                	mov    %ebx,%eax
  801d3d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d41:	d3 e0                	shl    %cl,%eax
  801d43:	89 e9                	mov    %ebp,%ecx
  801d45:	d3 ea                	shr    %cl,%edx
  801d47:	09 d0                	or     %edx,%eax
  801d49:	89 e9                	mov    %ebp,%ecx
  801d4b:	d3 eb                	shr    %cl,%ebx
  801d4d:	89 da                	mov    %ebx,%edx
  801d4f:	83 c4 1c             	add    $0x1c,%esp
  801d52:	5b                   	pop    %ebx
  801d53:	5e                   	pop    %esi
  801d54:	5f                   	pop    %edi
  801d55:	5d                   	pop    %ebp
  801d56:	c3                   	ret    
  801d57:	90                   	nop
  801d58:	89 fd                	mov    %edi,%ebp
  801d5a:	85 ff                	test   %edi,%edi
  801d5c:	75 0b                	jne    801d69 <__umoddi3+0xe9>
  801d5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d63:	31 d2                	xor    %edx,%edx
  801d65:	f7 f7                	div    %edi
  801d67:	89 c5                	mov    %eax,%ebp
  801d69:	89 f0                	mov    %esi,%eax
  801d6b:	31 d2                	xor    %edx,%edx
  801d6d:	f7 f5                	div    %ebp
  801d6f:	89 c8                	mov    %ecx,%eax
  801d71:	f7 f5                	div    %ebp
  801d73:	89 d0                	mov    %edx,%eax
  801d75:	e9 44 ff ff ff       	jmp    801cbe <__umoddi3+0x3e>
  801d7a:	66 90                	xchg   %ax,%ax
  801d7c:	89 c8                	mov    %ecx,%eax
  801d7e:	89 f2                	mov    %esi,%edx
  801d80:	83 c4 1c             	add    $0x1c,%esp
  801d83:	5b                   	pop    %ebx
  801d84:	5e                   	pop    %esi
  801d85:	5f                   	pop    %edi
  801d86:	5d                   	pop    %ebp
  801d87:	c3                   	ret    
  801d88:	3b 04 24             	cmp    (%esp),%eax
  801d8b:	72 06                	jb     801d93 <__umoddi3+0x113>
  801d8d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d91:	77 0f                	ja     801da2 <__umoddi3+0x122>
  801d93:	89 f2                	mov    %esi,%edx
  801d95:	29 f9                	sub    %edi,%ecx
  801d97:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d9b:	89 14 24             	mov    %edx,(%esp)
  801d9e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801da2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801da6:	8b 14 24             	mov    (%esp),%edx
  801da9:	83 c4 1c             	add    $0x1c,%esp
  801dac:	5b                   	pop    %ebx
  801dad:	5e                   	pop    %esi
  801dae:	5f                   	pop    %edi
  801daf:	5d                   	pop    %ebp
  801db0:	c3                   	ret    
  801db1:	8d 76 00             	lea    0x0(%esi),%esi
  801db4:	2b 04 24             	sub    (%esp),%eax
  801db7:	19 fa                	sbb    %edi,%edx
  801db9:	89 d1                	mov    %edx,%ecx
  801dbb:	89 c6                	mov    %eax,%esi
  801dbd:	e9 71 ff ff ff       	jmp    801d33 <__umoddi3+0xb3>
  801dc2:	66 90                	xchg   %ax,%ax
  801dc4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801dc8:	72 ea                	jb     801db4 <__umoddi3+0x134>
  801dca:	89 d9                	mov    %ebx,%ecx
  801dcc:	e9 62 ff ff ff       	jmp    801d33 <__umoddi3+0xb3>

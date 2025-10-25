
obj/user/concurrent_start:     file format elf32-i386


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
  800031:	e8 f9 00 00 00       	call   80012f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// hello, world
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	char *str ;
	sys_create_shared_object("cnc1", 512, 1, (void*) &str);
  80003e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800041:	50                   	push   %eax
  800042:	6a 01                	push   $0x1
  800044:	68 00 02 00 00       	push   $0x200
  800049:	68 20 1d 80 00       	push   $0x801d20
  80004e:	e8 36 16 00 00       	call   801689 <sys_create_shared_object>
  800053:	83 c4 10             	add    $0x10,%esp

	struct semaphore cnc1 = create_semaphore("cnc1", 1);
  800056:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	6a 01                	push   $0x1
  80005e:	68 20 1d 80 00       	push   $0x801d20
  800063:	50                   	push   %eax
  800064:	e8 d3 19 00 00       	call   801a3c <create_semaphore>
  800069:	83 c4 0c             	add    $0xc,%esp
	struct semaphore depend1 = create_semaphore("depend1", 0);
  80006c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80006f:	83 ec 04             	sub    $0x4,%esp
  800072:	6a 00                	push   $0x0
  800074:	68 25 1d 80 00       	push   $0x801d25
  800079:	50                   	push   %eax
  80007a:	e8 bd 19 00 00       	call   801a3c <create_semaphore>
  80007f:	83 c4 0c             	add    $0xc,%esp

	uint32 id1, id2;
	id2 = sys_create_env("qs2", (myEnv->page_WS_max_size), (myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800082:	a1 20 30 80 00       	mov    0x803020,%eax
  800087:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  80008d:	a1 20 30 80 00       	mov    0x803020,%eax
  800092:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800098:	89 c1                	mov    %eax,%ecx
  80009a:	a1 20 30 80 00       	mov    0x803020,%eax
  80009f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000a5:	52                   	push   %edx
  8000a6:	51                   	push   %ecx
  8000a7:	50                   	push   %eax
  8000a8:	68 2d 1d 80 00       	push   $0x801d2d
  8000ad:	e8 5a 16 00 00       	call   80170c <sys_create_env>
  8000b2:	83 c4 10             	add    $0x10,%esp
  8000b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	id1 = sys_create_env("qs1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8000bd:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8000c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8000c8:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8000ce:	89 c1                	mov    %eax,%ecx
  8000d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d5:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000db:	52                   	push   %edx
  8000dc:	51                   	push   %ecx
  8000dd:	50                   	push   %eax
  8000de:	68 31 1d 80 00       	push   $0x801d31
  8000e3:	e8 24 16 00 00       	call   80170c <sys_create_env>
  8000e8:	83 c4 10             	add    $0x10,%esp
  8000eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (id1 == E_ENV_CREATION_ERROR || id2 == E_ENV_CREATION_ERROR)
  8000ee:	83 7d f0 ef          	cmpl   $0xffffffef,-0x10(%ebp)
  8000f2:	74 06                	je     8000fa <_main+0xc2>
  8000f4:	83 7d f4 ef          	cmpl   $0xffffffef,-0xc(%ebp)
  8000f8:	75 14                	jne    80010e <_main+0xd6>
		panic("NO AVAILABLE ENVs...");
  8000fa:	83 ec 04             	sub    $0x4,%esp
  8000fd:	68 35 1d 80 00       	push   $0x801d35
  800102:	6a 11                	push   $0x11
  800104:	68 4a 1d 80 00       	push   $0x801d4a
  800109:	e8 d1 01 00 00       	call   8002df <_panic>

	sys_run_env(id2);
  80010e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	50                   	push   %eax
  800115:	e8 10 16 00 00       	call   80172a <sys_run_env>
  80011a:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id1);
  80011d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	50                   	push   %eax
  800124:	e8 01 16 00 00       	call   80172a <sys_run_env>
  800129:	83 c4 10             	add    $0x10,%esp

	return;
  80012c:	90                   	nop
}
  80012d:	c9                   	leave  
  80012e:	c3                   	ret    

0080012f <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	57                   	push   %edi
  800133:	56                   	push   %esi
  800134:	53                   	push   %ebx
  800135:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800138:	e8 3d 16 00 00       	call   80177a <sys_getenvindex>
  80013d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800140:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800143:	89 d0                	mov    %edx,%eax
  800145:	c1 e0 02             	shl    $0x2,%eax
  800148:	01 d0                	add    %edx,%eax
  80014a:	c1 e0 03             	shl    $0x3,%eax
  80014d:	01 d0                	add    %edx,%eax
  80014f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800156:	01 d0                	add    %edx,%eax
  800158:	c1 e0 02             	shl    $0x2,%eax
  80015b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800160:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800165:	a1 20 30 80 00       	mov    0x803020,%eax
  80016a:	8a 40 20             	mov    0x20(%eax),%al
  80016d:	84 c0                	test   %al,%al
  80016f:	74 0d                	je     80017e <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800171:	a1 20 30 80 00       	mov    0x803020,%eax
  800176:	83 c0 20             	add    $0x20,%eax
  800179:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80017e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800182:	7e 0a                	jle    80018e <libmain+0x5f>
		binaryname = argv[0];
  800184:	8b 45 0c             	mov    0xc(%ebp),%eax
  800187:	8b 00                	mov    (%eax),%eax
  800189:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80018e:	83 ec 08             	sub    $0x8,%esp
  800191:	ff 75 0c             	pushl  0xc(%ebp)
  800194:	ff 75 08             	pushl  0x8(%ebp)
  800197:	e8 9c fe ff ff       	call   800038 <_main>
  80019c:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80019f:	a1 00 30 80 00       	mov    0x803000,%eax
  8001a4:	85 c0                	test   %eax,%eax
  8001a6:	0f 84 01 01 00 00    	je     8002ad <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001ac:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001b2:	bb 5c 1e 80 00       	mov    $0x801e5c,%ebx
  8001b7:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001bc:	89 c7                	mov    %eax,%edi
  8001be:	89 de                	mov    %ebx,%esi
  8001c0:	89 d1                	mov    %edx,%ecx
  8001c2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001c4:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001c7:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001cc:	b0 00                	mov    $0x0,%al
  8001ce:	89 d7                	mov    %edx,%edi
  8001d0:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001d2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001d9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001dc:	83 ec 08             	sub    $0x8,%esp
  8001df:	50                   	push   %eax
  8001e0:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001e6:	50                   	push   %eax
  8001e7:	e8 c4 17 00 00       	call   8019b0 <sys_utilities>
  8001ec:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001ef:	e8 0d 13 00 00       	call   801501 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	68 7c 1d 80 00       	push   $0x801d7c
  8001fc:	e8 ac 03 00 00       	call   8005ad <cprintf>
  800201:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800204:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800207:	85 c0                	test   %eax,%eax
  800209:	74 18                	je     800223 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80020b:	e8 be 17 00 00       	call   8019ce <sys_get_optimal_num_faults>
  800210:	83 ec 08             	sub    $0x8,%esp
  800213:	50                   	push   %eax
  800214:	68 a4 1d 80 00       	push   $0x801da4
  800219:	e8 8f 03 00 00       	call   8005ad <cprintf>
  80021e:	83 c4 10             	add    $0x10,%esp
  800221:	eb 59                	jmp    80027c <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800223:	a1 20 30 80 00       	mov    0x803020,%eax
  800228:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80022e:	a1 20 30 80 00       	mov    0x803020,%eax
  800233:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800239:	83 ec 04             	sub    $0x4,%esp
  80023c:	52                   	push   %edx
  80023d:	50                   	push   %eax
  80023e:	68 c8 1d 80 00       	push   $0x801dc8
  800243:	e8 65 03 00 00       	call   8005ad <cprintf>
  800248:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80024b:	a1 20 30 80 00       	mov    0x803020,%eax
  800250:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800256:	a1 20 30 80 00       	mov    0x803020,%eax
  80025b:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800261:	a1 20 30 80 00       	mov    0x803020,%eax
  800266:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80026c:	51                   	push   %ecx
  80026d:	52                   	push   %edx
  80026e:	50                   	push   %eax
  80026f:	68 f0 1d 80 00       	push   $0x801df0
  800274:	e8 34 03 00 00       	call   8005ad <cprintf>
  800279:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80027c:	a1 20 30 80 00       	mov    0x803020,%eax
  800281:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800287:	83 ec 08             	sub    $0x8,%esp
  80028a:	50                   	push   %eax
  80028b:	68 48 1e 80 00       	push   $0x801e48
  800290:	e8 18 03 00 00       	call   8005ad <cprintf>
  800295:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	68 7c 1d 80 00       	push   $0x801d7c
  8002a0:	e8 08 03 00 00       	call   8005ad <cprintf>
  8002a5:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002a8:	e8 6e 12 00 00       	call   80151b <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002ad:	e8 1f 00 00 00       	call   8002d1 <exit>
}
  8002b2:	90                   	nop
  8002b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b6:	5b                   	pop    %ebx
  8002b7:	5e                   	pop    %esi
  8002b8:	5f                   	pop    %edi
  8002b9:	5d                   	pop    %ebp
  8002ba:	c3                   	ret    

008002bb <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002bb:	55                   	push   %ebp
  8002bc:	89 e5                	mov    %esp,%ebp
  8002be:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002c1:	83 ec 0c             	sub    $0xc,%esp
  8002c4:	6a 00                	push   $0x0
  8002c6:	e8 7b 14 00 00       	call   801746 <sys_destroy_env>
  8002cb:	83 c4 10             	add    $0x10,%esp
}
  8002ce:	90                   	nop
  8002cf:	c9                   	leave  
  8002d0:	c3                   	ret    

008002d1 <exit>:

void
exit(void)
{
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002d7:	e8 d0 14 00 00       	call   8017ac <sys_exit_env>
}
  8002dc:	90                   	nop
  8002dd:	c9                   	leave  
  8002de:	c3                   	ret    

008002df <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002df:	55                   	push   %ebp
  8002e0:	89 e5                	mov    %esp,%ebp
  8002e2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002e5:	8d 45 10             	lea    0x10(%ebp),%eax
  8002e8:	83 c0 04             	add    $0x4,%eax
  8002eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002ee:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002f3:	85 c0                	test   %eax,%eax
  8002f5:	74 16                	je     80030d <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002f7:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002fc:	83 ec 08             	sub    $0x8,%esp
  8002ff:	50                   	push   %eax
  800300:	68 c0 1e 80 00       	push   $0x801ec0
  800305:	e8 a3 02 00 00       	call   8005ad <cprintf>
  80030a:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80030d:	a1 04 30 80 00       	mov    0x803004,%eax
  800312:	83 ec 0c             	sub    $0xc,%esp
  800315:	ff 75 0c             	pushl  0xc(%ebp)
  800318:	ff 75 08             	pushl  0x8(%ebp)
  80031b:	50                   	push   %eax
  80031c:	68 c8 1e 80 00       	push   $0x801ec8
  800321:	6a 74                	push   $0x74
  800323:	e8 b2 02 00 00       	call   8005da <cprintf_colored>
  800328:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80032b:	8b 45 10             	mov    0x10(%ebp),%eax
  80032e:	83 ec 08             	sub    $0x8,%esp
  800331:	ff 75 f4             	pushl  -0xc(%ebp)
  800334:	50                   	push   %eax
  800335:	e8 04 02 00 00       	call   80053e <vcprintf>
  80033a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80033d:	83 ec 08             	sub    $0x8,%esp
  800340:	6a 00                	push   $0x0
  800342:	68 f0 1e 80 00       	push   $0x801ef0
  800347:	e8 f2 01 00 00       	call   80053e <vcprintf>
  80034c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80034f:	e8 7d ff ff ff       	call   8002d1 <exit>

	// should not return here
	while (1) ;
  800354:	eb fe                	jmp    800354 <_panic+0x75>

00800356 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
  800359:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80035c:	a1 20 30 80 00       	mov    0x803020,%eax
  800361:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800367:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036a:	39 c2                	cmp    %eax,%edx
  80036c:	74 14                	je     800382 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80036e:	83 ec 04             	sub    $0x4,%esp
  800371:	68 f4 1e 80 00       	push   $0x801ef4
  800376:	6a 26                	push   $0x26
  800378:	68 40 1f 80 00       	push   $0x801f40
  80037d:	e8 5d ff ff ff       	call   8002df <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800382:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800389:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800390:	e9 c5 00 00 00       	jmp    80045a <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800398:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80039f:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a2:	01 d0                	add    %edx,%eax
  8003a4:	8b 00                	mov    (%eax),%eax
  8003a6:	85 c0                	test   %eax,%eax
  8003a8:	75 08                	jne    8003b2 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003aa:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003ad:	e9 a5 00 00 00       	jmp    800457 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003b2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003b9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003c0:	eb 69                	jmp    80042b <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003c2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c7:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003cd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d0:	89 d0                	mov    %edx,%eax
  8003d2:	01 c0                	add    %eax,%eax
  8003d4:	01 d0                	add    %edx,%eax
  8003d6:	c1 e0 03             	shl    $0x3,%eax
  8003d9:	01 c8                	add    %ecx,%eax
  8003db:	8a 40 04             	mov    0x4(%eax),%al
  8003de:	84 c0                	test   %al,%al
  8003e0:	75 46                	jne    800428 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003e2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e7:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003ed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003f0:	89 d0                	mov    %edx,%eax
  8003f2:	01 c0                	add    %eax,%eax
  8003f4:	01 d0                	add    %edx,%eax
  8003f6:	c1 e0 03             	shl    $0x3,%eax
  8003f9:	01 c8                	add    %ecx,%eax
  8003fb:	8b 00                	mov    (%eax),%eax
  8003fd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800400:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800403:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800408:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80040a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80040d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	01 c8                	add    %ecx,%eax
  800419:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80041b:	39 c2                	cmp    %eax,%edx
  80041d:	75 09                	jne    800428 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80041f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800426:	eb 15                	jmp    80043d <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800428:	ff 45 e8             	incl   -0x18(%ebp)
  80042b:	a1 20 30 80 00       	mov    0x803020,%eax
  800430:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800436:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800439:	39 c2                	cmp    %eax,%edx
  80043b:	77 85                	ja     8003c2 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80043d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800441:	75 14                	jne    800457 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800443:	83 ec 04             	sub    $0x4,%esp
  800446:	68 4c 1f 80 00       	push   $0x801f4c
  80044b:	6a 3a                	push   $0x3a
  80044d:	68 40 1f 80 00       	push   $0x801f40
  800452:	e8 88 fe ff ff       	call   8002df <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800457:	ff 45 f0             	incl   -0x10(%ebp)
  80045a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80045d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800460:	0f 8c 2f ff ff ff    	jl     800395 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800466:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800474:	eb 26                	jmp    80049c <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800476:	a1 20 30 80 00       	mov    0x803020,%eax
  80047b:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800481:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800484:	89 d0                	mov    %edx,%eax
  800486:	01 c0                	add    %eax,%eax
  800488:	01 d0                	add    %edx,%eax
  80048a:	c1 e0 03             	shl    $0x3,%eax
  80048d:	01 c8                	add    %ecx,%eax
  80048f:	8a 40 04             	mov    0x4(%eax),%al
  800492:	3c 01                	cmp    $0x1,%al
  800494:	75 03                	jne    800499 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800496:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800499:	ff 45 e0             	incl   -0x20(%ebp)
  80049c:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004aa:	39 c2                	cmp    %eax,%edx
  8004ac:	77 c8                	ja     800476 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004b1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004b4:	74 14                	je     8004ca <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004b6:	83 ec 04             	sub    $0x4,%esp
  8004b9:	68 a0 1f 80 00       	push   $0x801fa0
  8004be:	6a 44                	push   $0x44
  8004c0:	68 40 1f 80 00       	push   $0x801f40
  8004c5:	e8 15 fe ff ff       	call   8002df <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004ca:	90                   	nop
  8004cb:	c9                   	leave  
  8004cc:	c3                   	ret    

008004cd <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004cd:	55                   	push   %ebp
  8004ce:	89 e5                	mov    %esp,%ebp
  8004d0:	53                   	push   %ebx
  8004d1:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	8d 48 01             	lea    0x1(%eax),%ecx
  8004dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004df:	89 0a                	mov    %ecx,(%edx)
  8004e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8004e4:	88 d1                	mov    %dl,%cl
  8004e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f0:	8b 00                	mov    (%eax),%eax
  8004f2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004f7:	75 30                	jne    800529 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004f9:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004ff:	a0 44 30 80 00       	mov    0x803044,%al
  800504:	0f b6 c0             	movzbl %al,%eax
  800507:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80050a:	8b 09                	mov    (%ecx),%ecx
  80050c:	89 cb                	mov    %ecx,%ebx
  80050e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800511:	83 c1 08             	add    $0x8,%ecx
  800514:	52                   	push   %edx
  800515:	50                   	push   %eax
  800516:	53                   	push   %ebx
  800517:	51                   	push   %ecx
  800518:	e8 a0 0f 00 00       	call   8014bd <sys_cputs>
  80051d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800520:	8b 45 0c             	mov    0xc(%ebp),%eax
  800523:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800529:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052c:	8b 40 04             	mov    0x4(%eax),%eax
  80052f:	8d 50 01             	lea    0x1(%eax),%edx
  800532:	8b 45 0c             	mov    0xc(%ebp),%eax
  800535:	89 50 04             	mov    %edx,0x4(%eax)
}
  800538:	90                   	nop
  800539:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80053c:	c9                   	leave  
  80053d:	c3                   	ret    

0080053e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80053e:	55                   	push   %ebp
  80053f:	89 e5                	mov    %esp,%ebp
  800541:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800547:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80054e:	00 00 00 
	b.cnt = 0;
  800551:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800558:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80055b:	ff 75 0c             	pushl  0xc(%ebp)
  80055e:	ff 75 08             	pushl  0x8(%ebp)
  800561:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800567:	50                   	push   %eax
  800568:	68 cd 04 80 00       	push   $0x8004cd
  80056d:	e8 5a 02 00 00       	call   8007cc <vprintfmt>
  800572:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800575:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80057b:	a0 44 30 80 00       	mov    0x803044,%al
  800580:	0f b6 c0             	movzbl %al,%eax
  800583:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800589:	52                   	push   %edx
  80058a:	50                   	push   %eax
  80058b:	51                   	push   %ecx
  80058c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800592:	83 c0 08             	add    $0x8,%eax
  800595:	50                   	push   %eax
  800596:	e8 22 0f 00 00       	call   8014bd <sys_cputs>
  80059b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80059e:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8005a5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005ab:	c9                   	leave  
  8005ac:	c3                   	ret    

008005ad <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005ad:	55                   	push   %ebp
  8005ae:	89 e5                	mov    %esp,%ebp
  8005b0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005b3:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8005ba:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c3:	83 ec 08             	sub    $0x8,%esp
  8005c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c9:	50                   	push   %eax
  8005ca:	e8 6f ff ff ff       	call   80053e <vcprintf>
  8005cf:	83 c4 10             	add    $0x10,%esp
  8005d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005d8:	c9                   	leave  
  8005d9:	c3                   	ret    

008005da <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005da:	55                   	push   %ebp
  8005db:	89 e5                	mov    %esp,%ebp
  8005dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005e0:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ea:	c1 e0 08             	shl    $0x8,%eax
  8005ed:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8005f2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005f5:	83 c0 04             	add    $0x4,%eax
  8005f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fe:	83 ec 08             	sub    $0x8,%esp
  800601:	ff 75 f4             	pushl  -0xc(%ebp)
  800604:	50                   	push   %eax
  800605:	e8 34 ff ff ff       	call   80053e <vcprintf>
  80060a:	83 c4 10             	add    $0x10,%esp
  80060d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800610:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800617:	07 00 00 

	return cnt;
  80061a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80061d:	c9                   	leave  
  80061e:	c3                   	ret    

0080061f <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80061f:	55                   	push   %ebp
  800620:	89 e5                	mov    %esp,%ebp
  800622:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800625:	e8 d7 0e 00 00       	call   801501 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80062a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80062d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	83 ec 08             	sub    $0x8,%esp
  800636:	ff 75 f4             	pushl  -0xc(%ebp)
  800639:	50                   	push   %eax
  80063a:	e8 ff fe ff ff       	call   80053e <vcprintf>
  80063f:	83 c4 10             	add    $0x10,%esp
  800642:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800645:	e8 d1 0e 00 00       	call   80151b <sys_unlock_cons>
	return cnt;
  80064a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80064d:	c9                   	leave  
  80064e:	c3                   	ret    

0080064f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80064f:	55                   	push   %ebp
  800650:	89 e5                	mov    %esp,%ebp
  800652:	53                   	push   %ebx
  800653:	83 ec 14             	sub    $0x14,%esp
  800656:	8b 45 10             	mov    0x10(%ebp),%eax
  800659:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800662:	8b 45 18             	mov    0x18(%ebp),%eax
  800665:	ba 00 00 00 00       	mov    $0x0,%edx
  80066a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80066d:	77 55                	ja     8006c4 <printnum+0x75>
  80066f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800672:	72 05                	jb     800679 <printnum+0x2a>
  800674:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800677:	77 4b                	ja     8006c4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800679:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80067c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80067f:	8b 45 18             	mov    0x18(%ebp),%eax
  800682:	ba 00 00 00 00       	mov    $0x0,%edx
  800687:	52                   	push   %edx
  800688:	50                   	push   %eax
  800689:	ff 75 f4             	pushl  -0xc(%ebp)
  80068c:	ff 75 f0             	pushl  -0x10(%ebp)
  80068f:	e8 1c 14 00 00       	call   801ab0 <__udivdi3>
  800694:	83 c4 10             	add    $0x10,%esp
  800697:	83 ec 04             	sub    $0x4,%esp
  80069a:	ff 75 20             	pushl  0x20(%ebp)
  80069d:	53                   	push   %ebx
  80069e:	ff 75 18             	pushl  0x18(%ebp)
  8006a1:	52                   	push   %edx
  8006a2:	50                   	push   %eax
  8006a3:	ff 75 0c             	pushl  0xc(%ebp)
  8006a6:	ff 75 08             	pushl  0x8(%ebp)
  8006a9:	e8 a1 ff ff ff       	call   80064f <printnum>
  8006ae:	83 c4 20             	add    $0x20,%esp
  8006b1:	eb 1a                	jmp    8006cd <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006b3:	83 ec 08             	sub    $0x8,%esp
  8006b6:	ff 75 0c             	pushl  0xc(%ebp)
  8006b9:	ff 75 20             	pushl  0x20(%ebp)
  8006bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bf:	ff d0                	call   *%eax
  8006c1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006c4:	ff 4d 1c             	decl   0x1c(%ebp)
  8006c7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006cb:	7f e6                	jg     8006b3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006cd:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006db:	53                   	push   %ebx
  8006dc:	51                   	push   %ecx
  8006dd:	52                   	push   %edx
  8006de:	50                   	push   %eax
  8006df:	e8 dc 14 00 00       	call   801bc0 <__umoddi3>
  8006e4:	83 c4 10             	add    $0x10,%esp
  8006e7:	05 14 22 80 00       	add    $0x802214,%eax
  8006ec:	8a 00                	mov    (%eax),%al
  8006ee:	0f be c0             	movsbl %al,%eax
  8006f1:	83 ec 08             	sub    $0x8,%esp
  8006f4:	ff 75 0c             	pushl  0xc(%ebp)
  8006f7:	50                   	push   %eax
  8006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fb:	ff d0                	call   *%eax
  8006fd:	83 c4 10             	add    $0x10,%esp
}
  800700:	90                   	nop
  800701:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800704:	c9                   	leave  
  800705:	c3                   	ret    

00800706 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800706:	55                   	push   %ebp
  800707:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800709:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80070d:	7e 1c                	jle    80072b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80070f:	8b 45 08             	mov    0x8(%ebp),%eax
  800712:	8b 00                	mov    (%eax),%eax
  800714:	8d 50 08             	lea    0x8(%eax),%edx
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	89 10                	mov    %edx,(%eax)
  80071c:	8b 45 08             	mov    0x8(%ebp),%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	83 e8 08             	sub    $0x8,%eax
  800724:	8b 50 04             	mov    0x4(%eax),%edx
  800727:	8b 00                	mov    (%eax),%eax
  800729:	eb 40                	jmp    80076b <getuint+0x65>
	else if (lflag)
  80072b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80072f:	74 1e                	je     80074f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800731:	8b 45 08             	mov    0x8(%ebp),%eax
  800734:	8b 00                	mov    (%eax),%eax
  800736:	8d 50 04             	lea    0x4(%eax),%edx
  800739:	8b 45 08             	mov    0x8(%ebp),%eax
  80073c:	89 10                	mov    %edx,(%eax)
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	8b 00                	mov    (%eax),%eax
  800743:	83 e8 04             	sub    $0x4,%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	ba 00 00 00 00       	mov    $0x0,%edx
  80074d:	eb 1c                	jmp    80076b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
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
}
  80076b:	5d                   	pop    %ebp
  80076c:	c3                   	ret    

0080076d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800770:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800774:	7e 1c                	jle    800792 <getint+0x25>
		return va_arg(*ap, long long);
  800776:	8b 45 08             	mov    0x8(%ebp),%eax
  800779:	8b 00                	mov    (%eax),%eax
  80077b:	8d 50 08             	lea    0x8(%eax),%edx
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	89 10                	mov    %edx,(%eax)
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	83 e8 08             	sub    $0x8,%eax
  80078b:	8b 50 04             	mov    0x4(%eax),%edx
  80078e:	8b 00                	mov    (%eax),%eax
  800790:	eb 38                	jmp    8007ca <getint+0x5d>
	else if (lflag)
  800792:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800796:	74 1a                	je     8007b2 <getint+0x45>
		return va_arg(*ap, long);
  800798:	8b 45 08             	mov    0x8(%ebp),%eax
  80079b:	8b 00                	mov    (%eax),%eax
  80079d:	8d 50 04             	lea    0x4(%eax),%edx
  8007a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a3:	89 10                	mov    %edx,(%eax)
  8007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a8:	8b 00                	mov    (%eax),%eax
  8007aa:	83 e8 04             	sub    $0x4,%eax
  8007ad:	8b 00                	mov    (%eax),%eax
  8007af:	99                   	cltd   
  8007b0:	eb 18                	jmp    8007ca <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b5:	8b 00                	mov    (%eax),%eax
  8007b7:	8d 50 04             	lea    0x4(%eax),%edx
  8007ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bd:	89 10                	mov    %edx,(%eax)
  8007bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c2:	8b 00                	mov    (%eax),%eax
  8007c4:	83 e8 04             	sub    $0x4,%eax
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	99                   	cltd   
}
  8007ca:	5d                   	pop    %ebp
  8007cb:	c3                   	ret    

008007cc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
  8007cf:	56                   	push   %esi
  8007d0:	53                   	push   %ebx
  8007d1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d4:	eb 17                	jmp    8007ed <vprintfmt+0x21>
			if (ch == '\0')
  8007d6:	85 db                	test   %ebx,%ebx
  8007d8:	0f 84 c1 03 00 00    	je     800b9f <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007de:	83 ec 08             	sub    $0x8,%esp
  8007e1:	ff 75 0c             	pushl  0xc(%ebp)
  8007e4:	53                   	push   %ebx
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	ff d0                	call   *%eax
  8007ea:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f0:	8d 50 01             	lea    0x1(%eax),%edx
  8007f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8007f6:	8a 00                	mov    (%eax),%al
  8007f8:	0f b6 d8             	movzbl %al,%ebx
  8007fb:	83 fb 25             	cmp    $0x25,%ebx
  8007fe:	75 d6                	jne    8007d6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800800:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800804:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80080b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800812:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800819:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800820:	8b 45 10             	mov    0x10(%ebp),%eax
  800823:	8d 50 01             	lea    0x1(%eax),%edx
  800826:	89 55 10             	mov    %edx,0x10(%ebp)
  800829:	8a 00                	mov    (%eax),%al
  80082b:	0f b6 d8             	movzbl %al,%ebx
  80082e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800831:	83 f8 5b             	cmp    $0x5b,%eax
  800834:	0f 87 3d 03 00 00    	ja     800b77 <vprintfmt+0x3ab>
  80083a:	8b 04 85 38 22 80 00 	mov    0x802238(,%eax,4),%eax
  800841:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800843:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800847:	eb d7                	jmp    800820 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800849:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80084d:	eb d1                	jmp    800820 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80084f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800856:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800859:	89 d0                	mov    %edx,%eax
  80085b:	c1 e0 02             	shl    $0x2,%eax
  80085e:	01 d0                	add    %edx,%eax
  800860:	01 c0                	add    %eax,%eax
  800862:	01 d8                	add    %ebx,%eax
  800864:	83 e8 30             	sub    $0x30,%eax
  800867:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80086a:	8b 45 10             	mov    0x10(%ebp),%eax
  80086d:	8a 00                	mov    (%eax),%al
  80086f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800872:	83 fb 2f             	cmp    $0x2f,%ebx
  800875:	7e 3e                	jle    8008b5 <vprintfmt+0xe9>
  800877:	83 fb 39             	cmp    $0x39,%ebx
  80087a:	7f 39                	jg     8008b5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80087c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80087f:	eb d5                	jmp    800856 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800881:	8b 45 14             	mov    0x14(%ebp),%eax
  800884:	83 c0 04             	add    $0x4,%eax
  800887:	89 45 14             	mov    %eax,0x14(%ebp)
  80088a:	8b 45 14             	mov    0x14(%ebp),%eax
  80088d:	83 e8 04             	sub    $0x4,%eax
  800890:	8b 00                	mov    (%eax),%eax
  800892:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800895:	eb 1f                	jmp    8008b6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800897:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80089b:	79 83                	jns    800820 <vprintfmt+0x54>
				width = 0;
  80089d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008a4:	e9 77 ff ff ff       	jmp    800820 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008a9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008b0:	e9 6b ff ff ff       	jmp    800820 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008b5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ba:	0f 89 60 ff ff ff    	jns    800820 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008c6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008cd:	e9 4e ff ff ff       	jmp    800820 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008d2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008d5:	e9 46 ff ff ff       	jmp    800820 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008da:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dd:	83 c0 04             	add    $0x4,%eax
  8008e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e6:	83 e8 04             	sub    $0x4,%eax
  8008e9:	8b 00                	mov    (%eax),%eax
  8008eb:	83 ec 08             	sub    $0x8,%esp
  8008ee:	ff 75 0c             	pushl  0xc(%ebp)
  8008f1:	50                   	push   %eax
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	ff d0                	call   *%eax
  8008f7:	83 c4 10             	add    $0x10,%esp
			break;
  8008fa:	e9 9b 02 00 00       	jmp    800b9a <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800902:	83 c0 04             	add    $0x4,%eax
  800905:	89 45 14             	mov    %eax,0x14(%ebp)
  800908:	8b 45 14             	mov    0x14(%ebp),%eax
  80090b:	83 e8 04             	sub    $0x4,%eax
  80090e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800910:	85 db                	test   %ebx,%ebx
  800912:	79 02                	jns    800916 <vprintfmt+0x14a>
				err = -err;
  800914:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800916:	83 fb 64             	cmp    $0x64,%ebx
  800919:	7f 0b                	jg     800926 <vprintfmt+0x15a>
  80091b:	8b 34 9d 80 20 80 00 	mov    0x802080(,%ebx,4),%esi
  800922:	85 f6                	test   %esi,%esi
  800924:	75 19                	jne    80093f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800926:	53                   	push   %ebx
  800927:	68 25 22 80 00       	push   $0x802225
  80092c:	ff 75 0c             	pushl  0xc(%ebp)
  80092f:	ff 75 08             	pushl  0x8(%ebp)
  800932:	e8 70 02 00 00       	call   800ba7 <printfmt>
  800937:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80093a:	e9 5b 02 00 00       	jmp    800b9a <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80093f:	56                   	push   %esi
  800940:	68 2e 22 80 00       	push   $0x80222e
  800945:	ff 75 0c             	pushl  0xc(%ebp)
  800948:	ff 75 08             	pushl  0x8(%ebp)
  80094b:	e8 57 02 00 00       	call   800ba7 <printfmt>
  800950:	83 c4 10             	add    $0x10,%esp
			break;
  800953:	e9 42 02 00 00       	jmp    800b9a <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800958:	8b 45 14             	mov    0x14(%ebp),%eax
  80095b:	83 c0 04             	add    $0x4,%eax
  80095e:	89 45 14             	mov    %eax,0x14(%ebp)
  800961:	8b 45 14             	mov    0x14(%ebp),%eax
  800964:	83 e8 04             	sub    $0x4,%eax
  800967:	8b 30                	mov    (%eax),%esi
  800969:	85 f6                	test   %esi,%esi
  80096b:	75 05                	jne    800972 <vprintfmt+0x1a6>
				p = "(null)";
  80096d:	be 31 22 80 00       	mov    $0x802231,%esi
			if (width > 0 && padc != '-')
  800972:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800976:	7e 6d                	jle    8009e5 <vprintfmt+0x219>
  800978:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80097c:	74 67                	je     8009e5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80097e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800981:	83 ec 08             	sub    $0x8,%esp
  800984:	50                   	push   %eax
  800985:	56                   	push   %esi
  800986:	e8 1e 03 00 00       	call   800ca9 <strnlen>
  80098b:	83 c4 10             	add    $0x10,%esp
  80098e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800991:	eb 16                	jmp    8009a9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800993:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800997:	83 ec 08             	sub    $0x8,%esp
  80099a:	ff 75 0c             	pushl  0xc(%ebp)
  80099d:	50                   	push   %eax
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	ff d0                	call   *%eax
  8009a3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009a6:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ad:	7f e4                	jg     800993 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009af:	eb 34                	jmp    8009e5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009b1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009b5:	74 1c                	je     8009d3 <vprintfmt+0x207>
  8009b7:	83 fb 1f             	cmp    $0x1f,%ebx
  8009ba:	7e 05                	jle    8009c1 <vprintfmt+0x1f5>
  8009bc:	83 fb 7e             	cmp    $0x7e,%ebx
  8009bf:	7e 12                	jle    8009d3 <vprintfmt+0x207>
					putch('?', putdat);
  8009c1:	83 ec 08             	sub    $0x8,%esp
  8009c4:	ff 75 0c             	pushl  0xc(%ebp)
  8009c7:	6a 3f                	push   $0x3f
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	ff d0                	call   *%eax
  8009ce:	83 c4 10             	add    $0x10,%esp
  8009d1:	eb 0f                	jmp    8009e2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	ff 75 0c             	pushl  0xc(%ebp)
  8009d9:	53                   	push   %ebx
  8009da:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dd:	ff d0                	call   *%eax
  8009df:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009e2:	ff 4d e4             	decl   -0x1c(%ebp)
  8009e5:	89 f0                	mov    %esi,%eax
  8009e7:	8d 70 01             	lea    0x1(%eax),%esi
  8009ea:	8a 00                	mov    (%eax),%al
  8009ec:	0f be d8             	movsbl %al,%ebx
  8009ef:	85 db                	test   %ebx,%ebx
  8009f1:	74 24                	je     800a17 <vprintfmt+0x24b>
  8009f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009f7:	78 b8                	js     8009b1 <vprintfmt+0x1e5>
  8009f9:	ff 4d e0             	decl   -0x20(%ebp)
  8009fc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a00:	79 af                	jns    8009b1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a02:	eb 13                	jmp    800a17 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a04:	83 ec 08             	sub    $0x8,%esp
  800a07:	ff 75 0c             	pushl  0xc(%ebp)
  800a0a:	6a 20                	push   $0x20
  800a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0f:	ff d0                	call   *%eax
  800a11:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a14:	ff 4d e4             	decl   -0x1c(%ebp)
  800a17:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a1b:	7f e7                	jg     800a04 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a1d:	e9 78 01 00 00       	jmp    800b9a <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a22:	83 ec 08             	sub    $0x8,%esp
  800a25:	ff 75 e8             	pushl  -0x18(%ebp)
  800a28:	8d 45 14             	lea    0x14(%ebp),%eax
  800a2b:	50                   	push   %eax
  800a2c:	e8 3c fd ff ff       	call   80076d <getint>
  800a31:	83 c4 10             	add    $0x10,%esp
  800a34:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a37:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a40:	85 d2                	test   %edx,%edx
  800a42:	79 23                	jns    800a67 <vprintfmt+0x29b>
				putch('-', putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	6a 2d                	push   $0x2d
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	ff d0                	call   *%eax
  800a51:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a5a:	f7 d8                	neg    %eax
  800a5c:	83 d2 00             	adc    $0x0,%edx
  800a5f:	f7 da                	neg    %edx
  800a61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a64:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a67:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a6e:	e9 bc 00 00 00       	jmp    800b2f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a73:	83 ec 08             	sub    $0x8,%esp
  800a76:	ff 75 e8             	pushl  -0x18(%ebp)
  800a79:	8d 45 14             	lea    0x14(%ebp),%eax
  800a7c:	50                   	push   %eax
  800a7d:	e8 84 fc ff ff       	call   800706 <getuint>
  800a82:	83 c4 10             	add    $0x10,%esp
  800a85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a88:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a8b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a92:	e9 98 00 00 00       	jmp    800b2f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a97:	83 ec 08             	sub    $0x8,%esp
  800a9a:	ff 75 0c             	pushl  0xc(%ebp)
  800a9d:	6a 58                	push   $0x58
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	ff d0                	call   *%eax
  800aa4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aa7:	83 ec 08             	sub    $0x8,%esp
  800aaa:	ff 75 0c             	pushl  0xc(%ebp)
  800aad:	6a 58                	push   $0x58
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	ff d0                	call   *%eax
  800ab4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ab7:	83 ec 08             	sub    $0x8,%esp
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	6a 58                	push   $0x58
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	ff d0                	call   *%eax
  800ac4:	83 c4 10             	add    $0x10,%esp
			break;
  800ac7:	e9 ce 00 00 00       	jmp    800b9a <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	ff 75 0c             	pushl  0xc(%ebp)
  800ad2:	6a 30                	push   $0x30
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	ff d0                	call   *%eax
  800ad9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800adc:	83 ec 08             	sub    $0x8,%esp
  800adf:	ff 75 0c             	pushl  0xc(%ebp)
  800ae2:	6a 78                	push   $0x78
  800ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae7:	ff d0                	call   *%eax
  800ae9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800aec:	8b 45 14             	mov    0x14(%ebp),%eax
  800aef:	83 c0 04             	add    $0x4,%eax
  800af2:	89 45 14             	mov    %eax,0x14(%ebp)
  800af5:	8b 45 14             	mov    0x14(%ebp),%eax
  800af8:	83 e8 04             	sub    $0x4,%eax
  800afb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800afd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b07:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b0e:	eb 1f                	jmp    800b2f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	ff 75 e8             	pushl  -0x18(%ebp)
  800b16:	8d 45 14             	lea    0x14(%ebp),%eax
  800b19:	50                   	push   %eax
  800b1a:	e8 e7 fb ff ff       	call   800706 <getuint>
  800b1f:	83 c4 10             	add    $0x10,%esp
  800b22:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b25:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b28:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b2f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b36:	83 ec 04             	sub    $0x4,%esp
  800b39:	52                   	push   %edx
  800b3a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b3d:	50                   	push   %eax
  800b3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b41:	ff 75 f0             	pushl  -0x10(%ebp)
  800b44:	ff 75 0c             	pushl  0xc(%ebp)
  800b47:	ff 75 08             	pushl  0x8(%ebp)
  800b4a:	e8 00 fb ff ff       	call   80064f <printnum>
  800b4f:	83 c4 20             	add    $0x20,%esp
			break;
  800b52:	eb 46                	jmp    800b9a <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b54:	83 ec 08             	sub    $0x8,%esp
  800b57:	ff 75 0c             	pushl  0xc(%ebp)
  800b5a:	53                   	push   %ebx
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	ff d0                	call   *%eax
  800b60:	83 c4 10             	add    $0x10,%esp
			break;
  800b63:	eb 35                	jmp    800b9a <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b65:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b6c:	eb 2c                	jmp    800b9a <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b6e:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b75:	eb 23                	jmp    800b9a <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b77:	83 ec 08             	sub    $0x8,%esp
  800b7a:	ff 75 0c             	pushl  0xc(%ebp)
  800b7d:	6a 25                	push   $0x25
  800b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b82:	ff d0                	call   *%eax
  800b84:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b87:	ff 4d 10             	decl   0x10(%ebp)
  800b8a:	eb 03                	jmp    800b8f <vprintfmt+0x3c3>
  800b8c:	ff 4d 10             	decl   0x10(%ebp)
  800b8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b92:	48                   	dec    %eax
  800b93:	8a 00                	mov    (%eax),%al
  800b95:	3c 25                	cmp    $0x25,%al
  800b97:	75 f3                	jne    800b8c <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b99:	90                   	nop
		}
	}
  800b9a:	e9 35 fc ff ff       	jmp    8007d4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b9f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ba0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ba3:	5b                   	pop    %ebx
  800ba4:	5e                   	pop    %esi
  800ba5:	5d                   	pop    %ebp
  800ba6:	c3                   	ret    

00800ba7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bad:	8d 45 10             	lea    0x10(%ebp),%eax
  800bb0:	83 c0 04             	add    $0x4,%eax
  800bb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bbc:	50                   	push   %eax
  800bbd:	ff 75 0c             	pushl  0xc(%ebp)
  800bc0:	ff 75 08             	pushl  0x8(%ebp)
  800bc3:	e8 04 fc ff ff       	call   8007cc <vprintfmt>
  800bc8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bcb:	90                   	nop
  800bcc:	c9                   	leave  
  800bcd:	c3                   	ret    

00800bce <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd4:	8b 40 08             	mov    0x8(%eax),%eax
  800bd7:	8d 50 01             	lea    0x1(%eax),%edx
  800bda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdd:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800be0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be3:	8b 10                	mov    (%eax),%edx
  800be5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be8:	8b 40 04             	mov    0x4(%eax),%eax
  800beb:	39 c2                	cmp    %eax,%edx
  800bed:	73 12                	jae    800c01 <sprintputch+0x33>
		*b->buf++ = ch;
  800bef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf2:	8b 00                	mov    (%eax),%eax
  800bf4:	8d 48 01             	lea    0x1(%eax),%ecx
  800bf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bfa:	89 0a                	mov    %ecx,(%edx)
  800bfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800bff:	88 10                	mov    %dl,(%eax)
}
  800c01:	90                   	nop
  800c02:	5d                   	pop    %ebp
  800c03:	c3                   	ret    

00800c04 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c13:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	01 d0                	add    %edx,%eax
  800c1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c25:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c29:	74 06                	je     800c31 <vsnprintf+0x2d>
  800c2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c2f:	7f 07                	jg     800c38 <vsnprintf+0x34>
		return -E_INVAL;
  800c31:	b8 03 00 00 00       	mov    $0x3,%eax
  800c36:	eb 20                	jmp    800c58 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c38:	ff 75 14             	pushl  0x14(%ebp)
  800c3b:	ff 75 10             	pushl  0x10(%ebp)
  800c3e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c41:	50                   	push   %eax
  800c42:	68 ce 0b 80 00       	push   $0x800bce
  800c47:	e8 80 fb ff ff       	call   8007cc <vprintfmt>
  800c4c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c52:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c58:	c9                   	leave  
  800c59:	c3                   	ret    

00800c5a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c60:	8d 45 10             	lea    0x10(%ebp),%eax
  800c63:	83 c0 04             	add    $0x4,%eax
  800c66:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c69:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c6f:	50                   	push   %eax
  800c70:	ff 75 0c             	pushl  0xc(%ebp)
  800c73:	ff 75 08             	pushl  0x8(%ebp)
  800c76:	e8 89 ff ff ff       	call   800c04 <vsnprintf>
  800c7b:	83 c4 10             	add    $0x10,%esp
  800c7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c84:	c9                   	leave  
  800c85:	c3                   	ret    

00800c86 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c93:	eb 06                	jmp    800c9b <strlen+0x15>
		n++;
  800c95:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c98:	ff 45 08             	incl   0x8(%ebp)
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	8a 00                	mov    (%eax),%al
  800ca0:	84 c0                	test   %al,%al
  800ca2:	75 f1                	jne    800c95 <strlen+0xf>
		n++;
	return n;
  800ca4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ca7:	c9                   	leave  
  800ca8:	c3                   	ret    

00800ca9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800caf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cb6:	eb 09                	jmp    800cc1 <strnlen+0x18>
		n++;
  800cb8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cbb:	ff 45 08             	incl   0x8(%ebp)
  800cbe:	ff 4d 0c             	decl   0xc(%ebp)
  800cc1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cc5:	74 09                	je     800cd0 <strnlen+0x27>
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	84 c0                	test   %al,%al
  800cce:	75 e8                	jne    800cb8 <strnlen+0xf>
		n++;
	return n;
  800cd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd3:	c9                   	leave  
  800cd4:	c3                   	ret    

00800cd5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
  800cd8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ce1:	90                   	nop
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	8d 50 01             	lea    0x1(%eax),%edx
  800ce8:	89 55 08             	mov    %edx,0x8(%ebp)
  800ceb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cee:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cf1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cf4:	8a 12                	mov    (%edx),%dl
  800cf6:	88 10                	mov    %dl,(%eax)
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	84 c0                	test   %al,%al
  800cfc:	75 e4                	jne    800ce2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d01:	c9                   	leave  
  800d02:	c3                   	ret    

00800d03 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d16:	eb 1f                	jmp    800d37 <strncpy+0x34>
		*dst++ = *src;
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	8d 50 01             	lea    0x1(%eax),%edx
  800d1e:	89 55 08             	mov    %edx,0x8(%ebp)
  800d21:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d24:	8a 12                	mov    (%edx),%dl
  800d26:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	8a 00                	mov    (%eax),%al
  800d2d:	84 c0                	test   %al,%al
  800d2f:	74 03                	je     800d34 <strncpy+0x31>
			src++;
  800d31:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d34:	ff 45 fc             	incl   -0x4(%ebp)
  800d37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d3a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d3d:	72 d9                	jb     800d18 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d42:	c9                   	leave  
  800d43:	c3                   	ret    

00800d44 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d54:	74 30                	je     800d86 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d56:	eb 16                	jmp    800d6e <strlcpy+0x2a>
			*dst++ = *src++;
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8d 50 01             	lea    0x1(%eax),%edx
  800d5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800d61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d64:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d67:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d6a:	8a 12                	mov    (%edx),%dl
  800d6c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d6e:	ff 4d 10             	decl   0x10(%ebp)
  800d71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d75:	74 09                	je     800d80 <strlcpy+0x3c>
  800d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	84 c0                	test   %al,%al
  800d7e:	75 d8                	jne    800d58 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d86:	8b 55 08             	mov    0x8(%ebp),%edx
  800d89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d8c:	29 c2                	sub    %eax,%edx
  800d8e:	89 d0                	mov    %edx,%eax
}
  800d90:	c9                   	leave  
  800d91:	c3                   	ret    

00800d92 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d92:	55                   	push   %ebp
  800d93:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d95:	eb 06                	jmp    800d9d <strcmp+0xb>
		p++, q++;
  800d97:	ff 45 08             	incl   0x8(%ebp)
  800d9a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	8a 00                	mov    (%eax),%al
  800da2:	84 c0                	test   %al,%al
  800da4:	74 0e                	je     800db4 <strcmp+0x22>
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	8a 10                	mov    (%eax),%dl
  800dab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dae:	8a 00                	mov    (%eax),%al
  800db0:	38 c2                	cmp    %al,%dl
  800db2:	74 e3                	je     800d97 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	0f b6 d0             	movzbl %al,%edx
  800dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbf:	8a 00                	mov    (%eax),%al
  800dc1:	0f b6 c0             	movzbl %al,%eax
  800dc4:	29 c2                	sub    %eax,%edx
  800dc6:	89 d0                	mov    %edx,%eax
}
  800dc8:	5d                   	pop    %ebp
  800dc9:	c3                   	ret    

00800dca <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dcd:	eb 09                	jmp    800dd8 <strncmp+0xe>
		n--, p++, q++;
  800dcf:	ff 4d 10             	decl   0x10(%ebp)
  800dd2:	ff 45 08             	incl   0x8(%ebp)
  800dd5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dd8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ddc:	74 17                	je     800df5 <strncmp+0x2b>
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	8a 00                	mov    (%eax),%al
  800de3:	84 c0                	test   %al,%al
  800de5:	74 0e                	je     800df5 <strncmp+0x2b>
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8a 10                	mov    (%eax),%dl
  800dec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800def:	8a 00                	mov    (%eax),%al
  800df1:	38 c2                	cmp    %al,%dl
  800df3:	74 da                	je     800dcf <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800df5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df9:	75 07                	jne    800e02 <strncmp+0x38>
		return 0;
  800dfb:	b8 00 00 00 00       	mov    $0x0,%eax
  800e00:	eb 14                	jmp    800e16 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	8a 00                	mov    (%eax),%al
  800e07:	0f b6 d0             	movzbl %al,%edx
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	8a 00                	mov    (%eax),%al
  800e0f:	0f b6 c0             	movzbl %al,%eax
  800e12:	29 c2                	sub    %eax,%edx
  800e14:	89 d0                	mov    %edx,%eax
}
  800e16:	5d                   	pop    %ebp
  800e17:	c3                   	ret    

00800e18 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e18:	55                   	push   %ebp
  800e19:	89 e5                	mov    %esp,%ebp
  800e1b:	83 ec 04             	sub    $0x4,%esp
  800e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e21:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e24:	eb 12                	jmp    800e38 <strchr+0x20>
		if (*s == c)
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	8a 00                	mov    (%eax),%al
  800e2b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e2e:	75 05                	jne    800e35 <strchr+0x1d>
			return (char *) s;
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	eb 11                	jmp    800e46 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e35:	ff 45 08             	incl   0x8(%ebp)
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3b:	8a 00                	mov    (%eax),%al
  800e3d:	84 c0                	test   %al,%al
  800e3f:	75 e5                	jne    800e26 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e46:	c9                   	leave  
  800e47:	c3                   	ret    

00800e48 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e48:	55                   	push   %ebp
  800e49:	89 e5                	mov    %esp,%ebp
  800e4b:	83 ec 04             	sub    $0x4,%esp
  800e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e51:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e54:	eb 0d                	jmp    800e63 <strfind+0x1b>
		if (*s == c)
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	8a 00                	mov    (%eax),%al
  800e5b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e5e:	74 0e                	je     800e6e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e60:	ff 45 08             	incl   0x8(%ebp)
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	8a 00                	mov    (%eax),%al
  800e68:	84 c0                	test   %al,%al
  800e6a:	75 ea                	jne    800e56 <strfind+0xe>
  800e6c:	eb 01                	jmp    800e6f <strfind+0x27>
		if (*s == c)
			break;
  800e6e:	90                   	nop
	return (char *) s;
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e72:	c9                   	leave  
  800e73:	c3                   	ret    

00800e74 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e74:	55                   	push   %ebp
  800e75:	89 e5                	mov    %esp,%ebp
  800e77:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e80:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e84:	76 63                	jbe    800ee9 <memset+0x75>
		uint64 data_block = c;
  800e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e89:	99                   	cltd   
  800e8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e8d:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e96:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e9a:	c1 e0 08             	shl    $0x8,%eax
  800e9d:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ea0:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea9:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ead:	c1 e0 10             	shl    $0x10,%eax
  800eb0:	09 45 f0             	or     %eax,-0x10(%ebp)
  800eb3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ebc:	89 c2                	mov    %eax,%edx
  800ebe:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec3:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ec6:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ec9:	eb 18                	jmp    800ee3 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ecb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ece:	8d 41 08             	lea    0x8(%ecx),%eax
  800ed1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800ed4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eda:	89 01                	mov    %eax,(%ecx)
  800edc:	89 51 04             	mov    %edx,0x4(%ecx)
  800edf:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ee3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ee7:	77 e2                	ja     800ecb <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ee9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eed:	74 23                	je     800f12 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800eef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ef5:	eb 0e                	jmp    800f05 <memset+0x91>
			*p8++ = (uint8)c;
  800ef7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efa:	8d 50 01             	lea    0x1(%eax),%edx
  800efd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f00:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f03:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f05:	8b 45 10             	mov    0x10(%ebp),%eax
  800f08:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f0b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f0e:	85 c0                	test   %eax,%eax
  800f10:	75 e5                	jne    800ef7 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f15:	c9                   	leave  
  800f16:	c3                   	ret    

00800f17 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f17:	55                   	push   %ebp
  800f18:	89 e5                	mov    %esp,%ebp
  800f1a:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f20:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f29:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f2d:	76 24                	jbe    800f53 <memcpy+0x3c>
		while(n >= 8){
  800f2f:	eb 1c                	jmp    800f4d <memcpy+0x36>
			*d64 = *s64;
  800f31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f34:	8b 50 04             	mov    0x4(%eax),%edx
  800f37:	8b 00                	mov    (%eax),%eax
  800f39:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f3c:	89 01                	mov    %eax,(%ecx)
  800f3e:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f41:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f45:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f49:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f4d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f51:	77 de                	ja     800f31 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f53:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f57:	74 31                	je     800f8a <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f62:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f65:	eb 16                	jmp    800f7d <memcpy+0x66>
			*d8++ = *s8++;
  800f67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f6a:	8d 50 01             	lea    0x1(%eax),%edx
  800f6d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f73:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f76:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f79:	8a 12                	mov    (%edx),%dl
  800f7b:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f80:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f83:	89 55 10             	mov    %edx,0x10(%ebp)
  800f86:	85 c0                	test   %eax,%eax
  800f88:	75 dd                	jne    800f67 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f8d:	c9                   	leave  
  800f8e:	c3                   	ret    

00800f8f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f8f:	55                   	push   %ebp
  800f90:	89 e5                	mov    %esp,%ebp
  800f92:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fa1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa7:	73 50                	jae    800ff9 <memmove+0x6a>
  800fa9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fac:	8b 45 10             	mov    0x10(%ebp),%eax
  800faf:	01 d0                	add    %edx,%eax
  800fb1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb4:	76 43                	jbe    800ff9 <memmove+0x6a>
		s += n;
  800fb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb9:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fbc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbf:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fc2:	eb 10                	jmp    800fd4 <memmove+0x45>
			*--d = *--s;
  800fc4:	ff 4d f8             	decl   -0x8(%ebp)
  800fc7:	ff 4d fc             	decl   -0x4(%ebp)
  800fca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fcd:	8a 10                	mov    (%eax),%dl
  800fcf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fda:	89 55 10             	mov    %edx,0x10(%ebp)
  800fdd:	85 c0                	test   %eax,%eax
  800fdf:	75 e3                	jne    800fc4 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fe1:	eb 23                	jmp    801006 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fe3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe6:	8d 50 01             	lea    0x1(%eax),%edx
  800fe9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fef:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ff2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ff5:	8a 12                	mov    (%edx),%dl
  800ff7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ff9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fff:	89 55 10             	mov    %edx,0x10(%ebp)
  801002:	85 c0                	test   %eax,%eax
  801004:	75 dd                	jne    800fe3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801009:	c9                   	leave  
  80100a:	c3                   	ret    

0080100b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80100b:	55                   	push   %ebp
  80100c:	89 e5                	mov    %esp,%ebp
  80100e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801017:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80101d:	eb 2a                	jmp    801049 <memcmp+0x3e>
		if (*s1 != *s2)
  80101f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801022:	8a 10                	mov    (%eax),%dl
  801024:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801027:	8a 00                	mov    (%eax),%al
  801029:	38 c2                	cmp    %al,%dl
  80102b:	74 16                	je     801043 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80102d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	0f b6 d0             	movzbl %al,%edx
  801035:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801038:	8a 00                	mov    (%eax),%al
  80103a:	0f b6 c0             	movzbl %al,%eax
  80103d:	29 c2                	sub    %eax,%edx
  80103f:	89 d0                	mov    %edx,%eax
  801041:	eb 18                	jmp    80105b <memcmp+0x50>
		s1++, s2++;
  801043:	ff 45 fc             	incl   -0x4(%ebp)
  801046:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801049:	8b 45 10             	mov    0x10(%ebp),%eax
  80104c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80104f:	89 55 10             	mov    %edx,0x10(%ebp)
  801052:	85 c0                	test   %eax,%eax
  801054:	75 c9                	jne    80101f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801056:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80105b:	c9                   	leave  
  80105c:	c3                   	ret    

0080105d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
  801060:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801063:	8b 55 08             	mov    0x8(%ebp),%edx
  801066:	8b 45 10             	mov    0x10(%ebp),%eax
  801069:	01 d0                	add    %edx,%eax
  80106b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80106e:	eb 15                	jmp    801085 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	8a 00                	mov    (%eax),%al
  801075:	0f b6 d0             	movzbl %al,%edx
  801078:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107b:	0f b6 c0             	movzbl %al,%eax
  80107e:	39 c2                	cmp    %eax,%edx
  801080:	74 0d                	je     80108f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801082:	ff 45 08             	incl   0x8(%ebp)
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80108b:	72 e3                	jb     801070 <memfind+0x13>
  80108d:	eb 01                	jmp    801090 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80108f:	90                   	nop
	return (void *) s;
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801093:	c9                   	leave  
  801094:	c3                   	ret    

00801095 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80109b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010a2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a9:	eb 03                	jmp    8010ae <strtol+0x19>
		s++;
  8010ab:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	8a 00                	mov    (%eax),%al
  8010b3:	3c 20                	cmp    $0x20,%al
  8010b5:	74 f4                	je     8010ab <strtol+0x16>
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	3c 09                	cmp    $0x9,%al
  8010be:	74 eb                	je     8010ab <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	3c 2b                	cmp    $0x2b,%al
  8010c7:	75 05                	jne    8010ce <strtol+0x39>
		s++;
  8010c9:	ff 45 08             	incl   0x8(%ebp)
  8010cc:	eb 13                	jmp    8010e1 <strtol+0x4c>
	else if (*s == '-')
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d1:	8a 00                	mov    (%eax),%al
  8010d3:	3c 2d                	cmp    $0x2d,%al
  8010d5:	75 0a                	jne    8010e1 <strtol+0x4c>
		s++, neg = 1;
  8010d7:	ff 45 08             	incl   0x8(%ebp)
  8010da:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e5:	74 06                	je     8010ed <strtol+0x58>
  8010e7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010eb:	75 20                	jne    80110d <strtol+0x78>
  8010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f0:	8a 00                	mov    (%eax),%al
  8010f2:	3c 30                	cmp    $0x30,%al
  8010f4:	75 17                	jne    80110d <strtol+0x78>
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	40                   	inc    %eax
  8010fa:	8a 00                	mov    (%eax),%al
  8010fc:	3c 78                	cmp    $0x78,%al
  8010fe:	75 0d                	jne    80110d <strtol+0x78>
		s += 2, base = 16;
  801100:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801104:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80110b:	eb 28                	jmp    801135 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80110d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801111:	75 15                	jne    801128 <strtol+0x93>
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	8a 00                	mov    (%eax),%al
  801118:	3c 30                	cmp    $0x30,%al
  80111a:	75 0c                	jne    801128 <strtol+0x93>
		s++, base = 8;
  80111c:	ff 45 08             	incl   0x8(%ebp)
  80111f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801126:	eb 0d                	jmp    801135 <strtol+0xa0>
	else if (base == 0)
  801128:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80112c:	75 07                	jne    801135 <strtol+0xa0>
		base = 10;
  80112e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8a 00                	mov    (%eax),%al
  80113a:	3c 2f                	cmp    $0x2f,%al
  80113c:	7e 19                	jle    801157 <strtol+0xc2>
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	8a 00                	mov    (%eax),%al
  801143:	3c 39                	cmp    $0x39,%al
  801145:	7f 10                	jg     801157 <strtol+0xc2>
			dig = *s - '0';
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	0f be c0             	movsbl %al,%eax
  80114f:	83 e8 30             	sub    $0x30,%eax
  801152:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801155:	eb 42                	jmp    801199 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	8a 00                	mov    (%eax),%al
  80115c:	3c 60                	cmp    $0x60,%al
  80115e:	7e 19                	jle    801179 <strtol+0xe4>
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	3c 7a                	cmp    $0x7a,%al
  801167:	7f 10                	jg     801179 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	8a 00                	mov    (%eax),%al
  80116e:	0f be c0             	movsbl %al,%eax
  801171:	83 e8 57             	sub    $0x57,%eax
  801174:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801177:	eb 20                	jmp    801199 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	3c 40                	cmp    $0x40,%al
  801180:	7e 39                	jle    8011bb <strtol+0x126>
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	3c 5a                	cmp    $0x5a,%al
  801189:	7f 30                	jg     8011bb <strtol+0x126>
			dig = *s - 'A' + 10;
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	8a 00                	mov    (%eax),%al
  801190:	0f be c0             	movsbl %al,%eax
  801193:	83 e8 37             	sub    $0x37,%eax
  801196:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80119c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80119f:	7d 19                	jge    8011ba <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011a1:	ff 45 08             	incl   0x8(%ebp)
  8011a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a7:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011ab:	89 c2                	mov    %eax,%edx
  8011ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b0:	01 d0                	add    %edx,%eax
  8011b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011b5:	e9 7b ff ff ff       	jmp    801135 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011ba:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011bf:	74 08                	je     8011c9 <strtol+0x134>
		*endptr = (char *) s;
  8011c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011cd:	74 07                	je     8011d6 <strtol+0x141>
  8011cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d2:	f7 d8                	neg    %eax
  8011d4:	eb 03                	jmp    8011d9 <strtol+0x144>
  8011d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011d9:	c9                   	leave  
  8011da:	c3                   	ret    

008011db <ltostr>:

void
ltostr(long value, char *str)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
  8011de:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011e8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011f3:	79 13                	jns    801208 <ltostr+0x2d>
	{
		neg = 1;
  8011f5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ff:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801202:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801205:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801210:	99                   	cltd   
  801211:	f7 f9                	idiv   %ecx
  801213:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801216:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801219:	8d 50 01             	lea    0x1(%eax),%edx
  80121c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80121f:	89 c2                	mov    %eax,%edx
  801221:	8b 45 0c             	mov    0xc(%ebp),%eax
  801224:	01 d0                	add    %edx,%eax
  801226:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801229:	83 c2 30             	add    $0x30,%edx
  80122c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80122e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801231:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801236:	f7 e9                	imul   %ecx
  801238:	c1 fa 02             	sar    $0x2,%edx
  80123b:	89 c8                	mov    %ecx,%eax
  80123d:	c1 f8 1f             	sar    $0x1f,%eax
  801240:	29 c2                	sub    %eax,%edx
  801242:	89 d0                	mov    %edx,%eax
  801244:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801247:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80124b:	75 bb                	jne    801208 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80124d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801254:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801257:	48                   	dec    %eax
  801258:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80125b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80125f:	74 3d                	je     80129e <ltostr+0xc3>
		start = 1 ;
  801261:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801268:	eb 34                	jmp    80129e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80126a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80126d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801270:	01 d0                	add    %edx,%eax
  801272:	8a 00                	mov    (%eax),%al
  801274:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801277:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80127a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127d:	01 c2                	add    %eax,%edx
  80127f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801282:	8b 45 0c             	mov    0xc(%ebp),%eax
  801285:	01 c8                	add    %ecx,%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80128b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80128e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801291:	01 c2                	add    %eax,%edx
  801293:	8a 45 eb             	mov    -0x15(%ebp),%al
  801296:	88 02                	mov    %al,(%edx)
		start++ ;
  801298:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80129b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80129e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012a4:	7c c4                	jl     80126a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012a6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ac:	01 d0                	add    %edx,%eax
  8012ae:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012b1:	90                   	nop
  8012b2:	c9                   	leave  
  8012b3:	c3                   	ret    

008012b4 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
  8012b7:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012ba:	ff 75 08             	pushl  0x8(%ebp)
  8012bd:	e8 c4 f9 ff ff       	call   800c86 <strlen>
  8012c2:	83 c4 04             	add    $0x4,%esp
  8012c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012c8:	ff 75 0c             	pushl  0xc(%ebp)
  8012cb:	e8 b6 f9 ff ff       	call   800c86 <strlen>
  8012d0:	83 c4 04             	add    $0x4,%esp
  8012d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012e4:	eb 17                	jmp    8012fd <strcconcat+0x49>
		final[s] = str1[s] ;
  8012e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ec:	01 c2                	add    %eax,%edx
  8012ee:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	01 c8                	add    %ecx,%eax
  8012f6:	8a 00                	mov    (%eax),%al
  8012f8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012fa:	ff 45 fc             	incl   -0x4(%ebp)
  8012fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801300:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801303:	7c e1                	jl     8012e6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801305:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80130c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801313:	eb 1f                	jmp    801334 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801315:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801318:	8d 50 01             	lea    0x1(%eax),%edx
  80131b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80131e:	89 c2                	mov    %eax,%edx
  801320:	8b 45 10             	mov    0x10(%ebp),%eax
  801323:	01 c2                	add    %eax,%edx
  801325:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132b:	01 c8                	add    %ecx,%eax
  80132d:	8a 00                	mov    (%eax),%al
  80132f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801331:	ff 45 f8             	incl   -0x8(%ebp)
  801334:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801337:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80133a:	7c d9                	jl     801315 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80133c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80133f:	8b 45 10             	mov    0x10(%ebp),%eax
  801342:	01 d0                	add    %edx,%eax
  801344:	c6 00 00             	movb   $0x0,(%eax)
}
  801347:	90                   	nop
  801348:	c9                   	leave  
  801349:	c3                   	ret    

0080134a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80134d:	8b 45 14             	mov    0x14(%ebp),%eax
  801350:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801356:	8b 45 14             	mov    0x14(%ebp),%eax
  801359:	8b 00                	mov    (%eax),%eax
  80135b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801362:	8b 45 10             	mov    0x10(%ebp),%eax
  801365:	01 d0                	add    %edx,%eax
  801367:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80136d:	eb 0c                	jmp    80137b <strsplit+0x31>
			*string++ = 0;
  80136f:	8b 45 08             	mov    0x8(%ebp),%eax
  801372:	8d 50 01             	lea    0x1(%eax),%edx
  801375:	89 55 08             	mov    %edx,0x8(%ebp)
  801378:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	8a 00                	mov    (%eax),%al
  801380:	84 c0                	test   %al,%al
  801382:	74 18                	je     80139c <strsplit+0x52>
  801384:	8b 45 08             	mov    0x8(%ebp),%eax
  801387:	8a 00                	mov    (%eax),%al
  801389:	0f be c0             	movsbl %al,%eax
  80138c:	50                   	push   %eax
  80138d:	ff 75 0c             	pushl  0xc(%ebp)
  801390:	e8 83 fa ff ff       	call   800e18 <strchr>
  801395:	83 c4 08             	add    $0x8,%esp
  801398:	85 c0                	test   %eax,%eax
  80139a:	75 d3                	jne    80136f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	8a 00                	mov    (%eax),%al
  8013a1:	84 c0                	test   %al,%al
  8013a3:	74 5a                	je     8013ff <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a8:	8b 00                	mov    (%eax),%eax
  8013aa:	83 f8 0f             	cmp    $0xf,%eax
  8013ad:	75 07                	jne    8013b6 <strsplit+0x6c>
		{
			return 0;
  8013af:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b4:	eb 66                	jmp    80141c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b9:	8b 00                	mov    (%eax),%eax
  8013bb:	8d 48 01             	lea    0x1(%eax),%ecx
  8013be:	8b 55 14             	mov    0x14(%ebp),%edx
  8013c1:	89 0a                	mov    %ecx,(%edx)
  8013c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cd:	01 c2                	add    %eax,%edx
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013d4:	eb 03                	jmp    8013d9 <strsplit+0x8f>
			string++;
  8013d6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dc:	8a 00                	mov    (%eax),%al
  8013de:	84 c0                	test   %al,%al
  8013e0:	74 8b                	je     80136d <strsplit+0x23>
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	8a 00                	mov    (%eax),%al
  8013e7:	0f be c0             	movsbl %al,%eax
  8013ea:	50                   	push   %eax
  8013eb:	ff 75 0c             	pushl  0xc(%ebp)
  8013ee:	e8 25 fa ff ff       	call   800e18 <strchr>
  8013f3:	83 c4 08             	add    $0x8,%esp
  8013f6:	85 c0                	test   %eax,%eax
  8013f8:	74 dc                	je     8013d6 <strsplit+0x8c>
			string++;
	}
  8013fa:	e9 6e ff ff ff       	jmp    80136d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013ff:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801400:	8b 45 14             	mov    0x14(%ebp),%eax
  801403:	8b 00                	mov    (%eax),%eax
  801405:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80140c:	8b 45 10             	mov    0x10(%ebp),%eax
  80140f:	01 d0                	add    %edx,%eax
  801411:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801417:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80141c:	c9                   	leave  
  80141d:	c3                   	ret    

0080141e <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
  801421:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801424:	8b 45 08             	mov    0x8(%ebp),%eax
  801427:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80142a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801431:	eb 4a                	jmp    80147d <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801433:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	01 c2                	add    %eax,%edx
  80143b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80143e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801441:	01 c8                	add    %ecx,%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801447:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80144a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144d:	01 d0                	add    %edx,%eax
  80144f:	8a 00                	mov    (%eax),%al
  801451:	3c 40                	cmp    $0x40,%al
  801453:	7e 25                	jle    80147a <str2lower+0x5c>
  801455:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801458:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145b:	01 d0                	add    %edx,%eax
  80145d:	8a 00                	mov    (%eax),%al
  80145f:	3c 5a                	cmp    $0x5a,%al
  801461:	7f 17                	jg     80147a <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801463:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	01 d0                	add    %edx,%eax
  80146b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80146e:	8b 55 08             	mov    0x8(%ebp),%edx
  801471:	01 ca                	add    %ecx,%edx
  801473:	8a 12                	mov    (%edx),%dl
  801475:	83 c2 20             	add    $0x20,%edx
  801478:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80147a:	ff 45 fc             	incl   -0x4(%ebp)
  80147d:	ff 75 0c             	pushl  0xc(%ebp)
  801480:	e8 01 f8 ff ff       	call   800c86 <strlen>
  801485:	83 c4 04             	add    $0x4,%esp
  801488:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80148b:	7f a6                	jg     801433 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80148d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801490:	c9                   	leave  
  801491:	c3                   	ret    

00801492 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
  801495:	57                   	push   %edi
  801496:	56                   	push   %esi
  801497:	53                   	push   %ebx
  801498:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014a4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014a7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014aa:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014ad:	cd 30                	int    $0x30
  8014af:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8014b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014b5:	83 c4 10             	add    $0x10,%esp
  8014b8:	5b                   	pop    %ebx
  8014b9:	5e                   	pop    %esi
  8014ba:	5f                   	pop    %edi
  8014bb:	5d                   	pop    %ebp
  8014bc:	c3                   	ret    

008014bd <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	83 ec 04             	sub    $0x4,%esp
  8014c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8014c9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014cc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d3:	6a 00                	push   $0x0
  8014d5:	51                   	push   %ecx
  8014d6:	52                   	push   %edx
  8014d7:	ff 75 0c             	pushl  0xc(%ebp)
  8014da:	50                   	push   %eax
  8014db:	6a 00                	push   $0x0
  8014dd:	e8 b0 ff ff ff       	call   801492 <syscall>
  8014e2:	83 c4 18             	add    $0x18,%esp
}
  8014e5:	90                   	nop
  8014e6:	c9                   	leave  
  8014e7:	c3                   	ret    

008014e8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 02                	push   $0x2
  8014f7:	e8 96 ff ff ff       	call   801492 <syscall>
  8014fc:	83 c4 18             	add    $0x18,%esp
}
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    

00801501 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	6a 03                	push   $0x3
  801510:	e8 7d ff ff ff       	call   801492 <syscall>
  801515:	83 c4 18             	add    $0x18,%esp
}
  801518:	90                   	nop
  801519:	c9                   	leave  
  80151a:	c3                   	ret    

0080151b <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80151b:	55                   	push   %ebp
  80151c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 04                	push   $0x4
  80152a:	e8 63 ff ff ff       	call   801492 <syscall>
  80152f:	83 c4 18             	add    $0x18,%esp
}
  801532:	90                   	nop
  801533:	c9                   	leave  
  801534:	c3                   	ret    

00801535 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801538:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	52                   	push   %edx
  801545:	50                   	push   %eax
  801546:	6a 08                	push   $0x8
  801548:	e8 45 ff ff ff       	call   801492 <syscall>
  80154d:	83 c4 18             	add    $0x18,%esp
}
  801550:	c9                   	leave  
  801551:	c3                   	ret    

00801552 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801552:	55                   	push   %ebp
  801553:	89 e5                	mov    %esp,%ebp
  801555:	56                   	push   %esi
  801556:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801557:	8b 75 18             	mov    0x18(%ebp),%esi
  80155a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80155d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801560:	8b 55 0c             	mov    0xc(%ebp),%edx
  801563:	8b 45 08             	mov    0x8(%ebp),%eax
  801566:	56                   	push   %esi
  801567:	53                   	push   %ebx
  801568:	51                   	push   %ecx
  801569:	52                   	push   %edx
  80156a:	50                   	push   %eax
  80156b:	6a 09                	push   $0x9
  80156d:	e8 20 ff ff ff       	call   801492 <syscall>
  801572:	83 c4 18             	add    $0x18,%esp
}
  801575:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801578:	5b                   	pop    %ebx
  801579:	5e                   	pop    %esi
  80157a:	5d                   	pop    %ebp
  80157b:	c3                   	ret    

0080157c <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	ff 75 08             	pushl  0x8(%ebp)
  80158a:	6a 0a                	push   $0xa
  80158c:	e8 01 ff ff ff       	call   801492 <syscall>
  801591:	83 c4 18             	add    $0x18,%esp
}
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	ff 75 0c             	pushl  0xc(%ebp)
  8015a2:	ff 75 08             	pushl  0x8(%ebp)
  8015a5:	6a 0b                	push   $0xb
  8015a7:	e8 e6 fe ff ff       	call   801492 <syscall>
  8015ac:	83 c4 18             	add    $0x18,%esp
}
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 0c                	push   $0xc
  8015c0:	e8 cd fe ff ff       	call   801492 <syscall>
  8015c5:	83 c4 18             	add    $0x18,%esp
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 0d                	push   $0xd
  8015d9:	e8 b4 fe ff ff       	call   801492 <syscall>
  8015de:	83 c4 18             	add    $0x18,%esp
}
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 0e                	push   $0xe
  8015f2:	e8 9b fe ff ff       	call   801492 <syscall>
  8015f7:	83 c4 18             	add    $0x18,%esp
}
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 0f                	push   $0xf
  80160b:	e8 82 fe ff ff       	call   801492 <syscall>
  801610:	83 c4 18             	add    $0x18,%esp
}
  801613:	c9                   	leave  
  801614:	c3                   	ret    

00801615 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	ff 75 08             	pushl  0x8(%ebp)
  801623:	6a 10                	push   $0x10
  801625:	e8 68 fe ff ff       	call   801492 <syscall>
  80162a:	83 c4 18             	add    $0x18,%esp
}
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 11                	push   $0x11
  80163e:	e8 4f fe ff ff       	call   801492 <syscall>
  801643:	83 c4 18             	add    $0x18,%esp
}
  801646:	90                   	nop
  801647:	c9                   	leave  
  801648:	c3                   	ret    

00801649 <sys_cputc>:

void
sys_cputc(const char c)
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
  80164c:	83 ec 04             	sub    $0x4,%esp
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801655:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	50                   	push   %eax
  801662:	6a 01                	push   $0x1
  801664:	e8 29 fe ff ff       	call   801492 <syscall>
  801669:	83 c4 18             	add    $0x18,%esp
}
  80166c:	90                   	nop
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 14                	push   $0x14
  80167e:	e8 0f fe ff ff       	call   801492 <syscall>
  801683:	83 c4 18             	add    $0x18,%esp
}
  801686:	90                   	nop
  801687:	c9                   	leave  
  801688:	c3                   	ret    

00801689 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
  80168c:	83 ec 04             	sub    $0x4,%esp
  80168f:	8b 45 10             	mov    0x10(%ebp),%eax
  801692:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801695:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801698:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80169c:	8b 45 08             	mov    0x8(%ebp),%eax
  80169f:	6a 00                	push   $0x0
  8016a1:	51                   	push   %ecx
  8016a2:	52                   	push   %edx
  8016a3:	ff 75 0c             	pushl  0xc(%ebp)
  8016a6:	50                   	push   %eax
  8016a7:	6a 15                	push   $0x15
  8016a9:	e8 e4 fd ff ff       	call   801492 <syscall>
  8016ae:	83 c4 18             	add    $0x18,%esp
}
  8016b1:	c9                   	leave  
  8016b2:	c3                   	ret    

008016b3 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	52                   	push   %edx
  8016c3:	50                   	push   %eax
  8016c4:	6a 16                	push   $0x16
  8016c6:	e8 c7 fd ff ff       	call   801492 <syscall>
  8016cb:	83 c4 18             	add    $0x18,%esp
}
  8016ce:	c9                   	leave  
  8016cf:	c3                   	ret    

008016d0 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	51                   	push   %ecx
  8016e1:	52                   	push   %edx
  8016e2:	50                   	push   %eax
  8016e3:	6a 17                	push   $0x17
  8016e5:	e8 a8 fd ff ff       	call   801492 <syscall>
  8016ea:	83 c4 18             	add    $0x18,%esp
}
  8016ed:	c9                   	leave  
  8016ee:	c3                   	ret    

008016ef <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	52                   	push   %edx
  8016ff:	50                   	push   %eax
  801700:	6a 18                	push   $0x18
  801702:	e8 8b fd ff ff       	call   801492 <syscall>
  801707:	83 c4 18             	add    $0x18,%esp
}
  80170a:	c9                   	leave  
  80170b:	c3                   	ret    

0080170c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80170f:	8b 45 08             	mov    0x8(%ebp),%eax
  801712:	6a 00                	push   $0x0
  801714:	ff 75 14             	pushl  0x14(%ebp)
  801717:	ff 75 10             	pushl  0x10(%ebp)
  80171a:	ff 75 0c             	pushl  0xc(%ebp)
  80171d:	50                   	push   %eax
  80171e:	6a 19                	push   $0x19
  801720:	e8 6d fd ff ff       	call   801492 <syscall>
  801725:	83 c4 18             	add    $0x18,%esp
}
  801728:	c9                   	leave  
  801729:	c3                   	ret    

0080172a <sys_run_env>:

void sys_run_env(int32 envId)
{
  80172a:	55                   	push   %ebp
  80172b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80172d:	8b 45 08             	mov    0x8(%ebp),%eax
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	50                   	push   %eax
  801739:	6a 1a                	push   $0x1a
  80173b:	e8 52 fd ff ff       	call   801492 <syscall>
  801740:	83 c4 18             	add    $0x18,%esp
}
  801743:	90                   	nop
  801744:	c9                   	leave  
  801745:	c3                   	ret    

00801746 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	50                   	push   %eax
  801755:	6a 1b                	push   $0x1b
  801757:	e8 36 fd ff ff       	call   801492 <syscall>
  80175c:	83 c4 18             	add    $0x18,%esp
}
  80175f:	c9                   	leave  
  801760:	c3                   	ret    

00801761 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 05                	push   $0x5
  801770:	e8 1d fd ff ff       	call   801492 <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 06                	push   $0x6
  801789:	e8 04 fd ff ff       	call   801492 <syscall>
  80178e:	83 c4 18             	add    $0x18,%esp
}
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 07                	push   $0x7
  8017a2:	e8 eb fc ff ff       	call   801492 <syscall>
  8017a7:	83 c4 18             	add    $0x18,%esp
}
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <sys_exit_env>:


void sys_exit_env(void)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 1c                	push   $0x1c
  8017bb:	e8 d2 fc ff ff       	call   801492 <syscall>
  8017c0:	83 c4 18             	add    $0x18,%esp
}
  8017c3:	90                   	nop
  8017c4:	c9                   	leave  
  8017c5:	c3                   	ret    

008017c6 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
  8017c9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017cc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017cf:	8d 50 04             	lea    0x4(%eax),%edx
  8017d2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	52                   	push   %edx
  8017dc:	50                   	push   %eax
  8017dd:	6a 1d                	push   $0x1d
  8017df:	e8 ae fc ff ff       	call   801492 <syscall>
  8017e4:	83 c4 18             	add    $0x18,%esp
	return result;
  8017e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017f0:	89 01                	mov    %eax,(%ecx)
  8017f2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	c9                   	leave  
  8017f9:	c2 04 00             	ret    $0x4

008017fc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	ff 75 10             	pushl  0x10(%ebp)
  801806:	ff 75 0c             	pushl  0xc(%ebp)
  801809:	ff 75 08             	pushl  0x8(%ebp)
  80180c:	6a 13                	push   $0x13
  80180e:	e8 7f fc ff ff       	call   801492 <syscall>
  801813:	83 c4 18             	add    $0x18,%esp
	return ;
  801816:	90                   	nop
}
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <sys_rcr2>:
uint32 sys_rcr2()
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 1e                	push   $0x1e
  801828:	e8 65 fc ff ff       	call   801492 <syscall>
  80182d:	83 c4 18             	add    $0x18,%esp
}
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	83 ec 04             	sub    $0x4,%esp
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80183e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	50                   	push   %eax
  80184b:	6a 1f                	push   $0x1f
  80184d:	e8 40 fc ff ff       	call   801492 <syscall>
  801852:	83 c4 18             	add    $0x18,%esp
	return ;
  801855:	90                   	nop
}
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <rsttst>:
void rsttst()
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 21                	push   $0x21
  801867:	e8 26 fc ff ff       	call   801492 <syscall>
  80186c:	83 c4 18             	add    $0x18,%esp
	return ;
  80186f:	90                   	nop
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 04             	sub    $0x4,%esp
  801878:	8b 45 14             	mov    0x14(%ebp),%eax
  80187b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80187e:	8b 55 18             	mov    0x18(%ebp),%edx
  801881:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801885:	52                   	push   %edx
  801886:	50                   	push   %eax
  801887:	ff 75 10             	pushl  0x10(%ebp)
  80188a:	ff 75 0c             	pushl  0xc(%ebp)
  80188d:	ff 75 08             	pushl  0x8(%ebp)
  801890:	6a 20                	push   $0x20
  801892:	e8 fb fb ff ff       	call   801492 <syscall>
  801897:	83 c4 18             	add    $0x18,%esp
	return ;
  80189a:	90                   	nop
}
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <chktst>:
void chktst(uint32 n)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	ff 75 08             	pushl  0x8(%ebp)
  8018ab:	6a 22                	push   $0x22
  8018ad:	e8 e0 fb ff ff       	call   801492 <syscall>
  8018b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b5:	90                   	nop
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <inctst>:

void inctst()
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 23                	push   $0x23
  8018c7:	e8 c6 fb ff ff       	call   801492 <syscall>
  8018cc:	83 c4 18             	add    $0x18,%esp
	return ;
  8018cf:	90                   	nop
}
  8018d0:	c9                   	leave  
  8018d1:	c3                   	ret    

008018d2 <gettst>:
uint32 gettst()
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 24                	push   $0x24
  8018e1:	e8 ac fb ff ff       	call   801492 <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 25                	push   $0x25
  8018fa:	e8 93 fb ff ff       	call   801492 <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
  801902:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801907:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801911:	8b 45 08             	mov    0x8(%ebp),%eax
  801914:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	ff 75 08             	pushl  0x8(%ebp)
  801924:	6a 26                	push   $0x26
  801926:	e8 67 fb ff ff       	call   801492 <syscall>
  80192b:	83 c4 18             	add    $0x18,%esp
	return ;
  80192e:	90                   	nop
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801935:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801938:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80193b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193e:	8b 45 08             	mov    0x8(%ebp),%eax
  801941:	6a 00                	push   $0x0
  801943:	53                   	push   %ebx
  801944:	51                   	push   %ecx
  801945:	52                   	push   %edx
  801946:	50                   	push   %eax
  801947:	6a 27                	push   $0x27
  801949:	e8 44 fb ff ff       	call   801492 <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
}
  801951:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801959:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	52                   	push   %edx
  801966:	50                   	push   %eax
  801967:	6a 28                	push   $0x28
  801969:	e8 24 fb ff ff       	call   801492 <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
}
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801976:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	6a 00                	push   $0x0
  801981:	51                   	push   %ecx
  801982:	ff 75 10             	pushl  0x10(%ebp)
  801985:	52                   	push   %edx
  801986:	50                   	push   %eax
  801987:	6a 29                	push   $0x29
  801989:	e8 04 fb ff ff       	call   801492 <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	ff 75 10             	pushl  0x10(%ebp)
  80199d:	ff 75 0c             	pushl  0xc(%ebp)
  8019a0:	ff 75 08             	pushl  0x8(%ebp)
  8019a3:	6a 12                	push   $0x12
  8019a5:	e8 e8 fa ff ff       	call   801492 <syscall>
  8019aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ad:	90                   	nop
}
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8019b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	52                   	push   %edx
  8019c0:	50                   	push   %eax
  8019c1:	6a 2a                	push   $0x2a
  8019c3:	e8 ca fa ff ff       	call   801492 <syscall>
  8019c8:	83 c4 18             	add    $0x18,%esp
	return;
  8019cb:	90                   	nop
}
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 2b                	push   $0x2b
  8019dd:	e8 b0 fa ff ff       	call   801492 <syscall>
  8019e2:	83 c4 18             	add    $0x18,%esp
}
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	ff 75 0c             	pushl  0xc(%ebp)
  8019f3:	ff 75 08             	pushl  0x8(%ebp)
  8019f6:	6a 2d                	push   $0x2d
  8019f8:	e8 95 fa ff ff       	call   801492 <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
	return;
  801a00:	90                   	nop
}
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	ff 75 0c             	pushl  0xc(%ebp)
  801a0f:	ff 75 08             	pushl  0x8(%ebp)
  801a12:	6a 2c                	push   $0x2c
  801a14:	e8 79 fa ff ff       	call   801492 <syscall>
  801a19:	83 c4 18             	add    $0x18,%esp
	return ;
  801a1c:	90                   	nop
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
  801a22:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801a25:	83 ec 04             	sub    $0x4,%esp
  801a28:	68 a8 23 80 00       	push   $0x8023a8
  801a2d:	68 25 01 00 00       	push   $0x125
  801a32:	68 db 23 80 00       	push   $0x8023db
  801a37:	e8 a3 e8 ff ff       	call   8002df <_panic>

00801a3c <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
  801a3f:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  801a42:	83 ec 04             	sub    $0x4,%esp
  801a45:	68 ec 23 80 00       	push   $0x8023ec
  801a4a:	6a 07                	push   $0x7
  801a4c:	68 1b 24 80 00       	push   $0x80241b
  801a51:	e8 89 e8 ff ff       	call   8002df <_panic>

00801a56 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  801a5c:	83 ec 04             	sub    $0x4,%esp
  801a5f:	68 2c 24 80 00       	push   $0x80242c
  801a64:	6a 0b                	push   $0xb
  801a66:	68 1b 24 80 00       	push   $0x80241b
  801a6b:	e8 6f e8 ff ff       	call   8002df <_panic>

00801a70 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
  801a73:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  801a76:	83 ec 04             	sub    $0x4,%esp
  801a79:	68 58 24 80 00       	push   $0x802458
  801a7e:	6a 10                	push   $0x10
  801a80:	68 1b 24 80 00       	push   $0x80241b
  801a85:	e8 55 e8 ff ff       	call   8002df <_panic>

00801a8a <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
  801a8d:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  801a90:	83 ec 04             	sub    $0x4,%esp
  801a93:	68 88 24 80 00       	push   $0x802488
  801a98:	6a 15                	push   $0x15
  801a9a:	68 1b 24 80 00       	push   $0x80241b
  801a9f:	e8 3b e8 ff ff       	call   8002df <_panic>

00801aa4 <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaa:	8b 40 10             	mov    0x10(%eax),%eax
}
  801aad:	5d                   	pop    %ebp
  801aae:	c3                   	ret    
  801aaf:	90                   	nop

00801ab0 <__udivdi3>:
  801ab0:	55                   	push   %ebp
  801ab1:	57                   	push   %edi
  801ab2:	56                   	push   %esi
  801ab3:	53                   	push   %ebx
  801ab4:	83 ec 1c             	sub    $0x1c,%esp
  801ab7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801abb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801abf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ac3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ac7:	89 ca                	mov    %ecx,%edx
  801ac9:	89 f8                	mov    %edi,%eax
  801acb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801acf:	85 f6                	test   %esi,%esi
  801ad1:	75 2d                	jne    801b00 <__udivdi3+0x50>
  801ad3:	39 cf                	cmp    %ecx,%edi
  801ad5:	77 65                	ja     801b3c <__udivdi3+0x8c>
  801ad7:	89 fd                	mov    %edi,%ebp
  801ad9:	85 ff                	test   %edi,%edi
  801adb:	75 0b                	jne    801ae8 <__udivdi3+0x38>
  801add:	b8 01 00 00 00       	mov    $0x1,%eax
  801ae2:	31 d2                	xor    %edx,%edx
  801ae4:	f7 f7                	div    %edi
  801ae6:	89 c5                	mov    %eax,%ebp
  801ae8:	31 d2                	xor    %edx,%edx
  801aea:	89 c8                	mov    %ecx,%eax
  801aec:	f7 f5                	div    %ebp
  801aee:	89 c1                	mov    %eax,%ecx
  801af0:	89 d8                	mov    %ebx,%eax
  801af2:	f7 f5                	div    %ebp
  801af4:	89 cf                	mov    %ecx,%edi
  801af6:	89 fa                	mov    %edi,%edx
  801af8:	83 c4 1c             	add    $0x1c,%esp
  801afb:	5b                   	pop    %ebx
  801afc:	5e                   	pop    %esi
  801afd:	5f                   	pop    %edi
  801afe:	5d                   	pop    %ebp
  801aff:	c3                   	ret    
  801b00:	39 ce                	cmp    %ecx,%esi
  801b02:	77 28                	ja     801b2c <__udivdi3+0x7c>
  801b04:	0f bd fe             	bsr    %esi,%edi
  801b07:	83 f7 1f             	xor    $0x1f,%edi
  801b0a:	75 40                	jne    801b4c <__udivdi3+0x9c>
  801b0c:	39 ce                	cmp    %ecx,%esi
  801b0e:	72 0a                	jb     801b1a <__udivdi3+0x6a>
  801b10:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b14:	0f 87 9e 00 00 00    	ja     801bb8 <__udivdi3+0x108>
  801b1a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b1f:	89 fa                	mov    %edi,%edx
  801b21:	83 c4 1c             	add    $0x1c,%esp
  801b24:	5b                   	pop    %ebx
  801b25:	5e                   	pop    %esi
  801b26:	5f                   	pop    %edi
  801b27:	5d                   	pop    %ebp
  801b28:	c3                   	ret    
  801b29:	8d 76 00             	lea    0x0(%esi),%esi
  801b2c:	31 ff                	xor    %edi,%edi
  801b2e:	31 c0                	xor    %eax,%eax
  801b30:	89 fa                	mov    %edi,%edx
  801b32:	83 c4 1c             	add    $0x1c,%esp
  801b35:	5b                   	pop    %ebx
  801b36:	5e                   	pop    %esi
  801b37:	5f                   	pop    %edi
  801b38:	5d                   	pop    %ebp
  801b39:	c3                   	ret    
  801b3a:	66 90                	xchg   %ax,%ax
  801b3c:	89 d8                	mov    %ebx,%eax
  801b3e:	f7 f7                	div    %edi
  801b40:	31 ff                	xor    %edi,%edi
  801b42:	89 fa                	mov    %edi,%edx
  801b44:	83 c4 1c             	add    $0x1c,%esp
  801b47:	5b                   	pop    %ebx
  801b48:	5e                   	pop    %esi
  801b49:	5f                   	pop    %edi
  801b4a:	5d                   	pop    %ebp
  801b4b:	c3                   	ret    
  801b4c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b51:	89 eb                	mov    %ebp,%ebx
  801b53:	29 fb                	sub    %edi,%ebx
  801b55:	89 f9                	mov    %edi,%ecx
  801b57:	d3 e6                	shl    %cl,%esi
  801b59:	89 c5                	mov    %eax,%ebp
  801b5b:	88 d9                	mov    %bl,%cl
  801b5d:	d3 ed                	shr    %cl,%ebp
  801b5f:	89 e9                	mov    %ebp,%ecx
  801b61:	09 f1                	or     %esi,%ecx
  801b63:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b67:	89 f9                	mov    %edi,%ecx
  801b69:	d3 e0                	shl    %cl,%eax
  801b6b:	89 c5                	mov    %eax,%ebp
  801b6d:	89 d6                	mov    %edx,%esi
  801b6f:	88 d9                	mov    %bl,%cl
  801b71:	d3 ee                	shr    %cl,%esi
  801b73:	89 f9                	mov    %edi,%ecx
  801b75:	d3 e2                	shl    %cl,%edx
  801b77:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b7b:	88 d9                	mov    %bl,%cl
  801b7d:	d3 e8                	shr    %cl,%eax
  801b7f:	09 c2                	or     %eax,%edx
  801b81:	89 d0                	mov    %edx,%eax
  801b83:	89 f2                	mov    %esi,%edx
  801b85:	f7 74 24 0c          	divl   0xc(%esp)
  801b89:	89 d6                	mov    %edx,%esi
  801b8b:	89 c3                	mov    %eax,%ebx
  801b8d:	f7 e5                	mul    %ebp
  801b8f:	39 d6                	cmp    %edx,%esi
  801b91:	72 19                	jb     801bac <__udivdi3+0xfc>
  801b93:	74 0b                	je     801ba0 <__udivdi3+0xf0>
  801b95:	89 d8                	mov    %ebx,%eax
  801b97:	31 ff                	xor    %edi,%edi
  801b99:	e9 58 ff ff ff       	jmp    801af6 <__udivdi3+0x46>
  801b9e:	66 90                	xchg   %ax,%ax
  801ba0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ba4:	89 f9                	mov    %edi,%ecx
  801ba6:	d3 e2                	shl    %cl,%edx
  801ba8:	39 c2                	cmp    %eax,%edx
  801baa:	73 e9                	jae    801b95 <__udivdi3+0xe5>
  801bac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801baf:	31 ff                	xor    %edi,%edi
  801bb1:	e9 40 ff ff ff       	jmp    801af6 <__udivdi3+0x46>
  801bb6:	66 90                	xchg   %ax,%ax
  801bb8:	31 c0                	xor    %eax,%eax
  801bba:	e9 37 ff ff ff       	jmp    801af6 <__udivdi3+0x46>
  801bbf:	90                   	nop

00801bc0 <__umoddi3>:
  801bc0:	55                   	push   %ebp
  801bc1:	57                   	push   %edi
  801bc2:	56                   	push   %esi
  801bc3:	53                   	push   %ebx
  801bc4:	83 ec 1c             	sub    $0x1c,%esp
  801bc7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bcb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bcf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bd3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801bd7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bdb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bdf:	89 f3                	mov    %esi,%ebx
  801be1:	89 fa                	mov    %edi,%edx
  801be3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801be7:	89 34 24             	mov    %esi,(%esp)
  801bea:	85 c0                	test   %eax,%eax
  801bec:	75 1a                	jne    801c08 <__umoddi3+0x48>
  801bee:	39 f7                	cmp    %esi,%edi
  801bf0:	0f 86 a2 00 00 00    	jbe    801c98 <__umoddi3+0xd8>
  801bf6:	89 c8                	mov    %ecx,%eax
  801bf8:	89 f2                	mov    %esi,%edx
  801bfa:	f7 f7                	div    %edi
  801bfc:	89 d0                	mov    %edx,%eax
  801bfe:	31 d2                	xor    %edx,%edx
  801c00:	83 c4 1c             	add    $0x1c,%esp
  801c03:	5b                   	pop    %ebx
  801c04:	5e                   	pop    %esi
  801c05:	5f                   	pop    %edi
  801c06:	5d                   	pop    %ebp
  801c07:	c3                   	ret    
  801c08:	39 f0                	cmp    %esi,%eax
  801c0a:	0f 87 ac 00 00 00    	ja     801cbc <__umoddi3+0xfc>
  801c10:	0f bd e8             	bsr    %eax,%ebp
  801c13:	83 f5 1f             	xor    $0x1f,%ebp
  801c16:	0f 84 ac 00 00 00    	je     801cc8 <__umoddi3+0x108>
  801c1c:	bf 20 00 00 00       	mov    $0x20,%edi
  801c21:	29 ef                	sub    %ebp,%edi
  801c23:	89 fe                	mov    %edi,%esi
  801c25:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c29:	89 e9                	mov    %ebp,%ecx
  801c2b:	d3 e0                	shl    %cl,%eax
  801c2d:	89 d7                	mov    %edx,%edi
  801c2f:	89 f1                	mov    %esi,%ecx
  801c31:	d3 ef                	shr    %cl,%edi
  801c33:	09 c7                	or     %eax,%edi
  801c35:	89 e9                	mov    %ebp,%ecx
  801c37:	d3 e2                	shl    %cl,%edx
  801c39:	89 14 24             	mov    %edx,(%esp)
  801c3c:	89 d8                	mov    %ebx,%eax
  801c3e:	d3 e0                	shl    %cl,%eax
  801c40:	89 c2                	mov    %eax,%edx
  801c42:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c46:	d3 e0                	shl    %cl,%eax
  801c48:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c4c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c50:	89 f1                	mov    %esi,%ecx
  801c52:	d3 e8                	shr    %cl,%eax
  801c54:	09 d0                	or     %edx,%eax
  801c56:	d3 eb                	shr    %cl,%ebx
  801c58:	89 da                	mov    %ebx,%edx
  801c5a:	f7 f7                	div    %edi
  801c5c:	89 d3                	mov    %edx,%ebx
  801c5e:	f7 24 24             	mull   (%esp)
  801c61:	89 c6                	mov    %eax,%esi
  801c63:	89 d1                	mov    %edx,%ecx
  801c65:	39 d3                	cmp    %edx,%ebx
  801c67:	0f 82 87 00 00 00    	jb     801cf4 <__umoddi3+0x134>
  801c6d:	0f 84 91 00 00 00    	je     801d04 <__umoddi3+0x144>
  801c73:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c77:	29 f2                	sub    %esi,%edx
  801c79:	19 cb                	sbb    %ecx,%ebx
  801c7b:	89 d8                	mov    %ebx,%eax
  801c7d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c81:	d3 e0                	shl    %cl,%eax
  801c83:	89 e9                	mov    %ebp,%ecx
  801c85:	d3 ea                	shr    %cl,%edx
  801c87:	09 d0                	or     %edx,%eax
  801c89:	89 e9                	mov    %ebp,%ecx
  801c8b:	d3 eb                	shr    %cl,%ebx
  801c8d:	89 da                	mov    %ebx,%edx
  801c8f:	83 c4 1c             	add    $0x1c,%esp
  801c92:	5b                   	pop    %ebx
  801c93:	5e                   	pop    %esi
  801c94:	5f                   	pop    %edi
  801c95:	5d                   	pop    %ebp
  801c96:	c3                   	ret    
  801c97:	90                   	nop
  801c98:	89 fd                	mov    %edi,%ebp
  801c9a:	85 ff                	test   %edi,%edi
  801c9c:	75 0b                	jne    801ca9 <__umoddi3+0xe9>
  801c9e:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca3:	31 d2                	xor    %edx,%edx
  801ca5:	f7 f7                	div    %edi
  801ca7:	89 c5                	mov    %eax,%ebp
  801ca9:	89 f0                	mov    %esi,%eax
  801cab:	31 d2                	xor    %edx,%edx
  801cad:	f7 f5                	div    %ebp
  801caf:	89 c8                	mov    %ecx,%eax
  801cb1:	f7 f5                	div    %ebp
  801cb3:	89 d0                	mov    %edx,%eax
  801cb5:	e9 44 ff ff ff       	jmp    801bfe <__umoddi3+0x3e>
  801cba:	66 90                	xchg   %ax,%ax
  801cbc:	89 c8                	mov    %ecx,%eax
  801cbe:	89 f2                	mov    %esi,%edx
  801cc0:	83 c4 1c             	add    $0x1c,%esp
  801cc3:	5b                   	pop    %ebx
  801cc4:	5e                   	pop    %esi
  801cc5:	5f                   	pop    %edi
  801cc6:	5d                   	pop    %ebp
  801cc7:	c3                   	ret    
  801cc8:	3b 04 24             	cmp    (%esp),%eax
  801ccb:	72 06                	jb     801cd3 <__umoddi3+0x113>
  801ccd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801cd1:	77 0f                	ja     801ce2 <__umoddi3+0x122>
  801cd3:	89 f2                	mov    %esi,%edx
  801cd5:	29 f9                	sub    %edi,%ecx
  801cd7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801cdb:	89 14 24             	mov    %edx,(%esp)
  801cde:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ce2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ce6:	8b 14 24             	mov    (%esp),%edx
  801ce9:	83 c4 1c             	add    $0x1c,%esp
  801cec:	5b                   	pop    %ebx
  801ced:	5e                   	pop    %esi
  801cee:	5f                   	pop    %edi
  801cef:	5d                   	pop    %ebp
  801cf0:	c3                   	ret    
  801cf1:	8d 76 00             	lea    0x0(%esi),%esi
  801cf4:	2b 04 24             	sub    (%esp),%eax
  801cf7:	19 fa                	sbb    %edi,%edx
  801cf9:	89 d1                	mov    %edx,%ecx
  801cfb:	89 c6                	mov    %eax,%esi
  801cfd:	e9 71 ff ff ff       	jmp    801c73 <__umoddi3+0xb3>
  801d02:	66 90                	xchg   %ax,%ax
  801d04:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d08:	72 ea                	jb     801cf4 <__umoddi3+0x134>
  801d0a:	89 d9                	mov    %ebx,%ecx
  801d0c:	e9 62 ff ff ff       	jmp    801c73 <__umoddi3+0xb3>

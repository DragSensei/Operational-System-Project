
obj/user/tst_sleeplock_slave:     file format elf32-i386


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
  800031:	e8 bb 00 00 00       	call   8000f1 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program: acquire, release then increment test to declare finishing
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	int envID = sys_getenvid();
  80003e:	e8 e0 16 00 00       	call   801723 <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	//Acquire the lock
	sys_utilities("__AcquireSleepLock__", 0);
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	6a 00                	push   $0x0
  80004b:	68 20 1d 80 00       	push   $0x801d20
  800050:	e8 1d 19 00 00       	call   801972 <sys_utilities>
  800055:	83 c4 10             	add    $0x10,%esp
	{
		if (gettst() > 1)
  800058:	e8 37 18 00 00       	call   801894 <gettst>
  80005d:	83 f8 01             	cmp    $0x1,%eax
  800060:	76 33                	jbe    800095 <_main+0x5d>
		{
			//Other slaves: wait for a while
			env_sleep(RAND(1000, 5000));
  800062:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800065:	83 ec 0c             	sub    $0xc,%esp
  800068:	50                   	push   %eax
  800069:	e8 1a 17 00 00       	call   801788 <sys_get_virtual_time>
  80006e:	83 c4 0c             	add    $0xc,%esp
  800071:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800074:	b9 a0 0f 00 00       	mov    $0xfa0,%ecx
  800079:	ba 00 00 00 00       	mov    $0x0,%edx
  80007e:	f7 f1                	div    %ecx
  800080:	89 d0                	mov    %edx,%eax
  800082:	05 e8 03 00 00       	add    $0x3e8,%eax
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	50                   	push   %eax
  80008b:	e8 6e 19 00 00       	call   8019fe <env_sleep>
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	eb 0b                	jmp    8000a0 <_main+0x68>
		}
		else
		{
			//this is the first slave inside C.S.! so wait until receiving signal from master
			while (gettst() != 1);
  800095:	90                   	nop
  800096:	e8 f9 17 00 00       	call   801894 <gettst>
  80009b:	83 f8 01             	cmp    $0x1,%eax
  80009e:	75 f6                	jne    800096 <_main+0x5e>
		}

		//Check lock value inside C.S.
		int lockVal = 0;
  8000a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		sys_utilities("__GetLockValue__", (int)(&lockVal));
  8000a7:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8000aa:	83 ec 08             	sub    $0x8,%esp
  8000ad:	50                   	push   %eax
  8000ae:	68 35 1d 80 00       	push   $0x801d35
  8000b3:	e8 ba 18 00 00       	call   801972 <sys_utilities>
  8000b8:	83 c4 10             	add    $0x10,%esp
		if (lockVal != 1)
  8000bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000be:	83 f8 01             	cmp    $0x1,%eax
  8000c1:	74 14                	je     8000d7 <_main+0x9f>
		{
			panic("%~test sleeplock failed! lock is not held while it's expected to be");
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	68 48 1d 80 00       	push   $0x801d48
  8000cb:	6a 1d                	push   $0x1d
  8000cd:	68 8c 1d 80 00       	push   $0x801d8c
  8000d2:	e8 ca 01 00 00       	call   8002a1 <_panic>
		}
	}
	//Release the lock
	sys_utilities("__ReleaseSleepLock__", 0);
  8000d7:	83 ec 08             	sub    $0x8,%esp
  8000da:	6a 00                	push   $0x0
  8000dc:	68 a7 1d 80 00       	push   $0x801da7
  8000e1:	e8 8c 18 00 00       	call   801972 <sys_utilities>
  8000e6:	83 c4 10             	add    $0x10,%esp

	//indicates wakenup
	inctst();
  8000e9:	e8 8c 17 00 00       	call   80187a <inctst>

	return;
  8000ee:	90                   	nop
}
  8000ef:	c9                   	leave  
  8000f0:	c3                   	ret    

008000f1 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000f1:	55                   	push   %ebp
  8000f2:	89 e5                	mov    %esp,%ebp
  8000f4:	57                   	push   %edi
  8000f5:	56                   	push   %esi
  8000f6:	53                   	push   %ebx
  8000f7:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000fa:	e8 3d 16 00 00       	call   80173c <sys_getenvindex>
  8000ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800102:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800105:	89 d0                	mov    %edx,%eax
  800107:	c1 e0 02             	shl    $0x2,%eax
  80010a:	01 d0                	add    %edx,%eax
  80010c:	c1 e0 03             	shl    $0x3,%eax
  80010f:	01 d0                	add    %edx,%eax
  800111:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800118:	01 d0                	add    %edx,%eax
  80011a:	c1 e0 02             	shl    $0x2,%eax
  80011d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800122:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800127:	a1 20 30 80 00       	mov    0x803020,%eax
  80012c:	8a 40 20             	mov    0x20(%eax),%al
  80012f:	84 c0                	test   %al,%al
  800131:	74 0d                	je     800140 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800133:	a1 20 30 80 00       	mov    0x803020,%eax
  800138:	83 c0 20             	add    $0x20,%eax
  80013b:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800140:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800144:	7e 0a                	jle    800150 <libmain+0x5f>
		binaryname = argv[0];
  800146:	8b 45 0c             	mov    0xc(%ebp),%eax
  800149:	8b 00                	mov    (%eax),%eax
  80014b:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800150:	83 ec 08             	sub    $0x8,%esp
  800153:	ff 75 0c             	pushl  0xc(%ebp)
  800156:	ff 75 08             	pushl  0x8(%ebp)
  800159:	e8 da fe ff ff       	call   800038 <_main>
  80015e:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800161:	a1 00 30 80 00       	mov    0x803000,%eax
  800166:	85 c0                	test   %eax,%eax
  800168:	0f 84 01 01 00 00    	je     80026f <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80016e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800174:	bb b4 1e 80 00       	mov    $0x801eb4,%ebx
  800179:	ba 0e 00 00 00       	mov    $0xe,%edx
  80017e:	89 c7                	mov    %eax,%edi
  800180:	89 de                	mov    %ebx,%esi
  800182:	89 d1                	mov    %edx,%ecx
  800184:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800186:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800189:	b9 56 00 00 00       	mov    $0x56,%ecx
  80018e:	b0 00                	mov    $0x0,%al
  800190:	89 d7                	mov    %edx,%edi
  800192:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800194:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80019b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80019e:	83 ec 08             	sub    $0x8,%esp
  8001a1:	50                   	push   %eax
  8001a2:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001a8:	50                   	push   %eax
  8001a9:	e8 c4 17 00 00       	call   801972 <sys_utilities>
  8001ae:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001b1:	e8 0d 13 00 00       	call   8014c3 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	68 d4 1d 80 00       	push   $0x801dd4
  8001be:	e8 ac 03 00 00       	call   80056f <cprintf>
  8001c3:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c9:	85 c0                	test   %eax,%eax
  8001cb:	74 18                	je     8001e5 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001cd:	e8 be 17 00 00       	call   801990 <sys_get_optimal_num_faults>
  8001d2:	83 ec 08             	sub    $0x8,%esp
  8001d5:	50                   	push   %eax
  8001d6:	68 fc 1d 80 00       	push   $0x801dfc
  8001db:	e8 8f 03 00 00       	call   80056f <cprintf>
  8001e0:	83 c4 10             	add    $0x10,%esp
  8001e3:	eb 59                	jmp    80023e <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001e5:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ea:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8001f0:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f5:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8001fb:	83 ec 04             	sub    $0x4,%esp
  8001fe:	52                   	push   %edx
  8001ff:	50                   	push   %eax
  800200:	68 20 1e 80 00       	push   $0x801e20
  800205:	e8 65 03 00 00       	call   80056f <cprintf>
  80020a:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80020d:	a1 20 30 80 00       	mov    0x803020,%eax
  800212:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800218:	a1 20 30 80 00       	mov    0x803020,%eax
  80021d:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800223:	a1 20 30 80 00       	mov    0x803020,%eax
  800228:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80022e:	51                   	push   %ecx
  80022f:	52                   	push   %edx
  800230:	50                   	push   %eax
  800231:	68 48 1e 80 00       	push   $0x801e48
  800236:	e8 34 03 00 00       	call   80056f <cprintf>
  80023b:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80023e:	a1 20 30 80 00       	mov    0x803020,%eax
  800243:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800249:	83 ec 08             	sub    $0x8,%esp
  80024c:	50                   	push   %eax
  80024d:	68 a0 1e 80 00       	push   $0x801ea0
  800252:	e8 18 03 00 00       	call   80056f <cprintf>
  800257:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80025a:	83 ec 0c             	sub    $0xc,%esp
  80025d:	68 d4 1d 80 00       	push   $0x801dd4
  800262:	e8 08 03 00 00       	call   80056f <cprintf>
  800267:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80026a:	e8 6e 12 00 00       	call   8014dd <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80026f:	e8 1f 00 00 00       	call   800293 <exit>
}
  800274:	90                   	nop
  800275:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800278:	5b                   	pop    %ebx
  800279:	5e                   	pop    %esi
  80027a:	5f                   	pop    %edi
  80027b:	5d                   	pop    %ebp
  80027c:	c3                   	ret    

0080027d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800283:	83 ec 0c             	sub    $0xc,%esp
  800286:	6a 00                	push   $0x0
  800288:	e8 7b 14 00 00       	call   801708 <sys_destroy_env>
  80028d:	83 c4 10             	add    $0x10,%esp
}
  800290:	90                   	nop
  800291:	c9                   	leave  
  800292:	c3                   	ret    

00800293 <exit>:

void
exit(void)
{
  800293:	55                   	push   %ebp
  800294:	89 e5                	mov    %esp,%ebp
  800296:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800299:	e8 d0 14 00 00       	call   80176e <sys_exit_env>
}
  80029e:	90                   	nop
  80029f:	c9                   	leave  
  8002a0:	c3                   	ret    

008002a1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002a1:	55                   	push   %ebp
  8002a2:	89 e5                	mov    %esp,%ebp
  8002a4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002a7:	8d 45 10             	lea    0x10(%ebp),%eax
  8002aa:	83 c0 04             	add    $0x4,%eax
  8002ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002b0:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002b5:	85 c0                	test   %eax,%eax
  8002b7:	74 16                	je     8002cf <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002b9:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002be:	83 ec 08             	sub    $0x8,%esp
  8002c1:	50                   	push   %eax
  8002c2:	68 18 1f 80 00       	push   $0x801f18
  8002c7:	e8 a3 02 00 00       	call   80056f <cprintf>
  8002cc:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8002cf:	a1 04 30 80 00       	mov    0x803004,%eax
  8002d4:	83 ec 0c             	sub    $0xc,%esp
  8002d7:	ff 75 0c             	pushl  0xc(%ebp)
  8002da:	ff 75 08             	pushl  0x8(%ebp)
  8002dd:	50                   	push   %eax
  8002de:	68 20 1f 80 00       	push   $0x801f20
  8002e3:	6a 74                	push   $0x74
  8002e5:	e8 b2 02 00 00       	call   80059c <cprintf_colored>
  8002ea:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8002ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f0:	83 ec 08             	sub    $0x8,%esp
  8002f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8002f6:	50                   	push   %eax
  8002f7:	e8 04 02 00 00       	call   800500 <vcprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002ff:	83 ec 08             	sub    $0x8,%esp
  800302:	6a 00                	push   $0x0
  800304:	68 48 1f 80 00       	push   $0x801f48
  800309:	e8 f2 01 00 00       	call   800500 <vcprintf>
  80030e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800311:	e8 7d ff ff ff       	call   800293 <exit>

	// should not return here
	while (1) ;
  800316:	eb fe                	jmp    800316 <_panic+0x75>

00800318 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80031e:	a1 20 30 80 00       	mov    0x803020,%eax
  800323:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800329:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032c:	39 c2                	cmp    %eax,%edx
  80032e:	74 14                	je     800344 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800330:	83 ec 04             	sub    $0x4,%esp
  800333:	68 4c 1f 80 00       	push   $0x801f4c
  800338:	6a 26                	push   $0x26
  80033a:	68 98 1f 80 00       	push   $0x801f98
  80033f:	e8 5d ff ff ff       	call   8002a1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800344:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80034b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800352:	e9 c5 00 00 00       	jmp    80041c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800357:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80035a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800361:	8b 45 08             	mov    0x8(%ebp),%eax
  800364:	01 d0                	add    %edx,%eax
  800366:	8b 00                	mov    (%eax),%eax
  800368:	85 c0                	test   %eax,%eax
  80036a:	75 08                	jne    800374 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80036c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80036f:	e9 a5 00 00 00       	jmp    800419 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800374:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80037b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800382:	eb 69                	jmp    8003ed <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800384:	a1 20 30 80 00       	mov    0x803020,%eax
  800389:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80038f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800392:	89 d0                	mov    %edx,%eax
  800394:	01 c0                	add    %eax,%eax
  800396:	01 d0                	add    %edx,%eax
  800398:	c1 e0 03             	shl    $0x3,%eax
  80039b:	01 c8                	add    %ecx,%eax
  80039d:	8a 40 04             	mov    0x4(%eax),%al
  8003a0:	84 c0                	test   %al,%al
  8003a2:	75 46                	jne    8003ea <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003a4:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a9:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003af:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003b2:	89 d0                	mov    %edx,%eax
  8003b4:	01 c0                	add    %eax,%eax
  8003b6:	01 d0                	add    %edx,%eax
  8003b8:	c1 e0 03             	shl    $0x3,%eax
  8003bb:	01 c8                	add    %ecx,%eax
  8003bd:	8b 00                	mov    (%eax),%eax
  8003bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ca:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003cf:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d9:	01 c8                	add    %ecx,%eax
  8003db:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003dd:	39 c2                	cmp    %eax,%edx
  8003df:	75 09                	jne    8003ea <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003e1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003e8:	eb 15                	jmp    8003ff <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ea:	ff 45 e8             	incl   -0x18(%ebp)
  8003ed:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003fb:	39 c2                	cmp    %eax,%edx
  8003fd:	77 85                	ja     800384 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800403:	75 14                	jne    800419 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800405:	83 ec 04             	sub    $0x4,%esp
  800408:	68 a4 1f 80 00       	push   $0x801fa4
  80040d:	6a 3a                	push   $0x3a
  80040f:	68 98 1f 80 00       	push   $0x801f98
  800414:	e8 88 fe ff ff       	call   8002a1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800419:	ff 45 f0             	incl   -0x10(%ebp)
  80041c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80041f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800422:	0f 8c 2f ff ff ff    	jl     800357 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800428:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800436:	eb 26                	jmp    80045e <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800438:	a1 20 30 80 00       	mov    0x803020,%eax
  80043d:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800443:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800446:	89 d0                	mov    %edx,%eax
  800448:	01 c0                	add    %eax,%eax
  80044a:	01 d0                	add    %edx,%eax
  80044c:	c1 e0 03             	shl    $0x3,%eax
  80044f:	01 c8                	add    %ecx,%eax
  800451:	8a 40 04             	mov    0x4(%eax),%al
  800454:	3c 01                	cmp    $0x1,%al
  800456:	75 03                	jne    80045b <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800458:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80045b:	ff 45 e0             	incl   -0x20(%ebp)
  80045e:	a1 20 30 80 00       	mov    0x803020,%eax
  800463:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800469:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80046c:	39 c2                	cmp    %eax,%edx
  80046e:	77 c8                	ja     800438 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800473:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800476:	74 14                	je     80048c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	68 f8 1f 80 00       	push   $0x801ff8
  800480:	6a 44                	push   $0x44
  800482:	68 98 1f 80 00       	push   $0x801f98
  800487:	e8 15 fe ff ff       	call   8002a1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80048c:	90                   	nop
  80048d:	c9                   	leave  
  80048e:	c3                   	ret    

0080048f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
  800492:	53                   	push   %ebx
  800493:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800496:	8b 45 0c             	mov    0xc(%ebp),%eax
  800499:	8b 00                	mov    (%eax),%eax
  80049b:	8d 48 01             	lea    0x1(%eax),%ecx
  80049e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a1:	89 0a                	mov    %ecx,(%edx)
  8004a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8004a6:	88 d1                	mov    %dl,%cl
  8004a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ab:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b2:	8b 00                	mov    (%eax),%eax
  8004b4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004b9:	75 30                	jne    8004eb <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004bb:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004c1:	a0 44 30 80 00       	mov    0x803044,%al
  8004c6:	0f b6 c0             	movzbl %al,%eax
  8004c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004cc:	8b 09                	mov    (%ecx),%ecx
  8004ce:	89 cb                	mov    %ecx,%ebx
  8004d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004d3:	83 c1 08             	add    $0x8,%ecx
  8004d6:	52                   	push   %edx
  8004d7:	50                   	push   %eax
  8004d8:	53                   	push   %ebx
  8004d9:	51                   	push   %ecx
  8004da:	e8 a0 0f 00 00       	call   80147f <sys_cputs>
  8004df:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ee:	8b 40 04             	mov    0x4(%eax),%eax
  8004f1:	8d 50 01             	lea    0x1(%eax),%edx
  8004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004fa:	90                   	nop
  8004fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004fe:	c9                   	leave  
  8004ff:	c3                   	ret    

00800500 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800500:	55                   	push   %ebp
  800501:	89 e5                	mov    %esp,%ebp
  800503:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800509:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800510:	00 00 00 
	b.cnt = 0;
  800513:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80051a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80051d:	ff 75 0c             	pushl  0xc(%ebp)
  800520:	ff 75 08             	pushl  0x8(%ebp)
  800523:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800529:	50                   	push   %eax
  80052a:	68 8f 04 80 00       	push   $0x80048f
  80052f:	e8 5a 02 00 00       	call   80078e <vprintfmt>
  800534:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800537:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80053d:	a0 44 30 80 00       	mov    0x803044,%al
  800542:	0f b6 c0             	movzbl %al,%eax
  800545:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80054b:	52                   	push   %edx
  80054c:	50                   	push   %eax
  80054d:	51                   	push   %ecx
  80054e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800554:	83 c0 08             	add    $0x8,%eax
  800557:	50                   	push   %eax
  800558:	e8 22 0f 00 00       	call   80147f <sys_cputs>
  80055d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800560:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800567:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80056d:	c9                   	leave  
  80056e:	c3                   	ret    

0080056f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80056f:	55                   	push   %ebp
  800570:	89 e5                	mov    %esp,%ebp
  800572:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800575:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80057c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80057f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800582:	8b 45 08             	mov    0x8(%ebp),%eax
  800585:	83 ec 08             	sub    $0x8,%esp
  800588:	ff 75 f4             	pushl  -0xc(%ebp)
  80058b:	50                   	push   %eax
  80058c:	e8 6f ff ff ff       	call   800500 <vcprintf>
  800591:	83 c4 10             	add    $0x10,%esp
  800594:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800597:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80059a:	c9                   	leave  
  80059b:	c3                   	ret    

0080059c <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80059c:	55                   	push   %ebp
  80059d:	89 e5                	mov    %esp,%ebp
  80059f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005a2:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ac:	c1 e0 08             	shl    $0x8,%eax
  8005af:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8005b4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005b7:	83 c0 04             	add    $0x4,%eax
  8005ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c0:	83 ec 08             	sub    $0x8,%esp
  8005c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c6:	50                   	push   %eax
  8005c7:	e8 34 ff ff ff       	call   800500 <vcprintf>
  8005cc:	83 c4 10             	add    $0x10,%esp
  8005cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8005d2:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8005d9:	07 00 00 

	return cnt;
  8005dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005df:	c9                   	leave  
  8005e0:	c3                   	ret    

008005e1 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8005e1:	55                   	push   %ebp
  8005e2:	89 e5                	mov    %esp,%ebp
  8005e4:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8005e7:	e8 d7 0e 00 00       	call   8014c3 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005ec:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f5:	83 ec 08             	sub    $0x8,%esp
  8005f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8005fb:	50                   	push   %eax
  8005fc:	e8 ff fe ff ff       	call   800500 <vcprintf>
  800601:	83 c4 10             	add    $0x10,%esp
  800604:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800607:	e8 d1 0e 00 00       	call   8014dd <sys_unlock_cons>
	return cnt;
  80060c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80060f:	c9                   	leave  
  800610:	c3                   	ret    

00800611 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800611:	55                   	push   %ebp
  800612:	89 e5                	mov    %esp,%ebp
  800614:	53                   	push   %ebx
  800615:	83 ec 14             	sub    $0x14,%esp
  800618:	8b 45 10             	mov    0x10(%ebp),%eax
  80061b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800624:	8b 45 18             	mov    0x18(%ebp),%eax
  800627:	ba 00 00 00 00       	mov    $0x0,%edx
  80062c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80062f:	77 55                	ja     800686 <printnum+0x75>
  800631:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800634:	72 05                	jb     80063b <printnum+0x2a>
  800636:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800639:	77 4b                	ja     800686 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80063b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80063e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800641:	8b 45 18             	mov    0x18(%ebp),%eax
  800644:	ba 00 00 00 00       	mov    $0x0,%edx
  800649:	52                   	push   %edx
  80064a:	50                   	push   %eax
  80064b:	ff 75 f4             	pushl  -0xc(%ebp)
  80064e:	ff 75 f0             	pushl  -0x10(%ebp)
  800651:	e8 66 14 00 00       	call   801abc <__udivdi3>
  800656:	83 c4 10             	add    $0x10,%esp
  800659:	83 ec 04             	sub    $0x4,%esp
  80065c:	ff 75 20             	pushl  0x20(%ebp)
  80065f:	53                   	push   %ebx
  800660:	ff 75 18             	pushl  0x18(%ebp)
  800663:	52                   	push   %edx
  800664:	50                   	push   %eax
  800665:	ff 75 0c             	pushl  0xc(%ebp)
  800668:	ff 75 08             	pushl  0x8(%ebp)
  80066b:	e8 a1 ff ff ff       	call   800611 <printnum>
  800670:	83 c4 20             	add    $0x20,%esp
  800673:	eb 1a                	jmp    80068f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800675:	83 ec 08             	sub    $0x8,%esp
  800678:	ff 75 0c             	pushl  0xc(%ebp)
  80067b:	ff 75 20             	pushl  0x20(%ebp)
  80067e:	8b 45 08             	mov    0x8(%ebp),%eax
  800681:	ff d0                	call   *%eax
  800683:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800686:	ff 4d 1c             	decl   0x1c(%ebp)
  800689:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80068d:	7f e6                	jg     800675 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80068f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800692:	bb 00 00 00 00       	mov    $0x0,%ebx
  800697:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80069a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80069d:	53                   	push   %ebx
  80069e:	51                   	push   %ecx
  80069f:	52                   	push   %edx
  8006a0:	50                   	push   %eax
  8006a1:	e8 26 15 00 00       	call   801bcc <__umoddi3>
  8006a6:	83 c4 10             	add    $0x10,%esp
  8006a9:	05 74 22 80 00       	add    $0x802274,%eax
  8006ae:	8a 00                	mov    (%eax),%al
  8006b0:	0f be c0             	movsbl %al,%eax
  8006b3:	83 ec 08             	sub    $0x8,%esp
  8006b6:	ff 75 0c             	pushl  0xc(%ebp)
  8006b9:	50                   	push   %eax
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	ff d0                	call   *%eax
  8006bf:	83 c4 10             	add    $0x10,%esp
}
  8006c2:	90                   	nop
  8006c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006c6:	c9                   	leave  
  8006c7:	c3                   	ret    

008006c8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006c8:	55                   	push   %ebp
  8006c9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006cb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006cf:	7e 1c                	jle    8006ed <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	8d 50 08             	lea    0x8(%eax),%edx
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	89 10                	mov    %edx,(%eax)
  8006de:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	83 e8 08             	sub    $0x8,%eax
  8006e6:	8b 50 04             	mov    0x4(%eax),%edx
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	eb 40                	jmp    80072d <getuint+0x65>
	else if (lflag)
  8006ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006f1:	74 1e                	je     800711 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	8d 50 04             	lea    0x4(%eax),%edx
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	89 10                	mov    %edx,(%eax)
  800700:	8b 45 08             	mov    0x8(%ebp),%eax
  800703:	8b 00                	mov    (%eax),%eax
  800705:	83 e8 04             	sub    $0x4,%eax
  800708:	8b 00                	mov    (%eax),%eax
  80070a:	ba 00 00 00 00       	mov    $0x0,%edx
  80070f:	eb 1c                	jmp    80072d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	8d 50 04             	lea    0x4(%eax),%edx
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	89 10                	mov    %edx,(%eax)
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	8b 00                	mov    (%eax),%eax
  800723:	83 e8 04             	sub    $0x4,%eax
  800726:	8b 00                	mov    (%eax),%eax
  800728:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80072d:	5d                   	pop    %ebp
  80072e:	c3                   	ret    

0080072f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800732:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800736:	7e 1c                	jle    800754 <getint+0x25>
		return va_arg(*ap, long long);
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	8d 50 08             	lea    0x8(%eax),%edx
  800740:	8b 45 08             	mov    0x8(%ebp),%eax
  800743:	89 10                	mov    %edx,(%eax)
  800745:	8b 45 08             	mov    0x8(%ebp),%eax
  800748:	8b 00                	mov    (%eax),%eax
  80074a:	83 e8 08             	sub    $0x8,%eax
  80074d:	8b 50 04             	mov    0x4(%eax),%edx
  800750:	8b 00                	mov    (%eax),%eax
  800752:	eb 38                	jmp    80078c <getint+0x5d>
	else if (lflag)
  800754:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800758:	74 1a                	je     800774 <getint+0x45>
		return va_arg(*ap, long);
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	8b 00                	mov    (%eax),%eax
  80075f:	8d 50 04             	lea    0x4(%eax),%edx
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	89 10                	mov    %edx,(%eax)
  800767:	8b 45 08             	mov    0x8(%ebp),%eax
  80076a:	8b 00                	mov    (%eax),%eax
  80076c:	83 e8 04             	sub    $0x4,%eax
  80076f:	8b 00                	mov    (%eax),%eax
  800771:	99                   	cltd   
  800772:	eb 18                	jmp    80078c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800774:	8b 45 08             	mov    0x8(%ebp),%eax
  800777:	8b 00                	mov    (%eax),%eax
  800779:	8d 50 04             	lea    0x4(%eax),%edx
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	89 10                	mov    %edx,(%eax)
  800781:	8b 45 08             	mov    0x8(%ebp),%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	83 e8 04             	sub    $0x4,%eax
  800789:	8b 00                	mov    (%eax),%eax
  80078b:	99                   	cltd   
}
  80078c:	5d                   	pop    %ebp
  80078d:	c3                   	ret    

0080078e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80078e:	55                   	push   %ebp
  80078f:	89 e5                	mov    %esp,%ebp
  800791:	56                   	push   %esi
  800792:	53                   	push   %ebx
  800793:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800796:	eb 17                	jmp    8007af <vprintfmt+0x21>
			if (ch == '\0')
  800798:	85 db                	test   %ebx,%ebx
  80079a:	0f 84 c1 03 00 00    	je     800b61 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	ff 75 0c             	pushl  0xc(%ebp)
  8007a6:	53                   	push   %ebx
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	ff d0                	call   *%eax
  8007ac:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007af:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b2:	8d 50 01             	lea    0x1(%eax),%edx
  8007b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8007b8:	8a 00                	mov    (%eax),%al
  8007ba:	0f b6 d8             	movzbl %al,%ebx
  8007bd:	83 fb 25             	cmp    $0x25,%ebx
  8007c0:	75 d6                	jne    800798 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007c2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007c6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007cd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007d4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007db:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e5:	8d 50 01             	lea    0x1(%eax),%edx
  8007e8:	89 55 10             	mov    %edx,0x10(%ebp)
  8007eb:	8a 00                	mov    (%eax),%al
  8007ed:	0f b6 d8             	movzbl %al,%ebx
  8007f0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007f3:	83 f8 5b             	cmp    $0x5b,%eax
  8007f6:	0f 87 3d 03 00 00    	ja     800b39 <vprintfmt+0x3ab>
  8007fc:	8b 04 85 98 22 80 00 	mov    0x802298(,%eax,4),%eax
  800803:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800805:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800809:	eb d7                	jmp    8007e2 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80080b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80080f:	eb d1                	jmp    8007e2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800811:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800818:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80081b:	89 d0                	mov    %edx,%eax
  80081d:	c1 e0 02             	shl    $0x2,%eax
  800820:	01 d0                	add    %edx,%eax
  800822:	01 c0                	add    %eax,%eax
  800824:	01 d8                	add    %ebx,%eax
  800826:	83 e8 30             	sub    $0x30,%eax
  800829:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80082c:	8b 45 10             	mov    0x10(%ebp),%eax
  80082f:	8a 00                	mov    (%eax),%al
  800831:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800834:	83 fb 2f             	cmp    $0x2f,%ebx
  800837:	7e 3e                	jle    800877 <vprintfmt+0xe9>
  800839:	83 fb 39             	cmp    $0x39,%ebx
  80083c:	7f 39                	jg     800877 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80083e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800841:	eb d5                	jmp    800818 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800843:	8b 45 14             	mov    0x14(%ebp),%eax
  800846:	83 c0 04             	add    $0x4,%eax
  800849:	89 45 14             	mov    %eax,0x14(%ebp)
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	83 e8 04             	sub    $0x4,%eax
  800852:	8b 00                	mov    (%eax),%eax
  800854:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800857:	eb 1f                	jmp    800878 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800859:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80085d:	79 83                	jns    8007e2 <vprintfmt+0x54>
				width = 0;
  80085f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800866:	e9 77 ff ff ff       	jmp    8007e2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80086b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800872:	e9 6b ff ff ff       	jmp    8007e2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800877:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800878:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80087c:	0f 89 60 ff ff ff    	jns    8007e2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800882:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800885:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800888:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80088f:	e9 4e ff ff ff       	jmp    8007e2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800894:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800897:	e9 46 ff ff ff       	jmp    8007e2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	83 c0 04             	add    $0x4,%eax
  8008a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	83 e8 04             	sub    $0x4,%eax
  8008ab:	8b 00                	mov    (%eax),%eax
  8008ad:	83 ec 08             	sub    $0x8,%esp
  8008b0:	ff 75 0c             	pushl  0xc(%ebp)
  8008b3:	50                   	push   %eax
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	ff d0                	call   *%eax
  8008b9:	83 c4 10             	add    $0x10,%esp
			break;
  8008bc:	e9 9b 02 00 00       	jmp    800b5c <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c4:	83 c0 04             	add    $0x4,%eax
  8008c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cd:	83 e8 04             	sub    $0x4,%eax
  8008d0:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008d2:	85 db                	test   %ebx,%ebx
  8008d4:	79 02                	jns    8008d8 <vprintfmt+0x14a>
				err = -err;
  8008d6:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008d8:	83 fb 64             	cmp    $0x64,%ebx
  8008db:	7f 0b                	jg     8008e8 <vprintfmt+0x15a>
  8008dd:	8b 34 9d e0 20 80 00 	mov    0x8020e0(,%ebx,4),%esi
  8008e4:	85 f6                	test   %esi,%esi
  8008e6:	75 19                	jne    800901 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008e8:	53                   	push   %ebx
  8008e9:	68 85 22 80 00       	push   $0x802285
  8008ee:	ff 75 0c             	pushl  0xc(%ebp)
  8008f1:	ff 75 08             	pushl  0x8(%ebp)
  8008f4:	e8 70 02 00 00       	call   800b69 <printfmt>
  8008f9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008fc:	e9 5b 02 00 00       	jmp    800b5c <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800901:	56                   	push   %esi
  800902:	68 8e 22 80 00       	push   $0x80228e
  800907:	ff 75 0c             	pushl  0xc(%ebp)
  80090a:	ff 75 08             	pushl  0x8(%ebp)
  80090d:	e8 57 02 00 00       	call   800b69 <printfmt>
  800912:	83 c4 10             	add    $0x10,%esp
			break;
  800915:	e9 42 02 00 00       	jmp    800b5c <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80091a:	8b 45 14             	mov    0x14(%ebp),%eax
  80091d:	83 c0 04             	add    $0x4,%eax
  800920:	89 45 14             	mov    %eax,0x14(%ebp)
  800923:	8b 45 14             	mov    0x14(%ebp),%eax
  800926:	83 e8 04             	sub    $0x4,%eax
  800929:	8b 30                	mov    (%eax),%esi
  80092b:	85 f6                	test   %esi,%esi
  80092d:	75 05                	jne    800934 <vprintfmt+0x1a6>
				p = "(null)";
  80092f:	be 91 22 80 00       	mov    $0x802291,%esi
			if (width > 0 && padc != '-')
  800934:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800938:	7e 6d                	jle    8009a7 <vprintfmt+0x219>
  80093a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80093e:	74 67                	je     8009a7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800940:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800943:	83 ec 08             	sub    $0x8,%esp
  800946:	50                   	push   %eax
  800947:	56                   	push   %esi
  800948:	e8 1e 03 00 00       	call   800c6b <strnlen>
  80094d:	83 c4 10             	add    $0x10,%esp
  800950:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800953:	eb 16                	jmp    80096b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800955:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800959:	83 ec 08             	sub    $0x8,%esp
  80095c:	ff 75 0c             	pushl  0xc(%ebp)
  80095f:	50                   	push   %eax
  800960:	8b 45 08             	mov    0x8(%ebp),%eax
  800963:	ff d0                	call   *%eax
  800965:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800968:	ff 4d e4             	decl   -0x1c(%ebp)
  80096b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096f:	7f e4                	jg     800955 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800971:	eb 34                	jmp    8009a7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800973:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800977:	74 1c                	je     800995 <vprintfmt+0x207>
  800979:	83 fb 1f             	cmp    $0x1f,%ebx
  80097c:	7e 05                	jle    800983 <vprintfmt+0x1f5>
  80097e:	83 fb 7e             	cmp    $0x7e,%ebx
  800981:	7e 12                	jle    800995 <vprintfmt+0x207>
					putch('?', putdat);
  800983:	83 ec 08             	sub    $0x8,%esp
  800986:	ff 75 0c             	pushl  0xc(%ebp)
  800989:	6a 3f                	push   $0x3f
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	ff d0                	call   *%eax
  800990:	83 c4 10             	add    $0x10,%esp
  800993:	eb 0f                	jmp    8009a4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800995:	83 ec 08             	sub    $0x8,%esp
  800998:	ff 75 0c             	pushl  0xc(%ebp)
  80099b:	53                   	push   %ebx
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	ff d0                	call   *%eax
  8009a1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a4:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a7:	89 f0                	mov    %esi,%eax
  8009a9:	8d 70 01             	lea    0x1(%eax),%esi
  8009ac:	8a 00                	mov    (%eax),%al
  8009ae:	0f be d8             	movsbl %al,%ebx
  8009b1:	85 db                	test   %ebx,%ebx
  8009b3:	74 24                	je     8009d9 <vprintfmt+0x24b>
  8009b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009b9:	78 b8                	js     800973 <vprintfmt+0x1e5>
  8009bb:	ff 4d e0             	decl   -0x20(%ebp)
  8009be:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009c2:	79 af                	jns    800973 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009c4:	eb 13                	jmp    8009d9 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009c6:	83 ec 08             	sub    $0x8,%esp
  8009c9:	ff 75 0c             	pushl  0xc(%ebp)
  8009cc:	6a 20                	push   $0x20
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	ff d0                	call   *%eax
  8009d3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009d6:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009dd:	7f e7                	jg     8009c6 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009df:	e9 78 01 00 00       	jmp    800b5c <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009e4:	83 ec 08             	sub    $0x8,%esp
  8009e7:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ea:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ed:	50                   	push   %eax
  8009ee:	e8 3c fd ff ff       	call   80072f <getint>
  8009f3:	83 c4 10             	add    $0x10,%esp
  8009f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a02:	85 d2                	test   %edx,%edx
  800a04:	79 23                	jns    800a29 <vprintfmt+0x29b>
				putch('-', putdat);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	ff 75 0c             	pushl  0xc(%ebp)
  800a0c:	6a 2d                	push   $0x2d
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	ff d0                	call   *%eax
  800a13:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a1c:	f7 d8                	neg    %eax
  800a1e:	83 d2 00             	adc    $0x0,%edx
  800a21:	f7 da                	neg    %edx
  800a23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a26:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a29:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a30:	e9 bc 00 00 00       	jmp    800af1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a35:	83 ec 08             	sub    $0x8,%esp
  800a38:	ff 75 e8             	pushl  -0x18(%ebp)
  800a3b:	8d 45 14             	lea    0x14(%ebp),%eax
  800a3e:	50                   	push   %eax
  800a3f:	e8 84 fc ff ff       	call   8006c8 <getuint>
  800a44:	83 c4 10             	add    $0x10,%esp
  800a47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a4d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a54:	e9 98 00 00 00       	jmp    800af1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a59:	83 ec 08             	sub    $0x8,%esp
  800a5c:	ff 75 0c             	pushl  0xc(%ebp)
  800a5f:	6a 58                	push   $0x58
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	ff d0                	call   *%eax
  800a66:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a69:	83 ec 08             	sub    $0x8,%esp
  800a6c:	ff 75 0c             	pushl  0xc(%ebp)
  800a6f:	6a 58                	push   $0x58
  800a71:	8b 45 08             	mov    0x8(%ebp),%eax
  800a74:	ff d0                	call   *%eax
  800a76:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a79:	83 ec 08             	sub    $0x8,%esp
  800a7c:	ff 75 0c             	pushl  0xc(%ebp)
  800a7f:	6a 58                	push   $0x58
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	ff d0                	call   *%eax
  800a86:	83 c4 10             	add    $0x10,%esp
			break;
  800a89:	e9 ce 00 00 00       	jmp    800b5c <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	6a 30                	push   $0x30
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	ff d0                	call   *%eax
  800a9b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a9e:	83 ec 08             	sub    $0x8,%esp
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	6a 78                	push   $0x78
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800aae:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab1:	83 c0 04             	add    $0x4,%eax
  800ab4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aba:	83 e8 04             	sub    $0x4,%eax
  800abd:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800abf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ac9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ad0:	eb 1f                	jmp    800af1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ad2:	83 ec 08             	sub    $0x8,%esp
  800ad5:	ff 75 e8             	pushl  -0x18(%ebp)
  800ad8:	8d 45 14             	lea    0x14(%ebp),%eax
  800adb:	50                   	push   %eax
  800adc:	e8 e7 fb ff ff       	call   8006c8 <getuint>
  800ae1:	83 c4 10             	add    $0x10,%esp
  800ae4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aea:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800af1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800af5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800af8:	83 ec 04             	sub    $0x4,%esp
  800afb:	52                   	push   %edx
  800afc:	ff 75 e4             	pushl  -0x1c(%ebp)
  800aff:	50                   	push   %eax
  800b00:	ff 75 f4             	pushl  -0xc(%ebp)
  800b03:	ff 75 f0             	pushl  -0x10(%ebp)
  800b06:	ff 75 0c             	pushl  0xc(%ebp)
  800b09:	ff 75 08             	pushl  0x8(%ebp)
  800b0c:	e8 00 fb ff ff       	call   800611 <printnum>
  800b11:	83 c4 20             	add    $0x20,%esp
			break;
  800b14:	eb 46                	jmp    800b5c <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b16:	83 ec 08             	sub    $0x8,%esp
  800b19:	ff 75 0c             	pushl  0xc(%ebp)
  800b1c:	53                   	push   %ebx
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	ff d0                	call   *%eax
  800b22:	83 c4 10             	add    $0x10,%esp
			break;
  800b25:	eb 35                	jmp    800b5c <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b27:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b2e:	eb 2c                	jmp    800b5c <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b30:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b37:	eb 23                	jmp    800b5c <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b39:	83 ec 08             	sub    $0x8,%esp
  800b3c:	ff 75 0c             	pushl  0xc(%ebp)
  800b3f:	6a 25                	push   $0x25
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	ff d0                	call   *%eax
  800b46:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b49:	ff 4d 10             	decl   0x10(%ebp)
  800b4c:	eb 03                	jmp    800b51 <vprintfmt+0x3c3>
  800b4e:	ff 4d 10             	decl   0x10(%ebp)
  800b51:	8b 45 10             	mov    0x10(%ebp),%eax
  800b54:	48                   	dec    %eax
  800b55:	8a 00                	mov    (%eax),%al
  800b57:	3c 25                	cmp    $0x25,%al
  800b59:	75 f3                	jne    800b4e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b5b:	90                   	nop
		}
	}
  800b5c:	e9 35 fc ff ff       	jmp    800796 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b61:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b65:	5b                   	pop    %ebx
  800b66:	5e                   	pop    %esi
  800b67:	5d                   	pop    %ebp
  800b68:	c3                   	ret    

00800b69 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b69:	55                   	push   %ebp
  800b6a:	89 e5                	mov    %esp,%ebp
  800b6c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b6f:	8d 45 10             	lea    0x10(%ebp),%eax
  800b72:	83 c0 04             	add    $0x4,%eax
  800b75:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b78:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b7e:	50                   	push   %eax
  800b7f:	ff 75 0c             	pushl  0xc(%ebp)
  800b82:	ff 75 08             	pushl  0x8(%ebp)
  800b85:	e8 04 fc ff ff       	call   80078e <vprintfmt>
  800b8a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b8d:	90                   	nop
  800b8e:	c9                   	leave  
  800b8f:	c3                   	ret    

00800b90 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b96:	8b 40 08             	mov    0x8(%eax),%eax
  800b99:	8d 50 01             	lea    0x1(%eax),%edx
  800b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ba2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba5:	8b 10                	mov    (%eax),%edx
  800ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800baa:	8b 40 04             	mov    0x4(%eax),%eax
  800bad:	39 c2                	cmp    %eax,%edx
  800baf:	73 12                	jae    800bc3 <sprintputch+0x33>
		*b->buf++ = ch;
  800bb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb4:	8b 00                	mov    (%eax),%eax
  800bb6:	8d 48 01             	lea    0x1(%eax),%ecx
  800bb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbc:	89 0a                	mov    %ecx,(%edx)
  800bbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc1:	88 10                	mov    %dl,(%eax)
}
  800bc3:	90                   	nop
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    

00800bc6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	01 d0                	add    %edx,%eax
  800bdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800be7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800beb:	74 06                	je     800bf3 <vsnprintf+0x2d>
  800bed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf1:	7f 07                	jg     800bfa <vsnprintf+0x34>
		return -E_INVAL;
  800bf3:	b8 03 00 00 00       	mov    $0x3,%eax
  800bf8:	eb 20                	jmp    800c1a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bfa:	ff 75 14             	pushl  0x14(%ebp)
  800bfd:	ff 75 10             	pushl  0x10(%ebp)
  800c00:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c03:	50                   	push   %eax
  800c04:	68 90 0b 80 00       	push   $0x800b90
  800c09:	e8 80 fb ff ff       	call   80078e <vprintfmt>
  800c0e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c14:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c1a:	c9                   	leave  
  800c1b:	c3                   	ret    

00800c1c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c22:	8d 45 10             	lea    0x10(%ebp),%eax
  800c25:	83 c0 04             	add    $0x4,%eax
  800c28:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c31:	50                   	push   %eax
  800c32:	ff 75 0c             	pushl  0xc(%ebp)
  800c35:	ff 75 08             	pushl  0x8(%ebp)
  800c38:	e8 89 ff ff ff       	call   800bc6 <vsnprintf>
  800c3d:	83 c4 10             	add    $0x10,%esp
  800c40:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c46:	c9                   	leave  
  800c47:	c3                   	ret    

00800c48 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c55:	eb 06                	jmp    800c5d <strlen+0x15>
		n++;
  800c57:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c5a:	ff 45 08             	incl   0x8(%ebp)
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	8a 00                	mov    (%eax),%al
  800c62:	84 c0                	test   %al,%al
  800c64:	75 f1                	jne    800c57 <strlen+0xf>
		n++;
	return n;
  800c66:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c69:	c9                   	leave  
  800c6a:	c3                   	ret    

00800c6b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c78:	eb 09                	jmp    800c83 <strnlen+0x18>
		n++;
  800c7a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c7d:	ff 45 08             	incl   0x8(%ebp)
  800c80:	ff 4d 0c             	decl   0xc(%ebp)
  800c83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c87:	74 09                	je     800c92 <strnlen+0x27>
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	8a 00                	mov    (%eax),%al
  800c8e:	84 c0                	test   %al,%al
  800c90:	75 e8                	jne    800c7a <strnlen+0xf>
		n++;
	return n;
  800c92:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c95:	c9                   	leave  
  800c96:	c3                   	ret    

00800c97 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ca3:	90                   	nop
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	8d 50 01             	lea    0x1(%eax),%edx
  800caa:	89 55 08             	mov    %edx,0x8(%ebp)
  800cad:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cb3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cb6:	8a 12                	mov    (%edx),%dl
  800cb8:	88 10                	mov    %dl,(%eax)
  800cba:	8a 00                	mov    (%eax),%al
  800cbc:	84 c0                	test   %al,%al
  800cbe:	75 e4                	jne    800ca4 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc3:	c9                   	leave  
  800cc4:	c3                   	ret    

00800cc5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cd1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd8:	eb 1f                	jmp    800cf9 <strncpy+0x34>
		*dst++ = *src;
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	8d 50 01             	lea    0x1(%eax),%edx
  800ce0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce6:	8a 12                	mov    (%edx),%dl
  800ce8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ced:	8a 00                	mov    (%eax),%al
  800cef:	84 c0                	test   %al,%al
  800cf1:	74 03                	je     800cf6 <strncpy+0x31>
			src++;
  800cf3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cf6:	ff 45 fc             	incl   -0x4(%ebp)
  800cf9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cfc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cff:	72 d9                	jb     800cda <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d01:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d04:	c9                   	leave  
  800d05:	c3                   	ret    

00800d06 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d16:	74 30                	je     800d48 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d18:	eb 16                	jmp    800d30 <strlcpy+0x2a>
			*dst++ = *src++;
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8d 50 01             	lea    0x1(%eax),%edx
  800d20:	89 55 08             	mov    %edx,0x8(%ebp)
  800d23:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d26:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d29:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d2c:	8a 12                	mov    (%edx),%dl
  800d2e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d30:	ff 4d 10             	decl   0x10(%ebp)
  800d33:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d37:	74 09                	je     800d42 <strlcpy+0x3c>
  800d39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	84 c0                	test   %al,%al
  800d40:	75 d8                	jne    800d1a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d48:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4e:	29 c2                	sub    %eax,%edx
  800d50:	89 d0                	mov    %edx,%eax
}
  800d52:	c9                   	leave  
  800d53:	c3                   	ret    

00800d54 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d57:	eb 06                	jmp    800d5f <strcmp+0xb>
		p++, q++;
  800d59:	ff 45 08             	incl   0x8(%ebp)
  800d5c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	84 c0                	test   %al,%al
  800d66:	74 0e                	je     800d76 <strcmp+0x22>
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 10                	mov    (%eax),%dl
  800d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d70:	8a 00                	mov    (%eax),%al
  800d72:	38 c2                	cmp    %al,%dl
  800d74:	74 e3                	je     800d59 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8a 00                	mov    (%eax),%al
  800d7b:	0f b6 d0             	movzbl %al,%edx
  800d7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d81:	8a 00                	mov    (%eax),%al
  800d83:	0f b6 c0             	movzbl %al,%eax
  800d86:	29 c2                	sub    %eax,%edx
  800d88:	89 d0                	mov    %edx,%eax
}
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    

00800d8c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d8f:	eb 09                	jmp    800d9a <strncmp+0xe>
		n--, p++, q++;
  800d91:	ff 4d 10             	decl   0x10(%ebp)
  800d94:	ff 45 08             	incl   0x8(%ebp)
  800d97:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d9e:	74 17                	je     800db7 <strncmp+0x2b>
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	8a 00                	mov    (%eax),%al
  800da5:	84 c0                	test   %al,%al
  800da7:	74 0e                	je     800db7 <strncmp+0x2b>
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	8a 10                	mov    (%eax),%dl
  800dae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db1:	8a 00                	mov    (%eax),%al
  800db3:	38 c2                	cmp    %al,%dl
  800db5:	74 da                	je     800d91 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800db7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbb:	75 07                	jne    800dc4 <strncmp+0x38>
		return 0;
  800dbd:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc2:	eb 14                	jmp    800dd8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8a 00                	mov    (%eax),%al
  800dc9:	0f b6 d0             	movzbl %al,%edx
  800dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcf:	8a 00                	mov    (%eax),%al
  800dd1:	0f b6 c0             	movzbl %al,%eax
  800dd4:	29 c2                	sub    %eax,%edx
  800dd6:	89 d0                	mov    %edx,%eax
}
  800dd8:	5d                   	pop    %ebp
  800dd9:	c3                   	ret    

00800dda <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	83 ec 04             	sub    $0x4,%esp
  800de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800de6:	eb 12                	jmp    800dfa <strchr+0x20>
		if (*s == c)
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	8a 00                	mov    (%eax),%al
  800ded:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df0:	75 05                	jne    800df7 <strchr+0x1d>
			return (char *) s;
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	eb 11                	jmp    800e08 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800df7:	ff 45 08             	incl   0x8(%ebp)
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	8a 00                	mov    (%eax),%al
  800dff:	84 c0                	test   %al,%al
  800e01:	75 e5                	jne    800de8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e08:	c9                   	leave  
  800e09:	c3                   	ret    

00800e0a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	83 ec 04             	sub    $0x4,%esp
  800e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e13:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e16:	eb 0d                	jmp    800e25 <strfind+0x1b>
		if (*s == c)
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1b:	8a 00                	mov    (%eax),%al
  800e1d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e20:	74 0e                	je     800e30 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e22:	ff 45 08             	incl   0x8(%ebp)
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	8a 00                	mov    (%eax),%al
  800e2a:	84 c0                	test   %al,%al
  800e2c:	75 ea                	jne    800e18 <strfind+0xe>
  800e2e:	eb 01                	jmp    800e31 <strfind+0x27>
		if (*s == c)
			break;
  800e30:	90                   	nop
	return (char *) s;
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e34:	c9                   	leave  
  800e35:	c3                   	ret    

00800e36 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e42:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e46:	76 63                	jbe    800eab <memset+0x75>
		uint64 data_block = c;
  800e48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4b:	99                   	cltd   
  800e4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e4f:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e58:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e5c:	c1 e0 08             	shl    $0x8,%eax
  800e5f:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e62:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e6b:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e6f:	c1 e0 10             	shl    $0x10,%eax
  800e72:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e75:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e7e:	89 c2                	mov    %eax,%edx
  800e80:	b8 00 00 00 00       	mov    $0x0,%eax
  800e85:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e88:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e8b:	eb 18                	jmp    800ea5 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e8d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e90:	8d 41 08             	lea    0x8(%ecx),%eax
  800e93:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9c:	89 01                	mov    %eax,(%ecx)
  800e9e:	89 51 04             	mov    %edx,0x4(%ecx)
  800ea1:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ea5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ea9:	77 e2                	ja     800e8d <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800eab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eaf:	74 23                	je     800ed4 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800eb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eb7:	eb 0e                	jmp    800ec7 <memset+0x91>
			*p8++ = (uint8)c;
  800eb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebc:	8d 50 01             	lea    0x1(%eax),%edx
  800ebf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ec2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec5:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800ec7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eca:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ecd:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed0:	85 c0                	test   %eax,%eax
  800ed2:	75 e5                	jne    800eb9 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800ed4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed7:	c9                   	leave  
  800ed8:	c3                   	ret    

00800ed9 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800edf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800eeb:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800eef:	76 24                	jbe    800f15 <memcpy+0x3c>
		while(n >= 8){
  800ef1:	eb 1c                	jmp    800f0f <memcpy+0x36>
			*d64 = *s64;
  800ef3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef6:	8b 50 04             	mov    0x4(%eax),%edx
  800ef9:	8b 00                	mov    (%eax),%eax
  800efb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800efe:	89 01                	mov    %eax,(%ecx)
  800f00:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f03:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f07:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f0b:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f0f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f13:	77 de                	ja     800ef3 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f19:	74 31                	je     800f4c <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f21:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f24:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f27:	eb 16                	jmp    800f3f <memcpy+0x66>
			*d8++ = *s8++;
  800f29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f2c:	8d 50 01             	lea    0x1(%eax),%edx
  800f2f:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f35:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f38:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f3b:	8a 12                	mov    (%edx),%dl
  800f3d:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f42:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f45:	89 55 10             	mov    %edx,0x10(%ebp)
  800f48:	85 c0                	test   %eax,%eax
  800f4a:	75 dd                	jne    800f29 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f4f:	c9                   	leave  
  800f50:	c3                   	ret    

00800f51 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f60:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f66:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f69:	73 50                	jae    800fbb <memmove+0x6a>
  800f6b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f71:	01 d0                	add    %edx,%eax
  800f73:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f76:	76 43                	jbe    800fbb <memmove+0x6a>
		s += n;
  800f78:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f81:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f84:	eb 10                	jmp    800f96 <memmove+0x45>
			*--d = *--s;
  800f86:	ff 4d f8             	decl   -0x8(%ebp)
  800f89:	ff 4d fc             	decl   -0x4(%ebp)
  800f8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f8f:	8a 10                	mov    (%eax),%dl
  800f91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f94:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f96:	8b 45 10             	mov    0x10(%ebp),%eax
  800f99:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f9c:	89 55 10             	mov    %edx,0x10(%ebp)
  800f9f:	85 c0                	test   %eax,%eax
  800fa1:	75 e3                	jne    800f86 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fa3:	eb 23                	jmp    800fc8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fa5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa8:	8d 50 01             	lea    0x1(%eax),%edx
  800fab:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fb4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fb7:	8a 12                	mov    (%edx),%dl
  800fb9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc1:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc4:	85 c0                	test   %eax,%eax
  800fc6:	75 dd                	jne    800fa5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fcb:	c9                   	leave  
  800fcc:	c3                   	ret    

00800fcd <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
  800fd0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fdf:	eb 2a                	jmp    80100b <memcmp+0x3e>
		if (*s1 != *s2)
  800fe1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe4:	8a 10                	mov    (%eax),%dl
  800fe6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	38 c2                	cmp    %al,%dl
  800fed:	74 16                	je     801005 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	0f b6 d0             	movzbl %al,%edx
  800ff7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ffa:	8a 00                	mov    (%eax),%al
  800ffc:	0f b6 c0             	movzbl %al,%eax
  800fff:	29 c2                	sub    %eax,%edx
  801001:	89 d0                	mov    %edx,%eax
  801003:	eb 18                	jmp    80101d <memcmp+0x50>
		s1++, s2++;
  801005:	ff 45 fc             	incl   -0x4(%ebp)
  801008:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80100b:	8b 45 10             	mov    0x10(%ebp),%eax
  80100e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801011:	89 55 10             	mov    %edx,0x10(%ebp)
  801014:	85 c0                	test   %eax,%eax
  801016:	75 c9                	jne    800fe1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801018:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80101d:	c9                   	leave  
  80101e:	c3                   	ret    

0080101f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
  801022:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801025:	8b 55 08             	mov    0x8(%ebp),%edx
  801028:	8b 45 10             	mov    0x10(%ebp),%eax
  80102b:	01 d0                	add    %edx,%eax
  80102d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801030:	eb 15                	jmp    801047 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	0f b6 d0             	movzbl %al,%edx
  80103a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103d:	0f b6 c0             	movzbl %al,%eax
  801040:	39 c2                	cmp    %eax,%edx
  801042:	74 0d                	je     801051 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801044:	ff 45 08             	incl   0x8(%ebp)
  801047:	8b 45 08             	mov    0x8(%ebp),%eax
  80104a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80104d:	72 e3                	jb     801032 <memfind+0x13>
  80104f:	eb 01                	jmp    801052 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801051:	90                   	nop
	return (void *) s;
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801055:	c9                   	leave  
  801056:	c3                   	ret    

00801057 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80105d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801064:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80106b:	eb 03                	jmp    801070 <strtol+0x19>
		s++;
  80106d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	8a 00                	mov    (%eax),%al
  801075:	3c 20                	cmp    $0x20,%al
  801077:	74 f4                	je     80106d <strtol+0x16>
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	8a 00                	mov    (%eax),%al
  80107e:	3c 09                	cmp    $0x9,%al
  801080:	74 eb                	je     80106d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	3c 2b                	cmp    $0x2b,%al
  801089:	75 05                	jne    801090 <strtol+0x39>
		s++;
  80108b:	ff 45 08             	incl   0x8(%ebp)
  80108e:	eb 13                	jmp    8010a3 <strtol+0x4c>
	else if (*s == '-')
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	8a 00                	mov    (%eax),%al
  801095:	3c 2d                	cmp    $0x2d,%al
  801097:	75 0a                	jne    8010a3 <strtol+0x4c>
		s++, neg = 1;
  801099:	ff 45 08             	incl   0x8(%ebp)
  80109c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a7:	74 06                	je     8010af <strtol+0x58>
  8010a9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010ad:	75 20                	jne    8010cf <strtol+0x78>
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	8a 00                	mov    (%eax),%al
  8010b4:	3c 30                	cmp    $0x30,%al
  8010b6:	75 17                	jne    8010cf <strtol+0x78>
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	40                   	inc    %eax
  8010bc:	8a 00                	mov    (%eax),%al
  8010be:	3c 78                	cmp    $0x78,%al
  8010c0:	75 0d                	jne    8010cf <strtol+0x78>
		s += 2, base = 16;
  8010c2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010c6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010cd:	eb 28                	jmp    8010f7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d3:	75 15                	jne    8010ea <strtol+0x93>
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	3c 30                	cmp    $0x30,%al
  8010dc:	75 0c                	jne    8010ea <strtol+0x93>
		s++, base = 8;
  8010de:	ff 45 08             	incl   0x8(%ebp)
  8010e1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010e8:	eb 0d                	jmp    8010f7 <strtol+0xa0>
	else if (base == 0)
  8010ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ee:	75 07                	jne    8010f7 <strtol+0xa0>
		base = 10;
  8010f0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fa:	8a 00                	mov    (%eax),%al
  8010fc:	3c 2f                	cmp    $0x2f,%al
  8010fe:	7e 19                	jle    801119 <strtol+0xc2>
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	3c 39                	cmp    $0x39,%al
  801107:	7f 10                	jg     801119 <strtol+0xc2>
			dig = *s - '0';
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	8a 00                	mov    (%eax),%al
  80110e:	0f be c0             	movsbl %al,%eax
  801111:	83 e8 30             	sub    $0x30,%eax
  801114:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801117:	eb 42                	jmp    80115b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
  80111c:	8a 00                	mov    (%eax),%al
  80111e:	3c 60                	cmp    $0x60,%al
  801120:	7e 19                	jle    80113b <strtol+0xe4>
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	8a 00                	mov    (%eax),%al
  801127:	3c 7a                	cmp    $0x7a,%al
  801129:	7f 10                	jg     80113b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	8a 00                	mov    (%eax),%al
  801130:	0f be c0             	movsbl %al,%eax
  801133:	83 e8 57             	sub    $0x57,%eax
  801136:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801139:	eb 20                	jmp    80115b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	8a 00                	mov    (%eax),%al
  801140:	3c 40                	cmp    $0x40,%al
  801142:	7e 39                	jle    80117d <strtol+0x126>
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	8a 00                	mov    (%eax),%al
  801149:	3c 5a                	cmp    $0x5a,%al
  80114b:	7f 30                	jg     80117d <strtol+0x126>
			dig = *s - 'A' + 10;
  80114d:	8b 45 08             	mov    0x8(%ebp),%eax
  801150:	8a 00                	mov    (%eax),%al
  801152:	0f be c0             	movsbl %al,%eax
  801155:	83 e8 37             	sub    $0x37,%eax
  801158:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80115b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80115e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801161:	7d 19                	jge    80117c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801163:	ff 45 08             	incl   0x8(%ebp)
  801166:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801169:	0f af 45 10          	imul   0x10(%ebp),%eax
  80116d:	89 c2                	mov    %eax,%edx
  80116f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801172:	01 d0                	add    %edx,%eax
  801174:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801177:	e9 7b ff ff ff       	jmp    8010f7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80117c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80117d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801181:	74 08                	je     80118b <strtol+0x134>
		*endptr = (char *) s;
  801183:	8b 45 0c             	mov    0xc(%ebp),%eax
  801186:	8b 55 08             	mov    0x8(%ebp),%edx
  801189:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80118b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80118f:	74 07                	je     801198 <strtol+0x141>
  801191:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801194:	f7 d8                	neg    %eax
  801196:	eb 03                	jmp    80119b <strtol+0x144>
  801198:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80119b:	c9                   	leave  
  80119c:	c3                   	ret    

0080119d <ltostr>:

void
ltostr(long value, char *str)
{
  80119d:	55                   	push   %ebp
  80119e:	89 e5                	mov    %esp,%ebp
  8011a0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011b5:	79 13                	jns    8011ca <ltostr+0x2d>
	{
		neg = 1;
  8011b7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011c4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011c7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011d2:	99                   	cltd   
  8011d3:	f7 f9                	idiv   %ecx
  8011d5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011db:	8d 50 01             	lea    0x1(%eax),%edx
  8011de:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011e1:	89 c2                	mov    %eax,%edx
  8011e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e6:	01 d0                	add    %edx,%eax
  8011e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011eb:	83 c2 30             	add    $0x30,%edx
  8011ee:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011f3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011f8:	f7 e9                	imul   %ecx
  8011fa:	c1 fa 02             	sar    $0x2,%edx
  8011fd:	89 c8                	mov    %ecx,%eax
  8011ff:	c1 f8 1f             	sar    $0x1f,%eax
  801202:	29 c2                	sub    %eax,%edx
  801204:	89 d0                	mov    %edx,%eax
  801206:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801209:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80120d:	75 bb                	jne    8011ca <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80120f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801216:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801219:	48                   	dec    %eax
  80121a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80121d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801221:	74 3d                	je     801260 <ltostr+0xc3>
		start = 1 ;
  801223:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80122a:	eb 34                	jmp    801260 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80122c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801232:	01 d0                	add    %edx,%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801239:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80123c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123f:	01 c2                	add    %eax,%edx
  801241:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801244:	8b 45 0c             	mov    0xc(%ebp),%eax
  801247:	01 c8                	add    %ecx,%eax
  801249:	8a 00                	mov    (%eax),%al
  80124b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80124d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801250:	8b 45 0c             	mov    0xc(%ebp),%eax
  801253:	01 c2                	add    %eax,%edx
  801255:	8a 45 eb             	mov    -0x15(%ebp),%al
  801258:	88 02                	mov    %al,(%edx)
		start++ ;
  80125a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80125d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801263:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801266:	7c c4                	jl     80122c <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801268:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80126b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126e:	01 d0                	add    %edx,%eax
  801270:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801273:	90                   	nop
  801274:	c9                   	leave  
  801275:	c3                   	ret    

00801276 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801276:	55                   	push   %ebp
  801277:	89 e5                	mov    %esp,%ebp
  801279:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80127c:	ff 75 08             	pushl  0x8(%ebp)
  80127f:	e8 c4 f9 ff ff       	call   800c48 <strlen>
  801284:	83 c4 04             	add    $0x4,%esp
  801287:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80128a:	ff 75 0c             	pushl  0xc(%ebp)
  80128d:	e8 b6 f9 ff ff       	call   800c48 <strlen>
  801292:	83 c4 04             	add    $0x4,%esp
  801295:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801298:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80129f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012a6:	eb 17                	jmp    8012bf <strcconcat+0x49>
		final[s] = str1[s] ;
  8012a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ae:	01 c2                	add    %eax,%edx
  8012b0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b6:	01 c8                	add    %ecx,%eax
  8012b8:	8a 00                	mov    (%eax),%al
  8012ba:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012bc:	ff 45 fc             	incl   -0x4(%ebp)
  8012bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012c5:	7c e1                	jl     8012a8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012c7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012ce:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012d5:	eb 1f                	jmp    8012f6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012da:	8d 50 01             	lea    0x1(%eax),%edx
  8012dd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012e0:	89 c2                	mov    %eax,%edx
  8012e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e5:	01 c2                	add    %eax,%edx
  8012e7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ed:	01 c8                	add    %ecx,%eax
  8012ef:	8a 00                	mov    (%eax),%al
  8012f1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012f3:	ff 45 f8             	incl   -0x8(%ebp)
  8012f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012fc:	7c d9                	jl     8012d7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801301:	8b 45 10             	mov    0x10(%ebp),%eax
  801304:	01 d0                	add    %edx,%eax
  801306:	c6 00 00             	movb   $0x0,(%eax)
}
  801309:	90                   	nop
  80130a:	c9                   	leave  
  80130b:	c3                   	ret    

0080130c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80130f:	8b 45 14             	mov    0x14(%ebp),%eax
  801312:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801318:	8b 45 14             	mov    0x14(%ebp),%eax
  80131b:	8b 00                	mov    (%eax),%eax
  80131d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801324:	8b 45 10             	mov    0x10(%ebp),%eax
  801327:	01 d0                	add    %edx,%eax
  801329:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80132f:	eb 0c                	jmp    80133d <strsplit+0x31>
			*string++ = 0;
  801331:	8b 45 08             	mov    0x8(%ebp),%eax
  801334:	8d 50 01             	lea    0x1(%eax),%edx
  801337:	89 55 08             	mov    %edx,0x8(%ebp)
  80133a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
  801340:	8a 00                	mov    (%eax),%al
  801342:	84 c0                	test   %al,%al
  801344:	74 18                	je     80135e <strsplit+0x52>
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	8a 00                	mov    (%eax),%al
  80134b:	0f be c0             	movsbl %al,%eax
  80134e:	50                   	push   %eax
  80134f:	ff 75 0c             	pushl  0xc(%ebp)
  801352:	e8 83 fa ff ff       	call   800dda <strchr>
  801357:	83 c4 08             	add    $0x8,%esp
  80135a:	85 c0                	test   %eax,%eax
  80135c:	75 d3                	jne    801331 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	8a 00                	mov    (%eax),%al
  801363:	84 c0                	test   %al,%al
  801365:	74 5a                	je     8013c1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801367:	8b 45 14             	mov    0x14(%ebp),%eax
  80136a:	8b 00                	mov    (%eax),%eax
  80136c:	83 f8 0f             	cmp    $0xf,%eax
  80136f:	75 07                	jne    801378 <strsplit+0x6c>
		{
			return 0;
  801371:	b8 00 00 00 00       	mov    $0x0,%eax
  801376:	eb 66                	jmp    8013de <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801378:	8b 45 14             	mov    0x14(%ebp),%eax
  80137b:	8b 00                	mov    (%eax),%eax
  80137d:	8d 48 01             	lea    0x1(%eax),%ecx
  801380:	8b 55 14             	mov    0x14(%ebp),%edx
  801383:	89 0a                	mov    %ecx,(%edx)
  801385:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80138c:	8b 45 10             	mov    0x10(%ebp),%eax
  80138f:	01 c2                	add    %eax,%edx
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801396:	eb 03                	jmp    80139b <strsplit+0x8f>
			string++;
  801398:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80139b:	8b 45 08             	mov    0x8(%ebp),%eax
  80139e:	8a 00                	mov    (%eax),%al
  8013a0:	84 c0                	test   %al,%al
  8013a2:	74 8b                	je     80132f <strsplit+0x23>
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	8a 00                	mov    (%eax),%al
  8013a9:	0f be c0             	movsbl %al,%eax
  8013ac:	50                   	push   %eax
  8013ad:	ff 75 0c             	pushl  0xc(%ebp)
  8013b0:	e8 25 fa ff ff       	call   800dda <strchr>
  8013b5:	83 c4 08             	add    $0x8,%esp
  8013b8:	85 c0                	test   %eax,%eax
  8013ba:	74 dc                	je     801398 <strsplit+0x8c>
			string++;
	}
  8013bc:	e9 6e ff ff ff       	jmp    80132f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013c1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c5:	8b 00                	mov    (%eax),%eax
  8013c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d1:	01 d0                	add    %edx,%eax
  8013d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013d9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013de:	c9                   	leave  
  8013df:	c3                   	ret    

008013e0 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
  8013e3:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8013e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f3:	eb 4a                	jmp    80143f <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8013f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	01 c2                	add    %eax,%edx
  8013fd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801400:	8b 45 0c             	mov    0xc(%ebp),%eax
  801403:	01 c8                	add    %ecx,%eax
  801405:	8a 00                	mov    (%eax),%al
  801407:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801409:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80140c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140f:	01 d0                	add    %edx,%eax
  801411:	8a 00                	mov    (%eax),%al
  801413:	3c 40                	cmp    $0x40,%al
  801415:	7e 25                	jle    80143c <str2lower+0x5c>
  801417:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80141a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141d:	01 d0                	add    %edx,%eax
  80141f:	8a 00                	mov    (%eax),%al
  801421:	3c 5a                	cmp    $0x5a,%al
  801423:	7f 17                	jg     80143c <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801425:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	01 d0                	add    %edx,%eax
  80142d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801430:	8b 55 08             	mov    0x8(%ebp),%edx
  801433:	01 ca                	add    %ecx,%edx
  801435:	8a 12                	mov    (%edx),%dl
  801437:	83 c2 20             	add    $0x20,%edx
  80143a:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80143c:	ff 45 fc             	incl   -0x4(%ebp)
  80143f:	ff 75 0c             	pushl  0xc(%ebp)
  801442:	e8 01 f8 ff ff       	call   800c48 <strlen>
  801447:	83 c4 04             	add    $0x4,%esp
  80144a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80144d:	7f a6                	jg     8013f5 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80144f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801452:	c9                   	leave  
  801453:	c3                   	ret    

00801454 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
  801457:	57                   	push   %edi
  801458:	56                   	push   %esi
  801459:	53                   	push   %ebx
  80145a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	8b 55 0c             	mov    0xc(%ebp),%edx
  801463:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801466:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801469:	8b 7d 18             	mov    0x18(%ebp),%edi
  80146c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80146f:	cd 30                	int    $0x30
  801471:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801474:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801477:	83 c4 10             	add    $0x10,%esp
  80147a:	5b                   	pop    %ebx
  80147b:	5e                   	pop    %esi
  80147c:	5f                   	pop    %edi
  80147d:	5d                   	pop    %ebp
  80147e:	c3                   	ret    

0080147f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
  801482:	83 ec 04             	sub    $0x4,%esp
  801485:	8b 45 10             	mov    0x10(%ebp),%eax
  801488:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80148b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80148e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	6a 00                	push   $0x0
  801497:	51                   	push   %ecx
  801498:	52                   	push   %edx
  801499:	ff 75 0c             	pushl  0xc(%ebp)
  80149c:	50                   	push   %eax
  80149d:	6a 00                	push   $0x0
  80149f:	e8 b0 ff ff ff       	call   801454 <syscall>
  8014a4:	83 c4 18             	add    $0x18,%esp
}
  8014a7:	90                   	nop
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <sys_cgetc>:

int
sys_cgetc(void)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 02                	push   $0x2
  8014b9:	e8 96 ff ff ff       	call   801454 <syscall>
  8014be:	83 c4 18             	add    $0x18,%esp
}
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    

008014c3 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 03                	push   $0x3
  8014d2:	e8 7d ff ff ff       	call   801454 <syscall>
  8014d7:	83 c4 18             	add    $0x18,%esp
}
  8014da:	90                   	nop
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    

008014dd <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 00                	push   $0x0
  8014ea:	6a 04                	push   $0x4
  8014ec:	e8 63 ff ff ff       	call   801454 <syscall>
  8014f1:	83 c4 18             	add    $0x18,%esp
}
  8014f4:	90                   	nop
  8014f5:	c9                   	leave  
  8014f6:	c3                   	ret    

008014f7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	52                   	push   %edx
  801507:	50                   	push   %eax
  801508:	6a 08                	push   $0x8
  80150a:	e8 45 ff ff ff       	call   801454 <syscall>
  80150f:	83 c4 18             	add    $0x18,%esp
}
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	56                   	push   %esi
  801518:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801519:	8b 75 18             	mov    0x18(%ebp),%esi
  80151c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80151f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801522:	8b 55 0c             	mov    0xc(%ebp),%edx
  801525:	8b 45 08             	mov    0x8(%ebp),%eax
  801528:	56                   	push   %esi
  801529:	53                   	push   %ebx
  80152a:	51                   	push   %ecx
  80152b:	52                   	push   %edx
  80152c:	50                   	push   %eax
  80152d:	6a 09                	push   $0x9
  80152f:	e8 20 ff ff ff       	call   801454 <syscall>
  801534:	83 c4 18             	add    $0x18,%esp
}
  801537:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80153a:	5b                   	pop    %ebx
  80153b:	5e                   	pop    %esi
  80153c:	5d                   	pop    %ebp
  80153d:	c3                   	ret    

0080153e <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	ff 75 08             	pushl  0x8(%ebp)
  80154c:	6a 0a                	push   $0xa
  80154e:	e8 01 ff ff ff       	call   801454 <syscall>
  801553:	83 c4 18             	add    $0x18,%esp
}
  801556:	c9                   	leave  
  801557:	c3                   	ret    

00801558 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	ff 75 0c             	pushl  0xc(%ebp)
  801564:	ff 75 08             	pushl  0x8(%ebp)
  801567:	6a 0b                	push   $0xb
  801569:	e8 e6 fe ff ff       	call   801454 <syscall>
  80156e:	83 c4 18             	add    $0x18,%esp
}
  801571:	c9                   	leave  
  801572:	c3                   	ret    

00801573 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	6a 0c                	push   $0xc
  801582:	e8 cd fe ff ff       	call   801454 <syscall>
  801587:	83 c4 18             	add    $0x18,%esp
}
  80158a:	c9                   	leave  
  80158b:	c3                   	ret    

0080158c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 0d                	push   $0xd
  80159b:	e8 b4 fe ff ff       	call   801454 <syscall>
  8015a0:	83 c4 18             	add    $0x18,%esp
}
  8015a3:	c9                   	leave  
  8015a4:	c3                   	ret    

008015a5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 0e                	push   $0xe
  8015b4:	e8 9b fe ff ff       	call   801454 <syscall>
  8015b9:	83 c4 18             	add    $0x18,%esp
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 0f                	push   $0xf
  8015cd:	e8 82 fe ff ff       	call   801454 <syscall>
  8015d2:	83 c4 18             	add    $0x18,%esp
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	ff 75 08             	pushl  0x8(%ebp)
  8015e5:	6a 10                	push   $0x10
  8015e7:	e8 68 fe ff ff       	call   801454 <syscall>
  8015ec:	83 c4 18             	add    $0x18,%esp
}
  8015ef:	c9                   	leave  
  8015f0:	c3                   	ret    

008015f1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 11                	push   $0x11
  801600:	e8 4f fe ff ff       	call   801454 <syscall>
  801605:	83 c4 18             	add    $0x18,%esp
}
  801608:	90                   	nop
  801609:	c9                   	leave  
  80160a:	c3                   	ret    

0080160b <sys_cputc>:

void
sys_cputc(const char c)
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
  80160e:	83 ec 04             	sub    $0x4,%esp
  801611:	8b 45 08             	mov    0x8(%ebp),%eax
  801614:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801617:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	50                   	push   %eax
  801624:	6a 01                	push   $0x1
  801626:	e8 29 fe ff ff       	call   801454 <syscall>
  80162b:	83 c4 18             	add    $0x18,%esp
}
  80162e:	90                   	nop
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 14                	push   $0x14
  801640:	e8 0f fe ff ff       	call   801454 <syscall>
  801645:	83 c4 18             	add    $0x18,%esp
}
  801648:	90                   	nop
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
  80164e:	83 ec 04             	sub    $0x4,%esp
  801651:	8b 45 10             	mov    0x10(%ebp),%eax
  801654:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801657:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80165a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	6a 00                	push   $0x0
  801663:	51                   	push   %ecx
  801664:	52                   	push   %edx
  801665:	ff 75 0c             	pushl  0xc(%ebp)
  801668:	50                   	push   %eax
  801669:	6a 15                	push   $0x15
  80166b:	e8 e4 fd ff ff       	call   801454 <syscall>
  801670:	83 c4 18             	add    $0x18,%esp
}
  801673:	c9                   	leave  
  801674:	c3                   	ret    

00801675 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801678:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167b:	8b 45 08             	mov    0x8(%ebp),%eax
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	52                   	push   %edx
  801685:	50                   	push   %eax
  801686:	6a 16                	push   $0x16
  801688:	e8 c7 fd ff ff       	call   801454 <syscall>
  80168d:	83 c4 18             	add    $0x18,%esp
}
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801695:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801698:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169b:	8b 45 08             	mov    0x8(%ebp),%eax
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	51                   	push   %ecx
  8016a3:	52                   	push   %edx
  8016a4:	50                   	push   %eax
  8016a5:	6a 17                	push   $0x17
  8016a7:	e8 a8 fd ff ff       	call   801454 <syscall>
  8016ac:	83 c4 18             	add    $0x18,%esp
}
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	52                   	push   %edx
  8016c1:	50                   	push   %eax
  8016c2:	6a 18                	push   $0x18
  8016c4:	e8 8b fd ff ff       	call   801454 <syscall>
  8016c9:	83 c4 18             	add    $0x18,%esp
}
  8016cc:	c9                   	leave  
  8016cd:	c3                   	ret    

008016ce <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	6a 00                	push   $0x0
  8016d6:	ff 75 14             	pushl  0x14(%ebp)
  8016d9:	ff 75 10             	pushl  0x10(%ebp)
  8016dc:	ff 75 0c             	pushl  0xc(%ebp)
  8016df:	50                   	push   %eax
  8016e0:	6a 19                	push   $0x19
  8016e2:	e8 6d fd ff ff       	call   801454 <syscall>
  8016e7:	83 c4 18             	add    $0x18,%esp
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <sys_run_env>:

void sys_run_env(int32 envId)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	50                   	push   %eax
  8016fb:	6a 1a                	push   $0x1a
  8016fd:	e8 52 fd ff ff       	call   801454 <syscall>
  801702:	83 c4 18             	add    $0x18,%esp
}
  801705:	90                   	nop
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80170b:	8b 45 08             	mov    0x8(%ebp),%eax
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	50                   	push   %eax
  801717:	6a 1b                	push   $0x1b
  801719:	e8 36 fd ff ff       	call   801454 <syscall>
  80171e:	83 c4 18             	add    $0x18,%esp
}
  801721:	c9                   	leave  
  801722:	c3                   	ret    

00801723 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 05                	push   $0x5
  801732:	e8 1d fd ff ff       	call   801454 <syscall>
  801737:	83 c4 18             	add    $0x18,%esp
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 06                	push   $0x6
  80174b:	e8 04 fd ff ff       	call   801454 <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 07                	push   $0x7
  801764:	e8 eb fc ff ff       	call   801454 <syscall>
  801769:	83 c4 18             	add    $0x18,%esp
}
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    

0080176e <sys_exit_env>:


void sys_exit_env(void)
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 1c                	push   $0x1c
  80177d:	e8 d2 fc ff ff       	call   801454 <syscall>
  801782:	83 c4 18             	add    $0x18,%esp
}
  801785:	90                   	nop
  801786:	c9                   	leave  
  801787:	c3                   	ret    

00801788 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80178e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801791:	8d 50 04             	lea    0x4(%eax),%edx
  801794:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	52                   	push   %edx
  80179e:	50                   	push   %eax
  80179f:	6a 1d                	push   $0x1d
  8017a1:	e8 ae fc ff ff       	call   801454 <syscall>
  8017a6:	83 c4 18             	add    $0x18,%esp
	return result;
  8017a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017af:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b2:	89 01                	mov    %eax,(%ecx)
  8017b4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ba:	c9                   	leave  
  8017bb:	c2 04 00             	ret    $0x4

008017be <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	ff 75 10             	pushl  0x10(%ebp)
  8017c8:	ff 75 0c             	pushl  0xc(%ebp)
  8017cb:	ff 75 08             	pushl  0x8(%ebp)
  8017ce:	6a 13                	push   $0x13
  8017d0:	e8 7f fc ff ff       	call   801454 <syscall>
  8017d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d8:	90                   	nop
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <sys_rcr2>:
uint32 sys_rcr2()
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 1e                	push   $0x1e
  8017ea:	e8 65 fc ff ff       	call   801454 <syscall>
  8017ef:	83 c4 18             	add    $0x18,%esp
}
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    

008017f4 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
  8017f7:	83 ec 04             	sub    $0x4,%esp
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801800:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	50                   	push   %eax
  80180d:	6a 1f                	push   $0x1f
  80180f:	e8 40 fc ff ff       	call   801454 <syscall>
  801814:	83 c4 18             	add    $0x18,%esp
	return ;
  801817:	90                   	nop
}
  801818:	c9                   	leave  
  801819:	c3                   	ret    

0080181a <rsttst>:
void rsttst()
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 21                	push   $0x21
  801829:	e8 26 fc ff ff       	call   801454 <syscall>
  80182e:	83 c4 18             	add    $0x18,%esp
	return ;
  801831:	90                   	nop
}
  801832:	c9                   	leave  
  801833:	c3                   	ret    

00801834 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	83 ec 04             	sub    $0x4,%esp
  80183a:	8b 45 14             	mov    0x14(%ebp),%eax
  80183d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801840:	8b 55 18             	mov    0x18(%ebp),%edx
  801843:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801847:	52                   	push   %edx
  801848:	50                   	push   %eax
  801849:	ff 75 10             	pushl  0x10(%ebp)
  80184c:	ff 75 0c             	pushl  0xc(%ebp)
  80184f:	ff 75 08             	pushl  0x8(%ebp)
  801852:	6a 20                	push   $0x20
  801854:	e8 fb fb ff ff       	call   801454 <syscall>
  801859:	83 c4 18             	add    $0x18,%esp
	return ;
  80185c:	90                   	nop
}
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <chktst>:
void chktst(uint32 n)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	ff 75 08             	pushl  0x8(%ebp)
  80186d:	6a 22                	push   $0x22
  80186f:	e8 e0 fb ff ff       	call   801454 <syscall>
  801874:	83 c4 18             	add    $0x18,%esp
	return ;
  801877:	90                   	nop
}
  801878:	c9                   	leave  
  801879:	c3                   	ret    

0080187a <inctst>:

void inctst()
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 23                	push   $0x23
  801889:	e8 c6 fb ff ff       	call   801454 <syscall>
  80188e:	83 c4 18             	add    $0x18,%esp
	return ;
  801891:	90                   	nop
}
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <gettst>:
uint32 gettst()
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 24                	push   $0x24
  8018a3:	e8 ac fb ff ff       	call   801454 <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp
}
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    

008018ad <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 25                	push   $0x25
  8018bc:	e8 93 fb ff ff       	call   801454 <syscall>
  8018c1:	83 c4 18             	add    $0x18,%esp
  8018c4:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8018c9:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d6:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	ff 75 08             	pushl  0x8(%ebp)
  8018e6:	6a 26                	push   $0x26
  8018e8:	e8 67 fb ff ff       	call   801454 <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f0:	90                   	nop
}
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
  8018f6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018f7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801900:	8b 45 08             	mov    0x8(%ebp),%eax
  801903:	6a 00                	push   $0x0
  801905:	53                   	push   %ebx
  801906:	51                   	push   %ecx
  801907:	52                   	push   %edx
  801908:	50                   	push   %eax
  801909:	6a 27                	push   $0x27
  80190b:	e8 44 fb ff ff       	call   801454 <syscall>
  801910:	83 c4 18             	add    $0x18,%esp
}
  801913:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80191b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191e:	8b 45 08             	mov    0x8(%ebp),%eax
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	52                   	push   %edx
  801928:	50                   	push   %eax
  801929:	6a 28                	push   $0x28
  80192b:	e8 24 fb ff ff       	call   801454 <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801938:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80193b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193e:	8b 45 08             	mov    0x8(%ebp),%eax
  801941:	6a 00                	push   $0x0
  801943:	51                   	push   %ecx
  801944:	ff 75 10             	pushl  0x10(%ebp)
  801947:	52                   	push   %edx
  801948:	50                   	push   %eax
  801949:	6a 29                	push   $0x29
  80194b:	e8 04 fb ff ff       	call   801454 <syscall>
  801950:	83 c4 18             	add    $0x18,%esp
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	ff 75 10             	pushl  0x10(%ebp)
  80195f:	ff 75 0c             	pushl  0xc(%ebp)
  801962:	ff 75 08             	pushl  0x8(%ebp)
  801965:	6a 12                	push   $0x12
  801967:	e8 e8 fa ff ff       	call   801454 <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
	return ;
  80196f:	90                   	nop
}
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801975:	8b 55 0c             	mov    0xc(%ebp),%edx
  801978:	8b 45 08             	mov    0x8(%ebp),%eax
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	52                   	push   %edx
  801982:	50                   	push   %eax
  801983:	6a 2a                	push   $0x2a
  801985:	e8 ca fa ff ff       	call   801454 <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
	return;
  80198d:	90                   	nop
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 2b                	push   $0x2b
  80199f:	e8 b0 fa ff ff       	call   801454 <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	ff 75 0c             	pushl  0xc(%ebp)
  8019b5:	ff 75 08             	pushl  0x8(%ebp)
  8019b8:	6a 2d                	push   $0x2d
  8019ba:	e8 95 fa ff ff       	call   801454 <syscall>
  8019bf:	83 c4 18             	add    $0x18,%esp
	return;
  8019c2:	90                   	nop
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	ff 75 0c             	pushl  0xc(%ebp)
  8019d1:	ff 75 08             	pushl  0x8(%ebp)
  8019d4:	6a 2c                	push   $0x2c
  8019d6:	e8 79 fa ff ff       	call   801454 <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
	return ;
  8019de:	90                   	nop
}
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8019e7:	83 ec 04             	sub    $0x4,%esp
  8019ea:	68 08 24 80 00       	push   $0x802408
  8019ef:	68 25 01 00 00       	push   $0x125
  8019f4:	68 3b 24 80 00       	push   $0x80243b
  8019f9:	e8 a3 e8 ff ff       	call   8002a1 <_panic>

008019fe <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801a04:	8b 55 08             	mov    0x8(%ebp),%edx
  801a07:	89 d0                	mov    %edx,%eax
  801a09:	c1 e0 02             	shl    $0x2,%eax
  801a0c:	01 d0                	add    %edx,%eax
  801a0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a15:	01 d0                	add    %edx,%eax
  801a17:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a1e:	01 d0                	add    %edx,%eax
  801a20:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a27:	01 d0                	add    %edx,%eax
  801a29:	c1 e0 04             	shl    $0x4,%eax
  801a2c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801a2f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801a36:	0f 31                	rdtsc  
  801a38:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801a3b:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801a3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a41:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a44:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a47:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801a4a:	eb 46                	jmp    801a92 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801a4c:	0f 31                	rdtsc  
  801a4e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801a51:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801a54:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801a57:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801a5a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801a5d:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801a60:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a66:	29 c2                	sub    %eax,%edx
  801a68:	89 d0                	mov    %edx,%eax
  801a6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801a6d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a73:	89 d1                	mov    %edx,%ecx
  801a75:	29 c1                	sub    %eax,%ecx
  801a77:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a7d:	39 c2                	cmp    %eax,%edx
  801a7f:	0f 97 c0             	seta   %al
  801a82:	0f b6 c0             	movzbl %al,%eax
  801a85:	29 c1                	sub    %eax,%ecx
  801a87:	89 c8                	mov    %ecx,%eax
  801a89:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801a8c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801a92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a95:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801a98:	72 b2                	jb     801a4c <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801a9a:	90                   	nop
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
  801aa0:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801aa3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801aaa:	eb 03                	jmp    801aaf <busy_wait+0x12>
  801aac:	ff 45 fc             	incl   -0x4(%ebp)
  801aaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ab2:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ab5:	72 f5                	jb     801aac <busy_wait+0xf>
	return i;
  801ab7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <__udivdi3>:
  801abc:	55                   	push   %ebp
  801abd:	57                   	push   %edi
  801abe:	56                   	push   %esi
  801abf:	53                   	push   %ebx
  801ac0:	83 ec 1c             	sub    $0x1c,%esp
  801ac3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ac7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801acb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801acf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ad3:	89 ca                	mov    %ecx,%edx
  801ad5:	89 f8                	mov    %edi,%eax
  801ad7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801adb:	85 f6                	test   %esi,%esi
  801add:	75 2d                	jne    801b0c <__udivdi3+0x50>
  801adf:	39 cf                	cmp    %ecx,%edi
  801ae1:	77 65                	ja     801b48 <__udivdi3+0x8c>
  801ae3:	89 fd                	mov    %edi,%ebp
  801ae5:	85 ff                	test   %edi,%edi
  801ae7:	75 0b                	jne    801af4 <__udivdi3+0x38>
  801ae9:	b8 01 00 00 00       	mov    $0x1,%eax
  801aee:	31 d2                	xor    %edx,%edx
  801af0:	f7 f7                	div    %edi
  801af2:	89 c5                	mov    %eax,%ebp
  801af4:	31 d2                	xor    %edx,%edx
  801af6:	89 c8                	mov    %ecx,%eax
  801af8:	f7 f5                	div    %ebp
  801afa:	89 c1                	mov    %eax,%ecx
  801afc:	89 d8                	mov    %ebx,%eax
  801afe:	f7 f5                	div    %ebp
  801b00:	89 cf                	mov    %ecx,%edi
  801b02:	89 fa                	mov    %edi,%edx
  801b04:	83 c4 1c             	add    $0x1c,%esp
  801b07:	5b                   	pop    %ebx
  801b08:	5e                   	pop    %esi
  801b09:	5f                   	pop    %edi
  801b0a:	5d                   	pop    %ebp
  801b0b:	c3                   	ret    
  801b0c:	39 ce                	cmp    %ecx,%esi
  801b0e:	77 28                	ja     801b38 <__udivdi3+0x7c>
  801b10:	0f bd fe             	bsr    %esi,%edi
  801b13:	83 f7 1f             	xor    $0x1f,%edi
  801b16:	75 40                	jne    801b58 <__udivdi3+0x9c>
  801b18:	39 ce                	cmp    %ecx,%esi
  801b1a:	72 0a                	jb     801b26 <__udivdi3+0x6a>
  801b1c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b20:	0f 87 9e 00 00 00    	ja     801bc4 <__udivdi3+0x108>
  801b26:	b8 01 00 00 00       	mov    $0x1,%eax
  801b2b:	89 fa                	mov    %edi,%edx
  801b2d:	83 c4 1c             	add    $0x1c,%esp
  801b30:	5b                   	pop    %ebx
  801b31:	5e                   	pop    %esi
  801b32:	5f                   	pop    %edi
  801b33:	5d                   	pop    %ebp
  801b34:	c3                   	ret    
  801b35:	8d 76 00             	lea    0x0(%esi),%esi
  801b38:	31 ff                	xor    %edi,%edi
  801b3a:	31 c0                	xor    %eax,%eax
  801b3c:	89 fa                	mov    %edi,%edx
  801b3e:	83 c4 1c             	add    $0x1c,%esp
  801b41:	5b                   	pop    %ebx
  801b42:	5e                   	pop    %esi
  801b43:	5f                   	pop    %edi
  801b44:	5d                   	pop    %ebp
  801b45:	c3                   	ret    
  801b46:	66 90                	xchg   %ax,%ax
  801b48:	89 d8                	mov    %ebx,%eax
  801b4a:	f7 f7                	div    %edi
  801b4c:	31 ff                	xor    %edi,%edi
  801b4e:	89 fa                	mov    %edi,%edx
  801b50:	83 c4 1c             	add    $0x1c,%esp
  801b53:	5b                   	pop    %ebx
  801b54:	5e                   	pop    %esi
  801b55:	5f                   	pop    %edi
  801b56:	5d                   	pop    %ebp
  801b57:	c3                   	ret    
  801b58:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b5d:	89 eb                	mov    %ebp,%ebx
  801b5f:	29 fb                	sub    %edi,%ebx
  801b61:	89 f9                	mov    %edi,%ecx
  801b63:	d3 e6                	shl    %cl,%esi
  801b65:	89 c5                	mov    %eax,%ebp
  801b67:	88 d9                	mov    %bl,%cl
  801b69:	d3 ed                	shr    %cl,%ebp
  801b6b:	89 e9                	mov    %ebp,%ecx
  801b6d:	09 f1                	or     %esi,%ecx
  801b6f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b73:	89 f9                	mov    %edi,%ecx
  801b75:	d3 e0                	shl    %cl,%eax
  801b77:	89 c5                	mov    %eax,%ebp
  801b79:	89 d6                	mov    %edx,%esi
  801b7b:	88 d9                	mov    %bl,%cl
  801b7d:	d3 ee                	shr    %cl,%esi
  801b7f:	89 f9                	mov    %edi,%ecx
  801b81:	d3 e2                	shl    %cl,%edx
  801b83:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b87:	88 d9                	mov    %bl,%cl
  801b89:	d3 e8                	shr    %cl,%eax
  801b8b:	09 c2                	or     %eax,%edx
  801b8d:	89 d0                	mov    %edx,%eax
  801b8f:	89 f2                	mov    %esi,%edx
  801b91:	f7 74 24 0c          	divl   0xc(%esp)
  801b95:	89 d6                	mov    %edx,%esi
  801b97:	89 c3                	mov    %eax,%ebx
  801b99:	f7 e5                	mul    %ebp
  801b9b:	39 d6                	cmp    %edx,%esi
  801b9d:	72 19                	jb     801bb8 <__udivdi3+0xfc>
  801b9f:	74 0b                	je     801bac <__udivdi3+0xf0>
  801ba1:	89 d8                	mov    %ebx,%eax
  801ba3:	31 ff                	xor    %edi,%edi
  801ba5:	e9 58 ff ff ff       	jmp    801b02 <__udivdi3+0x46>
  801baa:	66 90                	xchg   %ax,%ax
  801bac:	8b 54 24 08          	mov    0x8(%esp),%edx
  801bb0:	89 f9                	mov    %edi,%ecx
  801bb2:	d3 e2                	shl    %cl,%edx
  801bb4:	39 c2                	cmp    %eax,%edx
  801bb6:	73 e9                	jae    801ba1 <__udivdi3+0xe5>
  801bb8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801bbb:	31 ff                	xor    %edi,%edi
  801bbd:	e9 40 ff ff ff       	jmp    801b02 <__udivdi3+0x46>
  801bc2:	66 90                	xchg   %ax,%ax
  801bc4:	31 c0                	xor    %eax,%eax
  801bc6:	e9 37 ff ff ff       	jmp    801b02 <__udivdi3+0x46>
  801bcb:	90                   	nop

00801bcc <__umoddi3>:
  801bcc:	55                   	push   %ebp
  801bcd:	57                   	push   %edi
  801bce:	56                   	push   %esi
  801bcf:	53                   	push   %ebx
  801bd0:	83 ec 1c             	sub    $0x1c,%esp
  801bd3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bd7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bdb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bdf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801be3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801be7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801beb:	89 f3                	mov    %esi,%ebx
  801bed:	89 fa                	mov    %edi,%edx
  801bef:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bf3:	89 34 24             	mov    %esi,(%esp)
  801bf6:	85 c0                	test   %eax,%eax
  801bf8:	75 1a                	jne    801c14 <__umoddi3+0x48>
  801bfa:	39 f7                	cmp    %esi,%edi
  801bfc:	0f 86 a2 00 00 00    	jbe    801ca4 <__umoddi3+0xd8>
  801c02:	89 c8                	mov    %ecx,%eax
  801c04:	89 f2                	mov    %esi,%edx
  801c06:	f7 f7                	div    %edi
  801c08:	89 d0                	mov    %edx,%eax
  801c0a:	31 d2                	xor    %edx,%edx
  801c0c:	83 c4 1c             	add    $0x1c,%esp
  801c0f:	5b                   	pop    %ebx
  801c10:	5e                   	pop    %esi
  801c11:	5f                   	pop    %edi
  801c12:	5d                   	pop    %ebp
  801c13:	c3                   	ret    
  801c14:	39 f0                	cmp    %esi,%eax
  801c16:	0f 87 ac 00 00 00    	ja     801cc8 <__umoddi3+0xfc>
  801c1c:	0f bd e8             	bsr    %eax,%ebp
  801c1f:	83 f5 1f             	xor    $0x1f,%ebp
  801c22:	0f 84 ac 00 00 00    	je     801cd4 <__umoddi3+0x108>
  801c28:	bf 20 00 00 00       	mov    $0x20,%edi
  801c2d:	29 ef                	sub    %ebp,%edi
  801c2f:	89 fe                	mov    %edi,%esi
  801c31:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c35:	89 e9                	mov    %ebp,%ecx
  801c37:	d3 e0                	shl    %cl,%eax
  801c39:	89 d7                	mov    %edx,%edi
  801c3b:	89 f1                	mov    %esi,%ecx
  801c3d:	d3 ef                	shr    %cl,%edi
  801c3f:	09 c7                	or     %eax,%edi
  801c41:	89 e9                	mov    %ebp,%ecx
  801c43:	d3 e2                	shl    %cl,%edx
  801c45:	89 14 24             	mov    %edx,(%esp)
  801c48:	89 d8                	mov    %ebx,%eax
  801c4a:	d3 e0                	shl    %cl,%eax
  801c4c:	89 c2                	mov    %eax,%edx
  801c4e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c52:	d3 e0                	shl    %cl,%eax
  801c54:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c58:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c5c:	89 f1                	mov    %esi,%ecx
  801c5e:	d3 e8                	shr    %cl,%eax
  801c60:	09 d0                	or     %edx,%eax
  801c62:	d3 eb                	shr    %cl,%ebx
  801c64:	89 da                	mov    %ebx,%edx
  801c66:	f7 f7                	div    %edi
  801c68:	89 d3                	mov    %edx,%ebx
  801c6a:	f7 24 24             	mull   (%esp)
  801c6d:	89 c6                	mov    %eax,%esi
  801c6f:	89 d1                	mov    %edx,%ecx
  801c71:	39 d3                	cmp    %edx,%ebx
  801c73:	0f 82 87 00 00 00    	jb     801d00 <__umoddi3+0x134>
  801c79:	0f 84 91 00 00 00    	je     801d10 <__umoddi3+0x144>
  801c7f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c83:	29 f2                	sub    %esi,%edx
  801c85:	19 cb                	sbb    %ecx,%ebx
  801c87:	89 d8                	mov    %ebx,%eax
  801c89:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c8d:	d3 e0                	shl    %cl,%eax
  801c8f:	89 e9                	mov    %ebp,%ecx
  801c91:	d3 ea                	shr    %cl,%edx
  801c93:	09 d0                	or     %edx,%eax
  801c95:	89 e9                	mov    %ebp,%ecx
  801c97:	d3 eb                	shr    %cl,%ebx
  801c99:	89 da                	mov    %ebx,%edx
  801c9b:	83 c4 1c             	add    $0x1c,%esp
  801c9e:	5b                   	pop    %ebx
  801c9f:	5e                   	pop    %esi
  801ca0:	5f                   	pop    %edi
  801ca1:	5d                   	pop    %ebp
  801ca2:	c3                   	ret    
  801ca3:	90                   	nop
  801ca4:	89 fd                	mov    %edi,%ebp
  801ca6:	85 ff                	test   %edi,%edi
  801ca8:	75 0b                	jne    801cb5 <__umoddi3+0xe9>
  801caa:	b8 01 00 00 00       	mov    $0x1,%eax
  801caf:	31 d2                	xor    %edx,%edx
  801cb1:	f7 f7                	div    %edi
  801cb3:	89 c5                	mov    %eax,%ebp
  801cb5:	89 f0                	mov    %esi,%eax
  801cb7:	31 d2                	xor    %edx,%edx
  801cb9:	f7 f5                	div    %ebp
  801cbb:	89 c8                	mov    %ecx,%eax
  801cbd:	f7 f5                	div    %ebp
  801cbf:	89 d0                	mov    %edx,%eax
  801cc1:	e9 44 ff ff ff       	jmp    801c0a <__umoddi3+0x3e>
  801cc6:	66 90                	xchg   %ax,%ax
  801cc8:	89 c8                	mov    %ecx,%eax
  801cca:	89 f2                	mov    %esi,%edx
  801ccc:	83 c4 1c             	add    $0x1c,%esp
  801ccf:	5b                   	pop    %ebx
  801cd0:	5e                   	pop    %esi
  801cd1:	5f                   	pop    %edi
  801cd2:	5d                   	pop    %ebp
  801cd3:	c3                   	ret    
  801cd4:	3b 04 24             	cmp    (%esp),%eax
  801cd7:	72 06                	jb     801cdf <__umoddi3+0x113>
  801cd9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801cdd:	77 0f                	ja     801cee <__umoddi3+0x122>
  801cdf:	89 f2                	mov    %esi,%edx
  801ce1:	29 f9                	sub    %edi,%ecx
  801ce3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ce7:	89 14 24             	mov    %edx,(%esp)
  801cea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cee:	8b 44 24 04          	mov    0x4(%esp),%eax
  801cf2:	8b 14 24             	mov    (%esp),%edx
  801cf5:	83 c4 1c             	add    $0x1c,%esp
  801cf8:	5b                   	pop    %ebx
  801cf9:	5e                   	pop    %esi
  801cfa:	5f                   	pop    %edi
  801cfb:	5d                   	pop    %ebp
  801cfc:	c3                   	ret    
  801cfd:	8d 76 00             	lea    0x0(%esi),%esi
  801d00:	2b 04 24             	sub    (%esp),%eax
  801d03:	19 fa                	sbb    %edi,%edx
  801d05:	89 d1                	mov    %edx,%ecx
  801d07:	89 c6                	mov    %eax,%esi
  801d09:	e9 71 ff ff ff       	jmp    801c7f <__umoddi3+0xb3>
  801d0e:	66 90                	xchg   %ax,%ax
  801d10:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d14:	72 ea                	jb     801d00 <__umoddi3+0x134>
  801d16:	89 d9                	mov    %ebx,%ecx
  801d18:	e9 62 ff ff ff       	jmp    801c7f <__umoddi3+0xb3>

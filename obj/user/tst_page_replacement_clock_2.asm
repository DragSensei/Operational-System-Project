
obj/user/tst_page_replacement_clock_2:     file format elf32-i386


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
  800031:	e8 1c 00 00 00       	call   800052 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
char __arr__[PAGE_SIZE*12];
char* __ptr__ = (char* )0x0801000 ;
char* __ptr2__ = (char* )0x0804000 ;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 08             	sub    $0x8,%esp

	panic("UPDATE IS REQUIRED");
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	68 e0 1b 80 00       	push   $0x801be0
  800046:	6a 0e                	push   $0xe
  800048:	68 f4 1b 80 00       	push   $0x801bf4
  80004d:	e8 b0 01 00 00       	call   800202 <_panic>

00800052 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800052:	55                   	push   %ebp
  800053:	89 e5                	mov    %esp,%ebp
  800055:	57                   	push   %edi
  800056:	56                   	push   %esi
  800057:	53                   	push   %ebx
  800058:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80005b:	e8 3d 16 00 00       	call   80169d <sys_getenvindex>
  800060:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800063:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800066:	89 d0                	mov    %edx,%eax
  800068:	c1 e0 02             	shl    $0x2,%eax
  80006b:	01 d0                	add    %edx,%eax
  80006d:	c1 e0 03             	shl    $0x3,%eax
  800070:	01 d0                	add    %edx,%eax
  800072:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800079:	01 d0                	add    %edx,%eax
  80007b:	c1 e0 02             	shl    $0x2,%eax
  80007e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800083:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800088:	a1 20 30 80 00       	mov    0x803020,%eax
  80008d:	8a 40 20             	mov    0x20(%eax),%al
  800090:	84 c0                	test   %al,%al
  800092:	74 0d                	je     8000a1 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800094:	a1 20 30 80 00       	mov    0x803020,%eax
  800099:	83 c0 20             	add    $0x20,%eax
  80009c:	a3 0c 30 80 00       	mov    %eax,0x80300c

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a5:	7e 0a                	jle    8000b1 <libmain+0x5f>
		binaryname = argv[0];
  8000a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000aa:	8b 00                	mov    (%eax),%eax
  8000ac:	a3 0c 30 80 00       	mov    %eax,0x80300c

	// call user main routine
	_main(argc, argv);
  8000b1:	83 ec 08             	sub    $0x8,%esp
  8000b4:	ff 75 0c             	pushl  0xc(%ebp)
  8000b7:	ff 75 08             	pushl  0x8(%ebp)
  8000ba:	e8 79 ff ff ff       	call   800038 <_main>
  8000bf:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000c2:	a1 08 30 80 00       	mov    0x803008,%eax
  8000c7:	85 c0                	test   %eax,%eax
  8000c9:	0f 84 01 01 00 00    	je     8001d0 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8000cf:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8000d5:	bb 10 1d 80 00       	mov    $0x801d10,%ebx
  8000da:	ba 0e 00 00 00       	mov    $0xe,%edx
  8000df:	89 c7                	mov    %eax,%edi
  8000e1:	89 de                	mov    %ebx,%esi
  8000e3:	89 d1                	mov    %edx,%ecx
  8000e5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000e7:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8000ea:	b9 56 00 00 00       	mov    $0x56,%ecx
  8000ef:	b0 00                	mov    $0x0,%al
  8000f1:	89 d7                	mov    %edx,%edi
  8000f3:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8000f5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8000fc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8000ff:	83 ec 08             	sub    $0x8,%esp
  800102:	50                   	push   %eax
  800103:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800109:	50                   	push   %eax
  80010a:	e8 c4 17 00 00       	call   8018d3 <sys_utilities>
  80010f:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800112:	e8 0d 13 00 00       	call   801424 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800117:	83 ec 0c             	sub    $0xc,%esp
  80011a:	68 30 1c 80 00       	push   $0x801c30
  80011f:	e8 ac 03 00 00       	call   8004d0 <cprintf>
  800124:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800127:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012a:	85 c0                	test   %eax,%eax
  80012c:	74 18                	je     800146 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80012e:	e8 be 17 00 00       	call   8018f1 <sys_get_optimal_num_faults>
  800133:	83 ec 08             	sub    $0x8,%esp
  800136:	50                   	push   %eax
  800137:	68 58 1c 80 00       	push   $0x801c58
  80013c:	e8 8f 03 00 00       	call   8004d0 <cprintf>
  800141:	83 c4 10             	add    $0x10,%esp
  800144:	eb 59                	jmp    80019f <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800146:	a1 20 30 80 00       	mov    0x803020,%eax
  80014b:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800151:	a1 20 30 80 00       	mov    0x803020,%eax
  800156:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80015c:	83 ec 04             	sub    $0x4,%esp
  80015f:	52                   	push   %edx
  800160:	50                   	push   %eax
  800161:	68 7c 1c 80 00       	push   $0x801c7c
  800166:	e8 65 03 00 00       	call   8004d0 <cprintf>
  80016b:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80016e:	a1 20 30 80 00       	mov    0x803020,%eax
  800173:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800179:	a1 20 30 80 00       	mov    0x803020,%eax
  80017e:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800184:	a1 20 30 80 00       	mov    0x803020,%eax
  800189:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80018f:	51                   	push   %ecx
  800190:	52                   	push   %edx
  800191:	50                   	push   %eax
  800192:	68 a4 1c 80 00       	push   $0x801ca4
  800197:	e8 34 03 00 00       	call   8004d0 <cprintf>
  80019c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80019f:	a1 20 30 80 00       	mov    0x803020,%eax
  8001a4:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8001aa:	83 ec 08             	sub    $0x8,%esp
  8001ad:	50                   	push   %eax
  8001ae:	68 fc 1c 80 00       	push   $0x801cfc
  8001b3:	e8 18 03 00 00       	call   8004d0 <cprintf>
  8001b8:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001bb:	83 ec 0c             	sub    $0xc,%esp
  8001be:	68 30 1c 80 00       	push   $0x801c30
  8001c3:	e8 08 03 00 00       	call   8004d0 <cprintf>
  8001c8:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001cb:	e8 6e 12 00 00       	call   80143e <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001d0:	e8 1f 00 00 00       	call   8001f4 <exit>
}
  8001d5:	90                   	nop
  8001d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d9:	5b                   	pop    %ebx
  8001da:	5e                   	pop    %esi
  8001db:	5f                   	pop    %edi
  8001dc:	5d                   	pop    %ebp
  8001dd:	c3                   	ret    

008001de <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001de:	55                   	push   %ebp
  8001df:	89 e5                	mov    %esp,%ebp
  8001e1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001e4:	83 ec 0c             	sub    $0xc,%esp
  8001e7:	6a 00                	push   $0x0
  8001e9:	e8 7b 14 00 00       	call   801669 <sys_destroy_env>
  8001ee:	83 c4 10             	add    $0x10,%esp
}
  8001f1:	90                   	nop
  8001f2:	c9                   	leave  
  8001f3:	c3                   	ret    

008001f4 <exit>:

void
exit(void)
{
  8001f4:	55                   	push   %ebp
  8001f5:	89 e5                	mov    %esp,%ebp
  8001f7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001fa:	e8 d0 14 00 00       	call   8016cf <sys_exit_env>
}
  8001ff:	90                   	nop
  800200:	c9                   	leave  
  800201:	c3                   	ret    

00800202 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800202:	55                   	push   %ebp
  800203:	89 e5                	mov    %esp,%ebp
  800205:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800208:	8d 45 10             	lea    0x10(%ebp),%eax
  80020b:	83 c0 04             	add    $0x4,%eax
  80020e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800211:	a1 38 71 82 00       	mov    0x827138,%eax
  800216:	85 c0                	test   %eax,%eax
  800218:	74 16                	je     800230 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80021a:	a1 38 71 82 00       	mov    0x827138,%eax
  80021f:	83 ec 08             	sub    $0x8,%esp
  800222:	50                   	push   %eax
  800223:	68 74 1d 80 00       	push   $0x801d74
  800228:	e8 a3 02 00 00       	call   8004d0 <cprintf>
  80022d:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800230:	a1 0c 30 80 00       	mov    0x80300c,%eax
  800235:	83 ec 0c             	sub    $0xc,%esp
  800238:	ff 75 0c             	pushl  0xc(%ebp)
  80023b:	ff 75 08             	pushl  0x8(%ebp)
  80023e:	50                   	push   %eax
  80023f:	68 7c 1d 80 00       	push   $0x801d7c
  800244:	6a 74                	push   $0x74
  800246:	e8 b2 02 00 00       	call   8004fd <cprintf_colored>
  80024b:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80024e:	8b 45 10             	mov    0x10(%ebp),%eax
  800251:	83 ec 08             	sub    $0x8,%esp
  800254:	ff 75 f4             	pushl  -0xc(%ebp)
  800257:	50                   	push   %eax
  800258:	e8 04 02 00 00       	call   800461 <vcprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800260:	83 ec 08             	sub    $0x8,%esp
  800263:	6a 00                	push   $0x0
  800265:	68 a4 1d 80 00       	push   $0x801da4
  80026a:	e8 f2 01 00 00       	call   800461 <vcprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800272:	e8 7d ff ff ff       	call   8001f4 <exit>

	// should not return here
	while (1) ;
  800277:	eb fe                	jmp    800277 <_panic+0x75>

00800279 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80027f:	a1 20 30 80 00       	mov    0x803020,%eax
  800284:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80028a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80028d:	39 c2                	cmp    %eax,%edx
  80028f:	74 14                	je     8002a5 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800291:	83 ec 04             	sub    $0x4,%esp
  800294:	68 a8 1d 80 00       	push   $0x801da8
  800299:	6a 26                	push   $0x26
  80029b:	68 f4 1d 80 00       	push   $0x801df4
  8002a0:	e8 5d ff ff ff       	call   800202 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002b3:	e9 c5 00 00 00       	jmp    80037d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8002b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c5:	01 d0                	add    %edx,%eax
  8002c7:	8b 00                	mov    (%eax),%eax
  8002c9:	85 c0                	test   %eax,%eax
  8002cb:	75 08                	jne    8002d5 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8002cd:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8002d0:	e9 a5 00 00 00       	jmp    80037a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8002d5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002dc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002e3:	eb 69                	jmp    80034e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8002e5:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ea:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8002f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002f3:	89 d0                	mov    %edx,%eax
  8002f5:	01 c0                	add    %eax,%eax
  8002f7:	01 d0                	add    %edx,%eax
  8002f9:	c1 e0 03             	shl    $0x3,%eax
  8002fc:	01 c8                	add    %ecx,%eax
  8002fe:	8a 40 04             	mov    0x4(%eax),%al
  800301:	84 c0                	test   %al,%al
  800303:	75 46                	jne    80034b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800305:	a1 20 30 80 00       	mov    0x803020,%eax
  80030a:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800310:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800313:	89 d0                	mov    %edx,%eax
  800315:	01 c0                	add    %eax,%eax
  800317:	01 d0                	add    %edx,%eax
  800319:	c1 e0 03             	shl    $0x3,%eax
  80031c:	01 c8                	add    %ecx,%eax
  80031e:	8b 00                	mov    (%eax),%eax
  800320:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800323:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800326:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80032b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80032d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800330:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800337:	8b 45 08             	mov    0x8(%ebp),%eax
  80033a:	01 c8                	add    %ecx,%eax
  80033c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80033e:	39 c2                	cmp    %eax,%edx
  800340:	75 09                	jne    80034b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800342:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800349:	eb 15                	jmp    800360 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80034b:	ff 45 e8             	incl   -0x18(%ebp)
  80034e:	a1 20 30 80 00       	mov    0x803020,%eax
  800353:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800359:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80035c:	39 c2                	cmp    %eax,%edx
  80035e:	77 85                	ja     8002e5 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800360:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800364:	75 14                	jne    80037a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800366:	83 ec 04             	sub    $0x4,%esp
  800369:	68 00 1e 80 00       	push   $0x801e00
  80036e:	6a 3a                	push   $0x3a
  800370:	68 f4 1d 80 00       	push   $0x801df4
  800375:	e8 88 fe ff ff       	call   800202 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80037a:	ff 45 f0             	incl   -0x10(%ebp)
  80037d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800380:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800383:	0f 8c 2f ff ff ff    	jl     8002b8 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800389:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800390:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800397:	eb 26                	jmp    8003bf <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800399:	a1 20 30 80 00       	mov    0x803020,%eax
  80039e:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003a4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003a7:	89 d0                	mov    %edx,%eax
  8003a9:	01 c0                	add    %eax,%eax
  8003ab:	01 d0                	add    %edx,%eax
  8003ad:	c1 e0 03             	shl    $0x3,%eax
  8003b0:	01 c8                	add    %ecx,%eax
  8003b2:	8a 40 04             	mov    0x4(%eax),%al
  8003b5:	3c 01                	cmp    $0x1,%al
  8003b7:	75 03                	jne    8003bc <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8003b9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003bc:	ff 45 e0             	incl   -0x20(%ebp)
  8003bf:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003cd:	39 c2                	cmp    %eax,%edx
  8003cf:	77 c8                	ja     800399 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8003d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003d4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003d7:	74 14                	je     8003ed <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8003d9:	83 ec 04             	sub    $0x4,%esp
  8003dc:	68 54 1e 80 00       	push   $0x801e54
  8003e1:	6a 44                	push   $0x44
  8003e3:	68 f4 1d 80 00       	push   $0x801df4
  8003e8:	e8 15 fe ff ff       	call   800202 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8003ed:	90                   	nop
  8003ee:	c9                   	leave  
  8003ef:	c3                   	ret    

008003f0 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
  8003f3:	53                   	push   %ebx
  8003f4:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8003f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003fa:	8b 00                	mov    (%eax),%eax
  8003fc:	8d 48 01             	lea    0x1(%eax),%ecx
  8003ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800402:	89 0a                	mov    %ecx,(%edx)
  800404:	8b 55 08             	mov    0x8(%ebp),%edx
  800407:	88 d1                	mov    %dl,%cl
  800409:	8b 55 0c             	mov    0xc(%ebp),%edx
  80040c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800410:	8b 45 0c             	mov    0xc(%ebp),%eax
  800413:	8b 00                	mov    (%eax),%eax
  800415:	3d ff 00 00 00       	cmp    $0xff,%eax
  80041a:	75 30                	jne    80044c <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80041c:	8b 15 3c 71 82 00    	mov    0x82713c,%edx
  800422:	a0 44 30 80 00       	mov    0x803044,%al
  800427:	0f b6 c0             	movzbl %al,%eax
  80042a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80042d:	8b 09                	mov    (%ecx),%ecx
  80042f:	89 cb                	mov    %ecx,%ebx
  800431:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800434:	83 c1 08             	add    $0x8,%ecx
  800437:	52                   	push   %edx
  800438:	50                   	push   %eax
  800439:	53                   	push   %ebx
  80043a:	51                   	push   %ecx
  80043b:	e8 a0 0f 00 00       	call   8013e0 <sys_cputs>
  800440:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800443:	8b 45 0c             	mov    0xc(%ebp),%eax
  800446:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80044c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80044f:	8b 40 04             	mov    0x4(%eax),%eax
  800452:	8d 50 01             	lea    0x1(%eax),%edx
  800455:	8b 45 0c             	mov    0xc(%ebp),%eax
  800458:	89 50 04             	mov    %edx,0x4(%eax)
}
  80045b:	90                   	nop
  80045c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80045f:	c9                   	leave  
  800460:	c3                   	ret    

00800461 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800461:	55                   	push   %ebp
  800462:	89 e5                	mov    %esp,%ebp
  800464:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80046a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800471:	00 00 00 
	b.cnt = 0;
  800474:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80047b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80047e:	ff 75 0c             	pushl  0xc(%ebp)
  800481:	ff 75 08             	pushl  0x8(%ebp)
  800484:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80048a:	50                   	push   %eax
  80048b:	68 f0 03 80 00       	push   $0x8003f0
  800490:	e8 5a 02 00 00       	call   8006ef <vprintfmt>
  800495:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800498:	8b 15 3c 71 82 00    	mov    0x82713c,%edx
  80049e:	a0 44 30 80 00       	mov    0x803044,%al
  8004a3:	0f b6 c0             	movzbl %al,%eax
  8004a6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8004ac:	52                   	push   %edx
  8004ad:	50                   	push   %eax
  8004ae:	51                   	push   %ecx
  8004af:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004b5:	83 c0 08             	add    $0x8,%eax
  8004b8:	50                   	push   %eax
  8004b9:	e8 22 0f 00 00       	call   8013e0 <sys_cputs>
  8004be:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004c1:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8004c8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8004ce:	c9                   	leave  
  8004cf:	c3                   	ret    

008004d0 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8004d0:	55                   	push   %ebp
  8004d1:	89 e5                	mov    %esp,%ebp
  8004d3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8004d6:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8004dd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e6:	83 ec 08             	sub    $0x8,%esp
  8004e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ec:	50                   	push   %eax
  8004ed:	e8 6f ff ff ff       	call   800461 <vcprintf>
  8004f2:	83 c4 10             	add    $0x10,%esp
  8004f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8004f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004fb:	c9                   	leave  
  8004fc:	c3                   	ret    

008004fd <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8004fd:	55                   	push   %ebp
  8004fe:	89 e5                	mov    %esp,%ebp
  800500:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800503:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80050a:	8b 45 08             	mov    0x8(%ebp),%eax
  80050d:	c1 e0 08             	shl    $0x8,%eax
  800510:	a3 3c 71 82 00       	mov    %eax,0x82713c
	va_start(ap, fmt);
  800515:	8d 45 0c             	lea    0xc(%ebp),%eax
  800518:	83 c0 04             	add    $0x4,%eax
  80051b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80051e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800521:	83 ec 08             	sub    $0x8,%esp
  800524:	ff 75 f4             	pushl  -0xc(%ebp)
  800527:	50                   	push   %eax
  800528:	e8 34 ff ff ff       	call   800461 <vcprintf>
  80052d:	83 c4 10             	add    $0x10,%esp
  800530:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800533:	c7 05 3c 71 82 00 00 	movl   $0x700,0x82713c
  80053a:	07 00 00 

	return cnt;
  80053d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800540:	c9                   	leave  
  800541:	c3                   	ret    

00800542 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800542:	55                   	push   %ebp
  800543:	89 e5                	mov    %esp,%ebp
  800545:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800548:	e8 d7 0e 00 00       	call   801424 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80054d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800550:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800553:	8b 45 08             	mov    0x8(%ebp),%eax
  800556:	83 ec 08             	sub    $0x8,%esp
  800559:	ff 75 f4             	pushl  -0xc(%ebp)
  80055c:	50                   	push   %eax
  80055d:	e8 ff fe ff ff       	call   800461 <vcprintf>
  800562:	83 c4 10             	add    $0x10,%esp
  800565:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800568:	e8 d1 0e 00 00       	call   80143e <sys_unlock_cons>
	return cnt;
  80056d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800570:	c9                   	leave  
  800571:	c3                   	ret    

00800572 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800572:	55                   	push   %ebp
  800573:	89 e5                	mov    %esp,%ebp
  800575:	53                   	push   %ebx
  800576:	83 ec 14             	sub    $0x14,%esp
  800579:	8b 45 10             	mov    0x10(%ebp),%eax
  80057c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80057f:	8b 45 14             	mov    0x14(%ebp),%eax
  800582:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800585:	8b 45 18             	mov    0x18(%ebp),%eax
  800588:	ba 00 00 00 00       	mov    $0x0,%edx
  80058d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800590:	77 55                	ja     8005e7 <printnum+0x75>
  800592:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800595:	72 05                	jb     80059c <printnum+0x2a>
  800597:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80059a:	77 4b                	ja     8005e7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80059c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80059f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005a2:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005aa:	52                   	push   %edx
  8005ab:	50                   	push   %eax
  8005ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8005af:	ff 75 f0             	pushl  -0x10(%ebp)
  8005b2:	e8 a9 13 00 00       	call   801960 <__udivdi3>
  8005b7:	83 c4 10             	add    $0x10,%esp
  8005ba:	83 ec 04             	sub    $0x4,%esp
  8005bd:	ff 75 20             	pushl  0x20(%ebp)
  8005c0:	53                   	push   %ebx
  8005c1:	ff 75 18             	pushl  0x18(%ebp)
  8005c4:	52                   	push   %edx
  8005c5:	50                   	push   %eax
  8005c6:	ff 75 0c             	pushl  0xc(%ebp)
  8005c9:	ff 75 08             	pushl  0x8(%ebp)
  8005cc:	e8 a1 ff ff ff       	call   800572 <printnum>
  8005d1:	83 c4 20             	add    $0x20,%esp
  8005d4:	eb 1a                	jmp    8005f0 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005d6:	83 ec 08             	sub    $0x8,%esp
  8005d9:	ff 75 0c             	pushl  0xc(%ebp)
  8005dc:	ff 75 20             	pushl  0x20(%ebp)
  8005df:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e2:	ff d0                	call   *%eax
  8005e4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005e7:	ff 4d 1c             	decl   0x1c(%ebp)
  8005ea:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005ee:	7f e6                	jg     8005d6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005f0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005fe:	53                   	push   %ebx
  8005ff:	51                   	push   %ecx
  800600:	52                   	push   %edx
  800601:	50                   	push   %eax
  800602:	e8 69 14 00 00       	call   801a70 <__umoddi3>
  800607:	83 c4 10             	add    $0x10,%esp
  80060a:	05 b4 20 80 00       	add    $0x8020b4,%eax
  80060f:	8a 00                	mov    (%eax),%al
  800611:	0f be c0             	movsbl %al,%eax
  800614:	83 ec 08             	sub    $0x8,%esp
  800617:	ff 75 0c             	pushl  0xc(%ebp)
  80061a:	50                   	push   %eax
  80061b:	8b 45 08             	mov    0x8(%ebp),%eax
  80061e:	ff d0                	call   *%eax
  800620:	83 c4 10             	add    $0x10,%esp
}
  800623:	90                   	nop
  800624:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800627:	c9                   	leave  
  800628:	c3                   	ret    

00800629 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800629:	55                   	push   %ebp
  80062a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80062c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800630:	7e 1c                	jle    80064e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800632:	8b 45 08             	mov    0x8(%ebp),%eax
  800635:	8b 00                	mov    (%eax),%eax
  800637:	8d 50 08             	lea    0x8(%eax),%edx
  80063a:	8b 45 08             	mov    0x8(%ebp),%eax
  80063d:	89 10                	mov    %edx,(%eax)
  80063f:	8b 45 08             	mov    0x8(%ebp),%eax
  800642:	8b 00                	mov    (%eax),%eax
  800644:	83 e8 08             	sub    $0x8,%eax
  800647:	8b 50 04             	mov    0x4(%eax),%edx
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	eb 40                	jmp    80068e <getuint+0x65>
	else if (lflag)
  80064e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800652:	74 1e                	je     800672 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800654:	8b 45 08             	mov    0x8(%ebp),%eax
  800657:	8b 00                	mov    (%eax),%eax
  800659:	8d 50 04             	lea    0x4(%eax),%edx
  80065c:	8b 45 08             	mov    0x8(%ebp),%eax
  80065f:	89 10                	mov    %edx,(%eax)
  800661:	8b 45 08             	mov    0x8(%ebp),%eax
  800664:	8b 00                	mov    (%eax),%eax
  800666:	83 e8 04             	sub    $0x4,%eax
  800669:	8b 00                	mov    (%eax),%eax
  80066b:	ba 00 00 00 00       	mov    $0x0,%edx
  800670:	eb 1c                	jmp    80068e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800672:	8b 45 08             	mov    0x8(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	8d 50 04             	lea    0x4(%eax),%edx
  80067a:	8b 45 08             	mov    0x8(%ebp),%eax
  80067d:	89 10                	mov    %edx,(%eax)
  80067f:	8b 45 08             	mov    0x8(%ebp),%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	83 e8 04             	sub    $0x4,%eax
  800687:	8b 00                	mov    (%eax),%eax
  800689:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80068e:	5d                   	pop    %ebp
  80068f:	c3                   	ret    

00800690 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800690:	55                   	push   %ebp
  800691:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800693:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800697:	7e 1c                	jle    8006b5 <getint+0x25>
		return va_arg(*ap, long long);
  800699:	8b 45 08             	mov    0x8(%ebp),%eax
  80069c:	8b 00                	mov    (%eax),%eax
  80069e:	8d 50 08             	lea    0x8(%eax),%edx
  8006a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a4:	89 10                	mov    %edx,(%eax)
  8006a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	83 e8 08             	sub    $0x8,%eax
  8006ae:	8b 50 04             	mov    0x4(%eax),%edx
  8006b1:	8b 00                	mov    (%eax),%eax
  8006b3:	eb 38                	jmp    8006ed <getint+0x5d>
	else if (lflag)
  8006b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006b9:	74 1a                	je     8006d5 <getint+0x45>
		return va_arg(*ap, long);
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	8d 50 04             	lea    0x4(%eax),%edx
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	89 10                	mov    %edx,(%eax)
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	83 e8 04             	sub    $0x4,%eax
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	99                   	cltd   
  8006d3:	eb 18                	jmp    8006ed <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	8d 50 04             	lea    0x4(%eax),%edx
  8006dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e0:	89 10                	mov    %edx,(%eax)
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	83 e8 04             	sub    $0x4,%eax
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	99                   	cltd   
}
  8006ed:	5d                   	pop    %ebp
  8006ee:	c3                   	ret    

008006ef <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006ef:	55                   	push   %ebp
  8006f0:	89 e5                	mov    %esp,%ebp
  8006f2:	56                   	push   %esi
  8006f3:	53                   	push   %ebx
  8006f4:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f7:	eb 17                	jmp    800710 <vprintfmt+0x21>
			if (ch == '\0')
  8006f9:	85 db                	test   %ebx,%ebx
  8006fb:	0f 84 c1 03 00 00    	je     800ac2 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800701:	83 ec 08             	sub    $0x8,%esp
  800704:	ff 75 0c             	pushl  0xc(%ebp)
  800707:	53                   	push   %ebx
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	ff d0                	call   *%eax
  80070d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800710:	8b 45 10             	mov    0x10(%ebp),%eax
  800713:	8d 50 01             	lea    0x1(%eax),%edx
  800716:	89 55 10             	mov    %edx,0x10(%ebp)
  800719:	8a 00                	mov    (%eax),%al
  80071b:	0f b6 d8             	movzbl %al,%ebx
  80071e:	83 fb 25             	cmp    $0x25,%ebx
  800721:	75 d6                	jne    8006f9 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800723:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800727:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80072e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800735:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80073c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800743:	8b 45 10             	mov    0x10(%ebp),%eax
  800746:	8d 50 01             	lea    0x1(%eax),%edx
  800749:	89 55 10             	mov    %edx,0x10(%ebp)
  80074c:	8a 00                	mov    (%eax),%al
  80074e:	0f b6 d8             	movzbl %al,%ebx
  800751:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800754:	83 f8 5b             	cmp    $0x5b,%eax
  800757:	0f 87 3d 03 00 00    	ja     800a9a <vprintfmt+0x3ab>
  80075d:	8b 04 85 d8 20 80 00 	mov    0x8020d8(,%eax,4),%eax
  800764:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800766:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80076a:	eb d7                	jmp    800743 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80076c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800770:	eb d1                	jmp    800743 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800772:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800779:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80077c:	89 d0                	mov    %edx,%eax
  80077e:	c1 e0 02             	shl    $0x2,%eax
  800781:	01 d0                	add    %edx,%eax
  800783:	01 c0                	add    %eax,%eax
  800785:	01 d8                	add    %ebx,%eax
  800787:	83 e8 30             	sub    $0x30,%eax
  80078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80078d:	8b 45 10             	mov    0x10(%ebp),%eax
  800790:	8a 00                	mov    (%eax),%al
  800792:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800795:	83 fb 2f             	cmp    $0x2f,%ebx
  800798:	7e 3e                	jle    8007d8 <vprintfmt+0xe9>
  80079a:	83 fb 39             	cmp    $0x39,%ebx
  80079d:	7f 39                	jg     8007d8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80079f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007a2:	eb d5                	jmp    800779 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	83 c0 04             	add    $0x4,%eax
  8007aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b0:	83 e8 04             	sub    $0x4,%eax
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007b8:	eb 1f                	jmp    8007d9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007be:	79 83                	jns    800743 <vprintfmt+0x54>
				width = 0;
  8007c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007c7:	e9 77 ff ff ff       	jmp    800743 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007cc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007d3:	e9 6b ff ff ff       	jmp    800743 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007d8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007dd:	0f 89 60 ff ff ff    	jns    800743 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007e9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007f0:	e9 4e ff ff ff       	jmp    800743 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007f5:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007f8:	e9 46 ff ff ff       	jmp    800743 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800800:	83 c0 04             	add    $0x4,%eax
  800803:	89 45 14             	mov    %eax,0x14(%ebp)
  800806:	8b 45 14             	mov    0x14(%ebp),%eax
  800809:	83 e8 04             	sub    $0x4,%eax
  80080c:	8b 00                	mov    (%eax),%eax
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	ff 75 0c             	pushl  0xc(%ebp)
  800814:	50                   	push   %eax
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	ff d0                	call   *%eax
  80081a:	83 c4 10             	add    $0x10,%esp
			break;
  80081d:	e9 9b 02 00 00       	jmp    800abd <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800822:	8b 45 14             	mov    0x14(%ebp),%eax
  800825:	83 c0 04             	add    $0x4,%eax
  800828:	89 45 14             	mov    %eax,0x14(%ebp)
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	83 e8 04             	sub    $0x4,%eax
  800831:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800833:	85 db                	test   %ebx,%ebx
  800835:	79 02                	jns    800839 <vprintfmt+0x14a>
				err = -err;
  800837:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800839:	83 fb 64             	cmp    $0x64,%ebx
  80083c:	7f 0b                	jg     800849 <vprintfmt+0x15a>
  80083e:	8b 34 9d 20 1f 80 00 	mov    0x801f20(,%ebx,4),%esi
  800845:	85 f6                	test   %esi,%esi
  800847:	75 19                	jne    800862 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800849:	53                   	push   %ebx
  80084a:	68 c5 20 80 00       	push   $0x8020c5
  80084f:	ff 75 0c             	pushl  0xc(%ebp)
  800852:	ff 75 08             	pushl  0x8(%ebp)
  800855:	e8 70 02 00 00       	call   800aca <printfmt>
  80085a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80085d:	e9 5b 02 00 00       	jmp    800abd <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800862:	56                   	push   %esi
  800863:	68 ce 20 80 00       	push   $0x8020ce
  800868:	ff 75 0c             	pushl  0xc(%ebp)
  80086b:	ff 75 08             	pushl  0x8(%ebp)
  80086e:	e8 57 02 00 00       	call   800aca <printfmt>
  800873:	83 c4 10             	add    $0x10,%esp
			break;
  800876:	e9 42 02 00 00       	jmp    800abd <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80087b:	8b 45 14             	mov    0x14(%ebp),%eax
  80087e:	83 c0 04             	add    $0x4,%eax
  800881:	89 45 14             	mov    %eax,0x14(%ebp)
  800884:	8b 45 14             	mov    0x14(%ebp),%eax
  800887:	83 e8 04             	sub    $0x4,%eax
  80088a:	8b 30                	mov    (%eax),%esi
  80088c:	85 f6                	test   %esi,%esi
  80088e:	75 05                	jne    800895 <vprintfmt+0x1a6>
				p = "(null)";
  800890:	be d1 20 80 00       	mov    $0x8020d1,%esi
			if (width > 0 && padc != '-')
  800895:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800899:	7e 6d                	jle    800908 <vprintfmt+0x219>
  80089b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80089f:	74 67                	je     800908 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008a4:	83 ec 08             	sub    $0x8,%esp
  8008a7:	50                   	push   %eax
  8008a8:	56                   	push   %esi
  8008a9:	e8 1e 03 00 00       	call   800bcc <strnlen>
  8008ae:	83 c4 10             	add    $0x10,%esp
  8008b1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008b4:	eb 16                	jmp    8008cc <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008b6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	ff 75 0c             	pushl  0xc(%ebp)
  8008c0:	50                   	push   %eax
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	ff d0                	call   *%eax
  8008c6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c9:	ff 4d e4             	decl   -0x1c(%ebp)
  8008cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008d0:	7f e4                	jg     8008b6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008d2:	eb 34                	jmp    800908 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008d4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008d8:	74 1c                	je     8008f6 <vprintfmt+0x207>
  8008da:	83 fb 1f             	cmp    $0x1f,%ebx
  8008dd:	7e 05                	jle    8008e4 <vprintfmt+0x1f5>
  8008df:	83 fb 7e             	cmp    $0x7e,%ebx
  8008e2:	7e 12                	jle    8008f6 <vprintfmt+0x207>
					putch('?', putdat);
  8008e4:	83 ec 08             	sub    $0x8,%esp
  8008e7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ea:	6a 3f                	push   $0x3f
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	ff d0                	call   *%eax
  8008f1:	83 c4 10             	add    $0x10,%esp
  8008f4:	eb 0f                	jmp    800905 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008f6:	83 ec 08             	sub    $0x8,%esp
  8008f9:	ff 75 0c             	pushl  0xc(%ebp)
  8008fc:	53                   	push   %ebx
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	ff d0                	call   *%eax
  800902:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800905:	ff 4d e4             	decl   -0x1c(%ebp)
  800908:	89 f0                	mov    %esi,%eax
  80090a:	8d 70 01             	lea    0x1(%eax),%esi
  80090d:	8a 00                	mov    (%eax),%al
  80090f:	0f be d8             	movsbl %al,%ebx
  800912:	85 db                	test   %ebx,%ebx
  800914:	74 24                	je     80093a <vprintfmt+0x24b>
  800916:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80091a:	78 b8                	js     8008d4 <vprintfmt+0x1e5>
  80091c:	ff 4d e0             	decl   -0x20(%ebp)
  80091f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800923:	79 af                	jns    8008d4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800925:	eb 13                	jmp    80093a <vprintfmt+0x24b>
				putch(' ', putdat);
  800927:	83 ec 08             	sub    $0x8,%esp
  80092a:	ff 75 0c             	pushl  0xc(%ebp)
  80092d:	6a 20                	push   $0x20
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	ff d0                	call   *%eax
  800934:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800937:	ff 4d e4             	decl   -0x1c(%ebp)
  80093a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80093e:	7f e7                	jg     800927 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800940:	e9 78 01 00 00       	jmp    800abd <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800945:	83 ec 08             	sub    $0x8,%esp
  800948:	ff 75 e8             	pushl  -0x18(%ebp)
  80094b:	8d 45 14             	lea    0x14(%ebp),%eax
  80094e:	50                   	push   %eax
  80094f:	e8 3c fd ff ff       	call   800690 <getint>
  800954:	83 c4 10             	add    $0x10,%esp
  800957:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80095a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80095d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800960:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800963:	85 d2                	test   %edx,%edx
  800965:	79 23                	jns    80098a <vprintfmt+0x29b>
				putch('-', putdat);
  800967:	83 ec 08             	sub    $0x8,%esp
  80096a:	ff 75 0c             	pushl  0xc(%ebp)
  80096d:	6a 2d                	push   $0x2d
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	ff d0                	call   *%eax
  800974:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800977:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80097a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80097d:	f7 d8                	neg    %eax
  80097f:	83 d2 00             	adc    $0x0,%edx
  800982:	f7 da                	neg    %edx
  800984:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800987:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80098a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800991:	e9 bc 00 00 00       	jmp    800a52 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	ff 75 e8             	pushl  -0x18(%ebp)
  80099c:	8d 45 14             	lea    0x14(%ebp),%eax
  80099f:	50                   	push   %eax
  8009a0:	e8 84 fc ff ff       	call   800629 <getuint>
  8009a5:	83 c4 10             	add    $0x10,%esp
  8009a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009ae:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009b5:	e9 98 00 00 00       	jmp    800a52 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009ba:	83 ec 08             	sub    $0x8,%esp
  8009bd:	ff 75 0c             	pushl  0xc(%ebp)
  8009c0:	6a 58                	push   $0x58
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	ff d0                	call   *%eax
  8009c7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	6a 58                	push   $0x58
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	ff d0                	call   *%eax
  8009d7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009da:	83 ec 08             	sub    $0x8,%esp
  8009dd:	ff 75 0c             	pushl  0xc(%ebp)
  8009e0:	6a 58                	push   $0x58
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	ff d0                	call   *%eax
  8009e7:	83 c4 10             	add    $0x10,%esp
			break;
  8009ea:	e9 ce 00 00 00       	jmp    800abd <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	ff 75 0c             	pushl  0xc(%ebp)
  8009f5:	6a 30                	push   $0x30
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	ff d0                	call   *%eax
  8009fc:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	6a 78                	push   $0x78
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	ff d0                	call   *%eax
  800a0c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a0f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a12:	83 c0 04             	add    $0x4,%eax
  800a15:	89 45 14             	mov    %eax,0x14(%ebp)
  800a18:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1b:	83 e8 04             	sub    $0x4,%eax
  800a1e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a20:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a2a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a31:	eb 1f                	jmp    800a52 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a33:	83 ec 08             	sub    $0x8,%esp
  800a36:	ff 75 e8             	pushl  -0x18(%ebp)
  800a39:	8d 45 14             	lea    0x14(%ebp),%eax
  800a3c:	50                   	push   %eax
  800a3d:	e8 e7 fb ff ff       	call   800629 <getuint>
  800a42:	83 c4 10             	add    $0x10,%esp
  800a45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a48:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a4b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a52:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a59:	83 ec 04             	sub    $0x4,%esp
  800a5c:	52                   	push   %edx
  800a5d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a60:	50                   	push   %eax
  800a61:	ff 75 f4             	pushl  -0xc(%ebp)
  800a64:	ff 75 f0             	pushl  -0x10(%ebp)
  800a67:	ff 75 0c             	pushl  0xc(%ebp)
  800a6a:	ff 75 08             	pushl  0x8(%ebp)
  800a6d:	e8 00 fb ff ff       	call   800572 <printnum>
  800a72:	83 c4 20             	add    $0x20,%esp
			break;
  800a75:	eb 46                	jmp    800abd <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	53                   	push   %ebx
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	ff d0                	call   *%eax
  800a83:	83 c4 10             	add    $0x10,%esp
			break;
  800a86:	eb 35                	jmp    800abd <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800a88:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800a8f:	eb 2c                	jmp    800abd <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800a91:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800a98:	eb 23                	jmp    800abd <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a9a:	83 ec 08             	sub    $0x8,%esp
  800a9d:	ff 75 0c             	pushl  0xc(%ebp)
  800aa0:	6a 25                	push   $0x25
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	ff d0                	call   *%eax
  800aa7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aaa:	ff 4d 10             	decl   0x10(%ebp)
  800aad:	eb 03                	jmp    800ab2 <vprintfmt+0x3c3>
  800aaf:	ff 4d 10             	decl   0x10(%ebp)
  800ab2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab5:	48                   	dec    %eax
  800ab6:	8a 00                	mov    (%eax),%al
  800ab8:	3c 25                	cmp    $0x25,%al
  800aba:	75 f3                	jne    800aaf <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800abc:	90                   	nop
		}
	}
  800abd:	e9 35 fc ff ff       	jmp    8006f7 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ac2:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ac3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ac6:	5b                   	pop    %ebx
  800ac7:	5e                   	pop    %esi
  800ac8:	5d                   	pop    %ebp
  800ac9:	c3                   	ret    

00800aca <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800aca:	55                   	push   %ebp
  800acb:	89 e5                	mov    %esp,%ebp
  800acd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ad0:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad3:	83 c0 04             	add    $0x4,%eax
  800ad6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ad9:	8b 45 10             	mov    0x10(%ebp),%eax
  800adc:	ff 75 f4             	pushl  -0xc(%ebp)
  800adf:	50                   	push   %eax
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	ff 75 08             	pushl  0x8(%ebp)
  800ae6:	e8 04 fc ff ff       	call   8006ef <vprintfmt>
  800aeb:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800aee:	90                   	nop
  800aef:	c9                   	leave  
  800af0:	c3                   	ret    

00800af1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800af1:	55                   	push   %ebp
  800af2:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800af4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af7:	8b 40 08             	mov    0x8(%eax),%eax
  800afa:	8d 50 01             	lea    0x1(%eax),%edx
  800afd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b00:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b06:	8b 10                	mov    (%eax),%edx
  800b08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0b:	8b 40 04             	mov    0x4(%eax),%eax
  800b0e:	39 c2                	cmp    %eax,%edx
  800b10:	73 12                	jae    800b24 <sprintputch+0x33>
		*b->buf++ = ch;
  800b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b15:	8b 00                	mov    (%eax),%eax
  800b17:	8d 48 01             	lea    0x1(%eax),%ecx
  800b1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1d:	89 0a                	mov    %ecx,(%edx)
  800b1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b22:	88 10                	mov    %dl,(%eax)
}
  800b24:	90                   	nop
  800b25:	5d                   	pop    %ebp
  800b26:	c3                   	ret    

00800b27 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	01 d0                	add    %edx,%eax
  800b3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b4c:	74 06                	je     800b54 <vsnprintf+0x2d>
  800b4e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b52:	7f 07                	jg     800b5b <vsnprintf+0x34>
		return -E_INVAL;
  800b54:	b8 03 00 00 00       	mov    $0x3,%eax
  800b59:	eb 20                	jmp    800b7b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b5b:	ff 75 14             	pushl  0x14(%ebp)
  800b5e:	ff 75 10             	pushl  0x10(%ebp)
  800b61:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b64:	50                   	push   %eax
  800b65:	68 f1 0a 80 00       	push   $0x800af1
  800b6a:	e8 80 fb ff ff       	call   8006ef <vprintfmt>
  800b6f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b75:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b7b:	c9                   	leave  
  800b7c:	c3                   	ret    

00800b7d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b83:	8d 45 10             	lea    0x10(%ebp),%eax
  800b86:	83 c0 04             	add    $0x4,%eax
  800b89:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b92:	50                   	push   %eax
  800b93:	ff 75 0c             	pushl  0xc(%ebp)
  800b96:	ff 75 08             	pushl  0x8(%ebp)
  800b99:	e8 89 ff ff ff       	call   800b27 <vsnprintf>
  800b9e:	83 c4 10             	add    $0x10,%esp
  800ba1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ba7:	c9                   	leave  
  800ba8:	c3                   	ret    

00800ba9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ba9:	55                   	push   %ebp
  800baa:	89 e5                	mov    %esp,%ebp
  800bac:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800baf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb6:	eb 06                	jmp    800bbe <strlen+0x15>
		n++;
  800bb8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbb:	ff 45 08             	incl   0x8(%ebp)
  800bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc1:	8a 00                	mov    (%eax),%al
  800bc3:	84 c0                	test   %al,%al
  800bc5:	75 f1                	jne    800bb8 <strlen+0xf>
		n++;
	return n;
  800bc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bca:	c9                   	leave  
  800bcb:	c3                   	ret    

00800bcc <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd9:	eb 09                	jmp    800be4 <strnlen+0x18>
		n++;
  800bdb:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bde:	ff 45 08             	incl   0x8(%ebp)
  800be1:	ff 4d 0c             	decl   0xc(%ebp)
  800be4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be8:	74 09                	je     800bf3 <strnlen+0x27>
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	8a 00                	mov    (%eax),%al
  800bef:	84 c0                	test   %al,%al
  800bf1:	75 e8                	jne    800bdb <strnlen+0xf>
		n++;
	return n;
  800bf3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf6:	c9                   	leave  
  800bf7:	c3                   	ret    

00800bf8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c04:	90                   	nop
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	8d 50 01             	lea    0x1(%eax),%edx
  800c0b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c11:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c14:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c17:	8a 12                	mov    (%edx),%dl
  800c19:	88 10                	mov    %dl,(%eax)
  800c1b:	8a 00                	mov    (%eax),%al
  800c1d:	84 c0                	test   %al,%al
  800c1f:	75 e4                	jne    800c05 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c21:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c24:	c9                   	leave  
  800c25:	c3                   	ret    

00800c26 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c39:	eb 1f                	jmp    800c5a <strncpy+0x34>
		*dst++ = *src;
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	8d 50 01             	lea    0x1(%eax),%edx
  800c41:	89 55 08             	mov    %edx,0x8(%ebp)
  800c44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c47:	8a 12                	mov    (%edx),%dl
  800c49:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4e:	8a 00                	mov    (%eax),%al
  800c50:	84 c0                	test   %al,%al
  800c52:	74 03                	je     800c57 <strncpy+0x31>
			src++;
  800c54:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c57:	ff 45 fc             	incl   -0x4(%ebp)
  800c5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c5d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c60:	72 d9                	jb     800c3b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c62:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c65:	c9                   	leave  
  800c66:	c3                   	ret    

00800c67 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c73:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c77:	74 30                	je     800ca9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c79:	eb 16                	jmp    800c91 <strlcpy+0x2a>
			*dst++ = *src++;
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8d 50 01             	lea    0x1(%eax),%edx
  800c81:	89 55 08             	mov    %edx,0x8(%ebp)
  800c84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c87:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c8a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c8d:	8a 12                	mov    (%edx),%dl
  800c8f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c91:	ff 4d 10             	decl   0x10(%ebp)
  800c94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c98:	74 09                	je     800ca3 <strlcpy+0x3c>
  800c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9d:	8a 00                	mov    (%eax),%al
  800c9f:	84 c0                	test   %al,%al
  800ca1:	75 d8                	jne    800c7b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800caf:	29 c2                	sub    %eax,%edx
  800cb1:	89 d0                	mov    %edx,%eax
}
  800cb3:	c9                   	leave  
  800cb4:	c3                   	ret    

00800cb5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cb8:	eb 06                	jmp    800cc0 <strcmp+0xb>
		p++, q++;
  800cba:	ff 45 08             	incl   0x8(%ebp)
  800cbd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	8a 00                	mov    (%eax),%al
  800cc5:	84 c0                	test   %al,%al
  800cc7:	74 0e                	je     800cd7 <strcmp+0x22>
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	8a 10                	mov    (%eax),%dl
  800cce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd1:	8a 00                	mov    (%eax),%al
  800cd3:	38 c2                	cmp    %al,%dl
  800cd5:	74 e3                	je     800cba <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	8a 00                	mov    (%eax),%al
  800cdc:	0f b6 d0             	movzbl %al,%edx
  800cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce2:	8a 00                	mov    (%eax),%al
  800ce4:	0f b6 c0             	movzbl %al,%eax
  800ce7:	29 c2                	sub    %eax,%edx
  800ce9:	89 d0                	mov    %edx,%eax
}
  800ceb:	5d                   	pop    %ebp
  800cec:	c3                   	ret    

00800ced <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ced:	55                   	push   %ebp
  800cee:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cf0:	eb 09                	jmp    800cfb <strncmp+0xe>
		n--, p++, q++;
  800cf2:	ff 4d 10             	decl   0x10(%ebp)
  800cf5:	ff 45 08             	incl   0x8(%ebp)
  800cf8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cfb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cff:	74 17                	je     800d18 <strncmp+0x2b>
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	8a 00                	mov    (%eax),%al
  800d06:	84 c0                	test   %al,%al
  800d08:	74 0e                	je     800d18 <strncmp+0x2b>
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	8a 10                	mov    (%eax),%dl
  800d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d12:	8a 00                	mov    (%eax),%al
  800d14:	38 c2                	cmp    %al,%dl
  800d16:	74 da                	je     800cf2 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1c:	75 07                	jne    800d25 <strncmp+0x38>
		return 0;
  800d1e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d23:	eb 14                	jmp    800d39 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	8a 00                	mov    (%eax),%al
  800d2a:	0f b6 d0             	movzbl %al,%edx
  800d2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d30:	8a 00                	mov    (%eax),%al
  800d32:	0f b6 c0             	movzbl %al,%eax
  800d35:	29 c2                	sub    %eax,%edx
  800d37:	89 d0                	mov    %edx,%eax
}
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    

00800d3b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	83 ec 04             	sub    $0x4,%esp
  800d41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d44:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d47:	eb 12                	jmp    800d5b <strchr+0x20>
		if (*s == c)
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	8a 00                	mov    (%eax),%al
  800d4e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d51:	75 05                	jne    800d58 <strchr+0x1d>
			return (char *) s;
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	eb 11                	jmp    800d69 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d58:	ff 45 08             	incl   0x8(%ebp)
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	8a 00                	mov    (%eax),%al
  800d60:	84 c0                	test   %al,%al
  800d62:	75 e5                	jne    800d49 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d69:	c9                   	leave  
  800d6a:	c3                   	ret    

00800d6b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	83 ec 04             	sub    $0x4,%esp
  800d71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d74:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d77:	eb 0d                	jmp    800d86 <strfind+0x1b>
		if (*s == c)
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8a 00                	mov    (%eax),%al
  800d7e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d81:	74 0e                	je     800d91 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d83:	ff 45 08             	incl   0x8(%ebp)
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8a 00                	mov    (%eax),%al
  800d8b:	84 c0                	test   %al,%al
  800d8d:	75 ea                	jne    800d79 <strfind+0xe>
  800d8f:	eb 01                	jmp    800d92 <strfind+0x27>
		if (*s == c)
			break;
  800d91:	90                   	nop
	return (char *) s;
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d95:	c9                   	leave  
  800d96:	c3                   	ret    

00800d97 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800da3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800da7:	76 63                	jbe    800e0c <memset+0x75>
		uint64 data_block = c;
  800da9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dac:	99                   	cltd   
  800dad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800db0:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800db9:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800dbd:	c1 e0 08             	shl    $0x8,%eax
  800dc0:	09 45 f0             	or     %eax,-0x10(%ebp)
  800dc3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dcc:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800dd0:	c1 e0 10             	shl    $0x10,%eax
  800dd3:	09 45 f0             	or     %eax,-0x10(%ebp)
  800dd6:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ddc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ddf:	89 c2                	mov    %eax,%edx
  800de1:	b8 00 00 00 00       	mov    $0x0,%eax
  800de6:	09 45 f0             	or     %eax,-0x10(%ebp)
  800de9:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800dec:	eb 18                	jmp    800e06 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800dee:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800df1:	8d 41 08             	lea    0x8(%ecx),%eax
  800df4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dfd:	89 01                	mov    %eax,(%ecx)
  800dff:	89 51 04             	mov    %edx,0x4(%ecx)
  800e02:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e06:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e0a:	77 e2                	ja     800dee <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e0c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e10:	74 23                	je     800e35 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e15:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e18:	eb 0e                	jmp    800e28 <memset+0x91>
			*p8++ = (uint8)c;
  800e1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e1d:	8d 50 01             	lea    0x1(%eax),%edx
  800e20:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e23:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e26:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e28:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e2e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e31:	85 c0                	test   %eax,%eax
  800e33:	75 e5                	jne    800e1a <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e38:	c9                   	leave  
  800e39:	c3                   	ret    

00800e3a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800e4c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e50:	76 24                	jbe    800e76 <memcpy+0x3c>
		while(n >= 8){
  800e52:	eb 1c                	jmp    800e70 <memcpy+0x36>
			*d64 = *s64;
  800e54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e57:	8b 50 04             	mov    0x4(%eax),%edx
  800e5a:	8b 00                	mov    (%eax),%eax
  800e5c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800e5f:	89 01                	mov    %eax,(%ecx)
  800e61:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800e64:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800e68:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800e6c:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800e70:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e74:	77 de                	ja     800e54 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800e76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e7a:	74 31                	je     800ead <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800e7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800e82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e85:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800e88:	eb 16                	jmp    800ea0 <memcpy+0x66>
			*d8++ = *s8++;
  800e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e8d:	8d 50 01             	lea    0x1(%eax),%edx
  800e90:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800e93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e96:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e99:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800e9c:	8a 12                	mov    (%edx),%dl
  800e9e:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800ea0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea6:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea9:	85 c0                	test   %eax,%eax
  800eab:	75 dd                	jne    800e8a <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb0:	c9                   	leave  
  800eb1:	c3                   	ret    

00800eb2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800eb2:	55                   	push   %ebp
  800eb3:	89 e5                	mov    %esp,%ebp
  800eb5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ec4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eca:	73 50                	jae    800f1c <memmove+0x6a>
  800ecc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ecf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed2:	01 d0                	add    %edx,%eax
  800ed4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ed7:	76 43                	jbe    800f1c <memmove+0x6a>
		s += n;
  800ed9:	8b 45 10             	mov    0x10(%ebp),%eax
  800edc:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800edf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ee5:	eb 10                	jmp    800ef7 <memmove+0x45>
			*--d = *--s;
  800ee7:	ff 4d f8             	decl   -0x8(%ebp)
  800eea:	ff 4d fc             	decl   -0x4(%ebp)
  800eed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef0:	8a 10                	mov    (%eax),%dl
  800ef2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ef7:	8b 45 10             	mov    0x10(%ebp),%eax
  800efa:	8d 50 ff             	lea    -0x1(%eax),%edx
  800efd:	89 55 10             	mov    %edx,0x10(%ebp)
  800f00:	85 c0                	test   %eax,%eax
  800f02:	75 e3                	jne    800ee7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f04:	eb 23                	jmp    800f29 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f06:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f09:	8d 50 01             	lea    0x1(%eax),%edx
  800f0c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f0f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f12:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f15:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f18:	8a 12                	mov    (%edx),%dl
  800f1a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f22:	89 55 10             	mov    %edx,0x10(%ebp)
  800f25:	85 c0                	test   %eax,%eax
  800f27:	75 dd                	jne    800f06 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f2c:	c9                   	leave  
  800f2d:	c3                   	ret    

00800f2e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f40:	eb 2a                	jmp    800f6c <memcmp+0x3e>
		if (*s1 != *s2)
  800f42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f45:	8a 10                	mov    (%eax),%dl
  800f47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4a:	8a 00                	mov    (%eax),%al
  800f4c:	38 c2                	cmp    %al,%dl
  800f4e:	74 16                	je     800f66 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	0f b6 d0             	movzbl %al,%edx
  800f58:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5b:	8a 00                	mov    (%eax),%al
  800f5d:	0f b6 c0             	movzbl %al,%eax
  800f60:	29 c2                	sub    %eax,%edx
  800f62:	89 d0                	mov    %edx,%eax
  800f64:	eb 18                	jmp    800f7e <memcmp+0x50>
		s1++, s2++;
  800f66:	ff 45 fc             	incl   -0x4(%ebp)
  800f69:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f72:	89 55 10             	mov    %edx,0x10(%ebp)
  800f75:	85 c0                	test   %eax,%eax
  800f77:	75 c9                	jne    800f42 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f7e:	c9                   	leave  
  800f7f:	c3                   	ret    

00800f80 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
  800f83:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f86:	8b 55 08             	mov    0x8(%ebp),%edx
  800f89:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8c:	01 d0                	add    %edx,%eax
  800f8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f91:	eb 15                	jmp    800fa8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	0f b6 d0             	movzbl %al,%edx
  800f9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9e:	0f b6 c0             	movzbl %al,%eax
  800fa1:	39 c2                	cmp    %eax,%edx
  800fa3:	74 0d                	je     800fb2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fa5:	ff 45 08             	incl   0x8(%ebp)
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fae:	72 e3                	jb     800f93 <memfind+0x13>
  800fb0:	eb 01                	jmp    800fb3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fb2:	90                   	nop
	return (void *) s;
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb6:	c9                   	leave  
  800fb7:	c3                   	ret    

00800fb8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fb8:	55                   	push   %ebp
  800fb9:	89 e5                	mov    %esp,%ebp
  800fbb:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fc5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fcc:	eb 03                	jmp    800fd1 <strtol+0x19>
		s++;
  800fce:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	3c 20                	cmp    $0x20,%al
  800fd8:	74 f4                	je     800fce <strtol+0x16>
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	3c 09                	cmp    $0x9,%al
  800fe1:	74 eb                	je     800fce <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	3c 2b                	cmp    $0x2b,%al
  800fea:	75 05                	jne    800ff1 <strtol+0x39>
		s++;
  800fec:	ff 45 08             	incl   0x8(%ebp)
  800fef:	eb 13                	jmp    801004 <strtol+0x4c>
	else if (*s == '-')
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 2d                	cmp    $0x2d,%al
  800ff8:	75 0a                	jne    801004 <strtol+0x4c>
		s++, neg = 1;
  800ffa:	ff 45 08             	incl   0x8(%ebp)
  800ffd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801004:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801008:	74 06                	je     801010 <strtol+0x58>
  80100a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80100e:	75 20                	jne    801030 <strtol+0x78>
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	3c 30                	cmp    $0x30,%al
  801017:	75 17                	jne    801030 <strtol+0x78>
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	40                   	inc    %eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	3c 78                	cmp    $0x78,%al
  801021:	75 0d                	jne    801030 <strtol+0x78>
		s += 2, base = 16;
  801023:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801027:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80102e:	eb 28                	jmp    801058 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801030:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801034:	75 15                	jne    80104b <strtol+0x93>
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	3c 30                	cmp    $0x30,%al
  80103d:	75 0c                	jne    80104b <strtol+0x93>
		s++, base = 8;
  80103f:	ff 45 08             	incl   0x8(%ebp)
  801042:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801049:	eb 0d                	jmp    801058 <strtol+0xa0>
	else if (base == 0)
  80104b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80104f:	75 07                	jne    801058 <strtol+0xa0>
		base = 10;
  801051:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	3c 2f                	cmp    $0x2f,%al
  80105f:	7e 19                	jle    80107a <strtol+0xc2>
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8a 00                	mov    (%eax),%al
  801066:	3c 39                	cmp    $0x39,%al
  801068:	7f 10                	jg     80107a <strtol+0xc2>
			dig = *s - '0';
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	8a 00                	mov    (%eax),%al
  80106f:	0f be c0             	movsbl %al,%eax
  801072:	83 e8 30             	sub    $0x30,%eax
  801075:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801078:	eb 42                	jmp    8010bc <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	8a 00                	mov    (%eax),%al
  80107f:	3c 60                	cmp    $0x60,%al
  801081:	7e 19                	jle    80109c <strtol+0xe4>
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	3c 7a                	cmp    $0x7a,%al
  80108a:	7f 10                	jg     80109c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80108c:	8b 45 08             	mov    0x8(%ebp),%eax
  80108f:	8a 00                	mov    (%eax),%al
  801091:	0f be c0             	movsbl %al,%eax
  801094:	83 e8 57             	sub    $0x57,%eax
  801097:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80109a:	eb 20                	jmp    8010bc <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
  80109f:	8a 00                	mov    (%eax),%al
  8010a1:	3c 40                	cmp    $0x40,%al
  8010a3:	7e 39                	jle    8010de <strtol+0x126>
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	8a 00                	mov    (%eax),%al
  8010aa:	3c 5a                	cmp    $0x5a,%al
  8010ac:	7f 30                	jg     8010de <strtol+0x126>
			dig = *s - 'A' + 10;
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	8a 00                	mov    (%eax),%al
  8010b3:	0f be c0             	movsbl %al,%eax
  8010b6:	83 e8 37             	sub    $0x37,%eax
  8010b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010bf:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010c2:	7d 19                	jge    8010dd <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010c4:	ff 45 08             	incl   0x8(%ebp)
  8010c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ca:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010ce:	89 c2                	mov    %eax,%edx
  8010d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d3:	01 d0                	add    %edx,%eax
  8010d5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010d8:	e9 7b ff ff ff       	jmp    801058 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010dd:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010e2:	74 08                	je     8010ec <strtol+0x134>
		*endptr = (char *) s;
  8010e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ea:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f0:	74 07                	je     8010f9 <strtol+0x141>
  8010f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f5:	f7 d8                	neg    %eax
  8010f7:	eb 03                	jmp    8010fc <strtol+0x144>
  8010f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010fc:	c9                   	leave  
  8010fd:	c3                   	ret    

008010fe <ltostr>:

void
ltostr(long value, char *str)
{
  8010fe:	55                   	push   %ebp
  8010ff:	89 e5                	mov    %esp,%ebp
  801101:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801104:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80110b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801112:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801116:	79 13                	jns    80112b <ltostr+0x2d>
	{
		neg = 1;
  801118:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80111f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801122:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801125:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801128:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801133:	99                   	cltd   
  801134:	f7 f9                	idiv   %ecx
  801136:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801139:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113c:	8d 50 01             	lea    0x1(%eax),%edx
  80113f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801142:	89 c2                	mov    %eax,%edx
  801144:	8b 45 0c             	mov    0xc(%ebp),%eax
  801147:	01 d0                	add    %edx,%eax
  801149:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80114c:	83 c2 30             	add    $0x30,%edx
  80114f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801151:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801154:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801159:	f7 e9                	imul   %ecx
  80115b:	c1 fa 02             	sar    $0x2,%edx
  80115e:	89 c8                	mov    %ecx,%eax
  801160:	c1 f8 1f             	sar    $0x1f,%eax
  801163:	29 c2                	sub    %eax,%edx
  801165:	89 d0                	mov    %edx,%eax
  801167:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80116a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80116e:	75 bb                	jne    80112b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801170:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801177:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117a:	48                   	dec    %eax
  80117b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80117e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801182:	74 3d                	je     8011c1 <ltostr+0xc3>
		start = 1 ;
  801184:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80118b:	eb 34                	jmp    8011c1 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80118d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801190:	8b 45 0c             	mov    0xc(%ebp),%eax
  801193:	01 d0                	add    %edx,%eax
  801195:	8a 00                	mov    (%eax),%al
  801197:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80119a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80119d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a0:	01 c2                	add    %eax,%edx
  8011a2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a8:	01 c8                	add    %ecx,%eax
  8011aa:	8a 00                	mov    (%eax),%al
  8011ac:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b4:	01 c2                	add    %eax,%edx
  8011b6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011b9:	88 02                	mov    %al,(%edx)
		start++ ;
  8011bb:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011be:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011c7:	7c c4                	jl     80118d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011c9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cf:	01 d0                	add    %edx,%eax
  8011d1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011d4:	90                   	nop
  8011d5:	c9                   	leave  
  8011d6:	c3                   	ret    

008011d7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
  8011da:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011dd:	ff 75 08             	pushl  0x8(%ebp)
  8011e0:	e8 c4 f9 ff ff       	call   800ba9 <strlen>
  8011e5:	83 c4 04             	add    $0x4,%esp
  8011e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011eb:	ff 75 0c             	pushl  0xc(%ebp)
  8011ee:	e8 b6 f9 ff ff       	call   800ba9 <strlen>
  8011f3:	83 c4 04             	add    $0x4,%esp
  8011f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801200:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801207:	eb 17                	jmp    801220 <strcconcat+0x49>
		final[s] = str1[s] ;
  801209:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80120c:	8b 45 10             	mov    0x10(%ebp),%eax
  80120f:	01 c2                	add    %eax,%edx
  801211:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	01 c8                	add    %ecx,%eax
  801219:	8a 00                	mov    (%eax),%al
  80121b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80121d:	ff 45 fc             	incl   -0x4(%ebp)
  801220:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801223:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801226:	7c e1                	jl     801209 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801228:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80122f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801236:	eb 1f                	jmp    801257 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801238:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80123b:	8d 50 01             	lea    0x1(%eax),%edx
  80123e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801241:	89 c2                	mov    %eax,%edx
  801243:	8b 45 10             	mov    0x10(%ebp),%eax
  801246:	01 c2                	add    %eax,%edx
  801248:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80124b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124e:	01 c8                	add    %ecx,%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801254:	ff 45 f8             	incl   -0x8(%ebp)
  801257:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80125d:	7c d9                	jl     801238 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80125f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801262:	8b 45 10             	mov    0x10(%ebp),%eax
  801265:	01 d0                	add    %edx,%eax
  801267:	c6 00 00             	movb   $0x0,(%eax)
}
  80126a:	90                   	nop
  80126b:	c9                   	leave  
  80126c:	c3                   	ret    

0080126d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80126d:	55                   	push   %ebp
  80126e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801270:	8b 45 14             	mov    0x14(%ebp),%eax
  801273:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801279:	8b 45 14             	mov    0x14(%ebp),%eax
  80127c:	8b 00                	mov    (%eax),%eax
  80127e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801285:	8b 45 10             	mov    0x10(%ebp),%eax
  801288:	01 d0                	add    %edx,%eax
  80128a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801290:	eb 0c                	jmp    80129e <strsplit+0x31>
			*string++ = 0;
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8d 50 01             	lea    0x1(%eax),%edx
  801298:	89 55 08             	mov    %edx,0x8(%ebp)
  80129b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	8a 00                	mov    (%eax),%al
  8012a3:	84 c0                	test   %al,%al
  8012a5:	74 18                	je     8012bf <strsplit+0x52>
  8012a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012aa:	8a 00                	mov    (%eax),%al
  8012ac:	0f be c0             	movsbl %al,%eax
  8012af:	50                   	push   %eax
  8012b0:	ff 75 0c             	pushl  0xc(%ebp)
  8012b3:	e8 83 fa ff ff       	call   800d3b <strchr>
  8012b8:	83 c4 08             	add    $0x8,%esp
  8012bb:	85 c0                	test   %eax,%eax
  8012bd:	75 d3                	jne    801292 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	8a 00                	mov    (%eax),%al
  8012c4:	84 c0                	test   %al,%al
  8012c6:	74 5a                	je     801322 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8012cb:	8b 00                	mov    (%eax),%eax
  8012cd:	83 f8 0f             	cmp    $0xf,%eax
  8012d0:	75 07                	jne    8012d9 <strsplit+0x6c>
		{
			return 0;
  8012d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d7:	eb 66                	jmp    80133f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8012dc:	8b 00                	mov    (%eax),%eax
  8012de:	8d 48 01             	lea    0x1(%eax),%ecx
  8012e1:	8b 55 14             	mov    0x14(%ebp),%edx
  8012e4:	89 0a                	mov    %ecx,(%edx)
  8012e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f0:	01 c2                	add    %eax,%edx
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012f7:	eb 03                	jmp    8012fc <strsplit+0x8f>
			string++;
  8012f9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	8a 00                	mov    (%eax),%al
  801301:	84 c0                	test   %al,%al
  801303:	74 8b                	je     801290 <strsplit+0x23>
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	0f be c0             	movsbl %al,%eax
  80130d:	50                   	push   %eax
  80130e:	ff 75 0c             	pushl  0xc(%ebp)
  801311:	e8 25 fa ff ff       	call   800d3b <strchr>
  801316:	83 c4 08             	add    $0x8,%esp
  801319:	85 c0                	test   %eax,%eax
  80131b:	74 dc                	je     8012f9 <strsplit+0x8c>
			string++;
	}
  80131d:	e9 6e ff ff ff       	jmp    801290 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801322:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801323:	8b 45 14             	mov    0x14(%ebp),%eax
  801326:	8b 00                	mov    (%eax),%eax
  801328:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80132f:	8b 45 10             	mov    0x10(%ebp),%eax
  801332:	01 d0                	add    %edx,%eax
  801334:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80133a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80133f:	c9                   	leave  
  801340:	c3                   	ret    

00801341 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801341:	55                   	push   %ebp
  801342:	89 e5                	mov    %esp,%ebp
  801344:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801347:	8b 45 08             	mov    0x8(%ebp),%eax
  80134a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80134d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801354:	eb 4a                	jmp    8013a0 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801356:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	01 c2                	add    %eax,%edx
  80135e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801361:	8b 45 0c             	mov    0xc(%ebp),%eax
  801364:	01 c8                	add    %ecx,%eax
  801366:	8a 00                	mov    (%eax),%al
  801368:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80136a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80136d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801370:	01 d0                	add    %edx,%eax
  801372:	8a 00                	mov    (%eax),%al
  801374:	3c 40                	cmp    $0x40,%al
  801376:	7e 25                	jle    80139d <str2lower+0x5c>
  801378:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80137b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137e:	01 d0                	add    %edx,%eax
  801380:	8a 00                	mov    (%eax),%al
  801382:	3c 5a                	cmp    $0x5a,%al
  801384:	7f 17                	jg     80139d <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801386:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	01 d0                	add    %edx,%eax
  80138e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801391:	8b 55 08             	mov    0x8(%ebp),%edx
  801394:	01 ca                	add    %ecx,%edx
  801396:	8a 12                	mov    (%edx),%dl
  801398:	83 c2 20             	add    $0x20,%edx
  80139b:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80139d:	ff 45 fc             	incl   -0x4(%ebp)
  8013a0:	ff 75 0c             	pushl  0xc(%ebp)
  8013a3:	e8 01 f8 ff ff       	call   800ba9 <strlen>
  8013a8:	83 c4 04             	add    $0x4,%esp
  8013ab:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013ae:	7f a6                	jg     801356 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8013b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    

008013b5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
  8013b8:	57                   	push   %edi
  8013b9:	56                   	push   %esi
  8013ba:	53                   	push   %ebx
  8013bb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013ca:	8b 7d 18             	mov    0x18(%ebp),%edi
  8013cd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8013d0:	cd 30                	int    $0x30
  8013d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8013d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013d8:	83 c4 10             	add    $0x10,%esp
  8013db:	5b                   	pop    %ebx
  8013dc:	5e                   	pop    %esi
  8013dd:	5f                   	pop    %edi
  8013de:	5d                   	pop    %ebp
  8013df:	c3                   	ret    

008013e0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
  8013e3:	83 ec 04             	sub    $0x4,%esp
  8013e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8013ec:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013ef:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f6:	6a 00                	push   $0x0
  8013f8:	51                   	push   %ecx
  8013f9:	52                   	push   %edx
  8013fa:	ff 75 0c             	pushl  0xc(%ebp)
  8013fd:	50                   	push   %eax
  8013fe:	6a 00                	push   $0x0
  801400:	e8 b0 ff ff ff       	call   8013b5 <syscall>
  801405:	83 c4 18             	add    $0x18,%esp
}
  801408:	90                   	nop
  801409:	c9                   	leave  
  80140a:	c3                   	ret    

0080140b <sys_cgetc>:

int
sys_cgetc(void)
{
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80140e:	6a 00                	push   $0x0
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 02                	push   $0x2
  80141a:	e8 96 ff ff ff       	call   8013b5 <syscall>
  80141f:	83 c4 18             	add    $0x18,%esp
}
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 03                	push   $0x3
  801433:	e8 7d ff ff ff       	call   8013b5 <syscall>
  801438:	83 c4 18             	add    $0x18,%esp
}
  80143b:	90                   	nop
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    

0080143e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 00                	push   $0x0
  801449:	6a 00                	push   $0x0
  80144b:	6a 04                	push   $0x4
  80144d:	e8 63 ff ff ff       	call   8013b5 <syscall>
  801452:	83 c4 18             	add    $0x18,%esp
}
  801455:	90                   	nop
  801456:	c9                   	leave  
  801457:	c3                   	ret    

00801458 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80145b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145e:	8b 45 08             	mov    0x8(%ebp),%eax
  801461:	6a 00                	push   $0x0
  801463:	6a 00                	push   $0x0
  801465:	6a 00                	push   $0x0
  801467:	52                   	push   %edx
  801468:	50                   	push   %eax
  801469:	6a 08                	push   $0x8
  80146b:	e8 45 ff ff ff       	call   8013b5 <syscall>
  801470:	83 c4 18             	add    $0x18,%esp
}
  801473:	c9                   	leave  
  801474:	c3                   	ret    

00801475 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
  801478:	56                   	push   %esi
  801479:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80147a:	8b 75 18             	mov    0x18(%ebp),%esi
  80147d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801480:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801483:	8b 55 0c             	mov    0xc(%ebp),%edx
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
  801489:	56                   	push   %esi
  80148a:	53                   	push   %ebx
  80148b:	51                   	push   %ecx
  80148c:	52                   	push   %edx
  80148d:	50                   	push   %eax
  80148e:	6a 09                	push   $0x9
  801490:	e8 20 ff ff ff       	call   8013b5 <syscall>
  801495:	83 c4 18             	add    $0x18,%esp
}
  801498:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80149b:	5b                   	pop    %ebx
  80149c:	5e                   	pop    %esi
  80149d:	5d                   	pop    %ebp
  80149e:	c3                   	ret    

0080149f <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	ff 75 08             	pushl  0x8(%ebp)
  8014ad:	6a 0a                	push   $0xa
  8014af:	e8 01 ff ff ff       	call   8013b5 <syscall>
  8014b4:	83 c4 18             	add    $0x18,%esp
}
  8014b7:	c9                   	leave  
  8014b8:	c3                   	ret    

008014b9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	ff 75 0c             	pushl  0xc(%ebp)
  8014c5:	ff 75 08             	pushl  0x8(%ebp)
  8014c8:	6a 0b                	push   $0xb
  8014ca:	e8 e6 fe ff ff       	call   8013b5 <syscall>
  8014cf:	83 c4 18             	add    $0x18,%esp
}
  8014d2:	c9                   	leave  
  8014d3:	c3                   	ret    

008014d4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 00                	push   $0x0
  8014e1:	6a 0c                	push   $0xc
  8014e3:	e8 cd fe ff ff       	call   8013b5 <syscall>
  8014e8:	83 c4 18             	add    $0x18,%esp
}
  8014eb:	c9                   	leave  
  8014ec:	c3                   	ret    

008014ed <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 0d                	push   $0xd
  8014fc:	e8 b4 fe ff ff       	call   8013b5 <syscall>
  801501:	83 c4 18             	add    $0x18,%esp
}
  801504:	c9                   	leave  
  801505:	c3                   	ret    

00801506 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 0e                	push   $0xe
  801515:	e8 9b fe ff ff       	call   8013b5 <syscall>
  80151a:	83 c4 18             	add    $0x18,%esp
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 0f                	push   $0xf
  80152e:	e8 82 fe ff ff       	call   8013b5 <syscall>
  801533:	83 c4 18             	add    $0x18,%esp
}
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	ff 75 08             	pushl  0x8(%ebp)
  801546:	6a 10                	push   $0x10
  801548:	e8 68 fe ff ff       	call   8013b5 <syscall>
  80154d:	83 c4 18             	add    $0x18,%esp
}
  801550:	c9                   	leave  
  801551:	c3                   	ret    

00801552 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801552:	55                   	push   %ebp
  801553:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 11                	push   $0x11
  801561:	e8 4f fe ff ff       	call   8013b5 <syscall>
  801566:	83 c4 18             	add    $0x18,%esp
}
  801569:	90                   	nop
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    

0080156c <sys_cputc>:

void
sys_cputc(const char c)
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
  80156f:	83 ec 04             	sub    $0x4,%esp
  801572:	8b 45 08             	mov    0x8(%ebp),%eax
  801575:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801578:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	50                   	push   %eax
  801585:	6a 01                	push   $0x1
  801587:	e8 29 fe ff ff       	call   8013b5 <syscall>
  80158c:	83 c4 18             	add    $0x18,%esp
}
  80158f:	90                   	nop
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 14                	push   $0x14
  8015a1:	e8 0f fe ff ff       	call   8013b5 <syscall>
  8015a6:	83 c4 18             	add    $0x18,%esp
}
  8015a9:	90                   	nop
  8015aa:	c9                   	leave  
  8015ab:	c3                   	ret    

008015ac <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
  8015af:	83 ec 04             	sub    $0x4,%esp
  8015b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8015b8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015bb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c2:	6a 00                	push   $0x0
  8015c4:	51                   	push   %ecx
  8015c5:	52                   	push   %edx
  8015c6:	ff 75 0c             	pushl  0xc(%ebp)
  8015c9:	50                   	push   %eax
  8015ca:	6a 15                	push   $0x15
  8015cc:	e8 e4 fd ff ff       	call   8013b5 <syscall>
  8015d1:	83 c4 18             	add    $0x18,%esp
}
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    

008015d6 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8015d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	52                   	push   %edx
  8015e6:	50                   	push   %eax
  8015e7:	6a 16                	push   $0x16
  8015e9:	e8 c7 fd ff ff       	call   8013b5 <syscall>
  8015ee:	83 c4 18             	add    $0x18,%esp
}
  8015f1:	c9                   	leave  
  8015f2:	c3                   	ret    

008015f3 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8015f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	51                   	push   %ecx
  801604:	52                   	push   %edx
  801605:	50                   	push   %eax
  801606:	6a 17                	push   $0x17
  801608:	e8 a8 fd ff ff       	call   8013b5 <syscall>
  80160d:	83 c4 18             	add    $0x18,%esp
}
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801615:	8b 55 0c             	mov    0xc(%ebp),%edx
  801618:	8b 45 08             	mov    0x8(%ebp),%eax
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	52                   	push   %edx
  801622:	50                   	push   %eax
  801623:	6a 18                	push   $0x18
  801625:	e8 8b fd ff ff       	call   8013b5 <syscall>
  80162a:	83 c4 18             	add    $0x18,%esp
}
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	6a 00                	push   $0x0
  801637:	ff 75 14             	pushl  0x14(%ebp)
  80163a:	ff 75 10             	pushl  0x10(%ebp)
  80163d:	ff 75 0c             	pushl  0xc(%ebp)
  801640:	50                   	push   %eax
  801641:	6a 19                	push   $0x19
  801643:	e8 6d fd ff ff       	call   8013b5 <syscall>
  801648:	83 c4 18             	add    $0x18,%esp
}
  80164b:	c9                   	leave  
  80164c:	c3                   	ret    

0080164d <sys_run_env>:

void sys_run_env(int32 envId)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	50                   	push   %eax
  80165c:	6a 1a                	push   $0x1a
  80165e:	e8 52 fd ff ff       	call   8013b5 <syscall>
  801663:	83 c4 18             	add    $0x18,%esp
}
  801666:	90                   	nop
  801667:	c9                   	leave  
  801668:	c3                   	ret    

00801669 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80166c:	8b 45 08             	mov    0x8(%ebp),%eax
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	50                   	push   %eax
  801678:	6a 1b                	push   $0x1b
  80167a:	e8 36 fd ff ff       	call   8013b5 <syscall>
  80167f:	83 c4 18             	add    $0x18,%esp
}
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 05                	push   $0x5
  801693:	e8 1d fd ff ff       	call   8013b5 <syscall>
  801698:	83 c4 18             	add    $0x18,%esp
}
  80169b:	c9                   	leave  
  80169c:	c3                   	ret    

0080169d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 06                	push   $0x6
  8016ac:	e8 04 fd ff ff       	call   8013b5 <syscall>
  8016b1:	83 c4 18             	add    $0x18,%esp
}
  8016b4:	c9                   	leave  
  8016b5:	c3                   	ret    

008016b6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 07                	push   $0x7
  8016c5:	e8 eb fc ff ff       	call   8013b5 <syscall>
  8016ca:	83 c4 18             	add    $0x18,%esp
}
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <sys_exit_env>:


void sys_exit_env(void)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 1c                	push   $0x1c
  8016de:	e8 d2 fc ff ff       	call   8013b5 <syscall>
  8016e3:	83 c4 18             	add    $0x18,%esp
}
  8016e6:	90                   	nop
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016ef:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016f2:	8d 50 04             	lea    0x4(%eax),%edx
  8016f5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	52                   	push   %edx
  8016ff:	50                   	push   %eax
  801700:	6a 1d                	push   $0x1d
  801702:	e8 ae fc ff ff       	call   8013b5 <syscall>
  801707:	83 c4 18             	add    $0x18,%esp
	return result;
  80170a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80170d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801710:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801713:	89 01                	mov    %eax,(%ecx)
  801715:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801718:	8b 45 08             	mov    0x8(%ebp),%eax
  80171b:	c9                   	leave  
  80171c:	c2 04 00             	ret    $0x4

0080171f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	ff 75 10             	pushl  0x10(%ebp)
  801729:	ff 75 0c             	pushl  0xc(%ebp)
  80172c:	ff 75 08             	pushl  0x8(%ebp)
  80172f:	6a 13                	push   $0x13
  801731:	e8 7f fc ff ff       	call   8013b5 <syscall>
  801736:	83 c4 18             	add    $0x18,%esp
	return ;
  801739:	90                   	nop
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <sys_rcr2>:
uint32 sys_rcr2()
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 1e                	push   $0x1e
  80174b:	e8 65 fc ff ff       	call   8013b5 <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
  801758:	83 ec 04             	sub    $0x4,%esp
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801761:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	50                   	push   %eax
  80176e:	6a 1f                	push   $0x1f
  801770:	e8 40 fc ff ff       	call   8013b5 <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
	return ;
  801778:	90                   	nop
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <rsttst>:
void rsttst()
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 21                	push   $0x21
  80178a:	e8 26 fc ff ff       	call   8013b5 <syscall>
  80178f:	83 c4 18             	add    $0x18,%esp
	return ;
  801792:	90                   	nop
}
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	83 ec 04             	sub    $0x4,%esp
  80179b:	8b 45 14             	mov    0x14(%ebp),%eax
  80179e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017a1:	8b 55 18             	mov    0x18(%ebp),%edx
  8017a4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017a8:	52                   	push   %edx
  8017a9:	50                   	push   %eax
  8017aa:	ff 75 10             	pushl  0x10(%ebp)
  8017ad:	ff 75 0c             	pushl  0xc(%ebp)
  8017b0:	ff 75 08             	pushl  0x8(%ebp)
  8017b3:	6a 20                	push   $0x20
  8017b5:	e8 fb fb ff ff       	call   8013b5 <syscall>
  8017ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8017bd:	90                   	nop
}
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <chktst>:
void chktst(uint32 n)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	ff 75 08             	pushl  0x8(%ebp)
  8017ce:	6a 22                	push   $0x22
  8017d0:	e8 e0 fb ff ff       	call   8013b5 <syscall>
  8017d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d8:	90                   	nop
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <inctst>:

void inctst()
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 23                	push   $0x23
  8017ea:	e8 c6 fb ff ff       	call   8013b5 <syscall>
  8017ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f2:	90                   	nop
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <gettst>:
uint32 gettst()
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 24                	push   $0x24
  801804:	e8 ac fb ff ff       	call   8013b5 <syscall>
  801809:	83 c4 18             	add    $0x18,%esp
}
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 25                	push   $0x25
  80181d:	e8 93 fb ff ff       	call   8013b5 <syscall>
  801822:	83 c4 18             	add    $0x18,%esp
  801825:	a3 80 70 82 00       	mov    %eax,0x827080
	return uheapPlaceStrategy ;
  80182a:	a1 80 70 82 00       	mov    0x827080,%eax
}
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801834:	8b 45 08             	mov    0x8(%ebp),%eax
  801837:	a3 80 70 82 00       	mov    %eax,0x827080
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	ff 75 08             	pushl  0x8(%ebp)
  801847:	6a 26                	push   $0x26
  801849:	e8 67 fb ff ff       	call   8013b5 <syscall>
  80184e:	83 c4 18             	add    $0x18,%esp
	return ;
  801851:	90                   	nop
}
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801858:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80185b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80185e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	6a 00                	push   $0x0
  801866:	53                   	push   %ebx
  801867:	51                   	push   %ecx
  801868:	52                   	push   %edx
  801869:	50                   	push   %eax
  80186a:	6a 27                	push   $0x27
  80186c:	e8 44 fb ff ff       	call   8013b5 <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80187c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187f:	8b 45 08             	mov    0x8(%ebp),%eax
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	52                   	push   %edx
  801889:	50                   	push   %eax
  80188a:	6a 28                	push   $0x28
  80188c:	e8 24 fb ff ff       	call   8013b5 <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
}
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801899:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80189c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a2:	6a 00                	push   $0x0
  8018a4:	51                   	push   %ecx
  8018a5:	ff 75 10             	pushl  0x10(%ebp)
  8018a8:	52                   	push   %edx
  8018a9:	50                   	push   %eax
  8018aa:	6a 29                	push   $0x29
  8018ac:	e8 04 fb ff ff       	call   8013b5 <syscall>
  8018b1:	83 c4 18             	add    $0x18,%esp
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	ff 75 10             	pushl  0x10(%ebp)
  8018c0:	ff 75 0c             	pushl  0xc(%ebp)
  8018c3:	ff 75 08             	pushl  0x8(%ebp)
  8018c6:	6a 12                	push   $0x12
  8018c8:	e8 e8 fa ff ff       	call   8013b5 <syscall>
  8018cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d0:	90                   	nop
}
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8018d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	52                   	push   %edx
  8018e3:	50                   	push   %eax
  8018e4:	6a 2a                	push   $0x2a
  8018e6:	e8 ca fa ff ff       	call   8013b5 <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
	return;
  8018ee:	90                   	nop
}
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 2b                	push   $0x2b
  801900:	e8 b0 fa ff ff       	call   8013b5 <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
}
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	ff 75 0c             	pushl  0xc(%ebp)
  801916:	ff 75 08             	pushl  0x8(%ebp)
  801919:	6a 2d                	push   $0x2d
  80191b:	e8 95 fa ff ff       	call   8013b5 <syscall>
  801920:	83 c4 18             	add    $0x18,%esp
	return;
  801923:	90                   	nop
}
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	ff 75 0c             	pushl  0xc(%ebp)
  801932:	ff 75 08             	pushl  0x8(%ebp)
  801935:	6a 2c                	push   $0x2c
  801937:	e8 79 fa ff ff       	call   8013b5 <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
	return ;
  80193f:	90                   	nop
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801948:	83 ec 04             	sub    $0x4,%esp
  80194b:	68 48 22 80 00       	push   $0x802248
  801950:	68 25 01 00 00       	push   $0x125
  801955:	68 7b 22 80 00       	push   $0x80227b
  80195a:	e8 a3 e8 ff ff       	call   800202 <_panic>
  80195f:	90                   	nop

00801960 <__udivdi3>:
  801960:	55                   	push   %ebp
  801961:	57                   	push   %edi
  801962:	56                   	push   %esi
  801963:	53                   	push   %ebx
  801964:	83 ec 1c             	sub    $0x1c,%esp
  801967:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80196b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80196f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801973:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801977:	89 ca                	mov    %ecx,%edx
  801979:	89 f8                	mov    %edi,%eax
  80197b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80197f:	85 f6                	test   %esi,%esi
  801981:	75 2d                	jne    8019b0 <__udivdi3+0x50>
  801983:	39 cf                	cmp    %ecx,%edi
  801985:	77 65                	ja     8019ec <__udivdi3+0x8c>
  801987:	89 fd                	mov    %edi,%ebp
  801989:	85 ff                	test   %edi,%edi
  80198b:	75 0b                	jne    801998 <__udivdi3+0x38>
  80198d:	b8 01 00 00 00       	mov    $0x1,%eax
  801992:	31 d2                	xor    %edx,%edx
  801994:	f7 f7                	div    %edi
  801996:	89 c5                	mov    %eax,%ebp
  801998:	31 d2                	xor    %edx,%edx
  80199a:	89 c8                	mov    %ecx,%eax
  80199c:	f7 f5                	div    %ebp
  80199e:	89 c1                	mov    %eax,%ecx
  8019a0:	89 d8                	mov    %ebx,%eax
  8019a2:	f7 f5                	div    %ebp
  8019a4:	89 cf                	mov    %ecx,%edi
  8019a6:	89 fa                	mov    %edi,%edx
  8019a8:	83 c4 1c             	add    $0x1c,%esp
  8019ab:	5b                   	pop    %ebx
  8019ac:	5e                   	pop    %esi
  8019ad:	5f                   	pop    %edi
  8019ae:	5d                   	pop    %ebp
  8019af:	c3                   	ret    
  8019b0:	39 ce                	cmp    %ecx,%esi
  8019b2:	77 28                	ja     8019dc <__udivdi3+0x7c>
  8019b4:	0f bd fe             	bsr    %esi,%edi
  8019b7:	83 f7 1f             	xor    $0x1f,%edi
  8019ba:	75 40                	jne    8019fc <__udivdi3+0x9c>
  8019bc:	39 ce                	cmp    %ecx,%esi
  8019be:	72 0a                	jb     8019ca <__udivdi3+0x6a>
  8019c0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019c4:	0f 87 9e 00 00 00    	ja     801a68 <__udivdi3+0x108>
  8019ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8019cf:	89 fa                	mov    %edi,%edx
  8019d1:	83 c4 1c             	add    $0x1c,%esp
  8019d4:	5b                   	pop    %ebx
  8019d5:	5e                   	pop    %esi
  8019d6:	5f                   	pop    %edi
  8019d7:	5d                   	pop    %ebp
  8019d8:	c3                   	ret    
  8019d9:	8d 76 00             	lea    0x0(%esi),%esi
  8019dc:	31 ff                	xor    %edi,%edi
  8019de:	31 c0                	xor    %eax,%eax
  8019e0:	89 fa                	mov    %edi,%edx
  8019e2:	83 c4 1c             	add    $0x1c,%esp
  8019e5:	5b                   	pop    %ebx
  8019e6:	5e                   	pop    %esi
  8019e7:	5f                   	pop    %edi
  8019e8:	5d                   	pop    %ebp
  8019e9:	c3                   	ret    
  8019ea:	66 90                	xchg   %ax,%ax
  8019ec:	89 d8                	mov    %ebx,%eax
  8019ee:	f7 f7                	div    %edi
  8019f0:	31 ff                	xor    %edi,%edi
  8019f2:	89 fa                	mov    %edi,%edx
  8019f4:	83 c4 1c             	add    $0x1c,%esp
  8019f7:	5b                   	pop    %ebx
  8019f8:	5e                   	pop    %esi
  8019f9:	5f                   	pop    %edi
  8019fa:	5d                   	pop    %ebp
  8019fb:	c3                   	ret    
  8019fc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a01:	89 eb                	mov    %ebp,%ebx
  801a03:	29 fb                	sub    %edi,%ebx
  801a05:	89 f9                	mov    %edi,%ecx
  801a07:	d3 e6                	shl    %cl,%esi
  801a09:	89 c5                	mov    %eax,%ebp
  801a0b:	88 d9                	mov    %bl,%cl
  801a0d:	d3 ed                	shr    %cl,%ebp
  801a0f:	89 e9                	mov    %ebp,%ecx
  801a11:	09 f1                	or     %esi,%ecx
  801a13:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a17:	89 f9                	mov    %edi,%ecx
  801a19:	d3 e0                	shl    %cl,%eax
  801a1b:	89 c5                	mov    %eax,%ebp
  801a1d:	89 d6                	mov    %edx,%esi
  801a1f:	88 d9                	mov    %bl,%cl
  801a21:	d3 ee                	shr    %cl,%esi
  801a23:	89 f9                	mov    %edi,%ecx
  801a25:	d3 e2                	shl    %cl,%edx
  801a27:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a2b:	88 d9                	mov    %bl,%cl
  801a2d:	d3 e8                	shr    %cl,%eax
  801a2f:	09 c2                	or     %eax,%edx
  801a31:	89 d0                	mov    %edx,%eax
  801a33:	89 f2                	mov    %esi,%edx
  801a35:	f7 74 24 0c          	divl   0xc(%esp)
  801a39:	89 d6                	mov    %edx,%esi
  801a3b:	89 c3                	mov    %eax,%ebx
  801a3d:	f7 e5                	mul    %ebp
  801a3f:	39 d6                	cmp    %edx,%esi
  801a41:	72 19                	jb     801a5c <__udivdi3+0xfc>
  801a43:	74 0b                	je     801a50 <__udivdi3+0xf0>
  801a45:	89 d8                	mov    %ebx,%eax
  801a47:	31 ff                	xor    %edi,%edi
  801a49:	e9 58 ff ff ff       	jmp    8019a6 <__udivdi3+0x46>
  801a4e:	66 90                	xchg   %ax,%ax
  801a50:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a54:	89 f9                	mov    %edi,%ecx
  801a56:	d3 e2                	shl    %cl,%edx
  801a58:	39 c2                	cmp    %eax,%edx
  801a5a:	73 e9                	jae    801a45 <__udivdi3+0xe5>
  801a5c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a5f:	31 ff                	xor    %edi,%edi
  801a61:	e9 40 ff ff ff       	jmp    8019a6 <__udivdi3+0x46>
  801a66:	66 90                	xchg   %ax,%ax
  801a68:	31 c0                	xor    %eax,%eax
  801a6a:	e9 37 ff ff ff       	jmp    8019a6 <__udivdi3+0x46>
  801a6f:	90                   	nop

00801a70 <__umoddi3>:
  801a70:	55                   	push   %ebp
  801a71:	57                   	push   %edi
  801a72:	56                   	push   %esi
  801a73:	53                   	push   %ebx
  801a74:	83 ec 1c             	sub    $0x1c,%esp
  801a77:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a7b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a83:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a8b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a8f:	89 f3                	mov    %esi,%ebx
  801a91:	89 fa                	mov    %edi,%edx
  801a93:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a97:	89 34 24             	mov    %esi,(%esp)
  801a9a:	85 c0                	test   %eax,%eax
  801a9c:	75 1a                	jne    801ab8 <__umoddi3+0x48>
  801a9e:	39 f7                	cmp    %esi,%edi
  801aa0:	0f 86 a2 00 00 00    	jbe    801b48 <__umoddi3+0xd8>
  801aa6:	89 c8                	mov    %ecx,%eax
  801aa8:	89 f2                	mov    %esi,%edx
  801aaa:	f7 f7                	div    %edi
  801aac:	89 d0                	mov    %edx,%eax
  801aae:	31 d2                	xor    %edx,%edx
  801ab0:	83 c4 1c             	add    $0x1c,%esp
  801ab3:	5b                   	pop    %ebx
  801ab4:	5e                   	pop    %esi
  801ab5:	5f                   	pop    %edi
  801ab6:	5d                   	pop    %ebp
  801ab7:	c3                   	ret    
  801ab8:	39 f0                	cmp    %esi,%eax
  801aba:	0f 87 ac 00 00 00    	ja     801b6c <__umoddi3+0xfc>
  801ac0:	0f bd e8             	bsr    %eax,%ebp
  801ac3:	83 f5 1f             	xor    $0x1f,%ebp
  801ac6:	0f 84 ac 00 00 00    	je     801b78 <__umoddi3+0x108>
  801acc:	bf 20 00 00 00       	mov    $0x20,%edi
  801ad1:	29 ef                	sub    %ebp,%edi
  801ad3:	89 fe                	mov    %edi,%esi
  801ad5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ad9:	89 e9                	mov    %ebp,%ecx
  801adb:	d3 e0                	shl    %cl,%eax
  801add:	89 d7                	mov    %edx,%edi
  801adf:	89 f1                	mov    %esi,%ecx
  801ae1:	d3 ef                	shr    %cl,%edi
  801ae3:	09 c7                	or     %eax,%edi
  801ae5:	89 e9                	mov    %ebp,%ecx
  801ae7:	d3 e2                	shl    %cl,%edx
  801ae9:	89 14 24             	mov    %edx,(%esp)
  801aec:	89 d8                	mov    %ebx,%eax
  801aee:	d3 e0                	shl    %cl,%eax
  801af0:	89 c2                	mov    %eax,%edx
  801af2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801af6:	d3 e0                	shl    %cl,%eax
  801af8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801afc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b00:	89 f1                	mov    %esi,%ecx
  801b02:	d3 e8                	shr    %cl,%eax
  801b04:	09 d0                	or     %edx,%eax
  801b06:	d3 eb                	shr    %cl,%ebx
  801b08:	89 da                	mov    %ebx,%edx
  801b0a:	f7 f7                	div    %edi
  801b0c:	89 d3                	mov    %edx,%ebx
  801b0e:	f7 24 24             	mull   (%esp)
  801b11:	89 c6                	mov    %eax,%esi
  801b13:	89 d1                	mov    %edx,%ecx
  801b15:	39 d3                	cmp    %edx,%ebx
  801b17:	0f 82 87 00 00 00    	jb     801ba4 <__umoddi3+0x134>
  801b1d:	0f 84 91 00 00 00    	je     801bb4 <__umoddi3+0x144>
  801b23:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b27:	29 f2                	sub    %esi,%edx
  801b29:	19 cb                	sbb    %ecx,%ebx
  801b2b:	89 d8                	mov    %ebx,%eax
  801b2d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b31:	d3 e0                	shl    %cl,%eax
  801b33:	89 e9                	mov    %ebp,%ecx
  801b35:	d3 ea                	shr    %cl,%edx
  801b37:	09 d0                	or     %edx,%eax
  801b39:	89 e9                	mov    %ebp,%ecx
  801b3b:	d3 eb                	shr    %cl,%ebx
  801b3d:	89 da                	mov    %ebx,%edx
  801b3f:	83 c4 1c             	add    $0x1c,%esp
  801b42:	5b                   	pop    %ebx
  801b43:	5e                   	pop    %esi
  801b44:	5f                   	pop    %edi
  801b45:	5d                   	pop    %ebp
  801b46:	c3                   	ret    
  801b47:	90                   	nop
  801b48:	89 fd                	mov    %edi,%ebp
  801b4a:	85 ff                	test   %edi,%edi
  801b4c:	75 0b                	jne    801b59 <__umoddi3+0xe9>
  801b4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b53:	31 d2                	xor    %edx,%edx
  801b55:	f7 f7                	div    %edi
  801b57:	89 c5                	mov    %eax,%ebp
  801b59:	89 f0                	mov    %esi,%eax
  801b5b:	31 d2                	xor    %edx,%edx
  801b5d:	f7 f5                	div    %ebp
  801b5f:	89 c8                	mov    %ecx,%eax
  801b61:	f7 f5                	div    %ebp
  801b63:	89 d0                	mov    %edx,%eax
  801b65:	e9 44 ff ff ff       	jmp    801aae <__umoddi3+0x3e>
  801b6a:	66 90                	xchg   %ax,%ax
  801b6c:	89 c8                	mov    %ecx,%eax
  801b6e:	89 f2                	mov    %esi,%edx
  801b70:	83 c4 1c             	add    $0x1c,%esp
  801b73:	5b                   	pop    %ebx
  801b74:	5e                   	pop    %esi
  801b75:	5f                   	pop    %edi
  801b76:	5d                   	pop    %ebp
  801b77:	c3                   	ret    
  801b78:	3b 04 24             	cmp    (%esp),%eax
  801b7b:	72 06                	jb     801b83 <__umoddi3+0x113>
  801b7d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b81:	77 0f                	ja     801b92 <__umoddi3+0x122>
  801b83:	89 f2                	mov    %esi,%edx
  801b85:	29 f9                	sub    %edi,%ecx
  801b87:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b8b:	89 14 24             	mov    %edx,(%esp)
  801b8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b92:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b96:	8b 14 24             	mov    (%esp),%edx
  801b99:	83 c4 1c             	add    $0x1c,%esp
  801b9c:	5b                   	pop    %ebx
  801b9d:	5e                   	pop    %esi
  801b9e:	5f                   	pop    %edi
  801b9f:	5d                   	pop    %ebp
  801ba0:	c3                   	ret    
  801ba1:	8d 76 00             	lea    0x0(%esi),%esi
  801ba4:	2b 04 24             	sub    (%esp),%eax
  801ba7:	19 fa                	sbb    %edi,%edx
  801ba9:	89 d1                	mov    %edx,%ecx
  801bab:	89 c6                	mov    %eax,%esi
  801bad:	e9 71 ff ff ff       	jmp    801b23 <__umoddi3+0xb3>
  801bb2:	66 90                	xchg   %ax,%ax
  801bb4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bb8:	72 ea                	jb     801ba4 <__umoddi3+0x134>
  801bba:	89 d9                	mov    %ebx,%ecx
  801bbc:	e9 62 ff ff ff       	jmp    801b23 <__umoddi3+0xb3>

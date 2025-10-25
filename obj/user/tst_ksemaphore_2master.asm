
obj/user/tst_ksemaphore_2master:     file format elf32-i386


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
  800031:	e8 1f 00 00 00       	call   800055 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: take user input, create the semaphores, run slaves and wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	panic("UPDATE IS REQUIRED");
  800041:	83 ec 04             	sub    $0x4,%esp
  800044:	68 e0 1b 80 00       	push   $0x801be0
  800049:	6a 08                	push   $0x8
  80004b:	68 f3 1b 80 00       	push   $0x801bf3
  800050:	e8 b0 01 00 00       	call   800205 <_panic>

00800055 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800055:	55                   	push   %ebp
  800056:	89 e5                	mov    %esp,%ebp
  800058:	57                   	push   %edi
  800059:	56                   	push   %esi
  80005a:	53                   	push   %ebx
  80005b:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80005e:	e8 3d 16 00 00       	call   8016a0 <sys_getenvindex>
  800063:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800066:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800069:	89 d0                	mov    %edx,%eax
  80006b:	c1 e0 02             	shl    $0x2,%eax
  80006e:	01 d0                	add    %edx,%eax
  800070:	c1 e0 03             	shl    $0x3,%eax
  800073:	01 d0                	add    %edx,%eax
  800075:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80007c:	01 d0                	add    %edx,%eax
  80007e:	c1 e0 02             	shl    $0x2,%eax
  800081:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800086:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80008b:	a1 20 30 80 00       	mov    0x803020,%eax
  800090:	8a 40 20             	mov    0x20(%eax),%al
  800093:	84 c0                	test   %al,%al
  800095:	74 0d                	je     8000a4 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800097:	a1 20 30 80 00       	mov    0x803020,%eax
  80009c:	83 c0 20             	add    $0x20,%eax
  80009f:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a8:	7e 0a                	jle    8000b4 <libmain+0x5f>
		binaryname = argv[0];
  8000aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ad:	8b 00                	mov    (%eax),%eax
  8000af:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000b4:	83 ec 08             	sub    $0x8,%esp
  8000b7:	ff 75 0c             	pushl  0xc(%ebp)
  8000ba:	ff 75 08             	pushl  0x8(%ebp)
  8000bd:	e8 76 ff ff ff       	call   800038 <_main>
  8000c2:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000c5:	a1 00 30 80 00       	mov    0x803000,%eax
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	0f 84 01 01 00 00    	je     8001d3 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8000d2:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8000d8:	bb 0c 1d 80 00       	mov    $0x801d0c,%ebx
  8000dd:	ba 0e 00 00 00       	mov    $0xe,%edx
  8000e2:	89 c7                	mov    %eax,%edi
  8000e4:	89 de                	mov    %ebx,%esi
  8000e6:	89 d1                	mov    %edx,%ecx
  8000e8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000ea:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8000ed:	b9 56 00 00 00       	mov    $0x56,%ecx
  8000f2:	b0 00                	mov    $0x0,%al
  8000f4:	89 d7                	mov    %edx,%edi
  8000f6:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8000f8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8000ff:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800102:	83 ec 08             	sub    $0x8,%esp
  800105:	50                   	push   %eax
  800106:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80010c:	50                   	push   %eax
  80010d:	e8 c4 17 00 00       	call   8018d6 <sys_utilities>
  800112:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800115:	e8 0d 13 00 00       	call   801427 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80011a:	83 ec 0c             	sub    $0xc,%esp
  80011d:	68 2c 1c 80 00       	push   $0x801c2c
  800122:	e8 ac 03 00 00       	call   8004d3 <cprintf>
  800127:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80012a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012d:	85 c0                	test   %eax,%eax
  80012f:	74 18                	je     800149 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800131:	e8 be 17 00 00       	call   8018f4 <sys_get_optimal_num_faults>
  800136:	83 ec 08             	sub    $0x8,%esp
  800139:	50                   	push   %eax
  80013a:	68 54 1c 80 00       	push   $0x801c54
  80013f:	e8 8f 03 00 00       	call   8004d3 <cprintf>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	eb 59                	jmp    8001a2 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800149:	a1 20 30 80 00       	mov    0x803020,%eax
  80014e:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800154:	a1 20 30 80 00       	mov    0x803020,%eax
  800159:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80015f:	83 ec 04             	sub    $0x4,%esp
  800162:	52                   	push   %edx
  800163:	50                   	push   %eax
  800164:	68 78 1c 80 00       	push   $0x801c78
  800169:	e8 65 03 00 00       	call   8004d3 <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800171:	a1 20 30 80 00       	mov    0x803020,%eax
  800176:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80017c:	a1 20 30 80 00       	mov    0x803020,%eax
  800181:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800187:	a1 20 30 80 00       	mov    0x803020,%eax
  80018c:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800192:	51                   	push   %ecx
  800193:	52                   	push   %edx
  800194:	50                   	push   %eax
  800195:	68 a0 1c 80 00       	push   $0x801ca0
  80019a:	e8 34 03 00 00       	call   8004d3 <cprintf>
  80019f:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001a2:	a1 20 30 80 00       	mov    0x803020,%eax
  8001a7:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8001ad:	83 ec 08             	sub    $0x8,%esp
  8001b0:	50                   	push   %eax
  8001b1:	68 f8 1c 80 00       	push   $0x801cf8
  8001b6:	e8 18 03 00 00       	call   8004d3 <cprintf>
  8001bb:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001be:	83 ec 0c             	sub    $0xc,%esp
  8001c1:	68 2c 1c 80 00       	push   $0x801c2c
  8001c6:	e8 08 03 00 00       	call   8004d3 <cprintf>
  8001cb:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001ce:	e8 6e 12 00 00       	call   801441 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001d3:	e8 1f 00 00 00       	call   8001f7 <exit>
}
  8001d8:	90                   	nop
  8001d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001dc:	5b                   	pop    %ebx
  8001dd:	5e                   	pop    %esi
  8001de:	5f                   	pop    %edi
  8001df:	5d                   	pop    %ebp
  8001e0:	c3                   	ret    

008001e1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001e1:	55                   	push   %ebp
  8001e2:	89 e5                	mov    %esp,%ebp
  8001e4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	6a 00                	push   $0x0
  8001ec:	e8 7b 14 00 00       	call   80166c <sys_destroy_env>
  8001f1:	83 c4 10             	add    $0x10,%esp
}
  8001f4:	90                   	nop
  8001f5:	c9                   	leave  
  8001f6:	c3                   	ret    

008001f7 <exit>:

void
exit(void)
{
  8001f7:	55                   	push   %ebp
  8001f8:	89 e5                	mov    %esp,%ebp
  8001fa:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001fd:	e8 d0 14 00 00       	call   8016d2 <sys_exit_env>
}
  800202:	90                   	nop
  800203:	c9                   	leave  
  800204:	c3                   	ret    

00800205 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800205:	55                   	push   %ebp
  800206:	89 e5                	mov    %esp,%ebp
  800208:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80020b:	8d 45 10             	lea    0x10(%ebp),%eax
  80020e:	83 c0 04             	add    $0x4,%eax
  800211:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800214:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800219:	85 c0                	test   %eax,%eax
  80021b:	74 16                	je     800233 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80021d:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	50                   	push   %eax
  800226:	68 70 1d 80 00       	push   $0x801d70
  80022b:	e8 a3 02 00 00       	call   8004d3 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800233:	a1 04 30 80 00       	mov    0x803004,%eax
  800238:	83 ec 0c             	sub    $0xc,%esp
  80023b:	ff 75 0c             	pushl  0xc(%ebp)
  80023e:	ff 75 08             	pushl  0x8(%ebp)
  800241:	50                   	push   %eax
  800242:	68 78 1d 80 00       	push   $0x801d78
  800247:	6a 74                	push   $0x74
  800249:	e8 b2 02 00 00       	call   800500 <cprintf_colored>
  80024e:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800251:	8b 45 10             	mov    0x10(%ebp),%eax
  800254:	83 ec 08             	sub    $0x8,%esp
  800257:	ff 75 f4             	pushl  -0xc(%ebp)
  80025a:	50                   	push   %eax
  80025b:	e8 04 02 00 00       	call   800464 <vcprintf>
  800260:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800263:	83 ec 08             	sub    $0x8,%esp
  800266:	6a 00                	push   $0x0
  800268:	68 a0 1d 80 00       	push   $0x801da0
  80026d:	e8 f2 01 00 00       	call   800464 <vcprintf>
  800272:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800275:	e8 7d ff ff ff       	call   8001f7 <exit>

	// should not return here
	while (1) ;
  80027a:	eb fe                	jmp    80027a <_panic+0x75>

0080027c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80027c:	55                   	push   %ebp
  80027d:	89 e5                	mov    %esp,%ebp
  80027f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800282:	a1 20 30 80 00       	mov    0x803020,%eax
  800287:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80028d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800290:	39 c2                	cmp    %eax,%edx
  800292:	74 14                	je     8002a8 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800294:	83 ec 04             	sub    $0x4,%esp
  800297:	68 a4 1d 80 00       	push   $0x801da4
  80029c:	6a 26                	push   $0x26
  80029e:	68 f0 1d 80 00       	push   $0x801df0
  8002a3:	e8 5d ff ff ff       	call   800205 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002b6:	e9 c5 00 00 00       	jmp    800380 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8002bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c8:	01 d0                	add    %edx,%eax
  8002ca:	8b 00                	mov    (%eax),%eax
  8002cc:	85 c0                	test   %eax,%eax
  8002ce:	75 08                	jne    8002d8 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8002d0:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8002d3:	e9 a5 00 00 00       	jmp    80037d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8002d8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002df:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002e6:	eb 69                	jmp    800351 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8002e8:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ed:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8002f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002f6:	89 d0                	mov    %edx,%eax
  8002f8:	01 c0                	add    %eax,%eax
  8002fa:	01 d0                	add    %edx,%eax
  8002fc:	c1 e0 03             	shl    $0x3,%eax
  8002ff:	01 c8                	add    %ecx,%eax
  800301:	8a 40 04             	mov    0x4(%eax),%al
  800304:	84 c0                	test   %al,%al
  800306:	75 46                	jne    80034e <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800308:	a1 20 30 80 00       	mov    0x803020,%eax
  80030d:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800313:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800316:	89 d0                	mov    %edx,%eax
  800318:	01 c0                	add    %eax,%eax
  80031a:	01 d0                	add    %edx,%eax
  80031c:	c1 e0 03             	shl    $0x3,%eax
  80031f:	01 c8                	add    %ecx,%eax
  800321:	8b 00                	mov    (%eax),%eax
  800323:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800326:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800329:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80032e:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800333:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80033a:	8b 45 08             	mov    0x8(%ebp),%eax
  80033d:	01 c8                	add    %ecx,%eax
  80033f:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800341:	39 c2                	cmp    %eax,%edx
  800343:	75 09                	jne    80034e <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800345:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80034c:	eb 15                	jmp    800363 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80034e:	ff 45 e8             	incl   -0x18(%ebp)
  800351:	a1 20 30 80 00       	mov    0x803020,%eax
  800356:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80035c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80035f:	39 c2                	cmp    %eax,%edx
  800361:	77 85                	ja     8002e8 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800363:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800367:	75 14                	jne    80037d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800369:	83 ec 04             	sub    $0x4,%esp
  80036c:	68 fc 1d 80 00       	push   $0x801dfc
  800371:	6a 3a                	push   $0x3a
  800373:	68 f0 1d 80 00       	push   $0x801df0
  800378:	e8 88 fe ff ff       	call   800205 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80037d:	ff 45 f0             	incl   -0x10(%ebp)
  800380:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800383:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800386:	0f 8c 2f ff ff ff    	jl     8002bb <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80038c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800393:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80039a:	eb 26                	jmp    8003c2 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80039c:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a1:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003aa:	89 d0                	mov    %edx,%eax
  8003ac:	01 c0                	add    %eax,%eax
  8003ae:	01 d0                	add    %edx,%eax
  8003b0:	c1 e0 03             	shl    $0x3,%eax
  8003b3:	01 c8                	add    %ecx,%eax
  8003b5:	8a 40 04             	mov    0x4(%eax),%al
  8003b8:	3c 01                	cmp    $0x1,%al
  8003ba:	75 03                	jne    8003bf <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8003bc:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003bf:	ff 45 e0             	incl   -0x20(%ebp)
  8003c2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d0:	39 c2                	cmp    %eax,%edx
  8003d2:	77 c8                	ja     80039c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8003d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003d7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003da:	74 14                	je     8003f0 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8003dc:	83 ec 04             	sub    $0x4,%esp
  8003df:	68 50 1e 80 00       	push   $0x801e50
  8003e4:	6a 44                	push   $0x44
  8003e6:	68 f0 1d 80 00       	push   $0x801df0
  8003eb:	e8 15 fe ff ff       	call   800205 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8003f0:	90                   	nop
  8003f1:	c9                   	leave  
  8003f2:	c3                   	ret    

008003f3 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8003f3:	55                   	push   %ebp
  8003f4:	89 e5                	mov    %esp,%ebp
  8003f6:	53                   	push   %ebx
  8003f7:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8003fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	8d 48 01             	lea    0x1(%eax),%ecx
  800402:	8b 55 0c             	mov    0xc(%ebp),%edx
  800405:	89 0a                	mov    %ecx,(%edx)
  800407:	8b 55 08             	mov    0x8(%ebp),%edx
  80040a:	88 d1                	mov    %dl,%cl
  80040c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80040f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800413:	8b 45 0c             	mov    0xc(%ebp),%eax
  800416:	8b 00                	mov    (%eax),%eax
  800418:	3d ff 00 00 00       	cmp    $0xff,%eax
  80041d:	75 30                	jne    80044f <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80041f:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800425:	a0 44 30 80 00       	mov    0x803044,%al
  80042a:	0f b6 c0             	movzbl %al,%eax
  80042d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800430:	8b 09                	mov    (%ecx),%ecx
  800432:	89 cb                	mov    %ecx,%ebx
  800434:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800437:	83 c1 08             	add    $0x8,%ecx
  80043a:	52                   	push   %edx
  80043b:	50                   	push   %eax
  80043c:	53                   	push   %ebx
  80043d:	51                   	push   %ecx
  80043e:	e8 a0 0f 00 00       	call   8013e3 <sys_cputs>
  800443:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800446:	8b 45 0c             	mov    0xc(%ebp),%eax
  800449:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80044f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800452:	8b 40 04             	mov    0x4(%eax),%eax
  800455:	8d 50 01             	lea    0x1(%eax),%edx
  800458:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80045e:	90                   	nop
  80045f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800462:	c9                   	leave  
  800463:	c3                   	ret    

00800464 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800464:	55                   	push   %ebp
  800465:	89 e5                	mov    %esp,%ebp
  800467:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80046d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800474:	00 00 00 
	b.cnt = 0;
  800477:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80047e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800481:	ff 75 0c             	pushl  0xc(%ebp)
  800484:	ff 75 08             	pushl  0x8(%ebp)
  800487:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80048d:	50                   	push   %eax
  80048e:	68 f3 03 80 00       	push   $0x8003f3
  800493:	e8 5a 02 00 00       	call   8006f2 <vprintfmt>
  800498:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80049b:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004a1:	a0 44 30 80 00       	mov    0x803044,%al
  8004a6:	0f b6 c0             	movzbl %al,%eax
  8004a9:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8004af:	52                   	push   %edx
  8004b0:	50                   	push   %eax
  8004b1:	51                   	push   %ecx
  8004b2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004b8:	83 c0 08             	add    $0x8,%eax
  8004bb:	50                   	push   %eax
  8004bc:	e8 22 0f 00 00       	call   8013e3 <sys_cputs>
  8004c1:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004c4:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8004cb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8004d1:	c9                   	leave  
  8004d2:	c3                   	ret    

008004d3 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8004d3:	55                   	push   %ebp
  8004d4:	89 e5                	mov    %esp,%ebp
  8004d6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8004d9:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8004e0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e9:	83 ec 08             	sub    $0x8,%esp
  8004ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ef:	50                   	push   %eax
  8004f0:	e8 6f ff ff ff       	call   800464 <vcprintf>
  8004f5:	83 c4 10             	add    $0x10,%esp
  8004f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8004fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004fe:	c9                   	leave  
  8004ff:	c3                   	ret    

00800500 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800500:	55                   	push   %ebp
  800501:	89 e5                	mov    %esp,%ebp
  800503:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800506:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	c1 e0 08             	shl    $0x8,%eax
  800513:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800518:	8d 45 0c             	lea    0xc(%ebp),%eax
  80051b:	83 c0 04             	add    $0x4,%eax
  80051e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800521:	8b 45 0c             	mov    0xc(%ebp),%eax
  800524:	83 ec 08             	sub    $0x8,%esp
  800527:	ff 75 f4             	pushl  -0xc(%ebp)
  80052a:	50                   	push   %eax
  80052b:	e8 34 ff ff ff       	call   800464 <vcprintf>
  800530:	83 c4 10             	add    $0x10,%esp
  800533:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800536:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  80053d:	07 00 00 

	return cnt;
  800540:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800543:	c9                   	leave  
  800544:	c3                   	ret    

00800545 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800545:	55                   	push   %ebp
  800546:	89 e5                	mov    %esp,%ebp
  800548:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80054b:	e8 d7 0e 00 00       	call   801427 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800550:	8d 45 0c             	lea    0xc(%ebp),%eax
  800553:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800556:	8b 45 08             	mov    0x8(%ebp),%eax
  800559:	83 ec 08             	sub    $0x8,%esp
  80055c:	ff 75 f4             	pushl  -0xc(%ebp)
  80055f:	50                   	push   %eax
  800560:	e8 ff fe ff ff       	call   800464 <vcprintf>
  800565:	83 c4 10             	add    $0x10,%esp
  800568:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80056b:	e8 d1 0e 00 00       	call   801441 <sys_unlock_cons>
	return cnt;
  800570:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800573:	c9                   	leave  
  800574:	c3                   	ret    

00800575 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800575:	55                   	push   %ebp
  800576:	89 e5                	mov    %esp,%ebp
  800578:	53                   	push   %ebx
  800579:	83 ec 14             	sub    $0x14,%esp
  80057c:	8b 45 10             	mov    0x10(%ebp),%eax
  80057f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800582:	8b 45 14             	mov    0x14(%ebp),%eax
  800585:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800588:	8b 45 18             	mov    0x18(%ebp),%eax
  80058b:	ba 00 00 00 00       	mov    $0x0,%edx
  800590:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800593:	77 55                	ja     8005ea <printnum+0x75>
  800595:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800598:	72 05                	jb     80059f <printnum+0x2a>
  80059a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80059d:	77 4b                	ja     8005ea <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80059f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005a2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005a5:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ad:	52                   	push   %edx
  8005ae:	50                   	push   %eax
  8005af:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8005b5:	e8 aa 13 00 00       	call   801964 <__udivdi3>
  8005ba:	83 c4 10             	add    $0x10,%esp
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	ff 75 20             	pushl  0x20(%ebp)
  8005c3:	53                   	push   %ebx
  8005c4:	ff 75 18             	pushl  0x18(%ebp)
  8005c7:	52                   	push   %edx
  8005c8:	50                   	push   %eax
  8005c9:	ff 75 0c             	pushl  0xc(%ebp)
  8005cc:	ff 75 08             	pushl  0x8(%ebp)
  8005cf:	e8 a1 ff ff ff       	call   800575 <printnum>
  8005d4:	83 c4 20             	add    $0x20,%esp
  8005d7:	eb 1a                	jmp    8005f3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005d9:	83 ec 08             	sub    $0x8,%esp
  8005dc:	ff 75 0c             	pushl  0xc(%ebp)
  8005df:	ff 75 20             	pushl  0x20(%ebp)
  8005e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e5:	ff d0                	call   *%eax
  8005e7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005ea:	ff 4d 1c             	decl   0x1c(%ebp)
  8005ed:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005f1:	7f e6                	jg     8005d9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005f3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800601:	53                   	push   %ebx
  800602:	51                   	push   %ecx
  800603:	52                   	push   %edx
  800604:	50                   	push   %eax
  800605:	e8 6a 14 00 00       	call   801a74 <__umoddi3>
  80060a:	83 c4 10             	add    $0x10,%esp
  80060d:	05 b4 20 80 00       	add    $0x8020b4,%eax
  800612:	8a 00                	mov    (%eax),%al
  800614:	0f be c0             	movsbl %al,%eax
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	ff 75 0c             	pushl  0xc(%ebp)
  80061d:	50                   	push   %eax
  80061e:	8b 45 08             	mov    0x8(%ebp),%eax
  800621:	ff d0                	call   *%eax
  800623:	83 c4 10             	add    $0x10,%esp
}
  800626:	90                   	nop
  800627:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80062a:	c9                   	leave  
  80062b:	c3                   	ret    

0080062c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80062c:	55                   	push   %ebp
  80062d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80062f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800633:	7e 1c                	jle    800651 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800635:	8b 45 08             	mov    0x8(%ebp),%eax
  800638:	8b 00                	mov    (%eax),%eax
  80063a:	8d 50 08             	lea    0x8(%eax),%edx
  80063d:	8b 45 08             	mov    0x8(%ebp),%eax
  800640:	89 10                	mov    %edx,(%eax)
  800642:	8b 45 08             	mov    0x8(%ebp),%eax
  800645:	8b 00                	mov    (%eax),%eax
  800647:	83 e8 08             	sub    $0x8,%eax
  80064a:	8b 50 04             	mov    0x4(%eax),%edx
  80064d:	8b 00                	mov    (%eax),%eax
  80064f:	eb 40                	jmp    800691 <getuint+0x65>
	else if (lflag)
  800651:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800655:	74 1e                	je     800675 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	8d 50 04             	lea    0x4(%eax),%edx
  80065f:	8b 45 08             	mov    0x8(%ebp),%eax
  800662:	89 10                	mov    %edx,(%eax)
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	8b 00                	mov    (%eax),%eax
  800669:	83 e8 04             	sub    $0x4,%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	ba 00 00 00 00       	mov    $0x0,%edx
  800673:	eb 1c                	jmp    800691 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800675:	8b 45 08             	mov    0x8(%ebp),%eax
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	8d 50 04             	lea    0x4(%eax),%edx
  80067d:	8b 45 08             	mov    0x8(%ebp),%eax
  800680:	89 10                	mov    %edx,(%eax)
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	83 e8 04             	sub    $0x4,%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800691:	5d                   	pop    %ebp
  800692:	c3                   	ret    

00800693 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800693:	55                   	push   %ebp
  800694:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800696:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80069a:	7e 1c                	jle    8006b8 <getint+0x25>
		return va_arg(*ap, long long);
  80069c:	8b 45 08             	mov    0x8(%ebp),%eax
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	8d 50 08             	lea    0x8(%eax),%edx
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	89 10                	mov    %edx,(%eax)
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	83 e8 08             	sub    $0x8,%eax
  8006b1:	8b 50 04             	mov    0x4(%eax),%edx
  8006b4:	8b 00                	mov    (%eax),%eax
  8006b6:	eb 38                	jmp    8006f0 <getint+0x5d>
	else if (lflag)
  8006b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006bc:	74 1a                	je     8006d8 <getint+0x45>
		return va_arg(*ap, long);
  8006be:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	8d 50 04             	lea    0x4(%eax),%edx
  8006c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c9:	89 10                	mov    %edx,(%eax)
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	8b 00                	mov    (%eax),%eax
  8006d0:	83 e8 04             	sub    $0x4,%eax
  8006d3:	8b 00                	mov    (%eax),%eax
  8006d5:	99                   	cltd   
  8006d6:	eb 18                	jmp    8006f0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	8d 50 04             	lea    0x4(%eax),%edx
  8006e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e3:	89 10                	mov    %edx,(%eax)
  8006e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e8:	8b 00                	mov    (%eax),%eax
  8006ea:	83 e8 04             	sub    $0x4,%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	99                   	cltd   
}
  8006f0:	5d                   	pop    %ebp
  8006f1:	c3                   	ret    

008006f2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006f2:	55                   	push   %ebp
  8006f3:	89 e5                	mov    %esp,%ebp
  8006f5:	56                   	push   %esi
  8006f6:	53                   	push   %ebx
  8006f7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006fa:	eb 17                	jmp    800713 <vprintfmt+0x21>
			if (ch == '\0')
  8006fc:	85 db                	test   %ebx,%ebx
  8006fe:	0f 84 c1 03 00 00    	je     800ac5 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800704:	83 ec 08             	sub    $0x8,%esp
  800707:	ff 75 0c             	pushl  0xc(%ebp)
  80070a:	53                   	push   %ebx
  80070b:	8b 45 08             	mov    0x8(%ebp),%eax
  80070e:	ff d0                	call   *%eax
  800710:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800713:	8b 45 10             	mov    0x10(%ebp),%eax
  800716:	8d 50 01             	lea    0x1(%eax),%edx
  800719:	89 55 10             	mov    %edx,0x10(%ebp)
  80071c:	8a 00                	mov    (%eax),%al
  80071e:	0f b6 d8             	movzbl %al,%ebx
  800721:	83 fb 25             	cmp    $0x25,%ebx
  800724:	75 d6                	jne    8006fc <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800726:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80072a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800731:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800738:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80073f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800746:	8b 45 10             	mov    0x10(%ebp),%eax
  800749:	8d 50 01             	lea    0x1(%eax),%edx
  80074c:	89 55 10             	mov    %edx,0x10(%ebp)
  80074f:	8a 00                	mov    (%eax),%al
  800751:	0f b6 d8             	movzbl %al,%ebx
  800754:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800757:	83 f8 5b             	cmp    $0x5b,%eax
  80075a:	0f 87 3d 03 00 00    	ja     800a9d <vprintfmt+0x3ab>
  800760:	8b 04 85 d8 20 80 00 	mov    0x8020d8(,%eax,4),%eax
  800767:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800769:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80076d:	eb d7                	jmp    800746 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80076f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800773:	eb d1                	jmp    800746 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800775:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80077c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80077f:	89 d0                	mov    %edx,%eax
  800781:	c1 e0 02             	shl    $0x2,%eax
  800784:	01 d0                	add    %edx,%eax
  800786:	01 c0                	add    %eax,%eax
  800788:	01 d8                	add    %ebx,%eax
  80078a:	83 e8 30             	sub    $0x30,%eax
  80078d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800790:	8b 45 10             	mov    0x10(%ebp),%eax
  800793:	8a 00                	mov    (%eax),%al
  800795:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800798:	83 fb 2f             	cmp    $0x2f,%ebx
  80079b:	7e 3e                	jle    8007db <vprintfmt+0xe9>
  80079d:	83 fb 39             	cmp    $0x39,%ebx
  8007a0:	7f 39                	jg     8007db <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007a5:	eb d5                	jmp    80077c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	83 c0 04             	add    $0x4,%eax
  8007ad:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b3:	83 e8 04             	sub    $0x4,%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007bb:	eb 1f                	jmp    8007dc <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007c1:	79 83                	jns    800746 <vprintfmt+0x54>
				width = 0;
  8007c3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007ca:	e9 77 ff ff ff       	jmp    800746 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007cf:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007d6:	e9 6b ff ff ff       	jmp    800746 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007db:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e0:	0f 89 60 ff ff ff    	jns    800746 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007ec:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007f3:	e9 4e ff ff ff       	jmp    800746 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007f8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007fb:	e9 46 ff ff ff       	jmp    800746 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	83 c0 04             	add    $0x4,%eax
  800806:	89 45 14             	mov    %eax,0x14(%ebp)
  800809:	8b 45 14             	mov    0x14(%ebp),%eax
  80080c:	83 e8 04             	sub    $0x4,%eax
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	83 ec 08             	sub    $0x8,%esp
  800814:	ff 75 0c             	pushl  0xc(%ebp)
  800817:	50                   	push   %eax
  800818:	8b 45 08             	mov    0x8(%ebp),%eax
  80081b:	ff d0                	call   *%eax
  80081d:	83 c4 10             	add    $0x10,%esp
			break;
  800820:	e9 9b 02 00 00       	jmp    800ac0 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800825:	8b 45 14             	mov    0x14(%ebp),%eax
  800828:	83 c0 04             	add    $0x4,%eax
  80082b:	89 45 14             	mov    %eax,0x14(%ebp)
  80082e:	8b 45 14             	mov    0x14(%ebp),%eax
  800831:	83 e8 04             	sub    $0x4,%eax
  800834:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800836:	85 db                	test   %ebx,%ebx
  800838:	79 02                	jns    80083c <vprintfmt+0x14a>
				err = -err;
  80083a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80083c:	83 fb 64             	cmp    $0x64,%ebx
  80083f:	7f 0b                	jg     80084c <vprintfmt+0x15a>
  800841:	8b 34 9d 20 1f 80 00 	mov    0x801f20(,%ebx,4),%esi
  800848:	85 f6                	test   %esi,%esi
  80084a:	75 19                	jne    800865 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80084c:	53                   	push   %ebx
  80084d:	68 c5 20 80 00       	push   $0x8020c5
  800852:	ff 75 0c             	pushl  0xc(%ebp)
  800855:	ff 75 08             	pushl  0x8(%ebp)
  800858:	e8 70 02 00 00       	call   800acd <printfmt>
  80085d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800860:	e9 5b 02 00 00       	jmp    800ac0 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800865:	56                   	push   %esi
  800866:	68 ce 20 80 00       	push   $0x8020ce
  80086b:	ff 75 0c             	pushl  0xc(%ebp)
  80086e:	ff 75 08             	pushl  0x8(%ebp)
  800871:	e8 57 02 00 00       	call   800acd <printfmt>
  800876:	83 c4 10             	add    $0x10,%esp
			break;
  800879:	e9 42 02 00 00       	jmp    800ac0 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 c0 04             	add    $0x4,%eax
  800884:	89 45 14             	mov    %eax,0x14(%ebp)
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	83 e8 04             	sub    $0x4,%eax
  80088d:	8b 30                	mov    (%eax),%esi
  80088f:	85 f6                	test   %esi,%esi
  800891:	75 05                	jne    800898 <vprintfmt+0x1a6>
				p = "(null)";
  800893:	be d1 20 80 00       	mov    $0x8020d1,%esi
			if (width > 0 && padc != '-')
  800898:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80089c:	7e 6d                	jle    80090b <vprintfmt+0x219>
  80089e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008a2:	74 67                	je     80090b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008a7:	83 ec 08             	sub    $0x8,%esp
  8008aa:	50                   	push   %eax
  8008ab:	56                   	push   %esi
  8008ac:	e8 1e 03 00 00       	call   800bcf <strnlen>
  8008b1:	83 c4 10             	add    $0x10,%esp
  8008b4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008b7:	eb 16                	jmp    8008cf <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008b9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008bd:	83 ec 08             	sub    $0x8,%esp
  8008c0:	ff 75 0c             	pushl  0xc(%ebp)
  8008c3:	50                   	push   %eax
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	ff d0                	call   *%eax
  8008c9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008cc:	ff 4d e4             	decl   -0x1c(%ebp)
  8008cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008d3:	7f e4                	jg     8008b9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008d5:	eb 34                	jmp    80090b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008d7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008db:	74 1c                	je     8008f9 <vprintfmt+0x207>
  8008dd:	83 fb 1f             	cmp    $0x1f,%ebx
  8008e0:	7e 05                	jle    8008e7 <vprintfmt+0x1f5>
  8008e2:	83 fb 7e             	cmp    $0x7e,%ebx
  8008e5:	7e 12                	jle    8008f9 <vprintfmt+0x207>
					putch('?', putdat);
  8008e7:	83 ec 08             	sub    $0x8,%esp
  8008ea:	ff 75 0c             	pushl  0xc(%ebp)
  8008ed:	6a 3f                	push   $0x3f
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	ff d0                	call   *%eax
  8008f4:	83 c4 10             	add    $0x10,%esp
  8008f7:	eb 0f                	jmp    800908 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008f9:	83 ec 08             	sub    $0x8,%esp
  8008fc:	ff 75 0c             	pushl  0xc(%ebp)
  8008ff:	53                   	push   %ebx
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	ff d0                	call   *%eax
  800905:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800908:	ff 4d e4             	decl   -0x1c(%ebp)
  80090b:	89 f0                	mov    %esi,%eax
  80090d:	8d 70 01             	lea    0x1(%eax),%esi
  800910:	8a 00                	mov    (%eax),%al
  800912:	0f be d8             	movsbl %al,%ebx
  800915:	85 db                	test   %ebx,%ebx
  800917:	74 24                	je     80093d <vprintfmt+0x24b>
  800919:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80091d:	78 b8                	js     8008d7 <vprintfmt+0x1e5>
  80091f:	ff 4d e0             	decl   -0x20(%ebp)
  800922:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800926:	79 af                	jns    8008d7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800928:	eb 13                	jmp    80093d <vprintfmt+0x24b>
				putch(' ', putdat);
  80092a:	83 ec 08             	sub    $0x8,%esp
  80092d:	ff 75 0c             	pushl  0xc(%ebp)
  800930:	6a 20                	push   $0x20
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	ff d0                	call   *%eax
  800937:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80093a:	ff 4d e4             	decl   -0x1c(%ebp)
  80093d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800941:	7f e7                	jg     80092a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800943:	e9 78 01 00 00       	jmp    800ac0 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800948:	83 ec 08             	sub    $0x8,%esp
  80094b:	ff 75 e8             	pushl  -0x18(%ebp)
  80094e:	8d 45 14             	lea    0x14(%ebp),%eax
  800951:	50                   	push   %eax
  800952:	e8 3c fd ff ff       	call   800693 <getint>
  800957:	83 c4 10             	add    $0x10,%esp
  80095a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80095d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800960:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800963:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800966:	85 d2                	test   %edx,%edx
  800968:	79 23                	jns    80098d <vprintfmt+0x29b>
				putch('-', putdat);
  80096a:	83 ec 08             	sub    $0x8,%esp
  80096d:	ff 75 0c             	pushl  0xc(%ebp)
  800970:	6a 2d                	push   $0x2d
  800972:	8b 45 08             	mov    0x8(%ebp),%eax
  800975:	ff d0                	call   *%eax
  800977:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80097a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80097d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800980:	f7 d8                	neg    %eax
  800982:	83 d2 00             	adc    $0x0,%edx
  800985:	f7 da                	neg    %edx
  800987:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80098a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80098d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800994:	e9 bc 00 00 00       	jmp    800a55 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800999:	83 ec 08             	sub    $0x8,%esp
  80099c:	ff 75 e8             	pushl  -0x18(%ebp)
  80099f:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a2:	50                   	push   %eax
  8009a3:	e8 84 fc ff ff       	call   80062c <getuint>
  8009a8:	83 c4 10             	add    $0x10,%esp
  8009ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009b1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009b8:	e9 98 00 00 00       	jmp    800a55 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009bd:	83 ec 08             	sub    $0x8,%esp
  8009c0:	ff 75 0c             	pushl  0xc(%ebp)
  8009c3:	6a 58                	push   $0x58
  8009c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c8:	ff d0                	call   *%eax
  8009ca:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	ff 75 0c             	pushl  0xc(%ebp)
  8009d3:	6a 58                	push   $0x58
  8009d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d8:	ff d0                	call   *%eax
  8009da:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009dd:	83 ec 08             	sub    $0x8,%esp
  8009e0:	ff 75 0c             	pushl  0xc(%ebp)
  8009e3:	6a 58                	push   $0x58
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	ff d0                	call   *%eax
  8009ea:	83 c4 10             	add    $0x10,%esp
			break;
  8009ed:	e9 ce 00 00 00       	jmp    800ac0 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8009f2:	83 ec 08             	sub    $0x8,%esp
  8009f5:	ff 75 0c             	pushl  0xc(%ebp)
  8009f8:	6a 30                	push   $0x30
  8009fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fd:	ff d0                	call   *%eax
  8009ff:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a02:	83 ec 08             	sub    $0x8,%esp
  800a05:	ff 75 0c             	pushl  0xc(%ebp)
  800a08:	6a 78                	push   $0x78
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	ff d0                	call   *%eax
  800a0f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a12:	8b 45 14             	mov    0x14(%ebp),%eax
  800a15:	83 c0 04             	add    $0x4,%eax
  800a18:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1e:	83 e8 04             	sub    $0x4,%eax
  800a21:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a2d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a34:	eb 1f                	jmp    800a55 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a36:	83 ec 08             	sub    $0x8,%esp
  800a39:	ff 75 e8             	pushl  -0x18(%ebp)
  800a3c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a3f:	50                   	push   %eax
  800a40:	e8 e7 fb ff ff       	call   80062c <getuint>
  800a45:	83 c4 10             	add    $0x10,%esp
  800a48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a4e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a55:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a5c:	83 ec 04             	sub    $0x4,%esp
  800a5f:	52                   	push   %edx
  800a60:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a63:	50                   	push   %eax
  800a64:	ff 75 f4             	pushl  -0xc(%ebp)
  800a67:	ff 75 f0             	pushl  -0x10(%ebp)
  800a6a:	ff 75 0c             	pushl  0xc(%ebp)
  800a6d:	ff 75 08             	pushl  0x8(%ebp)
  800a70:	e8 00 fb ff ff       	call   800575 <printnum>
  800a75:	83 c4 20             	add    $0x20,%esp
			break;
  800a78:	eb 46                	jmp    800ac0 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a7a:	83 ec 08             	sub    $0x8,%esp
  800a7d:	ff 75 0c             	pushl  0xc(%ebp)
  800a80:	53                   	push   %ebx
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	ff d0                	call   *%eax
  800a86:	83 c4 10             	add    $0x10,%esp
			break;
  800a89:	eb 35                	jmp    800ac0 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800a8b:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800a92:	eb 2c                	jmp    800ac0 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800a94:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800a9b:	eb 23                	jmp    800ac0 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a9d:	83 ec 08             	sub    $0x8,%esp
  800aa0:	ff 75 0c             	pushl  0xc(%ebp)
  800aa3:	6a 25                	push   $0x25
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	ff d0                	call   *%eax
  800aaa:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aad:	ff 4d 10             	decl   0x10(%ebp)
  800ab0:	eb 03                	jmp    800ab5 <vprintfmt+0x3c3>
  800ab2:	ff 4d 10             	decl   0x10(%ebp)
  800ab5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab8:	48                   	dec    %eax
  800ab9:	8a 00                	mov    (%eax),%al
  800abb:	3c 25                	cmp    $0x25,%al
  800abd:	75 f3                	jne    800ab2 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800abf:	90                   	nop
		}
	}
  800ac0:	e9 35 fc ff ff       	jmp    8006fa <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ac5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ac6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ac9:	5b                   	pop    %ebx
  800aca:	5e                   	pop    %esi
  800acb:	5d                   	pop    %ebp
  800acc:	c3                   	ret    

00800acd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800acd:	55                   	push   %ebp
  800ace:	89 e5                	mov    %esp,%ebp
  800ad0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ad3:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad6:	83 c0 04             	add    $0x4,%eax
  800ad9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800adc:	8b 45 10             	mov    0x10(%ebp),%eax
  800adf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae2:	50                   	push   %eax
  800ae3:	ff 75 0c             	pushl  0xc(%ebp)
  800ae6:	ff 75 08             	pushl  0x8(%ebp)
  800ae9:	e8 04 fc ff ff       	call   8006f2 <vprintfmt>
  800aee:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800af1:	90                   	nop
  800af2:	c9                   	leave  
  800af3:	c3                   	ret    

00800af4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800af7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afa:	8b 40 08             	mov    0x8(%eax),%eax
  800afd:	8d 50 01             	lea    0x1(%eax),%edx
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b09:	8b 10                	mov    (%eax),%edx
  800b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0e:	8b 40 04             	mov    0x4(%eax),%eax
  800b11:	39 c2                	cmp    %eax,%edx
  800b13:	73 12                	jae    800b27 <sprintputch+0x33>
		*b->buf++ = ch;
  800b15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b18:	8b 00                	mov    (%eax),%eax
  800b1a:	8d 48 01             	lea    0x1(%eax),%ecx
  800b1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b20:	89 0a                	mov    %ecx,(%edx)
  800b22:	8b 55 08             	mov    0x8(%ebp),%edx
  800b25:	88 10                	mov    %dl,(%eax)
}
  800b27:	90                   	nop
  800b28:	5d                   	pop    %ebp
  800b29:	c3                   	ret    

00800b2a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b39:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	01 d0                	add    %edx,%eax
  800b41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b4b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b4f:	74 06                	je     800b57 <vsnprintf+0x2d>
  800b51:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b55:	7f 07                	jg     800b5e <vsnprintf+0x34>
		return -E_INVAL;
  800b57:	b8 03 00 00 00       	mov    $0x3,%eax
  800b5c:	eb 20                	jmp    800b7e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b5e:	ff 75 14             	pushl  0x14(%ebp)
  800b61:	ff 75 10             	pushl  0x10(%ebp)
  800b64:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b67:	50                   	push   %eax
  800b68:	68 f4 0a 80 00       	push   $0x800af4
  800b6d:	e8 80 fb ff ff       	call   8006f2 <vprintfmt>
  800b72:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b78:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b7e:	c9                   	leave  
  800b7f:	c3                   	ret    

00800b80 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b86:	8d 45 10             	lea    0x10(%ebp),%eax
  800b89:	83 c0 04             	add    $0x4,%eax
  800b8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b92:	ff 75 f4             	pushl  -0xc(%ebp)
  800b95:	50                   	push   %eax
  800b96:	ff 75 0c             	pushl  0xc(%ebp)
  800b99:	ff 75 08             	pushl  0x8(%ebp)
  800b9c:	e8 89 ff ff ff       	call   800b2a <vsnprintf>
  800ba1:	83 c4 10             	add    $0x10,%esp
  800ba4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800baa:	c9                   	leave  
  800bab:	c3                   	ret    

00800bac <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb9:	eb 06                	jmp    800bc1 <strlen+0x15>
		n++;
  800bbb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbe:	ff 45 08             	incl   0x8(%ebp)
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	8a 00                	mov    (%eax),%al
  800bc6:	84 c0                	test   %al,%al
  800bc8:	75 f1                	jne    800bbb <strlen+0xf>
		n++;
	return n;
  800bca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bcd:	c9                   	leave  
  800bce:	c3                   	ret    

00800bcf <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bcf:	55                   	push   %ebp
  800bd0:	89 e5                	mov    %esp,%ebp
  800bd2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bdc:	eb 09                	jmp    800be7 <strnlen+0x18>
		n++;
  800bde:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be1:	ff 45 08             	incl   0x8(%ebp)
  800be4:	ff 4d 0c             	decl   0xc(%ebp)
  800be7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800beb:	74 09                	je     800bf6 <strnlen+0x27>
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	8a 00                	mov    (%eax),%al
  800bf2:	84 c0                	test   %al,%al
  800bf4:	75 e8                	jne    800bde <strnlen+0xf>
		n++;
	return n;
  800bf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf9:	c9                   	leave  
  800bfa:	c3                   	ret    

00800bfb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
  800bfe:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c07:	90                   	nop
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	8d 50 01             	lea    0x1(%eax),%edx
  800c0e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c11:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c14:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c17:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c1a:	8a 12                	mov    (%edx),%dl
  800c1c:	88 10                	mov    %dl,(%eax)
  800c1e:	8a 00                	mov    (%eax),%al
  800c20:	84 c0                	test   %al,%al
  800c22:	75 e4                	jne    800c08 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c24:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c27:	c9                   	leave  
  800c28:	c3                   	ret    

00800c29 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c3c:	eb 1f                	jmp    800c5d <strncpy+0x34>
		*dst++ = *src;
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	8d 50 01             	lea    0x1(%eax),%edx
  800c44:	89 55 08             	mov    %edx,0x8(%ebp)
  800c47:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4a:	8a 12                	mov    (%edx),%dl
  800c4c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c51:	8a 00                	mov    (%eax),%al
  800c53:	84 c0                	test   %al,%al
  800c55:	74 03                	je     800c5a <strncpy+0x31>
			src++;
  800c57:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c5a:	ff 45 fc             	incl   -0x4(%ebp)
  800c5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c60:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c63:	72 d9                	jb     800c3e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c65:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c68:	c9                   	leave  
  800c69:	c3                   	ret    

00800c6a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c70:	8b 45 08             	mov    0x8(%ebp),%eax
  800c73:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c7a:	74 30                	je     800cac <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c7c:	eb 16                	jmp    800c94 <strlcpy+0x2a>
			*dst++ = *src++;
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8d 50 01             	lea    0x1(%eax),%edx
  800c84:	89 55 08             	mov    %edx,0x8(%ebp)
  800c87:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c8d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c90:	8a 12                	mov    (%edx),%dl
  800c92:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c94:	ff 4d 10             	decl   0x10(%ebp)
  800c97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c9b:	74 09                	je     800ca6 <strlcpy+0x3c>
  800c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca0:	8a 00                	mov    (%eax),%al
  800ca2:	84 c0                	test   %al,%al
  800ca4:	75 d8                	jne    800c7e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cac:	8b 55 08             	mov    0x8(%ebp),%edx
  800caf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb2:	29 c2                	sub    %eax,%edx
  800cb4:	89 d0                	mov    %edx,%eax
}
  800cb6:	c9                   	leave  
  800cb7:	c3                   	ret    

00800cb8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cbb:	eb 06                	jmp    800cc3 <strcmp+0xb>
		p++, q++;
  800cbd:	ff 45 08             	incl   0x8(%ebp)
  800cc0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	8a 00                	mov    (%eax),%al
  800cc8:	84 c0                	test   %al,%al
  800cca:	74 0e                	je     800cda <strcmp+0x22>
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	8a 10                	mov    (%eax),%dl
  800cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd4:	8a 00                	mov    (%eax),%al
  800cd6:	38 c2                	cmp    %al,%dl
  800cd8:	74 e3                	je     800cbd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	0f b6 d0             	movzbl %al,%edx
  800ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce5:	8a 00                	mov    (%eax),%al
  800ce7:	0f b6 c0             	movzbl %al,%eax
  800cea:	29 c2                	sub    %eax,%edx
  800cec:	89 d0                	mov    %edx,%eax
}
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cf3:	eb 09                	jmp    800cfe <strncmp+0xe>
		n--, p++, q++;
  800cf5:	ff 4d 10             	decl   0x10(%ebp)
  800cf8:	ff 45 08             	incl   0x8(%ebp)
  800cfb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cfe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d02:	74 17                	je     800d1b <strncmp+0x2b>
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	8a 00                	mov    (%eax),%al
  800d09:	84 c0                	test   %al,%al
  800d0b:	74 0e                	je     800d1b <strncmp+0x2b>
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8a 10                	mov    (%eax),%dl
  800d12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d15:	8a 00                	mov    (%eax),%al
  800d17:	38 c2                	cmp    %al,%dl
  800d19:	74 da                	je     800cf5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1f:	75 07                	jne    800d28 <strncmp+0x38>
		return 0;
  800d21:	b8 00 00 00 00       	mov    $0x0,%eax
  800d26:	eb 14                	jmp    800d3c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	8a 00                	mov    (%eax),%al
  800d2d:	0f b6 d0             	movzbl %al,%edx
  800d30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d33:	8a 00                	mov    (%eax),%al
  800d35:	0f b6 c0             	movzbl %al,%eax
  800d38:	29 c2                	sub    %eax,%edx
  800d3a:	89 d0                	mov    %edx,%eax
}
  800d3c:	5d                   	pop    %ebp
  800d3d:	c3                   	ret    

00800d3e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d3e:	55                   	push   %ebp
  800d3f:	89 e5                	mov    %esp,%ebp
  800d41:	83 ec 04             	sub    $0x4,%esp
  800d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d47:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d4a:	eb 12                	jmp    800d5e <strchr+0x20>
		if (*s == c)
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8a 00                	mov    (%eax),%al
  800d51:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d54:	75 05                	jne    800d5b <strchr+0x1d>
			return (char *) s;
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	eb 11                	jmp    800d6c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d5b:	ff 45 08             	incl   0x8(%ebp)
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	8a 00                	mov    (%eax),%al
  800d63:	84 c0                	test   %al,%al
  800d65:	75 e5                	jne    800d4c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d6c:	c9                   	leave  
  800d6d:	c3                   	ret    

00800d6e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	83 ec 04             	sub    $0x4,%esp
  800d74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d77:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d7a:	eb 0d                	jmp    800d89 <strfind+0x1b>
		if (*s == c)
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	8a 00                	mov    (%eax),%al
  800d81:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d84:	74 0e                	je     800d94 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d86:	ff 45 08             	incl   0x8(%ebp)
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	84 c0                	test   %al,%al
  800d90:	75 ea                	jne    800d7c <strfind+0xe>
  800d92:	eb 01                	jmp    800d95 <strfind+0x27>
		if (*s == c)
			break;
  800d94:	90                   	nop
	return (char *) s;
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d98:	c9                   	leave  
  800d99:	c3                   	ret    

00800d9a <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800da6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800daa:	76 63                	jbe    800e0f <memset+0x75>
		uint64 data_block = c;
  800dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800daf:	99                   	cltd   
  800db0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800db3:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dbc:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800dc0:	c1 e0 08             	shl    $0x8,%eax
  800dc3:	09 45 f0             	or     %eax,-0x10(%ebp)
  800dc6:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dcf:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800dd3:	c1 e0 10             	shl    $0x10,%eax
  800dd6:	09 45 f0             	or     %eax,-0x10(%ebp)
  800dd9:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ddf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800de2:	89 c2                	mov    %eax,%edx
  800de4:	b8 00 00 00 00       	mov    $0x0,%eax
  800de9:	09 45 f0             	or     %eax,-0x10(%ebp)
  800dec:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800def:	eb 18                	jmp    800e09 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800df1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800df4:	8d 41 08             	lea    0x8(%ecx),%eax
  800df7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800dfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e00:	89 01                	mov    %eax,(%ecx)
  800e02:	89 51 04             	mov    %edx,0x4(%ecx)
  800e05:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e09:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e0d:	77 e2                	ja     800df1 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e0f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e13:	74 23                	je     800e38 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e15:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e18:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e1b:	eb 0e                	jmp    800e2b <memset+0x91>
			*p8++ = (uint8)c;
  800e1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e20:	8d 50 01             	lea    0x1(%eax),%edx
  800e23:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e29:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e31:	89 55 10             	mov    %edx,0x10(%ebp)
  800e34:	85 c0                	test   %eax,%eax
  800e36:	75 e5                	jne    800e1d <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3b:	c9                   	leave  
  800e3c:	c3                   	ret    

00800e3d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800e4f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e53:	76 24                	jbe    800e79 <memcpy+0x3c>
		while(n >= 8){
  800e55:	eb 1c                	jmp    800e73 <memcpy+0x36>
			*d64 = *s64;
  800e57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5a:	8b 50 04             	mov    0x4(%eax),%edx
  800e5d:	8b 00                	mov    (%eax),%eax
  800e5f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800e62:	89 01                	mov    %eax,(%ecx)
  800e64:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800e67:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800e6b:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800e6f:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800e73:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e77:	77 de                	ja     800e57 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800e79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e7d:	74 31                	je     800eb0 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800e7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e82:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800e85:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e88:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800e8b:	eb 16                	jmp    800ea3 <memcpy+0x66>
			*d8++ = *s8++;
  800e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e90:	8d 50 01             	lea    0x1(%eax),%edx
  800e93:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800e96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e99:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e9c:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800e9f:	8a 12                	mov    (%edx),%dl
  800ea1:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800ea3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea9:	89 55 10             	mov    %edx,0x10(%ebp)
  800eac:	85 c0                	test   %eax,%eax
  800eae:	75 dd                	jne    800e8d <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb3:	c9                   	leave  
  800eb4:	c3                   	ret    

00800eb5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ec7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ecd:	73 50                	jae    800f1f <memmove+0x6a>
  800ecf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed5:	01 d0                	add    %edx,%eax
  800ed7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eda:	76 43                	jbe    800f1f <memmove+0x6a>
		s += n;
  800edc:	8b 45 10             	mov    0x10(%ebp),%eax
  800edf:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ee2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ee8:	eb 10                	jmp    800efa <memmove+0x45>
			*--d = *--s;
  800eea:	ff 4d f8             	decl   -0x8(%ebp)
  800eed:	ff 4d fc             	decl   -0x4(%ebp)
  800ef0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef3:	8a 10                	mov    (%eax),%dl
  800ef5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef8:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800efa:	8b 45 10             	mov    0x10(%ebp),%eax
  800efd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f00:	89 55 10             	mov    %edx,0x10(%ebp)
  800f03:	85 c0                	test   %eax,%eax
  800f05:	75 e3                	jne    800eea <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f07:	eb 23                	jmp    800f2c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0c:	8d 50 01             	lea    0x1(%eax),%edx
  800f0f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f12:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f15:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f18:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f1b:	8a 12                	mov    (%edx),%dl
  800f1d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f22:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f25:	89 55 10             	mov    %edx,0x10(%ebp)
  800f28:	85 c0                	test   %eax,%eax
  800f2a:	75 dd                	jne    800f09 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f2f:	c9                   	leave  
  800f30:	c3                   	ret    

00800f31 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f31:	55                   	push   %ebp
  800f32:	89 e5                	mov    %esp,%ebp
  800f34:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f40:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f43:	eb 2a                	jmp    800f6f <memcmp+0x3e>
		if (*s1 != *s2)
  800f45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f48:	8a 10                	mov    (%eax),%dl
  800f4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4d:	8a 00                	mov    (%eax),%al
  800f4f:	38 c2                	cmp    %al,%dl
  800f51:	74 16                	je     800f69 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f53:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	0f b6 d0             	movzbl %al,%edx
  800f5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5e:	8a 00                	mov    (%eax),%al
  800f60:	0f b6 c0             	movzbl %al,%eax
  800f63:	29 c2                	sub    %eax,%edx
  800f65:	89 d0                	mov    %edx,%eax
  800f67:	eb 18                	jmp    800f81 <memcmp+0x50>
		s1++, s2++;
  800f69:	ff 45 fc             	incl   -0x4(%ebp)
  800f6c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f72:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f75:	89 55 10             	mov    %edx,0x10(%ebp)
  800f78:	85 c0                	test   %eax,%eax
  800f7a:	75 c9                	jne    800f45 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f81:	c9                   	leave  
  800f82:	c3                   	ret    

00800f83 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f89:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8f:	01 d0                	add    %edx,%eax
  800f91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f94:	eb 15                	jmp    800fab <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f96:	8b 45 08             	mov    0x8(%ebp),%eax
  800f99:	8a 00                	mov    (%eax),%al
  800f9b:	0f b6 d0             	movzbl %al,%edx
  800f9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa1:	0f b6 c0             	movzbl %al,%eax
  800fa4:	39 c2                	cmp    %eax,%edx
  800fa6:	74 0d                	je     800fb5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fa8:	ff 45 08             	incl   0x8(%ebp)
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fb1:	72 e3                	jb     800f96 <memfind+0x13>
  800fb3:	eb 01                	jmp    800fb6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fb5:	90                   	nop
	return (void *) s;
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb9:	c9                   	leave  
  800fba:	c3                   	ret    

00800fbb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
  800fbe:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fc1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fc8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fcf:	eb 03                	jmp    800fd4 <strtol+0x19>
		s++;
  800fd1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd7:	8a 00                	mov    (%eax),%al
  800fd9:	3c 20                	cmp    $0x20,%al
  800fdb:	74 f4                	je     800fd1 <strtol+0x16>
  800fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe0:	8a 00                	mov    (%eax),%al
  800fe2:	3c 09                	cmp    $0x9,%al
  800fe4:	74 eb                	je     800fd1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	3c 2b                	cmp    $0x2b,%al
  800fed:	75 05                	jne    800ff4 <strtol+0x39>
		s++;
  800fef:	ff 45 08             	incl   0x8(%ebp)
  800ff2:	eb 13                	jmp    801007 <strtol+0x4c>
	else if (*s == '-')
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	3c 2d                	cmp    $0x2d,%al
  800ffb:	75 0a                	jne    801007 <strtol+0x4c>
		s++, neg = 1;
  800ffd:	ff 45 08             	incl   0x8(%ebp)
  801000:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801007:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100b:	74 06                	je     801013 <strtol+0x58>
  80100d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801011:	75 20                	jne    801033 <strtol+0x78>
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	3c 30                	cmp    $0x30,%al
  80101a:	75 17                	jne    801033 <strtol+0x78>
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	40                   	inc    %eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	3c 78                	cmp    $0x78,%al
  801024:	75 0d                	jne    801033 <strtol+0x78>
		s += 2, base = 16;
  801026:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80102a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801031:	eb 28                	jmp    80105b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801033:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801037:	75 15                	jne    80104e <strtol+0x93>
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	3c 30                	cmp    $0x30,%al
  801040:	75 0c                	jne    80104e <strtol+0x93>
		s++, base = 8;
  801042:	ff 45 08             	incl   0x8(%ebp)
  801045:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80104c:	eb 0d                	jmp    80105b <strtol+0xa0>
	else if (base == 0)
  80104e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801052:	75 07                	jne    80105b <strtol+0xa0>
		base = 10;
  801054:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
  80105e:	8a 00                	mov    (%eax),%al
  801060:	3c 2f                	cmp    $0x2f,%al
  801062:	7e 19                	jle    80107d <strtol+0xc2>
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	8a 00                	mov    (%eax),%al
  801069:	3c 39                	cmp    $0x39,%al
  80106b:	7f 10                	jg     80107d <strtol+0xc2>
			dig = *s - '0';
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	0f be c0             	movsbl %al,%eax
  801075:	83 e8 30             	sub    $0x30,%eax
  801078:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80107b:	eb 42                	jmp    8010bf <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	8a 00                	mov    (%eax),%al
  801082:	3c 60                	cmp    $0x60,%al
  801084:	7e 19                	jle    80109f <strtol+0xe4>
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
  801089:	8a 00                	mov    (%eax),%al
  80108b:	3c 7a                	cmp    $0x7a,%al
  80108d:	7f 10                	jg     80109f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	8a 00                	mov    (%eax),%al
  801094:	0f be c0             	movsbl %al,%eax
  801097:	83 e8 57             	sub    $0x57,%eax
  80109a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80109d:	eb 20                	jmp    8010bf <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	8a 00                	mov    (%eax),%al
  8010a4:	3c 40                	cmp    $0x40,%al
  8010a6:	7e 39                	jle    8010e1 <strtol+0x126>
  8010a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ab:	8a 00                	mov    (%eax),%al
  8010ad:	3c 5a                	cmp    $0x5a,%al
  8010af:	7f 30                	jg     8010e1 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	8a 00                	mov    (%eax),%al
  8010b6:	0f be c0             	movsbl %al,%eax
  8010b9:	83 e8 37             	sub    $0x37,%eax
  8010bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010c5:	7d 19                	jge    8010e0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010c7:	ff 45 08             	incl   0x8(%ebp)
  8010ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cd:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010d1:	89 c2                	mov    %eax,%edx
  8010d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d6:	01 d0                	add    %edx,%eax
  8010d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010db:	e9 7b ff ff ff       	jmp    80105b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010e0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010e5:	74 08                	je     8010ef <strtol+0x134>
		*endptr = (char *) s;
  8010e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ed:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f3:	74 07                	je     8010fc <strtol+0x141>
  8010f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f8:	f7 d8                	neg    %eax
  8010fa:	eb 03                	jmp    8010ff <strtol+0x144>
  8010fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010ff:	c9                   	leave  
  801100:	c3                   	ret    

00801101 <ltostr>:

void
ltostr(long value, char *str)
{
  801101:	55                   	push   %ebp
  801102:	89 e5                	mov    %esp,%ebp
  801104:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801107:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80110e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801115:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801119:	79 13                	jns    80112e <ltostr+0x2d>
	{
		neg = 1;
  80111b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801122:	8b 45 0c             	mov    0xc(%ebp),%eax
  801125:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801128:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80112b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801136:	99                   	cltd   
  801137:	f7 f9                	idiv   %ecx
  801139:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80113c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113f:	8d 50 01             	lea    0x1(%eax),%edx
  801142:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801145:	89 c2                	mov    %eax,%edx
  801147:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114a:	01 d0                	add    %edx,%eax
  80114c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80114f:	83 c2 30             	add    $0x30,%edx
  801152:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801154:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801157:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80115c:	f7 e9                	imul   %ecx
  80115e:	c1 fa 02             	sar    $0x2,%edx
  801161:	89 c8                	mov    %ecx,%eax
  801163:	c1 f8 1f             	sar    $0x1f,%eax
  801166:	29 c2                	sub    %eax,%edx
  801168:	89 d0                	mov    %edx,%eax
  80116a:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80116d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801171:	75 bb                	jne    80112e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801173:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80117a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117d:	48                   	dec    %eax
  80117e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801181:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801185:	74 3d                	je     8011c4 <ltostr+0xc3>
		start = 1 ;
  801187:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80118e:	eb 34                	jmp    8011c4 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801190:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801193:	8b 45 0c             	mov    0xc(%ebp),%eax
  801196:	01 d0                	add    %edx,%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80119d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a3:	01 c2                	add    %eax,%edx
  8011a5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ab:	01 c8                	add    %ecx,%eax
  8011ad:	8a 00                	mov    (%eax),%al
  8011af:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b7:	01 c2                	add    %eax,%edx
  8011b9:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011bc:	88 02                	mov    %al,(%edx)
		start++ ;
  8011be:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011c1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ca:	7c c4                	jl     801190 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011cc:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d2:	01 d0                	add    %edx,%eax
  8011d4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011d7:	90                   	nop
  8011d8:	c9                   	leave  
  8011d9:	c3                   	ret    

008011da <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
  8011dd:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011e0:	ff 75 08             	pushl  0x8(%ebp)
  8011e3:	e8 c4 f9 ff ff       	call   800bac <strlen>
  8011e8:	83 c4 04             	add    $0x4,%esp
  8011eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011ee:	ff 75 0c             	pushl  0xc(%ebp)
  8011f1:	e8 b6 f9 ff ff       	call   800bac <strlen>
  8011f6:	83 c4 04             	add    $0x4,%esp
  8011f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801203:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80120a:	eb 17                	jmp    801223 <strcconcat+0x49>
		final[s] = str1[s] ;
  80120c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80120f:	8b 45 10             	mov    0x10(%ebp),%eax
  801212:	01 c2                	add    %eax,%edx
  801214:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	01 c8                	add    %ecx,%eax
  80121c:	8a 00                	mov    (%eax),%al
  80121e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801220:	ff 45 fc             	incl   -0x4(%ebp)
  801223:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801226:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801229:	7c e1                	jl     80120c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80122b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801232:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801239:	eb 1f                	jmp    80125a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80123b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80123e:	8d 50 01             	lea    0x1(%eax),%edx
  801241:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801244:	89 c2                	mov    %eax,%edx
  801246:	8b 45 10             	mov    0x10(%ebp),%eax
  801249:	01 c2                	add    %eax,%edx
  80124b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80124e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801251:	01 c8                	add    %ecx,%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801257:	ff 45 f8             	incl   -0x8(%ebp)
  80125a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801260:	7c d9                	jl     80123b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801262:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801265:	8b 45 10             	mov    0x10(%ebp),%eax
  801268:	01 d0                	add    %edx,%eax
  80126a:	c6 00 00             	movb   $0x0,(%eax)
}
  80126d:	90                   	nop
  80126e:	c9                   	leave  
  80126f:	c3                   	ret    

00801270 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801270:	55                   	push   %ebp
  801271:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801273:	8b 45 14             	mov    0x14(%ebp),%eax
  801276:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80127c:	8b 45 14             	mov    0x14(%ebp),%eax
  80127f:	8b 00                	mov    (%eax),%eax
  801281:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801288:	8b 45 10             	mov    0x10(%ebp),%eax
  80128b:	01 d0                	add    %edx,%eax
  80128d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801293:	eb 0c                	jmp    8012a1 <strsplit+0x31>
			*string++ = 0;
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	8d 50 01             	lea    0x1(%eax),%edx
  80129b:	89 55 08             	mov    %edx,0x8(%ebp)
  80129e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	8a 00                	mov    (%eax),%al
  8012a6:	84 c0                	test   %al,%al
  8012a8:	74 18                	je     8012c2 <strsplit+0x52>
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	8a 00                	mov    (%eax),%al
  8012af:	0f be c0             	movsbl %al,%eax
  8012b2:	50                   	push   %eax
  8012b3:	ff 75 0c             	pushl  0xc(%ebp)
  8012b6:	e8 83 fa ff ff       	call   800d3e <strchr>
  8012bb:	83 c4 08             	add    $0x8,%esp
  8012be:	85 c0                	test   %eax,%eax
  8012c0:	75 d3                	jne    801295 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	8a 00                	mov    (%eax),%al
  8012c7:	84 c0                	test   %al,%al
  8012c9:	74 5a                	je     801325 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ce:	8b 00                	mov    (%eax),%eax
  8012d0:	83 f8 0f             	cmp    $0xf,%eax
  8012d3:	75 07                	jne    8012dc <strsplit+0x6c>
		{
			return 0;
  8012d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012da:	eb 66                	jmp    801342 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8012df:	8b 00                	mov    (%eax),%eax
  8012e1:	8d 48 01             	lea    0x1(%eax),%ecx
  8012e4:	8b 55 14             	mov    0x14(%ebp),%edx
  8012e7:	89 0a                	mov    %ecx,(%edx)
  8012e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f3:	01 c2                	add    %eax,%edx
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012fa:	eb 03                	jmp    8012ff <strsplit+0x8f>
			string++;
  8012fc:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801302:	8a 00                	mov    (%eax),%al
  801304:	84 c0                	test   %al,%al
  801306:	74 8b                	je     801293 <strsplit+0x23>
  801308:	8b 45 08             	mov    0x8(%ebp),%eax
  80130b:	8a 00                	mov    (%eax),%al
  80130d:	0f be c0             	movsbl %al,%eax
  801310:	50                   	push   %eax
  801311:	ff 75 0c             	pushl  0xc(%ebp)
  801314:	e8 25 fa ff ff       	call   800d3e <strchr>
  801319:	83 c4 08             	add    $0x8,%esp
  80131c:	85 c0                	test   %eax,%eax
  80131e:	74 dc                	je     8012fc <strsplit+0x8c>
			string++;
	}
  801320:	e9 6e ff ff ff       	jmp    801293 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801325:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801326:	8b 45 14             	mov    0x14(%ebp),%eax
  801329:	8b 00                	mov    (%eax),%eax
  80132b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801332:	8b 45 10             	mov    0x10(%ebp),%eax
  801335:	01 d0                	add    %edx,%eax
  801337:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80133d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801342:	c9                   	leave  
  801343:	c3                   	ret    

00801344 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801344:	55                   	push   %ebp
  801345:	89 e5                	mov    %esp,%ebp
  801347:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801350:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801357:	eb 4a                	jmp    8013a3 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801359:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	01 c2                	add    %eax,%edx
  801361:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801364:	8b 45 0c             	mov    0xc(%ebp),%eax
  801367:	01 c8                	add    %ecx,%eax
  801369:	8a 00                	mov    (%eax),%al
  80136b:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80136d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801370:	8b 45 0c             	mov    0xc(%ebp),%eax
  801373:	01 d0                	add    %edx,%eax
  801375:	8a 00                	mov    (%eax),%al
  801377:	3c 40                	cmp    $0x40,%al
  801379:	7e 25                	jle    8013a0 <str2lower+0x5c>
  80137b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80137e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801381:	01 d0                	add    %edx,%eax
  801383:	8a 00                	mov    (%eax),%al
  801385:	3c 5a                	cmp    $0x5a,%al
  801387:	7f 17                	jg     8013a0 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801389:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	01 d0                	add    %edx,%eax
  801391:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801394:	8b 55 08             	mov    0x8(%ebp),%edx
  801397:	01 ca                	add    %ecx,%edx
  801399:	8a 12                	mov    (%edx),%dl
  80139b:	83 c2 20             	add    $0x20,%edx
  80139e:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8013a0:	ff 45 fc             	incl   -0x4(%ebp)
  8013a3:	ff 75 0c             	pushl  0xc(%ebp)
  8013a6:	e8 01 f8 ff ff       	call   800bac <strlen>
  8013ab:	83 c4 04             	add    $0x4,%esp
  8013ae:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013b1:	7f a6                	jg     801359 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8013b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013b6:	c9                   	leave  
  8013b7:	c3                   	ret    

008013b8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
  8013bb:	57                   	push   %edi
  8013bc:	56                   	push   %esi
  8013bd:	53                   	push   %ebx
  8013be:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013ca:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013cd:	8b 7d 18             	mov    0x18(%ebp),%edi
  8013d0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8013d3:	cd 30                	int    $0x30
  8013d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8013d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013db:	83 c4 10             	add    $0x10,%esp
  8013de:	5b                   	pop    %ebx
  8013df:	5e                   	pop    %esi
  8013e0:	5f                   	pop    %edi
  8013e1:	5d                   	pop    %ebp
  8013e2:	c3                   	ret    

008013e3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8013e3:	55                   	push   %ebp
  8013e4:	89 e5                	mov    %esp,%ebp
  8013e6:	83 ec 04             	sub    $0x4,%esp
  8013e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8013ef:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013f2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	6a 00                	push   $0x0
  8013fb:	51                   	push   %ecx
  8013fc:	52                   	push   %edx
  8013fd:	ff 75 0c             	pushl  0xc(%ebp)
  801400:	50                   	push   %eax
  801401:	6a 00                	push   $0x0
  801403:	e8 b0 ff ff ff       	call   8013b8 <syscall>
  801408:	83 c4 18             	add    $0x18,%esp
}
  80140b:	90                   	nop
  80140c:	c9                   	leave  
  80140d:	c3                   	ret    

0080140e <sys_cgetc>:

int
sys_cgetc(void)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	6a 02                	push   $0x2
  80141d:	e8 96 ff ff ff       	call   8013b8 <syscall>
  801422:	83 c4 18             	add    $0x18,%esp
}
  801425:	c9                   	leave  
  801426:	c3                   	ret    

00801427 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801427:	55                   	push   %ebp
  801428:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 03                	push   $0x3
  801436:	e8 7d ff ff ff       	call   8013b8 <syscall>
  80143b:	83 c4 18             	add    $0x18,%esp
}
  80143e:	90                   	nop
  80143f:	c9                   	leave  
  801440:	c3                   	ret    

00801441 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801441:	55                   	push   %ebp
  801442:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	6a 00                	push   $0x0
  80144e:	6a 04                	push   $0x4
  801450:	e8 63 ff ff ff       	call   8013b8 <syscall>
  801455:	83 c4 18             	add    $0x18,%esp
}
  801458:	90                   	nop
  801459:	c9                   	leave  
  80145a:	c3                   	ret    

0080145b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80145e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	6a 00                	push   $0x0
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	52                   	push   %edx
  80146b:	50                   	push   %eax
  80146c:	6a 08                	push   $0x8
  80146e:	e8 45 ff ff ff       	call   8013b8 <syscall>
  801473:	83 c4 18             	add    $0x18,%esp
}
  801476:	c9                   	leave  
  801477:	c3                   	ret    

00801478 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801478:	55                   	push   %ebp
  801479:	89 e5                	mov    %esp,%ebp
  80147b:	56                   	push   %esi
  80147c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80147d:	8b 75 18             	mov    0x18(%ebp),%esi
  801480:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801483:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801486:	8b 55 0c             	mov    0xc(%ebp),%edx
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	56                   	push   %esi
  80148d:	53                   	push   %ebx
  80148e:	51                   	push   %ecx
  80148f:	52                   	push   %edx
  801490:	50                   	push   %eax
  801491:	6a 09                	push   $0x9
  801493:	e8 20 ff ff ff       	call   8013b8 <syscall>
  801498:	83 c4 18             	add    $0x18,%esp
}
  80149b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80149e:	5b                   	pop    %ebx
  80149f:	5e                   	pop    %esi
  8014a0:	5d                   	pop    %ebp
  8014a1:	c3                   	ret    

008014a2 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 00                	push   $0x0
  8014ad:	ff 75 08             	pushl  0x8(%ebp)
  8014b0:	6a 0a                	push   $0xa
  8014b2:	e8 01 ff ff ff       	call   8013b8 <syscall>
  8014b7:	83 c4 18             	add    $0x18,%esp
}
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	ff 75 0c             	pushl  0xc(%ebp)
  8014c8:	ff 75 08             	pushl  0x8(%ebp)
  8014cb:	6a 0b                	push   $0xb
  8014cd:	e8 e6 fe ff ff       	call   8013b8 <syscall>
  8014d2:	83 c4 18             	add    $0x18,%esp
}
  8014d5:	c9                   	leave  
  8014d6:	c3                   	ret    

008014d7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 0c                	push   $0xc
  8014e6:	e8 cd fe ff ff       	call   8013b8 <syscall>
  8014eb:	83 c4 18             	add    $0x18,%esp
}
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 0d                	push   $0xd
  8014ff:	e8 b4 fe ff ff       	call   8013b8 <syscall>
  801504:	83 c4 18             	add    $0x18,%esp
}
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 0e                	push   $0xe
  801518:	e8 9b fe ff ff       	call   8013b8 <syscall>
  80151d:	83 c4 18             	add    $0x18,%esp
}
  801520:	c9                   	leave  
  801521:	c3                   	ret    

00801522 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801522:	55                   	push   %ebp
  801523:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 0f                	push   $0xf
  801531:	e8 82 fe ff ff       	call   8013b8 <syscall>
  801536:	83 c4 18             	add    $0x18,%esp
}
  801539:	c9                   	leave  
  80153a:	c3                   	ret    

0080153b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	ff 75 08             	pushl  0x8(%ebp)
  801549:	6a 10                	push   $0x10
  80154b:	e8 68 fe ff ff       	call   8013b8 <syscall>
  801550:	83 c4 18             	add    $0x18,%esp
}
  801553:	c9                   	leave  
  801554:	c3                   	ret    

00801555 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801558:	6a 00                	push   $0x0
  80155a:	6a 00                	push   $0x0
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 11                	push   $0x11
  801564:	e8 4f fe ff ff       	call   8013b8 <syscall>
  801569:	83 c4 18             	add    $0x18,%esp
}
  80156c:	90                   	nop
  80156d:	c9                   	leave  
  80156e:	c3                   	ret    

0080156f <sys_cputc>:

void
sys_cputc(const char c)
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
  801572:	83 ec 04             	sub    $0x4,%esp
  801575:	8b 45 08             	mov    0x8(%ebp),%eax
  801578:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80157b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	50                   	push   %eax
  801588:	6a 01                	push   $0x1
  80158a:	e8 29 fe ff ff       	call   8013b8 <syscall>
  80158f:	83 c4 18             	add    $0x18,%esp
}
  801592:	90                   	nop
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 14                	push   $0x14
  8015a4:	e8 0f fe ff ff       	call   8013b8 <syscall>
  8015a9:	83 c4 18             	add    $0x18,%esp
}
  8015ac:	90                   	nop
  8015ad:	c9                   	leave  
  8015ae:	c3                   	ret    

008015af <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015af:	55                   	push   %ebp
  8015b0:	89 e5                	mov    %esp,%ebp
  8015b2:	83 ec 04             	sub    $0x4,%esp
  8015b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8015bb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015be:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	6a 00                	push   $0x0
  8015c7:	51                   	push   %ecx
  8015c8:	52                   	push   %edx
  8015c9:	ff 75 0c             	pushl  0xc(%ebp)
  8015cc:	50                   	push   %eax
  8015cd:	6a 15                	push   $0x15
  8015cf:	e8 e4 fd ff ff       	call   8013b8 <syscall>
  8015d4:	83 c4 18             	add    $0x18,%esp
}
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8015dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	52                   	push   %edx
  8015e9:	50                   	push   %eax
  8015ea:	6a 16                	push   $0x16
  8015ec:	e8 c7 fd ff ff       	call   8013b8 <syscall>
  8015f1:	83 c4 18             	add    $0x18,%esp
}
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8015f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	51                   	push   %ecx
  801607:	52                   	push   %edx
  801608:	50                   	push   %eax
  801609:	6a 17                	push   $0x17
  80160b:	e8 a8 fd ff ff       	call   8013b8 <syscall>
  801610:	83 c4 18             	add    $0x18,%esp
}
  801613:	c9                   	leave  
  801614:	c3                   	ret    

00801615 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801618:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161b:	8b 45 08             	mov    0x8(%ebp),%eax
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	52                   	push   %edx
  801625:	50                   	push   %eax
  801626:	6a 18                	push   $0x18
  801628:	e8 8b fd ff ff       	call   8013b8 <syscall>
  80162d:	83 c4 18             	add    $0x18,%esp
}
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	6a 00                	push   $0x0
  80163a:	ff 75 14             	pushl  0x14(%ebp)
  80163d:	ff 75 10             	pushl  0x10(%ebp)
  801640:	ff 75 0c             	pushl  0xc(%ebp)
  801643:	50                   	push   %eax
  801644:	6a 19                	push   $0x19
  801646:	e8 6d fd ff ff       	call   8013b8 <syscall>
  80164b:	83 c4 18             	add    $0x18,%esp
}
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    

00801650 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801653:	8b 45 08             	mov    0x8(%ebp),%eax
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	50                   	push   %eax
  80165f:	6a 1a                	push   $0x1a
  801661:	e8 52 fd ff ff       	call   8013b8 <syscall>
  801666:	83 c4 18             	add    $0x18,%esp
}
  801669:	90                   	nop
  80166a:	c9                   	leave  
  80166b:	c3                   	ret    

0080166c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	50                   	push   %eax
  80167b:	6a 1b                	push   $0x1b
  80167d:	e8 36 fd ff ff       	call   8013b8 <syscall>
  801682:	83 c4 18             	add    $0x18,%esp
}
  801685:	c9                   	leave  
  801686:	c3                   	ret    

00801687 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 05                	push   $0x5
  801696:	e8 1d fd ff ff       	call   8013b8 <syscall>
  80169b:	83 c4 18             	add    $0x18,%esp
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 06                	push   $0x6
  8016af:	e8 04 fd ff ff       	call   8013b8 <syscall>
  8016b4:	83 c4 18             	add    $0x18,%esp
}
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 07                	push   $0x7
  8016c8:	e8 eb fc ff ff       	call   8013b8 <syscall>
  8016cd:	83 c4 18             	add    $0x18,%esp
}
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    

008016d2 <sys_exit_env>:


void sys_exit_env(void)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 1c                	push   $0x1c
  8016e1:	e8 d2 fc ff ff       	call   8013b8 <syscall>
  8016e6:	83 c4 18             	add    $0x18,%esp
}
  8016e9:	90                   	nop
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
  8016ef:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8016f2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016f5:	8d 50 04             	lea    0x4(%eax),%edx
  8016f8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	52                   	push   %edx
  801702:	50                   	push   %eax
  801703:	6a 1d                	push   $0x1d
  801705:	e8 ae fc ff ff       	call   8013b8 <syscall>
  80170a:	83 c4 18             	add    $0x18,%esp
	return result;
  80170d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801710:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801713:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801716:	89 01                	mov    %eax,(%ecx)
  801718:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	c9                   	leave  
  80171f:	c2 04 00             	ret    $0x4

00801722 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	ff 75 10             	pushl  0x10(%ebp)
  80172c:	ff 75 0c             	pushl  0xc(%ebp)
  80172f:	ff 75 08             	pushl  0x8(%ebp)
  801732:	6a 13                	push   $0x13
  801734:	e8 7f fc ff ff       	call   8013b8 <syscall>
  801739:	83 c4 18             	add    $0x18,%esp
	return ;
  80173c:	90                   	nop
}
  80173d:	c9                   	leave  
  80173e:	c3                   	ret    

0080173f <sys_rcr2>:
uint32 sys_rcr2()
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 1e                	push   $0x1e
  80174e:	e8 65 fc ff ff       	call   8013b8 <syscall>
  801753:	83 c4 18             	add    $0x18,%esp
}
  801756:	c9                   	leave  
  801757:	c3                   	ret    

00801758 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	83 ec 04             	sub    $0x4,%esp
  80175e:	8b 45 08             	mov    0x8(%ebp),%eax
  801761:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801764:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	50                   	push   %eax
  801771:	6a 1f                	push   $0x1f
  801773:	e8 40 fc ff ff       	call   8013b8 <syscall>
  801778:	83 c4 18             	add    $0x18,%esp
	return ;
  80177b:	90                   	nop
}
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    

0080177e <rsttst>:
void rsttst()
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 21                	push   $0x21
  80178d:	e8 26 fc ff ff       	call   8013b8 <syscall>
  801792:	83 c4 18             	add    $0x18,%esp
	return ;
  801795:	90                   	nop
}
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	83 ec 04             	sub    $0x4,%esp
  80179e:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017a4:	8b 55 18             	mov    0x18(%ebp),%edx
  8017a7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017ab:	52                   	push   %edx
  8017ac:	50                   	push   %eax
  8017ad:	ff 75 10             	pushl  0x10(%ebp)
  8017b0:	ff 75 0c             	pushl  0xc(%ebp)
  8017b3:	ff 75 08             	pushl  0x8(%ebp)
  8017b6:	6a 20                	push   $0x20
  8017b8:	e8 fb fb ff ff       	call   8013b8 <syscall>
  8017bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c0:	90                   	nop
}
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <chktst>:
void chktst(uint32 n)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	ff 75 08             	pushl  0x8(%ebp)
  8017d1:	6a 22                	push   $0x22
  8017d3:	e8 e0 fb ff ff       	call   8013b8 <syscall>
  8017d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8017db:	90                   	nop
}
  8017dc:	c9                   	leave  
  8017dd:	c3                   	ret    

008017de <inctst>:

void inctst()
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 23                	push   $0x23
  8017ed:	e8 c6 fb ff ff       	call   8013b8 <syscall>
  8017f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f5:	90                   	nop
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <gettst>:
uint32 gettst()
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 24                	push   $0x24
  801807:	e8 ac fb ff ff       	call   8013b8 <syscall>
  80180c:	83 c4 18             	add    $0x18,%esp
}
  80180f:	c9                   	leave  
  801810:	c3                   	ret    

00801811 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 25                	push   $0x25
  801820:	e8 93 fb ff ff       	call   8013b8 <syscall>
  801825:	83 c4 18             	add    $0x18,%esp
  801828:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  80182d:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801832:	c9                   	leave  
  801833:	c3                   	ret    

00801834 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	ff 75 08             	pushl  0x8(%ebp)
  80184a:	6a 26                	push   $0x26
  80184c:	e8 67 fb ff ff       	call   8013b8 <syscall>
  801851:	83 c4 18             	add    $0x18,%esp
	return ;
  801854:	90                   	nop
}
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80185b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80185e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801861:	8b 55 0c             	mov    0xc(%ebp),%edx
  801864:	8b 45 08             	mov    0x8(%ebp),%eax
  801867:	6a 00                	push   $0x0
  801869:	53                   	push   %ebx
  80186a:	51                   	push   %ecx
  80186b:	52                   	push   %edx
  80186c:	50                   	push   %eax
  80186d:	6a 27                	push   $0x27
  80186f:	e8 44 fb ff ff       	call   8013b8 <syscall>
  801874:	83 c4 18             	add    $0x18,%esp
}
  801877:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80187f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801882:	8b 45 08             	mov    0x8(%ebp),%eax
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	52                   	push   %edx
  80188c:	50                   	push   %eax
  80188d:	6a 28                	push   $0x28
  80188f:	e8 24 fb ff ff       	call   8013b8 <syscall>
  801894:	83 c4 18             	add    $0x18,%esp
}
  801897:	c9                   	leave  
  801898:	c3                   	ret    

00801899 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80189c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80189f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a5:	6a 00                	push   $0x0
  8018a7:	51                   	push   %ecx
  8018a8:	ff 75 10             	pushl  0x10(%ebp)
  8018ab:	52                   	push   %edx
  8018ac:	50                   	push   %eax
  8018ad:	6a 29                	push   $0x29
  8018af:	e8 04 fb ff ff       	call   8013b8 <syscall>
  8018b4:	83 c4 18             	add    $0x18,%esp
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	ff 75 10             	pushl  0x10(%ebp)
  8018c3:	ff 75 0c             	pushl  0xc(%ebp)
  8018c6:	ff 75 08             	pushl  0x8(%ebp)
  8018c9:	6a 12                	push   $0x12
  8018cb:	e8 e8 fa ff ff       	call   8013b8 <syscall>
  8018d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d3:	90                   	nop
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8018d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	52                   	push   %edx
  8018e6:	50                   	push   %eax
  8018e7:	6a 2a                	push   $0x2a
  8018e9:	e8 ca fa ff ff       	call   8013b8 <syscall>
  8018ee:	83 c4 18             	add    $0x18,%esp
	return;
  8018f1:	90                   	nop
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 2b                	push   $0x2b
  801903:	e8 b0 fa ff ff       	call   8013b8 <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
}
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	ff 75 0c             	pushl  0xc(%ebp)
  801919:	ff 75 08             	pushl  0x8(%ebp)
  80191c:	6a 2d                	push   $0x2d
  80191e:	e8 95 fa ff ff       	call   8013b8 <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
	return;
  801926:	90                   	nop
}
  801927:	c9                   	leave  
  801928:	c3                   	ret    

00801929 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	ff 75 0c             	pushl  0xc(%ebp)
  801935:	ff 75 08             	pushl  0x8(%ebp)
  801938:	6a 2c                	push   $0x2c
  80193a:	e8 79 fa ff ff       	call   8013b8 <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
	return ;
  801942:	90                   	nop
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
  801948:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  80194b:	83 ec 04             	sub    $0x4,%esp
  80194e:	68 48 22 80 00       	push   $0x802248
  801953:	68 25 01 00 00       	push   $0x125
  801958:	68 7b 22 80 00       	push   $0x80227b
  80195d:	e8 a3 e8 ff ff       	call   800205 <_panic>
  801962:	66 90                	xchg   %ax,%ax

00801964 <__udivdi3>:
  801964:	55                   	push   %ebp
  801965:	57                   	push   %edi
  801966:	56                   	push   %esi
  801967:	53                   	push   %ebx
  801968:	83 ec 1c             	sub    $0x1c,%esp
  80196b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80196f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801973:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801977:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80197b:	89 ca                	mov    %ecx,%edx
  80197d:	89 f8                	mov    %edi,%eax
  80197f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801983:	85 f6                	test   %esi,%esi
  801985:	75 2d                	jne    8019b4 <__udivdi3+0x50>
  801987:	39 cf                	cmp    %ecx,%edi
  801989:	77 65                	ja     8019f0 <__udivdi3+0x8c>
  80198b:	89 fd                	mov    %edi,%ebp
  80198d:	85 ff                	test   %edi,%edi
  80198f:	75 0b                	jne    80199c <__udivdi3+0x38>
  801991:	b8 01 00 00 00       	mov    $0x1,%eax
  801996:	31 d2                	xor    %edx,%edx
  801998:	f7 f7                	div    %edi
  80199a:	89 c5                	mov    %eax,%ebp
  80199c:	31 d2                	xor    %edx,%edx
  80199e:	89 c8                	mov    %ecx,%eax
  8019a0:	f7 f5                	div    %ebp
  8019a2:	89 c1                	mov    %eax,%ecx
  8019a4:	89 d8                	mov    %ebx,%eax
  8019a6:	f7 f5                	div    %ebp
  8019a8:	89 cf                	mov    %ecx,%edi
  8019aa:	89 fa                	mov    %edi,%edx
  8019ac:	83 c4 1c             	add    $0x1c,%esp
  8019af:	5b                   	pop    %ebx
  8019b0:	5e                   	pop    %esi
  8019b1:	5f                   	pop    %edi
  8019b2:	5d                   	pop    %ebp
  8019b3:	c3                   	ret    
  8019b4:	39 ce                	cmp    %ecx,%esi
  8019b6:	77 28                	ja     8019e0 <__udivdi3+0x7c>
  8019b8:	0f bd fe             	bsr    %esi,%edi
  8019bb:	83 f7 1f             	xor    $0x1f,%edi
  8019be:	75 40                	jne    801a00 <__udivdi3+0x9c>
  8019c0:	39 ce                	cmp    %ecx,%esi
  8019c2:	72 0a                	jb     8019ce <__udivdi3+0x6a>
  8019c4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019c8:	0f 87 9e 00 00 00    	ja     801a6c <__udivdi3+0x108>
  8019ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8019d3:	89 fa                	mov    %edi,%edx
  8019d5:	83 c4 1c             	add    $0x1c,%esp
  8019d8:	5b                   	pop    %ebx
  8019d9:	5e                   	pop    %esi
  8019da:	5f                   	pop    %edi
  8019db:	5d                   	pop    %ebp
  8019dc:	c3                   	ret    
  8019dd:	8d 76 00             	lea    0x0(%esi),%esi
  8019e0:	31 ff                	xor    %edi,%edi
  8019e2:	31 c0                	xor    %eax,%eax
  8019e4:	89 fa                	mov    %edi,%edx
  8019e6:	83 c4 1c             	add    $0x1c,%esp
  8019e9:	5b                   	pop    %ebx
  8019ea:	5e                   	pop    %esi
  8019eb:	5f                   	pop    %edi
  8019ec:	5d                   	pop    %ebp
  8019ed:	c3                   	ret    
  8019ee:	66 90                	xchg   %ax,%ax
  8019f0:	89 d8                	mov    %ebx,%eax
  8019f2:	f7 f7                	div    %edi
  8019f4:	31 ff                	xor    %edi,%edi
  8019f6:	89 fa                	mov    %edi,%edx
  8019f8:	83 c4 1c             	add    $0x1c,%esp
  8019fb:	5b                   	pop    %ebx
  8019fc:	5e                   	pop    %esi
  8019fd:	5f                   	pop    %edi
  8019fe:	5d                   	pop    %ebp
  8019ff:	c3                   	ret    
  801a00:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a05:	89 eb                	mov    %ebp,%ebx
  801a07:	29 fb                	sub    %edi,%ebx
  801a09:	89 f9                	mov    %edi,%ecx
  801a0b:	d3 e6                	shl    %cl,%esi
  801a0d:	89 c5                	mov    %eax,%ebp
  801a0f:	88 d9                	mov    %bl,%cl
  801a11:	d3 ed                	shr    %cl,%ebp
  801a13:	89 e9                	mov    %ebp,%ecx
  801a15:	09 f1                	or     %esi,%ecx
  801a17:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a1b:	89 f9                	mov    %edi,%ecx
  801a1d:	d3 e0                	shl    %cl,%eax
  801a1f:	89 c5                	mov    %eax,%ebp
  801a21:	89 d6                	mov    %edx,%esi
  801a23:	88 d9                	mov    %bl,%cl
  801a25:	d3 ee                	shr    %cl,%esi
  801a27:	89 f9                	mov    %edi,%ecx
  801a29:	d3 e2                	shl    %cl,%edx
  801a2b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a2f:	88 d9                	mov    %bl,%cl
  801a31:	d3 e8                	shr    %cl,%eax
  801a33:	09 c2                	or     %eax,%edx
  801a35:	89 d0                	mov    %edx,%eax
  801a37:	89 f2                	mov    %esi,%edx
  801a39:	f7 74 24 0c          	divl   0xc(%esp)
  801a3d:	89 d6                	mov    %edx,%esi
  801a3f:	89 c3                	mov    %eax,%ebx
  801a41:	f7 e5                	mul    %ebp
  801a43:	39 d6                	cmp    %edx,%esi
  801a45:	72 19                	jb     801a60 <__udivdi3+0xfc>
  801a47:	74 0b                	je     801a54 <__udivdi3+0xf0>
  801a49:	89 d8                	mov    %ebx,%eax
  801a4b:	31 ff                	xor    %edi,%edi
  801a4d:	e9 58 ff ff ff       	jmp    8019aa <__udivdi3+0x46>
  801a52:	66 90                	xchg   %ax,%ax
  801a54:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a58:	89 f9                	mov    %edi,%ecx
  801a5a:	d3 e2                	shl    %cl,%edx
  801a5c:	39 c2                	cmp    %eax,%edx
  801a5e:	73 e9                	jae    801a49 <__udivdi3+0xe5>
  801a60:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a63:	31 ff                	xor    %edi,%edi
  801a65:	e9 40 ff ff ff       	jmp    8019aa <__udivdi3+0x46>
  801a6a:	66 90                	xchg   %ax,%ax
  801a6c:	31 c0                	xor    %eax,%eax
  801a6e:	e9 37 ff ff ff       	jmp    8019aa <__udivdi3+0x46>
  801a73:	90                   	nop

00801a74 <__umoddi3>:
  801a74:	55                   	push   %ebp
  801a75:	57                   	push   %edi
  801a76:	56                   	push   %esi
  801a77:	53                   	push   %ebx
  801a78:	83 ec 1c             	sub    $0x1c,%esp
  801a7b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a87:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a8b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a8f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a93:	89 f3                	mov    %esi,%ebx
  801a95:	89 fa                	mov    %edi,%edx
  801a97:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a9b:	89 34 24             	mov    %esi,(%esp)
  801a9e:	85 c0                	test   %eax,%eax
  801aa0:	75 1a                	jne    801abc <__umoddi3+0x48>
  801aa2:	39 f7                	cmp    %esi,%edi
  801aa4:	0f 86 a2 00 00 00    	jbe    801b4c <__umoddi3+0xd8>
  801aaa:	89 c8                	mov    %ecx,%eax
  801aac:	89 f2                	mov    %esi,%edx
  801aae:	f7 f7                	div    %edi
  801ab0:	89 d0                	mov    %edx,%eax
  801ab2:	31 d2                	xor    %edx,%edx
  801ab4:	83 c4 1c             	add    $0x1c,%esp
  801ab7:	5b                   	pop    %ebx
  801ab8:	5e                   	pop    %esi
  801ab9:	5f                   	pop    %edi
  801aba:	5d                   	pop    %ebp
  801abb:	c3                   	ret    
  801abc:	39 f0                	cmp    %esi,%eax
  801abe:	0f 87 ac 00 00 00    	ja     801b70 <__umoddi3+0xfc>
  801ac4:	0f bd e8             	bsr    %eax,%ebp
  801ac7:	83 f5 1f             	xor    $0x1f,%ebp
  801aca:	0f 84 ac 00 00 00    	je     801b7c <__umoddi3+0x108>
  801ad0:	bf 20 00 00 00       	mov    $0x20,%edi
  801ad5:	29 ef                	sub    %ebp,%edi
  801ad7:	89 fe                	mov    %edi,%esi
  801ad9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801add:	89 e9                	mov    %ebp,%ecx
  801adf:	d3 e0                	shl    %cl,%eax
  801ae1:	89 d7                	mov    %edx,%edi
  801ae3:	89 f1                	mov    %esi,%ecx
  801ae5:	d3 ef                	shr    %cl,%edi
  801ae7:	09 c7                	or     %eax,%edi
  801ae9:	89 e9                	mov    %ebp,%ecx
  801aeb:	d3 e2                	shl    %cl,%edx
  801aed:	89 14 24             	mov    %edx,(%esp)
  801af0:	89 d8                	mov    %ebx,%eax
  801af2:	d3 e0                	shl    %cl,%eax
  801af4:	89 c2                	mov    %eax,%edx
  801af6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801afa:	d3 e0                	shl    %cl,%eax
  801afc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b00:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b04:	89 f1                	mov    %esi,%ecx
  801b06:	d3 e8                	shr    %cl,%eax
  801b08:	09 d0                	or     %edx,%eax
  801b0a:	d3 eb                	shr    %cl,%ebx
  801b0c:	89 da                	mov    %ebx,%edx
  801b0e:	f7 f7                	div    %edi
  801b10:	89 d3                	mov    %edx,%ebx
  801b12:	f7 24 24             	mull   (%esp)
  801b15:	89 c6                	mov    %eax,%esi
  801b17:	89 d1                	mov    %edx,%ecx
  801b19:	39 d3                	cmp    %edx,%ebx
  801b1b:	0f 82 87 00 00 00    	jb     801ba8 <__umoddi3+0x134>
  801b21:	0f 84 91 00 00 00    	je     801bb8 <__umoddi3+0x144>
  801b27:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b2b:	29 f2                	sub    %esi,%edx
  801b2d:	19 cb                	sbb    %ecx,%ebx
  801b2f:	89 d8                	mov    %ebx,%eax
  801b31:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b35:	d3 e0                	shl    %cl,%eax
  801b37:	89 e9                	mov    %ebp,%ecx
  801b39:	d3 ea                	shr    %cl,%edx
  801b3b:	09 d0                	or     %edx,%eax
  801b3d:	89 e9                	mov    %ebp,%ecx
  801b3f:	d3 eb                	shr    %cl,%ebx
  801b41:	89 da                	mov    %ebx,%edx
  801b43:	83 c4 1c             	add    $0x1c,%esp
  801b46:	5b                   	pop    %ebx
  801b47:	5e                   	pop    %esi
  801b48:	5f                   	pop    %edi
  801b49:	5d                   	pop    %ebp
  801b4a:	c3                   	ret    
  801b4b:	90                   	nop
  801b4c:	89 fd                	mov    %edi,%ebp
  801b4e:	85 ff                	test   %edi,%edi
  801b50:	75 0b                	jne    801b5d <__umoddi3+0xe9>
  801b52:	b8 01 00 00 00       	mov    $0x1,%eax
  801b57:	31 d2                	xor    %edx,%edx
  801b59:	f7 f7                	div    %edi
  801b5b:	89 c5                	mov    %eax,%ebp
  801b5d:	89 f0                	mov    %esi,%eax
  801b5f:	31 d2                	xor    %edx,%edx
  801b61:	f7 f5                	div    %ebp
  801b63:	89 c8                	mov    %ecx,%eax
  801b65:	f7 f5                	div    %ebp
  801b67:	89 d0                	mov    %edx,%eax
  801b69:	e9 44 ff ff ff       	jmp    801ab2 <__umoddi3+0x3e>
  801b6e:	66 90                	xchg   %ax,%ax
  801b70:	89 c8                	mov    %ecx,%eax
  801b72:	89 f2                	mov    %esi,%edx
  801b74:	83 c4 1c             	add    $0x1c,%esp
  801b77:	5b                   	pop    %ebx
  801b78:	5e                   	pop    %esi
  801b79:	5f                   	pop    %edi
  801b7a:	5d                   	pop    %ebp
  801b7b:	c3                   	ret    
  801b7c:	3b 04 24             	cmp    (%esp),%eax
  801b7f:	72 06                	jb     801b87 <__umoddi3+0x113>
  801b81:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b85:	77 0f                	ja     801b96 <__umoddi3+0x122>
  801b87:	89 f2                	mov    %esi,%edx
  801b89:	29 f9                	sub    %edi,%ecx
  801b8b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b8f:	89 14 24             	mov    %edx,(%esp)
  801b92:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b96:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b9a:	8b 14 24             	mov    (%esp),%edx
  801b9d:	83 c4 1c             	add    $0x1c,%esp
  801ba0:	5b                   	pop    %ebx
  801ba1:	5e                   	pop    %esi
  801ba2:	5f                   	pop    %edi
  801ba3:	5d                   	pop    %ebp
  801ba4:	c3                   	ret    
  801ba5:	8d 76 00             	lea    0x0(%esi),%esi
  801ba8:	2b 04 24             	sub    (%esp),%eax
  801bab:	19 fa                	sbb    %edi,%edx
  801bad:	89 d1                	mov    %edx,%ecx
  801baf:	89 c6                	mov    %eax,%esi
  801bb1:	e9 71 ff ff ff       	jmp    801b27 <__umoddi3+0xb3>
  801bb6:	66 90                	xchg   %ax,%ax
  801bb8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bbc:	72 ea                	jb     801ba8 <__umoddi3+0x134>
  801bbe:	89 d9                	mov    %ebx,%ecx
  801bc0:	e9 62 ff ff ff       	jmp    801b27 <__umoddi3+0xb3>


obj/user/tst_invalid_access_slave3:     file format elf32-i386


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
  800031:	e8 31 00 00 00       	call   800067 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/************************************************************/

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//[1] Non=reserved User Heap
	uint32 *ptr = (uint32*)(USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE);
  80003e:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	*ptr = 100 ;
  800045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800048:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	inctst();
  80004e:	e8 9d 17 00 00       	call   8017f0 <inctst>
	panic("tst invalid access failed: Attempt to access a non-reserved (unmarked) user heap page.\nThe env must be killed and shouldn't return here.");
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	68 e0 1b 80 00       	push   $0x801be0
  80005b:	6a 0e                	push   $0xe
  80005d:	68 6c 1c 80 00       	push   $0x801c6c
  800062:	e8 b0 01 00 00       	call   800217 <_panic>

00800067 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800067:	55                   	push   %ebp
  800068:	89 e5                	mov    %esp,%ebp
  80006a:	57                   	push   %edi
  80006b:	56                   	push   %esi
  80006c:	53                   	push   %ebx
  80006d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800070:	e8 3d 16 00 00       	call   8016b2 <sys_getenvindex>
  800075:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800078:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80007b:	89 d0                	mov    %edx,%eax
  80007d:	c1 e0 02             	shl    $0x2,%eax
  800080:	01 d0                	add    %edx,%eax
  800082:	c1 e0 03             	shl    $0x3,%eax
  800085:	01 d0                	add    %edx,%eax
  800087:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80008e:	01 d0                	add    %edx,%eax
  800090:	c1 e0 02             	shl    $0x2,%eax
  800093:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800098:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80009d:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a2:	8a 40 20             	mov    0x20(%eax),%al
  8000a5:	84 c0                	test   %al,%al
  8000a7:	74 0d                	je     8000b6 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8000a9:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ae:	83 c0 20             	add    $0x20,%eax
  8000b1:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000ba:	7e 0a                	jle    8000c6 <libmain+0x5f>
		binaryname = argv[0];
  8000bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000bf:	8b 00                	mov    (%eax),%eax
  8000c1:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000c6:	83 ec 08             	sub    $0x8,%esp
  8000c9:	ff 75 0c             	pushl  0xc(%ebp)
  8000cc:	ff 75 08             	pushl  0x8(%ebp)
  8000cf:	e8 64 ff ff ff       	call   800038 <_main>
  8000d4:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000d7:	a1 00 30 80 00       	mov    0x803000,%eax
  8000dc:	85 c0                	test   %eax,%eax
  8000de:	0f 84 01 01 00 00    	je     8001e5 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8000e4:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8000ea:	bb 88 1d 80 00       	mov    $0x801d88,%ebx
  8000ef:	ba 0e 00 00 00       	mov    $0xe,%edx
  8000f4:	89 c7                	mov    %eax,%edi
  8000f6:	89 de                	mov    %ebx,%esi
  8000f8:	89 d1                	mov    %edx,%ecx
  8000fa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000fc:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8000ff:	b9 56 00 00 00       	mov    $0x56,%ecx
  800104:	b0 00                	mov    $0x0,%al
  800106:	89 d7                	mov    %edx,%edi
  800108:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80010a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800111:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800114:	83 ec 08             	sub    $0x8,%esp
  800117:	50                   	push   %eax
  800118:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80011e:	50                   	push   %eax
  80011f:	e8 c4 17 00 00       	call   8018e8 <sys_utilities>
  800124:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800127:	e8 0d 13 00 00       	call   801439 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80012c:	83 ec 0c             	sub    $0xc,%esp
  80012f:	68 a8 1c 80 00       	push   $0x801ca8
  800134:	e8 ac 03 00 00       	call   8004e5 <cprintf>
  800139:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80013c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80013f:	85 c0                	test   %eax,%eax
  800141:	74 18                	je     80015b <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800143:	e8 be 17 00 00       	call   801906 <sys_get_optimal_num_faults>
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	50                   	push   %eax
  80014c:	68 d0 1c 80 00       	push   $0x801cd0
  800151:	e8 8f 03 00 00       	call   8004e5 <cprintf>
  800156:	83 c4 10             	add    $0x10,%esp
  800159:	eb 59                	jmp    8001b4 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80015b:	a1 20 30 80 00       	mov    0x803020,%eax
  800160:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800166:	a1 20 30 80 00       	mov    0x803020,%eax
  80016b:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	52                   	push   %edx
  800175:	50                   	push   %eax
  800176:	68 f4 1c 80 00       	push   $0x801cf4
  80017b:	e8 65 03 00 00       	call   8004e5 <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800183:	a1 20 30 80 00       	mov    0x803020,%eax
  800188:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80018e:	a1 20 30 80 00       	mov    0x803020,%eax
  800193:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800199:	a1 20 30 80 00       	mov    0x803020,%eax
  80019e:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8001a4:	51                   	push   %ecx
  8001a5:	52                   	push   %edx
  8001a6:	50                   	push   %eax
  8001a7:	68 1c 1d 80 00       	push   $0x801d1c
  8001ac:	e8 34 03 00 00       	call   8004e5 <cprintf>
  8001b1:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001b4:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b9:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8001bf:	83 ec 08             	sub    $0x8,%esp
  8001c2:	50                   	push   %eax
  8001c3:	68 74 1d 80 00       	push   $0x801d74
  8001c8:	e8 18 03 00 00       	call   8004e5 <cprintf>
  8001cd:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	68 a8 1c 80 00       	push   $0x801ca8
  8001d8:	e8 08 03 00 00       	call   8004e5 <cprintf>
  8001dd:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001e0:	e8 6e 12 00 00       	call   801453 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001e5:	e8 1f 00 00 00       	call   800209 <exit>
}
  8001ea:	90                   	nop
  8001eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ee:	5b                   	pop    %ebx
  8001ef:	5e                   	pop    %esi
  8001f0:	5f                   	pop    %edi
  8001f1:	5d                   	pop    %ebp
  8001f2:	c3                   	ret    

008001f3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001f3:	55                   	push   %ebp
  8001f4:	89 e5                	mov    %esp,%ebp
  8001f6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001f9:	83 ec 0c             	sub    $0xc,%esp
  8001fc:	6a 00                	push   $0x0
  8001fe:	e8 7b 14 00 00       	call   80167e <sys_destroy_env>
  800203:	83 c4 10             	add    $0x10,%esp
}
  800206:	90                   	nop
  800207:	c9                   	leave  
  800208:	c3                   	ret    

00800209 <exit>:

void
exit(void)
{
  800209:	55                   	push   %ebp
  80020a:	89 e5                	mov    %esp,%ebp
  80020c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80020f:	e8 d0 14 00 00       	call   8016e4 <sys_exit_env>
}
  800214:	90                   	nop
  800215:	c9                   	leave  
  800216:	c3                   	ret    

00800217 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800217:	55                   	push   %ebp
  800218:	89 e5                	mov    %esp,%ebp
  80021a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80021d:	8d 45 10             	lea    0x10(%ebp),%eax
  800220:	83 c0 04             	add    $0x4,%eax
  800223:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800226:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80022b:	85 c0                	test   %eax,%eax
  80022d:	74 16                	je     800245 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80022f:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800234:	83 ec 08             	sub    $0x8,%esp
  800237:	50                   	push   %eax
  800238:	68 ec 1d 80 00       	push   $0x801dec
  80023d:	e8 a3 02 00 00       	call   8004e5 <cprintf>
  800242:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800245:	a1 04 30 80 00       	mov    0x803004,%eax
  80024a:	83 ec 0c             	sub    $0xc,%esp
  80024d:	ff 75 0c             	pushl  0xc(%ebp)
  800250:	ff 75 08             	pushl  0x8(%ebp)
  800253:	50                   	push   %eax
  800254:	68 f4 1d 80 00       	push   $0x801df4
  800259:	6a 74                	push   $0x74
  80025b:	e8 b2 02 00 00       	call   800512 <cprintf_colored>
  800260:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800263:	8b 45 10             	mov    0x10(%ebp),%eax
  800266:	83 ec 08             	sub    $0x8,%esp
  800269:	ff 75 f4             	pushl  -0xc(%ebp)
  80026c:	50                   	push   %eax
  80026d:	e8 04 02 00 00       	call   800476 <vcprintf>
  800272:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800275:	83 ec 08             	sub    $0x8,%esp
  800278:	6a 00                	push   $0x0
  80027a:	68 1c 1e 80 00       	push   $0x801e1c
  80027f:	e8 f2 01 00 00       	call   800476 <vcprintf>
  800284:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800287:	e8 7d ff ff ff       	call   800209 <exit>

	// should not return here
	while (1) ;
  80028c:	eb fe                	jmp    80028c <_panic+0x75>

0080028e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800294:	a1 20 30 80 00       	mov    0x803020,%eax
  800299:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80029f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a2:	39 c2                	cmp    %eax,%edx
  8002a4:	74 14                	je     8002ba <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002a6:	83 ec 04             	sub    $0x4,%esp
  8002a9:	68 20 1e 80 00       	push   $0x801e20
  8002ae:	6a 26                	push   $0x26
  8002b0:	68 6c 1e 80 00       	push   $0x801e6c
  8002b5:	e8 5d ff ff ff       	call   800217 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002c8:	e9 c5 00 00 00       	jmp    800392 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8002cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002da:	01 d0                	add    %edx,%eax
  8002dc:	8b 00                	mov    (%eax),%eax
  8002de:	85 c0                	test   %eax,%eax
  8002e0:	75 08                	jne    8002ea <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8002e2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8002e5:	e9 a5 00 00 00       	jmp    80038f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8002ea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8002f1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002f8:	eb 69                	jmp    800363 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8002fa:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ff:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800305:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800308:	89 d0                	mov    %edx,%eax
  80030a:	01 c0                	add    %eax,%eax
  80030c:	01 d0                	add    %edx,%eax
  80030e:	c1 e0 03             	shl    $0x3,%eax
  800311:	01 c8                	add    %ecx,%eax
  800313:	8a 40 04             	mov    0x4(%eax),%al
  800316:	84 c0                	test   %al,%al
  800318:	75 46                	jne    800360 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80031a:	a1 20 30 80 00       	mov    0x803020,%eax
  80031f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800325:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800328:	89 d0                	mov    %edx,%eax
  80032a:	01 c0                	add    %eax,%eax
  80032c:	01 d0                	add    %edx,%eax
  80032e:	c1 e0 03             	shl    $0x3,%eax
  800331:	01 c8                	add    %ecx,%eax
  800333:	8b 00                	mov    (%eax),%eax
  800335:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800338:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80033b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800340:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800345:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 c8                	add    %ecx,%eax
  800351:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800353:	39 c2                	cmp    %eax,%edx
  800355:	75 09                	jne    800360 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800357:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80035e:	eb 15                	jmp    800375 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800360:	ff 45 e8             	incl   -0x18(%ebp)
  800363:	a1 20 30 80 00       	mov    0x803020,%eax
  800368:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80036e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800371:	39 c2                	cmp    %eax,%edx
  800373:	77 85                	ja     8002fa <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800375:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800379:	75 14                	jne    80038f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80037b:	83 ec 04             	sub    $0x4,%esp
  80037e:	68 78 1e 80 00       	push   $0x801e78
  800383:	6a 3a                	push   $0x3a
  800385:	68 6c 1e 80 00       	push   $0x801e6c
  80038a:	e8 88 fe ff ff       	call   800217 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80038f:	ff 45 f0             	incl   -0x10(%ebp)
  800392:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800395:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800398:	0f 8c 2f ff ff ff    	jl     8002cd <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80039e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003a5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003ac:	eb 26                	jmp    8003d4 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003ae:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b3:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003bc:	89 d0                	mov    %edx,%eax
  8003be:	01 c0                	add    %eax,%eax
  8003c0:	01 d0                	add    %edx,%eax
  8003c2:	c1 e0 03             	shl    $0x3,%eax
  8003c5:	01 c8                	add    %ecx,%eax
  8003c7:	8a 40 04             	mov    0x4(%eax),%al
  8003ca:	3c 01                	cmp    $0x1,%al
  8003cc:	75 03                	jne    8003d1 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8003ce:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d1:	ff 45 e0             	incl   -0x20(%ebp)
  8003d4:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e2:	39 c2                	cmp    %eax,%edx
  8003e4:	77 c8                	ja     8003ae <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8003e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003e9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8003ec:	74 14                	je     800402 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8003ee:	83 ec 04             	sub    $0x4,%esp
  8003f1:	68 cc 1e 80 00       	push   $0x801ecc
  8003f6:	6a 44                	push   $0x44
  8003f8:	68 6c 1e 80 00       	push   $0x801e6c
  8003fd:	e8 15 fe ff ff       	call   800217 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800402:	90                   	nop
  800403:	c9                   	leave  
  800404:	c3                   	ret    

00800405 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800405:	55                   	push   %ebp
  800406:	89 e5                	mov    %esp,%ebp
  800408:	53                   	push   %ebx
  800409:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80040c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040f:	8b 00                	mov    (%eax),%eax
  800411:	8d 48 01             	lea    0x1(%eax),%ecx
  800414:	8b 55 0c             	mov    0xc(%ebp),%edx
  800417:	89 0a                	mov    %ecx,(%edx)
  800419:	8b 55 08             	mov    0x8(%ebp),%edx
  80041c:	88 d1                	mov    %dl,%cl
  80041e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800421:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800425:	8b 45 0c             	mov    0xc(%ebp),%eax
  800428:	8b 00                	mov    (%eax),%eax
  80042a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80042f:	75 30                	jne    800461 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800431:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800437:	a0 44 30 80 00       	mov    0x803044,%al
  80043c:	0f b6 c0             	movzbl %al,%eax
  80043f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800442:	8b 09                	mov    (%ecx),%ecx
  800444:	89 cb                	mov    %ecx,%ebx
  800446:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800449:	83 c1 08             	add    $0x8,%ecx
  80044c:	52                   	push   %edx
  80044d:	50                   	push   %eax
  80044e:	53                   	push   %ebx
  80044f:	51                   	push   %ecx
  800450:	e8 a0 0f 00 00       	call   8013f5 <sys_cputs>
  800455:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800458:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800461:	8b 45 0c             	mov    0xc(%ebp),%eax
  800464:	8b 40 04             	mov    0x4(%eax),%eax
  800467:	8d 50 01             	lea    0x1(%eax),%edx
  80046a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800470:	90                   	nop
  800471:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800474:	c9                   	leave  
  800475:	c3                   	ret    

00800476 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800476:	55                   	push   %ebp
  800477:	89 e5                	mov    %esp,%ebp
  800479:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80047f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800486:	00 00 00 
	b.cnt = 0;
  800489:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800490:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800493:	ff 75 0c             	pushl  0xc(%ebp)
  800496:	ff 75 08             	pushl  0x8(%ebp)
  800499:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80049f:	50                   	push   %eax
  8004a0:	68 05 04 80 00       	push   $0x800405
  8004a5:	e8 5a 02 00 00       	call   800704 <vprintfmt>
  8004aa:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8004ad:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004b3:	a0 44 30 80 00       	mov    0x803044,%al
  8004b8:	0f b6 c0             	movzbl %al,%eax
  8004bb:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8004c1:	52                   	push   %edx
  8004c2:	50                   	push   %eax
  8004c3:	51                   	push   %ecx
  8004c4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004ca:	83 c0 08             	add    $0x8,%eax
  8004cd:	50                   	push   %eax
  8004ce:	e8 22 0f 00 00       	call   8013f5 <sys_cputs>
  8004d3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8004d6:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8004dd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8004e3:	c9                   	leave  
  8004e4:	c3                   	ret    

008004e5 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8004e5:	55                   	push   %ebp
  8004e6:	89 e5                	mov    %esp,%ebp
  8004e8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8004eb:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8004f2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8004f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8004f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fb:	83 ec 08             	sub    $0x8,%esp
  8004fe:	ff 75 f4             	pushl  -0xc(%ebp)
  800501:	50                   	push   %eax
  800502:	e8 6f ff ff ff       	call   800476 <vcprintf>
  800507:	83 c4 10             	add    $0x10,%esp
  80050a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80050d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800510:	c9                   	leave  
  800511:	c3                   	ret    

00800512 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800512:	55                   	push   %ebp
  800513:	89 e5                	mov    %esp,%ebp
  800515:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800518:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80051f:	8b 45 08             	mov    0x8(%ebp),%eax
  800522:	c1 e0 08             	shl    $0x8,%eax
  800525:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  80052a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80052d:	83 c0 04             	add    $0x4,%eax
  800530:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800533:	8b 45 0c             	mov    0xc(%ebp),%eax
  800536:	83 ec 08             	sub    $0x8,%esp
  800539:	ff 75 f4             	pushl  -0xc(%ebp)
  80053c:	50                   	push   %eax
  80053d:	e8 34 ff ff ff       	call   800476 <vcprintf>
  800542:	83 c4 10             	add    $0x10,%esp
  800545:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800548:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  80054f:	07 00 00 

	return cnt;
  800552:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800555:	c9                   	leave  
  800556:	c3                   	ret    

00800557 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800557:	55                   	push   %ebp
  800558:	89 e5                	mov    %esp,%ebp
  80055a:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80055d:	e8 d7 0e 00 00       	call   801439 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800562:	8d 45 0c             	lea    0xc(%ebp),%eax
  800565:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800568:	8b 45 08             	mov    0x8(%ebp),%eax
  80056b:	83 ec 08             	sub    $0x8,%esp
  80056e:	ff 75 f4             	pushl  -0xc(%ebp)
  800571:	50                   	push   %eax
  800572:	e8 ff fe ff ff       	call   800476 <vcprintf>
  800577:	83 c4 10             	add    $0x10,%esp
  80057a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80057d:	e8 d1 0e 00 00       	call   801453 <sys_unlock_cons>
	return cnt;
  800582:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800585:	c9                   	leave  
  800586:	c3                   	ret    

00800587 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800587:	55                   	push   %ebp
  800588:	89 e5                	mov    %esp,%ebp
  80058a:	53                   	push   %ebx
  80058b:	83 ec 14             	sub    $0x14,%esp
  80058e:	8b 45 10             	mov    0x10(%ebp),%eax
  800591:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80059a:	8b 45 18             	mov    0x18(%ebp),%eax
  80059d:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a5:	77 55                	ja     8005fc <printnum+0x75>
  8005a7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005aa:	72 05                	jb     8005b1 <printnum+0x2a>
  8005ac:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005af:	77 4b                	ja     8005fc <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005b4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005b7:	8b 45 18             	mov    0x18(%ebp),%eax
  8005ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bf:	52                   	push   %edx
  8005c0:	50                   	push   %eax
  8005c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8005c7:	e8 a8 13 00 00       	call   801974 <__udivdi3>
  8005cc:	83 c4 10             	add    $0x10,%esp
  8005cf:	83 ec 04             	sub    $0x4,%esp
  8005d2:	ff 75 20             	pushl  0x20(%ebp)
  8005d5:	53                   	push   %ebx
  8005d6:	ff 75 18             	pushl  0x18(%ebp)
  8005d9:	52                   	push   %edx
  8005da:	50                   	push   %eax
  8005db:	ff 75 0c             	pushl  0xc(%ebp)
  8005de:	ff 75 08             	pushl  0x8(%ebp)
  8005e1:	e8 a1 ff ff ff       	call   800587 <printnum>
  8005e6:	83 c4 20             	add    $0x20,%esp
  8005e9:	eb 1a                	jmp    800605 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005eb:	83 ec 08             	sub    $0x8,%esp
  8005ee:	ff 75 0c             	pushl  0xc(%ebp)
  8005f1:	ff 75 20             	pushl  0x20(%ebp)
  8005f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f7:	ff d0                	call   *%eax
  8005f9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005fc:	ff 4d 1c             	decl   0x1c(%ebp)
  8005ff:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800603:	7f e6                	jg     8005eb <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800605:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800608:	bb 00 00 00 00       	mov    $0x0,%ebx
  80060d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800610:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800613:	53                   	push   %ebx
  800614:	51                   	push   %ecx
  800615:	52                   	push   %edx
  800616:	50                   	push   %eax
  800617:	e8 68 14 00 00       	call   801a84 <__umoddi3>
  80061c:	83 c4 10             	add    $0x10,%esp
  80061f:	05 34 21 80 00       	add    $0x802134,%eax
  800624:	8a 00                	mov    (%eax),%al
  800626:	0f be c0             	movsbl %al,%eax
  800629:	83 ec 08             	sub    $0x8,%esp
  80062c:	ff 75 0c             	pushl  0xc(%ebp)
  80062f:	50                   	push   %eax
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	ff d0                	call   *%eax
  800635:	83 c4 10             	add    $0x10,%esp
}
  800638:	90                   	nop
  800639:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80063c:	c9                   	leave  
  80063d:	c3                   	ret    

0080063e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80063e:	55                   	push   %ebp
  80063f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800641:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800645:	7e 1c                	jle    800663 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800647:	8b 45 08             	mov    0x8(%ebp),%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	8d 50 08             	lea    0x8(%eax),%edx
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	89 10                	mov    %edx,(%eax)
  800654:	8b 45 08             	mov    0x8(%ebp),%eax
  800657:	8b 00                	mov    (%eax),%eax
  800659:	83 e8 08             	sub    $0x8,%eax
  80065c:	8b 50 04             	mov    0x4(%eax),%edx
  80065f:	8b 00                	mov    (%eax),%eax
  800661:	eb 40                	jmp    8006a3 <getuint+0x65>
	else if (lflag)
  800663:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800667:	74 1e                	je     800687 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800669:	8b 45 08             	mov    0x8(%ebp),%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	8d 50 04             	lea    0x4(%eax),%edx
  800671:	8b 45 08             	mov    0x8(%ebp),%eax
  800674:	89 10                	mov    %edx,(%eax)
  800676:	8b 45 08             	mov    0x8(%ebp),%eax
  800679:	8b 00                	mov    (%eax),%eax
  80067b:	83 e8 04             	sub    $0x4,%eax
  80067e:	8b 00                	mov    (%eax),%eax
  800680:	ba 00 00 00 00       	mov    $0x0,%edx
  800685:	eb 1c                	jmp    8006a3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800687:	8b 45 08             	mov    0x8(%ebp),%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	8d 50 04             	lea    0x4(%eax),%edx
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	89 10                	mov    %edx,(%eax)
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	83 e8 04             	sub    $0x4,%eax
  80069c:	8b 00                	mov    (%eax),%eax
  80069e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006a3:	5d                   	pop    %ebp
  8006a4:	c3                   	ret    

008006a5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006a5:	55                   	push   %ebp
  8006a6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ac:	7e 1c                	jle    8006ca <getint+0x25>
		return va_arg(*ap, long long);
  8006ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b1:	8b 00                	mov    (%eax),%eax
  8006b3:	8d 50 08             	lea    0x8(%eax),%edx
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	89 10                	mov    %edx,(%eax)
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	83 e8 08             	sub    $0x8,%eax
  8006c3:	8b 50 04             	mov    0x4(%eax),%edx
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	eb 38                	jmp    800702 <getint+0x5d>
	else if (lflag)
  8006ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006ce:	74 1a                	je     8006ea <getint+0x45>
		return va_arg(*ap, long);
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	8b 00                	mov    (%eax),%eax
  8006d5:	8d 50 04             	lea    0x4(%eax),%edx
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	89 10                	mov    %edx,(%eax)
  8006dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	83 e8 04             	sub    $0x4,%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	99                   	cltd   
  8006e8:	eb 18                	jmp    800702 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	8d 50 04             	lea    0x4(%eax),%edx
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	89 10                	mov    %edx,(%eax)
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	83 e8 04             	sub    $0x4,%eax
  8006ff:	8b 00                	mov    (%eax),%eax
  800701:	99                   	cltd   
}
  800702:	5d                   	pop    %ebp
  800703:	c3                   	ret    

00800704 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
  800707:	56                   	push   %esi
  800708:	53                   	push   %ebx
  800709:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070c:	eb 17                	jmp    800725 <vprintfmt+0x21>
			if (ch == '\0')
  80070e:	85 db                	test   %ebx,%ebx
  800710:	0f 84 c1 03 00 00    	je     800ad7 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800716:	83 ec 08             	sub    $0x8,%esp
  800719:	ff 75 0c             	pushl  0xc(%ebp)
  80071c:	53                   	push   %ebx
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	ff d0                	call   *%eax
  800722:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800725:	8b 45 10             	mov    0x10(%ebp),%eax
  800728:	8d 50 01             	lea    0x1(%eax),%edx
  80072b:	89 55 10             	mov    %edx,0x10(%ebp)
  80072e:	8a 00                	mov    (%eax),%al
  800730:	0f b6 d8             	movzbl %al,%ebx
  800733:	83 fb 25             	cmp    $0x25,%ebx
  800736:	75 d6                	jne    80070e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800738:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80073c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800743:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80074a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800751:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800758:	8b 45 10             	mov    0x10(%ebp),%eax
  80075b:	8d 50 01             	lea    0x1(%eax),%edx
  80075e:	89 55 10             	mov    %edx,0x10(%ebp)
  800761:	8a 00                	mov    (%eax),%al
  800763:	0f b6 d8             	movzbl %al,%ebx
  800766:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800769:	83 f8 5b             	cmp    $0x5b,%eax
  80076c:	0f 87 3d 03 00 00    	ja     800aaf <vprintfmt+0x3ab>
  800772:	8b 04 85 58 21 80 00 	mov    0x802158(,%eax,4),%eax
  800779:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80077b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80077f:	eb d7                	jmp    800758 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800781:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800785:	eb d1                	jmp    800758 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800787:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80078e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800791:	89 d0                	mov    %edx,%eax
  800793:	c1 e0 02             	shl    $0x2,%eax
  800796:	01 d0                	add    %edx,%eax
  800798:	01 c0                	add    %eax,%eax
  80079a:	01 d8                	add    %ebx,%eax
  80079c:	83 e8 30             	sub    $0x30,%eax
  80079f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a5:	8a 00                	mov    (%eax),%al
  8007a7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007aa:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ad:	7e 3e                	jle    8007ed <vprintfmt+0xe9>
  8007af:	83 fb 39             	cmp    $0x39,%ebx
  8007b2:	7f 39                	jg     8007ed <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007b4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007b7:	eb d5                	jmp    80078e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bc:	83 c0 04             	add    $0x4,%eax
  8007bf:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c5:	83 e8 04             	sub    $0x4,%eax
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007cd:	eb 1f                	jmp    8007ee <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d3:	79 83                	jns    800758 <vprintfmt+0x54>
				width = 0;
  8007d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007dc:	e9 77 ff ff ff       	jmp    800758 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007e1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007e8:	e9 6b ff ff ff       	jmp    800758 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007ed:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f2:	0f 89 60 ff ff ff    	jns    800758 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007fe:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800805:	e9 4e ff ff ff       	jmp    800758 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80080a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80080d:	e9 46 ff ff ff       	jmp    800758 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800812:	8b 45 14             	mov    0x14(%ebp),%eax
  800815:	83 c0 04             	add    $0x4,%eax
  800818:	89 45 14             	mov    %eax,0x14(%ebp)
  80081b:	8b 45 14             	mov    0x14(%ebp),%eax
  80081e:	83 e8 04             	sub    $0x4,%eax
  800821:	8b 00                	mov    (%eax),%eax
  800823:	83 ec 08             	sub    $0x8,%esp
  800826:	ff 75 0c             	pushl  0xc(%ebp)
  800829:	50                   	push   %eax
  80082a:	8b 45 08             	mov    0x8(%ebp),%eax
  80082d:	ff d0                	call   *%eax
  80082f:	83 c4 10             	add    $0x10,%esp
			break;
  800832:	e9 9b 02 00 00       	jmp    800ad2 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800837:	8b 45 14             	mov    0x14(%ebp),%eax
  80083a:	83 c0 04             	add    $0x4,%eax
  80083d:	89 45 14             	mov    %eax,0x14(%ebp)
  800840:	8b 45 14             	mov    0x14(%ebp),%eax
  800843:	83 e8 04             	sub    $0x4,%eax
  800846:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800848:	85 db                	test   %ebx,%ebx
  80084a:	79 02                	jns    80084e <vprintfmt+0x14a>
				err = -err;
  80084c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80084e:	83 fb 64             	cmp    $0x64,%ebx
  800851:	7f 0b                	jg     80085e <vprintfmt+0x15a>
  800853:	8b 34 9d a0 1f 80 00 	mov    0x801fa0(,%ebx,4),%esi
  80085a:	85 f6                	test   %esi,%esi
  80085c:	75 19                	jne    800877 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80085e:	53                   	push   %ebx
  80085f:	68 45 21 80 00       	push   $0x802145
  800864:	ff 75 0c             	pushl  0xc(%ebp)
  800867:	ff 75 08             	pushl  0x8(%ebp)
  80086a:	e8 70 02 00 00       	call   800adf <printfmt>
  80086f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800872:	e9 5b 02 00 00       	jmp    800ad2 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800877:	56                   	push   %esi
  800878:	68 4e 21 80 00       	push   $0x80214e
  80087d:	ff 75 0c             	pushl  0xc(%ebp)
  800880:	ff 75 08             	pushl  0x8(%ebp)
  800883:	e8 57 02 00 00       	call   800adf <printfmt>
  800888:	83 c4 10             	add    $0x10,%esp
			break;
  80088b:	e9 42 02 00 00       	jmp    800ad2 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800890:	8b 45 14             	mov    0x14(%ebp),%eax
  800893:	83 c0 04             	add    $0x4,%eax
  800896:	89 45 14             	mov    %eax,0x14(%ebp)
  800899:	8b 45 14             	mov    0x14(%ebp),%eax
  80089c:	83 e8 04             	sub    $0x4,%eax
  80089f:	8b 30                	mov    (%eax),%esi
  8008a1:	85 f6                	test   %esi,%esi
  8008a3:	75 05                	jne    8008aa <vprintfmt+0x1a6>
				p = "(null)";
  8008a5:	be 51 21 80 00       	mov    $0x802151,%esi
			if (width > 0 && padc != '-')
  8008aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ae:	7e 6d                	jle    80091d <vprintfmt+0x219>
  8008b0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008b4:	74 67                	je     80091d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b9:	83 ec 08             	sub    $0x8,%esp
  8008bc:	50                   	push   %eax
  8008bd:	56                   	push   %esi
  8008be:	e8 1e 03 00 00       	call   800be1 <strnlen>
  8008c3:	83 c4 10             	add    $0x10,%esp
  8008c6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008c9:	eb 16                	jmp    8008e1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008cb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008cf:	83 ec 08             	sub    $0x8,%esp
  8008d2:	ff 75 0c             	pushl  0xc(%ebp)
  8008d5:	50                   	push   %eax
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	ff d0                	call   *%eax
  8008db:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008de:	ff 4d e4             	decl   -0x1c(%ebp)
  8008e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e5:	7f e4                	jg     8008cb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e7:	eb 34                	jmp    80091d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008e9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008ed:	74 1c                	je     80090b <vprintfmt+0x207>
  8008ef:	83 fb 1f             	cmp    $0x1f,%ebx
  8008f2:	7e 05                	jle    8008f9 <vprintfmt+0x1f5>
  8008f4:	83 fb 7e             	cmp    $0x7e,%ebx
  8008f7:	7e 12                	jle    80090b <vprintfmt+0x207>
					putch('?', putdat);
  8008f9:	83 ec 08             	sub    $0x8,%esp
  8008fc:	ff 75 0c             	pushl  0xc(%ebp)
  8008ff:	6a 3f                	push   $0x3f
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	ff d0                	call   *%eax
  800906:	83 c4 10             	add    $0x10,%esp
  800909:	eb 0f                	jmp    80091a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80090b:	83 ec 08             	sub    $0x8,%esp
  80090e:	ff 75 0c             	pushl  0xc(%ebp)
  800911:	53                   	push   %ebx
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	ff d0                	call   *%eax
  800917:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80091a:	ff 4d e4             	decl   -0x1c(%ebp)
  80091d:	89 f0                	mov    %esi,%eax
  80091f:	8d 70 01             	lea    0x1(%eax),%esi
  800922:	8a 00                	mov    (%eax),%al
  800924:	0f be d8             	movsbl %al,%ebx
  800927:	85 db                	test   %ebx,%ebx
  800929:	74 24                	je     80094f <vprintfmt+0x24b>
  80092b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80092f:	78 b8                	js     8008e9 <vprintfmt+0x1e5>
  800931:	ff 4d e0             	decl   -0x20(%ebp)
  800934:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800938:	79 af                	jns    8008e9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80093a:	eb 13                	jmp    80094f <vprintfmt+0x24b>
				putch(' ', putdat);
  80093c:	83 ec 08             	sub    $0x8,%esp
  80093f:	ff 75 0c             	pushl  0xc(%ebp)
  800942:	6a 20                	push   $0x20
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	ff d0                	call   *%eax
  800949:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80094c:	ff 4d e4             	decl   -0x1c(%ebp)
  80094f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800953:	7f e7                	jg     80093c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800955:	e9 78 01 00 00       	jmp    800ad2 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80095a:	83 ec 08             	sub    $0x8,%esp
  80095d:	ff 75 e8             	pushl  -0x18(%ebp)
  800960:	8d 45 14             	lea    0x14(%ebp),%eax
  800963:	50                   	push   %eax
  800964:	e8 3c fd ff ff       	call   8006a5 <getint>
  800969:	83 c4 10             	add    $0x10,%esp
  80096c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80096f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800972:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800975:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800978:	85 d2                	test   %edx,%edx
  80097a:	79 23                	jns    80099f <vprintfmt+0x29b>
				putch('-', putdat);
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	ff 75 0c             	pushl  0xc(%ebp)
  800982:	6a 2d                	push   $0x2d
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	ff d0                	call   *%eax
  800989:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80098c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80098f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800992:	f7 d8                	neg    %eax
  800994:	83 d2 00             	adc    $0x0,%edx
  800997:	f7 da                	neg    %edx
  800999:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80099f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009a6:	e9 bc 00 00 00       	jmp    800a67 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009ab:	83 ec 08             	sub    $0x8,%esp
  8009ae:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b1:	8d 45 14             	lea    0x14(%ebp),%eax
  8009b4:	50                   	push   %eax
  8009b5:	e8 84 fc ff ff       	call   80063e <getuint>
  8009ba:	83 c4 10             	add    $0x10,%esp
  8009bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009c3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009ca:	e9 98 00 00 00       	jmp    800a67 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009cf:	83 ec 08             	sub    $0x8,%esp
  8009d2:	ff 75 0c             	pushl  0xc(%ebp)
  8009d5:	6a 58                	push   $0x58
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	ff d0                	call   *%eax
  8009dc:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009df:	83 ec 08             	sub    $0x8,%esp
  8009e2:	ff 75 0c             	pushl  0xc(%ebp)
  8009e5:	6a 58                	push   $0x58
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	ff d0                	call   *%eax
  8009ec:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	ff 75 0c             	pushl  0xc(%ebp)
  8009f5:	6a 58                	push   $0x58
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	ff d0                	call   *%eax
  8009fc:	83 c4 10             	add    $0x10,%esp
			break;
  8009ff:	e9 ce 00 00 00       	jmp    800ad2 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a04:	83 ec 08             	sub    $0x8,%esp
  800a07:	ff 75 0c             	pushl  0xc(%ebp)
  800a0a:	6a 30                	push   $0x30
  800a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0f:	ff d0                	call   *%eax
  800a11:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a14:	83 ec 08             	sub    $0x8,%esp
  800a17:	ff 75 0c             	pushl  0xc(%ebp)
  800a1a:	6a 78                	push   $0x78
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	ff d0                	call   *%eax
  800a21:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a24:	8b 45 14             	mov    0x14(%ebp),%eax
  800a27:	83 c0 04             	add    $0x4,%eax
  800a2a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a30:	83 e8 04             	sub    $0x4,%eax
  800a33:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a3f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a46:	eb 1f                	jmp    800a67 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a48:	83 ec 08             	sub    $0x8,%esp
  800a4b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a4e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a51:	50                   	push   %eax
  800a52:	e8 e7 fb ff ff       	call   80063e <getuint>
  800a57:	83 c4 10             	add    $0x10,%esp
  800a5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a60:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a67:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a6e:	83 ec 04             	sub    $0x4,%esp
  800a71:	52                   	push   %edx
  800a72:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a75:	50                   	push   %eax
  800a76:	ff 75 f4             	pushl  -0xc(%ebp)
  800a79:	ff 75 f0             	pushl  -0x10(%ebp)
  800a7c:	ff 75 0c             	pushl  0xc(%ebp)
  800a7f:	ff 75 08             	pushl  0x8(%ebp)
  800a82:	e8 00 fb ff ff       	call   800587 <printnum>
  800a87:	83 c4 20             	add    $0x20,%esp
			break;
  800a8a:	eb 46                	jmp    800ad2 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a8c:	83 ec 08             	sub    $0x8,%esp
  800a8f:	ff 75 0c             	pushl  0xc(%ebp)
  800a92:	53                   	push   %ebx
  800a93:	8b 45 08             	mov    0x8(%ebp),%eax
  800a96:	ff d0                	call   *%eax
  800a98:	83 c4 10             	add    $0x10,%esp
			break;
  800a9b:	eb 35                	jmp    800ad2 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800a9d:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800aa4:	eb 2c                	jmp    800ad2 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800aa6:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800aad:	eb 23                	jmp    800ad2 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aaf:	83 ec 08             	sub    $0x8,%esp
  800ab2:	ff 75 0c             	pushl  0xc(%ebp)
  800ab5:	6a 25                	push   $0x25
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	ff d0                	call   *%eax
  800abc:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800abf:	ff 4d 10             	decl   0x10(%ebp)
  800ac2:	eb 03                	jmp    800ac7 <vprintfmt+0x3c3>
  800ac4:	ff 4d 10             	decl   0x10(%ebp)
  800ac7:	8b 45 10             	mov    0x10(%ebp),%eax
  800aca:	48                   	dec    %eax
  800acb:	8a 00                	mov    (%eax),%al
  800acd:	3c 25                	cmp    $0x25,%al
  800acf:	75 f3                	jne    800ac4 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ad1:	90                   	nop
		}
	}
  800ad2:	e9 35 fc ff ff       	jmp    80070c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ad7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ad8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800adb:	5b                   	pop    %ebx
  800adc:	5e                   	pop    %esi
  800add:	5d                   	pop    %ebp
  800ade:	c3                   	ret    

00800adf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800adf:	55                   	push   %ebp
  800ae0:	89 e5                	mov    %esp,%ebp
  800ae2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ae5:	8d 45 10             	lea    0x10(%ebp),%eax
  800ae8:	83 c0 04             	add    $0x4,%eax
  800aeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800aee:	8b 45 10             	mov    0x10(%ebp),%eax
  800af1:	ff 75 f4             	pushl  -0xc(%ebp)
  800af4:	50                   	push   %eax
  800af5:	ff 75 0c             	pushl  0xc(%ebp)
  800af8:	ff 75 08             	pushl  0x8(%ebp)
  800afb:	e8 04 fc ff ff       	call   800704 <vprintfmt>
  800b00:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b03:	90                   	nop
  800b04:	c9                   	leave  
  800b05:	c3                   	ret    

00800b06 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0c:	8b 40 08             	mov    0x8(%eax),%eax
  800b0f:	8d 50 01             	lea    0x1(%eax),%edx
  800b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b15:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1b:	8b 10                	mov    (%eax),%edx
  800b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b20:	8b 40 04             	mov    0x4(%eax),%eax
  800b23:	39 c2                	cmp    %eax,%edx
  800b25:	73 12                	jae    800b39 <sprintputch+0x33>
		*b->buf++ = ch;
  800b27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2a:	8b 00                	mov    (%eax),%eax
  800b2c:	8d 48 01             	lea    0x1(%eax),%ecx
  800b2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b32:	89 0a                	mov    %ecx,(%edx)
  800b34:	8b 55 08             	mov    0x8(%ebp),%edx
  800b37:	88 10                	mov    %dl,(%eax)
}
  800b39:	90                   	nop
  800b3a:	5d                   	pop    %ebp
  800b3b:	c3                   	ret    

00800b3c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b42:	8b 45 08             	mov    0x8(%ebp),%eax
  800b45:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b51:	01 d0                	add    %edx,%eax
  800b53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b5d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b61:	74 06                	je     800b69 <vsnprintf+0x2d>
  800b63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b67:	7f 07                	jg     800b70 <vsnprintf+0x34>
		return -E_INVAL;
  800b69:	b8 03 00 00 00       	mov    $0x3,%eax
  800b6e:	eb 20                	jmp    800b90 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b70:	ff 75 14             	pushl  0x14(%ebp)
  800b73:	ff 75 10             	pushl  0x10(%ebp)
  800b76:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b79:	50                   	push   %eax
  800b7a:	68 06 0b 80 00       	push   $0x800b06
  800b7f:	e8 80 fb ff ff       	call   800704 <vprintfmt>
  800b84:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b8a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b90:	c9                   	leave  
  800b91:	c3                   	ret    

00800b92 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
  800b95:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b98:	8d 45 10             	lea    0x10(%ebp),%eax
  800b9b:	83 c0 04             	add    $0x4,%eax
  800b9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ba1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba7:	50                   	push   %eax
  800ba8:	ff 75 0c             	pushl  0xc(%ebp)
  800bab:	ff 75 08             	pushl  0x8(%ebp)
  800bae:	e8 89 ff ff ff       	call   800b3c <vsnprintf>
  800bb3:	83 c4 10             	add    $0x10,%esp
  800bb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bbc:	c9                   	leave  
  800bbd:	c3                   	ret    

00800bbe <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bcb:	eb 06                	jmp    800bd3 <strlen+0x15>
		n++;
  800bcd:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd0:	ff 45 08             	incl   0x8(%ebp)
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	8a 00                	mov    (%eax),%al
  800bd8:	84 c0                	test   %al,%al
  800bda:	75 f1                	jne    800bcd <strlen+0xf>
		n++;
	return n;
  800bdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bdf:	c9                   	leave  
  800be0:	c3                   	ret    

00800be1 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bee:	eb 09                	jmp    800bf9 <strnlen+0x18>
		n++;
  800bf0:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bf3:	ff 45 08             	incl   0x8(%ebp)
  800bf6:	ff 4d 0c             	decl   0xc(%ebp)
  800bf9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bfd:	74 09                	je     800c08 <strnlen+0x27>
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	8a 00                	mov    (%eax),%al
  800c04:	84 c0                	test   %al,%al
  800c06:	75 e8                	jne    800bf0 <strnlen+0xf>
		n++;
	return n;
  800c08:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0b:	c9                   	leave  
  800c0c:	c3                   	ret    

00800c0d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c19:	90                   	nop
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1d:	8d 50 01             	lea    0x1(%eax),%edx
  800c20:	89 55 08             	mov    %edx,0x8(%ebp)
  800c23:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c26:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c29:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c2c:	8a 12                	mov    (%edx),%dl
  800c2e:	88 10                	mov    %dl,(%eax)
  800c30:	8a 00                	mov    (%eax),%al
  800c32:	84 c0                	test   %al,%al
  800c34:	75 e4                	jne    800c1a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c39:	c9                   	leave  
  800c3a:	c3                   	ret    

00800c3b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c47:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c4e:	eb 1f                	jmp    800c6f <strncpy+0x34>
		*dst++ = *src;
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	8d 50 01             	lea    0x1(%eax),%edx
  800c56:	89 55 08             	mov    %edx,0x8(%ebp)
  800c59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5c:	8a 12                	mov    (%edx),%dl
  800c5e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	84 c0                	test   %al,%al
  800c67:	74 03                	je     800c6c <strncpy+0x31>
			src++;
  800c69:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c6c:	ff 45 fc             	incl   -0x4(%ebp)
  800c6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c72:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c75:	72 d9                	jb     800c50 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c77:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c7a:	c9                   	leave  
  800c7b:	c3                   	ret    

00800c7c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c7c:	55                   	push   %ebp
  800c7d:	89 e5                	mov    %esp,%ebp
  800c7f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c88:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c8c:	74 30                	je     800cbe <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c8e:	eb 16                	jmp    800ca6 <strlcpy+0x2a>
			*dst++ = *src++;
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8d 50 01             	lea    0x1(%eax),%edx
  800c96:	89 55 08             	mov    %edx,0x8(%ebp)
  800c99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c9f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ca2:	8a 12                	mov    (%edx),%dl
  800ca4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ca6:	ff 4d 10             	decl   0x10(%ebp)
  800ca9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cad:	74 09                	je     800cb8 <strlcpy+0x3c>
  800caf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb2:	8a 00                	mov    (%eax),%al
  800cb4:	84 c0                	test   %al,%al
  800cb6:	75 d8                	jne    800c90 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc4:	29 c2                	sub    %eax,%edx
  800cc6:	89 d0                	mov    %edx,%eax
}
  800cc8:	c9                   	leave  
  800cc9:	c3                   	ret    

00800cca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ccd:	eb 06                	jmp    800cd5 <strcmp+0xb>
		p++, q++;
  800ccf:	ff 45 08             	incl   0x8(%ebp)
  800cd2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8a 00                	mov    (%eax),%al
  800cda:	84 c0                	test   %al,%al
  800cdc:	74 0e                	je     800cec <strcmp+0x22>
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	8a 10                	mov    (%eax),%dl
  800ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce6:	8a 00                	mov    (%eax),%al
  800ce8:	38 c2                	cmp    %al,%dl
  800cea:	74 e3                	je     800ccf <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	8a 00                	mov    (%eax),%al
  800cf1:	0f b6 d0             	movzbl %al,%edx
  800cf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf7:	8a 00                	mov    (%eax),%al
  800cf9:	0f b6 c0             	movzbl %al,%eax
  800cfc:	29 c2                	sub    %eax,%edx
  800cfe:	89 d0                	mov    %edx,%eax
}
  800d00:	5d                   	pop    %ebp
  800d01:	c3                   	ret    

00800d02 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d05:	eb 09                	jmp    800d10 <strncmp+0xe>
		n--, p++, q++;
  800d07:	ff 4d 10             	decl   0x10(%ebp)
  800d0a:	ff 45 08             	incl   0x8(%ebp)
  800d0d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d10:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d14:	74 17                	je     800d2d <strncmp+0x2b>
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	84 c0                	test   %al,%al
  800d1d:	74 0e                	je     800d2d <strncmp+0x2b>
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8a 10                	mov    (%eax),%dl
  800d24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d27:	8a 00                	mov    (%eax),%al
  800d29:	38 c2                	cmp    %al,%dl
  800d2b:	74 da                	je     800d07 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d2d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d31:	75 07                	jne    800d3a <strncmp+0x38>
		return 0;
  800d33:	b8 00 00 00 00       	mov    $0x0,%eax
  800d38:	eb 14                	jmp    800d4e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3d:	8a 00                	mov    (%eax),%al
  800d3f:	0f b6 d0             	movzbl %al,%edx
  800d42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	0f b6 c0             	movzbl %al,%eax
  800d4a:	29 c2                	sub    %eax,%edx
  800d4c:	89 d0                	mov    %edx,%eax
}
  800d4e:	5d                   	pop    %ebp
  800d4f:	c3                   	ret    

00800d50 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	83 ec 04             	sub    $0x4,%esp
  800d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d59:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d5c:	eb 12                	jmp    800d70 <strchr+0x20>
		if (*s == c)
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	8a 00                	mov    (%eax),%al
  800d63:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d66:	75 05                	jne    800d6d <strchr+0x1d>
			return (char *) s;
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	eb 11                	jmp    800d7e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d6d:	ff 45 08             	incl   0x8(%ebp)
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	84 c0                	test   %al,%al
  800d77:	75 e5                	jne    800d5e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d7e:	c9                   	leave  
  800d7f:	c3                   	ret    

00800d80 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	83 ec 04             	sub    $0x4,%esp
  800d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d89:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d8c:	eb 0d                	jmp    800d9b <strfind+0x1b>
		if (*s == c)
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	8a 00                	mov    (%eax),%al
  800d93:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d96:	74 0e                	je     800da6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d98:	ff 45 08             	incl   0x8(%ebp)
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	8a 00                	mov    (%eax),%al
  800da0:	84 c0                	test   %al,%al
  800da2:	75 ea                	jne    800d8e <strfind+0xe>
  800da4:	eb 01                	jmp    800da7 <strfind+0x27>
		if (*s == c)
			break;
  800da6:	90                   	nop
	return (char *) s;
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800daa:	c9                   	leave  
  800dab:	c3                   	ret    

00800dac <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
  800db5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800db8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800dbc:	76 63                	jbe    800e21 <memset+0x75>
		uint64 data_block = c;
  800dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc1:	99                   	cltd   
  800dc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc5:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dcb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dce:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800dd2:	c1 e0 08             	shl    $0x8,%eax
  800dd5:	09 45 f0             	or     %eax,-0x10(%ebp)
  800dd8:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ddb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800de1:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800de5:	c1 e0 10             	shl    $0x10,%eax
  800de8:	09 45 f0             	or     %eax,-0x10(%ebp)
  800deb:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800df1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800df4:	89 c2                	mov    %eax,%edx
  800df6:	b8 00 00 00 00       	mov    $0x0,%eax
  800dfb:	09 45 f0             	or     %eax,-0x10(%ebp)
  800dfe:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e01:	eb 18                	jmp    800e1b <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e03:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e06:	8d 41 08             	lea    0x8(%ecx),%eax
  800e09:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e12:	89 01                	mov    %eax,(%ecx)
  800e14:	89 51 04             	mov    %edx,0x4(%ecx)
  800e17:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e1b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e1f:	77 e2                	ja     800e03 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e21:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e25:	74 23                	je     800e4a <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e27:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e2d:	eb 0e                	jmp    800e3d <memset+0x91>
			*p8++ = (uint8)c;
  800e2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e32:	8d 50 01             	lea    0x1(%eax),%edx
  800e35:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3b:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e40:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e43:	89 55 10             	mov    %edx,0x10(%ebp)
  800e46:	85 c0                	test   %eax,%eax
  800e48:	75 e5                	jne    800e2f <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4d:	c9                   	leave  
  800e4e:	c3                   	ret    

00800e4f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800e55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800e61:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e65:	76 24                	jbe    800e8b <memcpy+0x3c>
		while(n >= 8){
  800e67:	eb 1c                	jmp    800e85 <memcpy+0x36>
			*d64 = *s64;
  800e69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e6c:	8b 50 04             	mov    0x4(%eax),%edx
  800e6f:	8b 00                	mov    (%eax),%eax
  800e71:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800e74:	89 01                	mov    %eax,(%ecx)
  800e76:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800e79:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800e7d:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800e81:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800e85:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e89:	77 de                	ja     800e69 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800e8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8f:	74 31                	je     800ec2 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800e91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e94:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800e97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800e9d:	eb 16                	jmp    800eb5 <memcpy+0x66>
			*d8++ = *s8++;
  800e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea2:	8d 50 01             	lea    0x1(%eax),%edx
  800ea5:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800ea8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eab:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eae:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800eb1:	8a 12                	mov    (%edx),%dl
  800eb3:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800eb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebb:	89 55 10             	mov    %edx,0x10(%ebp)
  800ebe:	85 c0                	test   %eax,%eax
  800ec0:	75 dd                	jne    800e9f <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec5:	c9                   	leave  
  800ec6:	c3                   	ret    

00800ec7 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ed9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800edc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800edf:	73 50                	jae    800f31 <memmove+0x6a>
  800ee1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ee4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee7:	01 d0                	add    %edx,%eax
  800ee9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eec:	76 43                	jbe    800f31 <memmove+0x6a>
		s += n;
  800eee:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ef4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800efa:	eb 10                	jmp    800f0c <memmove+0x45>
			*--d = *--s;
  800efc:	ff 4d f8             	decl   -0x8(%ebp)
  800eff:	ff 4d fc             	decl   -0x4(%ebp)
  800f02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f05:	8a 10                	mov    (%eax),%dl
  800f07:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f0c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f12:	89 55 10             	mov    %edx,0x10(%ebp)
  800f15:	85 c0                	test   %eax,%eax
  800f17:	75 e3                	jne    800efc <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f19:	eb 23                	jmp    800f3e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1e:	8d 50 01             	lea    0x1(%eax),%edx
  800f21:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f24:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f27:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f2a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f2d:	8a 12                	mov    (%edx),%dl
  800f2f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f31:	8b 45 10             	mov    0x10(%ebp),%eax
  800f34:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f37:	89 55 10             	mov    %edx,0x10(%ebp)
  800f3a:	85 c0                	test   %eax,%eax
  800f3c:	75 dd                	jne    800f1b <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f41:	c9                   	leave  
  800f42:	c3                   	ret    

00800f43 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f52:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f55:	eb 2a                	jmp    800f81 <memcmp+0x3e>
		if (*s1 != *s2)
  800f57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5a:	8a 10                	mov    (%eax),%dl
  800f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5f:	8a 00                	mov    (%eax),%al
  800f61:	38 c2                	cmp    %al,%dl
  800f63:	74 16                	je     800f7b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	0f b6 d0             	movzbl %al,%edx
  800f6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	0f b6 c0             	movzbl %al,%eax
  800f75:	29 c2                	sub    %eax,%edx
  800f77:	89 d0                	mov    %edx,%eax
  800f79:	eb 18                	jmp    800f93 <memcmp+0x50>
		s1++, s2++;
  800f7b:	ff 45 fc             	incl   -0x4(%ebp)
  800f7e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f81:	8b 45 10             	mov    0x10(%ebp),%eax
  800f84:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f87:	89 55 10             	mov    %edx,0x10(%ebp)
  800f8a:	85 c0                	test   %eax,%eax
  800f8c:	75 c9                	jne    800f57 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f93:	c9                   	leave  
  800f94:	c3                   	ret    

00800f95 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa1:	01 d0                	add    %edx,%eax
  800fa3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fa6:	eb 15                	jmp    800fbd <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	8a 00                	mov    (%eax),%al
  800fad:	0f b6 d0             	movzbl %al,%edx
  800fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb3:	0f b6 c0             	movzbl %al,%eax
  800fb6:	39 c2                	cmp    %eax,%edx
  800fb8:	74 0d                	je     800fc7 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fba:	ff 45 08             	incl   0x8(%ebp)
  800fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fc3:	72 e3                	jb     800fa8 <memfind+0x13>
  800fc5:	eb 01                	jmp    800fc8 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fc7:	90                   	nop
	return (void *) s;
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fcb:	c9                   	leave  
  800fcc:	c3                   	ret    

00800fcd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
  800fd0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fd3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fda:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fe1:	eb 03                	jmp    800fe6 <strtol+0x19>
		s++;
  800fe3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	3c 20                	cmp    $0x20,%al
  800fed:	74 f4                	je     800fe3 <strtol+0x16>
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	3c 09                	cmp    $0x9,%al
  800ff6:	74 eb                	je     800fe3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	8a 00                	mov    (%eax),%al
  800ffd:	3c 2b                	cmp    $0x2b,%al
  800fff:	75 05                	jne    801006 <strtol+0x39>
		s++;
  801001:	ff 45 08             	incl   0x8(%ebp)
  801004:	eb 13                	jmp    801019 <strtol+0x4c>
	else if (*s == '-')
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	8a 00                	mov    (%eax),%al
  80100b:	3c 2d                	cmp    $0x2d,%al
  80100d:	75 0a                	jne    801019 <strtol+0x4c>
		s++, neg = 1;
  80100f:	ff 45 08             	incl   0x8(%ebp)
  801012:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801019:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80101d:	74 06                	je     801025 <strtol+0x58>
  80101f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801023:	75 20                	jne    801045 <strtol+0x78>
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	8a 00                	mov    (%eax),%al
  80102a:	3c 30                	cmp    $0x30,%al
  80102c:	75 17                	jne    801045 <strtol+0x78>
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	40                   	inc    %eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	3c 78                	cmp    $0x78,%al
  801036:	75 0d                	jne    801045 <strtol+0x78>
		s += 2, base = 16;
  801038:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80103c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801043:	eb 28                	jmp    80106d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801045:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801049:	75 15                	jne    801060 <strtol+0x93>
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	3c 30                	cmp    $0x30,%al
  801052:	75 0c                	jne    801060 <strtol+0x93>
		s++, base = 8;
  801054:	ff 45 08             	incl   0x8(%ebp)
  801057:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80105e:	eb 0d                	jmp    80106d <strtol+0xa0>
	else if (base == 0)
  801060:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801064:	75 07                	jne    80106d <strtol+0xa0>
		base = 10;
  801066:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	3c 2f                	cmp    $0x2f,%al
  801074:	7e 19                	jle    80108f <strtol+0xc2>
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	3c 39                	cmp    $0x39,%al
  80107d:	7f 10                	jg     80108f <strtol+0xc2>
			dig = *s - '0';
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	8a 00                	mov    (%eax),%al
  801084:	0f be c0             	movsbl %al,%eax
  801087:	83 e8 30             	sub    $0x30,%eax
  80108a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80108d:	eb 42                	jmp    8010d1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	8a 00                	mov    (%eax),%al
  801094:	3c 60                	cmp    $0x60,%al
  801096:	7e 19                	jle    8010b1 <strtol+0xe4>
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	3c 7a                	cmp    $0x7a,%al
  80109f:	7f 10                	jg     8010b1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	8a 00                	mov    (%eax),%al
  8010a6:	0f be c0             	movsbl %al,%eax
  8010a9:	83 e8 57             	sub    $0x57,%eax
  8010ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010af:	eb 20                	jmp    8010d1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	8a 00                	mov    (%eax),%al
  8010b6:	3c 40                	cmp    $0x40,%al
  8010b8:	7e 39                	jle    8010f3 <strtol+0x126>
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	8a 00                	mov    (%eax),%al
  8010bf:	3c 5a                	cmp    $0x5a,%al
  8010c1:	7f 30                	jg     8010f3 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	0f be c0             	movsbl %al,%eax
  8010cb:	83 e8 37             	sub    $0x37,%eax
  8010ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010d7:	7d 19                	jge    8010f2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010d9:	ff 45 08             	incl   0x8(%ebp)
  8010dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010df:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010e3:	89 c2                	mov    %eax,%edx
  8010e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e8:	01 d0                	add    %edx,%eax
  8010ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010ed:	e9 7b ff ff ff       	jmp    80106d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010f2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010f7:	74 08                	je     801101 <strtol+0x134>
		*endptr = (char *) s;
  8010f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ff:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801101:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801105:	74 07                	je     80110e <strtol+0x141>
  801107:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110a:	f7 d8                	neg    %eax
  80110c:	eb 03                	jmp    801111 <strtol+0x144>
  80110e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801111:	c9                   	leave  
  801112:	c3                   	ret    

00801113 <ltostr>:

void
ltostr(long value, char *str)
{
  801113:	55                   	push   %ebp
  801114:	89 e5                	mov    %esp,%ebp
  801116:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801119:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801120:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801127:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80112b:	79 13                	jns    801140 <ltostr+0x2d>
	{
		neg = 1;
  80112d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801134:	8b 45 0c             	mov    0xc(%ebp),%eax
  801137:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80113a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80113d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
  801143:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801148:	99                   	cltd   
  801149:	f7 f9                	idiv   %ecx
  80114b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80114e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801151:	8d 50 01             	lea    0x1(%eax),%edx
  801154:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801157:	89 c2                	mov    %eax,%edx
  801159:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115c:	01 d0                	add    %edx,%eax
  80115e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801161:	83 c2 30             	add    $0x30,%edx
  801164:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801166:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801169:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80116e:	f7 e9                	imul   %ecx
  801170:	c1 fa 02             	sar    $0x2,%edx
  801173:	89 c8                	mov    %ecx,%eax
  801175:	c1 f8 1f             	sar    $0x1f,%eax
  801178:	29 c2                	sub    %eax,%edx
  80117a:	89 d0                	mov    %edx,%eax
  80117c:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80117f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801183:	75 bb                	jne    801140 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801185:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80118c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118f:	48                   	dec    %eax
  801190:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801193:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801197:	74 3d                	je     8011d6 <ltostr+0xc3>
		start = 1 ;
  801199:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011a0:	eb 34                	jmp    8011d6 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8011a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a8:	01 d0                	add    %edx,%eax
  8011aa:	8a 00                	mov    (%eax),%al
  8011ac:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b5:	01 c2                	add    %eax,%edx
  8011b7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bd:	01 c8                	add    %ecx,%eax
  8011bf:	8a 00                	mov    (%eax),%al
  8011c1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c9:	01 c2                	add    %eax,%edx
  8011cb:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011ce:	88 02                	mov    %al,(%edx)
		start++ ;
  8011d0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011d3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011dc:	7c c4                	jl     8011a2 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011de:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e4:	01 d0                	add    %edx,%eax
  8011e6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011e9:	90                   	nop
  8011ea:	c9                   	leave  
  8011eb:	c3                   	ret    

008011ec <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011ec:	55                   	push   %ebp
  8011ed:	89 e5                	mov    %esp,%ebp
  8011ef:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011f2:	ff 75 08             	pushl  0x8(%ebp)
  8011f5:	e8 c4 f9 ff ff       	call   800bbe <strlen>
  8011fa:	83 c4 04             	add    $0x4,%esp
  8011fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801200:	ff 75 0c             	pushl  0xc(%ebp)
  801203:	e8 b6 f9 ff ff       	call   800bbe <strlen>
  801208:	83 c4 04             	add    $0x4,%esp
  80120b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80120e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801215:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80121c:	eb 17                	jmp    801235 <strcconcat+0x49>
		final[s] = str1[s] ;
  80121e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801221:	8b 45 10             	mov    0x10(%ebp),%eax
  801224:	01 c2                	add    %eax,%edx
  801226:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	01 c8                	add    %ecx,%eax
  80122e:	8a 00                	mov    (%eax),%al
  801230:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801232:	ff 45 fc             	incl   -0x4(%ebp)
  801235:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801238:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80123b:	7c e1                	jl     80121e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80123d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801244:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80124b:	eb 1f                	jmp    80126c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80124d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801250:	8d 50 01             	lea    0x1(%eax),%edx
  801253:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801256:	89 c2                	mov    %eax,%edx
  801258:	8b 45 10             	mov    0x10(%ebp),%eax
  80125b:	01 c2                	add    %eax,%edx
  80125d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801260:	8b 45 0c             	mov    0xc(%ebp),%eax
  801263:	01 c8                	add    %ecx,%eax
  801265:	8a 00                	mov    (%eax),%al
  801267:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801269:	ff 45 f8             	incl   -0x8(%ebp)
  80126c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801272:	7c d9                	jl     80124d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801274:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801277:	8b 45 10             	mov    0x10(%ebp),%eax
  80127a:	01 d0                	add    %edx,%eax
  80127c:	c6 00 00             	movb   $0x0,(%eax)
}
  80127f:	90                   	nop
  801280:	c9                   	leave  
  801281:	c3                   	ret    

00801282 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801282:	55                   	push   %ebp
  801283:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801285:	8b 45 14             	mov    0x14(%ebp),%eax
  801288:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80128e:	8b 45 14             	mov    0x14(%ebp),%eax
  801291:	8b 00                	mov    (%eax),%eax
  801293:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129a:	8b 45 10             	mov    0x10(%ebp),%eax
  80129d:	01 d0                	add    %edx,%eax
  80129f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012a5:	eb 0c                	jmp    8012b3 <strsplit+0x31>
			*string++ = 0;
  8012a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012aa:	8d 50 01             	lea    0x1(%eax),%edx
  8012ad:	89 55 08             	mov    %edx,0x8(%ebp)
  8012b0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b6:	8a 00                	mov    (%eax),%al
  8012b8:	84 c0                	test   %al,%al
  8012ba:	74 18                	je     8012d4 <strsplit+0x52>
  8012bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bf:	8a 00                	mov    (%eax),%al
  8012c1:	0f be c0             	movsbl %al,%eax
  8012c4:	50                   	push   %eax
  8012c5:	ff 75 0c             	pushl  0xc(%ebp)
  8012c8:	e8 83 fa ff ff       	call   800d50 <strchr>
  8012cd:	83 c4 08             	add    $0x8,%esp
  8012d0:	85 c0                	test   %eax,%eax
  8012d2:	75 d3                	jne    8012a7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	8a 00                	mov    (%eax),%al
  8012d9:	84 c0                	test   %al,%al
  8012db:	74 5a                	je     801337 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e0:	8b 00                	mov    (%eax),%eax
  8012e2:	83 f8 0f             	cmp    $0xf,%eax
  8012e5:	75 07                	jne    8012ee <strsplit+0x6c>
		{
			return 0;
  8012e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ec:	eb 66                	jmp    801354 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f1:	8b 00                	mov    (%eax),%eax
  8012f3:	8d 48 01             	lea    0x1(%eax),%ecx
  8012f6:	8b 55 14             	mov    0x14(%ebp),%edx
  8012f9:	89 0a                	mov    %ecx,(%edx)
  8012fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801302:	8b 45 10             	mov    0x10(%ebp),%eax
  801305:	01 c2                	add    %eax,%edx
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80130c:	eb 03                	jmp    801311 <strsplit+0x8f>
			string++;
  80130e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	8a 00                	mov    (%eax),%al
  801316:	84 c0                	test   %al,%al
  801318:	74 8b                	je     8012a5 <strsplit+0x23>
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	8a 00                	mov    (%eax),%al
  80131f:	0f be c0             	movsbl %al,%eax
  801322:	50                   	push   %eax
  801323:	ff 75 0c             	pushl  0xc(%ebp)
  801326:	e8 25 fa ff ff       	call   800d50 <strchr>
  80132b:	83 c4 08             	add    $0x8,%esp
  80132e:	85 c0                	test   %eax,%eax
  801330:	74 dc                	je     80130e <strsplit+0x8c>
			string++;
	}
  801332:	e9 6e ff ff ff       	jmp    8012a5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801337:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801338:	8b 45 14             	mov    0x14(%ebp),%eax
  80133b:	8b 00                	mov    (%eax),%eax
  80133d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801344:	8b 45 10             	mov    0x10(%ebp),%eax
  801347:	01 d0                	add    %edx,%eax
  801349:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80134f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801354:	c9                   	leave  
  801355:	c3                   	ret    

00801356 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
  801359:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801362:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801369:	eb 4a                	jmp    8013b5 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80136b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
  801371:	01 c2                	add    %eax,%edx
  801373:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801376:	8b 45 0c             	mov    0xc(%ebp),%eax
  801379:	01 c8                	add    %ecx,%eax
  80137b:	8a 00                	mov    (%eax),%al
  80137d:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80137f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801382:	8b 45 0c             	mov    0xc(%ebp),%eax
  801385:	01 d0                	add    %edx,%eax
  801387:	8a 00                	mov    (%eax),%al
  801389:	3c 40                	cmp    $0x40,%al
  80138b:	7e 25                	jle    8013b2 <str2lower+0x5c>
  80138d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801390:	8b 45 0c             	mov    0xc(%ebp),%eax
  801393:	01 d0                	add    %edx,%eax
  801395:	8a 00                	mov    (%eax),%al
  801397:	3c 5a                	cmp    $0x5a,%al
  801399:	7f 17                	jg     8013b2 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80139b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	01 d0                	add    %edx,%eax
  8013a3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a9:	01 ca                	add    %ecx,%edx
  8013ab:	8a 12                	mov    (%edx),%dl
  8013ad:	83 c2 20             	add    $0x20,%edx
  8013b0:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8013b2:	ff 45 fc             	incl   -0x4(%ebp)
  8013b5:	ff 75 0c             	pushl  0xc(%ebp)
  8013b8:	e8 01 f8 ff ff       	call   800bbe <strlen>
  8013bd:	83 c4 04             	add    $0x4,%esp
  8013c0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013c3:	7f a6                	jg     80136b <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8013c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013c8:	c9                   	leave  
  8013c9:	c3                   	ret    

008013ca <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8013ca:	55                   	push   %ebp
  8013cb:	89 e5                	mov    %esp,%ebp
  8013cd:	57                   	push   %edi
  8013ce:	56                   	push   %esi
  8013cf:	53                   	push   %ebx
  8013d0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013dc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013df:	8b 7d 18             	mov    0x18(%ebp),%edi
  8013e2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8013e5:	cd 30                	int    $0x30
  8013e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8013ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013ed:	83 c4 10             	add    $0x10,%esp
  8013f0:	5b                   	pop    %ebx
  8013f1:	5e                   	pop    %esi
  8013f2:	5f                   	pop    %edi
  8013f3:	5d                   	pop    %ebp
  8013f4:	c3                   	ret    

008013f5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8013f5:	55                   	push   %ebp
  8013f6:	89 e5                	mov    %esp,%ebp
  8013f8:	83 ec 04             	sub    $0x4,%esp
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801401:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801404:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	6a 00                	push   $0x0
  80140d:	51                   	push   %ecx
  80140e:	52                   	push   %edx
  80140f:	ff 75 0c             	pushl  0xc(%ebp)
  801412:	50                   	push   %eax
  801413:	6a 00                	push   $0x0
  801415:	e8 b0 ff ff ff       	call   8013ca <syscall>
  80141a:	83 c4 18             	add    $0x18,%esp
}
  80141d:	90                   	nop
  80141e:	c9                   	leave  
  80141f:	c3                   	ret    

00801420 <sys_cgetc>:

int
sys_cgetc(void)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801423:	6a 00                	push   $0x0
  801425:	6a 00                	push   $0x0
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	6a 02                	push   $0x2
  80142f:	e8 96 ff ff ff       	call   8013ca <syscall>
  801434:	83 c4 18             	add    $0x18,%esp
}
  801437:	c9                   	leave  
  801438:	c3                   	ret    

00801439 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80143c:	6a 00                	push   $0x0
  80143e:	6a 00                	push   $0x0
  801440:	6a 00                	push   $0x0
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	6a 03                	push   $0x3
  801448:	e8 7d ff ff ff       	call   8013ca <syscall>
  80144d:	83 c4 18             	add    $0x18,%esp
}
  801450:	90                   	nop
  801451:	c9                   	leave  
  801452:	c3                   	ret    

00801453 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	6a 00                	push   $0x0
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	6a 04                	push   $0x4
  801462:	e8 63 ff ff ff       	call   8013ca <syscall>
  801467:	83 c4 18             	add    $0x18,%esp
}
  80146a:	90                   	nop
  80146b:	c9                   	leave  
  80146c:	c3                   	ret    

0080146d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801470:	8b 55 0c             	mov    0xc(%ebp),%edx
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	6a 00                	push   $0x0
  801478:	6a 00                	push   $0x0
  80147a:	6a 00                	push   $0x0
  80147c:	52                   	push   %edx
  80147d:	50                   	push   %eax
  80147e:	6a 08                	push   $0x8
  801480:	e8 45 ff ff ff       	call   8013ca <syscall>
  801485:	83 c4 18             	add    $0x18,%esp
}
  801488:	c9                   	leave  
  801489:	c3                   	ret    

0080148a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
  80148d:	56                   	push   %esi
  80148e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80148f:	8b 75 18             	mov    0x18(%ebp),%esi
  801492:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801495:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801498:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	56                   	push   %esi
  80149f:	53                   	push   %ebx
  8014a0:	51                   	push   %ecx
  8014a1:	52                   	push   %edx
  8014a2:	50                   	push   %eax
  8014a3:	6a 09                	push   $0x9
  8014a5:	e8 20 ff ff ff       	call   8013ca <syscall>
  8014aa:	83 c4 18             	add    $0x18,%esp
}
  8014ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014b0:	5b                   	pop    %ebx
  8014b1:	5e                   	pop    %esi
  8014b2:	5d                   	pop    %ebp
  8014b3:	c3                   	ret    

008014b4 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	ff 75 08             	pushl  0x8(%ebp)
  8014c2:	6a 0a                	push   $0xa
  8014c4:	e8 01 ff ff ff       	call   8013ca <syscall>
  8014c9:	83 c4 18             	add    $0x18,%esp
}
  8014cc:	c9                   	leave  
  8014cd:	c3                   	ret    

008014ce <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014ce:	55                   	push   %ebp
  8014cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	ff 75 0c             	pushl  0xc(%ebp)
  8014da:	ff 75 08             	pushl  0x8(%ebp)
  8014dd:	6a 0b                	push   $0xb
  8014df:	e8 e6 fe ff ff       	call   8013ca <syscall>
  8014e4:	83 c4 18             	add    $0x18,%esp
}
  8014e7:	c9                   	leave  
  8014e8:	c3                   	ret    

008014e9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 0c                	push   $0xc
  8014f8:	e8 cd fe ff ff       	call   8013ca <syscall>
  8014fd:	83 c4 18             	add    $0x18,%esp
}
  801500:	c9                   	leave  
  801501:	c3                   	ret    

00801502 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 0d                	push   $0xd
  801511:	e8 b4 fe ff ff       	call   8013ca <syscall>
  801516:	83 c4 18             	add    $0x18,%esp
}
  801519:	c9                   	leave  
  80151a:	c3                   	ret    

0080151b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80151b:	55                   	push   %ebp
  80151c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 0e                	push   $0xe
  80152a:	e8 9b fe ff ff       	call   8013ca <syscall>
  80152f:	83 c4 18             	add    $0x18,%esp
}
  801532:	c9                   	leave  
  801533:	c3                   	ret    

00801534 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 0f                	push   $0xf
  801543:	e8 82 fe ff ff       	call   8013ca <syscall>
  801548:	83 c4 18             	add    $0x18,%esp
}
  80154b:	c9                   	leave  
  80154c:	c3                   	ret    

0080154d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	ff 75 08             	pushl  0x8(%ebp)
  80155b:	6a 10                	push   $0x10
  80155d:	e8 68 fe ff ff       	call   8013ca <syscall>
  801562:	83 c4 18             	add    $0x18,%esp
}
  801565:	c9                   	leave  
  801566:	c3                   	ret    

00801567 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	6a 00                	push   $0x0
  801572:	6a 00                	push   $0x0
  801574:	6a 11                	push   $0x11
  801576:	e8 4f fe ff ff       	call   8013ca <syscall>
  80157b:	83 c4 18             	add    $0x18,%esp
}
  80157e:	90                   	nop
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <sys_cputc>:

void
sys_cputc(const char c)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	83 ec 04             	sub    $0x4,%esp
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80158d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	50                   	push   %eax
  80159a:	6a 01                	push   $0x1
  80159c:	e8 29 fe ff ff       	call   8013ca <syscall>
  8015a1:	83 c4 18             	add    $0x18,%esp
}
  8015a4:	90                   	nop
  8015a5:	c9                   	leave  
  8015a6:	c3                   	ret    

008015a7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 14                	push   $0x14
  8015b6:	e8 0f fe ff ff       	call   8013ca <syscall>
  8015bb:	83 c4 18             	add    $0x18,%esp
}
  8015be:	90                   	nop
  8015bf:	c9                   	leave  
  8015c0:	c3                   	ret    

008015c1 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
  8015c4:	83 ec 04             	sub    $0x4,%esp
  8015c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8015cd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015d0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d7:	6a 00                	push   $0x0
  8015d9:	51                   	push   %ecx
  8015da:	52                   	push   %edx
  8015db:	ff 75 0c             	pushl  0xc(%ebp)
  8015de:	50                   	push   %eax
  8015df:	6a 15                	push   $0x15
  8015e1:	e8 e4 fd ff ff       	call   8013ca <syscall>
  8015e6:	83 c4 18             	add    $0x18,%esp
}
  8015e9:	c9                   	leave  
  8015ea:	c3                   	ret    

008015eb <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8015ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	52                   	push   %edx
  8015fb:	50                   	push   %eax
  8015fc:	6a 16                	push   $0x16
  8015fe:	e8 c7 fd ff ff       	call   8013ca <syscall>
  801603:	83 c4 18             	add    $0x18,%esp
}
  801606:	c9                   	leave  
  801607:	c3                   	ret    

00801608 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80160b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80160e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801611:	8b 45 08             	mov    0x8(%ebp),%eax
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	51                   	push   %ecx
  801619:	52                   	push   %edx
  80161a:	50                   	push   %eax
  80161b:	6a 17                	push   $0x17
  80161d:	e8 a8 fd ff ff       	call   8013ca <syscall>
  801622:	83 c4 18             	add    $0x18,%esp
}
  801625:	c9                   	leave  
  801626:	c3                   	ret    

00801627 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80162a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	52                   	push   %edx
  801637:	50                   	push   %eax
  801638:	6a 18                	push   $0x18
  80163a:	e8 8b fd ff ff       	call   8013ca <syscall>
  80163f:	83 c4 18             	add    $0x18,%esp
}
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	6a 00                	push   $0x0
  80164c:	ff 75 14             	pushl  0x14(%ebp)
  80164f:	ff 75 10             	pushl  0x10(%ebp)
  801652:	ff 75 0c             	pushl  0xc(%ebp)
  801655:	50                   	push   %eax
  801656:	6a 19                	push   $0x19
  801658:	e8 6d fd ff ff       	call   8013ca <syscall>
  80165d:	83 c4 18             	add    $0x18,%esp
}
  801660:	c9                   	leave  
  801661:	c3                   	ret    

00801662 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	50                   	push   %eax
  801671:	6a 1a                	push   $0x1a
  801673:	e8 52 fd ff ff       	call   8013ca <syscall>
  801678:	83 c4 18             	add    $0x18,%esp
}
  80167b:	90                   	nop
  80167c:	c9                   	leave  
  80167d:	c3                   	ret    

0080167e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	50                   	push   %eax
  80168d:	6a 1b                	push   $0x1b
  80168f:	e8 36 fd ff ff       	call   8013ca <syscall>
  801694:	83 c4 18             	add    $0x18,%esp
}
  801697:	c9                   	leave  
  801698:	c3                   	ret    

00801699 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 05                	push   $0x5
  8016a8:	e8 1d fd ff ff       	call   8013ca <syscall>
  8016ad:	83 c4 18             	add    $0x18,%esp
}
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    

008016b2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 06                	push   $0x6
  8016c1:	e8 04 fd ff ff       	call   8013ca <syscall>
  8016c6:	83 c4 18             	add    $0x18,%esp
}
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 07                	push   $0x7
  8016da:	e8 eb fc ff ff       	call   8013ca <syscall>
  8016df:	83 c4 18             	add    $0x18,%esp
}
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <sys_exit_env>:


void sys_exit_env(void)
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 1c                	push   $0x1c
  8016f3:	e8 d2 fc ff ff       	call   8013ca <syscall>
  8016f8:	83 c4 18             	add    $0x18,%esp
}
  8016fb:	90                   	nop
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801704:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801707:	8d 50 04             	lea    0x4(%eax),%edx
  80170a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	52                   	push   %edx
  801714:	50                   	push   %eax
  801715:	6a 1d                	push   $0x1d
  801717:	e8 ae fc ff ff       	call   8013ca <syscall>
  80171c:	83 c4 18             	add    $0x18,%esp
	return result;
  80171f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801722:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801725:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801728:	89 01                	mov    %eax,(%ecx)
  80172a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80172d:	8b 45 08             	mov    0x8(%ebp),%eax
  801730:	c9                   	leave  
  801731:	c2 04 00             	ret    $0x4

00801734 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	ff 75 10             	pushl  0x10(%ebp)
  80173e:	ff 75 0c             	pushl  0xc(%ebp)
  801741:	ff 75 08             	pushl  0x8(%ebp)
  801744:	6a 13                	push   $0x13
  801746:	e8 7f fc ff ff       	call   8013ca <syscall>
  80174b:	83 c4 18             	add    $0x18,%esp
	return ;
  80174e:	90                   	nop
}
  80174f:	c9                   	leave  
  801750:	c3                   	ret    

00801751 <sys_rcr2>:
uint32 sys_rcr2()
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 1e                	push   $0x1e
  801760:	e8 65 fc ff ff       	call   8013ca <syscall>
  801765:	83 c4 18             	add    $0x18,%esp
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
  80176d:	83 ec 04             	sub    $0x4,%esp
  801770:	8b 45 08             	mov    0x8(%ebp),%eax
  801773:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801776:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	50                   	push   %eax
  801783:	6a 1f                	push   $0x1f
  801785:	e8 40 fc ff ff       	call   8013ca <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
	return ;
  80178d:	90                   	nop
}
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <rsttst>:
void rsttst()
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 21                	push   $0x21
  80179f:	e8 26 fc ff ff       	call   8013ca <syscall>
  8017a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8017a7:	90                   	nop
}
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	83 ec 04             	sub    $0x4,%esp
  8017b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017b6:	8b 55 18             	mov    0x18(%ebp),%edx
  8017b9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017bd:	52                   	push   %edx
  8017be:	50                   	push   %eax
  8017bf:	ff 75 10             	pushl  0x10(%ebp)
  8017c2:	ff 75 0c             	pushl  0xc(%ebp)
  8017c5:	ff 75 08             	pushl  0x8(%ebp)
  8017c8:	6a 20                	push   $0x20
  8017ca:	e8 fb fb ff ff       	call   8013ca <syscall>
  8017cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d2:	90                   	nop
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <chktst>:
void chktst(uint32 n)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	ff 75 08             	pushl  0x8(%ebp)
  8017e3:	6a 22                	push   $0x22
  8017e5:	e8 e0 fb ff ff       	call   8013ca <syscall>
  8017ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8017ed:	90                   	nop
}
  8017ee:	c9                   	leave  
  8017ef:	c3                   	ret    

008017f0 <inctst>:

void inctst()
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 23                	push   $0x23
  8017ff:	e8 c6 fb ff ff       	call   8013ca <syscall>
  801804:	83 c4 18             	add    $0x18,%esp
	return ;
  801807:	90                   	nop
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <gettst>:
uint32 gettst()
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 24                	push   $0x24
  801819:	e8 ac fb ff ff       	call   8013ca <syscall>
  80181e:	83 c4 18             	add    $0x18,%esp
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 25                	push   $0x25
  801832:	e8 93 fb ff ff       	call   8013ca <syscall>
  801837:	83 c4 18             	add    $0x18,%esp
  80183a:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  80183f:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801844:	c9                   	leave  
  801845:	c3                   	ret    

00801846 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801849:	8b 45 08             	mov    0x8(%ebp),%eax
  80184c:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	ff 75 08             	pushl  0x8(%ebp)
  80185c:	6a 26                	push   $0x26
  80185e:	e8 67 fb ff ff       	call   8013ca <syscall>
  801863:	83 c4 18             	add    $0x18,%esp
	return ;
  801866:	90                   	nop
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
  80186c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80186d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801870:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801873:	8b 55 0c             	mov    0xc(%ebp),%edx
  801876:	8b 45 08             	mov    0x8(%ebp),%eax
  801879:	6a 00                	push   $0x0
  80187b:	53                   	push   %ebx
  80187c:	51                   	push   %ecx
  80187d:	52                   	push   %edx
  80187e:	50                   	push   %eax
  80187f:	6a 27                	push   $0x27
  801881:	e8 44 fb ff ff       	call   8013ca <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
}
  801889:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801891:	8b 55 0c             	mov    0xc(%ebp),%edx
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	52                   	push   %edx
  80189e:	50                   	push   %eax
  80189f:	6a 28                	push   $0x28
  8018a1:	e8 24 fb ff ff       	call   8013ca <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
}
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018ae:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b7:	6a 00                	push   $0x0
  8018b9:	51                   	push   %ecx
  8018ba:	ff 75 10             	pushl  0x10(%ebp)
  8018bd:	52                   	push   %edx
  8018be:	50                   	push   %eax
  8018bf:	6a 29                	push   $0x29
  8018c1:	e8 04 fb ff ff       	call   8013ca <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
}
  8018c9:	c9                   	leave  
  8018ca:	c3                   	ret    

008018cb <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	ff 75 10             	pushl  0x10(%ebp)
  8018d5:	ff 75 0c             	pushl  0xc(%ebp)
  8018d8:	ff 75 08             	pushl  0x8(%ebp)
  8018db:	6a 12                	push   $0x12
  8018dd:	e8 e8 fa ff ff       	call   8013ca <syscall>
  8018e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8018e5:	90                   	nop
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8018eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	52                   	push   %edx
  8018f8:	50                   	push   %eax
  8018f9:	6a 2a                	push   $0x2a
  8018fb:	e8 ca fa ff ff       	call   8013ca <syscall>
  801900:	83 c4 18             	add    $0x18,%esp
	return;
  801903:	90                   	nop
}
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 2b                	push   $0x2b
  801915:	e8 b0 fa ff ff       	call   8013ca <syscall>
  80191a:	83 c4 18             	add    $0x18,%esp
}
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	ff 75 0c             	pushl  0xc(%ebp)
  80192b:	ff 75 08             	pushl  0x8(%ebp)
  80192e:	6a 2d                	push   $0x2d
  801930:	e8 95 fa ff ff       	call   8013ca <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
	return;
  801938:	90                   	nop
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	ff 75 0c             	pushl  0xc(%ebp)
  801947:	ff 75 08             	pushl  0x8(%ebp)
  80194a:	6a 2c                	push   $0x2c
  80194c:	e8 79 fa ff ff       	call   8013ca <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
	return ;
  801954:	90                   	nop
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
  80195a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  80195d:	83 ec 04             	sub    $0x4,%esp
  801960:	68 c8 22 80 00       	push   $0x8022c8
  801965:	68 25 01 00 00       	push   $0x125
  80196a:	68 fb 22 80 00       	push   $0x8022fb
  80196f:	e8 a3 e8 ff ff       	call   800217 <_panic>

00801974 <__udivdi3>:
  801974:	55                   	push   %ebp
  801975:	57                   	push   %edi
  801976:	56                   	push   %esi
  801977:	53                   	push   %ebx
  801978:	83 ec 1c             	sub    $0x1c,%esp
  80197b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80197f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801983:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801987:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80198b:	89 ca                	mov    %ecx,%edx
  80198d:	89 f8                	mov    %edi,%eax
  80198f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801993:	85 f6                	test   %esi,%esi
  801995:	75 2d                	jne    8019c4 <__udivdi3+0x50>
  801997:	39 cf                	cmp    %ecx,%edi
  801999:	77 65                	ja     801a00 <__udivdi3+0x8c>
  80199b:	89 fd                	mov    %edi,%ebp
  80199d:	85 ff                	test   %edi,%edi
  80199f:	75 0b                	jne    8019ac <__udivdi3+0x38>
  8019a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8019a6:	31 d2                	xor    %edx,%edx
  8019a8:	f7 f7                	div    %edi
  8019aa:	89 c5                	mov    %eax,%ebp
  8019ac:	31 d2                	xor    %edx,%edx
  8019ae:	89 c8                	mov    %ecx,%eax
  8019b0:	f7 f5                	div    %ebp
  8019b2:	89 c1                	mov    %eax,%ecx
  8019b4:	89 d8                	mov    %ebx,%eax
  8019b6:	f7 f5                	div    %ebp
  8019b8:	89 cf                	mov    %ecx,%edi
  8019ba:	89 fa                	mov    %edi,%edx
  8019bc:	83 c4 1c             	add    $0x1c,%esp
  8019bf:	5b                   	pop    %ebx
  8019c0:	5e                   	pop    %esi
  8019c1:	5f                   	pop    %edi
  8019c2:	5d                   	pop    %ebp
  8019c3:	c3                   	ret    
  8019c4:	39 ce                	cmp    %ecx,%esi
  8019c6:	77 28                	ja     8019f0 <__udivdi3+0x7c>
  8019c8:	0f bd fe             	bsr    %esi,%edi
  8019cb:	83 f7 1f             	xor    $0x1f,%edi
  8019ce:	75 40                	jne    801a10 <__udivdi3+0x9c>
  8019d0:	39 ce                	cmp    %ecx,%esi
  8019d2:	72 0a                	jb     8019de <__udivdi3+0x6a>
  8019d4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019d8:	0f 87 9e 00 00 00    	ja     801a7c <__udivdi3+0x108>
  8019de:	b8 01 00 00 00       	mov    $0x1,%eax
  8019e3:	89 fa                	mov    %edi,%edx
  8019e5:	83 c4 1c             	add    $0x1c,%esp
  8019e8:	5b                   	pop    %ebx
  8019e9:	5e                   	pop    %esi
  8019ea:	5f                   	pop    %edi
  8019eb:	5d                   	pop    %ebp
  8019ec:	c3                   	ret    
  8019ed:	8d 76 00             	lea    0x0(%esi),%esi
  8019f0:	31 ff                	xor    %edi,%edi
  8019f2:	31 c0                	xor    %eax,%eax
  8019f4:	89 fa                	mov    %edi,%edx
  8019f6:	83 c4 1c             	add    $0x1c,%esp
  8019f9:	5b                   	pop    %ebx
  8019fa:	5e                   	pop    %esi
  8019fb:	5f                   	pop    %edi
  8019fc:	5d                   	pop    %ebp
  8019fd:	c3                   	ret    
  8019fe:	66 90                	xchg   %ax,%ax
  801a00:	89 d8                	mov    %ebx,%eax
  801a02:	f7 f7                	div    %edi
  801a04:	31 ff                	xor    %edi,%edi
  801a06:	89 fa                	mov    %edi,%edx
  801a08:	83 c4 1c             	add    $0x1c,%esp
  801a0b:	5b                   	pop    %ebx
  801a0c:	5e                   	pop    %esi
  801a0d:	5f                   	pop    %edi
  801a0e:	5d                   	pop    %ebp
  801a0f:	c3                   	ret    
  801a10:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a15:	89 eb                	mov    %ebp,%ebx
  801a17:	29 fb                	sub    %edi,%ebx
  801a19:	89 f9                	mov    %edi,%ecx
  801a1b:	d3 e6                	shl    %cl,%esi
  801a1d:	89 c5                	mov    %eax,%ebp
  801a1f:	88 d9                	mov    %bl,%cl
  801a21:	d3 ed                	shr    %cl,%ebp
  801a23:	89 e9                	mov    %ebp,%ecx
  801a25:	09 f1                	or     %esi,%ecx
  801a27:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a2b:	89 f9                	mov    %edi,%ecx
  801a2d:	d3 e0                	shl    %cl,%eax
  801a2f:	89 c5                	mov    %eax,%ebp
  801a31:	89 d6                	mov    %edx,%esi
  801a33:	88 d9                	mov    %bl,%cl
  801a35:	d3 ee                	shr    %cl,%esi
  801a37:	89 f9                	mov    %edi,%ecx
  801a39:	d3 e2                	shl    %cl,%edx
  801a3b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a3f:	88 d9                	mov    %bl,%cl
  801a41:	d3 e8                	shr    %cl,%eax
  801a43:	09 c2                	or     %eax,%edx
  801a45:	89 d0                	mov    %edx,%eax
  801a47:	89 f2                	mov    %esi,%edx
  801a49:	f7 74 24 0c          	divl   0xc(%esp)
  801a4d:	89 d6                	mov    %edx,%esi
  801a4f:	89 c3                	mov    %eax,%ebx
  801a51:	f7 e5                	mul    %ebp
  801a53:	39 d6                	cmp    %edx,%esi
  801a55:	72 19                	jb     801a70 <__udivdi3+0xfc>
  801a57:	74 0b                	je     801a64 <__udivdi3+0xf0>
  801a59:	89 d8                	mov    %ebx,%eax
  801a5b:	31 ff                	xor    %edi,%edi
  801a5d:	e9 58 ff ff ff       	jmp    8019ba <__udivdi3+0x46>
  801a62:	66 90                	xchg   %ax,%ax
  801a64:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a68:	89 f9                	mov    %edi,%ecx
  801a6a:	d3 e2                	shl    %cl,%edx
  801a6c:	39 c2                	cmp    %eax,%edx
  801a6e:	73 e9                	jae    801a59 <__udivdi3+0xe5>
  801a70:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a73:	31 ff                	xor    %edi,%edi
  801a75:	e9 40 ff ff ff       	jmp    8019ba <__udivdi3+0x46>
  801a7a:	66 90                	xchg   %ax,%ax
  801a7c:	31 c0                	xor    %eax,%eax
  801a7e:	e9 37 ff ff ff       	jmp    8019ba <__udivdi3+0x46>
  801a83:	90                   	nop

00801a84 <__umoddi3>:
  801a84:	55                   	push   %ebp
  801a85:	57                   	push   %edi
  801a86:	56                   	push   %esi
  801a87:	53                   	push   %ebx
  801a88:	83 ec 1c             	sub    $0x1c,%esp
  801a8b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a97:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a9f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801aa3:	89 f3                	mov    %esi,%ebx
  801aa5:	89 fa                	mov    %edi,%edx
  801aa7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801aab:	89 34 24             	mov    %esi,(%esp)
  801aae:	85 c0                	test   %eax,%eax
  801ab0:	75 1a                	jne    801acc <__umoddi3+0x48>
  801ab2:	39 f7                	cmp    %esi,%edi
  801ab4:	0f 86 a2 00 00 00    	jbe    801b5c <__umoddi3+0xd8>
  801aba:	89 c8                	mov    %ecx,%eax
  801abc:	89 f2                	mov    %esi,%edx
  801abe:	f7 f7                	div    %edi
  801ac0:	89 d0                	mov    %edx,%eax
  801ac2:	31 d2                	xor    %edx,%edx
  801ac4:	83 c4 1c             	add    $0x1c,%esp
  801ac7:	5b                   	pop    %ebx
  801ac8:	5e                   	pop    %esi
  801ac9:	5f                   	pop    %edi
  801aca:	5d                   	pop    %ebp
  801acb:	c3                   	ret    
  801acc:	39 f0                	cmp    %esi,%eax
  801ace:	0f 87 ac 00 00 00    	ja     801b80 <__umoddi3+0xfc>
  801ad4:	0f bd e8             	bsr    %eax,%ebp
  801ad7:	83 f5 1f             	xor    $0x1f,%ebp
  801ada:	0f 84 ac 00 00 00    	je     801b8c <__umoddi3+0x108>
  801ae0:	bf 20 00 00 00       	mov    $0x20,%edi
  801ae5:	29 ef                	sub    %ebp,%edi
  801ae7:	89 fe                	mov    %edi,%esi
  801ae9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801aed:	89 e9                	mov    %ebp,%ecx
  801aef:	d3 e0                	shl    %cl,%eax
  801af1:	89 d7                	mov    %edx,%edi
  801af3:	89 f1                	mov    %esi,%ecx
  801af5:	d3 ef                	shr    %cl,%edi
  801af7:	09 c7                	or     %eax,%edi
  801af9:	89 e9                	mov    %ebp,%ecx
  801afb:	d3 e2                	shl    %cl,%edx
  801afd:	89 14 24             	mov    %edx,(%esp)
  801b00:	89 d8                	mov    %ebx,%eax
  801b02:	d3 e0                	shl    %cl,%eax
  801b04:	89 c2                	mov    %eax,%edx
  801b06:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b0a:	d3 e0                	shl    %cl,%eax
  801b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b10:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b14:	89 f1                	mov    %esi,%ecx
  801b16:	d3 e8                	shr    %cl,%eax
  801b18:	09 d0                	or     %edx,%eax
  801b1a:	d3 eb                	shr    %cl,%ebx
  801b1c:	89 da                	mov    %ebx,%edx
  801b1e:	f7 f7                	div    %edi
  801b20:	89 d3                	mov    %edx,%ebx
  801b22:	f7 24 24             	mull   (%esp)
  801b25:	89 c6                	mov    %eax,%esi
  801b27:	89 d1                	mov    %edx,%ecx
  801b29:	39 d3                	cmp    %edx,%ebx
  801b2b:	0f 82 87 00 00 00    	jb     801bb8 <__umoddi3+0x134>
  801b31:	0f 84 91 00 00 00    	je     801bc8 <__umoddi3+0x144>
  801b37:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b3b:	29 f2                	sub    %esi,%edx
  801b3d:	19 cb                	sbb    %ecx,%ebx
  801b3f:	89 d8                	mov    %ebx,%eax
  801b41:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b45:	d3 e0                	shl    %cl,%eax
  801b47:	89 e9                	mov    %ebp,%ecx
  801b49:	d3 ea                	shr    %cl,%edx
  801b4b:	09 d0                	or     %edx,%eax
  801b4d:	89 e9                	mov    %ebp,%ecx
  801b4f:	d3 eb                	shr    %cl,%ebx
  801b51:	89 da                	mov    %ebx,%edx
  801b53:	83 c4 1c             	add    $0x1c,%esp
  801b56:	5b                   	pop    %ebx
  801b57:	5e                   	pop    %esi
  801b58:	5f                   	pop    %edi
  801b59:	5d                   	pop    %ebp
  801b5a:	c3                   	ret    
  801b5b:	90                   	nop
  801b5c:	89 fd                	mov    %edi,%ebp
  801b5e:	85 ff                	test   %edi,%edi
  801b60:	75 0b                	jne    801b6d <__umoddi3+0xe9>
  801b62:	b8 01 00 00 00       	mov    $0x1,%eax
  801b67:	31 d2                	xor    %edx,%edx
  801b69:	f7 f7                	div    %edi
  801b6b:	89 c5                	mov    %eax,%ebp
  801b6d:	89 f0                	mov    %esi,%eax
  801b6f:	31 d2                	xor    %edx,%edx
  801b71:	f7 f5                	div    %ebp
  801b73:	89 c8                	mov    %ecx,%eax
  801b75:	f7 f5                	div    %ebp
  801b77:	89 d0                	mov    %edx,%eax
  801b79:	e9 44 ff ff ff       	jmp    801ac2 <__umoddi3+0x3e>
  801b7e:	66 90                	xchg   %ax,%ax
  801b80:	89 c8                	mov    %ecx,%eax
  801b82:	89 f2                	mov    %esi,%edx
  801b84:	83 c4 1c             	add    $0x1c,%esp
  801b87:	5b                   	pop    %ebx
  801b88:	5e                   	pop    %esi
  801b89:	5f                   	pop    %edi
  801b8a:	5d                   	pop    %ebp
  801b8b:	c3                   	ret    
  801b8c:	3b 04 24             	cmp    (%esp),%eax
  801b8f:	72 06                	jb     801b97 <__umoddi3+0x113>
  801b91:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b95:	77 0f                	ja     801ba6 <__umoddi3+0x122>
  801b97:	89 f2                	mov    %esi,%edx
  801b99:	29 f9                	sub    %edi,%ecx
  801b9b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b9f:	89 14 24             	mov    %edx,(%esp)
  801ba2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ba6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801baa:	8b 14 24             	mov    (%esp),%edx
  801bad:	83 c4 1c             	add    $0x1c,%esp
  801bb0:	5b                   	pop    %ebx
  801bb1:	5e                   	pop    %esi
  801bb2:	5f                   	pop    %edi
  801bb3:	5d                   	pop    %ebp
  801bb4:	c3                   	ret    
  801bb5:	8d 76 00             	lea    0x0(%esi),%esi
  801bb8:	2b 04 24             	sub    (%esp),%eax
  801bbb:	19 fa                	sbb    %edi,%edx
  801bbd:	89 d1                	mov    %edx,%ecx
  801bbf:	89 c6                	mov    %eax,%esi
  801bc1:	e9 71 ff ff ff       	jmp    801b37 <__umoddi3+0xb3>
  801bc6:	66 90                	xchg   %ax,%ax
  801bc8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bcc:	72 ea                	jb     801bb8 <__umoddi3+0x134>
  801bce:	89 d9                	mov    %ebx,%ecx
  801bd0:	e9 62 ff ff ff       	jmp    801b37 <__umoddi3+0xb3>

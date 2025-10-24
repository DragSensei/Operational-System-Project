
obj/user/tst_invalid_access_slave4:     file format elf32-i386


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
  800031:	e8 5c 00 00 00       	call   800092 <libmain>
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
	//[4] Not in Page File, Not Stack & Not Heap
	uint32 kilo = 1024;
  80003e:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)
	{
		uint32 size = 4*kilo;
  800045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800048:	c1 e0 02             	shl    $0x2,%eax
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

		unsigned char *x = (unsigned char *)(0x00200000-PAGE_SIZE);
  80004e:	c7 45 e8 00 f0 1f 00 	movl   $0x1ff000,-0x18(%ebp)

		int i=0;
  800055:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for(;i< size+20;i++)
  80005c:	eb 0e                	jmp    80006c <_main+0x34>
		{
			x[i]=-1;
  80005e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800061:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800064:	01 d0                	add    %edx,%eax
  800066:	c6 00 ff             	movb   $0xff,(%eax)
		uint32 size = 4*kilo;

		unsigned char *x = (unsigned char *)(0x00200000-PAGE_SIZE);

		int i=0;
		for(;i< size+20;i++)
  800069:	ff 45 f4             	incl   -0xc(%ebp)
  80006c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80006f:	8d 50 14             	lea    0x14(%eax),%edx
  800072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800075:	39 c2                	cmp    %eax,%edx
  800077:	77 e5                	ja     80005e <_main+0x26>
		{
			x[i]=-1;
		}
	}

	inctst();
  800079:	e8 9d 17 00 00       	call   80181b <inctst>
	panic("tst invalid access failed: Attempt to access page that's not exist in page file, neither stack or heap.\nThe env must be killed and shouldn't return here.");
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	68 20 1c 80 00       	push   $0x801c20
  800086:	6a 18                	push   $0x18
  800088:	68 bc 1c 80 00       	push   $0x801cbc
  80008d:	e8 b0 01 00 00       	call   800242 <_panic>

00800092 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800092:	55                   	push   %ebp
  800093:	89 e5                	mov    %esp,%ebp
  800095:	57                   	push   %edi
  800096:	56                   	push   %esi
  800097:	53                   	push   %ebx
  800098:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80009b:	e8 3d 16 00 00       	call   8016dd <sys_getenvindex>
  8000a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000a6:	89 d0                	mov    %edx,%eax
  8000a8:	c1 e0 02             	shl    $0x2,%eax
  8000ab:	01 d0                	add    %edx,%eax
  8000ad:	c1 e0 03             	shl    $0x3,%eax
  8000b0:	01 d0                	add    %edx,%eax
  8000b2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8000b9:	01 d0                	add    %edx,%eax
  8000bb:	c1 e0 02             	shl    $0x2,%eax
  8000be:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000c3:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000c8:	a1 20 30 80 00       	mov    0x803020,%eax
  8000cd:	8a 40 20             	mov    0x20(%eax),%al
  8000d0:	84 c0                	test   %al,%al
  8000d2:	74 0d                	je     8000e1 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8000d4:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d9:	83 c0 20             	add    $0x20,%eax
  8000dc:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000e5:	7e 0a                	jle    8000f1 <libmain+0x5f>
		binaryname = argv[0];
  8000e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ea:	8b 00                	mov    (%eax),%eax
  8000ec:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000f1:	83 ec 08             	sub    $0x8,%esp
  8000f4:	ff 75 0c             	pushl  0xc(%ebp)
  8000f7:	ff 75 08             	pushl  0x8(%ebp)
  8000fa:	e8 39 ff ff ff       	call   800038 <_main>
  8000ff:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800102:	a1 00 30 80 00       	mov    0x803000,%eax
  800107:	85 c0                	test   %eax,%eax
  800109:	0f 84 01 01 00 00    	je     800210 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80010f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800115:	bb d8 1d 80 00       	mov    $0x801dd8,%ebx
  80011a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80011f:	89 c7                	mov    %eax,%edi
  800121:	89 de                	mov    %ebx,%esi
  800123:	89 d1                	mov    %edx,%ecx
  800125:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800127:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80012a:	b9 56 00 00 00       	mov    $0x56,%ecx
  80012f:	b0 00                	mov    $0x0,%al
  800131:	89 d7                	mov    %edx,%edi
  800133:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800135:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80013c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80013f:	83 ec 08             	sub    $0x8,%esp
  800142:	50                   	push   %eax
  800143:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800149:	50                   	push   %eax
  80014a:	e8 c4 17 00 00       	call   801913 <sys_utilities>
  80014f:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800152:	e8 0d 13 00 00       	call   801464 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 f8 1c 80 00       	push   $0x801cf8
  80015f:	e8 ac 03 00 00       	call   800510 <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800167:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80016a:	85 c0                	test   %eax,%eax
  80016c:	74 18                	je     800186 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80016e:	e8 be 17 00 00       	call   801931 <sys_get_optimal_num_faults>
  800173:	83 ec 08             	sub    $0x8,%esp
  800176:	50                   	push   %eax
  800177:	68 20 1d 80 00       	push   $0x801d20
  80017c:	e8 8f 03 00 00       	call   800510 <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	eb 59                	jmp    8001df <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800186:	a1 20 30 80 00       	mov    0x803020,%eax
  80018b:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800191:	a1 20 30 80 00       	mov    0x803020,%eax
  800196:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80019c:	83 ec 04             	sub    $0x4,%esp
  80019f:	52                   	push   %edx
  8001a0:	50                   	push   %eax
  8001a1:	68 44 1d 80 00       	push   $0x801d44
  8001a6:	e8 65 03 00 00       	call   800510 <cprintf>
  8001ab:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001ae:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b3:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8001b9:	a1 20 30 80 00       	mov    0x803020,%eax
  8001be:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8001c4:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c9:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8001cf:	51                   	push   %ecx
  8001d0:	52                   	push   %edx
  8001d1:	50                   	push   %eax
  8001d2:	68 6c 1d 80 00       	push   $0x801d6c
  8001d7:	e8 34 03 00 00       	call   800510 <cprintf>
  8001dc:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001df:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e4:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8001ea:	83 ec 08             	sub    $0x8,%esp
  8001ed:	50                   	push   %eax
  8001ee:	68 c4 1d 80 00       	push   $0x801dc4
  8001f3:	e8 18 03 00 00       	call   800510 <cprintf>
  8001f8:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001fb:	83 ec 0c             	sub    $0xc,%esp
  8001fe:	68 f8 1c 80 00       	push   $0x801cf8
  800203:	e8 08 03 00 00       	call   800510 <cprintf>
  800208:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80020b:	e8 6e 12 00 00       	call   80147e <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800210:	e8 1f 00 00 00       	call   800234 <exit>
}
  800215:	90                   	nop
  800216:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800219:	5b                   	pop    %ebx
  80021a:	5e                   	pop    %esi
  80021b:	5f                   	pop    %edi
  80021c:	5d                   	pop    %ebp
  80021d:	c3                   	ret    

0080021e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	6a 00                	push   $0x0
  800229:	e8 7b 14 00 00       	call   8016a9 <sys_destroy_env>
  80022e:	83 c4 10             	add    $0x10,%esp
}
  800231:	90                   	nop
  800232:	c9                   	leave  
  800233:	c3                   	ret    

00800234 <exit>:

void
exit(void)
{
  800234:	55                   	push   %ebp
  800235:	89 e5                	mov    %esp,%ebp
  800237:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80023a:	e8 d0 14 00 00       	call   80170f <sys_exit_env>
}
  80023f:	90                   	nop
  800240:	c9                   	leave  
  800241:	c3                   	ret    

00800242 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800242:	55                   	push   %ebp
  800243:	89 e5                	mov    %esp,%ebp
  800245:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800248:	8d 45 10             	lea    0x10(%ebp),%eax
  80024b:	83 c0 04             	add    $0x4,%eax
  80024e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800251:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800256:	85 c0                	test   %eax,%eax
  800258:	74 16                	je     800270 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80025a:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80025f:	83 ec 08             	sub    $0x8,%esp
  800262:	50                   	push   %eax
  800263:	68 3c 1e 80 00       	push   $0x801e3c
  800268:	e8 a3 02 00 00       	call   800510 <cprintf>
  80026d:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800270:	a1 04 30 80 00       	mov    0x803004,%eax
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	ff 75 0c             	pushl  0xc(%ebp)
  80027b:	ff 75 08             	pushl  0x8(%ebp)
  80027e:	50                   	push   %eax
  80027f:	68 44 1e 80 00       	push   $0x801e44
  800284:	6a 74                	push   $0x74
  800286:	e8 b2 02 00 00       	call   80053d <cprintf_colored>
  80028b:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80028e:	8b 45 10             	mov    0x10(%ebp),%eax
  800291:	83 ec 08             	sub    $0x8,%esp
  800294:	ff 75 f4             	pushl  -0xc(%ebp)
  800297:	50                   	push   %eax
  800298:	e8 04 02 00 00       	call   8004a1 <vcprintf>
  80029d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002a0:	83 ec 08             	sub    $0x8,%esp
  8002a3:	6a 00                	push   $0x0
  8002a5:	68 6c 1e 80 00       	push   $0x801e6c
  8002aa:	e8 f2 01 00 00       	call   8004a1 <vcprintf>
  8002af:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002b2:	e8 7d ff ff ff       	call   800234 <exit>

	// should not return here
	while (1) ;
  8002b7:	eb fe                	jmp    8002b7 <_panic+0x75>

008002b9 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002b9:	55                   	push   %ebp
  8002ba:	89 e5                	mov    %esp,%ebp
  8002bc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002bf:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8002ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cd:	39 c2                	cmp    %eax,%edx
  8002cf:	74 14                	je     8002e5 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002d1:	83 ec 04             	sub    $0x4,%esp
  8002d4:	68 70 1e 80 00       	push   $0x801e70
  8002d9:	6a 26                	push   $0x26
  8002db:	68 bc 1e 80 00       	push   $0x801ebc
  8002e0:	e8 5d ff ff ff       	call   800242 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002f3:	e9 c5 00 00 00       	jmp    8003bd <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8002f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800302:	8b 45 08             	mov    0x8(%ebp),%eax
  800305:	01 d0                	add    %edx,%eax
  800307:	8b 00                	mov    (%eax),%eax
  800309:	85 c0                	test   %eax,%eax
  80030b:	75 08                	jne    800315 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80030d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800310:	e9 a5 00 00 00       	jmp    8003ba <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800315:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80031c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800323:	eb 69                	jmp    80038e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800325:	a1 20 30 80 00       	mov    0x803020,%eax
  80032a:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800330:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800333:	89 d0                	mov    %edx,%eax
  800335:	01 c0                	add    %eax,%eax
  800337:	01 d0                	add    %edx,%eax
  800339:	c1 e0 03             	shl    $0x3,%eax
  80033c:	01 c8                	add    %ecx,%eax
  80033e:	8a 40 04             	mov    0x4(%eax),%al
  800341:	84 c0                	test   %al,%al
  800343:	75 46                	jne    80038b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800345:	a1 20 30 80 00       	mov    0x803020,%eax
  80034a:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800350:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800353:	89 d0                	mov    %edx,%eax
  800355:	01 c0                	add    %eax,%eax
  800357:	01 d0                	add    %edx,%eax
  800359:	c1 e0 03             	shl    $0x3,%eax
  80035c:	01 c8                	add    %ecx,%eax
  80035e:	8b 00                	mov    (%eax),%eax
  800360:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800363:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800366:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80036b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80036d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800370:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800377:	8b 45 08             	mov    0x8(%ebp),%eax
  80037a:	01 c8                	add    %ecx,%eax
  80037c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80037e:	39 c2                	cmp    %eax,%edx
  800380:	75 09                	jne    80038b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800382:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800389:	eb 15                	jmp    8003a0 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80038b:	ff 45 e8             	incl   -0x18(%ebp)
  80038e:	a1 20 30 80 00       	mov    0x803020,%eax
  800393:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800399:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80039c:	39 c2                	cmp    %eax,%edx
  80039e:	77 85                	ja     800325 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003a4:	75 14                	jne    8003ba <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003a6:	83 ec 04             	sub    $0x4,%esp
  8003a9:	68 c8 1e 80 00       	push   $0x801ec8
  8003ae:	6a 3a                	push   $0x3a
  8003b0:	68 bc 1e 80 00       	push   $0x801ebc
  8003b5:	e8 88 fe ff ff       	call   800242 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003ba:	ff 45 f0             	incl   -0x10(%ebp)
  8003bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003c3:	0f 8c 2f ff ff ff    	jl     8002f8 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003c9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003d7:	eb 26                	jmp    8003ff <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003d9:	a1 20 30 80 00       	mov    0x803020,%eax
  8003de:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003e4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003e7:	89 d0                	mov    %edx,%eax
  8003e9:	01 c0                	add    %eax,%eax
  8003eb:	01 d0                	add    %edx,%eax
  8003ed:	c1 e0 03             	shl    $0x3,%eax
  8003f0:	01 c8                	add    %ecx,%eax
  8003f2:	8a 40 04             	mov    0x4(%eax),%al
  8003f5:	3c 01                	cmp    $0x1,%al
  8003f7:	75 03                	jne    8003fc <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8003f9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fc:	ff 45 e0             	incl   -0x20(%ebp)
  8003ff:	a1 20 30 80 00       	mov    0x803020,%eax
  800404:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80040a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80040d:	39 c2                	cmp    %eax,%edx
  80040f:	77 c8                	ja     8003d9 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800414:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800417:	74 14                	je     80042d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800419:	83 ec 04             	sub    $0x4,%esp
  80041c:	68 1c 1f 80 00       	push   $0x801f1c
  800421:	6a 44                	push   $0x44
  800423:	68 bc 1e 80 00       	push   $0x801ebc
  800428:	e8 15 fe ff ff       	call   800242 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80042d:	90                   	nop
  80042e:	c9                   	leave  
  80042f:	c3                   	ret    

00800430 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800430:	55                   	push   %ebp
  800431:	89 e5                	mov    %esp,%ebp
  800433:	53                   	push   %ebx
  800434:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800437:	8b 45 0c             	mov    0xc(%ebp),%eax
  80043a:	8b 00                	mov    (%eax),%eax
  80043c:	8d 48 01             	lea    0x1(%eax),%ecx
  80043f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800442:	89 0a                	mov    %ecx,(%edx)
  800444:	8b 55 08             	mov    0x8(%ebp),%edx
  800447:	88 d1                	mov    %dl,%cl
  800449:	8b 55 0c             	mov    0xc(%ebp),%edx
  80044c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800450:	8b 45 0c             	mov    0xc(%ebp),%eax
  800453:	8b 00                	mov    (%eax),%eax
  800455:	3d ff 00 00 00       	cmp    $0xff,%eax
  80045a:	75 30                	jne    80048c <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80045c:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800462:	a0 44 30 80 00       	mov    0x803044,%al
  800467:	0f b6 c0             	movzbl %al,%eax
  80046a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80046d:	8b 09                	mov    (%ecx),%ecx
  80046f:	89 cb                	mov    %ecx,%ebx
  800471:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800474:	83 c1 08             	add    $0x8,%ecx
  800477:	52                   	push   %edx
  800478:	50                   	push   %eax
  800479:	53                   	push   %ebx
  80047a:	51                   	push   %ecx
  80047b:	e8 a0 0f 00 00       	call   801420 <sys_cputs>
  800480:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800483:	8b 45 0c             	mov    0xc(%ebp),%eax
  800486:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80048c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048f:	8b 40 04             	mov    0x4(%eax),%eax
  800492:	8d 50 01             	lea    0x1(%eax),%edx
  800495:	8b 45 0c             	mov    0xc(%ebp),%eax
  800498:	89 50 04             	mov    %edx,0x4(%eax)
}
  80049b:	90                   	nop
  80049c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80049f:	c9                   	leave  
  8004a0:	c3                   	ret    

008004a1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004a1:	55                   	push   %ebp
  8004a2:	89 e5                	mov    %esp,%ebp
  8004a4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004aa:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004b1:	00 00 00 
	b.cnt = 0;
  8004b4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004bb:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004be:	ff 75 0c             	pushl  0xc(%ebp)
  8004c1:	ff 75 08             	pushl  0x8(%ebp)
  8004c4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004ca:	50                   	push   %eax
  8004cb:	68 30 04 80 00       	push   $0x800430
  8004d0:	e8 5a 02 00 00       	call   80072f <vprintfmt>
  8004d5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8004d8:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004de:	a0 44 30 80 00       	mov    0x803044,%al
  8004e3:	0f b6 c0             	movzbl %al,%eax
  8004e6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8004ec:	52                   	push   %edx
  8004ed:	50                   	push   %eax
  8004ee:	51                   	push   %ecx
  8004ef:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f5:	83 c0 08             	add    $0x8,%eax
  8004f8:	50                   	push   %eax
  8004f9:	e8 22 0f 00 00       	call   801420 <sys_cputs>
  8004fe:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800501:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800508:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80050e:	c9                   	leave  
  80050f:	c3                   	ret    

00800510 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800510:	55                   	push   %ebp
  800511:	89 e5                	mov    %esp,%ebp
  800513:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800516:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80051d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800520:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800523:	8b 45 08             	mov    0x8(%ebp),%eax
  800526:	83 ec 08             	sub    $0x8,%esp
  800529:	ff 75 f4             	pushl  -0xc(%ebp)
  80052c:	50                   	push   %eax
  80052d:	e8 6f ff ff ff       	call   8004a1 <vcprintf>
  800532:	83 c4 10             	add    $0x10,%esp
  800535:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800538:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80053b:	c9                   	leave  
  80053c:	c3                   	ret    

0080053d <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80053d:	55                   	push   %ebp
  80053e:	89 e5                	mov    %esp,%ebp
  800540:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800543:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80054a:	8b 45 08             	mov    0x8(%ebp),%eax
  80054d:	c1 e0 08             	shl    $0x8,%eax
  800550:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800555:	8d 45 0c             	lea    0xc(%ebp),%eax
  800558:	83 c0 04             	add    $0x4,%eax
  80055b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80055e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800561:	83 ec 08             	sub    $0x8,%esp
  800564:	ff 75 f4             	pushl  -0xc(%ebp)
  800567:	50                   	push   %eax
  800568:	e8 34 ff ff ff       	call   8004a1 <vcprintf>
  80056d:	83 c4 10             	add    $0x10,%esp
  800570:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800573:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  80057a:	07 00 00 

	return cnt;
  80057d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800580:	c9                   	leave  
  800581:	c3                   	ret    

00800582 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
  800585:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800588:	e8 d7 0e 00 00       	call   801464 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80058d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800590:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800593:	8b 45 08             	mov    0x8(%ebp),%eax
  800596:	83 ec 08             	sub    $0x8,%esp
  800599:	ff 75 f4             	pushl  -0xc(%ebp)
  80059c:	50                   	push   %eax
  80059d:	e8 ff fe ff ff       	call   8004a1 <vcprintf>
  8005a2:	83 c4 10             	add    $0x10,%esp
  8005a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8005a8:	e8 d1 0e 00 00       	call   80147e <sys_unlock_cons>
	return cnt;
  8005ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005b0:	c9                   	leave  
  8005b1:	c3                   	ret    

008005b2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005b2:	55                   	push   %ebp
  8005b3:	89 e5                	mov    %esp,%ebp
  8005b5:	53                   	push   %ebx
  8005b6:	83 ec 14             	sub    $0x14,%esp
  8005b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005c5:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005d0:	77 55                	ja     800627 <printnum+0x75>
  8005d2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005d5:	72 05                	jb     8005dc <printnum+0x2a>
  8005d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005da:	77 4b                	ja     800627 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005dc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005df:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005e2:	8b 45 18             	mov    0x18(%ebp),%eax
  8005e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ea:	52                   	push   %edx
  8005eb:	50                   	push   %eax
  8005ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8005f2:	e8 a9 13 00 00       	call   8019a0 <__udivdi3>
  8005f7:	83 c4 10             	add    $0x10,%esp
  8005fa:	83 ec 04             	sub    $0x4,%esp
  8005fd:	ff 75 20             	pushl  0x20(%ebp)
  800600:	53                   	push   %ebx
  800601:	ff 75 18             	pushl  0x18(%ebp)
  800604:	52                   	push   %edx
  800605:	50                   	push   %eax
  800606:	ff 75 0c             	pushl  0xc(%ebp)
  800609:	ff 75 08             	pushl  0x8(%ebp)
  80060c:	e8 a1 ff ff ff       	call   8005b2 <printnum>
  800611:	83 c4 20             	add    $0x20,%esp
  800614:	eb 1a                	jmp    800630 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800616:	83 ec 08             	sub    $0x8,%esp
  800619:	ff 75 0c             	pushl  0xc(%ebp)
  80061c:	ff 75 20             	pushl  0x20(%ebp)
  80061f:	8b 45 08             	mov    0x8(%ebp),%eax
  800622:	ff d0                	call   *%eax
  800624:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800627:	ff 4d 1c             	decl   0x1c(%ebp)
  80062a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80062e:	7f e6                	jg     800616 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800630:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800633:	bb 00 00 00 00       	mov    $0x0,%ebx
  800638:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80063b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80063e:	53                   	push   %ebx
  80063f:	51                   	push   %ecx
  800640:	52                   	push   %edx
  800641:	50                   	push   %eax
  800642:	e8 69 14 00 00       	call   801ab0 <__umoddi3>
  800647:	83 c4 10             	add    $0x10,%esp
  80064a:	05 94 21 80 00       	add    $0x802194,%eax
  80064f:	8a 00                	mov    (%eax),%al
  800651:	0f be c0             	movsbl %al,%eax
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	ff 75 0c             	pushl  0xc(%ebp)
  80065a:	50                   	push   %eax
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	ff d0                	call   *%eax
  800660:	83 c4 10             	add    $0x10,%esp
}
  800663:	90                   	nop
  800664:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800667:	c9                   	leave  
  800668:	c3                   	ret    

00800669 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800669:	55                   	push   %ebp
  80066a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80066c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800670:	7e 1c                	jle    80068e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800672:	8b 45 08             	mov    0x8(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	8d 50 08             	lea    0x8(%eax),%edx
  80067a:	8b 45 08             	mov    0x8(%ebp),%eax
  80067d:	89 10                	mov    %edx,(%eax)
  80067f:	8b 45 08             	mov    0x8(%ebp),%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	83 e8 08             	sub    $0x8,%eax
  800687:	8b 50 04             	mov    0x4(%eax),%edx
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	eb 40                	jmp    8006ce <getuint+0x65>
	else if (lflag)
  80068e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800692:	74 1e                	je     8006b2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	8d 50 04             	lea    0x4(%eax),%edx
  80069c:	8b 45 08             	mov    0x8(%ebp),%eax
  80069f:	89 10                	mov    %edx,(%eax)
  8006a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	83 e8 04             	sub    $0x4,%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b0:	eb 1c                	jmp    8006ce <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	8d 50 04             	lea    0x4(%eax),%edx
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	89 10                	mov    %edx,(%eax)
  8006bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c2:	8b 00                	mov    (%eax),%eax
  8006c4:	83 e8 04             	sub    $0x4,%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ce:	5d                   	pop    %ebp
  8006cf:	c3                   	ret    

008006d0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006d0:	55                   	push   %ebp
  8006d1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006d3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006d7:	7e 1c                	jle    8006f5 <getint+0x25>
		return va_arg(*ap, long long);
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	8d 50 08             	lea    0x8(%eax),%edx
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	89 10                	mov    %edx,(%eax)
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	83 e8 08             	sub    $0x8,%eax
  8006ee:	8b 50 04             	mov    0x4(%eax),%edx
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	eb 38                	jmp    80072d <getint+0x5d>
	else if (lflag)
  8006f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006f9:	74 1a                	je     800715 <getint+0x45>
		return va_arg(*ap, long);
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	8d 50 04             	lea    0x4(%eax),%edx
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	89 10                	mov    %edx,(%eax)
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	83 e8 04             	sub    $0x4,%eax
  800710:	8b 00                	mov    (%eax),%eax
  800712:	99                   	cltd   
  800713:	eb 18                	jmp    80072d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	8d 50 04             	lea    0x4(%eax),%edx
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	89 10                	mov    %edx,(%eax)
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	83 e8 04             	sub    $0x4,%eax
  80072a:	8b 00                	mov    (%eax),%eax
  80072c:	99                   	cltd   
}
  80072d:	5d                   	pop    %ebp
  80072e:	c3                   	ret    

0080072f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
  800732:	56                   	push   %esi
  800733:	53                   	push   %ebx
  800734:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800737:	eb 17                	jmp    800750 <vprintfmt+0x21>
			if (ch == '\0')
  800739:	85 db                	test   %ebx,%ebx
  80073b:	0f 84 c1 03 00 00    	je     800b02 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800741:	83 ec 08             	sub    $0x8,%esp
  800744:	ff 75 0c             	pushl  0xc(%ebp)
  800747:	53                   	push   %ebx
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	ff d0                	call   *%eax
  80074d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800750:	8b 45 10             	mov    0x10(%ebp),%eax
  800753:	8d 50 01             	lea    0x1(%eax),%edx
  800756:	89 55 10             	mov    %edx,0x10(%ebp)
  800759:	8a 00                	mov    (%eax),%al
  80075b:	0f b6 d8             	movzbl %al,%ebx
  80075e:	83 fb 25             	cmp    $0x25,%ebx
  800761:	75 d6                	jne    800739 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800763:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800767:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80076e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800775:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80077c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800783:	8b 45 10             	mov    0x10(%ebp),%eax
  800786:	8d 50 01             	lea    0x1(%eax),%edx
  800789:	89 55 10             	mov    %edx,0x10(%ebp)
  80078c:	8a 00                	mov    (%eax),%al
  80078e:	0f b6 d8             	movzbl %al,%ebx
  800791:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800794:	83 f8 5b             	cmp    $0x5b,%eax
  800797:	0f 87 3d 03 00 00    	ja     800ada <vprintfmt+0x3ab>
  80079d:	8b 04 85 b8 21 80 00 	mov    0x8021b8(,%eax,4),%eax
  8007a4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007a6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007aa:	eb d7                	jmp    800783 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007ac:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007b0:	eb d1                	jmp    800783 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007b2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007bc:	89 d0                	mov    %edx,%eax
  8007be:	c1 e0 02             	shl    $0x2,%eax
  8007c1:	01 d0                	add    %edx,%eax
  8007c3:	01 c0                	add    %eax,%eax
  8007c5:	01 d8                	add    %ebx,%eax
  8007c7:	83 e8 30             	sub    $0x30,%eax
  8007ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d0:	8a 00                	mov    (%eax),%al
  8007d2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007d5:	83 fb 2f             	cmp    $0x2f,%ebx
  8007d8:	7e 3e                	jle    800818 <vprintfmt+0xe9>
  8007da:	83 fb 39             	cmp    $0x39,%ebx
  8007dd:	7f 39                	jg     800818 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007df:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007e2:	eb d5                	jmp    8007b9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e7:	83 c0 04             	add    $0x4,%eax
  8007ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f0:	83 e8 04             	sub    $0x4,%eax
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007f8:	eb 1f                	jmp    800819 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fe:	79 83                	jns    800783 <vprintfmt+0x54>
				width = 0;
  800800:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800807:	e9 77 ff ff ff       	jmp    800783 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80080c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800813:	e9 6b ff ff ff       	jmp    800783 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800818:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800819:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80081d:	0f 89 60 ff ff ff    	jns    800783 <vprintfmt+0x54>
				width = precision, precision = -1;
  800823:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800826:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800829:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800830:	e9 4e ff ff ff       	jmp    800783 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800835:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800838:	e9 46 ff ff ff       	jmp    800783 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80083d:	8b 45 14             	mov    0x14(%ebp),%eax
  800840:	83 c0 04             	add    $0x4,%eax
  800843:	89 45 14             	mov    %eax,0x14(%ebp)
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	83 e8 04             	sub    $0x4,%eax
  80084c:	8b 00                	mov    (%eax),%eax
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	ff 75 0c             	pushl  0xc(%ebp)
  800854:	50                   	push   %eax
  800855:	8b 45 08             	mov    0x8(%ebp),%eax
  800858:	ff d0                	call   *%eax
  80085a:	83 c4 10             	add    $0x10,%esp
			break;
  80085d:	e9 9b 02 00 00       	jmp    800afd <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800862:	8b 45 14             	mov    0x14(%ebp),%eax
  800865:	83 c0 04             	add    $0x4,%eax
  800868:	89 45 14             	mov    %eax,0x14(%ebp)
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	83 e8 04             	sub    $0x4,%eax
  800871:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800873:	85 db                	test   %ebx,%ebx
  800875:	79 02                	jns    800879 <vprintfmt+0x14a>
				err = -err;
  800877:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800879:	83 fb 64             	cmp    $0x64,%ebx
  80087c:	7f 0b                	jg     800889 <vprintfmt+0x15a>
  80087e:	8b 34 9d 00 20 80 00 	mov    0x802000(,%ebx,4),%esi
  800885:	85 f6                	test   %esi,%esi
  800887:	75 19                	jne    8008a2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800889:	53                   	push   %ebx
  80088a:	68 a5 21 80 00       	push   $0x8021a5
  80088f:	ff 75 0c             	pushl  0xc(%ebp)
  800892:	ff 75 08             	pushl  0x8(%ebp)
  800895:	e8 70 02 00 00       	call   800b0a <printfmt>
  80089a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80089d:	e9 5b 02 00 00       	jmp    800afd <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008a2:	56                   	push   %esi
  8008a3:	68 ae 21 80 00       	push   $0x8021ae
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	ff 75 08             	pushl  0x8(%ebp)
  8008ae:	e8 57 02 00 00       	call   800b0a <printfmt>
  8008b3:	83 c4 10             	add    $0x10,%esp
			break;
  8008b6:	e9 42 02 00 00       	jmp    800afd <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008be:	83 c0 04             	add    $0x4,%eax
  8008c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c7:	83 e8 04             	sub    $0x4,%eax
  8008ca:	8b 30                	mov    (%eax),%esi
  8008cc:	85 f6                	test   %esi,%esi
  8008ce:	75 05                	jne    8008d5 <vprintfmt+0x1a6>
				p = "(null)";
  8008d0:	be b1 21 80 00       	mov    $0x8021b1,%esi
			if (width > 0 && padc != '-')
  8008d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008d9:	7e 6d                	jle    800948 <vprintfmt+0x219>
  8008db:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008df:	74 67                	je     800948 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008e4:	83 ec 08             	sub    $0x8,%esp
  8008e7:	50                   	push   %eax
  8008e8:	56                   	push   %esi
  8008e9:	e8 1e 03 00 00       	call   800c0c <strnlen>
  8008ee:	83 c4 10             	add    $0x10,%esp
  8008f1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008f4:	eb 16                	jmp    80090c <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008f6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008fa:	83 ec 08             	sub    $0x8,%esp
  8008fd:	ff 75 0c             	pushl  0xc(%ebp)
  800900:	50                   	push   %eax
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	ff d0                	call   *%eax
  800906:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800909:	ff 4d e4             	decl   -0x1c(%ebp)
  80090c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800910:	7f e4                	jg     8008f6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800912:	eb 34                	jmp    800948 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800914:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800918:	74 1c                	je     800936 <vprintfmt+0x207>
  80091a:	83 fb 1f             	cmp    $0x1f,%ebx
  80091d:	7e 05                	jle    800924 <vprintfmt+0x1f5>
  80091f:	83 fb 7e             	cmp    $0x7e,%ebx
  800922:	7e 12                	jle    800936 <vprintfmt+0x207>
					putch('?', putdat);
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	ff 75 0c             	pushl  0xc(%ebp)
  80092a:	6a 3f                	push   $0x3f
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	ff d0                	call   *%eax
  800931:	83 c4 10             	add    $0x10,%esp
  800934:	eb 0f                	jmp    800945 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800936:	83 ec 08             	sub    $0x8,%esp
  800939:	ff 75 0c             	pushl  0xc(%ebp)
  80093c:	53                   	push   %ebx
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	ff d0                	call   *%eax
  800942:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800945:	ff 4d e4             	decl   -0x1c(%ebp)
  800948:	89 f0                	mov    %esi,%eax
  80094a:	8d 70 01             	lea    0x1(%eax),%esi
  80094d:	8a 00                	mov    (%eax),%al
  80094f:	0f be d8             	movsbl %al,%ebx
  800952:	85 db                	test   %ebx,%ebx
  800954:	74 24                	je     80097a <vprintfmt+0x24b>
  800956:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80095a:	78 b8                	js     800914 <vprintfmt+0x1e5>
  80095c:	ff 4d e0             	decl   -0x20(%ebp)
  80095f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800963:	79 af                	jns    800914 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800965:	eb 13                	jmp    80097a <vprintfmt+0x24b>
				putch(' ', putdat);
  800967:	83 ec 08             	sub    $0x8,%esp
  80096a:	ff 75 0c             	pushl  0xc(%ebp)
  80096d:	6a 20                	push   $0x20
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	ff d0                	call   *%eax
  800974:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800977:	ff 4d e4             	decl   -0x1c(%ebp)
  80097a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80097e:	7f e7                	jg     800967 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800980:	e9 78 01 00 00       	jmp    800afd <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	ff 75 e8             	pushl  -0x18(%ebp)
  80098b:	8d 45 14             	lea    0x14(%ebp),%eax
  80098e:	50                   	push   %eax
  80098f:	e8 3c fd ff ff       	call   8006d0 <getint>
  800994:	83 c4 10             	add    $0x10,%esp
  800997:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80099d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009a3:	85 d2                	test   %edx,%edx
  8009a5:	79 23                	jns    8009ca <vprintfmt+0x29b>
				putch('-', putdat);
  8009a7:	83 ec 08             	sub    $0x8,%esp
  8009aa:	ff 75 0c             	pushl  0xc(%ebp)
  8009ad:	6a 2d                	push   $0x2d
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	ff d0                	call   *%eax
  8009b4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009bd:	f7 d8                	neg    %eax
  8009bf:	83 d2 00             	adc    $0x0,%edx
  8009c2:	f7 da                	neg    %edx
  8009c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009ca:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d1:	e9 bc 00 00 00       	jmp    800a92 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 e8             	pushl  -0x18(%ebp)
  8009dc:	8d 45 14             	lea    0x14(%ebp),%eax
  8009df:	50                   	push   %eax
  8009e0:	e8 84 fc ff ff       	call   800669 <getuint>
  8009e5:	83 c4 10             	add    $0x10,%esp
  8009e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009ee:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009f5:	e9 98 00 00 00       	jmp    800a92 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009fa:	83 ec 08             	sub    $0x8,%esp
  8009fd:	ff 75 0c             	pushl  0xc(%ebp)
  800a00:	6a 58                	push   $0x58
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	ff d0                	call   *%eax
  800a07:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a0a:	83 ec 08             	sub    $0x8,%esp
  800a0d:	ff 75 0c             	pushl  0xc(%ebp)
  800a10:	6a 58                	push   $0x58
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	ff d0                	call   *%eax
  800a17:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1a:	83 ec 08             	sub    $0x8,%esp
  800a1d:	ff 75 0c             	pushl  0xc(%ebp)
  800a20:	6a 58                	push   $0x58
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	ff d0                	call   *%eax
  800a27:	83 c4 10             	add    $0x10,%esp
			break;
  800a2a:	e9 ce 00 00 00       	jmp    800afd <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a2f:	83 ec 08             	sub    $0x8,%esp
  800a32:	ff 75 0c             	pushl  0xc(%ebp)
  800a35:	6a 30                	push   $0x30
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	ff d0                	call   *%eax
  800a3c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a3f:	83 ec 08             	sub    $0x8,%esp
  800a42:	ff 75 0c             	pushl  0xc(%ebp)
  800a45:	6a 78                	push   $0x78
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	ff d0                	call   *%eax
  800a4c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a52:	83 c0 04             	add    $0x4,%eax
  800a55:	89 45 14             	mov    %eax,0x14(%ebp)
  800a58:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5b:	83 e8 04             	sub    $0x4,%eax
  800a5e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a6a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a71:	eb 1f                	jmp    800a92 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a73:	83 ec 08             	sub    $0x8,%esp
  800a76:	ff 75 e8             	pushl  -0x18(%ebp)
  800a79:	8d 45 14             	lea    0x14(%ebp),%eax
  800a7c:	50                   	push   %eax
  800a7d:	e8 e7 fb ff ff       	call   800669 <getuint>
  800a82:	83 c4 10             	add    $0x10,%esp
  800a85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a88:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a8b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a92:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a99:	83 ec 04             	sub    $0x4,%esp
  800a9c:	52                   	push   %edx
  800a9d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800aa0:	50                   	push   %eax
  800aa1:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa4:	ff 75 f0             	pushl  -0x10(%ebp)
  800aa7:	ff 75 0c             	pushl  0xc(%ebp)
  800aaa:	ff 75 08             	pushl  0x8(%ebp)
  800aad:	e8 00 fb ff ff       	call   8005b2 <printnum>
  800ab2:	83 c4 20             	add    $0x20,%esp
			break;
  800ab5:	eb 46                	jmp    800afd <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ab7:	83 ec 08             	sub    $0x8,%esp
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	53                   	push   %ebx
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	ff d0                	call   *%eax
  800ac3:	83 c4 10             	add    $0x10,%esp
			break;
  800ac6:	eb 35                	jmp    800afd <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ac8:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800acf:	eb 2c                	jmp    800afd <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ad1:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800ad8:	eb 23                	jmp    800afd <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ada:	83 ec 08             	sub    $0x8,%esp
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	6a 25                	push   $0x25
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	ff d0                	call   *%eax
  800ae7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aea:	ff 4d 10             	decl   0x10(%ebp)
  800aed:	eb 03                	jmp    800af2 <vprintfmt+0x3c3>
  800aef:	ff 4d 10             	decl   0x10(%ebp)
  800af2:	8b 45 10             	mov    0x10(%ebp),%eax
  800af5:	48                   	dec    %eax
  800af6:	8a 00                	mov    (%eax),%al
  800af8:	3c 25                	cmp    $0x25,%al
  800afa:	75 f3                	jne    800aef <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800afc:	90                   	nop
		}
	}
  800afd:	e9 35 fc ff ff       	jmp    800737 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b02:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b06:	5b                   	pop    %ebx
  800b07:	5e                   	pop    %esi
  800b08:	5d                   	pop    %ebp
  800b09:	c3                   	ret    

00800b0a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b10:	8d 45 10             	lea    0x10(%ebp),%eax
  800b13:	83 c0 04             	add    $0x4,%eax
  800b16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b19:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b1f:	50                   	push   %eax
  800b20:	ff 75 0c             	pushl  0xc(%ebp)
  800b23:	ff 75 08             	pushl  0x8(%ebp)
  800b26:	e8 04 fc ff ff       	call   80072f <vprintfmt>
  800b2b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b2e:	90                   	nop
  800b2f:	c9                   	leave  
  800b30:	c3                   	ret    

00800b31 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b37:	8b 40 08             	mov    0x8(%eax),%eax
  800b3a:	8d 50 01             	lea    0x1(%eax),%edx
  800b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b40:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b46:	8b 10                	mov    (%eax),%edx
  800b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4b:	8b 40 04             	mov    0x4(%eax),%eax
  800b4e:	39 c2                	cmp    %eax,%edx
  800b50:	73 12                	jae    800b64 <sprintputch+0x33>
		*b->buf++ = ch;
  800b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b55:	8b 00                	mov    (%eax),%eax
  800b57:	8d 48 01             	lea    0x1(%eax),%ecx
  800b5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5d:	89 0a                	mov    %ecx,(%edx)
  800b5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b62:	88 10                	mov    %dl,(%eax)
}
  800b64:	90                   	nop
  800b65:	5d                   	pop    %ebp
  800b66:	c3                   	ret    

00800b67 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b76:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	01 d0                	add    %edx,%eax
  800b7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b8c:	74 06                	je     800b94 <vsnprintf+0x2d>
  800b8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b92:	7f 07                	jg     800b9b <vsnprintf+0x34>
		return -E_INVAL;
  800b94:	b8 03 00 00 00       	mov    $0x3,%eax
  800b99:	eb 20                	jmp    800bbb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b9b:	ff 75 14             	pushl  0x14(%ebp)
  800b9e:	ff 75 10             	pushl  0x10(%ebp)
  800ba1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ba4:	50                   	push   %eax
  800ba5:	68 31 0b 80 00       	push   $0x800b31
  800baa:	e8 80 fb ff ff       	call   80072f <vprintfmt>
  800baf:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bb5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bbb:	c9                   	leave  
  800bbc:	c3                   	ret    

00800bbd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
  800bc0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bc3:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc6:	83 c0 04             	add    $0x4,%eax
  800bc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bcc:	8b 45 10             	mov    0x10(%ebp),%eax
  800bcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd2:	50                   	push   %eax
  800bd3:	ff 75 0c             	pushl  0xc(%ebp)
  800bd6:	ff 75 08             	pushl  0x8(%ebp)
  800bd9:	e8 89 ff ff ff       	call   800b67 <vsnprintf>
  800bde:	83 c4 10             	add    $0x10,%esp
  800be1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be7:	c9                   	leave  
  800be8:	c3                   	ret    

00800be9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf6:	eb 06                	jmp    800bfe <strlen+0x15>
		n++;
  800bf8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bfb:	ff 45 08             	incl   0x8(%ebp)
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	8a 00                	mov    (%eax),%al
  800c03:	84 c0                	test   %al,%al
  800c05:	75 f1                	jne    800bf8 <strlen+0xf>
		n++;
	return n;
  800c07:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0a:	c9                   	leave  
  800c0b:	c3                   	ret    

00800c0c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
  800c0f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c19:	eb 09                	jmp    800c24 <strnlen+0x18>
		n++;
  800c1b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1e:	ff 45 08             	incl   0x8(%ebp)
  800c21:	ff 4d 0c             	decl   0xc(%ebp)
  800c24:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c28:	74 09                	je     800c33 <strnlen+0x27>
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	8a 00                	mov    (%eax),%al
  800c2f:	84 c0                	test   %al,%al
  800c31:	75 e8                	jne    800c1b <strnlen+0xf>
		n++;
	return n;
  800c33:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c36:	c9                   	leave  
  800c37:	c3                   	ret    

00800c38 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c38:	55                   	push   %ebp
  800c39:	89 e5                	mov    %esp,%ebp
  800c3b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c44:	90                   	nop
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	8d 50 01             	lea    0x1(%eax),%edx
  800c4b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c51:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c54:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c57:	8a 12                	mov    (%edx),%dl
  800c59:	88 10                	mov    %dl,(%eax)
  800c5b:	8a 00                	mov    (%eax),%al
  800c5d:	84 c0                	test   %al,%al
  800c5f:	75 e4                	jne    800c45 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c61:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c64:	c9                   	leave  
  800c65:	c3                   	ret    

00800c66 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c66:	55                   	push   %ebp
  800c67:	89 e5                	mov    %esp,%ebp
  800c69:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c72:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c79:	eb 1f                	jmp    800c9a <strncpy+0x34>
		*dst++ = *src;
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8d 50 01             	lea    0x1(%eax),%edx
  800c81:	89 55 08             	mov    %edx,0x8(%ebp)
  800c84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c87:	8a 12                	mov    (%edx),%dl
  800c89:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8e:	8a 00                	mov    (%eax),%al
  800c90:	84 c0                	test   %al,%al
  800c92:	74 03                	je     800c97 <strncpy+0x31>
			src++;
  800c94:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c97:	ff 45 fc             	incl   -0x4(%ebp)
  800c9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c9d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ca0:	72 d9                	jb     800c7b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ca2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ca5:	c9                   	leave  
  800ca6:	c3                   	ret    

00800ca7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb7:	74 30                	je     800ce9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cb9:	eb 16                	jmp    800cd1 <strlcpy+0x2a>
			*dst++ = *src++;
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	8d 50 01             	lea    0x1(%eax),%edx
  800cc1:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cca:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ccd:	8a 12                	mov    (%edx),%dl
  800ccf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cd1:	ff 4d 10             	decl   0x10(%ebp)
  800cd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd8:	74 09                	je     800ce3 <strlcpy+0x3c>
  800cda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	84 c0                	test   %al,%al
  800ce1:	75 d8                	jne    800cbb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ce9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cef:	29 c2                	sub    %eax,%edx
  800cf1:	89 d0                	mov    %edx,%eax
}
  800cf3:	c9                   	leave  
  800cf4:	c3                   	ret    

00800cf5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cf8:	eb 06                	jmp    800d00 <strcmp+0xb>
		p++, q++;
  800cfa:	ff 45 08             	incl   0x8(%ebp)
  800cfd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	8a 00                	mov    (%eax),%al
  800d05:	84 c0                	test   %al,%al
  800d07:	74 0e                	je     800d17 <strcmp+0x22>
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	8a 10                	mov    (%eax),%dl
  800d0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d11:	8a 00                	mov    (%eax),%al
  800d13:	38 c2                	cmp    %al,%dl
  800d15:	74 e3                	je     800cfa <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	8a 00                	mov    (%eax),%al
  800d1c:	0f b6 d0             	movzbl %al,%edx
  800d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d22:	8a 00                	mov    (%eax),%al
  800d24:	0f b6 c0             	movzbl %al,%eax
  800d27:	29 c2                	sub    %eax,%edx
  800d29:	89 d0                	mov    %edx,%eax
}
  800d2b:	5d                   	pop    %ebp
  800d2c:	c3                   	ret    

00800d2d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d30:	eb 09                	jmp    800d3b <strncmp+0xe>
		n--, p++, q++;
  800d32:	ff 4d 10             	decl   0x10(%ebp)
  800d35:	ff 45 08             	incl   0x8(%ebp)
  800d38:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d3b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3f:	74 17                	je     800d58 <strncmp+0x2b>
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	8a 00                	mov    (%eax),%al
  800d46:	84 c0                	test   %al,%al
  800d48:	74 0e                	je     800d58 <strncmp+0x2b>
  800d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4d:	8a 10                	mov    (%eax),%dl
  800d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d52:	8a 00                	mov    (%eax),%al
  800d54:	38 c2                	cmp    %al,%dl
  800d56:	74 da                	je     800d32 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d58:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5c:	75 07                	jne    800d65 <strncmp+0x38>
		return 0;
  800d5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d63:	eb 14                	jmp    800d79 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8a 00                	mov    (%eax),%al
  800d6a:	0f b6 d0             	movzbl %al,%edx
  800d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d70:	8a 00                	mov    (%eax),%al
  800d72:	0f b6 c0             	movzbl %al,%eax
  800d75:	29 c2                	sub    %eax,%edx
  800d77:	89 d0                	mov    %edx,%eax
}
  800d79:	5d                   	pop    %ebp
  800d7a:	c3                   	ret    

00800d7b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
  800d7e:	83 ec 04             	sub    $0x4,%esp
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d87:	eb 12                	jmp    800d9b <strchr+0x20>
		if (*s == c)
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d91:	75 05                	jne    800d98 <strchr+0x1d>
			return (char *) s;
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	eb 11                	jmp    800da9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d98:	ff 45 08             	incl   0x8(%ebp)
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	8a 00                	mov    (%eax),%al
  800da0:	84 c0                	test   %al,%al
  800da2:	75 e5                	jne    800d89 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800da4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800da9:	c9                   	leave  
  800daa:	c3                   	ret    

00800dab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dab:	55                   	push   %ebp
  800dac:	89 e5                	mov    %esp,%ebp
  800dae:	83 ec 04             	sub    $0x4,%esp
  800db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800db7:	eb 0d                	jmp    800dc6 <strfind+0x1b>
		if (*s == c)
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	8a 00                	mov    (%eax),%al
  800dbe:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc1:	74 0e                	je     800dd1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dc3:	ff 45 08             	incl   0x8(%ebp)
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	8a 00                	mov    (%eax),%al
  800dcb:	84 c0                	test   %al,%al
  800dcd:	75 ea                	jne    800db9 <strfind+0xe>
  800dcf:	eb 01                	jmp    800dd2 <strfind+0x27>
		if (*s == c)
			break;
  800dd1:	90                   	nop
	return (char *) s;
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd5:	c9                   	leave  
  800dd6:	c3                   	ret    

00800dd7 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800dd7:	55                   	push   %ebp
  800dd8:	89 e5                	mov    %esp,%ebp
  800dda:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800de3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800de7:	76 63                	jbe    800e4c <memset+0x75>
		uint64 data_block = c;
  800de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dec:	99                   	cltd   
  800ded:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800df0:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800df3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800df6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800df9:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800dfd:	c1 e0 08             	shl    $0x8,%eax
  800e00:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e03:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e0c:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e10:	c1 e0 10             	shl    $0x10,%eax
  800e13:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e16:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e1f:	89 c2                	mov    %eax,%edx
  800e21:	b8 00 00 00 00       	mov    $0x0,%eax
  800e26:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e29:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e2c:	eb 18                	jmp    800e46 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e2e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e31:	8d 41 08             	lea    0x8(%ecx),%eax
  800e34:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3d:	89 01                	mov    %eax,(%ecx)
  800e3f:	89 51 04             	mov    %edx,0x4(%ecx)
  800e42:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e46:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e4a:	77 e2                	ja     800e2e <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e50:	74 23                	je     800e75 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e55:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e58:	eb 0e                	jmp    800e68 <memset+0x91>
			*p8++ = (uint8)c;
  800e5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5d:	8d 50 01             	lea    0x1(%eax),%edx
  800e60:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e66:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800e68:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e71:	85 c0                	test   %eax,%eax
  800e73:	75 e5                	jne    800e5a <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e78:	c9                   	leave  
  800e79:	c3                   	ret    

00800e7a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800e8c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e90:	76 24                	jbe    800eb6 <memcpy+0x3c>
		while(n >= 8){
  800e92:	eb 1c                	jmp    800eb0 <memcpy+0x36>
			*d64 = *s64;
  800e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e97:	8b 50 04             	mov    0x4(%eax),%edx
  800e9a:	8b 00                	mov    (%eax),%eax
  800e9c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800e9f:	89 01                	mov    %eax,(%ecx)
  800ea1:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800ea4:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800ea8:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800eac:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800eb0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800eb4:	77 de                	ja     800e94 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800eb6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eba:	74 31                	je     800eed <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800ebc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ebf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800ec2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800ec8:	eb 16                	jmp    800ee0 <memcpy+0x66>
			*d8++ = *s8++;
  800eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ecd:	8d 50 01             	lea    0x1(%eax),%edx
  800ed0:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800ed3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ed9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800edc:	8a 12                	mov    (%edx),%dl
  800ede:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800ee0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee6:	89 55 10             	mov    %edx,0x10(%ebp)
  800ee9:	85 c0                	test   %eax,%eax
  800eeb:	75 dd                	jne    800eca <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef0:	c9                   	leave  
  800ef1:	c3                   	ret    

00800ef2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
  800ef5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f07:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f0a:	73 50                	jae    800f5c <memmove+0x6a>
  800f0c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f12:	01 d0                	add    %edx,%eax
  800f14:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f17:	76 43                	jbe    800f5c <memmove+0x6a>
		s += n;
  800f19:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f22:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f25:	eb 10                	jmp    800f37 <memmove+0x45>
			*--d = *--s;
  800f27:	ff 4d f8             	decl   -0x8(%ebp)
  800f2a:	ff 4d fc             	decl   -0x4(%ebp)
  800f2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f30:	8a 10                	mov    (%eax),%dl
  800f32:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f35:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f37:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f3d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f40:	85 c0                	test   %eax,%eax
  800f42:	75 e3                	jne    800f27 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f44:	eb 23                	jmp    800f69 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f46:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f49:	8d 50 01             	lea    0x1(%eax),%edx
  800f4c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f4f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f52:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f55:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f58:	8a 12                	mov    (%edx),%dl
  800f5a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f62:	89 55 10             	mov    %edx,0x10(%ebp)
  800f65:	85 c0                	test   %eax,%eax
  800f67:	75 dd                	jne    800f46 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f6c:	c9                   	leave  
  800f6d:	c3                   	ret    

00800f6e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f6e:	55                   	push   %ebp
  800f6f:	89 e5                	mov    %esp,%ebp
  800f71:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f80:	eb 2a                	jmp    800fac <memcmp+0x3e>
		if (*s1 != *s2)
  800f82:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f85:	8a 10                	mov    (%eax),%dl
  800f87:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f8a:	8a 00                	mov    (%eax),%al
  800f8c:	38 c2                	cmp    %al,%dl
  800f8e:	74 16                	je     800fa6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f93:	8a 00                	mov    (%eax),%al
  800f95:	0f b6 d0             	movzbl %al,%edx
  800f98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	0f b6 c0             	movzbl %al,%eax
  800fa0:	29 c2                	sub    %eax,%edx
  800fa2:	89 d0                	mov    %edx,%eax
  800fa4:	eb 18                	jmp    800fbe <memcmp+0x50>
		s1++, s2++;
  800fa6:	ff 45 fc             	incl   -0x4(%ebp)
  800fa9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fac:	8b 45 10             	mov    0x10(%ebp),%eax
  800faf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb2:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb5:	85 c0                	test   %eax,%eax
  800fb7:	75 c9                	jne    800f82 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fbe:	c9                   	leave  
  800fbf:	c3                   	ret    

00800fc0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	01 d0                	add    %edx,%eax
  800fce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fd1:	eb 15                	jmp    800fe8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	8a 00                	mov    (%eax),%al
  800fd8:	0f b6 d0             	movzbl %al,%edx
  800fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fde:	0f b6 c0             	movzbl %al,%eax
  800fe1:	39 c2                	cmp    %eax,%edx
  800fe3:	74 0d                	je     800ff2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fe5:	ff 45 08             	incl   0x8(%ebp)
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fee:	72 e3                	jb     800fd3 <memfind+0x13>
  800ff0:	eb 01                	jmp    800ff3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ff2:	90                   	nop
	return (void *) s;
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff6:	c9                   	leave  
  800ff7:	c3                   	ret    

00800ff8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ff8:	55                   	push   %ebp
  800ff9:	89 e5                	mov    %esp,%ebp
  800ffb:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ffe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801005:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80100c:	eb 03                	jmp    801011 <strtol+0x19>
		s++;
  80100e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	3c 20                	cmp    $0x20,%al
  801018:	74 f4                	je     80100e <strtol+0x16>
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	3c 09                	cmp    $0x9,%al
  801021:	74 eb                	je     80100e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	8a 00                	mov    (%eax),%al
  801028:	3c 2b                	cmp    $0x2b,%al
  80102a:	75 05                	jne    801031 <strtol+0x39>
		s++;
  80102c:	ff 45 08             	incl   0x8(%ebp)
  80102f:	eb 13                	jmp    801044 <strtol+0x4c>
	else if (*s == '-')
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	8a 00                	mov    (%eax),%al
  801036:	3c 2d                	cmp    $0x2d,%al
  801038:	75 0a                	jne    801044 <strtol+0x4c>
		s++, neg = 1;
  80103a:	ff 45 08             	incl   0x8(%ebp)
  80103d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801044:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801048:	74 06                	je     801050 <strtol+0x58>
  80104a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80104e:	75 20                	jne    801070 <strtol+0x78>
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	8a 00                	mov    (%eax),%al
  801055:	3c 30                	cmp    $0x30,%al
  801057:	75 17                	jne    801070 <strtol+0x78>
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
  80105c:	40                   	inc    %eax
  80105d:	8a 00                	mov    (%eax),%al
  80105f:	3c 78                	cmp    $0x78,%al
  801061:	75 0d                	jne    801070 <strtol+0x78>
		s += 2, base = 16;
  801063:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801067:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80106e:	eb 28                	jmp    801098 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801070:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801074:	75 15                	jne    80108b <strtol+0x93>
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	3c 30                	cmp    $0x30,%al
  80107d:	75 0c                	jne    80108b <strtol+0x93>
		s++, base = 8;
  80107f:	ff 45 08             	incl   0x8(%ebp)
  801082:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801089:	eb 0d                	jmp    801098 <strtol+0xa0>
	else if (base == 0)
  80108b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80108f:	75 07                	jne    801098 <strtol+0xa0>
		base = 10;
  801091:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	3c 2f                	cmp    $0x2f,%al
  80109f:	7e 19                	jle    8010ba <strtol+0xc2>
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	8a 00                	mov    (%eax),%al
  8010a6:	3c 39                	cmp    $0x39,%al
  8010a8:	7f 10                	jg     8010ba <strtol+0xc2>
			dig = *s - '0';
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	8a 00                	mov    (%eax),%al
  8010af:	0f be c0             	movsbl %al,%eax
  8010b2:	83 e8 30             	sub    $0x30,%eax
  8010b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010b8:	eb 42                	jmp    8010fc <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	8a 00                	mov    (%eax),%al
  8010bf:	3c 60                	cmp    $0x60,%al
  8010c1:	7e 19                	jle    8010dc <strtol+0xe4>
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	3c 7a                	cmp    $0x7a,%al
  8010ca:	7f 10                	jg     8010dc <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	0f be c0             	movsbl %al,%eax
  8010d4:	83 e8 57             	sub    $0x57,%eax
  8010d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010da:	eb 20                	jmp    8010fc <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010df:	8a 00                	mov    (%eax),%al
  8010e1:	3c 40                	cmp    $0x40,%al
  8010e3:	7e 39                	jle    80111e <strtol+0x126>
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	8a 00                	mov    (%eax),%al
  8010ea:	3c 5a                	cmp    $0x5a,%al
  8010ec:	7f 30                	jg     80111e <strtol+0x126>
			dig = *s - 'A' + 10;
  8010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f1:	8a 00                	mov    (%eax),%al
  8010f3:	0f be c0             	movsbl %al,%eax
  8010f6:	83 e8 37             	sub    $0x37,%eax
  8010f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ff:	3b 45 10             	cmp    0x10(%ebp),%eax
  801102:	7d 19                	jge    80111d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801104:	ff 45 08             	incl   0x8(%ebp)
  801107:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80110e:	89 c2                	mov    %eax,%edx
  801110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801113:	01 d0                	add    %edx,%eax
  801115:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801118:	e9 7b ff ff ff       	jmp    801098 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80111d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80111e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801122:	74 08                	je     80112c <strtol+0x134>
		*endptr = (char *) s;
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	8b 55 08             	mov    0x8(%ebp),%edx
  80112a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80112c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801130:	74 07                	je     801139 <strtol+0x141>
  801132:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801135:	f7 d8                	neg    %eax
  801137:	eb 03                	jmp    80113c <strtol+0x144>
  801139:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80113c:	c9                   	leave  
  80113d:	c3                   	ret    

0080113e <ltostr>:

void
ltostr(long value, char *str)
{
  80113e:	55                   	push   %ebp
  80113f:	89 e5                	mov    %esp,%ebp
  801141:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801144:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80114b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801152:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801156:	79 13                	jns    80116b <ltostr+0x2d>
	{
		neg = 1;
  801158:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80115f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801162:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801165:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801168:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801173:	99                   	cltd   
  801174:	f7 f9                	idiv   %ecx
  801176:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801179:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117c:	8d 50 01             	lea    0x1(%eax),%edx
  80117f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801182:	89 c2                	mov    %eax,%edx
  801184:	8b 45 0c             	mov    0xc(%ebp),%eax
  801187:	01 d0                	add    %edx,%eax
  801189:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80118c:	83 c2 30             	add    $0x30,%edx
  80118f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801191:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801194:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801199:	f7 e9                	imul   %ecx
  80119b:	c1 fa 02             	sar    $0x2,%edx
  80119e:	89 c8                	mov    %ecx,%eax
  8011a0:	c1 f8 1f             	sar    $0x1f,%eax
  8011a3:	29 c2                	sub    %eax,%edx
  8011a5:	89 d0                	mov    %edx,%eax
  8011a7:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8011aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011ae:	75 bb                	jne    80116b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ba:	48                   	dec    %eax
  8011bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011be:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011c2:	74 3d                	je     801201 <ltostr+0xc3>
		start = 1 ;
  8011c4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011cb:	eb 34                	jmp    801201 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8011cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d3:	01 d0                	add    %edx,%eax
  8011d5:	8a 00                	mov    (%eax),%al
  8011d7:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e0:	01 c2                	add    %eax,%edx
  8011e2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e8:	01 c8                	add    %ecx,%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	01 c2                	add    %eax,%edx
  8011f6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011f9:	88 02                	mov    %al,(%edx)
		start++ ;
  8011fb:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011fe:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801204:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801207:	7c c4                	jl     8011cd <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801209:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80120c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120f:	01 d0                	add    %edx,%eax
  801211:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801214:	90                   	nop
  801215:	c9                   	leave  
  801216:	c3                   	ret    

00801217 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801217:	55                   	push   %ebp
  801218:	89 e5                	mov    %esp,%ebp
  80121a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80121d:	ff 75 08             	pushl  0x8(%ebp)
  801220:	e8 c4 f9 ff ff       	call   800be9 <strlen>
  801225:	83 c4 04             	add    $0x4,%esp
  801228:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80122b:	ff 75 0c             	pushl  0xc(%ebp)
  80122e:	e8 b6 f9 ff ff       	call   800be9 <strlen>
  801233:	83 c4 04             	add    $0x4,%esp
  801236:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801239:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801240:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801247:	eb 17                	jmp    801260 <strcconcat+0x49>
		final[s] = str1[s] ;
  801249:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80124c:	8b 45 10             	mov    0x10(%ebp),%eax
  80124f:	01 c2                	add    %eax,%edx
  801251:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	01 c8                	add    %ecx,%eax
  801259:	8a 00                	mov    (%eax),%al
  80125b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80125d:	ff 45 fc             	incl   -0x4(%ebp)
  801260:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801263:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801266:	7c e1                	jl     801249 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801268:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80126f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801276:	eb 1f                	jmp    801297 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801278:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80127b:	8d 50 01             	lea    0x1(%eax),%edx
  80127e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801281:	89 c2                	mov    %eax,%edx
  801283:	8b 45 10             	mov    0x10(%ebp),%eax
  801286:	01 c2                	add    %eax,%edx
  801288:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80128b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128e:	01 c8                	add    %ecx,%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801294:	ff 45 f8             	incl   -0x8(%ebp)
  801297:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80129d:	7c d9                	jl     801278 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80129f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a5:	01 d0                	add    %edx,%eax
  8012a7:	c6 00 00             	movb   $0x0,(%eax)
}
  8012aa:	90                   	nop
  8012ab:	c9                   	leave  
  8012ac:	c3                   	ret    

008012ad <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8012bc:	8b 00                	mov    (%eax),%eax
  8012be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c8:	01 d0                	add    %edx,%eax
  8012ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012d0:	eb 0c                	jmp    8012de <strsplit+0x31>
			*string++ = 0;
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	8d 50 01             	lea    0x1(%eax),%edx
  8012d8:	89 55 08             	mov    %edx,0x8(%ebp)
  8012db:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	8a 00                	mov    (%eax),%al
  8012e3:	84 c0                	test   %al,%al
  8012e5:	74 18                	je     8012ff <strsplit+0x52>
  8012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ea:	8a 00                	mov    (%eax),%al
  8012ec:	0f be c0             	movsbl %al,%eax
  8012ef:	50                   	push   %eax
  8012f0:	ff 75 0c             	pushl  0xc(%ebp)
  8012f3:	e8 83 fa ff ff       	call   800d7b <strchr>
  8012f8:	83 c4 08             	add    $0x8,%esp
  8012fb:	85 c0                	test   %eax,%eax
  8012fd:	75 d3                	jne    8012d2 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801302:	8a 00                	mov    (%eax),%al
  801304:	84 c0                	test   %al,%al
  801306:	74 5a                	je     801362 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801308:	8b 45 14             	mov    0x14(%ebp),%eax
  80130b:	8b 00                	mov    (%eax),%eax
  80130d:	83 f8 0f             	cmp    $0xf,%eax
  801310:	75 07                	jne    801319 <strsplit+0x6c>
		{
			return 0;
  801312:	b8 00 00 00 00       	mov    $0x0,%eax
  801317:	eb 66                	jmp    80137f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801319:	8b 45 14             	mov    0x14(%ebp),%eax
  80131c:	8b 00                	mov    (%eax),%eax
  80131e:	8d 48 01             	lea    0x1(%eax),%ecx
  801321:	8b 55 14             	mov    0x14(%ebp),%edx
  801324:	89 0a                	mov    %ecx,(%edx)
  801326:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80132d:	8b 45 10             	mov    0x10(%ebp),%eax
  801330:	01 c2                	add    %eax,%edx
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801337:	eb 03                	jmp    80133c <strsplit+0x8f>
			string++;
  801339:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
  80133f:	8a 00                	mov    (%eax),%al
  801341:	84 c0                	test   %al,%al
  801343:	74 8b                	je     8012d0 <strsplit+0x23>
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
  801348:	8a 00                	mov    (%eax),%al
  80134a:	0f be c0             	movsbl %al,%eax
  80134d:	50                   	push   %eax
  80134e:	ff 75 0c             	pushl  0xc(%ebp)
  801351:	e8 25 fa ff ff       	call   800d7b <strchr>
  801356:	83 c4 08             	add    $0x8,%esp
  801359:	85 c0                	test   %eax,%eax
  80135b:	74 dc                	je     801339 <strsplit+0x8c>
			string++;
	}
  80135d:	e9 6e ff ff ff       	jmp    8012d0 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801362:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801363:	8b 45 14             	mov    0x14(%ebp),%eax
  801366:	8b 00                	mov    (%eax),%eax
  801368:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80136f:	8b 45 10             	mov    0x10(%ebp),%eax
  801372:	01 d0                	add    %edx,%eax
  801374:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80137a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80137f:	c9                   	leave  
  801380:	c3                   	ret    

00801381 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
  801384:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
  80138a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80138d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801394:	eb 4a                	jmp    8013e0 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801396:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	01 c2                	add    %eax,%edx
  80139e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a4:	01 c8                	add    %ecx,%eax
  8013a6:	8a 00                	mov    (%eax),%al
  8013a8:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8013aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b0:	01 d0                	add    %edx,%eax
  8013b2:	8a 00                	mov    (%eax),%al
  8013b4:	3c 40                	cmp    $0x40,%al
  8013b6:	7e 25                	jle    8013dd <str2lower+0x5c>
  8013b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013be:	01 d0                	add    %edx,%eax
  8013c0:	8a 00                	mov    (%eax),%al
  8013c2:	3c 5a                	cmp    $0x5a,%al
  8013c4:	7f 17                	jg     8013dd <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8013c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cc:	01 d0                	add    %edx,%eax
  8013ce:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d4:	01 ca                	add    %ecx,%edx
  8013d6:	8a 12                	mov    (%edx),%dl
  8013d8:	83 c2 20             	add    $0x20,%edx
  8013db:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8013dd:	ff 45 fc             	incl   -0x4(%ebp)
  8013e0:	ff 75 0c             	pushl  0xc(%ebp)
  8013e3:	e8 01 f8 ff ff       	call   800be9 <strlen>
  8013e8:	83 c4 04             	add    $0x4,%esp
  8013eb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013ee:	7f a6                	jg     801396 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8013f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013f3:	c9                   	leave  
  8013f4:	c3                   	ret    

008013f5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8013f5:	55                   	push   %ebp
  8013f6:	89 e5                	mov    %esp,%ebp
  8013f8:	57                   	push   %edi
  8013f9:	56                   	push   %esi
  8013fa:	53                   	push   %ebx
  8013fb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	8b 55 0c             	mov    0xc(%ebp),%edx
  801404:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801407:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80140a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80140d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801410:	cd 30                	int    $0x30
  801412:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801415:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801418:	83 c4 10             	add    $0x10,%esp
  80141b:	5b                   	pop    %ebx
  80141c:	5e                   	pop    %esi
  80141d:	5f                   	pop    %edi
  80141e:	5d                   	pop    %ebp
  80141f:	c3                   	ret    

00801420 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
  801423:	83 ec 04             	sub    $0x4,%esp
  801426:	8b 45 10             	mov    0x10(%ebp),%eax
  801429:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80142c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80142f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801433:	8b 45 08             	mov    0x8(%ebp),%eax
  801436:	6a 00                	push   $0x0
  801438:	51                   	push   %ecx
  801439:	52                   	push   %edx
  80143a:	ff 75 0c             	pushl  0xc(%ebp)
  80143d:	50                   	push   %eax
  80143e:	6a 00                	push   $0x0
  801440:	e8 b0 ff ff ff       	call   8013f5 <syscall>
  801445:	83 c4 18             	add    $0x18,%esp
}
  801448:	90                   	nop
  801449:	c9                   	leave  
  80144a:	c3                   	ret    

0080144b <sys_cgetc>:

int
sys_cgetc(void)
{
  80144b:	55                   	push   %ebp
  80144c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 02                	push   $0x2
  80145a:	e8 96 ff ff ff       	call   8013f5 <syscall>
  80145f:	83 c4 18             	add    $0x18,%esp
}
  801462:	c9                   	leave  
  801463:	c3                   	ret    

00801464 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801467:	6a 00                	push   $0x0
  801469:	6a 00                	push   $0x0
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	6a 03                	push   $0x3
  801473:	e8 7d ff ff ff       	call   8013f5 <syscall>
  801478:	83 c4 18             	add    $0x18,%esp
}
  80147b:	90                   	nop
  80147c:	c9                   	leave  
  80147d:	c3                   	ret    

0080147e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801481:	6a 00                	push   $0x0
  801483:	6a 00                	push   $0x0
  801485:	6a 00                	push   $0x0
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	6a 04                	push   $0x4
  80148d:	e8 63 ff ff ff       	call   8013f5 <syscall>
  801492:	83 c4 18             	add    $0x18,%esp
}
  801495:	90                   	nop
  801496:	c9                   	leave  
  801497:	c3                   	ret    

00801498 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80149b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149e:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 00                	push   $0x0
  8014a7:	52                   	push   %edx
  8014a8:	50                   	push   %eax
  8014a9:	6a 08                	push   $0x8
  8014ab:	e8 45 ff ff ff       	call   8013f5 <syscall>
  8014b0:	83 c4 18             	add    $0x18,%esp
}
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    

008014b5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
  8014b8:	56                   	push   %esi
  8014b9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014ba:	8b 75 18             	mov    0x18(%ebp),%esi
  8014bd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	56                   	push   %esi
  8014ca:	53                   	push   %ebx
  8014cb:	51                   	push   %ecx
  8014cc:	52                   	push   %edx
  8014cd:	50                   	push   %eax
  8014ce:	6a 09                	push   $0x9
  8014d0:	e8 20 ff ff ff       	call   8013f5 <syscall>
  8014d5:	83 c4 18             	add    $0x18,%esp
}
  8014d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014db:	5b                   	pop    %ebx
  8014dc:	5e                   	pop    %esi
  8014dd:	5d                   	pop    %ebp
  8014de:	c3                   	ret    

008014df <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 00                	push   $0x0
  8014ea:	ff 75 08             	pushl  0x8(%ebp)
  8014ed:	6a 0a                	push   $0xa
  8014ef:	e8 01 ff ff ff       	call   8013f5 <syscall>
  8014f4:	83 c4 18             	add    $0x18,%esp
}
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	ff 75 0c             	pushl  0xc(%ebp)
  801505:	ff 75 08             	pushl  0x8(%ebp)
  801508:	6a 0b                	push   $0xb
  80150a:	e8 e6 fe ff ff       	call   8013f5 <syscall>
  80150f:	83 c4 18             	add    $0x18,%esp
}
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	6a 00                	push   $0x0
  80151f:	6a 00                	push   $0x0
  801521:	6a 0c                	push   $0xc
  801523:	e8 cd fe ff ff       	call   8013f5 <syscall>
  801528:	83 c4 18             	add    $0x18,%esp
}
  80152b:	c9                   	leave  
  80152c:	c3                   	ret    

0080152d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801530:	6a 00                	push   $0x0
  801532:	6a 00                	push   $0x0
  801534:	6a 00                	push   $0x0
  801536:	6a 00                	push   $0x0
  801538:	6a 00                	push   $0x0
  80153a:	6a 0d                	push   $0xd
  80153c:	e8 b4 fe ff ff       	call   8013f5 <syscall>
  801541:	83 c4 18             	add    $0x18,%esp
}
  801544:	c9                   	leave  
  801545:	c3                   	ret    

00801546 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	6a 00                	push   $0x0
  801551:	6a 00                	push   $0x0
  801553:	6a 0e                	push   $0xe
  801555:	e8 9b fe ff ff       	call   8013f5 <syscall>
  80155a:	83 c4 18             	add    $0x18,%esp
}
  80155d:	c9                   	leave  
  80155e:	c3                   	ret    

0080155f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	6a 0f                	push   $0xf
  80156e:	e8 82 fe ff ff       	call   8013f5 <syscall>
  801573:	83 c4 18             	add    $0x18,%esp
}
  801576:	c9                   	leave  
  801577:	c3                   	ret    

00801578 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	ff 75 08             	pushl  0x8(%ebp)
  801586:	6a 10                	push   $0x10
  801588:	e8 68 fe ff ff       	call   8013f5 <syscall>
  80158d:	83 c4 18             	add    $0x18,%esp
}
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 11                	push   $0x11
  8015a1:	e8 4f fe ff ff       	call   8013f5 <syscall>
  8015a6:	83 c4 18             	add    $0x18,%esp
}
  8015a9:	90                   	nop
  8015aa:	c9                   	leave  
  8015ab:	c3                   	ret    

008015ac <sys_cputc>:

void
sys_cputc(const char c)
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
  8015af:	83 ec 04             	sub    $0x4,%esp
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8015b8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	50                   	push   %eax
  8015c5:	6a 01                	push   $0x1
  8015c7:	e8 29 fe ff ff       	call   8013f5 <syscall>
  8015cc:	83 c4 18             	add    $0x18,%esp
}
  8015cf:	90                   	nop
  8015d0:	c9                   	leave  
  8015d1:	c3                   	ret    

008015d2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 14                	push   $0x14
  8015e1:	e8 0f fe ff ff       	call   8013f5 <syscall>
  8015e6:	83 c4 18             	add    $0x18,%esp
}
  8015e9:	90                   	nop
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	83 ec 04             	sub    $0x4,%esp
  8015f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8015f8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015fb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801602:	6a 00                	push   $0x0
  801604:	51                   	push   %ecx
  801605:	52                   	push   %edx
  801606:	ff 75 0c             	pushl  0xc(%ebp)
  801609:	50                   	push   %eax
  80160a:	6a 15                	push   $0x15
  80160c:	e8 e4 fd ff ff       	call   8013f5 <syscall>
  801611:	83 c4 18             	add    $0x18,%esp
}
  801614:	c9                   	leave  
  801615:	c3                   	ret    

00801616 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801619:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161c:	8b 45 08             	mov    0x8(%ebp),%eax
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	52                   	push   %edx
  801626:	50                   	push   %eax
  801627:	6a 16                	push   $0x16
  801629:	e8 c7 fd ff ff       	call   8013f5 <syscall>
  80162e:	83 c4 18             	add    $0x18,%esp
}
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801636:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801639:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	51                   	push   %ecx
  801644:	52                   	push   %edx
  801645:	50                   	push   %eax
  801646:	6a 17                	push   $0x17
  801648:	e8 a8 fd ff ff       	call   8013f5 <syscall>
  80164d:	83 c4 18             	add    $0x18,%esp
}
  801650:	c9                   	leave  
  801651:	c3                   	ret    

00801652 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801655:	8b 55 0c             	mov    0xc(%ebp),%edx
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	52                   	push   %edx
  801662:	50                   	push   %eax
  801663:	6a 18                	push   $0x18
  801665:	e8 8b fd ff ff       	call   8013f5 <syscall>
  80166a:	83 c4 18             	add    $0x18,%esp
}
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	6a 00                	push   $0x0
  801677:	ff 75 14             	pushl  0x14(%ebp)
  80167a:	ff 75 10             	pushl  0x10(%ebp)
  80167d:	ff 75 0c             	pushl  0xc(%ebp)
  801680:	50                   	push   %eax
  801681:	6a 19                	push   $0x19
  801683:	e8 6d fd ff ff       	call   8013f5 <syscall>
  801688:	83 c4 18             	add    $0x18,%esp
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <sys_run_env>:

void sys_run_env(int32 envId)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	50                   	push   %eax
  80169c:	6a 1a                	push   $0x1a
  80169e:	e8 52 fd ff ff       	call   8013f5 <syscall>
  8016a3:	83 c4 18             	add    $0x18,%esp
}
  8016a6:	90                   	nop
  8016a7:	c9                   	leave  
  8016a8:	c3                   	ret    

008016a9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	50                   	push   %eax
  8016b8:	6a 1b                	push   $0x1b
  8016ba:	e8 36 fd ff ff       	call   8013f5 <syscall>
  8016bf:	83 c4 18             	add    $0x18,%esp
}
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    

008016c4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 05                	push   $0x5
  8016d3:	e8 1d fd ff ff       	call   8013f5 <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
}
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 06                	push   $0x6
  8016ec:	e8 04 fd ff ff       	call   8013f5 <syscall>
  8016f1:	83 c4 18             	add    $0x18,%esp
}
  8016f4:	c9                   	leave  
  8016f5:	c3                   	ret    

008016f6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 07                	push   $0x7
  801705:	e8 eb fc ff ff       	call   8013f5 <syscall>
  80170a:	83 c4 18             	add    $0x18,%esp
}
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <sys_exit_env>:


void sys_exit_env(void)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 1c                	push   $0x1c
  80171e:	e8 d2 fc ff ff       	call   8013f5 <syscall>
  801723:	83 c4 18             	add    $0x18,%esp
}
  801726:	90                   	nop
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80172f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801732:	8d 50 04             	lea    0x4(%eax),%edx
  801735:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	52                   	push   %edx
  80173f:	50                   	push   %eax
  801740:	6a 1d                	push   $0x1d
  801742:	e8 ae fc ff ff       	call   8013f5 <syscall>
  801747:	83 c4 18             	add    $0x18,%esp
	return result;
  80174a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80174d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801750:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801753:	89 01                	mov    %eax,(%ecx)
  801755:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	c9                   	leave  
  80175c:	c2 04 00             	ret    $0x4

0080175f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	ff 75 10             	pushl  0x10(%ebp)
  801769:	ff 75 0c             	pushl  0xc(%ebp)
  80176c:	ff 75 08             	pushl  0x8(%ebp)
  80176f:	6a 13                	push   $0x13
  801771:	e8 7f fc ff ff       	call   8013f5 <syscall>
  801776:	83 c4 18             	add    $0x18,%esp
	return ;
  801779:	90                   	nop
}
  80177a:	c9                   	leave  
  80177b:	c3                   	ret    

0080177c <sys_rcr2>:
uint32 sys_rcr2()
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 1e                	push   $0x1e
  80178b:	e8 65 fc ff ff       	call   8013f5 <syscall>
  801790:	83 c4 18             	add    $0x18,%esp
}
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	83 ec 04             	sub    $0x4,%esp
  80179b:	8b 45 08             	mov    0x8(%ebp),%eax
  80179e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8017a1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	50                   	push   %eax
  8017ae:	6a 1f                	push   $0x1f
  8017b0:	e8 40 fc ff ff       	call   8013f5 <syscall>
  8017b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b8:	90                   	nop
}
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    

008017bb <rsttst>:
void rsttst()
{
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 21                	push   $0x21
  8017ca:	e8 26 fc ff ff       	call   8013f5 <syscall>
  8017cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d2:	90                   	nop
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	83 ec 04             	sub    $0x4,%esp
  8017db:	8b 45 14             	mov    0x14(%ebp),%eax
  8017de:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8017e1:	8b 55 18             	mov    0x18(%ebp),%edx
  8017e4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017e8:	52                   	push   %edx
  8017e9:	50                   	push   %eax
  8017ea:	ff 75 10             	pushl  0x10(%ebp)
  8017ed:	ff 75 0c             	pushl  0xc(%ebp)
  8017f0:	ff 75 08             	pushl  0x8(%ebp)
  8017f3:	6a 20                	push   $0x20
  8017f5:	e8 fb fb ff ff       	call   8013f5 <syscall>
  8017fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8017fd:	90                   	nop
}
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <chktst>:
void chktst(uint32 n)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	ff 75 08             	pushl  0x8(%ebp)
  80180e:	6a 22                	push   $0x22
  801810:	e8 e0 fb ff ff       	call   8013f5 <syscall>
  801815:	83 c4 18             	add    $0x18,%esp
	return ;
  801818:	90                   	nop
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <inctst>:

void inctst()
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 23                	push   $0x23
  80182a:	e8 c6 fb ff ff       	call   8013f5 <syscall>
  80182f:	83 c4 18             	add    $0x18,%esp
	return ;
  801832:	90                   	nop
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <gettst>:
uint32 gettst()
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 24                	push   $0x24
  801844:	e8 ac fb ff ff       	call   8013f5 <syscall>
  801849:	83 c4 18             	add    $0x18,%esp
}
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 25                	push   $0x25
  80185d:	e8 93 fb ff ff       	call   8013f5 <syscall>
  801862:	83 c4 18             	add    $0x18,%esp
  801865:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  80186a:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801874:	8b 45 08             	mov    0x8(%ebp),%eax
  801877:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	ff 75 08             	pushl  0x8(%ebp)
  801887:	6a 26                	push   $0x26
  801889:	e8 67 fb ff ff       	call   8013f5 <syscall>
  80188e:	83 c4 18             	add    $0x18,%esp
	return ;
  801891:	90                   	nop
}
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801898:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80189b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80189e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a4:	6a 00                	push   $0x0
  8018a6:	53                   	push   %ebx
  8018a7:	51                   	push   %ecx
  8018a8:	52                   	push   %edx
  8018a9:	50                   	push   %eax
  8018aa:	6a 27                	push   $0x27
  8018ac:	e8 44 fb ff ff       	call   8013f5 <syscall>
  8018b1:	83 c4 18             	add    $0x18,%esp
}
  8018b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	52                   	push   %edx
  8018c9:	50                   	push   %eax
  8018ca:	6a 28                	push   $0x28
  8018cc:	e8 24 fb ff ff       	call   8013f5 <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8018d9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	6a 00                	push   $0x0
  8018e4:	51                   	push   %ecx
  8018e5:	ff 75 10             	pushl  0x10(%ebp)
  8018e8:	52                   	push   %edx
  8018e9:	50                   	push   %eax
  8018ea:	6a 29                	push   $0x29
  8018ec:	e8 04 fb ff ff       	call   8013f5 <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
}
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	ff 75 10             	pushl  0x10(%ebp)
  801900:	ff 75 0c             	pushl  0xc(%ebp)
  801903:	ff 75 08             	pushl  0x8(%ebp)
  801906:	6a 12                	push   $0x12
  801908:	e8 e8 fa ff ff       	call   8013f5 <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
	return ;
  801910:	90                   	nop
}
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801916:	8b 55 0c             	mov    0xc(%ebp),%edx
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	52                   	push   %edx
  801923:	50                   	push   %eax
  801924:	6a 2a                	push   $0x2a
  801926:	e8 ca fa ff ff       	call   8013f5 <syscall>
  80192b:	83 c4 18             	add    $0x18,%esp
	return;
  80192e:	90                   	nop
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 2b                	push   $0x2b
  801940:	e8 b0 fa ff ff       	call   8013f5 <syscall>
  801945:	83 c4 18             	add    $0x18,%esp
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	ff 75 0c             	pushl  0xc(%ebp)
  801956:	ff 75 08             	pushl  0x8(%ebp)
  801959:	6a 2d                	push   $0x2d
  80195b:	e8 95 fa ff ff       	call   8013f5 <syscall>
  801960:	83 c4 18             	add    $0x18,%esp
	return;
  801963:	90                   	nop
}
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	ff 75 0c             	pushl  0xc(%ebp)
  801972:	ff 75 08             	pushl  0x8(%ebp)
  801975:	6a 2c                	push   $0x2c
  801977:	e8 79 fa ff ff       	call   8013f5 <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
	return ;
  80197f:	90                   	nop
}
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
  801985:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801988:	83 ec 04             	sub    $0x4,%esp
  80198b:	68 28 23 80 00       	push   $0x802328
  801990:	68 25 01 00 00       	push   $0x125
  801995:	68 5b 23 80 00       	push   $0x80235b
  80199a:	e8 a3 e8 ff ff       	call   800242 <_panic>
  80199f:	90                   	nop

008019a0 <__udivdi3>:
  8019a0:	55                   	push   %ebp
  8019a1:	57                   	push   %edi
  8019a2:	56                   	push   %esi
  8019a3:	53                   	push   %ebx
  8019a4:	83 ec 1c             	sub    $0x1c,%esp
  8019a7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019ab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019b7:	89 ca                	mov    %ecx,%edx
  8019b9:	89 f8                	mov    %edi,%eax
  8019bb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019bf:	85 f6                	test   %esi,%esi
  8019c1:	75 2d                	jne    8019f0 <__udivdi3+0x50>
  8019c3:	39 cf                	cmp    %ecx,%edi
  8019c5:	77 65                	ja     801a2c <__udivdi3+0x8c>
  8019c7:	89 fd                	mov    %edi,%ebp
  8019c9:	85 ff                	test   %edi,%edi
  8019cb:	75 0b                	jne    8019d8 <__udivdi3+0x38>
  8019cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8019d2:	31 d2                	xor    %edx,%edx
  8019d4:	f7 f7                	div    %edi
  8019d6:	89 c5                	mov    %eax,%ebp
  8019d8:	31 d2                	xor    %edx,%edx
  8019da:	89 c8                	mov    %ecx,%eax
  8019dc:	f7 f5                	div    %ebp
  8019de:	89 c1                	mov    %eax,%ecx
  8019e0:	89 d8                	mov    %ebx,%eax
  8019e2:	f7 f5                	div    %ebp
  8019e4:	89 cf                	mov    %ecx,%edi
  8019e6:	89 fa                	mov    %edi,%edx
  8019e8:	83 c4 1c             	add    $0x1c,%esp
  8019eb:	5b                   	pop    %ebx
  8019ec:	5e                   	pop    %esi
  8019ed:	5f                   	pop    %edi
  8019ee:	5d                   	pop    %ebp
  8019ef:	c3                   	ret    
  8019f0:	39 ce                	cmp    %ecx,%esi
  8019f2:	77 28                	ja     801a1c <__udivdi3+0x7c>
  8019f4:	0f bd fe             	bsr    %esi,%edi
  8019f7:	83 f7 1f             	xor    $0x1f,%edi
  8019fa:	75 40                	jne    801a3c <__udivdi3+0x9c>
  8019fc:	39 ce                	cmp    %ecx,%esi
  8019fe:	72 0a                	jb     801a0a <__udivdi3+0x6a>
  801a00:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a04:	0f 87 9e 00 00 00    	ja     801aa8 <__udivdi3+0x108>
  801a0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a0f:	89 fa                	mov    %edi,%edx
  801a11:	83 c4 1c             	add    $0x1c,%esp
  801a14:	5b                   	pop    %ebx
  801a15:	5e                   	pop    %esi
  801a16:	5f                   	pop    %edi
  801a17:	5d                   	pop    %ebp
  801a18:	c3                   	ret    
  801a19:	8d 76 00             	lea    0x0(%esi),%esi
  801a1c:	31 ff                	xor    %edi,%edi
  801a1e:	31 c0                	xor    %eax,%eax
  801a20:	89 fa                	mov    %edi,%edx
  801a22:	83 c4 1c             	add    $0x1c,%esp
  801a25:	5b                   	pop    %ebx
  801a26:	5e                   	pop    %esi
  801a27:	5f                   	pop    %edi
  801a28:	5d                   	pop    %ebp
  801a29:	c3                   	ret    
  801a2a:	66 90                	xchg   %ax,%ax
  801a2c:	89 d8                	mov    %ebx,%eax
  801a2e:	f7 f7                	div    %edi
  801a30:	31 ff                	xor    %edi,%edi
  801a32:	89 fa                	mov    %edi,%edx
  801a34:	83 c4 1c             	add    $0x1c,%esp
  801a37:	5b                   	pop    %ebx
  801a38:	5e                   	pop    %esi
  801a39:	5f                   	pop    %edi
  801a3a:	5d                   	pop    %ebp
  801a3b:	c3                   	ret    
  801a3c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a41:	89 eb                	mov    %ebp,%ebx
  801a43:	29 fb                	sub    %edi,%ebx
  801a45:	89 f9                	mov    %edi,%ecx
  801a47:	d3 e6                	shl    %cl,%esi
  801a49:	89 c5                	mov    %eax,%ebp
  801a4b:	88 d9                	mov    %bl,%cl
  801a4d:	d3 ed                	shr    %cl,%ebp
  801a4f:	89 e9                	mov    %ebp,%ecx
  801a51:	09 f1                	or     %esi,%ecx
  801a53:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a57:	89 f9                	mov    %edi,%ecx
  801a59:	d3 e0                	shl    %cl,%eax
  801a5b:	89 c5                	mov    %eax,%ebp
  801a5d:	89 d6                	mov    %edx,%esi
  801a5f:	88 d9                	mov    %bl,%cl
  801a61:	d3 ee                	shr    %cl,%esi
  801a63:	89 f9                	mov    %edi,%ecx
  801a65:	d3 e2                	shl    %cl,%edx
  801a67:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a6b:	88 d9                	mov    %bl,%cl
  801a6d:	d3 e8                	shr    %cl,%eax
  801a6f:	09 c2                	or     %eax,%edx
  801a71:	89 d0                	mov    %edx,%eax
  801a73:	89 f2                	mov    %esi,%edx
  801a75:	f7 74 24 0c          	divl   0xc(%esp)
  801a79:	89 d6                	mov    %edx,%esi
  801a7b:	89 c3                	mov    %eax,%ebx
  801a7d:	f7 e5                	mul    %ebp
  801a7f:	39 d6                	cmp    %edx,%esi
  801a81:	72 19                	jb     801a9c <__udivdi3+0xfc>
  801a83:	74 0b                	je     801a90 <__udivdi3+0xf0>
  801a85:	89 d8                	mov    %ebx,%eax
  801a87:	31 ff                	xor    %edi,%edi
  801a89:	e9 58 ff ff ff       	jmp    8019e6 <__udivdi3+0x46>
  801a8e:	66 90                	xchg   %ax,%ax
  801a90:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a94:	89 f9                	mov    %edi,%ecx
  801a96:	d3 e2                	shl    %cl,%edx
  801a98:	39 c2                	cmp    %eax,%edx
  801a9a:	73 e9                	jae    801a85 <__udivdi3+0xe5>
  801a9c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a9f:	31 ff                	xor    %edi,%edi
  801aa1:	e9 40 ff ff ff       	jmp    8019e6 <__udivdi3+0x46>
  801aa6:	66 90                	xchg   %ax,%ax
  801aa8:	31 c0                	xor    %eax,%eax
  801aaa:	e9 37 ff ff ff       	jmp    8019e6 <__udivdi3+0x46>
  801aaf:	90                   	nop

00801ab0 <__umoddi3>:
  801ab0:	55                   	push   %ebp
  801ab1:	57                   	push   %edi
  801ab2:	56                   	push   %esi
  801ab3:	53                   	push   %ebx
  801ab4:	83 ec 1c             	sub    $0x1c,%esp
  801ab7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801abb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801abf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ac3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ac7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801acb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801acf:	89 f3                	mov    %esi,%ebx
  801ad1:	89 fa                	mov    %edi,%edx
  801ad3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ad7:	89 34 24             	mov    %esi,(%esp)
  801ada:	85 c0                	test   %eax,%eax
  801adc:	75 1a                	jne    801af8 <__umoddi3+0x48>
  801ade:	39 f7                	cmp    %esi,%edi
  801ae0:	0f 86 a2 00 00 00    	jbe    801b88 <__umoddi3+0xd8>
  801ae6:	89 c8                	mov    %ecx,%eax
  801ae8:	89 f2                	mov    %esi,%edx
  801aea:	f7 f7                	div    %edi
  801aec:	89 d0                	mov    %edx,%eax
  801aee:	31 d2                	xor    %edx,%edx
  801af0:	83 c4 1c             	add    $0x1c,%esp
  801af3:	5b                   	pop    %ebx
  801af4:	5e                   	pop    %esi
  801af5:	5f                   	pop    %edi
  801af6:	5d                   	pop    %ebp
  801af7:	c3                   	ret    
  801af8:	39 f0                	cmp    %esi,%eax
  801afa:	0f 87 ac 00 00 00    	ja     801bac <__umoddi3+0xfc>
  801b00:	0f bd e8             	bsr    %eax,%ebp
  801b03:	83 f5 1f             	xor    $0x1f,%ebp
  801b06:	0f 84 ac 00 00 00    	je     801bb8 <__umoddi3+0x108>
  801b0c:	bf 20 00 00 00       	mov    $0x20,%edi
  801b11:	29 ef                	sub    %ebp,%edi
  801b13:	89 fe                	mov    %edi,%esi
  801b15:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b19:	89 e9                	mov    %ebp,%ecx
  801b1b:	d3 e0                	shl    %cl,%eax
  801b1d:	89 d7                	mov    %edx,%edi
  801b1f:	89 f1                	mov    %esi,%ecx
  801b21:	d3 ef                	shr    %cl,%edi
  801b23:	09 c7                	or     %eax,%edi
  801b25:	89 e9                	mov    %ebp,%ecx
  801b27:	d3 e2                	shl    %cl,%edx
  801b29:	89 14 24             	mov    %edx,(%esp)
  801b2c:	89 d8                	mov    %ebx,%eax
  801b2e:	d3 e0                	shl    %cl,%eax
  801b30:	89 c2                	mov    %eax,%edx
  801b32:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b36:	d3 e0                	shl    %cl,%eax
  801b38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b3c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b40:	89 f1                	mov    %esi,%ecx
  801b42:	d3 e8                	shr    %cl,%eax
  801b44:	09 d0                	or     %edx,%eax
  801b46:	d3 eb                	shr    %cl,%ebx
  801b48:	89 da                	mov    %ebx,%edx
  801b4a:	f7 f7                	div    %edi
  801b4c:	89 d3                	mov    %edx,%ebx
  801b4e:	f7 24 24             	mull   (%esp)
  801b51:	89 c6                	mov    %eax,%esi
  801b53:	89 d1                	mov    %edx,%ecx
  801b55:	39 d3                	cmp    %edx,%ebx
  801b57:	0f 82 87 00 00 00    	jb     801be4 <__umoddi3+0x134>
  801b5d:	0f 84 91 00 00 00    	je     801bf4 <__umoddi3+0x144>
  801b63:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b67:	29 f2                	sub    %esi,%edx
  801b69:	19 cb                	sbb    %ecx,%ebx
  801b6b:	89 d8                	mov    %ebx,%eax
  801b6d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b71:	d3 e0                	shl    %cl,%eax
  801b73:	89 e9                	mov    %ebp,%ecx
  801b75:	d3 ea                	shr    %cl,%edx
  801b77:	09 d0                	or     %edx,%eax
  801b79:	89 e9                	mov    %ebp,%ecx
  801b7b:	d3 eb                	shr    %cl,%ebx
  801b7d:	89 da                	mov    %ebx,%edx
  801b7f:	83 c4 1c             	add    $0x1c,%esp
  801b82:	5b                   	pop    %ebx
  801b83:	5e                   	pop    %esi
  801b84:	5f                   	pop    %edi
  801b85:	5d                   	pop    %ebp
  801b86:	c3                   	ret    
  801b87:	90                   	nop
  801b88:	89 fd                	mov    %edi,%ebp
  801b8a:	85 ff                	test   %edi,%edi
  801b8c:	75 0b                	jne    801b99 <__umoddi3+0xe9>
  801b8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b93:	31 d2                	xor    %edx,%edx
  801b95:	f7 f7                	div    %edi
  801b97:	89 c5                	mov    %eax,%ebp
  801b99:	89 f0                	mov    %esi,%eax
  801b9b:	31 d2                	xor    %edx,%edx
  801b9d:	f7 f5                	div    %ebp
  801b9f:	89 c8                	mov    %ecx,%eax
  801ba1:	f7 f5                	div    %ebp
  801ba3:	89 d0                	mov    %edx,%eax
  801ba5:	e9 44 ff ff ff       	jmp    801aee <__umoddi3+0x3e>
  801baa:	66 90                	xchg   %ax,%ax
  801bac:	89 c8                	mov    %ecx,%eax
  801bae:	89 f2                	mov    %esi,%edx
  801bb0:	83 c4 1c             	add    $0x1c,%esp
  801bb3:	5b                   	pop    %ebx
  801bb4:	5e                   	pop    %esi
  801bb5:	5f                   	pop    %edi
  801bb6:	5d                   	pop    %ebp
  801bb7:	c3                   	ret    
  801bb8:	3b 04 24             	cmp    (%esp),%eax
  801bbb:	72 06                	jb     801bc3 <__umoddi3+0x113>
  801bbd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bc1:	77 0f                	ja     801bd2 <__umoddi3+0x122>
  801bc3:	89 f2                	mov    %esi,%edx
  801bc5:	29 f9                	sub    %edi,%ecx
  801bc7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801bcb:	89 14 24             	mov    %edx,(%esp)
  801bce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bd2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bd6:	8b 14 24             	mov    (%esp),%edx
  801bd9:	83 c4 1c             	add    $0x1c,%esp
  801bdc:	5b                   	pop    %ebx
  801bdd:	5e                   	pop    %esi
  801bde:	5f                   	pop    %edi
  801bdf:	5d                   	pop    %ebp
  801be0:	c3                   	ret    
  801be1:	8d 76 00             	lea    0x0(%esi),%esi
  801be4:	2b 04 24             	sub    (%esp),%eax
  801be7:	19 fa                	sbb    %edi,%edx
  801be9:	89 d1                	mov    %edx,%ecx
  801beb:	89 c6                	mov    %eax,%esi
  801bed:	e9 71 ff ff ff       	jmp    801b63 <__umoddi3+0xb3>
  801bf2:	66 90                	xchg   %ax,%ax
  801bf4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bf8:	72 ea                	jb     801be4 <__umoddi3+0x134>
  801bfa:	89 d9                	mov    %ebx,%ecx
  801bfc:	e9 62 ff ff ff       	jmp    801b63 <__umoddi3+0xb3>

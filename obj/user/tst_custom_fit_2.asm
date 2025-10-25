
obj/user/tst_custom_fit_2:     file format elf32-i386


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
  800031:	e8 a4 00 00 00       	call   8000da <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <check_dynalloc_datastruct>:
#define USER_TST_UTILITIES_H_
#include <inc/types.h>
#include <inc/stdio.h>

int check_dynalloc_datastruct(void* va, void* expectedVA, uint32 expectedSize, uint8 expectedFlag)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
  80003e:	8b 45 14             	mov    0x14(%ebp),%eax
  800041:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//Check returned va
	if(va != expectedVA)
  800044:	8b 45 08             	mov    0x8(%ebp),%eax
  800047:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80004a:	74 1d                	je     800069 <check_dynalloc_datastruct+0x31>
	{
		cprintf("wrong block address. Expected %x, Actual %x\n", expectedVA, va);
  80004c:	83 ec 04             	sub    $0x4,%esp
  80004f:	ff 75 08             	pushl  0x8(%ebp)
  800052:	ff 75 0c             	pushl  0xc(%ebp)
  800055:	68 60 1c 80 00       	push   $0x801c60
  80005a:	e8 f9 04 00 00       	call   800558 <cprintf>
  80005f:	83 c4 10             	add    $0x10,%esp
		return 0;
  800062:	b8 00 00 00 00       	mov    $0x0,%eax
  800067:	eb 55                	jmp    8000be <check_dynalloc_datastruct+0x86>
	}
	//Check header & footer
	uint32 header = *((uint32*)va-1);
  800069:	8b 45 08             	mov    0x8(%ebp),%eax
  80006c:	8b 40 fc             	mov    -0x4(%eax),%eax
  80006f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 footer = *((uint32*)(va + expectedSize - 8));
  800072:	8b 45 10             	mov    0x10(%ebp),%eax
  800075:	8d 50 f8             	lea    -0x8(%eax),%edx
  800078:	8b 45 08             	mov    0x8(%ebp),%eax
  80007b:	01 d0                	add    %edx,%eax
  80007d:	8b 00                	mov    (%eax),%eax
  80007f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 expectedData = expectedSize | expectedFlag ;
  800082:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  800086:	0b 45 10             	or     0x10(%ebp),%eax
  800089:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(header != expectedData || footer != expectedData)
  80008c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80008f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800092:	75 08                	jne    80009c <check_dynalloc_datastruct+0x64>
  800094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800097:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80009a:	74 1d                	je     8000b9 <check_dynalloc_datastruct+0x81>
	{
		cprintf("wrong header/footer data. Expected %d, Actual H:%d F:%d\n", expectedData, header, footer);
  80009c:	ff 75 f0             	pushl  -0x10(%ebp)
  80009f:	ff 75 f4             	pushl  -0xc(%ebp)
  8000a2:	ff 75 ec             	pushl  -0x14(%ebp)
  8000a5:	68 90 1c 80 00       	push   $0x801c90
  8000aa:	e8 a9 04 00 00       	call   800558 <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
		return 0;
  8000b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b7:	eb 05                	jmp    8000be <check_dynalloc_datastruct+0x86>
	}
	return 1;
  8000b9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8000be:	c9                   	leave  
  8000bf:	c3                   	ret    

008000c0 <_main>:
short* startVAs[numOfAllocs*allocCntPerSize+1] ;
short* midVAs[numOfAllocs*allocCntPerSize+1] ;
short* endVAs[numOfAllocs*allocCntPerSize+1] ;

void _main(void)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	83 ec 68             	sub    $0x68,%esp
	panic("update is required!!");
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	68 c9 1c 80 00       	push   $0x801cc9
  8000ce:	6a 19                	push   $0x19
  8000d0:	68 de 1c 80 00       	push   $0x801cde
  8000d5:	e8 b0 01 00 00       	call   80028a <_panic>

008000da <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000da:	55                   	push   %ebp
  8000db:	89 e5                	mov    %esp,%ebp
  8000dd:	57                   	push   %edi
  8000de:	56                   	push   %esi
  8000df:	53                   	push   %ebx
  8000e0:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000e3:	e8 3d 16 00 00       	call   801725 <sys_getenvindex>
  8000e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000ee:	89 d0                	mov    %edx,%eax
  8000f0:	c1 e0 02             	shl    $0x2,%eax
  8000f3:	01 d0                	add    %edx,%eax
  8000f5:	c1 e0 03             	shl    $0x3,%eax
  8000f8:	01 d0                	add    %edx,%eax
  8000fa:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800101:	01 d0                	add    %edx,%eax
  800103:	c1 e0 02             	shl    $0x2,%eax
  800106:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80010b:	a3 40 30 80 00       	mov    %eax,0x803040

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800110:	a1 40 30 80 00       	mov    0x803040,%eax
  800115:	8a 40 20             	mov    0x20(%eax),%al
  800118:	84 c0                	test   %al,%al
  80011a:	74 0d                	je     800129 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80011c:	a1 40 30 80 00       	mov    0x803040,%eax
  800121:	83 c0 20             	add    $0x20,%eax
  800124:	a3 20 30 80 00       	mov    %eax,0x803020

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800129:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80012d:	7e 0a                	jle    800139 <libmain+0x5f>
		binaryname = argv[0];
  80012f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800132:	8b 00                	mov    (%eax),%eax
  800134:	a3 20 30 80 00       	mov    %eax,0x803020

	// call user main routine
	_main(argc, argv);
  800139:	83 ec 08             	sub    $0x8,%esp
  80013c:	ff 75 0c             	pushl  0xc(%ebp)
  80013f:	ff 75 08             	pushl  0x8(%ebp)
  800142:	e8 79 ff ff ff       	call   8000c0 <_main>
  800147:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80014a:	a1 1c 30 80 00       	mov    0x80301c,%eax
  80014f:	85 c0                	test   %eax,%eax
  800151:	0f 84 01 01 00 00    	je     800258 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800157:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80015d:	bb f0 1d 80 00       	mov    $0x801df0,%ebx
  800162:	ba 0e 00 00 00       	mov    $0xe,%edx
  800167:	89 c7                	mov    %eax,%edi
  800169:	89 de                	mov    %ebx,%esi
  80016b:	89 d1                	mov    %edx,%ecx
  80016d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80016f:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800172:	b9 56 00 00 00       	mov    $0x56,%ecx
  800177:	b0 00                	mov    $0x0,%al
  800179:	89 d7                	mov    %edx,%edi
  80017b:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80017d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800184:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800187:	83 ec 08             	sub    $0x8,%esp
  80018a:	50                   	push   %eax
  80018b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800191:	50                   	push   %eax
  800192:	e8 c4 17 00 00       	call   80195b <sys_utilities>
  800197:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80019a:	e8 0d 13 00 00       	call   8014ac <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80019f:	83 ec 0c             	sub    $0xc,%esp
  8001a2:	68 10 1d 80 00       	push   $0x801d10
  8001a7:	e8 ac 03 00 00       	call   800558 <cprintf>
  8001ac:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001b2:	85 c0                	test   %eax,%eax
  8001b4:	74 18                	je     8001ce <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001b6:	e8 be 17 00 00       	call   801979 <sys_get_optimal_num_faults>
  8001bb:	83 ec 08             	sub    $0x8,%esp
  8001be:	50                   	push   %eax
  8001bf:	68 38 1d 80 00       	push   $0x801d38
  8001c4:	e8 8f 03 00 00       	call   800558 <cprintf>
  8001c9:	83 c4 10             	add    $0x10,%esp
  8001cc:	eb 59                	jmp    800227 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001ce:	a1 40 30 80 00       	mov    0x803040,%eax
  8001d3:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8001d9:	a1 40 30 80 00       	mov    0x803040,%eax
  8001de:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8001e4:	83 ec 04             	sub    $0x4,%esp
  8001e7:	52                   	push   %edx
  8001e8:	50                   	push   %eax
  8001e9:	68 5c 1d 80 00       	push   $0x801d5c
  8001ee:	e8 65 03 00 00       	call   800558 <cprintf>
  8001f3:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f6:	a1 40 30 80 00       	mov    0x803040,%eax
  8001fb:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800201:	a1 40 30 80 00       	mov    0x803040,%eax
  800206:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80020c:	a1 40 30 80 00       	mov    0x803040,%eax
  800211:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800217:	51                   	push   %ecx
  800218:	52                   	push   %edx
  800219:	50                   	push   %eax
  80021a:	68 84 1d 80 00       	push   $0x801d84
  80021f:	e8 34 03 00 00       	call   800558 <cprintf>
  800224:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800227:	a1 40 30 80 00       	mov    0x803040,%eax
  80022c:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800232:	83 ec 08             	sub    $0x8,%esp
  800235:	50                   	push   %eax
  800236:	68 dc 1d 80 00       	push   $0x801ddc
  80023b:	e8 18 03 00 00       	call   800558 <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800243:	83 ec 0c             	sub    $0xc,%esp
  800246:	68 10 1d 80 00       	push   $0x801d10
  80024b:	e8 08 03 00 00       	call   800558 <cprintf>
  800250:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800253:	e8 6e 12 00 00       	call   8014c6 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800258:	e8 1f 00 00 00       	call   80027c <exit>
}
  80025d:	90                   	nop
  80025e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800261:	5b                   	pop    %ebx
  800262:	5e                   	pop    %esi
  800263:	5f                   	pop    %edi
  800264:	5d                   	pop    %ebp
  800265:	c3                   	ret    

00800266 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	6a 00                	push   $0x0
  800271:	e8 7b 14 00 00       	call   8016f1 <sys_destroy_env>
  800276:	83 c4 10             	add    $0x10,%esp
}
  800279:	90                   	nop
  80027a:	c9                   	leave  
  80027b:	c3                   	ret    

0080027c <exit>:

void
exit(void)
{
  80027c:	55                   	push   %ebp
  80027d:	89 e5                	mov    %esp,%ebp
  80027f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800282:	e8 d0 14 00 00       	call   801757 <sys_exit_env>
}
  800287:	90                   	nop
  800288:	c9                   	leave  
  800289:	c3                   	ret    

0080028a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800290:	8d 45 10             	lea    0x10(%ebp),%eax
  800293:	83 c0 04             	add    $0x4,%eax
  800296:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800299:	a1 38 f3 81 00       	mov    0x81f338,%eax
  80029e:	85 c0                	test   %eax,%eax
  8002a0:	74 16                	je     8002b8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002a2:	a1 38 f3 81 00       	mov    0x81f338,%eax
  8002a7:	83 ec 08             	sub    $0x8,%esp
  8002aa:	50                   	push   %eax
  8002ab:	68 54 1e 80 00       	push   $0x801e54
  8002b0:	e8 a3 02 00 00       	call   800558 <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8002b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8002bd:	83 ec 0c             	sub    $0xc,%esp
  8002c0:	ff 75 0c             	pushl  0xc(%ebp)
  8002c3:	ff 75 08             	pushl  0x8(%ebp)
  8002c6:	50                   	push   %eax
  8002c7:	68 5c 1e 80 00       	push   $0x801e5c
  8002cc:	6a 74                	push   $0x74
  8002ce:	e8 b2 02 00 00       	call   800585 <cprintf_colored>
  8002d3:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8002d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d9:	83 ec 08             	sub    $0x8,%esp
  8002dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8002df:	50                   	push   %eax
  8002e0:	e8 04 02 00 00       	call   8004e9 <vcprintf>
  8002e5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002e8:	83 ec 08             	sub    $0x8,%esp
  8002eb:	6a 00                	push   $0x0
  8002ed:	68 84 1e 80 00       	push   $0x801e84
  8002f2:	e8 f2 01 00 00       	call   8004e9 <vcprintf>
  8002f7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002fa:	e8 7d ff ff ff       	call   80027c <exit>

	// should not return here
	while (1) ;
  8002ff:	eb fe                	jmp    8002ff <_panic+0x75>

00800301 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800301:	55                   	push   %ebp
  800302:	89 e5                	mov    %esp,%ebp
  800304:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800307:	a1 40 30 80 00       	mov    0x803040,%eax
  80030c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800312:	8b 45 0c             	mov    0xc(%ebp),%eax
  800315:	39 c2                	cmp    %eax,%edx
  800317:	74 14                	je     80032d <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800319:	83 ec 04             	sub    $0x4,%esp
  80031c:	68 88 1e 80 00       	push   $0x801e88
  800321:	6a 26                	push   $0x26
  800323:	68 d4 1e 80 00       	push   $0x801ed4
  800328:	e8 5d ff ff ff       	call   80028a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80032d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800334:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80033b:	e9 c5 00 00 00       	jmp    800405 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800343:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034a:	8b 45 08             	mov    0x8(%ebp),%eax
  80034d:	01 d0                	add    %edx,%eax
  80034f:	8b 00                	mov    (%eax),%eax
  800351:	85 c0                	test   %eax,%eax
  800353:	75 08                	jne    80035d <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800355:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800358:	e9 a5 00 00 00       	jmp    800402 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80035d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800364:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80036b:	eb 69                	jmp    8003d6 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80036d:	a1 40 30 80 00       	mov    0x803040,%eax
  800372:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800378:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80037b:	89 d0                	mov    %edx,%eax
  80037d:	01 c0                	add    %eax,%eax
  80037f:	01 d0                	add    %edx,%eax
  800381:	c1 e0 03             	shl    $0x3,%eax
  800384:	01 c8                	add    %ecx,%eax
  800386:	8a 40 04             	mov    0x4(%eax),%al
  800389:	84 c0                	test   %al,%al
  80038b:	75 46                	jne    8003d3 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80038d:	a1 40 30 80 00       	mov    0x803040,%eax
  800392:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800398:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80039b:	89 d0                	mov    %edx,%eax
  80039d:	01 c0                	add    %eax,%eax
  80039f:	01 d0                	add    %edx,%eax
  8003a1:	c1 e0 03             	shl    $0x3,%eax
  8003a4:	01 c8                	add    %ecx,%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003b3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c2:	01 c8                	add    %ecx,%eax
  8003c4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003c6:	39 c2                	cmp    %eax,%edx
  8003c8:	75 09                	jne    8003d3 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003ca:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003d1:	eb 15                	jmp    8003e8 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d3:	ff 45 e8             	incl   -0x18(%ebp)
  8003d6:	a1 40 30 80 00       	mov    0x803040,%eax
  8003db:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003e4:	39 c2                	cmp    %eax,%edx
  8003e6:	77 85                	ja     80036d <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003ec:	75 14                	jne    800402 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003ee:	83 ec 04             	sub    $0x4,%esp
  8003f1:	68 e0 1e 80 00       	push   $0x801ee0
  8003f6:	6a 3a                	push   $0x3a
  8003f8:	68 d4 1e 80 00       	push   $0x801ed4
  8003fd:	e8 88 fe ff ff       	call   80028a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800402:	ff 45 f0             	incl   -0x10(%ebp)
  800405:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800408:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80040b:	0f 8c 2f ff ff ff    	jl     800340 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800411:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800418:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80041f:	eb 26                	jmp    800447 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800421:	a1 40 30 80 00       	mov    0x803040,%eax
  800426:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80042c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80042f:	89 d0                	mov    %edx,%eax
  800431:	01 c0                	add    %eax,%eax
  800433:	01 d0                	add    %edx,%eax
  800435:	c1 e0 03             	shl    $0x3,%eax
  800438:	01 c8                	add    %ecx,%eax
  80043a:	8a 40 04             	mov    0x4(%eax),%al
  80043d:	3c 01                	cmp    $0x1,%al
  80043f:	75 03                	jne    800444 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800441:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800444:	ff 45 e0             	incl   -0x20(%ebp)
  800447:	a1 40 30 80 00       	mov    0x803040,%eax
  80044c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800452:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800455:	39 c2                	cmp    %eax,%edx
  800457:	77 c8                	ja     800421 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80045c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80045f:	74 14                	je     800475 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800461:	83 ec 04             	sub    $0x4,%esp
  800464:	68 34 1f 80 00       	push   $0x801f34
  800469:	6a 44                	push   $0x44
  80046b:	68 d4 1e 80 00       	push   $0x801ed4
  800470:	e8 15 fe ff ff       	call   80028a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800475:	90                   	nop
  800476:	c9                   	leave  
  800477:	c3                   	ret    

00800478 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800478:	55                   	push   %ebp
  800479:	89 e5                	mov    %esp,%ebp
  80047b:	53                   	push   %ebx
  80047c:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80047f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800482:	8b 00                	mov    (%eax),%eax
  800484:	8d 48 01             	lea    0x1(%eax),%ecx
  800487:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048a:	89 0a                	mov    %ecx,(%edx)
  80048c:	8b 55 08             	mov    0x8(%ebp),%edx
  80048f:	88 d1                	mov    %dl,%cl
  800491:	8b 55 0c             	mov    0xc(%ebp),%edx
  800494:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800498:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004a2:	75 30                	jne    8004d4 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004a4:	8b 15 3c f3 81 00    	mov    0x81f33c,%edx
  8004aa:	a0 64 30 80 00       	mov    0x803064,%al
  8004af:	0f b6 c0             	movzbl %al,%eax
  8004b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004b5:	8b 09                	mov    (%ecx),%ecx
  8004b7:	89 cb                	mov    %ecx,%ebx
  8004b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004bc:	83 c1 08             	add    $0x8,%ecx
  8004bf:	52                   	push   %edx
  8004c0:	50                   	push   %eax
  8004c1:	53                   	push   %ebx
  8004c2:	51                   	push   %ecx
  8004c3:	e8 a0 0f 00 00       	call   801468 <sys_cputs>
  8004c8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d7:	8b 40 04             	mov    0x4(%eax),%eax
  8004da:	8d 50 01             	lea    0x1(%eax),%edx
  8004dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e0:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004e3:	90                   	nop
  8004e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004e7:	c9                   	leave  
  8004e8:	c3                   	ret    

008004e9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004e9:	55                   	push   %ebp
  8004ea:	89 e5                	mov    %esp,%ebp
  8004ec:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004f2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004f9:	00 00 00 
	b.cnt = 0;
  8004fc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800503:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800506:	ff 75 0c             	pushl  0xc(%ebp)
  800509:	ff 75 08             	pushl  0x8(%ebp)
  80050c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800512:	50                   	push   %eax
  800513:	68 78 04 80 00       	push   $0x800478
  800518:	e8 5a 02 00 00       	call   800777 <vprintfmt>
  80051d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800520:	8b 15 3c f3 81 00    	mov    0x81f33c,%edx
  800526:	a0 64 30 80 00       	mov    0x803064,%al
  80052b:	0f b6 c0             	movzbl %al,%eax
  80052e:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800534:	52                   	push   %edx
  800535:	50                   	push   %eax
  800536:	51                   	push   %ecx
  800537:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80053d:	83 c0 08             	add    $0x8,%eax
  800540:	50                   	push   %eax
  800541:	e8 22 0f 00 00       	call   801468 <sys_cputs>
  800546:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800549:	c6 05 64 30 80 00 00 	movb   $0x0,0x803064
	return b.cnt;
  800550:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800556:	c9                   	leave  
  800557:	c3                   	ret    

00800558 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800558:	55                   	push   %ebp
  800559:	89 e5                	mov    %esp,%ebp
  80055b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80055e:	c6 05 64 30 80 00 01 	movb   $0x1,0x803064
	va_start(ap, fmt);
  800565:	8d 45 0c             	lea    0xc(%ebp),%eax
  800568:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80056b:	8b 45 08             	mov    0x8(%ebp),%eax
  80056e:	83 ec 08             	sub    $0x8,%esp
  800571:	ff 75 f4             	pushl  -0xc(%ebp)
  800574:	50                   	push   %eax
  800575:	e8 6f ff ff ff       	call   8004e9 <vcprintf>
  80057a:	83 c4 10             	add    $0x10,%esp
  80057d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800580:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800583:	c9                   	leave  
  800584:	c3                   	ret    

00800585 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800585:	55                   	push   %ebp
  800586:	89 e5                	mov    %esp,%ebp
  800588:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80058b:	c6 05 64 30 80 00 01 	movb   $0x1,0x803064
	curTextClr = (textClr << 8) ; //set text color by the given value
  800592:	8b 45 08             	mov    0x8(%ebp),%eax
  800595:	c1 e0 08             	shl    $0x8,%eax
  800598:	a3 3c f3 81 00       	mov    %eax,0x81f33c
	va_start(ap, fmt);
  80059d:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a0:	83 c0 04             	add    $0x4,%eax
  8005a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8005af:	50                   	push   %eax
  8005b0:	e8 34 ff ff ff       	call   8004e9 <vcprintf>
  8005b5:	83 c4 10             	add    $0x10,%esp
  8005b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8005bb:	c7 05 3c f3 81 00 00 	movl   $0x700,0x81f33c
  8005c2:	07 00 00 

	return cnt;
  8005c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c8:	c9                   	leave  
  8005c9:	c3                   	ret    

008005ca <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8005ca:	55                   	push   %ebp
  8005cb:	89 e5                	mov    %esp,%ebp
  8005cd:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8005d0:	e8 d7 0e 00 00       	call   8014ac <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005d5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	83 ec 08             	sub    $0x8,%esp
  8005e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e4:	50                   	push   %eax
  8005e5:	e8 ff fe ff ff       	call   8004e9 <vcprintf>
  8005ea:	83 c4 10             	add    $0x10,%esp
  8005ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8005f0:	e8 d1 0e 00 00       	call   8014c6 <sys_unlock_cons>
	return cnt;
  8005f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f8:	c9                   	leave  
  8005f9:	c3                   	ret    

008005fa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005fa:	55                   	push   %ebp
  8005fb:	89 e5                	mov    %esp,%ebp
  8005fd:	53                   	push   %ebx
  8005fe:	83 ec 14             	sub    $0x14,%esp
  800601:	8b 45 10             	mov    0x10(%ebp),%eax
  800604:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800607:	8b 45 14             	mov    0x14(%ebp),%eax
  80060a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80060d:	8b 45 18             	mov    0x18(%ebp),%eax
  800610:	ba 00 00 00 00       	mov    $0x0,%edx
  800615:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800618:	77 55                	ja     80066f <printnum+0x75>
  80061a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80061d:	72 05                	jb     800624 <printnum+0x2a>
  80061f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800622:	77 4b                	ja     80066f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800624:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800627:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80062a:	8b 45 18             	mov    0x18(%ebp),%eax
  80062d:	ba 00 00 00 00       	mov    $0x0,%edx
  800632:	52                   	push   %edx
  800633:	50                   	push   %eax
  800634:	ff 75 f4             	pushl  -0xc(%ebp)
  800637:	ff 75 f0             	pushl  -0x10(%ebp)
  80063a:	e8 a9 13 00 00       	call   8019e8 <__udivdi3>
  80063f:	83 c4 10             	add    $0x10,%esp
  800642:	83 ec 04             	sub    $0x4,%esp
  800645:	ff 75 20             	pushl  0x20(%ebp)
  800648:	53                   	push   %ebx
  800649:	ff 75 18             	pushl  0x18(%ebp)
  80064c:	52                   	push   %edx
  80064d:	50                   	push   %eax
  80064e:	ff 75 0c             	pushl  0xc(%ebp)
  800651:	ff 75 08             	pushl  0x8(%ebp)
  800654:	e8 a1 ff ff ff       	call   8005fa <printnum>
  800659:	83 c4 20             	add    $0x20,%esp
  80065c:	eb 1a                	jmp    800678 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80065e:	83 ec 08             	sub    $0x8,%esp
  800661:	ff 75 0c             	pushl  0xc(%ebp)
  800664:	ff 75 20             	pushl  0x20(%ebp)
  800667:	8b 45 08             	mov    0x8(%ebp),%eax
  80066a:	ff d0                	call   *%eax
  80066c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80066f:	ff 4d 1c             	decl   0x1c(%ebp)
  800672:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800676:	7f e6                	jg     80065e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800678:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80067b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800683:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800686:	53                   	push   %ebx
  800687:	51                   	push   %ecx
  800688:	52                   	push   %edx
  800689:	50                   	push   %eax
  80068a:	e8 69 14 00 00       	call   801af8 <__umoddi3>
  80068f:	83 c4 10             	add    $0x10,%esp
  800692:	05 94 21 80 00       	add    $0x802194,%eax
  800697:	8a 00                	mov    (%eax),%al
  800699:	0f be c0             	movsbl %al,%eax
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	ff 75 0c             	pushl  0xc(%ebp)
  8006a2:	50                   	push   %eax
  8006a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a6:	ff d0                	call   *%eax
  8006a8:	83 c4 10             	add    $0x10,%esp
}
  8006ab:	90                   	nop
  8006ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006af:	c9                   	leave  
  8006b0:	c3                   	ret    

008006b1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006b1:	55                   	push   %ebp
  8006b2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b8:	7e 1c                	jle    8006d6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	8d 50 08             	lea    0x8(%eax),%edx
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	89 10                	mov    %edx,(%eax)
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	83 e8 08             	sub    $0x8,%eax
  8006cf:	8b 50 04             	mov    0x4(%eax),%edx
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	eb 40                	jmp    800716 <getuint+0x65>
	else if (lflag)
  8006d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006da:	74 1e                	je     8006fa <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	8d 50 04             	lea    0x4(%eax),%edx
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	89 10                	mov    %edx,(%eax)
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	83 e8 04             	sub    $0x4,%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f8:	eb 1c                	jmp    800716 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	8d 50 04             	lea    0x4(%eax),%edx
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	89 10                	mov    %edx,(%eax)
  800707:	8b 45 08             	mov    0x8(%ebp),%eax
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	83 e8 04             	sub    $0x4,%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800716:	5d                   	pop    %ebp
  800717:	c3                   	ret    

00800718 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800718:	55                   	push   %ebp
  800719:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80071b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80071f:	7e 1c                	jle    80073d <getint+0x25>
		return va_arg(*ap, long long);
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	8d 50 08             	lea    0x8(%eax),%edx
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	89 10                	mov    %edx,(%eax)
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	8b 00                	mov    (%eax),%eax
  800733:	83 e8 08             	sub    $0x8,%eax
  800736:	8b 50 04             	mov    0x4(%eax),%edx
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	eb 38                	jmp    800775 <getint+0x5d>
	else if (lflag)
  80073d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800741:	74 1a                	je     80075d <getint+0x45>
		return va_arg(*ap, long);
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	8d 50 04             	lea    0x4(%eax),%edx
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	89 10                	mov    %edx,(%eax)
  800750:	8b 45 08             	mov    0x8(%ebp),%eax
  800753:	8b 00                	mov    (%eax),%eax
  800755:	83 e8 04             	sub    $0x4,%eax
  800758:	8b 00                	mov    (%eax),%eax
  80075a:	99                   	cltd   
  80075b:	eb 18                	jmp    800775 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	8d 50 04             	lea    0x4(%eax),%edx
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	89 10                	mov    %edx,(%eax)
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	83 e8 04             	sub    $0x4,%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	99                   	cltd   
}
  800775:	5d                   	pop    %ebp
  800776:	c3                   	ret    

00800777 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
  80077a:	56                   	push   %esi
  80077b:	53                   	push   %ebx
  80077c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077f:	eb 17                	jmp    800798 <vprintfmt+0x21>
			if (ch == '\0')
  800781:	85 db                	test   %ebx,%ebx
  800783:	0f 84 c1 03 00 00    	je     800b4a <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	53                   	push   %ebx
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	ff d0                	call   *%eax
  800795:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800798:	8b 45 10             	mov    0x10(%ebp),%eax
  80079b:	8d 50 01             	lea    0x1(%eax),%edx
  80079e:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a1:	8a 00                	mov    (%eax),%al
  8007a3:	0f b6 d8             	movzbl %al,%ebx
  8007a6:	83 fb 25             	cmp    $0x25,%ebx
  8007a9:	75 d6                	jne    800781 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007ab:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007af:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007b6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007c4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ce:	8d 50 01             	lea    0x1(%eax),%edx
  8007d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8007d4:	8a 00                	mov    (%eax),%al
  8007d6:	0f b6 d8             	movzbl %al,%ebx
  8007d9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007dc:	83 f8 5b             	cmp    $0x5b,%eax
  8007df:	0f 87 3d 03 00 00    	ja     800b22 <vprintfmt+0x3ab>
  8007e5:	8b 04 85 b8 21 80 00 	mov    0x8021b8(,%eax,4),%eax
  8007ec:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007ee:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007f2:	eb d7                	jmp    8007cb <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007f4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007f8:	eb d1                	jmp    8007cb <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800801:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800804:	89 d0                	mov    %edx,%eax
  800806:	c1 e0 02             	shl    $0x2,%eax
  800809:	01 d0                	add    %edx,%eax
  80080b:	01 c0                	add    %eax,%eax
  80080d:	01 d8                	add    %ebx,%eax
  80080f:	83 e8 30             	sub    $0x30,%eax
  800812:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800815:	8b 45 10             	mov    0x10(%ebp),%eax
  800818:	8a 00                	mov    (%eax),%al
  80081a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80081d:	83 fb 2f             	cmp    $0x2f,%ebx
  800820:	7e 3e                	jle    800860 <vprintfmt+0xe9>
  800822:	83 fb 39             	cmp    $0x39,%ebx
  800825:	7f 39                	jg     800860 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800827:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80082a:	eb d5                	jmp    800801 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	83 c0 04             	add    $0x4,%eax
  800832:	89 45 14             	mov    %eax,0x14(%ebp)
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	83 e8 04             	sub    $0x4,%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800840:	eb 1f                	jmp    800861 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800842:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800846:	79 83                	jns    8007cb <vprintfmt+0x54>
				width = 0;
  800848:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80084f:	e9 77 ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800854:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80085b:	e9 6b ff ff ff       	jmp    8007cb <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800860:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800861:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800865:	0f 89 60 ff ff ff    	jns    8007cb <vprintfmt+0x54>
				width = precision, precision = -1;
  80086b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80086e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800871:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800878:	e9 4e ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80087d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800880:	e9 46 ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	83 c0 04             	add    $0x4,%eax
  80088b:	89 45 14             	mov    %eax,0x14(%ebp)
  80088e:	8b 45 14             	mov    0x14(%ebp),%eax
  800891:	83 e8 04             	sub    $0x4,%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	83 ec 08             	sub    $0x8,%esp
  800899:	ff 75 0c             	pushl  0xc(%ebp)
  80089c:	50                   	push   %eax
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	ff d0                	call   *%eax
  8008a2:	83 c4 10             	add    $0x10,%esp
			break;
  8008a5:	e9 9b 02 00 00       	jmp    800b45 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	83 c0 04             	add    $0x4,%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	83 e8 04             	sub    $0x4,%eax
  8008b9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008bb:	85 db                	test   %ebx,%ebx
  8008bd:	79 02                	jns    8008c1 <vprintfmt+0x14a>
				err = -err;
  8008bf:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008c1:	83 fb 64             	cmp    $0x64,%ebx
  8008c4:	7f 0b                	jg     8008d1 <vprintfmt+0x15a>
  8008c6:	8b 34 9d 00 20 80 00 	mov    0x802000(,%ebx,4),%esi
  8008cd:	85 f6                	test   %esi,%esi
  8008cf:	75 19                	jne    8008ea <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008d1:	53                   	push   %ebx
  8008d2:	68 a5 21 80 00       	push   $0x8021a5
  8008d7:	ff 75 0c             	pushl  0xc(%ebp)
  8008da:	ff 75 08             	pushl  0x8(%ebp)
  8008dd:	e8 70 02 00 00       	call   800b52 <printfmt>
  8008e2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008e5:	e9 5b 02 00 00       	jmp    800b45 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008ea:	56                   	push   %esi
  8008eb:	68 ae 21 80 00       	push   $0x8021ae
  8008f0:	ff 75 0c             	pushl  0xc(%ebp)
  8008f3:	ff 75 08             	pushl  0x8(%ebp)
  8008f6:	e8 57 02 00 00       	call   800b52 <printfmt>
  8008fb:	83 c4 10             	add    $0x10,%esp
			break;
  8008fe:	e9 42 02 00 00       	jmp    800b45 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800903:	8b 45 14             	mov    0x14(%ebp),%eax
  800906:	83 c0 04             	add    $0x4,%eax
  800909:	89 45 14             	mov    %eax,0x14(%ebp)
  80090c:	8b 45 14             	mov    0x14(%ebp),%eax
  80090f:	83 e8 04             	sub    $0x4,%eax
  800912:	8b 30                	mov    (%eax),%esi
  800914:	85 f6                	test   %esi,%esi
  800916:	75 05                	jne    80091d <vprintfmt+0x1a6>
				p = "(null)";
  800918:	be b1 21 80 00       	mov    $0x8021b1,%esi
			if (width > 0 && padc != '-')
  80091d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800921:	7e 6d                	jle    800990 <vprintfmt+0x219>
  800923:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800927:	74 67                	je     800990 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800929:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092c:	83 ec 08             	sub    $0x8,%esp
  80092f:	50                   	push   %eax
  800930:	56                   	push   %esi
  800931:	e8 1e 03 00 00       	call   800c54 <strnlen>
  800936:	83 c4 10             	add    $0x10,%esp
  800939:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80093c:	eb 16                	jmp    800954 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80093e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800942:	83 ec 08             	sub    $0x8,%esp
  800945:	ff 75 0c             	pushl  0xc(%ebp)
  800948:	50                   	push   %eax
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	ff d0                	call   *%eax
  80094e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800951:	ff 4d e4             	decl   -0x1c(%ebp)
  800954:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800958:	7f e4                	jg     80093e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80095a:	eb 34                	jmp    800990 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80095c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800960:	74 1c                	je     80097e <vprintfmt+0x207>
  800962:	83 fb 1f             	cmp    $0x1f,%ebx
  800965:	7e 05                	jle    80096c <vprintfmt+0x1f5>
  800967:	83 fb 7e             	cmp    $0x7e,%ebx
  80096a:	7e 12                	jle    80097e <vprintfmt+0x207>
					putch('?', putdat);
  80096c:	83 ec 08             	sub    $0x8,%esp
  80096f:	ff 75 0c             	pushl  0xc(%ebp)
  800972:	6a 3f                	push   $0x3f
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	ff d0                	call   *%eax
  800979:	83 c4 10             	add    $0x10,%esp
  80097c:	eb 0f                	jmp    80098d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80097e:	83 ec 08             	sub    $0x8,%esp
  800981:	ff 75 0c             	pushl  0xc(%ebp)
  800984:	53                   	push   %ebx
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	ff d0                	call   *%eax
  80098a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80098d:	ff 4d e4             	decl   -0x1c(%ebp)
  800990:	89 f0                	mov    %esi,%eax
  800992:	8d 70 01             	lea    0x1(%eax),%esi
  800995:	8a 00                	mov    (%eax),%al
  800997:	0f be d8             	movsbl %al,%ebx
  80099a:	85 db                	test   %ebx,%ebx
  80099c:	74 24                	je     8009c2 <vprintfmt+0x24b>
  80099e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009a2:	78 b8                	js     80095c <vprintfmt+0x1e5>
  8009a4:	ff 4d e0             	decl   -0x20(%ebp)
  8009a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ab:	79 af                	jns    80095c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ad:	eb 13                	jmp    8009c2 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009af:	83 ec 08             	sub    $0x8,%esp
  8009b2:	ff 75 0c             	pushl  0xc(%ebp)
  8009b5:	6a 20                	push   $0x20
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	ff d0                	call   *%eax
  8009bc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009bf:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c6:	7f e7                	jg     8009af <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009c8:	e9 78 01 00 00       	jmp    800b45 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	ff 75 e8             	pushl  -0x18(%ebp)
  8009d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8009d6:	50                   	push   %eax
  8009d7:	e8 3c fd ff ff       	call   800718 <getint>
  8009dc:	83 c4 10             	add    $0x10,%esp
  8009df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009eb:	85 d2                	test   %edx,%edx
  8009ed:	79 23                	jns    800a12 <vprintfmt+0x29b>
				putch('-', putdat);
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	ff 75 0c             	pushl  0xc(%ebp)
  8009f5:	6a 2d                	push   $0x2d
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	ff d0                	call   *%eax
  8009fc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a05:	f7 d8                	neg    %eax
  800a07:	83 d2 00             	adc    $0x0,%edx
  800a0a:	f7 da                	neg    %edx
  800a0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a12:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a19:	e9 bc 00 00 00       	jmp    800ada <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 e8             	pushl  -0x18(%ebp)
  800a24:	8d 45 14             	lea    0x14(%ebp),%eax
  800a27:	50                   	push   %eax
  800a28:	e8 84 fc ff ff       	call   8006b1 <getuint>
  800a2d:	83 c4 10             	add    $0x10,%esp
  800a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a33:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a36:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a3d:	e9 98 00 00 00       	jmp    800ada <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a42:	83 ec 08             	sub    $0x8,%esp
  800a45:	ff 75 0c             	pushl  0xc(%ebp)
  800a48:	6a 58                	push   $0x58
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	ff d0                	call   *%eax
  800a4f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	6a 58                	push   $0x58
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	ff d0                	call   *%eax
  800a5f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 0c             	pushl  0xc(%ebp)
  800a68:	6a 58                	push   $0x58
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	ff d0                	call   *%eax
  800a6f:	83 c4 10             	add    $0x10,%esp
			break;
  800a72:	e9 ce 00 00 00       	jmp    800b45 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	6a 30                	push   $0x30
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
  800a84:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 0c             	pushl  0xc(%ebp)
  800a8d:	6a 78                	push   $0x78
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	ff d0                	call   *%eax
  800a94:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 c0 04             	add    $0x4,%eax
  800a9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	83 e8 04             	sub    $0x4,%eax
  800aa6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800aa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ab2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ab9:	eb 1f                	jmp    800ada <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	ff 75 e8             	pushl  -0x18(%ebp)
  800ac1:	8d 45 14             	lea    0x14(%ebp),%eax
  800ac4:	50                   	push   %eax
  800ac5:	e8 e7 fb ff ff       	call   8006b1 <getuint>
  800aca:	83 c4 10             	add    $0x10,%esp
  800acd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ad3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ada:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ade:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ae1:	83 ec 04             	sub    $0x4,%esp
  800ae4:	52                   	push   %edx
  800ae5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ae8:	50                   	push   %eax
  800ae9:	ff 75 f4             	pushl  -0xc(%ebp)
  800aec:	ff 75 f0             	pushl  -0x10(%ebp)
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	ff 75 08             	pushl  0x8(%ebp)
  800af5:	e8 00 fb ff ff       	call   8005fa <printnum>
  800afa:	83 c4 20             	add    $0x20,%esp
			break;
  800afd:	eb 46                	jmp    800b45 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 0c             	pushl  0xc(%ebp)
  800b05:	53                   	push   %ebx
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	ff d0                	call   *%eax
  800b0b:	83 c4 10             	add    $0x10,%esp
			break;
  800b0e:	eb 35                	jmp    800b45 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b10:	c6 05 64 30 80 00 00 	movb   $0x0,0x803064
			break;
  800b17:	eb 2c                	jmp    800b45 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b19:	c6 05 64 30 80 00 01 	movb   $0x1,0x803064
			break;
  800b20:	eb 23                	jmp    800b45 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b22:	83 ec 08             	sub    $0x8,%esp
  800b25:	ff 75 0c             	pushl  0xc(%ebp)
  800b28:	6a 25                	push   $0x25
  800b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2d:	ff d0                	call   *%eax
  800b2f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b32:	ff 4d 10             	decl   0x10(%ebp)
  800b35:	eb 03                	jmp    800b3a <vprintfmt+0x3c3>
  800b37:	ff 4d 10             	decl   0x10(%ebp)
  800b3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3d:	48                   	dec    %eax
  800b3e:	8a 00                	mov    (%eax),%al
  800b40:	3c 25                	cmp    $0x25,%al
  800b42:	75 f3                	jne    800b37 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b44:	90                   	nop
		}
	}
  800b45:	e9 35 fc ff ff       	jmp    80077f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b4a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b4b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b4e:	5b                   	pop    %ebx
  800b4f:	5e                   	pop    %esi
  800b50:	5d                   	pop    %ebp
  800b51:	c3                   	ret    

00800b52 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b52:	55                   	push   %ebp
  800b53:	89 e5                	mov    %esp,%ebp
  800b55:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b58:	8d 45 10             	lea    0x10(%ebp),%eax
  800b5b:	83 c0 04             	add    $0x4,%eax
  800b5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b61:	8b 45 10             	mov    0x10(%ebp),%eax
  800b64:	ff 75 f4             	pushl  -0xc(%ebp)
  800b67:	50                   	push   %eax
  800b68:	ff 75 0c             	pushl  0xc(%ebp)
  800b6b:	ff 75 08             	pushl  0x8(%ebp)
  800b6e:	e8 04 fc ff ff       	call   800777 <vprintfmt>
  800b73:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b76:	90                   	nop
  800b77:	c9                   	leave  
  800b78:	c3                   	ret    

00800b79 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7f:	8b 40 08             	mov    0x8(%eax),%eax
  800b82:	8d 50 01             	lea    0x1(%eax),%edx
  800b85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b88:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8e:	8b 10                	mov    (%eax),%edx
  800b90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b93:	8b 40 04             	mov    0x4(%eax),%eax
  800b96:	39 c2                	cmp    %eax,%edx
  800b98:	73 12                	jae    800bac <sprintputch+0x33>
		*b->buf++ = ch;
  800b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9d:	8b 00                	mov    (%eax),%eax
  800b9f:	8d 48 01             	lea    0x1(%eax),%ecx
  800ba2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba5:	89 0a                	mov    %ecx,(%edx)
  800ba7:	8b 55 08             	mov    0x8(%ebp),%edx
  800baa:	88 10                	mov    %dl,(%eax)
}
  800bac:	90                   	nop
  800bad:	5d                   	pop    %ebp
  800bae:	c3                   	ret    

00800baf <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	01 d0                	add    %edx,%eax
  800bc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bd0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bd4:	74 06                	je     800bdc <vsnprintf+0x2d>
  800bd6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bda:	7f 07                	jg     800be3 <vsnprintf+0x34>
		return -E_INVAL;
  800bdc:	b8 03 00 00 00       	mov    $0x3,%eax
  800be1:	eb 20                	jmp    800c03 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800be3:	ff 75 14             	pushl  0x14(%ebp)
  800be6:	ff 75 10             	pushl  0x10(%ebp)
  800be9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bec:	50                   	push   %eax
  800bed:	68 79 0b 80 00       	push   $0x800b79
  800bf2:	e8 80 fb ff ff       	call   800777 <vprintfmt>
  800bf7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bfd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c03:	c9                   	leave  
  800c04:	c3                   	ret    

00800c05 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c0b:	8d 45 10             	lea    0x10(%ebp),%eax
  800c0e:	83 c0 04             	add    $0x4,%eax
  800c11:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c14:	8b 45 10             	mov    0x10(%ebp),%eax
  800c17:	ff 75 f4             	pushl  -0xc(%ebp)
  800c1a:	50                   	push   %eax
  800c1b:	ff 75 0c             	pushl  0xc(%ebp)
  800c1e:	ff 75 08             	pushl  0x8(%ebp)
  800c21:	e8 89 ff ff ff       	call   800baf <vsnprintf>
  800c26:	83 c4 10             	add    $0x10,%esp
  800c29:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c2f:	c9                   	leave  
  800c30:	c3                   	ret    

00800c31 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c37:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c3e:	eb 06                	jmp    800c46 <strlen+0x15>
		n++;
  800c40:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c43:	ff 45 08             	incl   0x8(%ebp)
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
  800c49:	8a 00                	mov    (%eax),%al
  800c4b:	84 c0                	test   %al,%al
  800c4d:	75 f1                	jne    800c40 <strlen+0xf>
		n++;
	return n;
  800c4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c52:	c9                   	leave  
  800c53:	c3                   	ret    

00800c54 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c61:	eb 09                	jmp    800c6c <strnlen+0x18>
		n++;
  800c63:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c66:	ff 45 08             	incl   0x8(%ebp)
  800c69:	ff 4d 0c             	decl   0xc(%ebp)
  800c6c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c70:	74 09                	je     800c7b <strnlen+0x27>
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	8a 00                	mov    (%eax),%al
  800c77:	84 c0                	test   %al,%al
  800c79:	75 e8                	jne    800c63 <strnlen+0xf>
		n++;
	return n;
  800c7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c7e:	c9                   	leave  
  800c7f:	c3                   	ret    

00800c80 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c8c:	90                   	nop
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c90:	8d 50 01             	lea    0x1(%eax),%edx
  800c93:	89 55 08             	mov    %edx,0x8(%ebp)
  800c96:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c99:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c9c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c9f:	8a 12                	mov    (%edx),%dl
  800ca1:	88 10                	mov    %dl,(%eax)
  800ca3:	8a 00                	mov    (%eax),%al
  800ca5:	84 c0                	test   %al,%al
  800ca7:	75 e4                	jne    800c8d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ca9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cac:	c9                   	leave  
  800cad:	c3                   	ret    

00800cae <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cae:	55                   	push   %ebp
  800caf:	89 e5                	mov    %esp,%ebp
  800cb1:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cc1:	eb 1f                	jmp    800ce2 <strncpy+0x34>
		*dst++ = *src;
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	8d 50 01             	lea    0x1(%eax),%edx
  800cc9:	89 55 08             	mov    %edx,0x8(%ebp)
  800ccc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ccf:	8a 12                	mov    (%edx),%dl
  800cd1:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd6:	8a 00                	mov    (%eax),%al
  800cd8:	84 c0                	test   %al,%al
  800cda:	74 03                	je     800cdf <strncpy+0x31>
			src++;
  800cdc:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cdf:	ff 45 fc             	incl   -0x4(%ebp)
  800ce2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ce8:	72 d9                	jb     800cc3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cea:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ced:	c9                   	leave  
  800cee:	c3                   	ret    

00800cef <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cfb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cff:	74 30                	je     800d31 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d01:	eb 16                	jmp    800d19 <strlcpy+0x2a>
			*dst++ = *src++;
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	8d 50 01             	lea    0x1(%eax),%edx
  800d09:	89 55 08             	mov    %edx,0x8(%ebp)
  800d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d12:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d15:	8a 12                	mov    (%edx),%dl
  800d17:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d19:	ff 4d 10             	decl   0x10(%ebp)
  800d1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d20:	74 09                	je     800d2b <strlcpy+0x3c>
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	84 c0                	test   %al,%al
  800d29:	75 d8                	jne    800d03 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d31:	8b 55 08             	mov    0x8(%ebp),%edx
  800d34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d37:	29 c2                	sub    %eax,%edx
  800d39:	89 d0                	mov    %edx,%eax
}
  800d3b:	c9                   	leave  
  800d3c:	c3                   	ret    

00800d3d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d40:	eb 06                	jmp    800d48 <strcmp+0xb>
		p++, q++;
  800d42:	ff 45 08             	incl   0x8(%ebp)
  800d45:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	8a 00                	mov    (%eax),%al
  800d4d:	84 c0                	test   %al,%al
  800d4f:	74 0e                	je     800d5f <strcmp+0x22>
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	8a 10                	mov    (%eax),%dl
  800d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d59:	8a 00                	mov    (%eax),%al
  800d5b:	38 c2                	cmp    %al,%dl
  800d5d:	74 e3                	je     800d42 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	0f b6 d0             	movzbl %al,%edx
  800d67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	0f b6 c0             	movzbl %al,%eax
  800d6f:	29 c2                	sub    %eax,%edx
  800d71:	89 d0                	mov    %edx,%eax
}
  800d73:	5d                   	pop    %ebp
  800d74:	c3                   	ret    

00800d75 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d78:	eb 09                	jmp    800d83 <strncmp+0xe>
		n--, p++, q++;
  800d7a:	ff 4d 10             	decl   0x10(%ebp)
  800d7d:	ff 45 08             	incl   0x8(%ebp)
  800d80:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d87:	74 17                	je     800da0 <strncmp+0x2b>
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	84 c0                	test   %al,%al
  800d90:	74 0e                	je     800da0 <strncmp+0x2b>
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8a 10                	mov    (%eax),%dl
  800d97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9a:	8a 00                	mov    (%eax),%al
  800d9c:	38 c2                	cmp    %al,%dl
  800d9e:	74 da                	je     800d7a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800da0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da4:	75 07                	jne    800dad <strncmp+0x38>
		return 0;
  800da6:	b8 00 00 00 00       	mov    $0x0,%eax
  800dab:	eb 14                	jmp    800dc1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	8a 00                	mov    (%eax),%al
  800db2:	0f b6 d0             	movzbl %al,%edx
  800db5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db8:	8a 00                	mov    (%eax),%al
  800dba:	0f b6 c0             	movzbl %al,%eax
  800dbd:	29 c2                	sub    %eax,%edx
  800dbf:	89 d0                	mov    %edx,%eax
}
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    

00800dc3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	83 ec 04             	sub    $0x4,%esp
  800dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dcf:	eb 12                	jmp    800de3 <strchr+0x20>
		if (*s == c)
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dd9:	75 05                	jne    800de0 <strchr+0x1d>
			return (char *) s;
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	eb 11                	jmp    800df1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800de0:	ff 45 08             	incl   0x8(%ebp)
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
  800de6:	8a 00                	mov    (%eax),%al
  800de8:	84 c0                	test   %al,%al
  800dea:	75 e5                	jne    800dd1 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800df1:	c9                   	leave  
  800df2:	c3                   	ret    

00800df3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	83 ec 04             	sub    $0x4,%esp
  800df9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dff:	eb 0d                	jmp    800e0e <strfind+0x1b>
		if (*s == c)
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8a 00                	mov    (%eax),%al
  800e06:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e09:	74 0e                	je     800e19 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e0b:	ff 45 08             	incl   0x8(%ebp)
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	8a 00                	mov    (%eax),%al
  800e13:	84 c0                	test   %al,%al
  800e15:	75 ea                	jne    800e01 <strfind+0xe>
  800e17:	eb 01                	jmp    800e1a <strfind+0x27>
		if (*s == c)
			break;
  800e19:	90                   	nop
	return (char *) s;
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e1d:	c9                   	leave  
  800e1e:	c3                   	ret    

00800e1f <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e2b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e2f:	76 63                	jbe    800e94 <memset+0x75>
		uint64 data_block = c;
  800e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e34:	99                   	cltd   
  800e35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e38:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e41:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e45:	c1 e0 08             	shl    $0x8,%eax
  800e48:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e4b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e54:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e58:	c1 e0 10             	shl    $0x10,%eax
  800e5b:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e5e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e67:	89 c2                	mov    %eax,%edx
  800e69:	b8 00 00 00 00       	mov    $0x0,%eax
  800e6e:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e71:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e74:	eb 18                	jmp    800e8e <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e76:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e79:	8d 41 08             	lea    0x8(%ecx),%eax
  800e7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e85:	89 01                	mov    %eax,(%ecx)
  800e87:	89 51 04             	mov    %edx,0x4(%ecx)
  800e8a:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e8e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e92:	77 e2                	ja     800e76 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e98:	74 23                	je     800ebd <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ea0:	eb 0e                	jmp    800eb0 <memset+0x91>
			*p8++ = (uint8)c;
  800ea2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea5:	8d 50 01             	lea    0x1(%eax),%edx
  800ea8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eae:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800eb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb6:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	75 e5                	jne    800ea2 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800ed4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ed8:	76 24                	jbe    800efe <memcpy+0x3c>
		while(n >= 8){
  800eda:	eb 1c                	jmp    800ef8 <memcpy+0x36>
			*d64 = *s64;
  800edc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800edf:	8b 50 04             	mov    0x4(%eax),%edx
  800ee2:	8b 00                	mov    (%eax),%eax
  800ee4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800ee7:	89 01                	mov    %eax,(%ecx)
  800ee9:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800eec:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800ef0:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800ef4:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800ef8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800efc:	77 de                	ja     800edc <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800efe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f02:	74 31                	je     800f35 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f07:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f10:	eb 16                	jmp    800f28 <memcpy+0x66>
			*d8++ = *s8++;
  800f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f15:	8d 50 01             	lea    0x1(%eax),%edx
  800f18:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f1e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f21:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f24:	8a 12                	mov    (%edx),%dl
  800f26:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f28:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f2e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f31:	85 c0                	test   %eax,%eax
  800f33:	75 dd                	jne    800f12 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f38:	c9                   	leave  
  800f39:	c3                   	ret    

00800f3a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
  800f3d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f52:	73 50                	jae    800fa4 <memmove+0x6a>
  800f54:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f57:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5a:	01 d0                	add    %edx,%eax
  800f5c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f5f:	76 43                	jbe    800fa4 <memmove+0x6a>
		s += n;
  800f61:	8b 45 10             	mov    0x10(%ebp),%eax
  800f64:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f67:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f6d:	eb 10                	jmp    800f7f <memmove+0x45>
			*--d = *--s;
  800f6f:	ff 4d f8             	decl   -0x8(%ebp)
  800f72:	ff 4d fc             	decl   -0x4(%ebp)
  800f75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f78:	8a 10                	mov    (%eax),%dl
  800f7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f82:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f85:	89 55 10             	mov    %edx,0x10(%ebp)
  800f88:	85 c0                	test   %eax,%eax
  800f8a:	75 e3                	jne    800f6f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f8c:	eb 23                	jmp    800fb1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f91:	8d 50 01             	lea    0x1(%eax),%edx
  800f94:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f9d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fa0:	8a 12                	mov    (%edx),%dl
  800fa2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fa4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800faa:	89 55 10             	mov    %edx,0x10(%ebp)
  800fad:	85 c0                	test   %eax,%eax
  800faf:	75 dd                	jne    800f8e <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb4:	c9                   	leave  
  800fb5:	c3                   	ret    

00800fb6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fc8:	eb 2a                	jmp    800ff4 <memcmp+0x3e>
		if (*s1 != *s2)
  800fca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fcd:	8a 10                	mov    (%eax),%dl
  800fcf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	38 c2                	cmp    %al,%dl
  800fd6:	74 16                	je     800fee <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	0f b6 d0             	movzbl %al,%edx
  800fe0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	0f b6 c0             	movzbl %al,%eax
  800fe8:	29 c2                	sub    %eax,%edx
  800fea:	89 d0                	mov    %edx,%eax
  800fec:	eb 18                	jmp    801006 <memcmp+0x50>
		s1++, s2++;
  800fee:	ff 45 fc             	incl   -0x4(%ebp)
  800ff1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ff4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ffa:	89 55 10             	mov    %edx,0x10(%ebp)
  800ffd:	85 c0                	test   %eax,%eax
  800fff:	75 c9                	jne    800fca <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801001:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801006:	c9                   	leave  
  801007:	c3                   	ret    

00801008 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80100e:	8b 55 08             	mov    0x8(%ebp),%edx
  801011:	8b 45 10             	mov    0x10(%ebp),%eax
  801014:	01 d0                	add    %edx,%eax
  801016:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801019:	eb 15                	jmp    801030 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	8a 00                	mov    (%eax),%al
  801020:	0f b6 d0             	movzbl %al,%edx
  801023:	8b 45 0c             	mov    0xc(%ebp),%eax
  801026:	0f b6 c0             	movzbl %al,%eax
  801029:	39 c2                	cmp    %eax,%edx
  80102b:	74 0d                	je     80103a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80102d:	ff 45 08             	incl   0x8(%ebp)
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801036:	72 e3                	jb     80101b <memfind+0x13>
  801038:	eb 01                	jmp    80103b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80103a:	90                   	nop
	return (void *) s;
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80103e:	c9                   	leave  
  80103f:	c3                   	ret    

00801040 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
  801043:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801046:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80104d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801054:	eb 03                	jmp    801059 <strtol+0x19>
		s++;
  801056:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
  80105c:	8a 00                	mov    (%eax),%al
  80105e:	3c 20                	cmp    $0x20,%al
  801060:	74 f4                	je     801056 <strtol+0x16>
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	3c 09                	cmp    $0x9,%al
  801069:	74 eb                	je     801056 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	3c 2b                	cmp    $0x2b,%al
  801072:	75 05                	jne    801079 <strtol+0x39>
		s++;
  801074:	ff 45 08             	incl   0x8(%ebp)
  801077:	eb 13                	jmp    80108c <strtol+0x4c>
	else if (*s == '-')
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	8a 00                	mov    (%eax),%al
  80107e:	3c 2d                	cmp    $0x2d,%al
  801080:	75 0a                	jne    80108c <strtol+0x4c>
		s++, neg = 1;
  801082:	ff 45 08             	incl   0x8(%ebp)
  801085:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80108c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801090:	74 06                	je     801098 <strtol+0x58>
  801092:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801096:	75 20                	jne    8010b8 <strtol+0x78>
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	3c 30                	cmp    $0x30,%al
  80109f:	75 17                	jne    8010b8 <strtol+0x78>
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	40                   	inc    %eax
  8010a5:	8a 00                	mov    (%eax),%al
  8010a7:	3c 78                	cmp    $0x78,%al
  8010a9:	75 0d                	jne    8010b8 <strtol+0x78>
		s += 2, base = 16;
  8010ab:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010af:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010b6:	eb 28                	jmp    8010e0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010bc:	75 15                	jne    8010d3 <strtol+0x93>
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	8a 00                	mov    (%eax),%al
  8010c3:	3c 30                	cmp    $0x30,%al
  8010c5:	75 0c                	jne    8010d3 <strtol+0x93>
		s++, base = 8;
  8010c7:	ff 45 08             	incl   0x8(%ebp)
  8010ca:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010d1:	eb 0d                	jmp    8010e0 <strtol+0xa0>
	else if (base == 0)
  8010d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d7:	75 07                	jne    8010e0 <strtol+0xa0>
		base = 10;
  8010d9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	3c 2f                	cmp    $0x2f,%al
  8010e7:	7e 19                	jle    801102 <strtol+0xc2>
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	8a 00                	mov    (%eax),%al
  8010ee:	3c 39                	cmp    $0x39,%al
  8010f0:	7f 10                	jg     801102 <strtol+0xc2>
			dig = *s - '0';
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	8a 00                	mov    (%eax),%al
  8010f7:	0f be c0             	movsbl %al,%eax
  8010fa:	83 e8 30             	sub    $0x30,%eax
  8010fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801100:	eb 42                	jmp    801144 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801102:	8b 45 08             	mov    0x8(%ebp),%eax
  801105:	8a 00                	mov    (%eax),%al
  801107:	3c 60                	cmp    $0x60,%al
  801109:	7e 19                	jle    801124 <strtol+0xe4>
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	8a 00                	mov    (%eax),%al
  801110:	3c 7a                	cmp    $0x7a,%al
  801112:	7f 10                	jg     801124 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	8a 00                	mov    (%eax),%al
  801119:	0f be c0             	movsbl %al,%eax
  80111c:	83 e8 57             	sub    $0x57,%eax
  80111f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801122:	eb 20                	jmp    801144 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801124:	8b 45 08             	mov    0x8(%ebp),%eax
  801127:	8a 00                	mov    (%eax),%al
  801129:	3c 40                	cmp    $0x40,%al
  80112b:	7e 39                	jle    801166 <strtol+0x126>
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	8a 00                	mov    (%eax),%al
  801132:	3c 5a                	cmp    $0x5a,%al
  801134:	7f 30                	jg     801166 <strtol+0x126>
			dig = *s - 'A' + 10;
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	8a 00                	mov    (%eax),%al
  80113b:	0f be c0             	movsbl %al,%eax
  80113e:	83 e8 37             	sub    $0x37,%eax
  801141:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801147:	3b 45 10             	cmp    0x10(%ebp),%eax
  80114a:	7d 19                	jge    801165 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80114c:	ff 45 08             	incl   0x8(%ebp)
  80114f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801152:	0f af 45 10          	imul   0x10(%ebp),%eax
  801156:	89 c2                	mov    %eax,%edx
  801158:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80115b:	01 d0                	add    %edx,%eax
  80115d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801160:	e9 7b ff ff ff       	jmp    8010e0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801165:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801166:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80116a:	74 08                	je     801174 <strtol+0x134>
		*endptr = (char *) s;
  80116c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116f:	8b 55 08             	mov    0x8(%ebp),%edx
  801172:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801174:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801178:	74 07                	je     801181 <strtol+0x141>
  80117a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117d:	f7 d8                	neg    %eax
  80117f:	eb 03                	jmp    801184 <strtol+0x144>
  801181:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801184:	c9                   	leave  
  801185:	c3                   	ret    

00801186 <ltostr>:

void
ltostr(long value, char *str)
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80118c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801193:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80119a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80119e:	79 13                	jns    8011b3 <ltostr+0x2d>
	{
		neg = 1;
  8011a0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011aa:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011ad:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011b0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011bb:	99                   	cltd   
  8011bc:	f7 f9                	idiv   %ecx
  8011be:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c4:	8d 50 01             	lea    0x1(%eax),%edx
  8011c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011ca:	89 c2                	mov    %eax,%edx
  8011cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cf:	01 d0                	add    %edx,%eax
  8011d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011d4:	83 c2 30             	add    $0x30,%edx
  8011d7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011dc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011e1:	f7 e9                	imul   %ecx
  8011e3:	c1 fa 02             	sar    $0x2,%edx
  8011e6:	89 c8                	mov    %ecx,%eax
  8011e8:	c1 f8 1f             	sar    $0x1f,%eax
  8011eb:	29 c2                	sub    %eax,%edx
  8011ed:	89 d0                	mov    %edx,%eax
  8011ef:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8011f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011f6:	75 bb                	jne    8011b3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801202:	48                   	dec    %eax
  801203:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801206:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80120a:	74 3d                	je     801249 <ltostr+0xc3>
		start = 1 ;
  80120c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801213:	eb 34                	jmp    801249 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801215:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121b:	01 d0                	add    %edx,%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801222:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801225:	8b 45 0c             	mov    0xc(%ebp),%eax
  801228:	01 c2                	add    %eax,%edx
  80122a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80122d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801230:	01 c8                	add    %ecx,%eax
  801232:	8a 00                	mov    (%eax),%al
  801234:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801236:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801239:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123c:	01 c2                	add    %eax,%edx
  80123e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801241:	88 02                	mov    %al,(%edx)
		start++ ;
  801243:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801246:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80124f:	7c c4                	jl     801215 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801251:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801254:	8b 45 0c             	mov    0xc(%ebp),%eax
  801257:	01 d0                	add    %edx,%eax
  801259:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80125c:	90                   	nop
  80125d:	c9                   	leave  
  80125e:	c3                   	ret    

0080125f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801265:	ff 75 08             	pushl  0x8(%ebp)
  801268:	e8 c4 f9 ff ff       	call   800c31 <strlen>
  80126d:	83 c4 04             	add    $0x4,%esp
  801270:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801273:	ff 75 0c             	pushl  0xc(%ebp)
  801276:	e8 b6 f9 ff ff       	call   800c31 <strlen>
  80127b:	83 c4 04             	add    $0x4,%esp
  80127e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801281:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801288:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80128f:	eb 17                	jmp    8012a8 <strcconcat+0x49>
		final[s] = str1[s] ;
  801291:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801294:	8b 45 10             	mov    0x10(%ebp),%eax
  801297:	01 c2                	add    %eax,%edx
  801299:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80129c:	8b 45 08             	mov    0x8(%ebp),%eax
  80129f:	01 c8                	add    %ecx,%eax
  8012a1:	8a 00                	mov    (%eax),%al
  8012a3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012a5:	ff 45 fc             	incl   -0x4(%ebp)
  8012a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ab:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012ae:	7c e1                	jl     801291 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012b0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012be:	eb 1f                	jmp    8012df <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c3:	8d 50 01             	lea    0x1(%eax),%edx
  8012c6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012c9:	89 c2                	mov    %eax,%edx
  8012cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ce:	01 c2                	add    %eax,%edx
  8012d0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d6:	01 c8                	add    %ecx,%eax
  8012d8:	8a 00                	mov    (%eax),%al
  8012da:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012dc:	ff 45 f8             	incl   -0x8(%ebp)
  8012df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012e5:	7c d9                	jl     8012c0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ed:	01 d0                	add    %edx,%eax
  8012ef:	c6 00 00             	movb   $0x0,(%eax)
}
  8012f2:	90                   	nop
  8012f3:	c9                   	leave  
  8012f4:	c3                   	ret    

008012f5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8012fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801301:	8b 45 14             	mov    0x14(%ebp),%eax
  801304:	8b 00                	mov    (%eax),%eax
  801306:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80130d:	8b 45 10             	mov    0x10(%ebp),%eax
  801310:	01 d0                	add    %edx,%eax
  801312:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801318:	eb 0c                	jmp    801326 <strsplit+0x31>
			*string++ = 0;
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	8d 50 01             	lea    0x1(%eax),%edx
  801320:	89 55 08             	mov    %edx,0x8(%ebp)
  801323:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	8a 00                	mov    (%eax),%al
  80132b:	84 c0                	test   %al,%al
  80132d:	74 18                	je     801347 <strsplit+0x52>
  80132f:	8b 45 08             	mov    0x8(%ebp),%eax
  801332:	8a 00                	mov    (%eax),%al
  801334:	0f be c0             	movsbl %al,%eax
  801337:	50                   	push   %eax
  801338:	ff 75 0c             	pushl  0xc(%ebp)
  80133b:	e8 83 fa ff ff       	call   800dc3 <strchr>
  801340:	83 c4 08             	add    $0x8,%esp
  801343:	85 c0                	test   %eax,%eax
  801345:	75 d3                	jne    80131a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801347:	8b 45 08             	mov    0x8(%ebp),%eax
  80134a:	8a 00                	mov    (%eax),%al
  80134c:	84 c0                	test   %al,%al
  80134e:	74 5a                	je     8013aa <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801350:	8b 45 14             	mov    0x14(%ebp),%eax
  801353:	8b 00                	mov    (%eax),%eax
  801355:	83 f8 0f             	cmp    $0xf,%eax
  801358:	75 07                	jne    801361 <strsplit+0x6c>
		{
			return 0;
  80135a:	b8 00 00 00 00       	mov    $0x0,%eax
  80135f:	eb 66                	jmp    8013c7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801361:	8b 45 14             	mov    0x14(%ebp),%eax
  801364:	8b 00                	mov    (%eax),%eax
  801366:	8d 48 01             	lea    0x1(%eax),%ecx
  801369:	8b 55 14             	mov    0x14(%ebp),%edx
  80136c:	89 0a                	mov    %ecx,(%edx)
  80136e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801375:	8b 45 10             	mov    0x10(%ebp),%eax
  801378:	01 c2                	add    %eax,%edx
  80137a:	8b 45 08             	mov    0x8(%ebp),%eax
  80137d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80137f:	eb 03                	jmp    801384 <strsplit+0x8f>
			string++;
  801381:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801384:	8b 45 08             	mov    0x8(%ebp),%eax
  801387:	8a 00                	mov    (%eax),%al
  801389:	84 c0                	test   %al,%al
  80138b:	74 8b                	je     801318 <strsplit+0x23>
  80138d:	8b 45 08             	mov    0x8(%ebp),%eax
  801390:	8a 00                	mov    (%eax),%al
  801392:	0f be c0             	movsbl %al,%eax
  801395:	50                   	push   %eax
  801396:	ff 75 0c             	pushl  0xc(%ebp)
  801399:	e8 25 fa ff ff       	call   800dc3 <strchr>
  80139e:	83 c4 08             	add    $0x8,%esp
  8013a1:	85 c0                	test   %eax,%eax
  8013a3:	74 dc                	je     801381 <strsplit+0x8c>
			string++;
	}
  8013a5:	e9 6e ff ff ff       	jmp    801318 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013aa:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ae:	8b 00                	mov    (%eax),%eax
  8013b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ba:	01 d0                	add    %edx,%eax
  8013bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013c2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013c7:	c9                   	leave  
  8013c8:	c3                   	ret    

008013c9 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013c9:	55                   	push   %ebp
  8013ca:	89 e5                	mov    %esp,%ebp
  8013cc:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013dc:	eb 4a                	jmp    801428 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8013de:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e4:	01 c2                	add    %eax,%edx
  8013e6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ec:	01 c8                	add    %ecx,%eax
  8013ee:	8a 00                	mov    (%eax),%al
  8013f0:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8013f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f8:	01 d0                	add    %edx,%eax
  8013fa:	8a 00                	mov    (%eax),%al
  8013fc:	3c 40                	cmp    $0x40,%al
  8013fe:	7e 25                	jle    801425 <str2lower+0x5c>
  801400:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801403:	8b 45 0c             	mov    0xc(%ebp),%eax
  801406:	01 d0                	add    %edx,%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	3c 5a                	cmp    $0x5a,%al
  80140c:	7f 17                	jg     801425 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80140e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	01 d0                	add    %edx,%eax
  801416:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801419:	8b 55 08             	mov    0x8(%ebp),%edx
  80141c:	01 ca                	add    %ecx,%edx
  80141e:	8a 12                	mov    (%edx),%dl
  801420:	83 c2 20             	add    $0x20,%edx
  801423:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801425:	ff 45 fc             	incl   -0x4(%ebp)
  801428:	ff 75 0c             	pushl  0xc(%ebp)
  80142b:	e8 01 f8 ff ff       	call   800c31 <strlen>
  801430:	83 c4 04             	add    $0x4,%esp
  801433:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801436:	7f a6                	jg     8013de <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801438:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80143b:	c9                   	leave  
  80143c:	c3                   	ret    

0080143d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
  801440:	57                   	push   %edi
  801441:	56                   	push   %esi
  801442:	53                   	push   %ebx
  801443:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801446:	8b 45 08             	mov    0x8(%ebp),%eax
  801449:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80144f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801452:	8b 7d 18             	mov    0x18(%ebp),%edi
  801455:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801458:	cd 30                	int    $0x30
  80145a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80145d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801460:	83 c4 10             	add    $0x10,%esp
  801463:	5b                   	pop    %ebx
  801464:	5e                   	pop    %esi
  801465:	5f                   	pop    %edi
  801466:	5d                   	pop    %ebp
  801467:	c3                   	ret    

00801468 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	83 ec 04             	sub    $0x4,%esp
  80146e:	8b 45 10             	mov    0x10(%ebp),%eax
  801471:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801474:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801477:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
  80147e:	6a 00                	push   $0x0
  801480:	51                   	push   %ecx
  801481:	52                   	push   %edx
  801482:	ff 75 0c             	pushl  0xc(%ebp)
  801485:	50                   	push   %eax
  801486:	6a 00                	push   $0x0
  801488:	e8 b0 ff ff ff       	call   80143d <syscall>
  80148d:	83 c4 18             	add    $0x18,%esp
}
  801490:	90                   	nop
  801491:	c9                   	leave  
  801492:	c3                   	ret    

00801493 <sys_cgetc>:

int
sys_cgetc(void)
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801496:	6a 00                	push   $0x0
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 02                	push   $0x2
  8014a2:	e8 96 ff ff ff       	call   80143d <syscall>
  8014a7:	83 c4 18             	add    $0x18,%esp
}
  8014aa:	c9                   	leave  
  8014ab:	c3                   	ret    

008014ac <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 03                	push   $0x3
  8014bb:	e8 7d ff ff ff       	call   80143d <syscall>
  8014c0:	83 c4 18             	add    $0x18,%esp
}
  8014c3:	90                   	nop
  8014c4:	c9                   	leave  
  8014c5:	c3                   	ret    

008014c6 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 00                	push   $0x0
  8014cd:	6a 00                	push   $0x0
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 04                	push   $0x4
  8014d5:	e8 63 ff ff ff       	call   80143d <syscall>
  8014da:	83 c4 18             	add    $0x18,%esp
}
  8014dd:	90                   	nop
  8014de:	c9                   	leave  
  8014df:	c3                   	ret    

008014e0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	52                   	push   %edx
  8014f0:	50                   	push   %eax
  8014f1:	6a 08                	push   $0x8
  8014f3:	e8 45 ff ff ff       	call   80143d <syscall>
  8014f8:	83 c4 18             	add    $0x18,%esp
}
  8014fb:	c9                   	leave  
  8014fc:	c3                   	ret    

008014fd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8014fd:	55                   	push   %ebp
  8014fe:	89 e5                	mov    %esp,%ebp
  801500:	56                   	push   %esi
  801501:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801502:	8b 75 18             	mov    0x18(%ebp),%esi
  801505:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801508:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80150b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150e:	8b 45 08             	mov    0x8(%ebp),%eax
  801511:	56                   	push   %esi
  801512:	53                   	push   %ebx
  801513:	51                   	push   %ecx
  801514:	52                   	push   %edx
  801515:	50                   	push   %eax
  801516:	6a 09                	push   $0x9
  801518:	e8 20 ff ff ff       	call   80143d <syscall>
  80151d:	83 c4 18             	add    $0x18,%esp
}
  801520:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801523:	5b                   	pop    %ebx
  801524:	5e                   	pop    %esi
  801525:	5d                   	pop    %ebp
  801526:	c3                   	ret    

00801527 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	ff 75 08             	pushl  0x8(%ebp)
  801535:	6a 0a                	push   $0xa
  801537:	e8 01 ff ff ff       	call   80143d <syscall>
  80153c:	83 c4 18             	add    $0x18,%esp
}
  80153f:	c9                   	leave  
  801540:	c3                   	ret    

00801541 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	ff 75 0c             	pushl  0xc(%ebp)
  80154d:	ff 75 08             	pushl  0x8(%ebp)
  801550:	6a 0b                	push   $0xb
  801552:	e8 e6 fe ff ff       	call   80143d <syscall>
  801557:	83 c4 18             	add    $0x18,%esp
}
  80155a:	c9                   	leave  
  80155b:	c3                   	ret    

0080155c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	6a 00                	push   $0x0
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 0c                	push   $0xc
  80156b:	e8 cd fe ff ff       	call   80143d <syscall>
  801570:	83 c4 18             	add    $0x18,%esp
}
  801573:	c9                   	leave  
  801574:	c3                   	ret    

00801575 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	6a 0d                	push   $0xd
  801584:	e8 b4 fe ff ff       	call   80143d <syscall>
  801589:	83 c4 18             	add    $0x18,%esp
}
  80158c:	c9                   	leave  
  80158d:	c3                   	ret    

0080158e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 0e                	push   $0xe
  80159d:	e8 9b fe ff ff       	call   80143d <syscall>
  8015a2:	83 c4 18             	add    $0x18,%esp
}
  8015a5:	c9                   	leave  
  8015a6:	c3                   	ret    

008015a7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 0f                	push   $0xf
  8015b6:	e8 82 fe ff ff       	call   80143d <syscall>
  8015bb:	83 c4 18             	add    $0x18,%esp
}
  8015be:	c9                   	leave  
  8015bf:	c3                   	ret    

008015c0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	ff 75 08             	pushl  0x8(%ebp)
  8015ce:	6a 10                	push   $0x10
  8015d0:	e8 68 fe ff ff       	call   80143d <syscall>
  8015d5:	83 c4 18             	add    $0x18,%esp
}
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 11                	push   $0x11
  8015e9:	e8 4f fe ff ff       	call   80143d <syscall>
  8015ee:	83 c4 18             	add    $0x18,%esp
}
  8015f1:	90                   	nop
  8015f2:	c9                   	leave  
  8015f3:	c3                   	ret    

008015f4 <sys_cputc>:

void
sys_cputc(const char c)
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
  8015f7:	83 ec 04             	sub    $0x4,%esp
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801600:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	50                   	push   %eax
  80160d:	6a 01                	push   $0x1
  80160f:	e8 29 fe ff ff       	call   80143d <syscall>
  801614:	83 c4 18             	add    $0x18,%esp
}
  801617:	90                   	nop
  801618:	c9                   	leave  
  801619:	c3                   	ret    

0080161a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 14                	push   $0x14
  801629:	e8 0f fe ff ff       	call   80143d <syscall>
  80162e:	83 c4 18             	add    $0x18,%esp
}
  801631:	90                   	nop
  801632:	c9                   	leave  
  801633:	c3                   	ret    

00801634 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
  801637:	83 ec 04             	sub    $0x4,%esp
  80163a:	8b 45 10             	mov    0x10(%ebp),%eax
  80163d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801640:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801643:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	6a 00                	push   $0x0
  80164c:	51                   	push   %ecx
  80164d:	52                   	push   %edx
  80164e:	ff 75 0c             	pushl  0xc(%ebp)
  801651:	50                   	push   %eax
  801652:	6a 15                	push   $0x15
  801654:	e8 e4 fd ff ff       	call   80143d <syscall>
  801659:	83 c4 18             	add    $0x18,%esp
}
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801661:	8b 55 0c             	mov    0xc(%ebp),%edx
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	52                   	push   %edx
  80166e:	50                   	push   %eax
  80166f:	6a 16                	push   $0x16
  801671:	e8 c7 fd ff ff       	call   80143d <syscall>
  801676:	83 c4 18             	add    $0x18,%esp
}
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80167e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801681:	8b 55 0c             	mov    0xc(%ebp),%edx
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	51                   	push   %ecx
  80168c:	52                   	push   %edx
  80168d:	50                   	push   %eax
  80168e:	6a 17                	push   $0x17
  801690:	e8 a8 fd ff ff       	call   80143d <syscall>
  801695:	83 c4 18             	add    $0x18,%esp
}
  801698:	c9                   	leave  
  801699:	c3                   	ret    

0080169a <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80169d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	52                   	push   %edx
  8016aa:	50                   	push   %eax
  8016ab:	6a 18                	push   $0x18
  8016ad:	e8 8b fd ff ff       	call   80143d <syscall>
  8016b2:	83 c4 18             	add    $0x18,%esp
}
  8016b5:	c9                   	leave  
  8016b6:	c3                   	ret    

008016b7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	6a 00                	push   $0x0
  8016bf:	ff 75 14             	pushl  0x14(%ebp)
  8016c2:	ff 75 10             	pushl  0x10(%ebp)
  8016c5:	ff 75 0c             	pushl  0xc(%ebp)
  8016c8:	50                   	push   %eax
  8016c9:	6a 19                	push   $0x19
  8016cb:	e8 6d fd ff ff       	call   80143d <syscall>
  8016d0:	83 c4 18             	add    $0x18,%esp
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	50                   	push   %eax
  8016e4:	6a 1a                	push   $0x1a
  8016e6:	e8 52 fd ff ff       	call   80143d <syscall>
  8016eb:	83 c4 18             	add    $0x18,%esp
}
  8016ee:	90                   	nop
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	50                   	push   %eax
  801700:	6a 1b                	push   $0x1b
  801702:	e8 36 fd ff ff       	call   80143d <syscall>
  801707:	83 c4 18             	add    $0x18,%esp
}
  80170a:	c9                   	leave  
  80170b:	c3                   	ret    

0080170c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 05                	push   $0x5
  80171b:	e8 1d fd ff ff       	call   80143d <syscall>
  801720:	83 c4 18             	add    $0x18,%esp
}
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 06                	push   $0x6
  801734:	e8 04 fd ff ff       	call   80143d <syscall>
  801739:	83 c4 18             	add    $0x18,%esp
}
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 07                	push   $0x7
  80174d:	e8 eb fc ff ff       	call   80143d <syscall>
  801752:	83 c4 18             	add    $0x18,%esp
}
  801755:	c9                   	leave  
  801756:	c3                   	ret    

00801757 <sys_exit_env>:


void sys_exit_env(void)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 1c                	push   $0x1c
  801766:	e8 d2 fc ff ff       	call   80143d <syscall>
  80176b:	83 c4 18             	add    $0x18,%esp
}
  80176e:	90                   	nop
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
  801774:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801777:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80177a:	8d 50 04             	lea    0x4(%eax),%edx
  80177d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	52                   	push   %edx
  801787:	50                   	push   %eax
  801788:	6a 1d                	push   $0x1d
  80178a:	e8 ae fc ff ff       	call   80143d <syscall>
  80178f:	83 c4 18             	add    $0x18,%esp
	return result;
  801792:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801795:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801798:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80179b:	89 01                	mov    %eax,(%ecx)
  80179d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a3:	c9                   	leave  
  8017a4:	c2 04 00             	ret    $0x4

008017a7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	ff 75 10             	pushl  0x10(%ebp)
  8017b1:	ff 75 0c             	pushl  0xc(%ebp)
  8017b4:	ff 75 08             	pushl  0x8(%ebp)
  8017b7:	6a 13                	push   $0x13
  8017b9:	e8 7f fc ff ff       	call   80143d <syscall>
  8017be:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c1:	90                   	nop
}
  8017c2:	c9                   	leave  
  8017c3:	c3                   	ret    

008017c4 <sys_rcr2>:
uint32 sys_rcr2()
{
  8017c4:	55                   	push   %ebp
  8017c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 1e                	push   $0x1e
  8017d3:	e8 65 fc ff ff       	call   80143d <syscall>
  8017d8:	83 c4 18             	add    $0x18,%esp
}
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
  8017e0:	83 ec 04             	sub    $0x4,%esp
  8017e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8017e9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	50                   	push   %eax
  8017f6:	6a 1f                	push   $0x1f
  8017f8:	e8 40 fc ff ff       	call   80143d <syscall>
  8017fd:	83 c4 18             	add    $0x18,%esp
	return ;
  801800:	90                   	nop
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <rsttst>:
void rsttst()
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 21                	push   $0x21
  801812:	e8 26 fc ff ff       	call   80143d <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
	return ;
  80181a:	90                   	nop
}
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
  801820:	83 ec 04             	sub    $0x4,%esp
  801823:	8b 45 14             	mov    0x14(%ebp),%eax
  801826:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801829:	8b 55 18             	mov    0x18(%ebp),%edx
  80182c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801830:	52                   	push   %edx
  801831:	50                   	push   %eax
  801832:	ff 75 10             	pushl  0x10(%ebp)
  801835:	ff 75 0c             	pushl  0xc(%ebp)
  801838:	ff 75 08             	pushl  0x8(%ebp)
  80183b:	6a 20                	push   $0x20
  80183d:	e8 fb fb ff ff       	call   80143d <syscall>
  801842:	83 c4 18             	add    $0x18,%esp
	return ;
  801845:	90                   	nop
}
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <chktst>:
void chktst(uint32 n)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	ff 75 08             	pushl  0x8(%ebp)
  801856:	6a 22                	push   $0x22
  801858:	e8 e0 fb ff ff       	call   80143d <syscall>
  80185d:	83 c4 18             	add    $0x18,%esp
	return ;
  801860:	90                   	nop
}
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <inctst>:

void inctst()
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 23                	push   $0x23
  801872:	e8 c6 fb ff ff       	call   80143d <syscall>
  801877:	83 c4 18             	add    $0x18,%esp
	return ;
  80187a:	90                   	nop
}
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <gettst>:
uint32 gettst()
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 24                	push   $0x24
  80188c:	e8 ac fb ff ff       	call   80143d <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
}
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 25                	push   $0x25
  8018a5:	e8 93 fb ff ff       	call   80143d <syscall>
  8018aa:	83 c4 18             	add    $0x18,%esp
  8018ad:	a3 80 f2 81 00       	mov    %eax,0x81f280
	return uheapPlaceStrategy ;
  8018b2:	a1 80 f2 81 00       	mov    0x81f280,%eax
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	a3 80 f2 81 00       	mov    %eax,0x81f280
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	ff 75 08             	pushl  0x8(%ebp)
  8018cf:	6a 26                	push   $0x26
  8018d1:	e8 67 fb ff ff       	call   80143d <syscall>
  8018d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d9:	90                   	nop
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018e0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	6a 00                	push   $0x0
  8018ee:	53                   	push   %ebx
  8018ef:	51                   	push   %ecx
  8018f0:	52                   	push   %edx
  8018f1:	50                   	push   %eax
  8018f2:	6a 27                	push   $0x27
  8018f4:	e8 44 fb ff ff       	call   80143d <syscall>
  8018f9:	83 c4 18             	add    $0x18,%esp
}
  8018fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801904:	8b 55 0c             	mov    0xc(%ebp),%edx
  801907:	8b 45 08             	mov    0x8(%ebp),%eax
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	52                   	push   %edx
  801911:	50                   	push   %eax
  801912:	6a 28                	push   $0x28
  801914:	e8 24 fb ff ff       	call   80143d <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
}
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    

0080191e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801921:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801924:	8b 55 0c             	mov    0xc(%ebp),%edx
  801927:	8b 45 08             	mov    0x8(%ebp),%eax
  80192a:	6a 00                	push   $0x0
  80192c:	51                   	push   %ecx
  80192d:	ff 75 10             	pushl  0x10(%ebp)
  801930:	52                   	push   %edx
  801931:	50                   	push   %eax
  801932:	6a 29                	push   $0x29
  801934:	e8 04 fb ff ff       	call   80143d <syscall>
  801939:	83 c4 18             	add    $0x18,%esp
}
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	ff 75 10             	pushl  0x10(%ebp)
  801948:	ff 75 0c             	pushl  0xc(%ebp)
  80194b:	ff 75 08             	pushl  0x8(%ebp)
  80194e:	6a 12                	push   $0x12
  801950:	e8 e8 fa ff ff       	call   80143d <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
	return ;
  801958:	90                   	nop
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80195e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801961:	8b 45 08             	mov    0x8(%ebp),%eax
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	52                   	push   %edx
  80196b:	50                   	push   %eax
  80196c:	6a 2a                	push   $0x2a
  80196e:	e8 ca fa ff ff       	call   80143d <syscall>
  801973:	83 c4 18             	add    $0x18,%esp
	return;
  801976:	90                   	nop
}
  801977:	c9                   	leave  
  801978:	c3                   	ret    

00801979 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 2b                	push   $0x2b
  801988:	e8 b0 fa ff ff       	call   80143d <syscall>
  80198d:	83 c4 18             	add    $0x18,%esp
}
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	ff 75 0c             	pushl  0xc(%ebp)
  80199e:	ff 75 08             	pushl  0x8(%ebp)
  8019a1:	6a 2d                	push   $0x2d
  8019a3:	e8 95 fa ff ff       	call   80143d <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
	return;
  8019ab:	90                   	nop
}
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ba:	ff 75 08             	pushl  0x8(%ebp)
  8019bd:	6a 2c                	push   $0x2c
  8019bf:	e8 79 fa ff ff       	call   80143d <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c7:	90                   	nop
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
  8019cd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8019d0:	83 ec 04             	sub    $0x4,%esp
  8019d3:	68 28 23 80 00       	push   $0x802328
  8019d8:	68 25 01 00 00       	push   $0x125
  8019dd:	68 5b 23 80 00       	push   $0x80235b
  8019e2:	e8 a3 e8 ff ff       	call   80028a <_panic>
  8019e7:	90                   	nop

008019e8 <__udivdi3>:
  8019e8:	55                   	push   %ebp
  8019e9:	57                   	push   %edi
  8019ea:	56                   	push   %esi
  8019eb:	53                   	push   %ebx
  8019ec:	83 ec 1c             	sub    $0x1c,%esp
  8019ef:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019f3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019ff:	89 ca                	mov    %ecx,%edx
  801a01:	89 f8                	mov    %edi,%eax
  801a03:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a07:	85 f6                	test   %esi,%esi
  801a09:	75 2d                	jne    801a38 <__udivdi3+0x50>
  801a0b:	39 cf                	cmp    %ecx,%edi
  801a0d:	77 65                	ja     801a74 <__udivdi3+0x8c>
  801a0f:	89 fd                	mov    %edi,%ebp
  801a11:	85 ff                	test   %edi,%edi
  801a13:	75 0b                	jne    801a20 <__udivdi3+0x38>
  801a15:	b8 01 00 00 00       	mov    $0x1,%eax
  801a1a:	31 d2                	xor    %edx,%edx
  801a1c:	f7 f7                	div    %edi
  801a1e:	89 c5                	mov    %eax,%ebp
  801a20:	31 d2                	xor    %edx,%edx
  801a22:	89 c8                	mov    %ecx,%eax
  801a24:	f7 f5                	div    %ebp
  801a26:	89 c1                	mov    %eax,%ecx
  801a28:	89 d8                	mov    %ebx,%eax
  801a2a:	f7 f5                	div    %ebp
  801a2c:	89 cf                	mov    %ecx,%edi
  801a2e:	89 fa                	mov    %edi,%edx
  801a30:	83 c4 1c             	add    $0x1c,%esp
  801a33:	5b                   	pop    %ebx
  801a34:	5e                   	pop    %esi
  801a35:	5f                   	pop    %edi
  801a36:	5d                   	pop    %ebp
  801a37:	c3                   	ret    
  801a38:	39 ce                	cmp    %ecx,%esi
  801a3a:	77 28                	ja     801a64 <__udivdi3+0x7c>
  801a3c:	0f bd fe             	bsr    %esi,%edi
  801a3f:	83 f7 1f             	xor    $0x1f,%edi
  801a42:	75 40                	jne    801a84 <__udivdi3+0x9c>
  801a44:	39 ce                	cmp    %ecx,%esi
  801a46:	72 0a                	jb     801a52 <__udivdi3+0x6a>
  801a48:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a4c:	0f 87 9e 00 00 00    	ja     801af0 <__udivdi3+0x108>
  801a52:	b8 01 00 00 00       	mov    $0x1,%eax
  801a57:	89 fa                	mov    %edi,%edx
  801a59:	83 c4 1c             	add    $0x1c,%esp
  801a5c:	5b                   	pop    %ebx
  801a5d:	5e                   	pop    %esi
  801a5e:	5f                   	pop    %edi
  801a5f:	5d                   	pop    %ebp
  801a60:	c3                   	ret    
  801a61:	8d 76 00             	lea    0x0(%esi),%esi
  801a64:	31 ff                	xor    %edi,%edi
  801a66:	31 c0                	xor    %eax,%eax
  801a68:	89 fa                	mov    %edi,%edx
  801a6a:	83 c4 1c             	add    $0x1c,%esp
  801a6d:	5b                   	pop    %ebx
  801a6e:	5e                   	pop    %esi
  801a6f:	5f                   	pop    %edi
  801a70:	5d                   	pop    %ebp
  801a71:	c3                   	ret    
  801a72:	66 90                	xchg   %ax,%ax
  801a74:	89 d8                	mov    %ebx,%eax
  801a76:	f7 f7                	div    %edi
  801a78:	31 ff                	xor    %edi,%edi
  801a7a:	89 fa                	mov    %edi,%edx
  801a7c:	83 c4 1c             	add    $0x1c,%esp
  801a7f:	5b                   	pop    %ebx
  801a80:	5e                   	pop    %esi
  801a81:	5f                   	pop    %edi
  801a82:	5d                   	pop    %ebp
  801a83:	c3                   	ret    
  801a84:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a89:	89 eb                	mov    %ebp,%ebx
  801a8b:	29 fb                	sub    %edi,%ebx
  801a8d:	89 f9                	mov    %edi,%ecx
  801a8f:	d3 e6                	shl    %cl,%esi
  801a91:	89 c5                	mov    %eax,%ebp
  801a93:	88 d9                	mov    %bl,%cl
  801a95:	d3 ed                	shr    %cl,%ebp
  801a97:	89 e9                	mov    %ebp,%ecx
  801a99:	09 f1                	or     %esi,%ecx
  801a9b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a9f:	89 f9                	mov    %edi,%ecx
  801aa1:	d3 e0                	shl    %cl,%eax
  801aa3:	89 c5                	mov    %eax,%ebp
  801aa5:	89 d6                	mov    %edx,%esi
  801aa7:	88 d9                	mov    %bl,%cl
  801aa9:	d3 ee                	shr    %cl,%esi
  801aab:	89 f9                	mov    %edi,%ecx
  801aad:	d3 e2                	shl    %cl,%edx
  801aaf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ab3:	88 d9                	mov    %bl,%cl
  801ab5:	d3 e8                	shr    %cl,%eax
  801ab7:	09 c2                	or     %eax,%edx
  801ab9:	89 d0                	mov    %edx,%eax
  801abb:	89 f2                	mov    %esi,%edx
  801abd:	f7 74 24 0c          	divl   0xc(%esp)
  801ac1:	89 d6                	mov    %edx,%esi
  801ac3:	89 c3                	mov    %eax,%ebx
  801ac5:	f7 e5                	mul    %ebp
  801ac7:	39 d6                	cmp    %edx,%esi
  801ac9:	72 19                	jb     801ae4 <__udivdi3+0xfc>
  801acb:	74 0b                	je     801ad8 <__udivdi3+0xf0>
  801acd:	89 d8                	mov    %ebx,%eax
  801acf:	31 ff                	xor    %edi,%edi
  801ad1:	e9 58 ff ff ff       	jmp    801a2e <__udivdi3+0x46>
  801ad6:	66 90                	xchg   %ax,%ax
  801ad8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801adc:	89 f9                	mov    %edi,%ecx
  801ade:	d3 e2                	shl    %cl,%edx
  801ae0:	39 c2                	cmp    %eax,%edx
  801ae2:	73 e9                	jae    801acd <__udivdi3+0xe5>
  801ae4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ae7:	31 ff                	xor    %edi,%edi
  801ae9:	e9 40 ff ff ff       	jmp    801a2e <__udivdi3+0x46>
  801aee:	66 90                	xchg   %ax,%ax
  801af0:	31 c0                	xor    %eax,%eax
  801af2:	e9 37 ff ff ff       	jmp    801a2e <__udivdi3+0x46>
  801af7:	90                   	nop

00801af8 <__umoddi3>:
  801af8:	55                   	push   %ebp
  801af9:	57                   	push   %edi
  801afa:	56                   	push   %esi
  801afb:	53                   	push   %ebx
  801afc:	83 ec 1c             	sub    $0x1c,%esp
  801aff:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b03:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b07:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b0b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b0f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b13:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b17:	89 f3                	mov    %esi,%ebx
  801b19:	89 fa                	mov    %edi,%edx
  801b1b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b1f:	89 34 24             	mov    %esi,(%esp)
  801b22:	85 c0                	test   %eax,%eax
  801b24:	75 1a                	jne    801b40 <__umoddi3+0x48>
  801b26:	39 f7                	cmp    %esi,%edi
  801b28:	0f 86 a2 00 00 00    	jbe    801bd0 <__umoddi3+0xd8>
  801b2e:	89 c8                	mov    %ecx,%eax
  801b30:	89 f2                	mov    %esi,%edx
  801b32:	f7 f7                	div    %edi
  801b34:	89 d0                	mov    %edx,%eax
  801b36:	31 d2                	xor    %edx,%edx
  801b38:	83 c4 1c             	add    $0x1c,%esp
  801b3b:	5b                   	pop    %ebx
  801b3c:	5e                   	pop    %esi
  801b3d:	5f                   	pop    %edi
  801b3e:	5d                   	pop    %ebp
  801b3f:	c3                   	ret    
  801b40:	39 f0                	cmp    %esi,%eax
  801b42:	0f 87 ac 00 00 00    	ja     801bf4 <__umoddi3+0xfc>
  801b48:	0f bd e8             	bsr    %eax,%ebp
  801b4b:	83 f5 1f             	xor    $0x1f,%ebp
  801b4e:	0f 84 ac 00 00 00    	je     801c00 <__umoddi3+0x108>
  801b54:	bf 20 00 00 00       	mov    $0x20,%edi
  801b59:	29 ef                	sub    %ebp,%edi
  801b5b:	89 fe                	mov    %edi,%esi
  801b5d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b61:	89 e9                	mov    %ebp,%ecx
  801b63:	d3 e0                	shl    %cl,%eax
  801b65:	89 d7                	mov    %edx,%edi
  801b67:	89 f1                	mov    %esi,%ecx
  801b69:	d3 ef                	shr    %cl,%edi
  801b6b:	09 c7                	or     %eax,%edi
  801b6d:	89 e9                	mov    %ebp,%ecx
  801b6f:	d3 e2                	shl    %cl,%edx
  801b71:	89 14 24             	mov    %edx,(%esp)
  801b74:	89 d8                	mov    %ebx,%eax
  801b76:	d3 e0                	shl    %cl,%eax
  801b78:	89 c2                	mov    %eax,%edx
  801b7a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b7e:	d3 e0                	shl    %cl,%eax
  801b80:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b84:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b88:	89 f1                	mov    %esi,%ecx
  801b8a:	d3 e8                	shr    %cl,%eax
  801b8c:	09 d0                	or     %edx,%eax
  801b8e:	d3 eb                	shr    %cl,%ebx
  801b90:	89 da                	mov    %ebx,%edx
  801b92:	f7 f7                	div    %edi
  801b94:	89 d3                	mov    %edx,%ebx
  801b96:	f7 24 24             	mull   (%esp)
  801b99:	89 c6                	mov    %eax,%esi
  801b9b:	89 d1                	mov    %edx,%ecx
  801b9d:	39 d3                	cmp    %edx,%ebx
  801b9f:	0f 82 87 00 00 00    	jb     801c2c <__umoddi3+0x134>
  801ba5:	0f 84 91 00 00 00    	je     801c3c <__umoddi3+0x144>
  801bab:	8b 54 24 04          	mov    0x4(%esp),%edx
  801baf:	29 f2                	sub    %esi,%edx
  801bb1:	19 cb                	sbb    %ecx,%ebx
  801bb3:	89 d8                	mov    %ebx,%eax
  801bb5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bb9:	d3 e0                	shl    %cl,%eax
  801bbb:	89 e9                	mov    %ebp,%ecx
  801bbd:	d3 ea                	shr    %cl,%edx
  801bbf:	09 d0                	or     %edx,%eax
  801bc1:	89 e9                	mov    %ebp,%ecx
  801bc3:	d3 eb                	shr    %cl,%ebx
  801bc5:	89 da                	mov    %ebx,%edx
  801bc7:	83 c4 1c             	add    $0x1c,%esp
  801bca:	5b                   	pop    %ebx
  801bcb:	5e                   	pop    %esi
  801bcc:	5f                   	pop    %edi
  801bcd:	5d                   	pop    %ebp
  801bce:	c3                   	ret    
  801bcf:	90                   	nop
  801bd0:	89 fd                	mov    %edi,%ebp
  801bd2:	85 ff                	test   %edi,%edi
  801bd4:	75 0b                	jne    801be1 <__umoddi3+0xe9>
  801bd6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bdb:	31 d2                	xor    %edx,%edx
  801bdd:	f7 f7                	div    %edi
  801bdf:	89 c5                	mov    %eax,%ebp
  801be1:	89 f0                	mov    %esi,%eax
  801be3:	31 d2                	xor    %edx,%edx
  801be5:	f7 f5                	div    %ebp
  801be7:	89 c8                	mov    %ecx,%eax
  801be9:	f7 f5                	div    %ebp
  801beb:	89 d0                	mov    %edx,%eax
  801bed:	e9 44 ff ff ff       	jmp    801b36 <__umoddi3+0x3e>
  801bf2:	66 90                	xchg   %ax,%ax
  801bf4:	89 c8                	mov    %ecx,%eax
  801bf6:	89 f2                	mov    %esi,%edx
  801bf8:	83 c4 1c             	add    $0x1c,%esp
  801bfb:	5b                   	pop    %ebx
  801bfc:	5e                   	pop    %esi
  801bfd:	5f                   	pop    %edi
  801bfe:	5d                   	pop    %ebp
  801bff:	c3                   	ret    
  801c00:	3b 04 24             	cmp    (%esp),%eax
  801c03:	72 06                	jb     801c0b <__umoddi3+0x113>
  801c05:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c09:	77 0f                	ja     801c1a <__umoddi3+0x122>
  801c0b:	89 f2                	mov    %esi,%edx
  801c0d:	29 f9                	sub    %edi,%ecx
  801c0f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c13:	89 14 24             	mov    %edx,(%esp)
  801c16:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c1a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c1e:	8b 14 24             	mov    (%esp),%edx
  801c21:	83 c4 1c             	add    $0x1c,%esp
  801c24:	5b                   	pop    %ebx
  801c25:	5e                   	pop    %esi
  801c26:	5f                   	pop    %edi
  801c27:	5d                   	pop    %ebp
  801c28:	c3                   	ret    
  801c29:	8d 76 00             	lea    0x0(%esi),%esi
  801c2c:	2b 04 24             	sub    (%esp),%eax
  801c2f:	19 fa                	sbb    %edi,%edx
  801c31:	89 d1                	mov    %edx,%ecx
  801c33:	89 c6                	mov    %eax,%esi
  801c35:	e9 71 ff ff ff       	jmp    801bab <__umoddi3+0xb3>
  801c3a:	66 90                	xchg   %ax,%ax
  801c3c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c40:	72 ea                	jb     801c2c <__umoddi3+0x134>
  801c42:	89 d9                	mov    %ebx,%ecx
  801c44:	e9 62 ff ff ff       	jmp    801bab <__umoddi3+0xb3>

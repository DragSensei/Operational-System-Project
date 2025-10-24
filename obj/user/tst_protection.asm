
obj/user/tst_protection:     file format elf32-i386


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
  800031:	e8 bc 00 00 00       	call   8000f2 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp

	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80003e:	a1 20 30 80 00       	mov    0x803020,%eax
  800043:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  800049:	a1 20 30 80 00       	mov    0x803020,%eax
  80004e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800054:	39 c2                	cmp    %eax,%edx
  800056:	72 14                	jb     80006c <_main+0x34>
			panic("Please increase the WS size");
  800058:	83 ec 04             	sub    $0x4,%esp
  80005b:	68 80 1c 80 00       	push   $0x801c80
  800060:	6a 12                	push   $0x12
  800062:	68 9c 1c 80 00       	push   $0x801c9c
  800067:	e8 36 02 00 00       	call   8002a2 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	int numOfSlaves = 3;
  80006c:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
	rsttst();
  800073:	e8 a3 17 00 00       	call   80181b <rsttst>
	//[1] Run programs that allocate many shared variables
	for (int i = 0; i < numOfSlaves; ++i) {
  800078:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80007f:	eb 47                	jmp    8000c8 <_main+0x90>
		int32 envId = sys_create_env("protection_slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800081:	a1 20 30 80 00       	mov    0x803020,%eax
  800086:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  80008c:	a1 20 30 80 00       	mov    0x803020,%eax
  800091:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800097:	89 c1                	mov    %eax,%ecx
  800099:	a1 20 30 80 00       	mov    0x803020,%eax
  80009e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000a4:	52                   	push   %edx
  8000a5:	51                   	push   %ecx
  8000a6:	50                   	push   %eax
  8000a7:	68 b2 1c 80 00       	push   $0x801cb2
  8000ac:	e8 1e 16 00 00       	call   8016cf <sys_create_env>
  8000b1:	83 c4 10             	add    $0x10,%esp
  8000b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		sys_run_env(envId);
  8000b7:	83 ec 0c             	sub    $0xc,%esp
  8000ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8000bd:	e8 2b 16 00 00       	call   8016ed <sys_run_env>
  8000c2:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int numOfSlaves = 3;
	rsttst();
	//[1] Run programs that allocate many shared variables
	for (int i = 0; i < numOfSlaves; ++i) {
  8000c5:	ff 45 f4             	incl   -0xc(%ebp)
  8000c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000ce:	7c b1                	jl     800081 <_main+0x49>
		int32 envId = sys_create_env("protection_slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
		sys_run_env(envId);
	}

	while (gettst() != numOfSlaves) ;
  8000d0:	90                   	nop
  8000d1:	e8 bf 17 00 00       	call   801895 <gettst>
  8000d6:	89 c2                	mov    %eax,%edx
  8000d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000db:	39 c2                	cmp    %eax,%edx
  8000dd:	75 f2                	jne    8000d1 <_main+0x99>

	cprintf("%~\nCongratulations... test protection is run successfully\n");
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 c4 1c 80 00       	push   $0x801cc4
  8000e7:	e8 84 04 00 00       	call   800570 <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp

}
  8000ef:	90                   	nop
  8000f0:	c9                   	leave  
  8000f1:	c3                   	ret    

008000f2 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	57                   	push   %edi
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000fb:	e8 3d 16 00 00       	call   80173d <sys_getenvindex>
  800100:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800103:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800106:	89 d0                	mov    %edx,%eax
  800108:	c1 e0 02             	shl    $0x2,%eax
  80010b:	01 d0                	add    %edx,%eax
  80010d:	c1 e0 03             	shl    $0x3,%eax
  800110:	01 d0                	add    %edx,%eax
  800112:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800119:	01 d0                	add    %edx,%eax
  80011b:	c1 e0 02             	shl    $0x2,%eax
  80011e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800123:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800128:	a1 20 30 80 00       	mov    0x803020,%eax
  80012d:	8a 40 20             	mov    0x20(%eax),%al
  800130:	84 c0                	test   %al,%al
  800132:	74 0d                	je     800141 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800134:	a1 20 30 80 00       	mov    0x803020,%eax
  800139:	83 c0 20             	add    $0x20,%eax
  80013c:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800141:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800145:	7e 0a                	jle    800151 <libmain+0x5f>
		binaryname = argv[0];
  800147:	8b 45 0c             	mov    0xc(%ebp),%eax
  80014a:	8b 00                	mov    (%eax),%eax
  80014c:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800151:	83 ec 08             	sub    $0x8,%esp
  800154:	ff 75 0c             	pushl  0xc(%ebp)
  800157:	ff 75 08             	pushl  0x8(%ebp)
  80015a:	e8 d9 fe ff ff       	call   800038 <_main>
  80015f:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800162:	a1 00 30 80 00       	mov    0x803000,%eax
  800167:	85 c0                	test   %eax,%eax
  800169:	0f 84 01 01 00 00    	je     800270 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80016f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800175:	bb f8 1d 80 00       	mov    $0x801df8,%ebx
  80017a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80017f:	89 c7                	mov    %eax,%edi
  800181:	89 de                	mov    %ebx,%esi
  800183:	89 d1                	mov    %edx,%ecx
  800185:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800187:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80018a:	b9 56 00 00 00       	mov    $0x56,%ecx
  80018f:	b0 00                	mov    $0x0,%al
  800191:	89 d7                	mov    %edx,%edi
  800193:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800195:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80019c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80019f:	83 ec 08             	sub    $0x8,%esp
  8001a2:	50                   	push   %eax
  8001a3:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001a9:	50                   	push   %eax
  8001aa:	e8 c4 17 00 00       	call   801973 <sys_utilities>
  8001af:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001b2:	e8 0d 13 00 00       	call   8014c4 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001b7:	83 ec 0c             	sub    $0xc,%esp
  8001ba:	68 18 1d 80 00       	push   $0x801d18
  8001bf:	e8 ac 03 00 00       	call   800570 <cprintf>
  8001c4:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ca:	85 c0                	test   %eax,%eax
  8001cc:	74 18                	je     8001e6 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001ce:	e8 be 17 00 00       	call   801991 <sys_get_optimal_num_faults>
  8001d3:	83 ec 08             	sub    $0x8,%esp
  8001d6:	50                   	push   %eax
  8001d7:	68 40 1d 80 00       	push   $0x801d40
  8001dc:	e8 8f 03 00 00       	call   800570 <cprintf>
  8001e1:	83 c4 10             	add    $0x10,%esp
  8001e4:	eb 59                	jmp    80023f <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001e6:	a1 20 30 80 00       	mov    0x803020,%eax
  8001eb:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8001f1:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f6:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8001fc:	83 ec 04             	sub    $0x4,%esp
  8001ff:	52                   	push   %edx
  800200:	50                   	push   %eax
  800201:	68 64 1d 80 00       	push   $0x801d64
  800206:	e8 65 03 00 00       	call   800570 <cprintf>
  80020b:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80020e:	a1 20 30 80 00       	mov    0x803020,%eax
  800213:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800219:	a1 20 30 80 00       	mov    0x803020,%eax
  80021e:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800224:	a1 20 30 80 00       	mov    0x803020,%eax
  800229:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80022f:	51                   	push   %ecx
  800230:	52                   	push   %edx
  800231:	50                   	push   %eax
  800232:	68 8c 1d 80 00       	push   $0x801d8c
  800237:	e8 34 03 00 00       	call   800570 <cprintf>
  80023c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80023f:	a1 20 30 80 00       	mov    0x803020,%eax
  800244:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80024a:	83 ec 08             	sub    $0x8,%esp
  80024d:	50                   	push   %eax
  80024e:	68 e4 1d 80 00       	push   $0x801de4
  800253:	e8 18 03 00 00       	call   800570 <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 18 1d 80 00       	push   $0x801d18
  800263:	e8 08 03 00 00       	call   800570 <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80026b:	e8 6e 12 00 00       	call   8014de <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800270:	e8 1f 00 00 00       	call   800294 <exit>
}
  800275:	90                   	nop
  800276:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800279:	5b                   	pop    %ebx
  80027a:	5e                   	pop    %esi
  80027b:	5f                   	pop    %edi
  80027c:	5d                   	pop    %ebp
  80027d:	c3                   	ret    

0080027e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800284:	83 ec 0c             	sub    $0xc,%esp
  800287:	6a 00                	push   $0x0
  800289:	e8 7b 14 00 00       	call   801709 <sys_destroy_env>
  80028e:	83 c4 10             	add    $0x10,%esp
}
  800291:	90                   	nop
  800292:	c9                   	leave  
  800293:	c3                   	ret    

00800294 <exit>:

void
exit(void)
{
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80029a:	e8 d0 14 00 00       	call   80176f <sys_exit_env>
}
  80029f:	90                   	nop
  8002a0:	c9                   	leave  
  8002a1:	c3                   	ret    

008002a2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002a2:	55                   	push   %ebp
  8002a3:	89 e5                	mov    %esp,%ebp
  8002a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002a8:	8d 45 10             	lea    0x10(%ebp),%eax
  8002ab:	83 c0 04             	add    $0x4,%eax
  8002ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002b1:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002b6:	85 c0                	test   %eax,%eax
  8002b8:	74 16                	je     8002d0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002ba:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002bf:	83 ec 08             	sub    $0x8,%esp
  8002c2:	50                   	push   %eax
  8002c3:	68 5c 1e 80 00       	push   $0x801e5c
  8002c8:	e8 a3 02 00 00       	call   800570 <cprintf>
  8002cd:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8002d0:	a1 04 30 80 00       	mov    0x803004,%eax
  8002d5:	83 ec 0c             	sub    $0xc,%esp
  8002d8:	ff 75 0c             	pushl  0xc(%ebp)
  8002db:	ff 75 08             	pushl  0x8(%ebp)
  8002de:	50                   	push   %eax
  8002df:	68 64 1e 80 00       	push   $0x801e64
  8002e4:	6a 74                	push   $0x74
  8002e6:	e8 b2 02 00 00       	call   80059d <cprintf_colored>
  8002eb:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8002ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f1:	83 ec 08             	sub    $0x8,%esp
  8002f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8002f7:	50                   	push   %eax
  8002f8:	e8 04 02 00 00       	call   800501 <vcprintf>
  8002fd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800300:	83 ec 08             	sub    $0x8,%esp
  800303:	6a 00                	push   $0x0
  800305:	68 8c 1e 80 00       	push   $0x801e8c
  80030a:	e8 f2 01 00 00       	call   800501 <vcprintf>
  80030f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800312:	e8 7d ff ff ff       	call   800294 <exit>

	// should not return here
	while (1) ;
  800317:	eb fe                	jmp    800317 <_panic+0x75>

00800319 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800319:	55                   	push   %ebp
  80031a:	89 e5                	mov    %esp,%ebp
  80031c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80031f:	a1 20 30 80 00       	mov    0x803020,%eax
  800324:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80032a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032d:	39 c2                	cmp    %eax,%edx
  80032f:	74 14                	je     800345 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800331:	83 ec 04             	sub    $0x4,%esp
  800334:	68 90 1e 80 00       	push   $0x801e90
  800339:	6a 26                	push   $0x26
  80033b:	68 dc 1e 80 00       	push   $0x801edc
  800340:	e8 5d ff ff ff       	call   8002a2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800345:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80034c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800353:	e9 c5 00 00 00       	jmp    80041d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80035b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800362:	8b 45 08             	mov    0x8(%ebp),%eax
  800365:	01 d0                	add    %edx,%eax
  800367:	8b 00                	mov    (%eax),%eax
  800369:	85 c0                	test   %eax,%eax
  80036b:	75 08                	jne    800375 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80036d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800370:	e9 a5 00 00 00       	jmp    80041a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800375:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80037c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800383:	eb 69                	jmp    8003ee <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800385:	a1 20 30 80 00       	mov    0x803020,%eax
  80038a:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800390:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800393:	89 d0                	mov    %edx,%eax
  800395:	01 c0                	add    %eax,%eax
  800397:	01 d0                	add    %edx,%eax
  800399:	c1 e0 03             	shl    $0x3,%eax
  80039c:	01 c8                	add    %ecx,%eax
  80039e:	8a 40 04             	mov    0x4(%eax),%al
  8003a1:	84 c0                	test   %al,%al
  8003a3:	75 46                	jne    8003eb <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003a5:	a1 20 30 80 00       	mov    0x803020,%eax
  8003aa:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003b3:	89 d0                	mov    %edx,%eax
  8003b5:	01 c0                	add    %eax,%eax
  8003b7:	01 d0                	add    %edx,%eax
  8003b9:	c1 e0 03             	shl    $0x3,%eax
  8003bc:	01 c8                	add    %ecx,%eax
  8003be:	8b 00                	mov    (%eax),%eax
  8003c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003cb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003da:	01 c8                	add    %ecx,%eax
  8003dc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003de:	39 c2                	cmp    %eax,%edx
  8003e0:	75 09                	jne    8003eb <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003e2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003e9:	eb 15                	jmp    800400 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003eb:	ff 45 e8             	incl   -0x18(%ebp)
  8003ee:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003fc:	39 c2                	cmp    %eax,%edx
  8003fe:	77 85                	ja     800385 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800400:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800404:	75 14                	jne    80041a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800406:	83 ec 04             	sub    $0x4,%esp
  800409:	68 e8 1e 80 00       	push   $0x801ee8
  80040e:	6a 3a                	push   $0x3a
  800410:	68 dc 1e 80 00       	push   $0x801edc
  800415:	e8 88 fe ff ff       	call   8002a2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80041a:	ff 45 f0             	incl   -0x10(%ebp)
  80041d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800420:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800423:	0f 8c 2f ff ff ff    	jl     800358 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800429:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800430:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800437:	eb 26                	jmp    80045f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800439:	a1 20 30 80 00       	mov    0x803020,%eax
  80043e:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800444:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800447:	89 d0                	mov    %edx,%eax
  800449:	01 c0                	add    %eax,%eax
  80044b:	01 d0                	add    %edx,%eax
  80044d:	c1 e0 03             	shl    $0x3,%eax
  800450:	01 c8                	add    %ecx,%eax
  800452:	8a 40 04             	mov    0x4(%eax),%al
  800455:	3c 01                	cmp    $0x1,%al
  800457:	75 03                	jne    80045c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800459:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80045c:	ff 45 e0             	incl   -0x20(%ebp)
  80045f:	a1 20 30 80 00       	mov    0x803020,%eax
  800464:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80046a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80046d:	39 c2                	cmp    %eax,%edx
  80046f:	77 c8                	ja     800439 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800474:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800477:	74 14                	je     80048d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800479:	83 ec 04             	sub    $0x4,%esp
  80047c:	68 3c 1f 80 00       	push   $0x801f3c
  800481:	6a 44                	push   $0x44
  800483:	68 dc 1e 80 00       	push   $0x801edc
  800488:	e8 15 fe ff ff       	call   8002a2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80048d:	90                   	nop
  80048e:	c9                   	leave  
  80048f:	c3                   	ret    

00800490 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
  800493:	53                   	push   %ebx
  800494:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800497:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049a:	8b 00                	mov    (%eax),%eax
  80049c:	8d 48 01             	lea    0x1(%eax),%ecx
  80049f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a2:	89 0a                	mov    %ecx,(%edx)
  8004a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8004a7:	88 d1                	mov    %dl,%cl
  8004a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ac:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b3:	8b 00                	mov    (%eax),%eax
  8004b5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004ba:	75 30                	jne    8004ec <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004bc:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004c2:	a0 44 30 80 00       	mov    0x803044,%al
  8004c7:	0f b6 c0             	movzbl %al,%eax
  8004ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004cd:	8b 09                	mov    (%ecx),%ecx
  8004cf:	89 cb                	mov    %ecx,%ebx
  8004d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004d4:	83 c1 08             	add    $0x8,%ecx
  8004d7:	52                   	push   %edx
  8004d8:	50                   	push   %eax
  8004d9:	53                   	push   %ebx
  8004da:	51                   	push   %ecx
  8004db:	e8 a0 0f 00 00       	call   801480 <sys_cputs>
  8004e0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ef:	8b 40 04             	mov    0x4(%eax),%eax
  8004f2:	8d 50 01             	lea    0x1(%eax),%edx
  8004f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f8:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004fb:	90                   	nop
  8004fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004ff:	c9                   	leave  
  800500:	c3                   	ret    

00800501 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800501:	55                   	push   %ebp
  800502:	89 e5                	mov    %esp,%ebp
  800504:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80050a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800511:	00 00 00 
	b.cnt = 0;
  800514:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80051b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80051e:	ff 75 0c             	pushl  0xc(%ebp)
  800521:	ff 75 08             	pushl  0x8(%ebp)
  800524:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80052a:	50                   	push   %eax
  80052b:	68 90 04 80 00       	push   $0x800490
  800530:	e8 5a 02 00 00       	call   80078f <vprintfmt>
  800535:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800538:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80053e:	a0 44 30 80 00       	mov    0x803044,%al
  800543:	0f b6 c0             	movzbl %al,%eax
  800546:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80054c:	52                   	push   %edx
  80054d:	50                   	push   %eax
  80054e:	51                   	push   %ecx
  80054f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800555:	83 c0 08             	add    $0x8,%eax
  800558:	50                   	push   %eax
  800559:	e8 22 0f 00 00       	call   801480 <sys_cputs>
  80055e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800561:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800568:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80056e:	c9                   	leave  
  80056f:	c3                   	ret    

00800570 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800570:	55                   	push   %ebp
  800571:	89 e5                	mov    %esp,%ebp
  800573:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800576:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80057d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800580:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800583:	8b 45 08             	mov    0x8(%ebp),%eax
  800586:	83 ec 08             	sub    $0x8,%esp
  800589:	ff 75 f4             	pushl  -0xc(%ebp)
  80058c:	50                   	push   %eax
  80058d:	e8 6f ff ff ff       	call   800501 <vcprintf>
  800592:	83 c4 10             	add    $0x10,%esp
  800595:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800598:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80059b:	c9                   	leave  
  80059c:	c3                   	ret    

0080059d <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80059d:	55                   	push   %ebp
  80059e:	89 e5                	mov    %esp,%ebp
  8005a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005a3:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	c1 e0 08             	shl    $0x8,%eax
  8005b0:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8005b5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005b8:	83 c0 04             	add    $0x4,%eax
  8005bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c1:	83 ec 08             	sub    $0x8,%esp
  8005c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c7:	50                   	push   %eax
  8005c8:	e8 34 ff ff ff       	call   800501 <vcprintf>
  8005cd:	83 c4 10             	add    $0x10,%esp
  8005d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8005d3:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8005da:	07 00 00 

	return cnt;
  8005dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005e0:	c9                   	leave  
  8005e1:	c3                   	ret    

008005e2 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8005e2:	55                   	push   %ebp
  8005e3:	89 e5                	mov    %esp,%ebp
  8005e5:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8005e8:	e8 d7 0e 00 00       	call   8014c4 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005ed:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f6:	83 ec 08             	sub    $0x8,%esp
  8005f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8005fc:	50                   	push   %eax
  8005fd:	e8 ff fe ff ff       	call   800501 <vcprintf>
  800602:	83 c4 10             	add    $0x10,%esp
  800605:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800608:	e8 d1 0e 00 00       	call   8014de <sys_unlock_cons>
	return cnt;
  80060d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800610:	c9                   	leave  
  800611:	c3                   	ret    

00800612 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800612:	55                   	push   %ebp
  800613:	89 e5                	mov    %esp,%ebp
  800615:	53                   	push   %ebx
  800616:	83 ec 14             	sub    $0x14,%esp
  800619:	8b 45 10             	mov    0x10(%ebp),%eax
  80061c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80061f:	8b 45 14             	mov    0x14(%ebp),%eax
  800622:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800625:	8b 45 18             	mov    0x18(%ebp),%eax
  800628:	ba 00 00 00 00       	mov    $0x0,%edx
  80062d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800630:	77 55                	ja     800687 <printnum+0x75>
  800632:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800635:	72 05                	jb     80063c <printnum+0x2a>
  800637:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80063a:	77 4b                	ja     800687 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80063c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80063f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800642:	8b 45 18             	mov    0x18(%ebp),%eax
  800645:	ba 00 00 00 00       	mov    $0x0,%edx
  80064a:	52                   	push   %edx
  80064b:	50                   	push   %eax
  80064c:	ff 75 f4             	pushl  -0xc(%ebp)
  80064f:	ff 75 f0             	pushl  -0x10(%ebp)
  800652:	e8 a9 13 00 00       	call   801a00 <__udivdi3>
  800657:	83 c4 10             	add    $0x10,%esp
  80065a:	83 ec 04             	sub    $0x4,%esp
  80065d:	ff 75 20             	pushl  0x20(%ebp)
  800660:	53                   	push   %ebx
  800661:	ff 75 18             	pushl  0x18(%ebp)
  800664:	52                   	push   %edx
  800665:	50                   	push   %eax
  800666:	ff 75 0c             	pushl  0xc(%ebp)
  800669:	ff 75 08             	pushl  0x8(%ebp)
  80066c:	e8 a1 ff ff ff       	call   800612 <printnum>
  800671:	83 c4 20             	add    $0x20,%esp
  800674:	eb 1a                	jmp    800690 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800676:	83 ec 08             	sub    $0x8,%esp
  800679:	ff 75 0c             	pushl  0xc(%ebp)
  80067c:	ff 75 20             	pushl  0x20(%ebp)
  80067f:	8b 45 08             	mov    0x8(%ebp),%eax
  800682:	ff d0                	call   *%eax
  800684:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800687:	ff 4d 1c             	decl   0x1c(%ebp)
  80068a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80068e:	7f e6                	jg     800676 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800690:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800693:	bb 00 00 00 00       	mov    $0x0,%ebx
  800698:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80069b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80069e:	53                   	push   %ebx
  80069f:	51                   	push   %ecx
  8006a0:	52                   	push   %edx
  8006a1:	50                   	push   %eax
  8006a2:	e8 69 14 00 00       	call   801b10 <__umoddi3>
  8006a7:	83 c4 10             	add    $0x10,%esp
  8006aa:	05 b4 21 80 00       	add    $0x8021b4,%eax
  8006af:	8a 00                	mov    (%eax),%al
  8006b1:	0f be c0             	movsbl %al,%eax
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	ff 75 0c             	pushl  0xc(%ebp)
  8006ba:	50                   	push   %eax
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	ff d0                	call   *%eax
  8006c0:	83 c4 10             	add    $0x10,%esp
}
  8006c3:	90                   	nop
  8006c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006c7:	c9                   	leave  
  8006c8:	c3                   	ret    

008006c9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006c9:	55                   	push   %ebp
  8006ca:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006cc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006d0:	7e 1c                	jle    8006ee <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d5:	8b 00                	mov    (%eax),%eax
  8006d7:	8d 50 08             	lea    0x8(%eax),%edx
  8006da:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dd:	89 10                	mov    %edx,(%eax)
  8006df:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	83 e8 08             	sub    $0x8,%eax
  8006e7:	8b 50 04             	mov    0x4(%eax),%edx
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	eb 40                	jmp    80072e <getuint+0x65>
	else if (lflag)
  8006ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006f2:	74 1e                	je     800712 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f7:	8b 00                	mov    (%eax),%eax
  8006f9:	8d 50 04             	lea    0x4(%eax),%edx
  8006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ff:	89 10                	mov    %edx,(%eax)
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	8b 00                	mov    (%eax),%eax
  800706:	83 e8 04             	sub    $0x4,%eax
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	ba 00 00 00 00       	mov    $0x0,%edx
  800710:	eb 1c                	jmp    80072e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800712:	8b 45 08             	mov    0x8(%ebp),%eax
  800715:	8b 00                	mov    (%eax),%eax
  800717:	8d 50 04             	lea    0x4(%eax),%edx
  80071a:	8b 45 08             	mov    0x8(%ebp),%eax
  80071d:	89 10                	mov    %edx,(%eax)
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	8b 00                	mov    (%eax),%eax
  800724:	83 e8 04             	sub    $0x4,%eax
  800727:	8b 00                	mov    (%eax),%eax
  800729:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80072e:	5d                   	pop    %ebp
  80072f:	c3                   	ret    

00800730 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800730:	55                   	push   %ebp
  800731:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800733:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800737:	7e 1c                	jle    800755 <getint+0x25>
		return va_arg(*ap, long long);
  800739:	8b 45 08             	mov    0x8(%ebp),%eax
  80073c:	8b 00                	mov    (%eax),%eax
  80073e:	8d 50 08             	lea    0x8(%eax),%edx
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	89 10                	mov    %edx,(%eax)
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	83 e8 08             	sub    $0x8,%eax
  80074e:	8b 50 04             	mov    0x4(%eax),%edx
  800751:	8b 00                	mov    (%eax),%eax
  800753:	eb 38                	jmp    80078d <getint+0x5d>
	else if (lflag)
  800755:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800759:	74 1a                	je     800775 <getint+0x45>
		return va_arg(*ap, long);
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	8d 50 04             	lea    0x4(%eax),%edx
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	89 10                	mov    %edx,(%eax)
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
  80076b:	8b 00                	mov    (%eax),%eax
  80076d:	83 e8 04             	sub    $0x4,%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	99                   	cltd   
  800773:	eb 18                	jmp    80078d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	8b 00                	mov    (%eax),%eax
  80077a:	8d 50 04             	lea    0x4(%eax),%edx
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	89 10                	mov    %edx,(%eax)
  800782:	8b 45 08             	mov    0x8(%ebp),%eax
  800785:	8b 00                	mov    (%eax),%eax
  800787:	83 e8 04             	sub    $0x4,%eax
  80078a:	8b 00                	mov    (%eax),%eax
  80078c:	99                   	cltd   
}
  80078d:	5d                   	pop    %ebp
  80078e:	c3                   	ret    

0080078f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	56                   	push   %esi
  800793:	53                   	push   %ebx
  800794:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800797:	eb 17                	jmp    8007b0 <vprintfmt+0x21>
			if (ch == '\0')
  800799:	85 db                	test   %ebx,%ebx
  80079b:	0f 84 c1 03 00 00    	je     800b62 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007a1:	83 ec 08             	sub    $0x8,%esp
  8007a4:	ff 75 0c             	pushl  0xc(%ebp)
  8007a7:	53                   	push   %ebx
  8007a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ab:	ff d0                	call   *%eax
  8007ad:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b3:	8d 50 01             	lea    0x1(%eax),%edx
  8007b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8007b9:	8a 00                	mov    (%eax),%al
  8007bb:	0f b6 d8             	movzbl %al,%ebx
  8007be:	83 fb 25             	cmp    $0x25,%ebx
  8007c1:	75 d6                	jne    800799 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007c3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007c7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007ce:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007d5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007dc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e6:	8d 50 01             	lea    0x1(%eax),%edx
  8007e9:	89 55 10             	mov    %edx,0x10(%ebp)
  8007ec:	8a 00                	mov    (%eax),%al
  8007ee:	0f b6 d8             	movzbl %al,%ebx
  8007f1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007f4:	83 f8 5b             	cmp    $0x5b,%eax
  8007f7:	0f 87 3d 03 00 00    	ja     800b3a <vprintfmt+0x3ab>
  8007fd:	8b 04 85 d8 21 80 00 	mov    0x8021d8(,%eax,4),%eax
  800804:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800806:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80080a:	eb d7                	jmp    8007e3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80080c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800810:	eb d1                	jmp    8007e3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800812:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800819:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80081c:	89 d0                	mov    %edx,%eax
  80081e:	c1 e0 02             	shl    $0x2,%eax
  800821:	01 d0                	add    %edx,%eax
  800823:	01 c0                	add    %eax,%eax
  800825:	01 d8                	add    %ebx,%eax
  800827:	83 e8 30             	sub    $0x30,%eax
  80082a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80082d:	8b 45 10             	mov    0x10(%ebp),%eax
  800830:	8a 00                	mov    (%eax),%al
  800832:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800835:	83 fb 2f             	cmp    $0x2f,%ebx
  800838:	7e 3e                	jle    800878 <vprintfmt+0xe9>
  80083a:	83 fb 39             	cmp    $0x39,%ebx
  80083d:	7f 39                	jg     800878 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80083f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800842:	eb d5                	jmp    800819 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800844:	8b 45 14             	mov    0x14(%ebp),%eax
  800847:	83 c0 04             	add    $0x4,%eax
  80084a:	89 45 14             	mov    %eax,0x14(%ebp)
  80084d:	8b 45 14             	mov    0x14(%ebp),%eax
  800850:	83 e8 04             	sub    $0x4,%eax
  800853:	8b 00                	mov    (%eax),%eax
  800855:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800858:	eb 1f                	jmp    800879 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80085a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80085e:	79 83                	jns    8007e3 <vprintfmt+0x54>
				width = 0;
  800860:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800867:	e9 77 ff ff ff       	jmp    8007e3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80086c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800873:	e9 6b ff ff ff       	jmp    8007e3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800878:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800879:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80087d:	0f 89 60 ff ff ff    	jns    8007e3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800883:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800886:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800889:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800890:	e9 4e ff ff ff       	jmp    8007e3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800895:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800898:	e9 46 ff ff ff       	jmp    8007e3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80089d:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a0:	83 c0 04             	add    $0x4,%eax
  8008a3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a9:	83 e8 04             	sub    $0x4,%eax
  8008ac:	8b 00                	mov    (%eax),%eax
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	ff 75 0c             	pushl  0xc(%ebp)
  8008b4:	50                   	push   %eax
  8008b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b8:	ff d0                	call   *%eax
  8008ba:	83 c4 10             	add    $0x10,%esp
			break;
  8008bd:	e9 9b 02 00 00       	jmp    800b5d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c5:	83 c0 04             	add    $0x4,%eax
  8008c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ce:	83 e8 04             	sub    $0x4,%eax
  8008d1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008d3:	85 db                	test   %ebx,%ebx
  8008d5:	79 02                	jns    8008d9 <vprintfmt+0x14a>
				err = -err;
  8008d7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008d9:	83 fb 64             	cmp    $0x64,%ebx
  8008dc:	7f 0b                	jg     8008e9 <vprintfmt+0x15a>
  8008de:	8b 34 9d 20 20 80 00 	mov    0x802020(,%ebx,4),%esi
  8008e5:	85 f6                	test   %esi,%esi
  8008e7:	75 19                	jne    800902 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008e9:	53                   	push   %ebx
  8008ea:	68 c5 21 80 00       	push   $0x8021c5
  8008ef:	ff 75 0c             	pushl  0xc(%ebp)
  8008f2:	ff 75 08             	pushl  0x8(%ebp)
  8008f5:	e8 70 02 00 00       	call   800b6a <printfmt>
  8008fa:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008fd:	e9 5b 02 00 00       	jmp    800b5d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800902:	56                   	push   %esi
  800903:	68 ce 21 80 00       	push   $0x8021ce
  800908:	ff 75 0c             	pushl  0xc(%ebp)
  80090b:	ff 75 08             	pushl  0x8(%ebp)
  80090e:	e8 57 02 00 00       	call   800b6a <printfmt>
  800913:	83 c4 10             	add    $0x10,%esp
			break;
  800916:	e9 42 02 00 00       	jmp    800b5d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80091b:	8b 45 14             	mov    0x14(%ebp),%eax
  80091e:	83 c0 04             	add    $0x4,%eax
  800921:	89 45 14             	mov    %eax,0x14(%ebp)
  800924:	8b 45 14             	mov    0x14(%ebp),%eax
  800927:	83 e8 04             	sub    $0x4,%eax
  80092a:	8b 30                	mov    (%eax),%esi
  80092c:	85 f6                	test   %esi,%esi
  80092e:	75 05                	jne    800935 <vprintfmt+0x1a6>
				p = "(null)";
  800930:	be d1 21 80 00       	mov    $0x8021d1,%esi
			if (width > 0 && padc != '-')
  800935:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800939:	7e 6d                	jle    8009a8 <vprintfmt+0x219>
  80093b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80093f:	74 67                	je     8009a8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800941:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800944:	83 ec 08             	sub    $0x8,%esp
  800947:	50                   	push   %eax
  800948:	56                   	push   %esi
  800949:	e8 1e 03 00 00       	call   800c6c <strnlen>
  80094e:	83 c4 10             	add    $0x10,%esp
  800951:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800954:	eb 16                	jmp    80096c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800956:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80095a:	83 ec 08             	sub    $0x8,%esp
  80095d:	ff 75 0c             	pushl  0xc(%ebp)
  800960:	50                   	push   %eax
  800961:	8b 45 08             	mov    0x8(%ebp),%eax
  800964:	ff d0                	call   *%eax
  800966:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800969:	ff 4d e4             	decl   -0x1c(%ebp)
  80096c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800970:	7f e4                	jg     800956 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800972:	eb 34                	jmp    8009a8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800974:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800978:	74 1c                	je     800996 <vprintfmt+0x207>
  80097a:	83 fb 1f             	cmp    $0x1f,%ebx
  80097d:	7e 05                	jle    800984 <vprintfmt+0x1f5>
  80097f:	83 fb 7e             	cmp    $0x7e,%ebx
  800982:	7e 12                	jle    800996 <vprintfmt+0x207>
					putch('?', putdat);
  800984:	83 ec 08             	sub    $0x8,%esp
  800987:	ff 75 0c             	pushl  0xc(%ebp)
  80098a:	6a 3f                	push   $0x3f
  80098c:	8b 45 08             	mov    0x8(%ebp),%eax
  80098f:	ff d0                	call   *%eax
  800991:	83 c4 10             	add    $0x10,%esp
  800994:	eb 0f                	jmp    8009a5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	ff 75 0c             	pushl  0xc(%ebp)
  80099c:	53                   	push   %ebx
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	ff d0                	call   *%eax
  8009a2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a5:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a8:	89 f0                	mov    %esi,%eax
  8009aa:	8d 70 01             	lea    0x1(%eax),%esi
  8009ad:	8a 00                	mov    (%eax),%al
  8009af:	0f be d8             	movsbl %al,%ebx
  8009b2:	85 db                	test   %ebx,%ebx
  8009b4:	74 24                	je     8009da <vprintfmt+0x24b>
  8009b6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ba:	78 b8                	js     800974 <vprintfmt+0x1e5>
  8009bc:	ff 4d e0             	decl   -0x20(%ebp)
  8009bf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009c3:	79 af                	jns    800974 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009c5:	eb 13                	jmp    8009da <vprintfmt+0x24b>
				putch(' ', putdat);
  8009c7:	83 ec 08             	sub    $0x8,%esp
  8009ca:	ff 75 0c             	pushl  0xc(%ebp)
  8009cd:	6a 20                	push   $0x20
  8009cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d2:	ff d0                	call   *%eax
  8009d4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009d7:	ff 4d e4             	decl   -0x1c(%ebp)
  8009da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009de:	7f e7                	jg     8009c7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009e0:	e9 78 01 00 00       	jmp    800b5d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009e5:	83 ec 08             	sub    $0x8,%esp
  8009e8:	ff 75 e8             	pushl  -0x18(%ebp)
  8009eb:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ee:	50                   	push   %eax
  8009ef:	e8 3c fd ff ff       	call   800730 <getint>
  8009f4:	83 c4 10             	add    $0x10,%esp
  8009f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009fa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a03:	85 d2                	test   %edx,%edx
  800a05:	79 23                	jns    800a2a <vprintfmt+0x29b>
				putch('-', putdat);
  800a07:	83 ec 08             	sub    $0x8,%esp
  800a0a:	ff 75 0c             	pushl  0xc(%ebp)
  800a0d:	6a 2d                	push   $0x2d
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	ff d0                	call   *%eax
  800a14:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a1d:	f7 d8                	neg    %eax
  800a1f:	83 d2 00             	adc    $0x0,%edx
  800a22:	f7 da                	neg    %edx
  800a24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a27:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a2a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a31:	e9 bc 00 00 00       	jmp    800af2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a36:	83 ec 08             	sub    $0x8,%esp
  800a39:	ff 75 e8             	pushl  -0x18(%ebp)
  800a3c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a3f:	50                   	push   %eax
  800a40:	e8 84 fc ff ff       	call   8006c9 <getuint>
  800a45:	83 c4 10             	add    $0x10,%esp
  800a48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a4e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a55:	e9 98 00 00 00       	jmp    800af2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a5a:	83 ec 08             	sub    $0x8,%esp
  800a5d:	ff 75 0c             	pushl  0xc(%ebp)
  800a60:	6a 58                	push   $0x58
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	ff d0                	call   *%eax
  800a67:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a6a:	83 ec 08             	sub    $0x8,%esp
  800a6d:	ff 75 0c             	pushl  0xc(%ebp)
  800a70:	6a 58                	push   $0x58
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	ff d0                	call   *%eax
  800a77:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a7a:	83 ec 08             	sub    $0x8,%esp
  800a7d:	ff 75 0c             	pushl  0xc(%ebp)
  800a80:	6a 58                	push   $0x58
  800a82:	8b 45 08             	mov    0x8(%ebp),%eax
  800a85:	ff d0                	call   *%eax
  800a87:	83 c4 10             	add    $0x10,%esp
			break;
  800a8a:	e9 ce 00 00 00       	jmp    800b5d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a8f:	83 ec 08             	sub    $0x8,%esp
  800a92:	ff 75 0c             	pushl  0xc(%ebp)
  800a95:	6a 30                	push   $0x30
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	ff d0                	call   *%eax
  800a9c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 0c             	pushl  0xc(%ebp)
  800aa5:	6a 78                	push   $0x78
  800aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaa:	ff d0                	call   *%eax
  800aac:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800aaf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab2:	83 c0 04             	add    $0x4,%eax
  800ab5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab8:	8b 45 14             	mov    0x14(%ebp),%eax
  800abb:	83 e8 04             	sub    $0x4,%eax
  800abe:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ac0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800aca:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ad1:	eb 1f                	jmp    800af2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 e8             	pushl  -0x18(%ebp)
  800ad9:	8d 45 14             	lea    0x14(%ebp),%eax
  800adc:	50                   	push   %eax
  800add:	e8 e7 fb ff ff       	call   8006c9 <getuint>
  800ae2:	83 c4 10             	add    $0x10,%esp
  800ae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aeb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800af2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800af6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800af9:	83 ec 04             	sub    $0x4,%esp
  800afc:	52                   	push   %edx
  800afd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b00:	50                   	push   %eax
  800b01:	ff 75 f4             	pushl  -0xc(%ebp)
  800b04:	ff 75 f0             	pushl  -0x10(%ebp)
  800b07:	ff 75 0c             	pushl  0xc(%ebp)
  800b0a:	ff 75 08             	pushl  0x8(%ebp)
  800b0d:	e8 00 fb ff ff       	call   800612 <printnum>
  800b12:	83 c4 20             	add    $0x20,%esp
			break;
  800b15:	eb 46                	jmp    800b5d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b17:	83 ec 08             	sub    $0x8,%esp
  800b1a:	ff 75 0c             	pushl  0xc(%ebp)
  800b1d:	53                   	push   %ebx
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	ff d0                	call   *%eax
  800b23:	83 c4 10             	add    $0x10,%esp
			break;
  800b26:	eb 35                	jmp    800b5d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b28:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b2f:	eb 2c                	jmp    800b5d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b31:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b38:	eb 23                	jmp    800b5d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b3a:	83 ec 08             	sub    $0x8,%esp
  800b3d:	ff 75 0c             	pushl  0xc(%ebp)
  800b40:	6a 25                	push   $0x25
  800b42:	8b 45 08             	mov    0x8(%ebp),%eax
  800b45:	ff d0                	call   *%eax
  800b47:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b4a:	ff 4d 10             	decl   0x10(%ebp)
  800b4d:	eb 03                	jmp    800b52 <vprintfmt+0x3c3>
  800b4f:	ff 4d 10             	decl   0x10(%ebp)
  800b52:	8b 45 10             	mov    0x10(%ebp),%eax
  800b55:	48                   	dec    %eax
  800b56:	8a 00                	mov    (%eax),%al
  800b58:	3c 25                	cmp    $0x25,%al
  800b5a:	75 f3                	jne    800b4f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b5c:	90                   	nop
		}
	}
  800b5d:	e9 35 fc ff ff       	jmp    800797 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b62:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b66:	5b                   	pop    %ebx
  800b67:	5e                   	pop    %esi
  800b68:	5d                   	pop    %ebp
  800b69:	c3                   	ret    

00800b6a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b70:	8d 45 10             	lea    0x10(%ebp),%eax
  800b73:	83 c0 04             	add    $0x4,%eax
  800b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b79:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b7f:	50                   	push   %eax
  800b80:	ff 75 0c             	pushl  0xc(%ebp)
  800b83:	ff 75 08             	pushl  0x8(%ebp)
  800b86:	e8 04 fc ff ff       	call   80078f <vprintfmt>
  800b8b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b8e:	90                   	nop
  800b8f:	c9                   	leave  
  800b90:	c3                   	ret    

00800b91 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b97:	8b 40 08             	mov    0x8(%eax),%eax
  800b9a:	8d 50 01             	lea    0x1(%eax),%edx
  800b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba0:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ba3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba6:	8b 10                	mov    (%eax),%edx
  800ba8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bab:	8b 40 04             	mov    0x4(%eax),%eax
  800bae:	39 c2                	cmp    %eax,%edx
  800bb0:	73 12                	jae    800bc4 <sprintputch+0x33>
		*b->buf++ = ch;
  800bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb5:	8b 00                	mov    (%eax),%eax
  800bb7:	8d 48 01             	lea    0x1(%eax),%ecx
  800bba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbd:	89 0a                	mov    %ecx,(%edx)
  800bbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc2:	88 10                	mov    %dl,(%eax)
}
  800bc4:	90                   	nop
  800bc5:	5d                   	pop    %ebp
  800bc6:	c3                   	ret    

00800bc7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bc7:	55                   	push   %ebp
  800bc8:	89 e5                	mov    %esp,%ebp
  800bca:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdc:	01 d0                	add    %edx,%eax
  800bde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800be8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bec:	74 06                	je     800bf4 <vsnprintf+0x2d>
  800bee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf2:	7f 07                	jg     800bfb <vsnprintf+0x34>
		return -E_INVAL;
  800bf4:	b8 03 00 00 00       	mov    $0x3,%eax
  800bf9:	eb 20                	jmp    800c1b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bfb:	ff 75 14             	pushl  0x14(%ebp)
  800bfe:	ff 75 10             	pushl  0x10(%ebp)
  800c01:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c04:	50                   	push   %eax
  800c05:	68 91 0b 80 00       	push   $0x800b91
  800c0a:	e8 80 fb ff ff       	call   80078f <vprintfmt>
  800c0f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c15:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c1b:	c9                   	leave  
  800c1c:	c3                   	ret    

00800c1d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c23:	8d 45 10             	lea    0x10(%ebp),%eax
  800c26:	83 c0 04             	add    $0x4,%eax
  800c29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2f:	ff 75 f4             	pushl  -0xc(%ebp)
  800c32:	50                   	push   %eax
  800c33:	ff 75 0c             	pushl  0xc(%ebp)
  800c36:	ff 75 08             	pushl  0x8(%ebp)
  800c39:	e8 89 ff ff ff       	call   800bc7 <vsnprintf>
  800c3e:	83 c4 10             	add    $0x10,%esp
  800c41:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c47:	c9                   	leave  
  800c48:	c3                   	ret    

00800c49 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c56:	eb 06                	jmp    800c5e <strlen+0x15>
		n++;
  800c58:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c5b:	ff 45 08             	incl   0x8(%ebp)
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	8a 00                	mov    (%eax),%al
  800c63:	84 c0                	test   %al,%al
  800c65:	75 f1                	jne    800c58 <strlen+0xf>
		n++;
	return n;
  800c67:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6a:	c9                   	leave  
  800c6b:	c3                   	ret    

00800c6c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c72:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c79:	eb 09                	jmp    800c84 <strnlen+0x18>
		n++;
  800c7b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c7e:	ff 45 08             	incl   0x8(%ebp)
  800c81:	ff 4d 0c             	decl   0xc(%ebp)
  800c84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c88:	74 09                	je     800c93 <strnlen+0x27>
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	8a 00                	mov    (%eax),%al
  800c8f:	84 c0                	test   %al,%al
  800c91:	75 e8                	jne    800c7b <strnlen+0xf>
		n++;
	return n;
  800c93:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c96:	c9                   	leave  
  800c97:	c3                   	ret    

00800c98 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ca4:	90                   	nop
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	8d 50 01             	lea    0x1(%eax),%edx
  800cab:	89 55 08             	mov    %edx,0x8(%ebp)
  800cae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cb4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cb7:	8a 12                	mov    (%edx),%dl
  800cb9:	88 10                	mov    %dl,(%eax)
  800cbb:	8a 00                	mov    (%eax),%al
  800cbd:	84 c0                	test   %al,%al
  800cbf:	75 e4                	jne    800ca5 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc4:	c9                   	leave  
  800cc5:	c3                   	ret    

00800cc6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cd2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd9:	eb 1f                	jmp    800cfa <strncpy+0x34>
		*dst++ = *src;
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	8d 50 01             	lea    0x1(%eax),%edx
  800ce1:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce7:	8a 12                	mov    (%edx),%dl
  800ce9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cee:	8a 00                	mov    (%eax),%al
  800cf0:	84 c0                	test   %al,%al
  800cf2:	74 03                	je     800cf7 <strncpy+0x31>
			src++;
  800cf4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cf7:	ff 45 fc             	incl   -0x4(%ebp)
  800cfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cfd:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d00:	72 d9                	jb     800cdb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d02:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d05:	c9                   	leave  
  800d06:	c3                   	ret    

00800d07 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d17:	74 30                	je     800d49 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d19:	eb 16                	jmp    800d31 <strlcpy+0x2a>
			*dst++ = *src++;
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	8d 50 01             	lea    0x1(%eax),%edx
  800d21:	89 55 08             	mov    %edx,0x8(%ebp)
  800d24:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d27:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d2a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d2d:	8a 12                	mov    (%edx),%dl
  800d2f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d31:	ff 4d 10             	decl   0x10(%ebp)
  800d34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d38:	74 09                	je     800d43 <strlcpy+0x3c>
  800d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3d:	8a 00                	mov    (%eax),%al
  800d3f:	84 c0                	test   %al,%al
  800d41:	75 d8                	jne    800d1b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d49:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4f:	29 c2                	sub    %eax,%edx
  800d51:	89 d0                	mov    %edx,%eax
}
  800d53:	c9                   	leave  
  800d54:	c3                   	ret    

00800d55 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d58:	eb 06                	jmp    800d60 <strcmp+0xb>
		p++, q++;
  800d5a:	ff 45 08             	incl   0x8(%ebp)
  800d5d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	8a 00                	mov    (%eax),%al
  800d65:	84 c0                	test   %al,%al
  800d67:	74 0e                	je     800d77 <strcmp+0x22>
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	8a 10                	mov    (%eax),%dl
  800d6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d71:	8a 00                	mov    (%eax),%al
  800d73:	38 c2                	cmp    %al,%dl
  800d75:	74 e3                	je     800d5a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	0f b6 d0             	movzbl %al,%edx
  800d7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d82:	8a 00                	mov    (%eax),%al
  800d84:	0f b6 c0             	movzbl %al,%eax
  800d87:	29 c2                	sub    %eax,%edx
  800d89:	89 d0                	mov    %edx,%eax
}
  800d8b:	5d                   	pop    %ebp
  800d8c:	c3                   	ret    

00800d8d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d90:	eb 09                	jmp    800d9b <strncmp+0xe>
		n--, p++, q++;
  800d92:	ff 4d 10             	decl   0x10(%ebp)
  800d95:	ff 45 08             	incl   0x8(%ebp)
  800d98:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d9b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d9f:	74 17                	je     800db8 <strncmp+0x2b>
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
  800da4:	8a 00                	mov    (%eax),%al
  800da6:	84 c0                	test   %al,%al
  800da8:	74 0e                	je     800db8 <strncmp+0x2b>
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dad:	8a 10                	mov    (%eax),%dl
  800daf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db2:	8a 00                	mov    (%eax),%al
  800db4:	38 c2                	cmp    %al,%dl
  800db6:	74 da                	je     800d92 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800db8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbc:	75 07                	jne    800dc5 <strncmp+0x38>
		return 0;
  800dbe:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc3:	eb 14                	jmp    800dd9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	0f b6 d0             	movzbl %al,%edx
  800dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd0:	8a 00                	mov    (%eax),%al
  800dd2:	0f b6 c0             	movzbl %al,%eax
  800dd5:	29 c2                	sub    %eax,%edx
  800dd7:	89 d0                	mov    %edx,%eax
}
  800dd9:	5d                   	pop    %ebp
  800dda:	c3                   	ret    

00800ddb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ddb:	55                   	push   %ebp
  800ddc:	89 e5                	mov    %esp,%ebp
  800dde:	83 ec 04             	sub    $0x4,%esp
  800de1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800de7:	eb 12                	jmp    800dfb <strchr+0x20>
		if (*s == c)
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dec:	8a 00                	mov    (%eax),%al
  800dee:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df1:	75 05                	jne    800df8 <strchr+0x1d>
			return (char *) s;
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
  800df6:	eb 11                	jmp    800e09 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800df8:	ff 45 08             	incl   0x8(%ebp)
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	8a 00                	mov    (%eax),%al
  800e00:	84 c0                	test   %al,%al
  800e02:	75 e5                	jne    800de9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e09:	c9                   	leave  
  800e0a:	c3                   	ret    

00800e0b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	83 ec 04             	sub    $0x4,%esp
  800e11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e14:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e17:	eb 0d                	jmp    800e26 <strfind+0x1b>
		if (*s == c)
  800e19:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1c:	8a 00                	mov    (%eax),%al
  800e1e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e21:	74 0e                	je     800e31 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e23:	ff 45 08             	incl   0x8(%ebp)
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	8a 00                	mov    (%eax),%al
  800e2b:	84 c0                	test   %al,%al
  800e2d:	75 ea                	jne    800e19 <strfind+0xe>
  800e2f:	eb 01                	jmp    800e32 <strfind+0x27>
		if (*s == c)
			break;
  800e31:	90                   	nop
	return (char *) s;
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e35:	c9                   	leave  
  800e36:	c3                   	ret    

00800e37 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
  800e3a:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e43:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e47:	76 63                	jbe    800eac <memset+0x75>
		uint64 data_block = c;
  800e49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4c:	99                   	cltd   
  800e4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e50:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e59:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e5d:	c1 e0 08             	shl    $0x8,%eax
  800e60:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e63:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e6c:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e70:	c1 e0 10             	shl    $0x10,%eax
  800e73:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e76:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e7f:	89 c2                	mov    %eax,%edx
  800e81:	b8 00 00 00 00       	mov    $0x0,%eax
  800e86:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e89:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e8c:	eb 18                	jmp    800ea6 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e8e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e91:	8d 41 08             	lea    0x8(%ecx),%eax
  800e94:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9d:	89 01                	mov    %eax,(%ecx)
  800e9f:	89 51 04             	mov    %edx,0x4(%ecx)
  800ea2:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ea6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800eaa:	77 e2                	ja     800e8e <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800eac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb0:	74 23                	je     800ed5 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800eb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eb8:	eb 0e                	jmp    800ec8 <memset+0x91>
			*p8++ = (uint8)c;
  800eba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebd:	8d 50 01             	lea    0x1(%eax),%edx
  800ec0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ec3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec6:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ece:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed1:	85 c0                	test   %eax,%eax
  800ed3:	75 e5                	jne    800eba <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed8:	c9                   	leave  
  800ed9:	c3                   	ret    

00800eda <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800eec:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ef0:	76 24                	jbe    800f16 <memcpy+0x3c>
		while(n >= 8){
  800ef2:	eb 1c                	jmp    800f10 <memcpy+0x36>
			*d64 = *s64;
  800ef4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef7:	8b 50 04             	mov    0x4(%eax),%edx
  800efa:	8b 00                	mov    (%eax),%eax
  800efc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800eff:	89 01                	mov    %eax,(%ecx)
  800f01:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f04:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f08:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f0c:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f10:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f14:	77 de                	ja     800ef4 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f16:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1a:	74 31                	je     800f4d <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f22:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f25:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f28:	eb 16                	jmp    800f40 <memcpy+0x66>
			*d8++ = *s8++;
  800f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f2d:	8d 50 01             	lea    0x1(%eax),%edx
  800f30:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f36:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f39:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f3c:	8a 12                	mov    (%edx),%dl
  800f3e:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f40:	8b 45 10             	mov    0x10(%ebp),%eax
  800f43:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f46:	89 55 10             	mov    %edx,0x10(%ebp)
  800f49:	85 c0                	test   %eax,%eax
  800f4b:	75 dd                	jne    800f2a <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f50:	c9                   	leave  
  800f51:	c3                   	ret    

00800f52 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f52:	55                   	push   %ebp
  800f53:	89 e5                	mov    %esp,%ebp
  800f55:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f67:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f6a:	73 50                	jae    800fbc <memmove+0x6a>
  800f6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f72:	01 d0                	add    %edx,%eax
  800f74:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f77:	76 43                	jbe    800fbc <memmove+0x6a>
		s += n;
  800f79:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f82:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f85:	eb 10                	jmp    800f97 <memmove+0x45>
			*--d = *--s;
  800f87:	ff 4d f8             	decl   -0x8(%ebp)
  800f8a:	ff 4d fc             	decl   -0x4(%ebp)
  800f8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f90:	8a 10                	mov    (%eax),%dl
  800f92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f95:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f97:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800fa0:	85 c0                	test   %eax,%eax
  800fa2:	75 e3                	jne    800f87 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fa4:	eb 23                	jmp    800fc9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fa6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa9:	8d 50 01             	lea    0x1(%eax),%edx
  800fac:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800faf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fb5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fb8:	8a 12                	mov    (%edx),%dl
  800fba:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fbc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc2:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc5:	85 c0                	test   %eax,%eax
  800fc7:	75 dd                	jne    800fa6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fcc:	c9                   	leave  
  800fcd:	c3                   	ret    

00800fce <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
  800fd1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fe0:	eb 2a                	jmp    80100c <memcmp+0x3e>
		if (*s1 != *s2)
  800fe2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe5:	8a 10                	mov    (%eax),%dl
  800fe7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	38 c2                	cmp    %al,%dl
  800fee:	74 16                	je     801006 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ff0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff3:	8a 00                	mov    (%eax),%al
  800ff5:	0f b6 d0             	movzbl %al,%edx
  800ff8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ffb:	8a 00                	mov    (%eax),%al
  800ffd:	0f b6 c0             	movzbl %al,%eax
  801000:	29 c2                	sub    %eax,%edx
  801002:	89 d0                	mov    %edx,%eax
  801004:	eb 18                	jmp    80101e <memcmp+0x50>
		s1++, s2++;
  801006:	ff 45 fc             	incl   -0x4(%ebp)
  801009:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80100c:	8b 45 10             	mov    0x10(%ebp),%eax
  80100f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801012:	89 55 10             	mov    %edx,0x10(%ebp)
  801015:	85 c0                	test   %eax,%eax
  801017:	75 c9                	jne    800fe2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801019:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80101e:	c9                   	leave  
  80101f:	c3                   	ret    

00801020 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801026:	8b 55 08             	mov    0x8(%ebp),%edx
  801029:	8b 45 10             	mov    0x10(%ebp),%eax
  80102c:	01 d0                	add    %edx,%eax
  80102e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801031:	eb 15                	jmp    801048 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	8a 00                	mov    (%eax),%al
  801038:	0f b6 d0             	movzbl %al,%edx
  80103b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103e:	0f b6 c0             	movzbl %al,%eax
  801041:	39 c2                	cmp    %eax,%edx
  801043:	74 0d                	je     801052 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801045:	ff 45 08             	incl   0x8(%ebp)
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80104e:	72 e3                	jb     801033 <memfind+0x13>
  801050:	eb 01                	jmp    801053 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801052:	90                   	nop
	return (void *) s;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801056:	c9                   	leave  
  801057:	c3                   	ret    

00801058 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
  80105b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80105e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801065:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80106c:	eb 03                	jmp    801071 <strtol+0x19>
		s++;
  80106e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	8a 00                	mov    (%eax),%al
  801076:	3c 20                	cmp    $0x20,%al
  801078:	74 f4                	je     80106e <strtol+0x16>
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	8a 00                	mov    (%eax),%al
  80107f:	3c 09                	cmp    $0x9,%al
  801081:	74 eb                	je     80106e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	3c 2b                	cmp    $0x2b,%al
  80108a:	75 05                	jne    801091 <strtol+0x39>
		s++;
  80108c:	ff 45 08             	incl   0x8(%ebp)
  80108f:	eb 13                	jmp    8010a4 <strtol+0x4c>
	else if (*s == '-')
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	8a 00                	mov    (%eax),%al
  801096:	3c 2d                	cmp    $0x2d,%al
  801098:	75 0a                	jne    8010a4 <strtol+0x4c>
		s++, neg = 1;
  80109a:	ff 45 08             	incl   0x8(%ebp)
  80109d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a8:	74 06                	je     8010b0 <strtol+0x58>
  8010aa:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010ae:	75 20                	jne    8010d0 <strtol+0x78>
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	8a 00                	mov    (%eax),%al
  8010b5:	3c 30                	cmp    $0x30,%al
  8010b7:	75 17                	jne    8010d0 <strtol+0x78>
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	40                   	inc    %eax
  8010bd:	8a 00                	mov    (%eax),%al
  8010bf:	3c 78                	cmp    $0x78,%al
  8010c1:	75 0d                	jne    8010d0 <strtol+0x78>
		s += 2, base = 16;
  8010c3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010c7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010ce:	eb 28                	jmp    8010f8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d4:	75 15                	jne    8010eb <strtol+0x93>
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	8a 00                	mov    (%eax),%al
  8010db:	3c 30                	cmp    $0x30,%al
  8010dd:	75 0c                	jne    8010eb <strtol+0x93>
		s++, base = 8;
  8010df:	ff 45 08             	incl   0x8(%ebp)
  8010e2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010e9:	eb 0d                	jmp    8010f8 <strtol+0xa0>
	else if (base == 0)
  8010eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ef:	75 07                	jne    8010f8 <strtol+0xa0>
		base = 10;
  8010f1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	8a 00                	mov    (%eax),%al
  8010fd:	3c 2f                	cmp    $0x2f,%al
  8010ff:	7e 19                	jle    80111a <strtol+0xc2>
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	8a 00                	mov    (%eax),%al
  801106:	3c 39                	cmp    $0x39,%al
  801108:	7f 10                	jg     80111a <strtol+0xc2>
			dig = *s - '0';
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	0f be c0             	movsbl %al,%eax
  801112:	83 e8 30             	sub    $0x30,%eax
  801115:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801118:	eb 42                	jmp    80115c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
  80111d:	8a 00                	mov    (%eax),%al
  80111f:	3c 60                	cmp    $0x60,%al
  801121:	7e 19                	jle    80113c <strtol+0xe4>
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	8a 00                	mov    (%eax),%al
  801128:	3c 7a                	cmp    $0x7a,%al
  80112a:	7f 10                	jg     80113c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	8a 00                	mov    (%eax),%al
  801131:	0f be c0             	movsbl %al,%eax
  801134:	83 e8 57             	sub    $0x57,%eax
  801137:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80113a:	eb 20                	jmp    80115c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	3c 40                	cmp    $0x40,%al
  801143:	7e 39                	jle    80117e <strtol+0x126>
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	3c 5a                	cmp    $0x5a,%al
  80114c:	7f 30                	jg     80117e <strtol+0x126>
			dig = *s - 'A' + 10;
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	8a 00                	mov    (%eax),%al
  801153:	0f be c0             	movsbl %al,%eax
  801156:	83 e8 37             	sub    $0x37,%eax
  801159:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80115c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80115f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801162:	7d 19                	jge    80117d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801164:	ff 45 08             	incl   0x8(%ebp)
  801167:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80116a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80116e:	89 c2                	mov    %eax,%edx
  801170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801173:	01 d0                	add    %edx,%eax
  801175:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801178:	e9 7b ff ff ff       	jmp    8010f8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80117d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80117e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801182:	74 08                	je     80118c <strtol+0x134>
		*endptr = (char *) s;
  801184:	8b 45 0c             	mov    0xc(%ebp),%eax
  801187:	8b 55 08             	mov    0x8(%ebp),%edx
  80118a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80118c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801190:	74 07                	je     801199 <strtol+0x141>
  801192:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801195:	f7 d8                	neg    %eax
  801197:	eb 03                	jmp    80119c <strtol+0x144>
  801199:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80119c:	c9                   	leave  
  80119d:	c3                   	ret    

0080119e <ltostr>:

void
ltostr(long value, char *str)
{
  80119e:	55                   	push   %ebp
  80119f:	89 e5                	mov    %esp,%ebp
  8011a1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011b6:	79 13                	jns    8011cb <ltostr+0x2d>
	{
		neg = 1;
  8011b8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011c5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011c8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011d3:	99                   	cltd   
  8011d4:	f7 f9                	idiv   %ecx
  8011d6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011dc:	8d 50 01             	lea    0x1(%eax),%edx
  8011df:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011e2:	89 c2                	mov    %eax,%edx
  8011e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e7:	01 d0                	add    %edx,%eax
  8011e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011ec:	83 c2 30             	add    $0x30,%edx
  8011ef:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011f4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011f9:	f7 e9                	imul   %ecx
  8011fb:	c1 fa 02             	sar    $0x2,%edx
  8011fe:	89 c8                	mov    %ecx,%eax
  801200:	c1 f8 1f             	sar    $0x1f,%eax
  801203:	29 c2                	sub    %eax,%edx
  801205:	89 d0                	mov    %edx,%eax
  801207:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80120a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80120e:	75 bb                	jne    8011cb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801210:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801217:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121a:	48                   	dec    %eax
  80121b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80121e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801222:	74 3d                	je     801261 <ltostr+0xc3>
		start = 1 ;
  801224:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80122b:	eb 34                	jmp    801261 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80122d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801230:	8b 45 0c             	mov    0xc(%ebp),%eax
  801233:	01 d0                	add    %edx,%eax
  801235:	8a 00                	mov    (%eax),%al
  801237:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80123a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80123d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801240:	01 c2                	add    %eax,%edx
  801242:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801245:	8b 45 0c             	mov    0xc(%ebp),%eax
  801248:	01 c8                	add    %ecx,%eax
  80124a:	8a 00                	mov    (%eax),%al
  80124c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80124e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801251:	8b 45 0c             	mov    0xc(%ebp),%eax
  801254:	01 c2                	add    %eax,%edx
  801256:	8a 45 eb             	mov    -0x15(%ebp),%al
  801259:	88 02                	mov    %al,(%edx)
		start++ ;
  80125b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80125e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801264:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801267:	7c c4                	jl     80122d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801269:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80126c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126f:	01 d0                	add    %edx,%eax
  801271:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801274:	90                   	nop
  801275:	c9                   	leave  
  801276:	c3                   	ret    

00801277 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
  80127a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80127d:	ff 75 08             	pushl  0x8(%ebp)
  801280:	e8 c4 f9 ff ff       	call   800c49 <strlen>
  801285:	83 c4 04             	add    $0x4,%esp
  801288:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80128b:	ff 75 0c             	pushl  0xc(%ebp)
  80128e:	e8 b6 f9 ff ff       	call   800c49 <strlen>
  801293:	83 c4 04             	add    $0x4,%esp
  801296:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801299:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012a7:	eb 17                	jmp    8012c0 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8012af:	01 c2                	add    %eax,%edx
  8012b1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	01 c8                	add    %ecx,%eax
  8012b9:	8a 00                	mov    (%eax),%al
  8012bb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012bd:	ff 45 fc             	incl   -0x4(%ebp)
  8012c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012c6:	7c e1                	jl     8012a9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012c8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012d6:	eb 1f                	jmp    8012f7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012db:	8d 50 01             	lea    0x1(%eax),%edx
  8012de:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012e1:	89 c2                	mov    %eax,%edx
  8012e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e6:	01 c2                	add    %eax,%edx
  8012e8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ee:	01 c8                	add    %ecx,%eax
  8012f0:	8a 00                	mov    (%eax),%al
  8012f2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012f4:	ff 45 f8             	incl   -0x8(%ebp)
  8012f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012fa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012fd:	7c d9                	jl     8012d8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801302:	8b 45 10             	mov    0x10(%ebp),%eax
  801305:	01 d0                	add    %edx,%eax
  801307:	c6 00 00             	movb   $0x0,(%eax)
}
  80130a:	90                   	nop
  80130b:	c9                   	leave  
  80130c:	c3                   	ret    

0080130d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801310:	8b 45 14             	mov    0x14(%ebp),%eax
  801313:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801319:	8b 45 14             	mov    0x14(%ebp),%eax
  80131c:	8b 00                	mov    (%eax),%eax
  80131e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801325:	8b 45 10             	mov    0x10(%ebp),%eax
  801328:	01 d0                	add    %edx,%eax
  80132a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801330:	eb 0c                	jmp    80133e <strsplit+0x31>
			*string++ = 0;
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	8d 50 01             	lea    0x1(%eax),%edx
  801338:	89 55 08             	mov    %edx,0x8(%ebp)
  80133b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80133e:	8b 45 08             	mov    0x8(%ebp),%eax
  801341:	8a 00                	mov    (%eax),%al
  801343:	84 c0                	test   %al,%al
  801345:	74 18                	je     80135f <strsplit+0x52>
  801347:	8b 45 08             	mov    0x8(%ebp),%eax
  80134a:	8a 00                	mov    (%eax),%al
  80134c:	0f be c0             	movsbl %al,%eax
  80134f:	50                   	push   %eax
  801350:	ff 75 0c             	pushl  0xc(%ebp)
  801353:	e8 83 fa ff ff       	call   800ddb <strchr>
  801358:	83 c4 08             	add    $0x8,%esp
  80135b:	85 c0                	test   %eax,%eax
  80135d:	75 d3                	jne    801332 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	8a 00                	mov    (%eax),%al
  801364:	84 c0                	test   %al,%al
  801366:	74 5a                	je     8013c2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801368:	8b 45 14             	mov    0x14(%ebp),%eax
  80136b:	8b 00                	mov    (%eax),%eax
  80136d:	83 f8 0f             	cmp    $0xf,%eax
  801370:	75 07                	jne    801379 <strsplit+0x6c>
		{
			return 0;
  801372:	b8 00 00 00 00       	mov    $0x0,%eax
  801377:	eb 66                	jmp    8013df <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801379:	8b 45 14             	mov    0x14(%ebp),%eax
  80137c:	8b 00                	mov    (%eax),%eax
  80137e:	8d 48 01             	lea    0x1(%eax),%ecx
  801381:	8b 55 14             	mov    0x14(%ebp),%edx
  801384:	89 0a                	mov    %ecx,(%edx)
  801386:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80138d:	8b 45 10             	mov    0x10(%ebp),%eax
  801390:	01 c2                	add    %eax,%edx
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801397:	eb 03                	jmp    80139c <strsplit+0x8f>
			string++;
  801399:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	8a 00                	mov    (%eax),%al
  8013a1:	84 c0                	test   %al,%al
  8013a3:	74 8b                	je     801330 <strsplit+0x23>
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	8a 00                	mov    (%eax),%al
  8013aa:	0f be c0             	movsbl %al,%eax
  8013ad:	50                   	push   %eax
  8013ae:	ff 75 0c             	pushl  0xc(%ebp)
  8013b1:	e8 25 fa ff ff       	call   800ddb <strchr>
  8013b6:	83 c4 08             	add    $0x8,%esp
  8013b9:	85 c0                	test   %eax,%eax
  8013bb:	74 dc                	je     801399 <strsplit+0x8c>
			string++;
	}
  8013bd:	e9 6e ff ff ff       	jmp    801330 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013c2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c6:	8b 00                	mov    (%eax),%eax
  8013c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d2:	01 d0                	add    %edx,%eax
  8013d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013da:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013df:	c9                   	leave  
  8013e0:	c3                   	ret    

008013e1 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
  8013e4:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8013e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f4:	eb 4a                	jmp    801440 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8013f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fc:	01 c2                	add    %eax,%edx
  8013fe:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801401:	8b 45 0c             	mov    0xc(%ebp),%eax
  801404:	01 c8                	add    %ecx,%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80140a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80140d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801410:	01 d0                	add    %edx,%eax
  801412:	8a 00                	mov    (%eax),%al
  801414:	3c 40                	cmp    $0x40,%al
  801416:	7e 25                	jle    80143d <str2lower+0x5c>
  801418:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80141b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141e:	01 d0                	add    %edx,%eax
  801420:	8a 00                	mov    (%eax),%al
  801422:	3c 5a                	cmp    $0x5a,%al
  801424:	7f 17                	jg     80143d <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801426:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	01 d0                	add    %edx,%eax
  80142e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801431:	8b 55 08             	mov    0x8(%ebp),%edx
  801434:	01 ca                	add    %ecx,%edx
  801436:	8a 12                	mov    (%edx),%dl
  801438:	83 c2 20             	add    $0x20,%edx
  80143b:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80143d:	ff 45 fc             	incl   -0x4(%ebp)
  801440:	ff 75 0c             	pushl  0xc(%ebp)
  801443:	e8 01 f8 ff ff       	call   800c49 <strlen>
  801448:	83 c4 04             	add    $0x4,%esp
  80144b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80144e:	7f a6                	jg     8013f6 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801450:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801453:	c9                   	leave  
  801454:	c3                   	ret    

00801455 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
  801458:	57                   	push   %edi
  801459:	56                   	push   %esi
  80145a:	53                   	push   %ebx
  80145b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80145e:	8b 45 08             	mov    0x8(%ebp),%eax
  801461:	8b 55 0c             	mov    0xc(%ebp),%edx
  801464:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801467:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80146a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80146d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801470:	cd 30                	int    $0x30
  801472:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801475:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801478:	83 c4 10             	add    $0x10,%esp
  80147b:	5b                   	pop    %ebx
  80147c:	5e                   	pop    %esi
  80147d:	5f                   	pop    %edi
  80147e:	5d                   	pop    %ebp
  80147f:	c3                   	ret    

00801480 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	83 ec 04             	sub    $0x4,%esp
  801486:	8b 45 10             	mov    0x10(%ebp),%eax
  801489:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80148c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80148f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801493:	8b 45 08             	mov    0x8(%ebp),%eax
  801496:	6a 00                	push   $0x0
  801498:	51                   	push   %ecx
  801499:	52                   	push   %edx
  80149a:	ff 75 0c             	pushl  0xc(%ebp)
  80149d:	50                   	push   %eax
  80149e:	6a 00                	push   $0x0
  8014a0:	e8 b0 ff ff ff       	call   801455 <syscall>
  8014a5:	83 c4 18             	add    $0x18,%esp
}
  8014a8:	90                   	nop
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    

008014ab <sys_cgetc>:

int
sys_cgetc(void)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014ae:	6a 00                	push   $0x0
  8014b0:	6a 00                	push   $0x0
  8014b2:	6a 00                	push   $0x0
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 02                	push   $0x2
  8014ba:	e8 96 ff ff ff       	call   801455 <syscall>
  8014bf:	83 c4 18             	add    $0x18,%esp
}
  8014c2:	c9                   	leave  
  8014c3:	c3                   	ret    

008014c4 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 00                	push   $0x0
  8014cd:	6a 00                	push   $0x0
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 03                	push   $0x3
  8014d3:	e8 7d ff ff ff       	call   801455 <syscall>
  8014d8:	83 c4 18             	add    $0x18,%esp
}
  8014db:	90                   	nop
  8014dc:	c9                   	leave  
  8014dd:	c3                   	ret    

008014de <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8014e1:	6a 00                	push   $0x0
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 04                	push   $0x4
  8014ed:	e8 63 ff ff ff       	call   801455 <syscall>
  8014f2:	83 c4 18             	add    $0x18,%esp
}
  8014f5:	90                   	nop
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    

008014f8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	52                   	push   %edx
  801508:	50                   	push   %eax
  801509:	6a 08                	push   $0x8
  80150b:	e8 45 ff ff ff       	call   801455 <syscall>
  801510:	83 c4 18             	add    $0x18,%esp
}
  801513:	c9                   	leave  
  801514:	c3                   	ret    

00801515 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801515:	55                   	push   %ebp
  801516:	89 e5                	mov    %esp,%ebp
  801518:	56                   	push   %esi
  801519:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80151a:	8b 75 18             	mov    0x18(%ebp),%esi
  80151d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801520:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801523:	8b 55 0c             	mov    0xc(%ebp),%edx
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	56                   	push   %esi
  80152a:	53                   	push   %ebx
  80152b:	51                   	push   %ecx
  80152c:	52                   	push   %edx
  80152d:	50                   	push   %eax
  80152e:	6a 09                	push   $0x9
  801530:	e8 20 ff ff ff       	call   801455 <syscall>
  801535:	83 c4 18             	add    $0x18,%esp
}
  801538:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80153b:	5b                   	pop    %ebx
  80153c:	5e                   	pop    %esi
  80153d:	5d                   	pop    %ebp
  80153e:	c3                   	ret    

0080153f <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	ff 75 08             	pushl  0x8(%ebp)
  80154d:	6a 0a                	push   $0xa
  80154f:	e8 01 ff ff ff       	call   801455 <syscall>
  801554:	83 c4 18             	add    $0x18,%esp
}
  801557:	c9                   	leave  
  801558:	c3                   	ret    

00801559 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	ff 75 0c             	pushl  0xc(%ebp)
  801565:	ff 75 08             	pushl  0x8(%ebp)
  801568:	6a 0b                	push   $0xb
  80156a:	e8 e6 fe ff ff       	call   801455 <syscall>
  80156f:	83 c4 18             	add    $0x18,%esp
}
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	6a 0c                	push   $0xc
  801583:	e8 cd fe ff ff       	call   801455 <syscall>
  801588:	83 c4 18             	add    $0x18,%esp
}
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 0d                	push   $0xd
  80159c:	e8 b4 fe ff ff       	call   801455 <syscall>
  8015a1:	83 c4 18             	add    $0x18,%esp
}
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 0e                	push   $0xe
  8015b5:	e8 9b fe ff ff       	call   801455 <syscall>
  8015ba:	83 c4 18             	add    $0x18,%esp
}
  8015bd:	c9                   	leave  
  8015be:	c3                   	ret    

008015bf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 0f                	push   $0xf
  8015ce:	e8 82 fe ff ff       	call   801455 <syscall>
  8015d3:	83 c4 18             	add    $0x18,%esp
}
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	ff 75 08             	pushl  0x8(%ebp)
  8015e6:	6a 10                	push   $0x10
  8015e8:	e8 68 fe ff ff       	call   801455 <syscall>
  8015ed:	83 c4 18             	add    $0x18,%esp
}
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 11                	push   $0x11
  801601:	e8 4f fe ff ff       	call   801455 <syscall>
  801606:	83 c4 18             	add    $0x18,%esp
}
  801609:	90                   	nop
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    

0080160c <sys_cputc>:

void
sys_cputc(const char c)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	83 ec 04             	sub    $0x4,%esp
  801612:	8b 45 08             	mov    0x8(%ebp),%eax
  801615:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801618:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	50                   	push   %eax
  801625:	6a 01                	push   $0x1
  801627:	e8 29 fe ff ff       	call   801455 <syscall>
  80162c:	83 c4 18             	add    $0x18,%esp
}
  80162f:	90                   	nop
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 14                	push   $0x14
  801641:	e8 0f fe ff ff       	call   801455 <syscall>
  801646:	83 c4 18             	add    $0x18,%esp
}
  801649:	90                   	nop
  80164a:	c9                   	leave  
  80164b:	c3                   	ret    

0080164c <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
  80164f:	83 ec 04             	sub    $0x4,%esp
  801652:	8b 45 10             	mov    0x10(%ebp),%eax
  801655:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801658:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80165b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80165f:	8b 45 08             	mov    0x8(%ebp),%eax
  801662:	6a 00                	push   $0x0
  801664:	51                   	push   %ecx
  801665:	52                   	push   %edx
  801666:	ff 75 0c             	pushl  0xc(%ebp)
  801669:	50                   	push   %eax
  80166a:	6a 15                	push   $0x15
  80166c:	e8 e4 fd ff ff       	call   801455 <syscall>
  801671:	83 c4 18             	add    $0x18,%esp
}
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801679:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	52                   	push   %edx
  801686:	50                   	push   %eax
  801687:	6a 16                	push   $0x16
  801689:	e8 c7 fd ff ff       	call   801455 <syscall>
  80168e:	83 c4 18             	add    $0x18,%esp
}
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801696:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801699:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169c:	8b 45 08             	mov    0x8(%ebp),%eax
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	51                   	push   %ecx
  8016a4:	52                   	push   %edx
  8016a5:	50                   	push   %eax
  8016a6:	6a 17                	push   $0x17
  8016a8:	e8 a8 fd ff ff       	call   801455 <syscall>
  8016ad:	83 c4 18             	add    $0x18,%esp
}
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    

008016b2 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	52                   	push   %edx
  8016c2:	50                   	push   %eax
  8016c3:	6a 18                	push   $0x18
  8016c5:	e8 8b fd ff ff       	call   801455 <syscall>
  8016ca:	83 c4 18             	add    $0x18,%esp
}
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	6a 00                	push   $0x0
  8016d7:	ff 75 14             	pushl  0x14(%ebp)
  8016da:	ff 75 10             	pushl  0x10(%ebp)
  8016dd:	ff 75 0c             	pushl  0xc(%ebp)
  8016e0:	50                   	push   %eax
  8016e1:	6a 19                	push   $0x19
  8016e3:	e8 6d fd ff ff       	call   801455 <syscall>
  8016e8:	83 c4 18             	add    $0x18,%esp
}
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <sys_run_env>:

void sys_run_env(int32 envId)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	50                   	push   %eax
  8016fc:	6a 1a                	push   $0x1a
  8016fe:	e8 52 fd ff ff       	call   801455 <syscall>
  801703:	83 c4 18             	add    $0x18,%esp
}
  801706:	90                   	nop
  801707:	c9                   	leave  
  801708:	c3                   	ret    

00801709 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80170c:	8b 45 08             	mov    0x8(%ebp),%eax
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	50                   	push   %eax
  801718:	6a 1b                	push   $0x1b
  80171a:	e8 36 fd ff ff       	call   801455 <syscall>
  80171f:	83 c4 18             	add    $0x18,%esp
}
  801722:	c9                   	leave  
  801723:	c3                   	ret    

00801724 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 05                	push   $0x5
  801733:	e8 1d fd ff ff       	call   801455 <syscall>
  801738:	83 c4 18             	add    $0x18,%esp
}
  80173b:	c9                   	leave  
  80173c:	c3                   	ret    

0080173d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 06                	push   $0x6
  80174c:	e8 04 fd ff ff       	call   801455 <syscall>
  801751:	83 c4 18             	add    $0x18,%esp
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 07                	push   $0x7
  801765:	e8 eb fc ff ff       	call   801455 <syscall>
  80176a:	83 c4 18             	add    $0x18,%esp
}
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    

0080176f <sys_exit_env>:


void sys_exit_env(void)
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 1c                	push   $0x1c
  80177e:	e8 d2 fc ff ff       	call   801455 <syscall>
  801783:	83 c4 18             	add    $0x18,%esp
}
  801786:	90                   	nop
  801787:	c9                   	leave  
  801788:	c3                   	ret    

00801789 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
  80178c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80178f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801792:	8d 50 04             	lea    0x4(%eax),%edx
  801795:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	52                   	push   %edx
  80179f:	50                   	push   %eax
  8017a0:	6a 1d                	push   $0x1d
  8017a2:	e8 ae fc ff ff       	call   801455 <syscall>
  8017a7:	83 c4 18             	add    $0x18,%esp
	return result;
  8017aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b3:	89 01                	mov    %eax,(%ecx)
  8017b5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bb:	c9                   	leave  
  8017bc:	c2 04 00             	ret    $0x4

008017bf <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	ff 75 10             	pushl  0x10(%ebp)
  8017c9:	ff 75 0c             	pushl  0xc(%ebp)
  8017cc:	ff 75 08             	pushl  0x8(%ebp)
  8017cf:	6a 13                	push   $0x13
  8017d1:	e8 7f fc ff ff       	call   801455 <syscall>
  8017d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d9:	90                   	nop
}
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <sys_rcr2>:
uint32 sys_rcr2()
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 1e                	push   $0x1e
  8017eb:	e8 65 fc ff ff       	call   801455 <syscall>
  8017f0:	83 c4 18             	add    $0x18,%esp
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	83 ec 04             	sub    $0x4,%esp
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801801:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	50                   	push   %eax
  80180e:	6a 1f                	push   $0x1f
  801810:	e8 40 fc ff ff       	call   801455 <syscall>
  801815:	83 c4 18             	add    $0x18,%esp
	return ;
  801818:	90                   	nop
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <rsttst>:
void rsttst()
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 21                	push   $0x21
  80182a:	e8 26 fc ff ff       	call   801455 <syscall>
  80182f:	83 c4 18             	add    $0x18,%esp
	return ;
  801832:	90                   	nop
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
  801838:	83 ec 04             	sub    $0x4,%esp
  80183b:	8b 45 14             	mov    0x14(%ebp),%eax
  80183e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801841:	8b 55 18             	mov    0x18(%ebp),%edx
  801844:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801848:	52                   	push   %edx
  801849:	50                   	push   %eax
  80184a:	ff 75 10             	pushl  0x10(%ebp)
  80184d:	ff 75 0c             	pushl  0xc(%ebp)
  801850:	ff 75 08             	pushl  0x8(%ebp)
  801853:	6a 20                	push   $0x20
  801855:	e8 fb fb ff ff       	call   801455 <syscall>
  80185a:	83 c4 18             	add    $0x18,%esp
	return ;
  80185d:	90                   	nop
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <chktst>:
void chktst(uint32 n)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	ff 75 08             	pushl  0x8(%ebp)
  80186e:	6a 22                	push   $0x22
  801870:	e8 e0 fb ff ff       	call   801455 <syscall>
  801875:	83 c4 18             	add    $0x18,%esp
	return ;
  801878:	90                   	nop
}
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <inctst>:

void inctst()
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 23                	push   $0x23
  80188a:	e8 c6 fb ff ff       	call   801455 <syscall>
  80188f:	83 c4 18             	add    $0x18,%esp
	return ;
  801892:	90                   	nop
}
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <gettst>:
uint32 gettst()
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 24                	push   $0x24
  8018a4:	e8 ac fb ff ff       	call   801455 <syscall>
  8018a9:	83 c4 18             	add    $0x18,%esp
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 25                	push   $0x25
  8018bd:	e8 93 fb ff ff       	call   801455 <syscall>
  8018c2:	83 c4 18             	add    $0x18,%esp
  8018c5:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8018ca:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	ff 75 08             	pushl  0x8(%ebp)
  8018e7:	6a 26                	push   $0x26
  8018e9:	e8 67 fb ff ff       	call   801455 <syscall>
  8018ee:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f1:	90                   	nop
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018f8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801901:	8b 45 08             	mov    0x8(%ebp),%eax
  801904:	6a 00                	push   $0x0
  801906:	53                   	push   %ebx
  801907:	51                   	push   %ecx
  801908:	52                   	push   %edx
  801909:	50                   	push   %eax
  80190a:	6a 27                	push   $0x27
  80190c:	e8 44 fb ff ff       	call   801455 <syscall>
  801911:	83 c4 18             	add    $0x18,%esp
}
  801914:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80191c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191f:	8b 45 08             	mov    0x8(%ebp),%eax
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	52                   	push   %edx
  801929:	50                   	push   %eax
  80192a:	6a 28                	push   $0x28
  80192c:	e8 24 fb ff ff       	call   801455 <syscall>
  801931:	83 c4 18             	add    $0x18,%esp
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801939:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80193c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	6a 00                	push   $0x0
  801944:	51                   	push   %ecx
  801945:	ff 75 10             	pushl  0x10(%ebp)
  801948:	52                   	push   %edx
  801949:	50                   	push   %eax
  80194a:	6a 29                	push   $0x29
  80194c:	e8 04 fb ff ff       	call   801455 <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	ff 75 10             	pushl  0x10(%ebp)
  801960:	ff 75 0c             	pushl  0xc(%ebp)
  801963:	ff 75 08             	pushl  0x8(%ebp)
  801966:	6a 12                	push   $0x12
  801968:	e8 e8 fa ff ff       	call   801455 <syscall>
  80196d:	83 c4 18             	add    $0x18,%esp
	return ;
  801970:	90                   	nop
}
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801976:	8b 55 0c             	mov    0xc(%ebp),%edx
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	52                   	push   %edx
  801983:	50                   	push   %eax
  801984:	6a 2a                	push   $0x2a
  801986:	e8 ca fa ff ff       	call   801455 <syscall>
  80198b:	83 c4 18             	add    $0x18,%esp
	return;
  80198e:	90                   	nop
}
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 2b                	push   $0x2b
  8019a0:	e8 b0 fa ff ff       	call   801455 <syscall>
  8019a5:	83 c4 18             	add    $0x18,%esp
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	ff 75 0c             	pushl  0xc(%ebp)
  8019b6:	ff 75 08             	pushl  0x8(%ebp)
  8019b9:	6a 2d                	push   $0x2d
  8019bb:	e8 95 fa ff ff       	call   801455 <syscall>
  8019c0:	83 c4 18             	add    $0x18,%esp
	return;
  8019c3:	90                   	nop
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	ff 75 0c             	pushl  0xc(%ebp)
  8019d2:	ff 75 08             	pushl  0x8(%ebp)
  8019d5:	6a 2c                	push   $0x2c
  8019d7:	e8 79 fa ff ff       	call   801455 <syscall>
  8019dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8019df:	90                   	nop
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8019e8:	83 ec 04             	sub    $0x4,%esp
  8019eb:	68 48 23 80 00       	push   $0x802348
  8019f0:	68 25 01 00 00       	push   $0x125
  8019f5:	68 7b 23 80 00       	push   $0x80237b
  8019fa:	e8 a3 e8 ff ff       	call   8002a2 <_panic>
  8019ff:	90                   	nop

00801a00 <__udivdi3>:
  801a00:	55                   	push   %ebp
  801a01:	57                   	push   %edi
  801a02:	56                   	push   %esi
  801a03:	53                   	push   %ebx
  801a04:	83 ec 1c             	sub    $0x1c,%esp
  801a07:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a0b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a13:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a17:	89 ca                	mov    %ecx,%edx
  801a19:	89 f8                	mov    %edi,%eax
  801a1b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a1f:	85 f6                	test   %esi,%esi
  801a21:	75 2d                	jne    801a50 <__udivdi3+0x50>
  801a23:	39 cf                	cmp    %ecx,%edi
  801a25:	77 65                	ja     801a8c <__udivdi3+0x8c>
  801a27:	89 fd                	mov    %edi,%ebp
  801a29:	85 ff                	test   %edi,%edi
  801a2b:	75 0b                	jne    801a38 <__udivdi3+0x38>
  801a2d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a32:	31 d2                	xor    %edx,%edx
  801a34:	f7 f7                	div    %edi
  801a36:	89 c5                	mov    %eax,%ebp
  801a38:	31 d2                	xor    %edx,%edx
  801a3a:	89 c8                	mov    %ecx,%eax
  801a3c:	f7 f5                	div    %ebp
  801a3e:	89 c1                	mov    %eax,%ecx
  801a40:	89 d8                	mov    %ebx,%eax
  801a42:	f7 f5                	div    %ebp
  801a44:	89 cf                	mov    %ecx,%edi
  801a46:	89 fa                	mov    %edi,%edx
  801a48:	83 c4 1c             	add    $0x1c,%esp
  801a4b:	5b                   	pop    %ebx
  801a4c:	5e                   	pop    %esi
  801a4d:	5f                   	pop    %edi
  801a4e:	5d                   	pop    %ebp
  801a4f:	c3                   	ret    
  801a50:	39 ce                	cmp    %ecx,%esi
  801a52:	77 28                	ja     801a7c <__udivdi3+0x7c>
  801a54:	0f bd fe             	bsr    %esi,%edi
  801a57:	83 f7 1f             	xor    $0x1f,%edi
  801a5a:	75 40                	jne    801a9c <__udivdi3+0x9c>
  801a5c:	39 ce                	cmp    %ecx,%esi
  801a5e:	72 0a                	jb     801a6a <__udivdi3+0x6a>
  801a60:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a64:	0f 87 9e 00 00 00    	ja     801b08 <__udivdi3+0x108>
  801a6a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a6f:	89 fa                	mov    %edi,%edx
  801a71:	83 c4 1c             	add    $0x1c,%esp
  801a74:	5b                   	pop    %ebx
  801a75:	5e                   	pop    %esi
  801a76:	5f                   	pop    %edi
  801a77:	5d                   	pop    %ebp
  801a78:	c3                   	ret    
  801a79:	8d 76 00             	lea    0x0(%esi),%esi
  801a7c:	31 ff                	xor    %edi,%edi
  801a7e:	31 c0                	xor    %eax,%eax
  801a80:	89 fa                	mov    %edi,%edx
  801a82:	83 c4 1c             	add    $0x1c,%esp
  801a85:	5b                   	pop    %ebx
  801a86:	5e                   	pop    %esi
  801a87:	5f                   	pop    %edi
  801a88:	5d                   	pop    %ebp
  801a89:	c3                   	ret    
  801a8a:	66 90                	xchg   %ax,%ax
  801a8c:	89 d8                	mov    %ebx,%eax
  801a8e:	f7 f7                	div    %edi
  801a90:	31 ff                	xor    %edi,%edi
  801a92:	89 fa                	mov    %edi,%edx
  801a94:	83 c4 1c             	add    $0x1c,%esp
  801a97:	5b                   	pop    %ebx
  801a98:	5e                   	pop    %esi
  801a99:	5f                   	pop    %edi
  801a9a:	5d                   	pop    %ebp
  801a9b:	c3                   	ret    
  801a9c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801aa1:	89 eb                	mov    %ebp,%ebx
  801aa3:	29 fb                	sub    %edi,%ebx
  801aa5:	89 f9                	mov    %edi,%ecx
  801aa7:	d3 e6                	shl    %cl,%esi
  801aa9:	89 c5                	mov    %eax,%ebp
  801aab:	88 d9                	mov    %bl,%cl
  801aad:	d3 ed                	shr    %cl,%ebp
  801aaf:	89 e9                	mov    %ebp,%ecx
  801ab1:	09 f1                	or     %esi,%ecx
  801ab3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ab7:	89 f9                	mov    %edi,%ecx
  801ab9:	d3 e0                	shl    %cl,%eax
  801abb:	89 c5                	mov    %eax,%ebp
  801abd:	89 d6                	mov    %edx,%esi
  801abf:	88 d9                	mov    %bl,%cl
  801ac1:	d3 ee                	shr    %cl,%esi
  801ac3:	89 f9                	mov    %edi,%ecx
  801ac5:	d3 e2                	shl    %cl,%edx
  801ac7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801acb:	88 d9                	mov    %bl,%cl
  801acd:	d3 e8                	shr    %cl,%eax
  801acf:	09 c2                	or     %eax,%edx
  801ad1:	89 d0                	mov    %edx,%eax
  801ad3:	89 f2                	mov    %esi,%edx
  801ad5:	f7 74 24 0c          	divl   0xc(%esp)
  801ad9:	89 d6                	mov    %edx,%esi
  801adb:	89 c3                	mov    %eax,%ebx
  801add:	f7 e5                	mul    %ebp
  801adf:	39 d6                	cmp    %edx,%esi
  801ae1:	72 19                	jb     801afc <__udivdi3+0xfc>
  801ae3:	74 0b                	je     801af0 <__udivdi3+0xf0>
  801ae5:	89 d8                	mov    %ebx,%eax
  801ae7:	31 ff                	xor    %edi,%edi
  801ae9:	e9 58 ff ff ff       	jmp    801a46 <__udivdi3+0x46>
  801aee:	66 90                	xchg   %ax,%ax
  801af0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801af4:	89 f9                	mov    %edi,%ecx
  801af6:	d3 e2                	shl    %cl,%edx
  801af8:	39 c2                	cmp    %eax,%edx
  801afa:	73 e9                	jae    801ae5 <__udivdi3+0xe5>
  801afc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801aff:	31 ff                	xor    %edi,%edi
  801b01:	e9 40 ff ff ff       	jmp    801a46 <__udivdi3+0x46>
  801b06:	66 90                	xchg   %ax,%ax
  801b08:	31 c0                	xor    %eax,%eax
  801b0a:	e9 37 ff ff ff       	jmp    801a46 <__udivdi3+0x46>
  801b0f:	90                   	nop

00801b10 <__umoddi3>:
  801b10:	55                   	push   %ebp
  801b11:	57                   	push   %edi
  801b12:	56                   	push   %esi
  801b13:	53                   	push   %ebx
  801b14:	83 ec 1c             	sub    $0x1c,%esp
  801b17:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b1b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b23:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b27:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b2b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b2f:	89 f3                	mov    %esi,%ebx
  801b31:	89 fa                	mov    %edi,%edx
  801b33:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b37:	89 34 24             	mov    %esi,(%esp)
  801b3a:	85 c0                	test   %eax,%eax
  801b3c:	75 1a                	jne    801b58 <__umoddi3+0x48>
  801b3e:	39 f7                	cmp    %esi,%edi
  801b40:	0f 86 a2 00 00 00    	jbe    801be8 <__umoddi3+0xd8>
  801b46:	89 c8                	mov    %ecx,%eax
  801b48:	89 f2                	mov    %esi,%edx
  801b4a:	f7 f7                	div    %edi
  801b4c:	89 d0                	mov    %edx,%eax
  801b4e:	31 d2                	xor    %edx,%edx
  801b50:	83 c4 1c             	add    $0x1c,%esp
  801b53:	5b                   	pop    %ebx
  801b54:	5e                   	pop    %esi
  801b55:	5f                   	pop    %edi
  801b56:	5d                   	pop    %ebp
  801b57:	c3                   	ret    
  801b58:	39 f0                	cmp    %esi,%eax
  801b5a:	0f 87 ac 00 00 00    	ja     801c0c <__umoddi3+0xfc>
  801b60:	0f bd e8             	bsr    %eax,%ebp
  801b63:	83 f5 1f             	xor    $0x1f,%ebp
  801b66:	0f 84 ac 00 00 00    	je     801c18 <__umoddi3+0x108>
  801b6c:	bf 20 00 00 00       	mov    $0x20,%edi
  801b71:	29 ef                	sub    %ebp,%edi
  801b73:	89 fe                	mov    %edi,%esi
  801b75:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b79:	89 e9                	mov    %ebp,%ecx
  801b7b:	d3 e0                	shl    %cl,%eax
  801b7d:	89 d7                	mov    %edx,%edi
  801b7f:	89 f1                	mov    %esi,%ecx
  801b81:	d3 ef                	shr    %cl,%edi
  801b83:	09 c7                	or     %eax,%edi
  801b85:	89 e9                	mov    %ebp,%ecx
  801b87:	d3 e2                	shl    %cl,%edx
  801b89:	89 14 24             	mov    %edx,(%esp)
  801b8c:	89 d8                	mov    %ebx,%eax
  801b8e:	d3 e0                	shl    %cl,%eax
  801b90:	89 c2                	mov    %eax,%edx
  801b92:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b96:	d3 e0                	shl    %cl,%eax
  801b98:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b9c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ba0:	89 f1                	mov    %esi,%ecx
  801ba2:	d3 e8                	shr    %cl,%eax
  801ba4:	09 d0                	or     %edx,%eax
  801ba6:	d3 eb                	shr    %cl,%ebx
  801ba8:	89 da                	mov    %ebx,%edx
  801baa:	f7 f7                	div    %edi
  801bac:	89 d3                	mov    %edx,%ebx
  801bae:	f7 24 24             	mull   (%esp)
  801bb1:	89 c6                	mov    %eax,%esi
  801bb3:	89 d1                	mov    %edx,%ecx
  801bb5:	39 d3                	cmp    %edx,%ebx
  801bb7:	0f 82 87 00 00 00    	jb     801c44 <__umoddi3+0x134>
  801bbd:	0f 84 91 00 00 00    	je     801c54 <__umoddi3+0x144>
  801bc3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bc7:	29 f2                	sub    %esi,%edx
  801bc9:	19 cb                	sbb    %ecx,%ebx
  801bcb:	89 d8                	mov    %ebx,%eax
  801bcd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bd1:	d3 e0                	shl    %cl,%eax
  801bd3:	89 e9                	mov    %ebp,%ecx
  801bd5:	d3 ea                	shr    %cl,%edx
  801bd7:	09 d0                	or     %edx,%eax
  801bd9:	89 e9                	mov    %ebp,%ecx
  801bdb:	d3 eb                	shr    %cl,%ebx
  801bdd:	89 da                	mov    %ebx,%edx
  801bdf:	83 c4 1c             	add    $0x1c,%esp
  801be2:	5b                   	pop    %ebx
  801be3:	5e                   	pop    %esi
  801be4:	5f                   	pop    %edi
  801be5:	5d                   	pop    %ebp
  801be6:	c3                   	ret    
  801be7:	90                   	nop
  801be8:	89 fd                	mov    %edi,%ebp
  801bea:	85 ff                	test   %edi,%edi
  801bec:	75 0b                	jne    801bf9 <__umoddi3+0xe9>
  801bee:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf3:	31 d2                	xor    %edx,%edx
  801bf5:	f7 f7                	div    %edi
  801bf7:	89 c5                	mov    %eax,%ebp
  801bf9:	89 f0                	mov    %esi,%eax
  801bfb:	31 d2                	xor    %edx,%edx
  801bfd:	f7 f5                	div    %ebp
  801bff:	89 c8                	mov    %ecx,%eax
  801c01:	f7 f5                	div    %ebp
  801c03:	89 d0                	mov    %edx,%eax
  801c05:	e9 44 ff ff ff       	jmp    801b4e <__umoddi3+0x3e>
  801c0a:	66 90                	xchg   %ax,%ax
  801c0c:	89 c8                	mov    %ecx,%eax
  801c0e:	89 f2                	mov    %esi,%edx
  801c10:	83 c4 1c             	add    $0x1c,%esp
  801c13:	5b                   	pop    %ebx
  801c14:	5e                   	pop    %esi
  801c15:	5f                   	pop    %edi
  801c16:	5d                   	pop    %ebp
  801c17:	c3                   	ret    
  801c18:	3b 04 24             	cmp    (%esp),%eax
  801c1b:	72 06                	jb     801c23 <__umoddi3+0x113>
  801c1d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c21:	77 0f                	ja     801c32 <__umoddi3+0x122>
  801c23:	89 f2                	mov    %esi,%edx
  801c25:	29 f9                	sub    %edi,%ecx
  801c27:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c2b:	89 14 24             	mov    %edx,(%esp)
  801c2e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c32:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c36:	8b 14 24             	mov    (%esp),%edx
  801c39:	83 c4 1c             	add    $0x1c,%esp
  801c3c:	5b                   	pop    %ebx
  801c3d:	5e                   	pop    %esi
  801c3e:	5f                   	pop    %edi
  801c3f:	5d                   	pop    %ebp
  801c40:	c3                   	ret    
  801c41:	8d 76 00             	lea    0x0(%esi),%esi
  801c44:	2b 04 24             	sub    (%esp),%eax
  801c47:	19 fa                	sbb    %edi,%edx
  801c49:	89 d1                	mov    %edx,%ecx
  801c4b:	89 c6                	mov    %eax,%esi
  801c4d:	e9 71 ff ff ff       	jmp    801bc3 <__umoddi3+0xb3>
  801c52:	66 90                	xchg   %ax,%ax
  801c54:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c58:	72 ea                	jb     801c44 <__umoddi3+0x134>
  801c5a:	89 d9                	mov    %ebx,%ecx
  801c5c:	e9 62 ff ff ff       	jmp    801bc3 <__umoddi3+0xb3>

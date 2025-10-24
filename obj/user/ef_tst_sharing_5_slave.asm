
obj/user/ef_tst_sharing_5_slave:     file format elf32-i386


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
  800031:	e8 dc 00 00 00       	call   800112 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

extern volatile bool printStats;
void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	printStats = 0;
  80003e:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  800045:	00 00 00 
	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800048:	a1 20 30 80 00       	mov    0x803020,%eax
  80004d:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  800053:	a1 20 30 80 00       	mov    0x803020,%eax
  800058:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80005e:	39 c2                	cmp    %eax,%edx
  800060:	72 14                	jb     800076 <_main+0x3e>
			panic("Please increase the WS size");
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	68 a0 1f 80 00       	push   $0x801fa0
  80006a:	6a 0e                	push   $0xe
  80006c:	68 bc 1f 80 00       	push   $0x801fbc
  800071:	e8 4c 02 00 00       	call   8002c2 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800076:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;
sys_lock_cons();
  80007d:	e8 19 16 00 00       	call   80169b <sys_lock_cons>
	x = sget(sys_getparentenvid(),"x");
  800082:	e8 a6 18 00 00       	call   80192d <sys_getparentenvid>
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	68 da 1f 80 00       	push   $0x801fda
  80008f:	50                   	push   %eax
  800090:	e8 39 15 00 00       	call   8015ce <sget>
  800095:	83 c4 10             	add    $0x10,%esp
  800098:	89 45 f0             	mov    %eax,-0x10(%ebp)

	freeFrames = sys_calculate_free_frames() ;
  80009b:	e8 ab 16 00 00       	call   80174b <sys_calculate_free_frames>
  8000a0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	68 dc 1f 80 00       	push   $0x801fdc
  8000ab:	e8 e0 04 00 00       	call   800590 <cprintf>
  8000b0:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b9:	e8 51 15 00 00       	call   80160f <sfree>
  8000be:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000c1:	83 ec 0c             	sub    $0xc,%esp
  8000c4:	68 00 20 80 00       	push   $0x802000
  8000c9:	e8 c2 04 00 00       	call   800590 <cprintf>
  8000ce:	83 c4 10             	add    $0x10,%esp

	diff = (sys_calculate_free_frames() - freeFrames);
  8000d1:	e8 75 16 00 00       	call   80174b <sys_calculate_free_frames>
  8000d6:	89 c2                	mov    %eax,%edx
  8000d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000db:	29 c2                	sub    %eax,%edx
  8000dd:	89 d0                	mov    %edx,%eax
  8000df:	89 45 e8             	mov    %eax,-0x18(%ebp)
sys_unlock_cons();
  8000e2:	e8 ce 15 00 00       	call   8016b5 <sys_unlock_cons>
	expected = 1;
  8000e7:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	if (diff != expected) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  8000ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000f4:	74 14                	je     80010a <_main+0xd2>
  8000f6:	83 ec 04             	sub    $0x4,%esp
  8000f9:	68 18 20 80 00       	push   $0x802018
  8000fe:	6a 25                	push   $0x25
  800100:	68 bc 1f 80 00       	push   $0x801fbc
  800105:	e8 b8 01 00 00       	call   8002c2 <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  80010a:	e8 43 19 00 00       	call   801a52 <inctst>

	return;
  80010f:	90                   	nop
}
  800110:	c9                   	leave  
  800111:	c3                   	ret    

00800112 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800112:	55                   	push   %ebp
  800113:	89 e5                	mov    %esp,%ebp
  800115:	57                   	push   %edi
  800116:	56                   	push   %esi
  800117:	53                   	push   %ebx
  800118:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80011b:	e8 f4 17 00 00       	call   801914 <sys_getenvindex>
  800120:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800123:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800126:	89 d0                	mov    %edx,%eax
  800128:	c1 e0 02             	shl    $0x2,%eax
  80012b:	01 d0                	add    %edx,%eax
  80012d:	c1 e0 03             	shl    $0x3,%eax
  800130:	01 d0                	add    %edx,%eax
  800132:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800139:	01 d0                	add    %edx,%eax
  80013b:	c1 e0 02             	shl    $0x2,%eax
  80013e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800143:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800148:	a1 20 30 80 00       	mov    0x803020,%eax
  80014d:	8a 40 20             	mov    0x20(%eax),%al
  800150:	84 c0                	test   %al,%al
  800152:	74 0d                	je     800161 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800154:	a1 20 30 80 00       	mov    0x803020,%eax
  800159:	83 c0 20             	add    $0x20,%eax
  80015c:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800161:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800165:	7e 0a                	jle    800171 <libmain+0x5f>
		binaryname = argv[0];
  800167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80016a:	8b 00                	mov    (%eax),%eax
  80016c:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800171:	83 ec 08             	sub    $0x8,%esp
  800174:	ff 75 0c             	pushl  0xc(%ebp)
  800177:	ff 75 08             	pushl  0x8(%ebp)
  80017a:	e8 b9 fe ff ff       	call   800038 <_main>
  80017f:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800182:	a1 00 30 80 00       	mov    0x803000,%eax
  800187:	85 c0                	test   %eax,%eax
  800189:	0f 84 01 01 00 00    	je     800290 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80018f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800195:	bb 9c 21 80 00       	mov    $0x80219c,%ebx
  80019a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80019f:	89 c7                	mov    %eax,%edi
  8001a1:	89 de                	mov    %ebx,%esi
  8001a3:	89 d1                	mov    %edx,%ecx
  8001a5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001a7:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001aa:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001af:	b0 00                	mov    $0x0,%al
  8001b1:	89 d7                	mov    %edx,%edi
  8001b3:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001b5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001bc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001bf:	83 ec 08             	sub    $0x8,%esp
  8001c2:	50                   	push   %eax
  8001c3:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001c9:	50                   	push   %eax
  8001ca:	e8 7b 19 00 00       	call   801b4a <sys_utilities>
  8001cf:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001d2:	e8 c4 14 00 00       	call   80169b <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	68 bc 20 80 00       	push   $0x8020bc
  8001df:	e8 ac 03 00 00       	call   800590 <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ea:	85 c0                	test   %eax,%eax
  8001ec:	74 18                	je     800206 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001ee:	e8 75 19 00 00       	call   801b68 <sys_get_optimal_num_faults>
  8001f3:	83 ec 08             	sub    $0x8,%esp
  8001f6:	50                   	push   %eax
  8001f7:	68 e4 20 80 00       	push   $0x8020e4
  8001fc:	e8 8f 03 00 00       	call   800590 <cprintf>
  800201:	83 c4 10             	add    $0x10,%esp
  800204:	eb 59                	jmp    80025f <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800206:	a1 20 30 80 00       	mov    0x803020,%eax
  80020b:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800211:	a1 20 30 80 00       	mov    0x803020,%eax
  800216:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	52                   	push   %edx
  800220:	50                   	push   %eax
  800221:	68 08 21 80 00       	push   $0x802108
  800226:	e8 65 03 00 00       	call   800590 <cprintf>
  80022b:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80022e:	a1 20 30 80 00       	mov    0x803020,%eax
  800233:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800239:	a1 20 30 80 00       	mov    0x803020,%eax
  80023e:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800244:	a1 20 30 80 00       	mov    0x803020,%eax
  800249:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80024f:	51                   	push   %ecx
  800250:	52                   	push   %edx
  800251:	50                   	push   %eax
  800252:	68 30 21 80 00       	push   $0x802130
  800257:	e8 34 03 00 00       	call   800590 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80025f:	a1 20 30 80 00       	mov    0x803020,%eax
  800264:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	50                   	push   %eax
  80026e:	68 88 21 80 00       	push   $0x802188
  800273:	e8 18 03 00 00       	call   800590 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	68 bc 20 80 00       	push   $0x8020bc
  800283:	e8 08 03 00 00       	call   800590 <cprintf>
  800288:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80028b:	e8 25 14 00 00       	call   8016b5 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800290:	e8 1f 00 00 00       	call   8002b4 <exit>
}
  800295:	90                   	nop
  800296:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800299:	5b                   	pop    %ebx
  80029a:	5e                   	pop    %esi
  80029b:	5f                   	pop    %edi
  80029c:	5d                   	pop    %ebp
  80029d:	c3                   	ret    

0080029e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80029e:	55                   	push   %ebp
  80029f:	89 e5                	mov    %esp,%ebp
  8002a1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	6a 00                	push   $0x0
  8002a9:	e8 32 16 00 00       	call   8018e0 <sys_destroy_env>
  8002ae:	83 c4 10             	add    $0x10,%esp
}
  8002b1:	90                   	nop
  8002b2:	c9                   	leave  
  8002b3:	c3                   	ret    

008002b4 <exit>:

void
exit(void)
{
  8002b4:	55                   	push   %ebp
  8002b5:	89 e5                	mov    %esp,%ebp
  8002b7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002ba:	e8 87 16 00 00       	call   801946 <sys_exit_env>
}
  8002bf:	90                   	nop
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002c8:	8d 45 10             	lea    0x10(%ebp),%eax
  8002cb:	83 c0 04             	add    $0x4,%eax
  8002ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002d1:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002d6:	85 c0                	test   %eax,%eax
  8002d8:	74 16                	je     8002f0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002da:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002df:	83 ec 08             	sub    $0x8,%esp
  8002e2:	50                   	push   %eax
  8002e3:	68 00 22 80 00       	push   $0x802200
  8002e8:	e8 a3 02 00 00       	call   800590 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8002f0:	a1 04 30 80 00       	mov    0x803004,%eax
  8002f5:	83 ec 0c             	sub    $0xc,%esp
  8002f8:	ff 75 0c             	pushl  0xc(%ebp)
  8002fb:	ff 75 08             	pushl  0x8(%ebp)
  8002fe:	50                   	push   %eax
  8002ff:	68 08 22 80 00       	push   $0x802208
  800304:	6a 74                	push   $0x74
  800306:	e8 b2 02 00 00       	call   8005bd <cprintf_colored>
  80030b:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80030e:	8b 45 10             	mov    0x10(%ebp),%eax
  800311:	83 ec 08             	sub    $0x8,%esp
  800314:	ff 75 f4             	pushl  -0xc(%ebp)
  800317:	50                   	push   %eax
  800318:	e8 04 02 00 00       	call   800521 <vcprintf>
  80031d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800320:	83 ec 08             	sub    $0x8,%esp
  800323:	6a 00                	push   $0x0
  800325:	68 30 22 80 00       	push   $0x802230
  80032a:	e8 f2 01 00 00       	call   800521 <vcprintf>
  80032f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800332:	e8 7d ff ff ff       	call   8002b4 <exit>

	// should not return here
	while (1) ;
  800337:	eb fe                	jmp    800337 <_panic+0x75>

00800339 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800339:	55                   	push   %ebp
  80033a:	89 e5                	mov    %esp,%ebp
  80033c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80033f:	a1 20 30 80 00       	mov    0x803020,%eax
  800344:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80034a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034d:	39 c2                	cmp    %eax,%edx
  80034f:	74 14                	je     800365 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800351:	83 ec 04             	sub    $0x4,%esp
  800354:	68 34 22 80 00       	push   $0x802234
  800359:	6a 26                	push   $0x26
  80035b:	68 80 22 80 00       	push   $0x802280
  800360:	e8 5d ff ff ff       	call   8002c2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800365:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80036c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800373:	e9 c5 00 00 00       	jmp    80043d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800378:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80037b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800382:	8b 45 08             	mov    0x8(%ebp),%eax
  800385:	01 d0                	add    %edx,%eax
  800387:	8b 00                	mov    (%eax),%eax
  800389:	85 c0                	test   %eax,%eax
  80038b:	75 08                	jne    800395 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80038d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800390:	e9 a5 00 00 00       	jmp    80043a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800395:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80039c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003a3:	eb 69                	jmp    80040e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003a5:	a1 20 30 80 00       	mov    0x803020,%eax
  8003aa:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003b3:	89 d0                	mov    %edx,%eax
  8003b5:	01 c0                	add    %eax,%eax
  8003b7:	01 d0                	add    %edx,%eax
  8003b9:	c1 e0 03             	shl    $0x3,%eax
  8003bc:	01 c8                	add    %ecx,%eax
  8003be:	8a 40 04             	mov    0x4(%eax),%al
  8003c1:	84 c0                	test   %al,%al
  8003c3:	75 46                	jne    80040b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003c5:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ca:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d3:	89 d0                	mov    %edx,%eax
  8003d5:	01 c0                	add    %eax,%eax
  8003d7:	01 d0                	add    %edx,%eax
  8003d9:	c1 e0 03             	shl    $0x3,%eax
  8003dc:	01 c8                	add    %ecx,%eax
  8003de:	8b 00                	mov    (%eax),%eax
  8003e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003eb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fa:	01 c8                	add    %ecx,%eax
  8003fc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003fe:	39 c2                	cmp    %eax,%edx
  800400:	75 09                	jne    80040b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800402:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800409:	eb 15                	jmp    800420 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80040b:	ff 45 e8             	incl   -0x18(%ebp)
  80040e:	a1 20 30 80 00       	mov    0x803020,%eax
  800413:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800419:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80041c:	39 c2                	cmp    %eax,%edx
  80041e:	77 85                	ja     8003a5 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800420:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800424:	75 14                	jne    80043a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800426:	83 ec 04             	sub    $0x4,%esp
  800429:	68 8c 22 80 00       	push   $0x80228c
  80042e:	6a 3a                	push   $0x3a
  800430:	68 80 22 80 00       	push   $0x802280
  800435:	e8 88 fe ff ff       	call   8002c2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80043a:	ff 45 f0             	incl   -0x10(%ebp)
  80043d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800440:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800443:	0f 8c 2f ff ff ff    	jl     800378 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800449:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800450:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800457:	eb 26                	jmp    80047f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800459:	a1 20 30 80 00       	mov    0x803020,%eax
  80045e:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800464:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800467:	89 d0                	mov    %edx,%eax
  800469:	01 c0                	add    %eax,%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	c1 e0 03             	shl    $0x3,%eax
  800470:	01 c8                	add    %ecx,%eax
  800472:	8a 40 04             	mov    0x4(%eax),%al
  800475:	3c 01                	cmp    $0x1,%al
  800477:	75 03                	jne    80047c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800479:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80047c:	ff 45 e0             	incl   -0x20(%ebp)
  80047f:	a1 20 30 80 00       	mov    0x803020,%eax
  800484:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80048a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80048d:	39 c2                	cmp    %eax,%edx
  80048f:	77 c8                	ja     800459 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800494:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800497:	74 14                	je     8004ad <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800499:	83 ec 04             	sub    $0x4,%esp
  80049c:	68 e0 22 80 00       	push   $0x8022e0
  8004a1:	6a 44                	push   $0x44
  8004a3:	68 80 22 80 00       	push   $0x802280
  8004a8:	e8 15 fe ff ff       	call   8002c2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004ad:	90                   	nop
  8004ae:	c9                   	leave  
  8004af:	c3                   	ret    

008004b0 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
  8004b3:	53                   	push   %ebx
  8004b4:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	8d 48 01             	lea    0x1(%eax),%ecx
  8004bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c2:	89 0a                	mov    %ecx,(%edx)
  8004c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c7:	88 d1                	mov    %dl,%cl
  8004c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d3:	8b 00                	mov    (%eax),%eax
  8004d5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004da:	75 30                	jne    80050c <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004dc:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004e2:	a0 44 30 80 00       	mov    0x803044,%al
  8004e7:	0f b6 c0             	movzbl %al,%eax
  8004ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ed:	8b 09                	mov    (%ecx),%ecx
  8004ef:	89 cb                	mov    %ecx,%ebx
  8004f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004f4:	83 c1 08             	add    $0x8,%ecx
  8004f7:	52                   	push   %edx
  8004f8:	50                   	push   %eax
  8004f9:	53                   	push   %ebx
  8004fa:	51                   	push   %ecx
  8004fb:	e8 57 11 00 00       	call   801657 <sys_cputs>
  800500:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800503:	8b 45 0c             	mov    0xc(%ebp),%eax
  800506:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80050c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050f:	8b 40 04             	mov    0x4(%eax),%eax
  800512:	8d 50 01             	lea    0x1(%eax),%edx
  800515:	8b 45 0c             	mov    0xc(%ebp),%eax
  800518:	89 50 04             	mov    %edx,0x4(%eax)
}
  80051b:	90                   	nop
  80051c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80051f:	c9                   	leave  
  800520:	c3                   	ret    

00800521 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800521:	55                   	push   %ebp
  800522:	89 e5                	mov    %esp,%ebp
  800524:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80052a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800531:	00 00 00 
	b.cnt = 0;
  800534:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80053b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80053e:	ff 75 0c             	pushl  0xc(%ebp)
  800541:	ff 75 08             	pushl  0x8(%ebp)
  800544:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054a:	50                   	push   %eax
  80054b:	68 b0 04 80 00       	push   $0x8004b0
  800550:	e8 5a 02 00 00       	call   8007af <vprintfmt>
  800555:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800558:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80055e:	a0 44 30 80 00       	mov    0x803044,%al
  800563:	0f b6 c0             	movzbl %al,%eax
  800566:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80056c:	52                   	push   %edx
  80056d:	50                   	push   %eax
  80056e:	51                   	push   %ecx
  80056f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800575:	83 c0 08             	add    $0x8,%eax
  800578:	50                   	push   %eax
  800579:	e8 d9 10 00 00       	call   801657 <sys_cputs>
  80057e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800581:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800588:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80058e:	c9                   	leave  
  80058f:	c3                   	ret    

00800590 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
  800593:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800596:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80059d:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a6:	83 ec 08             	sub    $0x8,%esp
  8005a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ac:	50                   	push   %eax
  8005ad:	e8 6f ff ff ff       	call   800521 <vcprintf>
  8005b2:	83 c4 10             	add    $0x10,%esp
  8005b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005bb:	c9                   	leave  
  8005bc:	c3                   	ret    

008005bd <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005bd:	55                   	push   %ebp
  8005be:	89 e5                	mov    %esp,%ebp
  8005c0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005c3:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cd:	c1 e0 08             	shl    $0x8,%eax
  8005d0:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8005d5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d8:	83 c0 04             	add    $0x4,%eax
  8005db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e1:	83 ec 08             	sub    $0x8,%esp
  8005e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e7:	50                   	push   %eax
  8005e8:	e8 34 ff ff ff       	call   800521 <vcprintf>
  8005ed:	83 c4 10             	add    $0x10,%esp
  8005f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8005f3:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8005fa:	07 00 00 

	return cnt;
  8005fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800600:	c9                   	leave  
  800601:	c3                   	ret    

00800602 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800602:	55                   	push   %ebp
  800603:	89 e5                	mov    %esp,%ebp
  800605:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800608:	e8 8e 10 00 00       	call   80169b <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80060d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800610:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800613:	8b 45 08             	mov    0x8(%ebp),%eax
  800616:	83 ec 08             	sub    $0x8,%esp
  800619:	ff 75 f4             	pushl  -0xc(%ebp)
  80061c:	50                   	push   %eax
  80061d:	e8 ff fe ff ff       	call   800521 <vcprintf>
  800622:	83 c4 10             	add    $0x10,%esp
  800625:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800628:	e8 88 10 00 00       	call   8016b5 <sys_unlock_cons>
	return cnt;
  80062d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800630:	c9                   	leave  
  800631:	c3                   	ret    

00800632 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800632:	55                   	push   %ebp
  800633:	89 e5                	mov    %esp,%ebp
  800635:	53                   	push   %ebx
  800636:	83 ec 14             	sub    $0x14,%esp
  800639:	8b 45 10             	mov    0x10(%ebp),%eax
  80063c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800645:	8b 45 18             	mov    0x18(%ebp),%eax
  800648:	ba 00 00 00 00       	mov    $0x0,%edx
  80064d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800650:	77 55                	ja     8006a7 <printnum+0x75>
  800652:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800655:	72 05                	jb     80065c <printnum+0x2a>
  800657:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80065a:	77 4b                	ja     8006a7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80065c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80065f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800662:	8b 45 18             	mov    0x18(%ebp),%eax
  800665:	ba 00 00 00 00       	mov    $0x0,%edx
  80066a:	52                   	push   %edx
  80066b:	50                   	push   %eax
  80066c:	ff 75 f4             	pushl  -0xc(%ebp)
  80066f:	ff 75 f0             	pushl  -0x10(%ebp)
  800672:	e8 a9 16 00 00       	call   801d20 <__udivdi3>
  800677:	83 c4 10             	add    $0x10,%esp
  80067a:	83 ec 04             	sub    $0x4,%esp
  80067d:	ff 75 20             	pushl  0x20(%ebp)
  800680:	53                   	push   %ebx
  800681:	ff 75 18             	pushl  0x18(%ebp)
  800684:	52                   	push   %edx
  800685:	50                   	push   %eax
  800686:	ff 75 0c             	pushl  0xc(%ebp)
  800689:	ff 75 08             	pushl  0x8(%ebp)
  80068c:	e8 a1 ff ff ff       	call   800632 <printnum>
  800691:	83 c4 20             	add    $0x20,%esp
  800694:	eb 1a                	jmp    8006b0 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800696:	83 ec 08             	sub    $0x8,%esp
  800699:	ff 75 0c             	pushl  0xc(%ebp)
  80069c:	ff 75 20             	pushl  0x20(%ebp)
  80069f:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a2:	ff d0                	call   *%eax
  8006a4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006a7:	ff 4d 1c             	decl   0x1c(%ebp)
  8006aa:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006ae:	7f e6                	jg     800696 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006b0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006be:	53                   	push   %ebx
  8006bf:	51                   	push   %ecx
  8006c0:	52                   	push   %edx
  8006c1:	50                   	push   %eax
  8006c2:	e8 69 17 00 00       	call   801e30 <__umoddi3>
  8006c7:	83 c4 10             	add    $0x10,%esp
  8006ca:	05 54 25 80 00       	add    $0x802554,%eax
  8006cf:	8a 00                	mov    (%eax),%al
  8006d1:	0f be c0             	movsbl %al,%eax
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	ff 75 0c             	pushl  0xc(%ebp)
  8006da:	50                   	push   %eax
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	ff d0                	call   *%eax
  8006e0:	83 c4 10             	add    $0x10,%esp
}
  8006e3:	90                   	nop
  8006e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006e7:	c9                   	leave  
  8006e8:	c3                   	ret    

008006e9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006ec:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006f0:	7e 1c                	jle    80070e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	8d 50 08             	lea    0x8(%eax),%edx
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	89 10                	mov    %edx,(%eax)
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	8b 00                	mov    (%eax),%eax
  800704:	83 e8 08             	sub    $0x8,%eax
  800707:	8b 50 04             	mov    0x4(%eax),%edx
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	eb 40                	jmp    80074e <getuint+0x65>
	else if (lflag)
  80070e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800712:	74 1e                	je     800732 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800714:	8b 45 08             	mov    0x8(%ebp),%eax
  800717:	8b 00                	mov    (%eax),%eax
  800719:	8d 50 04             	lea    0x4(%eax),%edx
  80071c:	8b 45 08             	mov    0x8(%ebp),%eax
  80071f:	89 10                	mov    %edx,(%eax)
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	83 e8 04             	sub    $0x4,%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	ba 00 00 00 00       	mov    $0x0,%edx
  800730:	eb 1c                	jmp    80074e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
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
}
  80074e:	5d                   	pop    %ebp
  80074f:	c3                   	ret    

00800750 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800753:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800757:	7e 1c                	jle    800775 <getint+0x25>
		return va_arg(*ap, long long);
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	8b 00                	mov    (%eax),%eax
  80075e:	8d 50 08             	lea    0x8(%eax),%edx
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	89 10                	mov    %edx,(%eax)
  800766:	8b 45 08             	mov    0x8(%ebp),%eax
  800769:	8b 00                	mov    (%eax),%eax
  80076b:	83 e8 08             	sub    $0x8,%eax
  80076e:	8b 50 04             	mov    0x4(%eax),%edx
  800771:	8b 00                	mov    (%eax),%eax
  800773:	eb 38                	jmp    8007ad <getint+0x5d>
	else if (lflag)
  800775:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800779:	74 1a                	je     800795 <getint+0x45>
		return va_arg(*ap, long);
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	8d 50 04             	lea    0x4(%eax),%edx
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	89 10                	mov    %edx,(%eax)
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	8b 00                	mov    (%eax),%eax
  80078d:	83 e8 04             	sub    $0x4,%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	99                   	cltd   
  800793:	eb 18                	jmp    8007ad <getint+0x5d>
	else
		return va_arg(*ap, int);
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	8d 50 04             	lea    0x4(%eax),%edx
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	89 10                	mov    %edx,(%eax)
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	8b 00                	mov    (%eax),%eax
  8007a7:	83 e8 04             	sub    $0x4,%eax
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	99                   	cltd   
}
  8007ad:	5d                   	pop    %ebp
  8007ae:	c3                   	ret    

008007af <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007af:	55                   	push   %ebp
  8007b0:	89 e5                	mov    %esp,%ebp
  8007b2:	56                   	push   %esi
  8007b3:	53                   	push   %ebx
  8007b4:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b7:	eb 17                	jmp    8007d0 <vprintfmt+0x21>
			if (ch == '\0')
  8007b9:	85 db                	test   %ebx,%ebx
  8007bb:	0f 84 c1 03 00 00    	je     800b82 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007c1:	83 ec 08             	sub    $0x8,%esp
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	53                   	push   %ebx
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	ff d0                	call   *%eax
  8007cd:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d3:	8d 50 01             	lea    0x1(%eax),%edx
  8007d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8007d9:	8a 00                	mov    (%eax),%al
  8007db:	0f b6 d8             	movzbl %al,%ebx
  8007de:	83 fb 25             	cmp    $0x25,%ebx
  8007e1:	75 d6                	jne    8007b9 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007e3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007e7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007ee:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007f5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007fc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800803:	8b 45 10             	mov    0x10(%ebp),%eax
  800806:	8d 50 01             	lea    0x1(%eax),%edx
  800809:	89 55 10             	mov    %edx,0x10(%ebp)
  80080c:	8a 00                	mov    (%eax),%al
  80080e:	0f b6 d8             	movzbl %al,%ebx
  800811:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800814:	83 f8 5b             	cmp    $0x5b,%eax
  800817:	0f 87 3d 03 00 00    	ja     800b5a <vprintfmt+0x3ab>
  80081d:	8b 04 85 78 25 80 00 	mov    0x802578(,%eax,4),%eax
  800824:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800826:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80082a:	eb d7                	jmp    800803 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80082c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800830:	eb d1                	jmp    800803 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800832:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800839:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80083c:	89 d0                	mov    %edx,%eax
  80083e:	c1 e0 02             	shl    $0x2,%eax
  800841:	01 d0                	add    %edx,%eax
  800843:	01 c0                	add    %eax,%eax
  800845:	01 d8                	add    %ebx,%eax
  800847:	83 e8 30             	sub    $0x30,%eax
  80084a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80084d:	8b 45 10             	mov    0x10(%ebp),%eax
  800850:	8a 00                	mov    (%eax),%al
  800852:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800855:	83 fb 2f             	cmp    $0x2f,%ebx
  800858:	7e 3e                	jle    800898 <vprintfmt+0xe9>
  80085a:	83 fb 39             	cmp    $0x39,%ebx
  80085d:	7f 39                	jg     800898 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80085f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800862:	eb d5                	jmp    800839 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800864:	8b 45 14             	mov    0x14(%ebp),%eax
  800867:	83 c0 04             	add    $0x4,%eax
  80086a:	89 45 14             	mov    %eax,0x14(%ebp)
  80086d:	8b 45 14             	mov    0x14(%ebp),%eax
  800870:	83 e8 04             	sub    $0x4,%eax
  800873:	8b 00                	mov    (%eax),%eax
  800875:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800878:	eb 1f                	jmp    800899 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80087a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80087e:	79 83                	jns    800803 <vprintfmt+0x54>
				width = 0;
  800880:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800887:	e9 77 ff ff ff       	jmp    800803 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80088c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800893:	e9 6b ff ff ff       	jmp    800803 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800898:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800899:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80089d:	0f 89 60 ff ff ff    	jns    800803 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008a9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008b0:	e9 4e ff ff ff       	jmp    800803 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008b5:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008b8:	e9 46 ff ff ff       	jmp    800803 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c0:	83 c0 04             	add    $0x4,%eax
  8008c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c9:	83 e8 04             	sub    $0x4,%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	83 ec 08             	sub    $0x8,%esp
  8008d1:	ff 75 0c             	pushl  0xc(%ebp)
  8008d4:	50                   	push   %eax
  8008d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d8:	ff d0                	call   *%eax
  8008da:	83 c4 10             	add    $0x10,%esp
			break;
  8008dd:	e9 9b 02 00 00       	jmp    800b7d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e5:	83 c0 04             	add    $0x4,%eax
  8008e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ee:	83 e8 04             	sub    $0x4,%eax
  8008f1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008f3:	85 db                	test   %ebx,%ebx
  8008f5:	79 02                	jns    8008f9 <vprintfmt+0x14a>
				err = -err;
  8008f7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008f9:	83 fb 64             	cmp    $0x64,%ebx
  8008fc:	7f 0b                	jg     800909 <vprintfmt+0x15a>
  8008fe:	8b 34 9d c0 23 80 00 	mov    0x8023c0(,%ebx,4),%esi
  800905:	85 f6                	test   %esi,%esi
  800907:	75 19                	jne    800922 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800909:	53                   	push   %ebx
  80090a:	68 65 25 80 00       	push   $0x802565
  80090f:	ff 75 0c             	pushl  0xc(%ebp)
  800912:	ff 75 08             	pushl  0x8(%ebp)
  800915:	e8 70 02 00 00       	call   800b8a <printfmt>
  80091a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80091d:	e9 5b 02 00 00       	jmp    800b7d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800922:	56                   	push   %esi
  800923:	68 6e 25 80 00       	push   $0x80256e
  800928:	ff 75 0c             	pushl  0xc(%ebp)
  80092b:	ff 75 08             	pushl  0x8(%ebp)
  80092e:	e8 57 02 00 00       	call   800b8a <printfmt>
  800933:	83 c4 10             	add    $0x10,%esp
			break;
  800936:	e9 42 02 00 00       	jmp    800b7d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80093b:	8b 45 14             	mov    0x14(%ebp),%eax
  80093e:	83 c0 04             	add    $0x4,%eax
  800941:	89 45 14             	mov    %eax,0x14(%ebp)
  800944:	8b 45 14             	mov    0x14(%ebp),%eax
  800947:	83 e8 04             	sub    $0x4,%eax
  80094a:	8b 30                	mov    (%eax),%esi
  80094c:	85 f6                	test   %esi,%esi
  80094e:	75 05                	jne    800955 <vprintfmt+0x1a6>
				p = "(null)";
  800950:	be 71 25 80 00       	mov    $0x802571,%esi
			if (width > 0 && padc != '-')
  800955:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800959:	7e 6d                	jle    8009c8 <vprintfmt+0x219>
  80095b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80095f:	74 67                	je     8009c8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800961:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800964:	83 ec 08             	sub    $0x8,%esp
  800967:	50                   	push   %eax
  800968:	56                   	push   %esi
  800969:	e8 1e 03 00 00       	call   800c8c <strnlen>
  80096e:	83 c4 10             	add    $0x10,%esp
  800971:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800974:	eb 16                	jmp    80098c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800976:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80097a:	83 ec 08             	sub    $0x8,%esp
  80097d:	ff 75 0c             	pushl  0xc(%ebp)
  800980:	50                   	push   %eax
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	ff d0                	call   *%eax
  800986:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800989:	ff 4d e4             	decl   -0x1c(%ebp)
  80098c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800990:	7f e4                	jg     800976 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800992:	eb 34                	jmp    8009c8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800994:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800998:	74 1c                	je     8009b6 <vprintfmt+0x207>
  80099a:	83 fb 1f             	cmp    $0x1f,%ebx
  80099d:	7e 05                	jle    8009a4 <vprintfmt+0x1f5>
  80099f:	83 fb 7e             	cmp    $0x7e,%ebx
  8009a2:	7e 12                	jle    8009b6 <vprintfmt+0x207>
					putch('?', putdat);
  8009a4:	83 ec 08             	sub    $0x8,%esp
  8009a7:	ff 75 0c             	pushl  0xc(%ebp)
  8009aa:	6a 3f                	push   $0x3f
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	ff d0                	call   *%eax
  8009b1:	83 c4 10             	add    $0x10,%esp
  8009b4:	eb 0f                	jmp    8009c5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009b6:	83 ec 08             	sub    $0x8,%esp
  8009b9:	ff 75 0c             	pushl  0xc(%ebp)
  8009bc:	53                   	push   %ebx
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	ff d0                	call   *%eax
  8009c2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009c5:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c8:	89 f0                	mov    %esi,%eax
  8009ca:	8d 70 01             	lea    0x1(%eax),%esi
  8009cd:	8a 00                	mov    (%eax),%al
  8009cf:	0f be d8             	movsbl %al,%ebx
  8009d2:	85 db                	test   %ebx,%ebx
  8009d4:	74 24                	je     8009fa <vprintfmt+0x24b>
  8009d6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009da:	78 b8                	js     800994 <vprintfmt+0x1e5>
  8009dc:	ff 4d e0             	decl   -0x20(%ebp)
  8009df:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009e3:	79 af                	jns    800994 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009e5:	eb 13                	jmp    8009fa <vprintfmt+0x24b>
				putch(' ', putdat);
  8009e7:	83 ec 08             	sub    $0x8,%esp
  8009ea:	ff 75 0c             	pushl  0xc(%ebp)
  8009ed:	6a 20                	push   $0x20
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	ff d0                	call   *%eax
  8009f4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f7:	ff 4d e4             	decl   -0x1c(%ebp)
  8009fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009fe:	7f e7                	jg     8009e7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a00:	e9 78 01 00 00       	jmp    800b7d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a05:	83 ec 08             	sub    $0x8,%esp
  800a08:	ff 75 e8             	pushl  -0x18(%ebp)
  800a0b:	8d 45 14             	lea    0x14(%ebp),%eax
  800a0e:	50                   	push   %eax
  800a0f:	e8 3c fd ff ff       	call   800750 <getint>
  800a14:	83 c4 10             	add    $0x10,%esp
  800a17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a23:	85 d2                	test   %edx,%edx
  800a25:	79 23                	jns    800a4a <vprintfmt+0x29b>
				putch('-', putdat);
  800a27:	83 ec 08             	sub    $0x8,%esp
  800a2a:	ff 75 0c             	pushl  0xc(%ebp)
  800a2d:	6a 2d                	push   $0x2d
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	ff d0                	call   *%eax
  800a34:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a3d:	f7 d8                	neg    %eax
  800a3f:	83 d2 00             	adc    $0x0,%edx
  800a42:	f7 da                	neg    %edx
  800a44:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a47:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a4a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a51:	e9 bc 00 00 00       	jmp    800b12 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	ff 75 e8             	pushl  -0x18(%ebp)
  800a5c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5f:	50                   	push   %eax
  800a60:	e8 84 fc ff ff       	call   8006e9 <getuint>
  800a65:	83 c4 10             	add    $0x10,%esp
  800a68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a6e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a75:	e9 98 00 00 00       	jmp    800b12 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a7a:	83 ec 08             	sub    $0x8,%esp
  800a7d:	ff 75 0c             	pushl  0xc(%ebp)
  800a80:	6a 58                	push   $0x58
  800a82:	8b 45 08             	mov    0x8(%ebp),%eax
  800a85:	ff d0                	call   *%eax
  800a87:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a8a:	83 ec 08             	sub    $0x8,%esp
  800a8d:	ff 75 0c             	pushl  0xc(%ebp)
  800a90:	6a 58                	push   $0x58
  800a92:	8b 45 08             	mov    0x8(%ebp),%eax
  800a95:	ff d0                	call   *%eax
  800a97:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a9a:	83 ec 08             	sub    $0x8,%esp
  800a9d:	ff 75 0c             	pushl  0xc(%ebp)
  800aa0:	6a 58                	push   $0x58
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	ff d0                	call   *%eax
  800aa7:	83 c4 10             	add    $0x10,%esp
			break;
  800aaa:	e9 ce 00 00 00       	jmp    800b7d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800aaf:	83 ec 08             	sub    $0x8,%esp
  800ab2:	ff 75 0c             	pushl  0xc(%ebp)
  800ab5:	6a 30                	push   $0x30
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	ff d0                	call   *%eax
  800abc:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800abf:	83 ec 08             	sub    $0x8,%esp
  800ac2:	ff 75 0c             	pushl  0xc(%ebp)
  800ac5:	6a 78                	push   $0x78
  800ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aca:	ff d0                	call   *%eax
  800acc:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800acf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad2:	83 c0 04             	add    $0x4,%eax
  800ad5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad8:	8b 45 14             	mov    0x14(%ebp),%eax
  800adb:	83 e8 04             	sub    $0x4,%eax
  800ade:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ae0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800aea:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800af1:	eb 1f                	jmp    800b12 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800af3:	83 ec 08             	sub    $0x8,%esp
  800af6:	ff 75 e8             	pushl  -0x18(%ebp)
  800af9:	8d 45 14             	lea    0x14(%ebp),%eax
  800afc:	50                   	push   %eax
  800afd:	e8 e7 fb ff ff       	call   8006e9 <getuint>
  800b02:	83 c4 10             	add    $0x10,%esp
  800b05:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b08:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b0b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b12:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b19:	83 ec 04             	sub    $0x4,%esp
  800b1c:	52                   	push   %edx
  800b1d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b20:	50                   	push   %eax
  800b21:	ff 75 f4             	pushl  -0xc(%ebp)
  800b24:	ff 75 f0             	pushl  -0x10(%ebp)
  800b27:	ff 75 0c             	pushl  0xc(%ebp)
  800b2a:	ff 75 08             	pushl  0x8(%ebp)
  800b2d:	e8 00 fb ff ff       	call   800632 <printnum>
  800b32:	83 c4 20             	add    $0x20,%esp
			break;
  800b35:	eb 46                	jmp    800b7d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b37:	83 ec 08             	sub    $0x8,%esp
  800b3a:	ff 75 0c             	pushl  0xc(%ebp)
  800b3d:	53                   	push   %ebx
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	ff d0                	call   *%eax
  800b43:	83 c4 10             	add    $0x10,%esp
			break;
  800b46:	eb 35                	jmp    800b7d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b48:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b4f:	eb 2c                	jmp    800b7d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b51:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b58:	eb 23                	jmp    800b7d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b5a:	83 ec 08             	sub    $0x8,%esp
  800b5d:	ff 75 0c             	pushl  0xc(%ebp)
  800b60:	6a 25                	push   $0x25
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	ff d0                	call   *%eax
  800b67:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b6a:	ff 4d 10             	decl   0x10(%ebp)
  800b6d:	eb 03                	jmp    800b72 <vprintfmt+0x3c3>
  800b6f:	ff 4d 10             	decl   0x10(%ebp)
  800b72:	8b 45 10             	mov    0x10(%ebp),%eax
  800b75:	48                   	dec    %eax
  800b76:	8a 00                	mov    (%eax),%al
  800b78:	3c 25                	cmp    $0x25,%al
  800b7a:	75 f3                	jne    800b6f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b7c:	90                   	nop
		}
	}
  800b7d:	e9 35 fc ff ff       	jmp    8007b7 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b82:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b83:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b86:	5b                   	pop    %ebx
  800b87:	5e                   	pop    %esi
  800b88:	5d                   	pop    %ebp
  800b89:	c3                   	ret    

00800b8a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b8a:	55                   	push   %ebp
  800b8b:	89 e5                	mov    %esp,%ebp
  800b8d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b90:	8d 45 10             	lea    0x10(%ebp),%eax
  800b93:	83 c0 04             	add    $0x4,%eax
  800b96:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b99:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b9f:	50                   	push   %eax
  800ba0:	ff 75 0c             	pushl  0xc(%ebp)
  800ba3:	ff 75 08             	pushl  0x8(%ebp)
  800ba6:	e8 04 fc ff ff       	call   8007af <vprintfmt>
  800bab:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bae:	90                   	nop
  800baf:	c9                   	leave  
  800bb0:	c3                   	ret    

00800bb1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bb1:	55                   	push   %ebp
  800bb2:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb7:	8b 40 08             	mov    0x8(%eax),%eax
  800bba:	8d 50 01             	lea    0x1(%eax),%edx
  800bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc0:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc6:	8b 10                	mov    (%eax),%edx
  800bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcb:	8b 40 04             	mov    0x4(%eax),%eax
  800bce:	39 c2                	cmp    %eax,%edx
  800bd0:	73 12                	jae    800be4 <sprintputch+0x33>
		*b->buf++ = ch;
  800bd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd5:	8b 00                	mov    (%eax),%eax
  800bd7:	8d 48 01             	lea    0x1(%eax),%ecx
  800bda:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bdd:	89 0a                	mov    %ecx,(%edx)
  800bdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800be2:	88 10                	mov    %dl,(%eax)
}
  800be4:	90                   	nop
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	01 d0                	add    %edx,%eax
  800bfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c0c:	74 06                	je     800c14 <vsnprintf+0x2d>
  800c0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c12:	7f 07                	jg     800c1b <vsnprintf+0x34>
		return -E_INVAL;
  800c14:	b8 03 00 00 00       	mov    $0x3,%eax
  800c19:	eb 20                	jmp    800c3b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c1b:	ff 75 14             	pushl  0x14(%ebp)
  800c1e:	ff 75 10             	pushl  0x10(%ebp)
  800c21:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c24:	50                   	push   %eax
  800c25:	68 b1 0b 80 00       	push   $0x800bb1
  800c2a:	e8 80 fb ff ff       	call   8007af <vprintfmt>
  800c2f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c35:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c3b:	c9                   	leave  
  800c3c:	c3                   	ret    

00800c3d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c3d:	55                   	push   %ebp
  800c3e:	89 e5                	mov    %esp,%ebp
  800c40:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c43:	8d 45 10             	lea    0x10(%ebp),%eax
  800c46:	83 c0 04             	add    $0x4,%eax
  800c49:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4f:	ff 75 f4             	pushl  -0xc(%ebp)
  800c52:	50                   	push   %eax
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	ff 75 08             	pushl  0x8(%ebp)
  800c59:	e8 89 ff ff ff       	call   800be7 <vsnprintf>
  800c5e:	83 c4 10             	add    $0x10,%esp
  800c61:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c64:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c76:	eb 06                	jmp    800c7e <strlen+0x15>
		n++;
  800c78:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c7b:	ff 45 08             	incl   0x8(%ebp)
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8a 00                	mov    (%eax),%al
  800c83:	84 c0                	test   %al,%al
  800c85:	75 f1                	jne    800c78 <strlen+0xf>
		n++;
	return n;
  800c87:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c8a:	c9                   	leave  
  800c8b:	c3                   	ret    

00800c8c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c99:	eb 09                	jmp    800ca4 <strnlen+0x18>
		n++;
  800c9b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c9e:	ff 45 08             	incl   0x8(%ebp)
  800ca1:	ff 4d 0c             	decl   0xc(%ebp)
  800ca4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca8:	74 09                	je     800cb3 <strnlen+0x27>
  800caa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cad:	8a 00                	mov    (%eax),%al
  800caf:	84 c0                	test   %al,%al
  800cb1:	75 e8                	jne    800c9b <strnlen+0xf>
		n++;
	return n;
  800cb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb6:	c9                   	leave  
  800cb7:	c3                   	ret    

00800cb8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cc4:	90                   	nop
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	8d 50 01             	lea    0x1(%eax),%edx
  800ccb:	89 55 08             	mov    %edx,0x8(%ebp)
  800cce:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd7:	8a 12                	mov    (%edx),%dl
  800cd9:	88 10                	mov    %dl,(%eax)
  800cdb:	8a 00                	mov    (%eax),%al
  800cdd:	84 c0                	test   %al,%al
  800cdf:	75 e4                	jne    800cc5 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ce1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce4:	c9                   	leave  
  800ce5:	c3                   	ret    

00800ce6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ce6:	55                   	push   %ebp
  800ce7:	89 e5                	mov    %esp,%ebp
  800ce9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cf2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf9:	eb 1f                	jmp    800d1a <strncpy+0x34>
		*dst++ = *src;
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	8d 50 01             	lea    0x1(%eax),%edx
  800d01:	89 55 08             	mov    %edx,0x8(%ebp)
  800d04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d07:	8a 12                	mov    (%edx),%dl
  800d09:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0e:	8a 00                	mov    (%eax),%al
  800d10:	84 c0                	test   %al,%al
  800d12:	74 03                	je     800d17 <strncpy+0x31>
			src++;
  800d14:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d17:	ff 45 fc             	incl   -0x4(%ebp)
  800d1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d1d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d20:	72 d9                	jb     800cfb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d22:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d25:	c9                   	leave  
  800d26:	c3                   	ret    

00800d27 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d33:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d37:	74 30                	je     800d69 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d39:	eb 16                	jmp    800d51 <strlcpy+0x2a>
			*dst++ = *src++;
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	8d 50 01             	lea    0x1(%eax),%edx
  800d41:	89 55 08             	mov    %edx,0x8(%ebp)
  800d44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d47:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d4a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d4d:	8a 12                	mov    (%edx),%dl
  800d4f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d51:	ff 4d 10             	decl   0x10(%ebp)
  800d54:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d58:	74 09                	je     800d63 <strlcpy+0x3c>
  800d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5d:	8a 00                	mov    (%eax),%al
  800d5f:	84 c0                	test   %al,%al
  800d61:	75 d8                	jne    800d3b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d69:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6f:	29 c2                	sub    %eax,%edx
  800d71:	89 d0                	mov    %edx,%eax
}
  800d73:	c9                   	leave  
  800d74:	c3                   	ret    

00800d75 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d78:	eb 06                	jmp    800d80 <strcmp+0xb>
		p++, q++;
  800d7a:	ff 45 08             	incl   0x8(%ebp)
  800d7d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	84 c0                	test   %al,%al
  800d87:	74 0e                	je     800d97 <strcmp+0x22>
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 10                	mov    (%eax),%dl
  800d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d91:	8a 00                	mov    (%eax),%al
  800d93:	38 c2                	cmp    %al,%dl
  800d95:	74 e3                	je     800d7a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8a 00                	mov    (%eax),%al
  800d9c:	0f b6 d0             	movzbl %al,%edx
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	8a 00                	mov    (%eax),%al
  800da4:	0f b6 c0             	movzbl %al,%eax
  800da7:	29 c2                	sub    %eax,%edx
  800da9:	89 d0                	mov    %edx,%eax
}
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    

00800dad <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800db0:	eb 09                	jmp    800dbb <strncmp+0xe>
		n--, p++, q++;
  800db2:	ff 4d 10             	decl   0x10(%ebp)
  800db5:	ff 45 08             	incl   0x8(%ebp)
  800db8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dbb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbf:	74 17                	je     800dd8 <strncmp+0x2b>
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	8a 00                	mov    (%eax),%al
  800dc6:	84 c0                	test   %al,%al
  800dc8:	74 0e                	je     800dd8 <strncmp+0x2b>
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	8a 10                	mov    (%eax),%dl
  800dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	38 c2                	cmp    %al,%dl
  800dd6:	74 da                	je     800db2 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dd8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ddc:	75 07                	jne    800de5 <strncmp+0x38>
		return 0;
  800dde:	b8 00 00 00 00       	mov    $0x0,%eax
  800de3:	eb 14                	jmp    800df9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	8a 00                	mov    (%eax),%al
  800dea:	0f b6 d0             	movzbl %al,%edx
  800ded:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df0:	8a 00                	mov    (%eax),%al
  800df2:	0f b6 c0             	movzbl %al,%eax
  800df5:	29 c2                	sub    %eax,%edx
  800df7:	89 d0                	mov    %edx,%eax
}
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    

00800dfb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	83 ec 04             	sub    $0x4,%esp
  800e01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e04:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e07:	eb 12                	jmp    800e1b <strchr+0x20>
		if (*s == c)
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8a 00                	mov    (%eax),%al
  800e0e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e11:	75 05                	jne    800e18 <strchr+0x1d>
			return (char *) s;
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	eb 11                	jmp    800e29 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e18:	ff 45 08             	incl   0x8(%ebp)
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	84 c0                	test   %al,%al
  800e22:	75 e5                	jne    800e09 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e29:	c9                   	leave  
  800e2a:	c3                   	ret    

00800e2b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	83 ec 04             	sub    $0x4,%esp
  800e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e34:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e37:	eb 0d                	jmp    800e46 <strfind+0x1b>
		if (*s == c)
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e41:	74 0e                	je     800e51 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e43:	ff 45 08             	incl   0x8(%ebp)
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	8a 00                	mov    (%eax),%al
  800e4b:	84 c0                	test   %al,%al
  800e4d:	75 ea                	jne    800e39 <strfind+0xe>
  800e4f:	eb 01                	jmp    800e52 <strfind+0x27>
		if (*s == c)
			break;
  800e51:	90                   	nop
	return (char *) s;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e55:	c9                   	leave  
  800e56:	c3                   	ret    

00800e57 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e57:	55                   	push   %ebp
  800e58:	89 e5                	mov    %esp,%ebp
  800e5a:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e63:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e67:	76 63                	jbe    800ecc <memset+0x75>
		uint64 data_block = c;
  800e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6c:	99                   	cltd   
  800e6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e70:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e79:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e7d:	c1 e0 08             	shl    $0x8,%eax
  800e80:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e83:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e8c:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e90:	c1 e0 10             	shl    $0x10,%eax
  800e93:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e96:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9f:	89 c2                	mov    %eax,%edx
  800ea1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea6:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ea9:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800eac:	eb 18                	jmp    800ec6 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800eae:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800eb1:	8d 41 08             	lea    0x8(%ecx),%eax
  800eb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ebd:	89 01                	mov    %eax,(%ecx)
  800ebf:	89 51 04             	mov    %edx,0x4(%ecx)
  800ec2:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ec6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800eca:	77 e2                	ja     800eae <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ecc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed0:	74 23                	je     800ef5 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ed8:	eb 0e                	jmp    800ee8 <memset+0x91>
			*p8++ = (uint8)c;
  800eda:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800edd:	8d 50 01             	lea    0x1(%eax),%edx
  800ee0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ee3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee6:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800ee8:	8b 45 10             	mov    0x10(%ebp),%eax
  800eeb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eee:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef1:	85 c0                	test   %eax,%eax
  800ef3:	75 e5                	jne    800eda <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef8:	c9                   	leave  
  800ef9:	c3                   	ret    

00800efa <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f0c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f10:	76 24                	jbe    800f36 <memcpy+0x3c>
		while(n >= 8){
  800f12:	eb 1c                	jmp    800f30 <memcpy+0x36>
			*d64 = *s64;
  800f14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f17:	8b 50 04             	mov    0x4(%eax),%edx
  800f1a:	8b 00                	mov    (%eax),%eax
  800f1c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f1f:	89 01                	mov    %eax,(%ecx)
  800f21:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f24:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f28:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f2c:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f30:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f34:	77 de                	ja     800f14 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3a:	74 31                	je     800f6d <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f42:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f45:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f48:	eb 16                	jmp    800f60 <memcpy+0x66>
			*d8++ = *s8++;
  800f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f4d:	8d 50 01             	lea    0x1(%eax),%edx
  800f50:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f56:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f59:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f5c:	8a 12                	mov    (%edx),%dl
  800f5e:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f60:	8b 45 10             	mov    0x10(%ebp),%eax
  800f63:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f66:	89 55 10             	mov    %edx,0x10(%ebp)
  800f69:	85 c0                	test   %eax,%eax
  800f6b:	75 dd                	jne    800f4a <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f70:	c9                   	leave  
  800f71:	c3                   	ret    

00800f72 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f72:	55                   	push   %ebp
  800f73:	89 e5                	mov    %esp,%ebp
  800f75:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f87:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f8a:	73 50                	jae    800fdc <memmove+0x6a>
  800f8c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f92:	01 d0                	add    %edx,%eax
  800f94:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f97:	76 43                	jbe    800fdc <memmove+0x6a>
		s += n;
  800f99:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fa5:	eb 10                	jmp    800fb7 <memmove+0x45>
			*--d = *--s;
  800fa7:	ff 4d f8             	decl   -0x8(%ebp)
  800faa:	ff 4d fc             	decl   -0x4(%ebp)
  800fad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb0:	8a 10                	mov    (%eax),%dl
  800fb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fba:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fbd:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc0:	85 c0                	test   %eax,%eax
  800fc2:	75 e3                	jne    800fa7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fc4:	eb 23                	jmp    800fe9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc9:	8d 50 01             	lea    0x1(%eax),%edx
  800fcc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fcf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fd5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fd8:	8a 12                	mov    (%edx),%dl
  800fda:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe2:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe5:	85 c0                	test   %eax,%eax
  800fe7:	75 dd                	jne    800fc6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fec:	c9                   	leave  
  800fed:	c3                   	ret    

00800fee <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801000:	eb 2a                	jmp    80102c <memcmp+0x3e>
		if (*s1 != *s2)
  801002:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801005:	8a 10                	mov    (%eax),%dl
  801007:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	38 c2                	cmp    %al,%dl
  80100e:	74 16                	je     801026 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801010:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	0f b6 d0             	movzbl %al,%edx
  801018:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101b:	8a 00                	mov    (%eax),%al
  80101d:	0f b6 c0             	movzbl %al,%eax
  801020:	29 c2                	sub    %eax,%edx
  801022:	89 d0                	mov    %edx,%eax
  801024:	eb 18                	jmp    80103e <memcmp+0x50>
		s1++, s2++;
  801026:	ff 45 fc             	incl   -0x4(%ebp)
  801029:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80102c:	8b 45 10             	mov    0x10(%ebp),%eax
  80102f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801032:	89 55 10             	mov    %edx,0x10(%ebp)
  801035:	85 c0                	test   %eax,%eax
  801037:	75 c9                	jne    801002 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801039:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80103e:	c9                   	leave  
  80103f:	c3                   	ret    

00801040 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
  801043:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801046:	8b 55 08             	mov    0x8(%ebp),%edx
  801049:	8b 45 10             	mov    0x10(%ebp),%eax
  80104c:	01 d0                	add    %edx,%eax
  80104e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801051:	eb 15                	jmp    801068 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	0f b6 d0             	movzbl %al,%edx
  80105b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105e:	0f b6 c0             	movzbl %al,%eax
  801061:	39 c2                	cmp    %eax,%edx
  801063:	74 0d                	je     801072 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801065:	ff 45 08             	incl   0x8(%ebp)
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
  80106b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80106e:	72 e3                	jb     801053 <memfind+0x13>
  801070:	eb 01                	jmp    801073 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801072:	90                   	nop
	return (void *) s;
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801076:	c9                   	leave  
  801077:	c3                   	ret    

00801078 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
  80107b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80107e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801085:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80108c:	eb 03                	jmp    801091 <strtol+0x19>
		s++;
  80108e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	8a 00                	mov    (%eax),%al
  801096:	3c 20                	cmp    $0x20,%al
  801098:	74 f4                	je     80108e <strtol+0x16>
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	8a 00                	mov    (%eax),%al
  80109f:	3c 09                	cmp    $0x9,%al
  8010a1:	74 eb                	je     80108e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	8a 00                	mov    (%eax),%al
  8010a8:	3c 2b                	cmp    $0x2b,%al
  8010aa:	75 05                	jne    8010b1 <strtol+0x39>
		s++;
  8010ac:	ff 45 08             	incl   0x8(%ebp)
  8010af:	eb 13                	jmp    8010c4 <strtol+0x4c>
	else if (*s == '-')
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	8a 00                	mov    (%eax),%al
  8010b6:	3c 2d                	cmp    $0x2d,%al
  8010b8:	75 0a                	jne    8010c4 <strtol+0x4c>
		s++, neg = 1;
  8010ba:	ff 45 08             	incl   0x8(%ebp)
  8010bd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010c8:	74 06                	je     8010d0 <strtol+0x58>
  8010ca:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010ce:	75 20                	jne    8010f0 <strtol+0x78>
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	3c 30                	cmp    $0x30,%al
  8010d7:	75 17                	jne    8010f0 <strtol+0x78>
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	40                   	inc    %eax
  8010dd:	8a 00                	mov    (%eax),%al
  8010df:	3c 78                	cmp    $0x78,%al
  8010e1:	75 0d                	jne    8010f0 <strtol+0x78>
		s += 2, base = 16;
  8010e3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010e7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010ee:	eb 28                	jmp    801118 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f4:	75 15                	jne    80110b <strtol+0x93>
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	3c 30                	cmp    $0x30,%al
  8010fd:	75 0c                	jne    80110b <strtol+0x93>
		s++, base = 8;
  8010ff:	ff 45 08             	incl   0x8(%ebp)
  801102:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801109:	eb 0d                	jmp    801118 <strtol+0xa0>
	else if (base == 0)
  80110b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110f:	75 07                	jne    801118 <strtol+0xa0>
		base = 10;
  801111:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	8a 00                	mov    (%eax),%al
  80111d:	3c 2f                	cmp    $0x2f,%al
  80111f:	7e 19                	jle    80113a <strtol+0xc2>
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	8a 00                	mov    (%eax),%al
  801126:	3c 39                	cmp    $0x39,%al
  801128:	7f 10                	jg     80113a <strtol+0xc2>
			dig = *s - '0';
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	0f be c0             	movsbl %al,%eax
  801132:	83 e8 30             	sub    $0x30,%eax
  801135:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801138:	eb 42                	jmp    80117c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	8a 00                	mov    (%eax),%al
  80113f:	3c 60                	cmp    $0x60,%al
  801141:	7e 19                	jle    80115c <strtol+0xe4>
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	8a 00                	mov    (%eax),%al
  801148:	3c 7a                	cmp    $0x7a,%al
  80114a:	7f 10                	jg     80115c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	0f be c0             	movsbl %al,%eax
  801154:	83 e8 57             	sub    $0x57,%eax
  801157:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80115a:	eb 20                	jmp    80117c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	8a 00                	mov    (%eax),%al
  801161:	3c 40                	cmp    $0x40,%al
  801163:	7e 39                	jle    80119e <strtol+0x126>
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	8a 00                	mov    (%eax),%al
  80116a:	3c 5a                	cmp    $0x5a,%al
  80116c:	7f 30                	jg     80119e <strtol+0x126>
			dig = *s - 'A' + 10;
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	0f be c0             	movsbl %al,%eax
  801176:	83 e8 37             	sub    $0x37,%eax
  801179:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80117c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80117f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801182:	7d 19                	jge    80119d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801184:	ff 45 08             	incl   0x8(%ebp)
  801187:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80118e:	89 c2                	mov    %eax,%edx
  801190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801193:	01 d0                	add    %edx,%eax
  801195:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801198:	e9 7b ff ff ff       	jmp    801118 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80119d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80119e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011a2:	74 08                	je     8011ac <strtol+0x134>
		*endptr = (char *) s;
  8011a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011aa:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011b0:	74 07                	je     8011b9 <strtol+0x141>
  8011b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b5:	f7 d8                	neg    %eax
  8011b7:	eb 03                	jmp    8011bc <strtol+0x144>
  8011b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011bc:	c9                   	leave  
  8011bd:	c3                   	ret    

008011be <ltostr>:

void
ltostr(long value, char *str)
{
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
  8011c1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d6:	79 13                	jns    8011eb <ltostr+0x2d>
	{
		neg = 1;
  8011d8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011e5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011e8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ee:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011f3:	99                   	cltd   
  8011f4:	f7 f9                	idiv   %ecx
  8011f6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011fc:	8d 50 01             	lea    0x1(%eax),%edx
  8011ff:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801202:	89 c2                	mov    %eax,%edx
  801204:	8b 45 0c             	mov    0xc(%ebp),%eax
  801207:	01 d0                	add    %edx,%eax
  801209:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80120c:	83 c2 30             	add    $0x30,%edx
  80120f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801211:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801214:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801219:	f7 e9                	imul   %ecx
  80121b:	c1 fa 02             	sar    $0x2,%edx
  80121e:	89 c8                	mov    %ecx,%eax
  801220:	c1 f8 1f             	sar    $0x1f,%eax
  801223:	29 c2                	sub    %eax,%edx
  801225:	89 d0                	mov    %edx,%eax
  801227:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80122a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80122e:	75 bb                	jne    8011eb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801230:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801237:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80123a:	48                   	dec    %eax
  80123b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80123e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801242:	74 3d                	je     801281 <ltostr+0xc3>
		start = 1 ;
  801244:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80124b:	eb 34                	jmp    801281 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80124d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801250:	8b 45 0c             	mov    0xc(%ebp),%eax
  801253:	01 d0                	add    %edx,%eax
  801255:	8a 00                	mov    (%eax),%al
  801257:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80125a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80125d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801260:	01 c2                	add    %eax,%edx
  801262:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801265:	8b 45 0c             	mov    0xc(%ebp),%eax
  801268:	01 c8                	add    %ecx,%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80126e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801271:	8b 45 0c             	mov    0xc(%ebp),%eax
  801274:	01 c2                	add    %eax,%edx
  801276:	8a 45 eb             	mov    -0x15(%ebp),%al
  801279:	88 02                	mov    %al,(%edx)
		start++ ;
  80127b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80127e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801284:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801287:	7c c4                	jl     80124d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801289:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80128c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128f:	01 d0                	add    %edx,%eax
  801291:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801294:	90                   	nop
  801295:	c9                   	leave  
  801296:	c3                   	ret    

00801297 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
  80129a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80129d:	ff 75 08             	pushl  0x8(%ebp)
  8012a0:	e8 c4 f9 ff ff       	call   800c69 <strlen>
  8012a5:	83 c4 04             	add    $0x4,%esp
  8012a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012ab:	ff 75 0c             	pushl  0xc(%ebp)
  8012ae:	e8 b6 f9 ff ff       	call   800c69 <strlen>
  8012b3:	83 c4 04             	add    $0x4,%esp
  8012b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012c7:	eb 17                	jmp    8012e0 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cf:	01 c2                	add    %eax,%edx
  8012d1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	01 c8                	add    %ecx,%eax
  8012d9:	8a 00                	mov    (%eax),%al
  8012db:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012dd:	ff 45 fc             	incl   -0x4(%ebp)
  8012e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012e6:	7c e1                	jl     8012c9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012e8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012ef:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012f6:	eb 1f                	jmp    801317 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012fb:	8d 50 01             	lea    0x1(%eax),%edx
  8012fe:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801301:	89 c2                	mov    %eax,%edx
  801303:	8b 45 10             	mov    0x10(%ebp),%eax
  801306:	01 c2                	add    %eax,%edx
  801308:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80130b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130e:	01 c8                	add    %ecx,%eax
  801310:	8a 00                	mov    (%eax),%al
  801312:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801314:	ff 45 f8             	incl   -0x8(%ebp)
  801317:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80131d:	7c d9                	jl     8012f8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80131f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801322:	8b 45 10             	mov    0x10(%ebp),%eax
  801325:	01 d0                	add    %edx,%eax
  801327:	c6 00 00             	movb   $0x0,(%eax)
}
  80132a:	90                   	nop
  80132b:	c9                   	leave  
  80132c:	c3                   	ret    

0080132d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801330:	8b 45 14             	mov    0x14(%ebp),%eax
  801333:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801339:	8b 45 14             	mov    0x14(%ebp),%eax
  80133c:	8b 00                	mov    (%eax),%eax
  80133e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801345:	8b 45 10             	mov    0x10(%ebp),%eax
  801348:	01 d0                	add    %edx,%eax
  80134a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801350:	eb 0c                	jmp    80135e <strsplit+0x31>
			*string++ = 0;
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8d 50 01             	lea    0x1(%eax),%edx
  801358:	89 55 08             	mov    %edx,0x8(%ebp)
  80135b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	8a 00                	mov    (%eax),%al
  801363:	84 c0                	test   %al,%al
  801365:	74 18                	je     80137f <strsplit+0x52>
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	0f be c0             	movsbl %al,%eax
  80136f:	50                   	push   %eax
  801370:	ff 75 0c             	pushl  0xc(%ebp)
  801373:	e8 83 fa ff ff       	call   800dfb <strchr>
  801378:	83 c4 08             	add    $0x8,%esp
  80137b:	85 c0                	test   %eax,%eax
  80137d:	75 d3                	jne    801352 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	8a 00                	mov    (%eax),%al
  801384:	84 c0                	test   %al,%al
  801386:	74 5a                	je     8013e2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801388:	8b 45 14             	mov    0x14(%ebp),%eax
  80138b:	8b 00                	mov    (%eax),%eax
  80138d:	83 f8 0f             	cmp    $0xf,%eax
  801390:	75 07                	jne    801399 <strsplit+0x6c>
		{
			return 0;
  801392:	b8 00 00 00 00       	mov    $0x0,%eax
  801397:	eb 66                	jmp    8013ff <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801399:	8b 45 14             	mov    0x14(%ebp),%eax
  80139c:	8b 00                	mov    (%eax),%eax
  80139e:	8d 48 01             	lea    0x1(%eax),%ecx
  8013a1:	8b 55 14             	mov    0x14(%ebp),%edx
  8013a4:	89 0a                	mov    %ecx,(%edx)
  8013a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b0:	01 c2                	add    %eax,%edx
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013b7:	eb 03                	jmp    8013bc <strsplit+0x8f>
			string++;
  8013b9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bf:	8a 00                	mov    (%eax),%al
  8013c1:	84 c0                	test   %al,%al
  8013c3:	74 8b                	je     801350 <strsplit+0x23>
  8013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c8:	8a 00                	mov    (%eax),%al
  8013ca:	0f be c0             	movsbl %al,%eax
  8013cd:	50                   	push   %eax
  8013ce:	ff 75 0c             	pushl  0xc(%ebp)
  8013d1:	e8 25 fa ff ff       	call   800dfb <strchr>
  8013d6:	83 c4 08             	add    $0x8,%esp
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	74 dc                	je     8013b9 <strsplit+0x8c>
			string++;
	}
  8013dd:	e9 6e ff ff ff       	jmp    801350 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013e2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e6:	8b 00                	mov    (%eax),%eax
  8013e8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f2:	01 d0                	add    %edx,%eax
  8013f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013fa:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013ff:	c9                   	leave  
  801400:	c3                   	ret    

00801401 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801401:	55                   	push   %ebp
  801402:	89 e5                	mov    %esp,%ebp
  801404:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801407:	8b 45 08             	mov    0x8(%ebp),%eax
  80140a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80140d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801414:	eb 4a                	jmp    801460 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801416:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801419:	8b 45 08             	mov    0x8(%ebp),%eax
  80141c:	01 c2                	add    %eax,%edx
  80141e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801421:	8b 45 0c             	mov    0xc(%ebp),%eax
  801424:	01 c8                	add    %ecx,%eax
  801426:	8a 00                	mov    (%eax),%al
  801428:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80142a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80142d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801430:	01 d0                	add    %edx,%eax
  801432:	8a 00                	mov    (%eax),%al
  801434:	3c 40                	cmp    $0x40,%al
  801436:	7e 25                	jle    80145d <str2lower+0x5c>
  801438:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80143b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143e:	01 d0                	add    %edx,%eax
  801440:	8a 00                	mov    (%eax),%al
  801442:	3c 5a                	cmp    $0x5a,%al
  801444:	7f 17                	jg     80145d <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801446:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	01 d0                	add    %edx,%eax
  80144e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801451:	8b 55 08             	mov    0x8(%ebp),%edx
  801454:	01 ca                	add    %ecx,%edx
  801456:	8a 12                	mov    (%edx),%dl
  801458:	83 c2 20             	add    $0x20,%edx
  80145b:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80145d:	ff 45 fc             	incl   -0x4(%ebp)
  801460:	ff 75 0c             	pushl  0xc(%ebp)
  801463:	e8 01 f8 ff ff       	call   800c69 <strlen>
  801468:	83 c4 04             	add    $0x4,%esp
  80146b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80146e:	7f a6                	jg     801416 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801470:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801473:	c9                   	leave  
  801474:	c3                   	ret    

00801475 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
  801478:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80147b:	a1 08 30 80 00       	mov    0x803008,%eax
  801480:	85 c0                	test   %eax,%eax
  801482:	74 42                	je     8014c6 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801484:	83 ec 08             	sub    $0x8,%esp
  801487:	68 00 00 00 82       	push   $0x82000000
  80148c:	68 00 00 00 80       	push   $0x80000000
  801491:	e8 8c 07 00 00       	call   801c22 <initialize_dynamic_allocator>
  801496:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801499:	e8 e7 05 00 00       	call   801a85 <sys_get_uheap_strategy>
  80149e:	a3 60 b0 81 00       	mov    %eax,0x81b060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8014a3:	a1 40 30 80 00       	mov    0x803040,%eax
  8014a8:	05 00 10 00 00       	add    $0x1000,%eax
  8014ad:	a3 10 b1 81 00       	mov    %eax,0x81b110
		uheapPageAllocBreak = uheapPageAllocStart;
  8014b2:	a1 10 b1 81 00       	mov    0x81b110,%eax
  8014b7:	a3 68 b0 81 00       	mov    %eax,0x81b068

		__firstTimeFlag = 0;
  8014bc:	c7 05 08 30 80 00 00 	movl   $0x0,0x803008
  8014c3:	00 00 00 
	}
}
  8014c6:	90                   	nop
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    

008014c9 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014dd:	83 ec 08             	sub    $0x8,%esp
  8014e0:	68 06 04 00 00       	push   $0x406
  8014e5:	50                   	push   %eax
  8014e6:	e8 e4 01 00 00       	call   8016cf <__sys_allocate_page>
  8014eb:	83 c4 10             	add    $0x10,%esp
  8014ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8014f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014f5:	79 14                	jns    80150b <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8014f7:	83 ec 04             	sub    $0x4,%esp
  8014fa:	68 e8 26 80 00       	push   $0x8026e8
  8014ff:	6a 1f                	push   $0x1f
  801501:	68 24 27 80 00       	push   $0x802724
  801506:	e8 b7 ed ff ff       	call   8002c2 <_panic>
	return 0;
  80150b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
  801515:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801518:	8b 45 08             	mov    0x8(%ebp),%eax
  80151b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80151e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801521:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801526:	83 ec 0c             	sub    $0xc,%esp
  801529:	50                   	push   %eax
  80152a:	e8 e7 01 00 00       	call   801716 <__sys_unmap_frame>
  80152f:	83 c4 10             	add    $0x10,%esp
  801532:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801535:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801539:	79 14                	jns    80154f <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  80153b:	83 ec 04             	sub    $0x4,%esp
  80153e:	68 30 27 80 00       	push   $0x802730
  801543:	6a 2a                	push   $0x2a
  801545:	68 24 27 80 00       	push   $0x802724
  80154a:	e8 73 ed ff ff       	call   8002c2 <_panic>
}
  80154f:	90                   	nop
  801550:	c9                   	leave  
  801551:	c3                   	ret    

00801552 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801552:	55                   	push   %ebp
  801553:	89 e5                	mov    %esp,%ebp
  801555:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801558:	e8 18 ff ff ff       	call   801475 <uheap_init>
	if (size == 0) return NULL ;
  80155d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801561:	75 07                	jne    80156a <malloc+0x18>
  801563:	b8 00 00 00 00       	mov    $0x0,%eax
  801568:	eb 14                	jmp    80157e <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  80156a:	83 ec 04             	sub    $0x4,%esp
  80156d:	68 70 27 80 00       	push   $0x802770
  801572:	6a 3e                	push   $0x3e
  801574:	68 24 27 80 00       	push   $0x802724
  801579:	e8 44 ed ff ff       	call   8002c2 <_panic>
}
  80157e:	c9                   	leave  
  80157f:	c3                   	ret    

00801580 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
  801583:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801586:	83 ec 04             	sub    $0x4,%esp
  801589:	68 98 27 80 00       	push   $0x802798
  80158e:	6a 49                	push   $0x49
  801590:	68 24 27 80 00       	push   $0x802724
  801595:	e8 28 ed ff ff       	call   8002c2 <_panic>

0080159a <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80159a:	55                   	push   %ebp
  80159b:	89 e5                	mov    %esp,%ebp
  80159d:	83 ec 18             	sub    $0x18,%esp
  8015a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a3:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8015a6:	e8 ca fe ff ff       	call   801475 <uheap_init>
	if (size == 0) return NULL ;
  8015ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015af:	75 07                	jne    8015b8 <smalloc+0x1e>
  8015b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b6:	eb 14                	jmp    8015cc <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  8015b8:	83 ec 04             	sub    $0x4,%esp
  8015bb:	68 bc 27 80 00       	push   $0x8027bc
  8015c0:	6a 5a                	push   $0x5a
  8015c2:	68 24 27 80 00       	push   $0x802724
  8015c7:	e8 f6 ec ff ff       	call   8002c2 <_panic>
}
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8015d4:	e8 9c fe ff ff       	call   801475 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  8015d9:	83 ec 04             	sub    $0x4,%esp
  8015dc:	68 e4 27 80 00       	push   $0x8027e4
  8015e1:	6a 6a                	push   $0x6a
  8015e3:	68 24 27 80 00       	push   $0x802724
  8015e8:	e8 d5 ec ff ff       	call   8002c2 <_panic>

008015ed <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8015f3:	e8 7d fe ff ff       	call   801475 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8015f8:	83 ec 04             	sub    $0x4,%esp
  8015fb:	68 08 28 80 00       	push   $0x802808
  801600:	68 88 00 00 00       	push   $0x88
  801605:	68 24 27 80 00       	push   $0x802724
  80160a:	e8 b3 ec ff ff       	call   8002c2 <_panic>

0080160f <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
  801612:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801615:	83 ec 04             	sub    $0x4,%esp
  801618:	68 30 28 80 00       	push   $0x802830
  80161d:	68 9b 00 00 00       	push   $0x9b
  801622:	68 24 27 80 00       	push   $0x802724
  801627:	e8 96 ec ff ff       	call   8002c2 <_panic>

0080162c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	57                   	push   %edi
  801630:	56                   	push   %esi
  801631:	53                   	push   %ebx
  801632:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80163e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801641:	8b 7d 18             	mov    0x18(%ebp),%edi
  801644:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801647:	cd 30                	int    $0x30
  801649:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80164c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80164f:	83 c4 10             	add    $0x10,%esp
  801652:	5b                   	pop    %ebx
  801653:	5e                   	pop    %esi
  801654:	5f                   	pop    %edi
  801655:	5d                   	pop    %ebp
  801656:	c3                   	ret    

00801657 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	83 ec 04             	sub    $0x4,%esp
  80165d:	8b 45 10             	mov    0x10(%ebp),%eax
  801660:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801663:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801666:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	6a 00                	push   $0x0
  80166f:	51                   	push   %ecx
  801670:	52                   	push   %edx
  801671:	ff 75 0c             	pushl  0xc(%ebp)
  801674:	50                   	push   %eax
  801675:	6a 00                	push   $0x0
  801677:	e8 b0 ff ff ff       	call   80162c <syscall>
  80167c:	83 c4 18             	add    $0x18,%esp
}
  80167f:	90                   	nop
  801680:	c9                   	leave  
  801681:	c3                   	ret    

00801682 <sys_cgetc>:

int
sys_cgetc(void)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 02                	push   $0x2
  801691:	e8 96 ff ff ff       	call   80162c <syscall>
  801696:	83 c4 18             	add    $0x18,%esp
}
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <sys_lock_cons>:

void sys_lock_cons(void)
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 03                	push   $0x3
  8016aa:	e8 7d ff ff ff       	call   80162c <syscall>
  8016af:	83 c4 18             	add    $0x18,%esp
}
  8016b2:	90                   	nop
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 04                	push   $0x4
  8016c4:	e8 63 ff ff ff       	call   80162c <syscall>
  8016c9:	83 c4 18             	add    $0x18,%esp
}
  8016cc:	90                   	nop
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	52                   	push   %edx
  8016df:	50                   	push   %eax
  8016e0:	6a 08                	push   $0x8
  8016e2:	e8 45 ff ff ff       	call   80162c <syscall>
  8016e7:	83 c4 18             	add    $0x18,%esp
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
  8016ef:	56                   	push   %esi
  8016f0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016f1:	8b 75 18             	mov    0x18(%ebp),%esi
  8016f4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	56                   	push   %esi
  801701:	53                   	push   %ebx
  801702:	51                   	push   %ecx
  801703:	52                   	push   %edx
  801704:	50                   	push   %eax
  801705:	6a 09                	push   $0x9
  801707:	e8 20 ff ff ff       	call   80162c <syscall>
  80170c:	83 c4 18             	add    $0x18,%esp
}
  80170f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801712:	5b                   	pop    %ebx
  801713:	5e                   	pop    %esi
  801714:	5d                   	pop    %ebp
  801715:	c3                   	ret    

00801716 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	ff 75 08             	pushl  0x8(%ebp)
  801724:	6a 0a                	push   $0xa
  801726:	e8 01 ff ff ff       	call   80162c <syscall>
  80172b:	83 c4 18             	add    $0x18,%esp
}
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	ff 75 0c             	pushl  0xc(%ebp)
  80173c:	ff 75 08             	pushl  0x8(%ebp)
  80173f:	6a 0b                	push   $0xb
  801741:	e8 e6 fe ff ff       	call   80162c <syscall>
  801746:	83 c4 18             	add    $0x18,%esp
}
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 0c                	push   $0xc
  80175a:	e8 cd fe ff ff       	call   80162c <syscall>
  80175f:	83 c4 18             	add    $0x18,%esp
}
  801762:	c9                   	leave  
  801763:	c3                   	ret    

00801764 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 0d                	push   $0xd
  801773:	e8 b4 fe ff ff       	call   80162c <syscall>
  801778:	83 c4 18             	add    $0x18,%esp
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 0e                	push   $0xe
  80178c:	e8 9b fe ff ff       	call   80162c <syscall>
  801791:	83 c4 18             	add    $0x18,%esp
}
  801794:	c9                   	leave  
  801795:	c3                   	ret    

00801796 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 0f                	push   $0xf
  8017a5:	e8 82 fe ff ff       	call   80162c <syscall>
  8017aa:	83 c4 18             	add    $0x18,%esp
}
  8017ad:	c9                   	leave  
  8017ae:	c3                   	ret    

008017af <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	ff 75 08             	pushl  0x8(%ebp)
  8017bd:	6a 10                	push   $0x10
  8017bf:	e8 68 fe ff ff       	call   80162c <syscall>
  8017c4:	83 c4 18             	add    $0x18,%esp
}
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    

008017c9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 11                	push   $0x11
  8017d8:	e8 4f fe ff ff       	call   80162c <syscall>
  8017dd:	83 c4 18             	add    $0x18,%esp
}
  8017e0:	90                   	nop
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    

008017e3 <sys_cputc>:

void
sys_cputc(const char c)
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
  8017e6:	83 ec 04             	sub    $0x4,%esp
  8017e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017ef:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	50                   	push   %eax
  8017fc:	6a 01                	push   $0x1
  8017fe:	e8 29 fe ff ff       	call   80162c <syscall>
  801803:	83 c4 18             	add    $0x18,%esp
}
  801806:	90                   	nop
  801807:	c9                   	leave  
  801808:	c3                   	ret    

00801809 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 14                	push   $0x14
  801818:	e8 0f fe ff ff       	call   80162c <syscall>
  80181d:	83 c4 18             	add    $0x18,%esp
}
  801820:	90                   	nop
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	83 ec 04             	sub    $0x4,%esp
  801829:	8b 45 10             	mov    0x10(%ebp),%eax
  80182c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80182f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801832:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
  801839:	6a 00                	push   $0x0
  80183b:	51                   	push   %ecx
  80183c:	52                   	push   %edx
  80183d:	ff 75 0c             	pushl  0xc(%ebp)
  801840:	50                   	push   %eax
  801841:	6a 15                	push   $0x15
  801843:	e8 e4 fd ff ff       	call   80162c <syscall>
  801848:	83 c4 18             	add    $0x18,%esp
}
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801850:	8b 55 0c             	mov    0xc(%ebp),%edx
  801853:	8b 45 08             	mov    0x8(%ebp),%eax
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	52                   	push   %edx
  80185d:	50                   	push   %eax
  80185e:	6a 16                	push   $0x16
  801860:	e8 c7 fd ff ff       	call   80162c <syscall>
  801865:	83 c4 18             	add    $0x18,%esp
}
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80186d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801870:	8b 55 0c             	mov    0xc(%ebp),%edx
  801873:	8b 45 08             	mov    0x8(%ebp),%eax
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	51                   	push   %ecx
  80187b:	52                   	push   %edx
  80187c:	50                   	push   %eax
  80187d:	6a 17                	push   $0x17
  80187f:	e8 a8 fd ff ff       	call   80162c <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80188c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188f:	8b 45 08             	mov    0x8(%ebp),%eax
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	52                   	push   %edx
  801899:	50                   	push   %eax
  80189a:	6a 18                	push   $0x18
  80189c:	e8 8b fd ff ff       	call   80162c <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	6a 00                	push   $0x0
  8018ae:	ff 75 14             	pushl  0x14(%ebp)
  8018b1:	ff 75 10             	pushl  0x10(%ebp)
  8018b4:	ff 75 0c             	pushl  0xc(%ebp)
  8018b7:	50                   	push   %eax
  8018b8:	6a 19                	push   $0x19
  8018ba:	e8 6d fd ff ff       	call   80162c <syscall>
  8018bf:	83 c4 18             	add    $0x18,%esp
}
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	50                   	push   %eax
  8018d3:	6a 1a                	push   $0x1a
  8018d5:	e8 52 fd ff ff       	call   80162c <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
}
  8018dd:	90                   	nop
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	50                   	push   %eax
  8018ef:	6a 1b                	push   $0x1b
  8018f1:	e8 36 fd ff ff       	call   80162c <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 05                	push   $0x5
  80190a:	e8 1d fd ff ff       	call   80162c <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 06                	push   $0x6
  801923:	e8 04 fd ff ff       	call   80162c <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
}
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 07                	push   $0x7
  80193c:	e8 eb fc ff ff       	call   80162c <syscall>
  801941:	83 c4 18             	add    $0x18,%esp
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_exit_env>:


void sys_exit_env(void)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 1c                	push   $0x1c
  801955:	e8 d2 fc ff ff       	call   80162c <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
}
  80195d:	90                   	nop
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801966:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801969:	8d 50 04             	lea    0x4(%eax),%edx
  80196c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	52                   	push   %edx
  801976:	50                   	push   %eax
  801977:	6a 1d                	push   $0x1d
  801979:	e8 ae fc ff ff       	call   80162c <syscall>
  80197e:	83 c4 18             	add    $0x18,%esp
	return result;
  801981:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801984:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801987:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80198a:	89 01                	mov    %eax,(%ecx)
  80198c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	c9                   	leave  
  801993:	c2 04 00             	ret    $0x4

00801996 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	ff 75 10             	pushl  0x10(%ebp)
  8019a0:	ff 75 0c             	pushl  0xc(%ebp)
  8019a3:	ff 75 08             	pushl  0x8(%ebp)
  8019a6:	6a 13                	push   $0x13
  8019a8:	e8 7f fc ff ff       	call   80162c <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b0:	90                   	nop
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 1e                	push   $0x1e
  8019c2:	e8 65 fc ff ff       	call   80162c <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	83 ec 04             	sub    $0x4,%esp
  8019d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019d8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	50                   	push   %eax
  8019e5:	6a 1f                	push   $0x1f
  8019e7:	e8 40 fc ff ff       	call   80162c <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ef:	90                   	nop
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <rsttst>:
void rsttst()
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 21                	push   $0x21
  801a01:	e8 26 fc ff ff       	call   80162c <syscall>
  801a06:	83 c4 18             	add    $0x18,%esp
	return ;
  801a09:	90                   	nop
}
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
  801a0f:	83 ec 04             	sub    $0x4,%esp
  801a12:	8b 45 14             	mov    0x14(%ebp),%eax
  801a15:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a18:	8b 55 18             	mov    0x18(%ebp),%edx
  801a1b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a1f:	52                   	push   %edx
  801a20:	50                   	push   %eax
  801a21:	ff 75 10             	pushl  0x10(%ebp)
  801a24:	ff 75 0c             	pushl  0xc(%ebp)
  801a27:	ff 75 08             	pushl  0x8(%ebp)
  801a2a:	6a 20                	push   $0x20
  801a2c:	e8 fb fb ff ff       	call   80162c <syscall>
  801a31:	83 c4 18             	add    $0x18,%esp
	return ;
  801a34:	90                   	nop
}
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <chktst>:
void chktst(uint32 n)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	ff 75 08             	pushl  0x8(%ebp)
  801a45:	6a 22                	push   $0x22
  801a47:	e8 e0 fb ff ff       	call   80162c <syscall>
  801a4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a4f:	90                   	nop
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <inctst>:

void inctst()
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 23                	push   $0x23
  801a61:	e8 c6 fb ff ff       	call   80162c <syscall>
  801a66:	83 c4 18             	add    $0x18,%esp
	return ;
  801a69:	90                   	nop
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <gettst>:
uint32 gettst()
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 24                	push   $0x24
  801a7b:	e8 ac fb ff ff       	call   80162c <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 25                	push   $0x25
  801a94:	e8 93 fb ff ff       	call   80162c <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
  801a9c:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801aa1:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801aa6:	c9                   	leave  
  801aa7:	c3                   	ret    

00801aa8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	ff 75 08             	pushl  0x8(%ebp)
  801abe:	6a 26                	push   $0x26
  801ac0:	e8 67 fb ff ff       	call   80162c <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac8:	90                   	nop
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
  801ace:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801acf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ad2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ad5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  801adb:	6a 00                	push   $0x0
  801add:	53                   	push   %ebx
  801ade:	51                   	push   %ecx
  801adf:	52                   	push   %edx
  801ae0:	50                   	push   %eax
  801ae1:	6a 27                	push   $0x27
  801ae3:	e8 44 fb ff ff       	call   80162c <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
}
  801aeb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801af3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	52                   	push   %edx
  801b00:	50                   	push   %eax
  801b01:	6a 28                	push   $0x28
  801b03:	e8 24 fb ff ff       	call   80162c <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b10:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b16:	8b 45 08             	mov    0x8(%ebp),%eax
  801b19:	6a 00                	push   $0x0
  801b1b:	51                   	push   %ecx
  801b1c:	ff 75 10             	pushl  0x10(%ebp)
  801b1f:	52                   	push   %edx
  801b20:	50                   	push   %eax
  801b21:	6a 29                	push   $0x29
  801b23:	e8 04 fb ff ff       	call   80162c <syscall>
  801b28:	83 c4 18             	add    $0x18,%esp
}
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	ff 75 10             	pushl  0x10(%ebp)
  801b37:	ff 75 0c             	pushl  0xc(%ebp)
  801b3a:	ff 75 08             	pushl  0x8(%ebp)
  801b3d:	6a 12                	push   $0x12
  801b3f:	e8 e8 fa ff ff       	call   80162c <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
	return ;
  801b47:	90                   	nop
}
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	52                   	push   %edx
  801b5a:	50                   	push   %eax
  801b5b:	6a 2a                	push   $0x2a
  801b5d:	e8 ca fa ff ff       	call   80162c <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
	return;
  801b65:	90                   	nop
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 2b                	push   $0x2b
  801b77:	e8 b0 fa ff ff       	call   80162c <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	ff 75 0c             	pushl  0xc(%ebp)
  801b8d:	ff 75 08             	pushl  0x8(%ebp)
  801b90:	6a 2d                	push   $0x2d
  801b92:	e8 95 fa ff ff       	call   80162c <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
	return;
  801b9a:	90                   	nop
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	ff 75 0c             	pushl  0xc(%ebp)
  801ba9:	ff 75 08             	pushl  0x8(%ebp)
  801bac:	6a 2c                	push   $0x2c
  801bae:	e8 79 fa ff ff       	call   80162c <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb6:	90                   	nop
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
  801bbc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801bbf:	83 ec 04             	sub    $0x4,%esp
  801bc2:	68 54 28 80 00       	push   $0x802854
  801bc7:	68 25 01 00 00       	push   $0x125
  801bcc:	68 87 28 80 00       	push   $0x802887
  801bd1:	e8 ec e6 ff ff       	call   8002c2 <_panic>

00801bd6 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdf:	ba 60 30 80 00       	mov    $0x803060,%edx
  801be4:	29 d0                	sub    %edx,%eax
  801be6:	c1 f8 02             	sar    $0x2,%eax
  801be9:	89 c2                	mov    %eax,%edx
  801beb:	89 d0                	mov    %edx,%eax
  801bed:	c1 e0 02             	shl    $0x2,%eax
  801bf0:	01 d0                	add    %edx,%eax
  801bf2:	c1 e0 02             	shl    $0x2,%eax
  801bf5:	01 d0                	add    %edx,%eax
  801bf7:	c1 e0 02             	shl    $0x2,%eax
  801bfa:	01 d0                	add    %edx,%eax
  801bfc:	89 c1                	mov    %eax,%ecx
  801bfe:	c1 e1 08             	shl    $0x8,%ecx
  801c01:	01 c8                	add    %ecx,%eax
  801c03:	89 c1                	mov    %eax,%ecx
  801c05:	c1 e1 10             	shl    $0x10,%ecx
  801c08:	01 c8                	add    %ecx,%eax
  801c0a:	01 c0                	add    %eax,%eax
  801c0c:	01 d0                	add    %edx,%eax
  801c0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801c11:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c14:	c1 e0 0c             	shl    $0xc,%eax
  801c17:	89 c2                	mov    %eax,%edx
  801c19:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801c1e:	01 d0                	add    %edx,%eax
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801c28:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2b:	05 00 00 00 02       	add    $0x2000000,%eax
  801c30:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801c33:	73 16                	jae    801c4b <initialize_dynamic_allocator+0x29>
  801c35:	68 98 28 80 00       	push   $0x802898
  801c3a:	68 be 28 80 00       	push   $0x8028be
  801c3f:	6a 26                	push   $0x26
  801c41:	68 d3 28 80 00       	push   $0x8028d3
  801c46:	e8 77 e6 ff ff       	call   8002c2 <_panic>
		is_initialized = 1;
  801c4b:	c7 05 24 30 80 00 01 	movl   $0x1,0x803024
  801c52:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  801c55:	83 ec 04             	sub    $0x4,%esp
  801c58:	68 ec 28 80 00       	push   $0x8028ec
  801c5d:	6a 2e                	push   $0x2e
  801c5f:	68 d3 28 80 00       	push   $0x8028d3
  801c64:	e8 59 e6 ff ff       	call   8002c2 <_panic>

00801c69 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
  801c6c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  801c6f:	83 ec 04             	sub    $0x4,%esp
  801c72:	68 20 29 80 00       	push   $0x802920
  801c77:	6a 3a                	push   $0x3a
  801c79:	68 d3 28 80 00       	push   $0x8028d3
  801c7e:	e8 3f e6 ff ff       	call   8002c2 <_panic>

00801c83 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801c89:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801c90:	76 16                	jbe    801ca8 <alloc_block+0x25>
  801c92:	68 48 29 80 00       	push   $0x802948
  801c97:	68 be 28 80 00       	push   $0x8028be
  801c9c:	6a 46                	push   $0x46
  801c9e:	68 d3 28 80 00       	push   $0x8028d3
  801ca3:	e8 1a e6 ff ff       	call   8002c2 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  801ca8:	83 ec 04             	sub    $0x4,%esp
  801cab:	68 6c 29 80 00       	push   $0x80296c
  801cb0:	6a 4d                	push   $0x4d
  801cb2:	68 d3 28 80 00       	push   $0x8028d3
  801cb7:	e8 06 e6 ff ff       	call   8002c2 <_panic>

00801cbc <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  801cc2:	8b 55 08             	mov    0x8(%ebp),%edx
  801cc5:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801cca:	39 c2                	cmp    %eax,%edx
  801ccc:	72 0c                	jb     801cda <free_block+0x1e>
  801cce:	8b 55 08             	mov    0x8(%ebp),%edx
  801cd1:	a1 40 30 80 00       	mov    0x803040,%eax
  801cd6:	39 c2                	cmp    %eax,%edx
  801cd8:	72 16                	jb     801cf0 <free_block+0x34>
  801cda:	68 90 29 80 00       	push   $0x802990
  801cdf:	68 be 28 80 00       	push   $0x8028be
  801ce4:	6a 5b                	push   $0x5b
  801ce6:	68 d3 28 80 00       	push   $0x8028d3
  801ceb:	e8 d2 e5 ff ff       	call   8002c2 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  801cf0:	83 ec 04             	sub    $0x4,%esp
  801cf3:	68 c8 29 80 00       	push   $0x8029c8
  801cf8:	6a 63                	push   $0x63
  801cfa:	68 d3 28 80 00       	push   $0x8028d3
  801cff:	e8 be e5 ff ff       	call   8002c2 <_panic>

00801d04 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  801d0a:	83 ec 04             	sub    $0x4,%esp
  801d0d:	68 ec 29 80 00       	push   $0x8029ec
  801d12:	6a 72                	push   $0x72
  801d14:	68 d3 28 80 00       	push   $0x8028d3
  801d19:	e8 a4 e5 ff ff       	call   8002c2 <_panic>
  801d1e:	66 90                	xchg   %ax,%ax

00801d20 <__udivdi3>:
  801d20:	55                   	push   %ebp
  801d21:	57                   	push   %edi
  801d22:	56                   	push   %esi
  801d23:	53                   	push   %ebx
  801d24:	83 ec 1c             	sub    $0x1c,%esp
  801d27:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d2b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d33:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d37:	89 ca                	mov    %ecx,%edx
  801d39:	89 f8                	mov    %edi,%eax
  801d3b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d3f:	85 f6                	test   %esi,%esi
  801d41:	75 2d                	jne    801d70 <__udivdi3+0x50>
  801d43:	39 cf                	cmp    %ecx,%edi
  801d45:	77 65                	ja     801dac <__udivdi3+0x8c>
  801d47:	89 fd                	mov    %edi,%ebp
  801d49:	85 ff                	test   %edi,%edi
  801d4b:	75 0b                	jne    801d58 <__udivdi3+0x38>
  801d4d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d52:	31 d2                	xor    %edx,%edx
  801d54:	f7 f7                	div    %edi
  801d56:	89 c5                	mov    %eax,%ebp
  801d58:	31 d2                	xor    %edx,%edx
  801d5a:	89 c8                	mov    %ecx,%eax
  801d5c:	f7 f5                	div    %ebp
  801d5e:	89 c1                	mov    %eax,%ecx
  801d60:	89 d8                	mov    %ebx,%eax
  801d62:	f7 f5                	div    %ebp
  801d64:	89 cf                	mov    %ecx,%edi
  801d66:	89 fa                	mov    %edi,%edx
  801d68:	83 c4 1c             	add    $0x1c,%esp
  801d6b:	5b                   	pop    %ebx
  801d6c:	5e                   	pop    %esi
  801d6d:	5f                   	pop    %edi
  801d6e:	5d                   	pop    %ebp
  801d6f:	c3                   	ret    
  801d70:	39 ce                	cmp    %ecx,%esi
  801d72:	77 28                	ja     801d9c <__udivdi3+0x7c>
  801d74:	0f bd fe             	bsr    %esi,%edi
  801d77:	83 f7 1f             	xor    $0x1f,%edi
  801d7a:	75 40                	jne    801dbc <__udivdi3+0x9c>
  801d7c:	39 ce                	cmp    %ecx,%esi
  801d7e:	72 0a                	jb     801d8a <__udivdi3+0x6a>
  801d80:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801d84:	0f 87 9e 00 00 00    	ja     801e28 <__udivdi3+0x108>
  801d8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8f:	89 fa                	mov    %edi,%edx
  801d91:	83 c4 1c             	add    $0x1c,%esp
  801d94:	5b                   	pop    %ebx
  801d95:	5e                   	pop    %esi
  801d96:	5f                   	pop    %edi
  801d97:	5d                   	pop    %ebp
  801d98:	c3                   	ret    
  801d99:	8d 76 00             	lea    0x0(%esi),%esi
  801d9c:	31 ff                	xor    %edi,%edi
  801d9e:	31 c0                	xor    %eax,%eax
  801da0:	89 fa                	mov    %edi,%edx
  801da2:	83 c4 1c             	add    $0x1c,%esp
  801da5:	5b                   	pop    %ebx
  801da6:	5e                   	pop    %esi
  801da7:	5f                   	pop    %edi
  801da8:	5d                   	pop    %ebp
  801da9:	c3                   	ret    
  801daa:	66 90                	xchg   %ax,%ax
  801dac:	89 d8                	mov    %ebx,%eax
  801dae:	f7 f7                	div    %edi
  801db0:	31 ff                	xor    %edi,%edi
  801db2:	89 fa                	mov    %edi,%edx
  801db4:	83 c4 1c             	add    $0x1c,%esp
  801db7:	5b                   	pop    %ebx
  801db8:	5e                   	pop    %esi
  801db9:	5f                   	pop    %edi
  801dba:	5d                   	pop    %ebp
  801dbb:	c3                   	ret    
  801dbc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801dc1:	89 eb                	mov    %ebp,%ebx
  801dc3:	29 fb                	sub    %edi,%ebx
  801dc5:	89 f9                	mov    %edi,%ecx
  801dc7:	d3 e6                	shl    %cl,%esi
  801dc9:	89 c5                	mov    %eax,%ebp
  801dcb:	88 d9                	mov    %bl,%cl
  801dcd:	d3 ed                	shr    %cl,%ebp
  801dcf:	89 e9                	mov    %ebp,%ecx
  801dd1:	09 f1                	or     %esi,%ecx
  801dd3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801dd7:	89 f9                	mov    %edi,%ecx
  801dd9:	d3 e0                	shl    %cl,%eax
  801ddb:	89 c5                	mov    %eax,%ebp
  801ddd:	89 d6                	mov    %edx,%esi
  801ddf:	88 d9                	mov    %bl,%cl
  801de1:	d3 ee                	shr    %cl,%esi
  801de3:	89 f9                	mov    %edi,%ecx
  801de5:	d3 e2                	shl    %cl,%edx
  801de7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801deb:	88 d9                	mov    %bl,%cl
  801ded:	d3 e8                	shr    %cl,%eax
  801def:	09 c2                	or     %eax,%edx
  801df1:	89 d0                	mov    %edx,%eax
  801df3:	89 f2                	mov    %esi,%edx
  801df5:	f7 74 24 0c          	divl   0xc(%esp)
  801df9:	89 d6                	mov    %edx,%esi
  801dfb:	89 c3                	mov    %eax,%ebx
  801dfd:	f7 e5                	mul    %ebp
  801dff:	39 d6                	cmp    %edx,%esi
  801e01:	72 19                	jb     801e1c <__udivdi3+0xfc>
  801e03:	74 0b                	je     801e10 <__udivdi3+0xf0>
  801e05:	89 d8                	mov    %ebx,%eax
  801e07:	31 ff                	xor    %edi,%edi
  801e09:	e9 58 ff ff ff       	jmp    801d66 <__udivdi3+0x46>
  801e0e:	66 90                	xchg   %ax,%ax
  801e10:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e14:	89 f9                	mov    %edi,%ecx
  801e16:	d3 e2                	shl    %cl,%edx
  801e18:	39 c2                	cmp    %eax,%edx
  801e1a:	73 e9                	jae    801e05 <__udivdi3+0xe5>
  801e1c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e1f:	31 ff                	xor    %edi,%edi
  801e21:	e9 40 ff ff ff       	jmp    801d66 <__udivdi3+0x46>
  801e26:	66 90                	xchg   %ax,%ax
  801e28:	31 c0                	xor    %eax,%eax
  801e2a:	e9 37 ff ff ff       	jmp    801d66 <__udivdi3+0x46>
  801e2f:	90                   	nop

00801e30 <__umoddi3>:
  801e30:	55                   	push   %ebp
  801e31:	57                   	push   %edi
  801e32:	56                   	push   %esi
  801e33:	53                   	push   %ebx
  801e34:	83 ec 1c             	sub    $0x1c,%esp
  801e37:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e3b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e43:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e4b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e4f:	89 f3                	mov    %esi,%ebx
  801e51:	89 fa                	mov    %edi,%edx
  801e53:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e57:	89 34 24             	mov    %esi,(%esp)
  801e5a:	85 c0                	test   %eax,%eax
  801e5c:	75 1a                	jne    801e78 <__umoddi3+0x48>
  801e5e:	39 f7                	cmp    %esi,%edi
  801e60:	0f 86 a2 00 00 00    	jbe    801f08 <__umoddi3+0xd8>
  801e66:	89 c8                	mov    %ecx,%eax
  801e68:	89 f2                	mov    %esi,%edx
  801e6a:	f7 f7                	div    %edi
  801e6c:	89 d0                	mov    %edx,%eax
  801e6e:	31 d2                	xor    %edx,%edx
  801e70:	83 c4 1c             	add    $0x1c,%esp
  801e73:	5b                   	pop    %ebx
  801e74:	5e                   	pop    %esi
  801e75:	5f                   	pop    %edi
  801e76:	5d                   	pop    %ebp
  801e77:	c3                   	ret    
  801e78:	39 f0                	cmp    %esi,%eax
  801e7a:	0f 87 ac 00 00 00    	ja     801f2c <__umoddi3+0xfc>
  801e80:	0f bd e8             	bsr    %eax,%ebp
  801e83:	83 f5 1f             	xor    $0x1f,%ebp
  801e86:	0f 84 ac 00 00 00    	je     801f38 <__umoddi3+0x108>
  801e8c:	bf 20 00 00 00       	mov    $0x20,%edi
  801e91:	29 ef                	sub    %ebp,%edi
  801e93:	89 fe                	mov    %edi,%esi
  801e95:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e99:	89 e9                	mov    %ebp,%ecx
  801e9b:	d3 e0                	shl    %cl,%eax
  801e9d:	89 d7                	mov    %edx,%edi
  801e9f:	89 f1                	mov    %esi,%ecx
  801ea1:	d3 ef                	shr    %cl,%edi
  801ea3:	09 c7                	or     %eax,%edi
  801ea5:	89 e9                	mov    %ebp,%ecx
  801ea7:	d3 e2                	shl    %cl,%edx
  801ea9:	89 14 24             	mov    %edx,(%esp)
  801eac:	89 d8                	mov    %ebx,%eax
  801eae:	d3 e0                	shl    %cl,%eax
  801eb0:	89 c2                	mov    %eax,%edx
  801eb2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801eb6:	d3 e0                	shl    %cl,%eax
  801eb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ebc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ec0:	89 f1                	mov    %esi,%ecx
  801ec2:	d3 e8                	shr    %cl,%eax
  801ec4:	09 d0                	or     %edx,%eax
  801ec6:	d3 eb                	shr    %cl,%ebx
  801ec8:	89 da                	mov    %ebx,%edx
  801eca:	f7 f7                	div    %edi
  801ecc:	89 d3                	mov    %edx,%ebx
  801ece:	f7 24 24             	mull   (%esp)
  801ed1:	89 c6                	mov    %eax,%esi
  801ed3:	89 d1                	mov    %edx,%ecx
  801ed5:	39 d3                	cmp    %edx,%ebx
  801ed7:	0f 82 87 00 00 00    	jb     801f64 <__umoddi3+0x134>
  801edd:	0f 84 91 00 00 00    	je     801f74 <__umoddi3+0x144>
  801ee3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ee7:	29 f2                	sub    %esi,%edx
  801ee9:	19 cb                	sbb    %ecx,%ebx
  801eeb:	89 d8                	mov    %ebx,%eax
  801eed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ef1:	d3 e0                	shl    %cl,%eax
  801ef3:	89 e9                	mov    %ebp,%ecx
  801ef5:	d3 ea                	shr    %cl,%edx
  801ef7:	09 d0                	or     %edx,%eax
  801ef9:	89 e9                	mov    %ebp,%ecx
  801efb:	d3 eb                	shr    %cl,%ebx
  801efd:	89 da                	mov    %ebx,%edx
  801eff:	83 c4 1c             	add    $0x1c,%esp
  801f02:	5b                   	pop    %ebx
  801f03:	5e                   	pop    %esi
  801f04:	5f                   	pop    %edi
  801f05:	5d                   	pop    %ebp
  801f06:	c3                   	ret    
  801f07:	90                   	nop
  801f08:	89 fd                	mov    %edi,%ebp
  801f0a:	85 ff                	test   %edi,%edi
  801f0c:	75 0b                	jne    801f19 <__umoddi3+0xe9>
  801f0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f13:	31 d2                	xor    %edx,%edx
  801f15:	f7 f7                	div    %edi
  801f17:	89 c5                	mov    %eax,%ebp
  801f19:	89 f0                	mov    %esi,%eax
  801f1b:	31 d2                	xor    %edx,%edx
  801f1d:	f7 f5                	div    %ebp
  801f1f:	89 c8                	mov    %ecx,%eax
  801f21:	f7 f5                	div    %ebp
  801f23:	89 d0                	mov    %edx,%eax
  801f25:	e9 44 ff ff ff       	jmp    801e6e <__umoddi3+0x3e>
  801f2a:	66 90                	xchg   %ax,%ax
  801f2c:	89 c8                	mov    %ecx,%eax
  801f2e:	89 f2                	mov    %esi,%edx
  801f30:	83 c4 1c             	add    $0x1c,%esp
  801f33:	5b                   	pop    %ebx
  801f34:	5e                   	pop    %esi
  801f35:	5f                   	pop    %edi
  801f36:	5d                   	pop    %ebp
  801f37:	c3                   	ret    
  801f38:	3b 04 24             	cmp    (%esp),%eax
  801f3b:	72 06                	jb     801f43 <__umoddi3+0x113>
  801f3d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801f41:	77 0f                	ja     801f52 <__umoddi3+0x122>
  801f43:	89 f2                	mov    %esi,%edx
  801f45:	29 f9                	sub    %edi,%ecx
  801f47:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f4b:	89 14 24             	mov    %edx,(%esp)
  801f4e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f52:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f56:	8b 14 24             	mov    (%esp),%edx
  801f59:	83 c4 1c             	add    $0x1c,%esp
  801f5c:	5b                   	pop    %ebx
  801f5d:	5e                   	pop    %esi
  801f5e:	5f                   	pop    %edi
  801f5f:	5d                   	pop    %ebp
  801f60:	c3                   	ret    
  801f61:	8d 76 00             	lea    0x0(%esi),%esi
  801f64:	2b 04 24             	sub    (%esp),%eax
  801f67:	19 fa                	sbb    %edi,%edx
  801f69:	89 d1                	mov    %edx,%ecx
  801f6b:	89 c6                	mov    %eax,%esi
  801f6d:	e9 71 ff ff ff       	jmp    801ee3 <__umoddi3+0xb3>
  801f72:	66 90                	xchg   %ax,%ax
  801f74:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801f78:	72 ea                	jb     801f64 <__umoddi3+0x134>
  801f7a:	89 d9                	mov    %ebx,%ecx
  801f7c:	e9 62 ff ff ff       	jmp    801ee3 <__umoddi3+0xb3>

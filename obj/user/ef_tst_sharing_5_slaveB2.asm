
obj/user/ef_tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 60 01 00 00       	call   800196 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
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
  80005b:	68 e0 20 80 00       	push   $0x8020e0
  800060:	6a 0b                	push   $0xb
  800062:	68 fc 20 80 00       	push   $0x8020fc
  800067:	e8 da 02 00 00       	call   800346 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006c:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	z = sget(sys_getparentenvid(),"z");
  800073:	e8 39 19 00 00       	call   8019b1 <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 1c 21 80 00       	push   $0x80211c
  800080:	50                   	push   %eax
  800081:	e8 cc 15 00 00       	call   801652 <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)
	inctst(); //to indicate that the shared object is taken
  80008c:	e8 45 1a 00 00       	call   801ad6 <inctst>
	cprintf("Slave B2 env used z (getSharedObject)\n");
  800091:	83 ec 0c             	sub    $0xc,%esp
  800094:	68 20 21 80 00       	push   $0x802120
  800099:	e8 76 05 00 00       	call   800614 <cprintf>
  80009e:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B2 please be patient ...\n");
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	68 48 21 80 00       	push   $0x802148
  8000a9:	e8 66 05 00 00       	call   800614 <cprintf>
  8000ae:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(9000);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 28 23 00 00       	push   $0x2328
  8000b9:	e8 e4 1c 00 00       	call   801da2 <env_sleep>
  8000be:	83 c4 10             	add    $0x10,%esp
	//to ensure that the other environments completed successfully
	while (gettst()!=5) ;// panic("test failed");
  8000c1:	90                   	nop
  8000c2:	e8 29 1a 00 00       	call   801af0 <gettst>
  8000c7:	83 f8 05             	cmp    $0x5,%eax
  8000ca:	75 f6                	jne    8000c2 <_main+0x8a>

	sys_lock_cons(); //critical section to ensure it's executed at atomically
  8000cc:	e8 4e 16 00 00       	call   80171f <sys_lock_cons>
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000d1:	e8 f9 16 00 00       	call   8017cf <sys_calculate_free_frames>
  8000d6:	89 45 ec             	mov    %eax,-0x14(%ebp)

		sfree(z);
  8000d9:	83 ec 0c             	sub    $0xc,%esp
  8000dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8000df:	e8 af 15 00 00       	call   801693 <sfree>
  8000e4:	83 c4 10             	add    $0x10,%esp
		cprintf("Slave B2 env removed z\n");
  8000e7:	83 ec 0c             	sub    $0xc,%esp
  8000ea:	68 68 21 80 00       	push   $0x802168
  8000ef:	e8 20 05 00 00       	call   800614 <cprintf>
  8000f4:	83 c4 10             	add    $0x10,%esp

		expected = 2+1; /*2pages+1table*/
  8000f7:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%ebp)
		if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal %d !, Expected:\nfrom the env: 1 table and 2 for frames of z\nframes_storage of z: should be cleared now\n", expected);
  8000fe:	e8 cc 16 00 00       	call   8017cf <sys_calculate_free_frames>
  800103:	89 c2                	mov    %eax,%edx
  800105:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800108:	29 c2                	sub    %eax,%edx
  80010a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80010d:	39 c2                	cmp    %eax,%edx
  80010f:	74 14                	je     800125 <_main+0xed>
  800111:	ff 75 e8             	pushl  -0x18(%ebp)
  800114:	68 80 21 80 00       	push   $0x802180
  800119:	6a 29                	push   $0x29
  80011b:	68 fc 20 80 00       	push   $0x8020fc
  800120:	e8 21 02 00 00       	call   800346 <_panic>
	}
	sys_unlock_cons();
  800125:	e8 0f 16 00 00       	call   801739 <sys_unlock_cons>
	//To indicate that it's completed successfully
	inctst();
  80012a:	e8 a7 19 00 00       	call   801ad6 <inctst>

	//to ensure that the other environments completed successfully
	while (gettst()!=7) ;// panic("test failed");
  80012f:	90                   	nop
  800130:	e8 bb 19 00 00       	call   801af0 <gettst>
  800135:	83 f8 07             	cmp    $0x7,%eax
  800138:	75 f6                	jne    800130 <_main+0xf8>

	cprintf("Step B is finished!!\n\n\n");
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	68 10 22 80 00       	push   $0x802210
  800142:	e8 cd 04 00 00       	call   800614 <cprintf>
  800147:	83 c4 10             	add    $0x10,%esp
	cprintf("Test of freeSharedObjects [5] is finished!!\n\n\n");
  80014a:	83 ec 0c             	sub    $0xc,%esp
  80014d:	68 28 22 80 00       	push   $0x802228
  800152:	e8 bd 04 00 00       	call   800614 <cprintf>
  800157:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  80015a:	e8 52 18 00 00       	call   8019b1 <sys_getparentenvid>
  80015f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(parentenvID > 0)
  800162:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800166:	7e 2b                	jle    800193 <_main+0x15b>
	{
		//Get the check-finishing counter
		int *finish = NULL;
  800168:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		finish = sget(parentenvID, "finish_children") ;
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	68 57 22 80 00       	push   $0x802257
  800177:	ff 75 e4             	pushl  -0x1c(%ebp)
  80017a:	e8 d3 14 00 00       	call   801652 <sget>
  80017f:	83 c4 10             	add    $0x10,%esp
  800182:	89 45 e0             	mov    %eax,-0x20(%ebp)
		(*finish)++ ;
  800185:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800188:	8b 00                	mov    (%eax),%eax
  80018a:	8d 50 01             	lea    0x1(%eax),%edx
  80018d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800190:	89 10                	mov    %edx,(%eax)
	}
	return;
  800192:	90                   	nop
  800193:	90                   	nop
}
  800194:	c9                   	leave  
  800195:	c3                   	ret    

00800196 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	57                   	push   %edi
  80019a:	56                   	push   %esi
  80019b:	53                   	push   %ebx
  80019c:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80019f:	e8 f4 17 00 00       	call   801998 <sys_getenvindex>
  8001a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8001a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001aa:	89 d0                	mov    %edx,%eax
  8001ac:	c1 e0 02             	shl    $0x2,%eax
  8001af:	01 d0                	add    %edx,%eax
  8001b1:	c1 e0 03             	shl    $0x3,%eax
  8001b4:	01 d0                	add    %edx,%eax
  8001b6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8001bd:	01 d0                	add    %edx,%eax
  8001bf:	c1 e0 02             	shl    $0x2,%eax
  8001c2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001c7:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001cc:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d1:	8a 40 20             	mov    0x20(%eax),%al
  8001d4:	84 c0                	test   %al,%al
  8001d6:	74 0d                	je     8001e5 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8001d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8001dd:	83 c0 20             	add    $0x20,%eax
  8001e0:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001e9:	7e 0a                	jle    8001f5 <libmain+0x5f>
		binaryname = argv[0];
  8001eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ee:	8b 00                	mov    (%eax),%eax
  8001f0:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8001f5:	83 ec 08             	sub    $0x8,%esp
  8001f8:	ff 75 0c             	pushl  0xc(%ebp)
  8001fb:	ff 75 08             	pushl  0x8(%ebp)
  8001fe:	e8 35 fe ff ff       	call   800038 <_main>
  800203:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800206:	a1 00 30 80 00       	mov    0x803000,%eax
  80020b:	85 c0                	test   %eax,%eax
  80020d:	0f 84 01 01 00 00    	je     800314 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800213:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800219:	bb 60 23 80 00       	mov    $0x802360,%ebx
  80021e:	ba 0e 00 00 00       	mov    $0xe,%edx
  800223:	89 c7                	mov    %eax,%edi
  800225:	89 de                	mov    %ebx,%esi
  800227:	89 d1                	mov    %edx,%ecx
  800229:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80022b:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80022e:	b9 56 00 00 00       	mov    $0x56,%ecx
  800233:	b0 00                	mov    $0x0,%al
  800235:	89 d7                	mov    %edx,%edi
  800237:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800239:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800240:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800243:	83 ec 08             	sub    $0x8,%esp
  800246:	50                   	push   %eax
  800247:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80024d:	50                   	push   %eax
  80024e:	e8 7b 19 00 00       	call   801bce <sys_utilities>
  800253:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800256:	e8 c4 14 00 00       	call   80171f <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 80 22 80 00       	push   $0x802280
  800263:	e8 ac 03 00 00       	call   800614 <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80026b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80026e:	85 c0                	test   %eax,%eax
  800270:	74 18                	je     80028a <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800272:	e8 75 19 00 00       	call   801bec <sys_get_optimal_num_faults>
  800277:	83 ec 08             	sub    $0x8,%esp
  80027a:	50                   	push   %eax
  80027b:	68 a8 22 80 00       	push   $0x8022a8
  800280:	e8 8f 03 00 00       	call   800614 <cprintf>
  800285:	83 c4 10             	add    $0x10,%esp
  800288:	eb 59                	jmp    8002e3 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80028a:	a1 20 30 80 00       	mov    0x803020,%eax
  80028f:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800295:	a1 20 30 80 00       	mov    0x803020,%eax
  80029a:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8002a0:	83 ec 04             	sub    $0x4,%esp
  8002a3:	52                   	push   %edx
  8002a4:	50                   	push   %eax
  8002a5:	68 cc 22 80 00       	push   $0x8022cc
  8002aa:	e8 65 03 00 00       	call   800614 <cprintf>
  8002af:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8002b7:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8002bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c2:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8002c8:	a1 20 30 80 00       	mov    0x803020,%eax
  8002cd:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8002d3:	51                   	push   %ecx
  8002d4:	52                   	push   %edx
  8002d5:	50                   	push   %eax
  8002d6:	68 f4 22 80 00       	push   $0x8022f4
  8002db:	e8 34 03 00 00       	call   800614 <cprintf>
  8002e0:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e8:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8002ee:	83 ec 08             	sub    $0x8,%esp
  8002f1:	50                   	push   %eax
  8002f2:	68 4c 23 80 00       	push   $0x80234c
  8002f7:	e8 18 03 00 00       	call   800614 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002ff:	83 ec 0c             	sub    $0xc,%esp
  800302:	68 80 22 80 00       	push   $0x802280
  800307:	e8 08 03 00 00       	call   800614 <cprintf>
  80030c:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80030f:	e8 25 14 00 00       	call   801739 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800314:	e8 1f 00 00 00       	call   800338 <exit>
}
  800319:	90                   	nop
  80031a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80031d:	5b                   	pop    %ebx
  80031e:	5e                   	pop    %esi
  80031f:	5f                   	pop    %edi
  800320:	5d                   	pop    %ebp
  800321:	c3                   	ret    

00800322 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800322:	55                   	push   %ebp
  800323:	89 e5                	mov    %esp,%ebp
  800325:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800328:	83 ec 0c             	sub    $0xc,%esp
  80032b:	6a 00                	push   $0x0
  80032d:	e8 32 16 00 00       	call   801964 <sys_destroy_env>
  800332:	83 c4 10             	add    $0x10,%esp
}
  800335:	90                   	nop
  800336:	c9                   	leave  
  800337:	c3                   	ret    

00800338 <exit>:

void
exit(void)
{
  800338:	55                   	push   %ebp
  800339:	89 e5                	mov    %esp,%ebp
  80033b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80033e:	e8 87 16 00 00       	call   8019ca <sys_exit_env>
}
  800343:	90                   	nop
  800344:	c9                   	leave  
  800345:	c3                   	ret    

00800346 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80034c:	8d 45 10             	lea    0x10(%ebp),%eax
  80034f:	83 c0 04             	add    $0x4,%eax
  800352:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800355:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80035a:	85 c0                	test   %eax,%eax
  80035c:	74 16                	je     800374 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80035e:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800363:	83 ec 08             	sub    $0x8,%esp
  800366:	50                   	push   %eax
  800367:	68 c4 23 80 00       	push   $0x8023c4
  80036c:	e8 a3 02 00 00       	call   800614 <cprintf>
  800371:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800374:	a1 04 30 80 00       	mov    0x803004,%eax
  800379:	83 ec 0c             	sub    $0xc,%esp
  80037c:	ff 75 0c             	pushl  0xc(%ebp)
  80037f:	ff 75 08             	pushl  0x8(%ebp)
  800382:	50                   	push   %eax
  800383:	68 cc 23 80 00       	push   $0x8023cc
  800388:	6a 74                	push   $0x74
  80038a:	e8 b2 02 00 00       	call   800641 <cprintf_colored>
  80038f:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800392:	8b 45 10             	mov    0x10(%ebp),%eax
  800395:	83 ec 08             	sub    $0x8,%esp
  800398:	ff 75 f4             	pushl  -0xc(%ebp)
  80039b:	50                   	push   %eax
  80039c:	e8 04 02 00 00       	call   8005a5 <vcprintf>
  8003a1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003a4:	83 ec 08             	sub    $0x8,%esp
  8003a7:	6a 00                	push   $0x0
  8003a9:	68 f4 23 80 00       	push   $0x8023f4
  8003ae:	e8 f2 01 00 00       	call   8005a5 <vcprintf>
  8003b3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003b6:	e8 7d ff ff ff       	call   800338 <exit>

	// should not return here
	while (1) ;
  8003bb:	eb fe                	jmp    8003bb <_panic+0x75>

008003bd <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
  8003c0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d1:	39 c2                	cmp    %eax,%edx
  8003d3:	74 14                	je     8003e9 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003d5:	83 ec 04             	sub    $0x4,%esp
  8003d8:	68 f8 23 80 00       	push   $0x8023f8
  8003dd:	6a 26                	push   $0x26
  8003df:	68 44 24 80 00       	push   $0x802444
  8003e4:	e8 5d ff ff ff       	call   800346 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003f7:	e9 c5 00 00 00       	jmp    8004c1 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800406:	8b 45 08             	mov    0x8(%ebp),%eax
  800409:	01 d0                	add    %edx,%eax
  80040b:	8b 00                	mov    (%eax),%eax
  80040d:	85 c0                	test   %eax,%eax
  80040f:	75 08                	jne    800419 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800411:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800414:	e9 a5 00 00 00       	jmp    8004be <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800419:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800420:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800427:	eb 69                	jmp    800492 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800429:	a1 20 30 80 00       	mov    0x803020,%eax
  80042e:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800434:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800437:	89 d0                	mov    %edx,%eax
  800439:	01 c0                	add    %eax,%eax
  80043b:	01 d0                	add    %edx,%eax
  80043d:	c1 e0 03             	shl    $0x3,%eax
  800440:	01 c8                	add    %ecx,%eax
  800442:	8a 40 04             	mov    0x4(%eax),%al
  800445:	84 c0                	test   %al,%al
  800447:	75 46                	jne    80048f <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800449:	a1 20 30 80 00       	mov    0x803020,%eax
  80044e:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800454:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800457:	89 d0                	mov    %edx,%eax
  800459:	01 c0                	add    %eax,%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	c1 e0 03             	shl    $0x3,%eax
  800460:	01 c8                	add    %ecx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800467:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80046a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80046f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800471:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800474:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	01 c8                	add    %ecx,%eax
  800480:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800482:	39 c2                	cmp    %eax,%edx
  800484:	75 09                	jne    80048f <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800486:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80048d:	eb 15                	jmp    8004a4 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80048f:	ff 45 e8             	incl   -0x18(%ebp)
  800492:	a1 20 30 80 00       	mov    0x803020,%eax
  800497:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80049d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004a0:	39 c2                	cmp    %eax,%edx
  8004a2:	77 85                	ja     800429 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004a8:	75 14                	jne    8004be <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	68 50 24 80 00       	push   $0x802450
  8004b2:	6a 3a                	push   $0x3a
  8004b4:	68 44 24 80 00       	push   $0x802444
  8004b9:	e8 88 fe ff ff       	call   800346 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004be:	ff 45 f0             	incl   -0x10(%ebp)
  8004c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004c7:	0f 8c 2f ff ff ff    	jl     8003fc <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004cd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004db:	eb 26                	jmp    800503 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8004e2:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8004e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004eb:	89 d0                	mov    %edx,%eax
  8004ed:	01 c0                	add    %eax,%eax
  8004ef:	01 d0                	add    %edx,%eax
  8004f1:	c1 e0 03             	shl    $0x3,%eax
  8004f4:	01 c8                	add    %ecx,%eax
  8004f6:	8a 40 04             	mov    0x4(%eax),%al
  8004f9:	3c 01                	cmp    $0x1,%al
  8004fb:	75 03                	jne    800500 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004fd:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800500:	ff 45 e0             	incl   -0x20(%ebp)
  800503:	a1 20 30 80 00       	mov    0x803020,%eax
  800508:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80050e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800511:	39 c2                	cmp    %eax,%edx
  800513:	77 c8                	ja     8004dd <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800518:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80051b:	74 14                	je     800531 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80051d:	83 ec 04             	sub    $0x4,%esp
  800520:	68 a4 24 80 00       	push   $0x8024a4
  800525:	6a 44                	push   $0x44
  800527:	68 44 24 80 00       	push   $0x802444
  80052c:	e8 15 fe ff ff       	call   800346 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800531:	90                   	nop
  800532:	c9                   	leave  
  800533:	c3                   	ret    

00800534 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800534:	55                   	push   %ebp
  800535:	89 e5                	mov    %esp,%ebp
  800537:	53                   	push   %ebx
  800538:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80053b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	8d 48 01             	lea    0x1(%eax),%ecx
  800543:	8b 55 0c             	mov    0xc(%ebp),%edx
  800546:	89 0a                	mov    %ecx,(%edx)
  800548:	8b 55 08             	mov    0x8(%ebp),%edx
  80054b:	88 d1                	mov    %dl,%cl
  80054d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800550:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800554:	8b 45 0c             	mov    0xc(%ebp),%eax
  800557:	8b 00                	mov    (%eax),%eax
  800559:	3d ff 00 00 00       	cmp    $0xff,%eax
  80055e:	75 30                	jne    800590 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800560:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800566:	a0 44 30 80 00       	mov    0x803044,%al
  80056b:	0f b6 c0             	movzbl %al,%eax
  80056e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800571:	8b 09                	mov    (%ecx),%ecx
  800573:	89 cb                	mov    %ecx,%ebx
  800575:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800578:	83 c1 08             	add    $0x8,%ecx
  80057b:	52                   	push   %edx
  80057c:	50                   	push   %eax
  80057d:	53                   	push   %ebx
  80057e:	51                   	push   %ecx
  80057f:	e8 57 11 00 00       	call   8016db <sys_cputs>
  800584:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80058a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800590:	8b 45 0c             	mov    0xc(%ebp),%eax
  800593:	8b 40 04             	mov    0x4(%eax),%eax
  800596:	8d 50 01             	lea    0x1(%eax),%edx
  800599:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80059f:	90                   	nop
  8005a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005a3:	c9                   	leave  
  8005a4:	c3                   	ret    

008005a5 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005a5:	55                   	push   %ebp
  8005a6:	89 e5                	mov    %esp,%ebp
  8005a8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005ae:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005b5:	00 00 00 
	b.cnt = 0;
  8005b8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005bf:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005c2:	ff 75 0c             	pushl  0xc(%ebp)
  8005c5:	ff 75 08             	pushl  0x8(%ebp)
  8005c8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005ce:	50                   	push   %eax
  8005cf:	68 34 05 80 00       	push   $0x800534
  8005d4:	e8 5a 02 00 00       	call   800833 <vprintfmt>
  8005d9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8005dc:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8005e2:	a0 44 30 80 00       	mov    0x803044,%al
  8005e7:	0f b6 c0             	movzbl %al,%eax
  8005ea:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8005f0:	52                   	push   %edx
  8005f1:	50                   	push   %eax
  8005f2:	51                   	push   %ecx
  8005f3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005f9:	83 c0 08             	add    $0x8,%eax
  8005fc:	50                   	push   %eax
  8005fd:	e8 d9 10 00 00       	call   8016db <sys_cputs>
  800602:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800605:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  80060c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800612:	c9                   	leave  
  800613:	c3                   	ret    

00800614 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800614:	55                   	push   %ebp
  800615:	89 e5                	mov    %esp,%ebp
  800617:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80061a:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800621:	8d 45 0c             	lea    0xc(%ebp),%eax
  800624:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	ff 75 f4             	pushl  -0xc(%ebp)
  800630:	50                   	push   %eax
  800631:	e8 6f ff ff ff       	call   8005a5 <vcprintf>
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80063c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80063f:	c9                   	leave  
  800640:	c3                   	ret    

00800641 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800641:	55                   	push   %ebp
  800642:	89 e5                	mov    %esp,%ebp
  800644:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800647:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	c1 e0 08             	shl    $0x8,%eax
  800654:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800659:	8d 45 0c             	lea    0xc(%ebp),%eax
  80065c:	83 c0 04             	add    $0x4,%eax
  80065f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800662:	8b 45 0c             	mov    0xc(%ebp),%eax
  800665:	83 ec 08             	sub    $0x8,%esp
  800668:	ff 75 f4             	pushl  -0xc(%ebp)
  80066b:	50                   	push   %eax
  80066c:	e8 34 ff ff ff       	call   8005a5 <vcprintf>
  800671:	83 c4 10             	add    $0x10,%esp
  800674:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800677:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  80067e:	07 00 00 

	return cnt;
  800681:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800684:	c9                   	leave  
  800685:	c3                   	ret    

00800686 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800686:	55                   	push   %ebp
  800687:	89 e5                	mov    %esp,%ebp
  800689:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80068c:	e8 8e 10 00 00       	call   80171f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800691:	8d 45 0c             	lea    0xc(%ebp),%eax
  800694:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	83 ec 08             	sub    $0x8,%esp
  80069d:	ff 75 f4             	pushl  -0xc(%ebp)
  8006a0:	50                   	push   %eax
  8006a1:	e8 ff fe ff ff       	call   8005a5 <vcprintf>
  8006a6:	83 c4 10             	add    $0x10,%esp
  8006a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8006ac:	e8 88 10 00 00       	call   801739 <sys_unlock_cons>
	return cnt;
  8006b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006b4:	c9                   	leave  
  8006b5:	c3                   	ret    

008006b6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006b6:	55                   	push   %ebp
  8006b7:	89 e5                	mov    %esp,%ebp
  8006b9:	53                   	push   %ebx
  8006ba:	83 ec 14             	sub    $0x14,%esp
  8006bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8006c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006c9:	8b 45 18             	mov    0x18(%ebp),%eax
  8006cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006d4:	77 55                	ja     80072b <printnum+0x75>
  8006d6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006d9:	72 05                	jb     8006e0 <printnum+0x2a>
  8006db:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006de:	77 4b                	ja     80072b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006e0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006e3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006e6:	8b 45 18             	mov    0x18(%ebp),%eax
  8006e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ee:	52                   	push   %edx
  8006ef:	50                   	push   %eax
  8006f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8006f3:	ff 75 f0             	pushl  -0x10(%ebp)
  8006f6:	e8 65 17 00 00       	call   801e60 <__udivdi3>
  8006fb:	83 c4 10             	add    $0x10,%esp
  8006fe:	83 ec 04             	sub    $0x4,%esp
  800701:	ff 75 20             	pushl  0x20(%ebp)
  800704:	53                   	push   %ebx
  800705:	ff 75 18             	pushl  0x18(%ebp)
  800708:	52                   	push   %edx
  800709:	50                   	push   %eax
  80070a:	ff 75 0c             	pushl  0xc(%ebp)
  80070d:	ff 75 08             	pushl  0x8(%ebp)
  800710:	e8 a1 ff ff ff       	call   8006b6 <printnum>
  800715:	83 c4 20             	add    $0x20,%esp
  800718:	eb 1a                	jmp    800734 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80071a:	83 ec 08             	sub    $0x8,%esp
  80071d:	ff 75 0c             	pushl  0xc(%ebp)
  800720:	ff 75 20             	pushl  0x20(%ebp)
  800723:	8b 45 08             	mov    0x8(%ebp),%eax
  800726:	ff d0                	call   *%eax
  800728:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80072b:	ff 4d 1c             	decl   0x1c(%ebp)
  80072e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800732:	7f e6                	jg     80071a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800734:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800737:	bb 00 00 00 00       	mov    $0x0,%ebx
  80073c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80073f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800742:	53                   	push   %ebx
  800743:	51                   	push   %ecx
  800744:	52                   	push   %edx
  800745:	50                   	push   %eax
  800746:	e8 25 18 00 00       	call   801f70 <__umoddi3>
  80074b:	83 c4 10             	add    $0x10,%esp
  80074e:	05 14 27 80 00       	add    $0x802714,%eax
  800753:	8a 00                	mov    (%eax),%al
  800755:	0f be c0             	movsbl %al,%eax
  800758:	83 ec 08             	sub    $0x8,%esp
  80075b:	ff 75 0c             	pushl  0xc(%ebp)
  80075e:	50                   	push   %eax
  80075f:	8b 45 08             	mov    0x8(%ebp),%eax
  800762:	ff d0                	call   *%eax
  800764:	83 c4 10             	add    $0x10,%esp
}
  800767:	90                   	nop
  800768:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80076b:	c9                   	leave  
  80076c:	c3                   	ret    

0080076d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800770:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800774:	7e 1c                	jle    800792 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
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
  800790:	eb 40                	jmp    8007d2 <getuint+0x65>
	else if (lflag)
  800792:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800796:	74 1e                	je     8007b6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800798:	8b 45 08             	mov    0x8(%ebp),%eax
  80079b:	8b 00                	mov    (%eax),%eax
  80079d:	8d 50 04             	lea    0x4(%eax),%edx
  8007a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a3:	89 10                	mov    %edx,(%eax)
  8007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a8:	8b 00                	mov    (%eax),%eax
  8007aa:	83 e8 04             	sub    $0x4,%eax
  8007ad:	8b 00                	mov    (%eax),%eax
  8007af:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b4:	eb 1c                	jmp    8007d2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	8d 50 04             	lea    0x4(%eax),%edx
  8007be:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c1:	89 10                	mov    %edx,(%eax)
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	83 e8 04             	sub    $0x4,%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007d2:	5d                   	pop    %ebp
  8007d3:	c3                   	ret    

008007d4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007d4:	55                   	push   %ebp
  8007d5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007d7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007db:	7e 1c                	jle    8007f9 <getint+0x25>
		return va_arg(*ap, long long);
  8007dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	8d 50 08             	lea    0x8(%eax),%edx
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	89 10                	mov    %edx,(%eax)
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	83 e8 08             	sub    $0x8,%eax
  8007f2:	8b 50 04             	mov    0x4(%eax),%edx
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	eb 38                	jmp    800831 <getint+0x5d>
	else if (lflag)
  8007f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007fd:	74 1a                	je     800819 <getint+0x45>
		return va_arg(*ap, long);
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	8b 00                	mov    (%eax),%eax
  800804:	8d 50 04             	lea    0x4(%eax),%edx
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	89 10                	mov    %edx,(%eax)
  80080c:	8b 45 08             	mov    0x8(%ebp),%eax
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	83 e8 04             	sub    $0x4,%eax
  800814:	8b 00                	mov    (%eax),%eax
  800816:	99                   	cltd   
  800817:	eb 18                	jmp    800831 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800819:	8b 45 08             	mov    0x8(%ebp),%eax
  80081c:	8b 00                	mov    (%eax),%eax
  80081e:	8d 50 04             	lea    0x4(%eax),%edx
  800821:	8b 45 08             	mov    0x8(%ebp),%eax
  800824:	89 10                	mov    %edx,(%eax)
  800826:	8b 45 08             	mov    0x8(%ebp),%eax
  800829:	8b 00                	mov    (%eax),%eax
  80082b:	83 e8 04             	sub    $0x4,%eax
  80082e:	8b 00                	mov    (%eax),%eax
  800830:	99                   	cltd   
}
  800831:	5d                   	pop    %ebp
  800832:	c3                   	ret    

00800833 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800833:	55                   	push   %ebp
  800834:	89 e5                	mov    %esp,%ebp
  800836:	56                   	push   %esi
  800837:	53                   	push   %ebx
  800838:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80083b:	eb 17                	jmp    800854 <vprintfmt+0x21>
			if (ch == '\0')
  80083d:	85 db                	test   %ebx,%ebx
  80083f:	0f 84 c1 03 00 00    	je     800c06 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800845:	83 ec 08             	sub    $0x8,%esp
  800848:	ff 75 0c             	pushl  0xc(%ebp)
  80084b:	53                   	push   %ebx
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	ff d0                	call   *%eax
  800851:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800854:	8b 45 10             	mov    0x10(%ebp),%eax
  800857:	8d 50 01             	lea    0x1(%eax),%edx
  80085a:	89 55 10             	mov    %edx,0x10(%ebp)
  80085d:	8a 00                	mov    (%eax),%al
  80085f:	0f b6 d8             	movzbl %al,%ebx
  800862:	83 fb 25             	cmp    $0x25,%ebx
  800865:	75 d6                	jne    80083d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800867:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80086b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800872:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800879:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800880:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800887:	8b 45 10             	mov    0x10(%ebp),%eax
  80088a:	8d 50 01             	lea    0x1(%eax),%edx
  80088d:	89 55 10             	mov    %edx,0x10(%ebp)
  800890:	8a 00                	mov    (%eax),%al
  800892:	0f b6 d8             	movzbl %al,%ebx
  800895:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800898:	83 f8 5b             	cmp    $0x5b,%eax
  80089b:	0f 87 3d 03 00 00    	ja     800bde <vprintfmt+0x3ab>
  8008a1:	8b 04 85 38 27 80 00 	mov    0x802738(,%eax,4),%eax
  8008a8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008aa:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008ae:	eb d7                	jmp    800887 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008b0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008b4:	eb d1                	jmp    800887 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008b6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008c0:	89 d0                	mov    %edx,%eax
  8008c2:	c1 e0 02             	shl    $0x2,%eax
  8008c5:	01 d0                	add    %edx,%eax
  8008c7:	01 c0                	add    %eax,%eax
  8008c9:	01 d8                	add    %ebx,%eax
  8008cb:	83 e8 30             	sub    $0x30,%eax
  8008ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d4:	8a 00                	mov    (%eax),%al
  8008d6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008d9:	83 fb 2f             	cmp    $0x2f,%ebx
  8008dc:	7e 3e                	jle    80091c <vprintfmt+0xe9>
  8008de:	83 fb 39             	cmp    $0x39,%ebx
  8008e1:	7f 39                	jg     80091c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008e3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008e6:	eb d5                	jmp    8008bd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008eb:	83 c0 04             	add    $0x4,%eax
  8008ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f4:	83 e8 04             	sub    $0x4,%eax
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008fc:	eb 1f                	jmp    80091d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800902:	79 83                	jns    800887 <vprintfmt+0x54>
				width = 0;
  800904:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80090b:	e9 77 ff ff ff       	jmp    800887 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800910:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800917:	e9 6b ff ff ff       	jmp    800887 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80091c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80091d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800921:	0f 89 60 ff ff ff    	jns    800887 <vprintfmt+0x54>
				width = precision, precision = -1;
  800927:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80092d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800934:	e9 4e ff ff ff       	jmp    800887 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800939:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80093c:	e9 46 ff ff ff       	jmp    800887 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800941:	8b 45 14             	mov    0x14(%ebp),%eax
  800944:	83 c0 04             	add    $0x4,%eax
  800947:	89 45 14             	mov    %eax,0x14(%ebp)
  80094a:	8b 45 14             	mov    0x14(%ebp),%eax
  80094d:	83 e8 04             	sub    $0x4,%eax
  800950:	8b 00                	mov    (%eax),%eax
  800952:	83 ec 08             	sub    $0x8,%esp
  800955:	ff 75 0c             	pushl  0xc(%ebp)
  800958:	50                   	push   %eax
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	ff d0                	call   *%eax
  80095e:	83 c4 10             	add    $0x10,%esp
			break;
  800961:	e9 9b 02 00 00       	jmp    800c01 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800966:	8b 45 14             	mov    0x14(%ebp),%eax
  800969:	83 c0 04             	add    $0x4,%eax
  80096c:	89 45 14             	mov    %eax,0x14(%ebp)
  80096f:	8b 45 14             	mov    0x14(%ebp),%eax
  800972:	83 e8 04             	sub    $0x4,%eax
  800975:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800977:	85 db                	test   %ebx,%ebx
  800979:	79 02                	jns    80097d <vprintfmt+0x14a>
				err = -err;
  80097b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80097d:	83 fb 64             	cmp    $0x64,%ebx
  800980:	7f 0b                	jg     80098d <vprintfmt+0x15a>
  800982:	8b 34 9d 80 25 80 00 	mov    0x802580(,%ebx,4),%esi
  800989:	85 f6                	test   %esi,%esi
  80098b:	75 19                	jne    8009a6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80098d:	53                   	push   %ebx
  80098e:	68 25 27 80 00       	push   $0x802725
  800993:	ff 75 0c             	pushl  0xc(%ebp)
  800996:	ff 75 08             	pushl  0x8(%ebp)
  800999:	e8 70 02 00 00       	call   800c0e <printfmt>
  80099e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009a1:	e9 5b 02 00 00       	jmp    800c01 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009a6:	56                   	push   %esi
  8009a7:	68 2e 27 80 00       	push   $0x80272e
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	ff 75 08             	pushl  0x8(%ebp)
  8009b2:	e8 57 02 00 00       	call   800c0e <printfmt>
  8009b7:	83 c4 10             	add    $0x10,%esp
			break;
  8009ba:	e9 42 02 00 00       	jmp    800c01 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c2:	83 c0 04             	add    $0x4,%eax
  8009c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cb:	83 e8 04             	sub    $0x4,%eax
  8009ce:	8b 30                	mov    (%eax),%esi
  8009d0:	85 f6                	test   %esi,%esi
  8009d2:	75 05                	jne    8009d9 <vprintfmt+0x1a6>
				p = "(null)";
  8009d4:	be 31 27 80 00       	mov    $0x802731,%esi
			if (width > 0 && padc != '-')
  8009d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009dd:	7e 6d                	jle    800a4c <vprintfmt+0x219>
  8009df:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009e3:	74 67                	je     800a4c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	50                   	push   %eax
  8009ec:	56                   	push   %esi
  8009ed:	e8 1e 03 00 00       	call   800d10 <strnlen>
  8009f2:	83 c4 10             	add    $0x10,%esp
  8009f5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009f8:	eb 16                	jmp    800a10 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009fa:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009fe:	83 ec 08             	sub    $0x8,%esp
  800a01:	ff 75 0c             	pushl  0xc(%ebp)
  800a04:	50                   	push   %eax
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	ff d0                	call   *%eax
  800a0a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a0d:	ff 4d e4             	decl   -0x1c(%ebp)
  800a10:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a14:	7f e4                	jg     8009fa <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a16:	eb 34                	jmp    800a4c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a18:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a1c:	74 1c                	je     800a3a <vprintfmt+0x207>
  800a1e:	83 fb 1f             	cmp    $0x1f,%ebx
  800a21:	7e 05                	jle    800a28 <vprintfmt+0x1f5>
  800a23:	83 fb 7e             	cmp    $0x7e,%ebx
  800a26:	7e 12                	jle    800a3a <vprintfmt+0x207>
					putch('?', putdat);
  800a28:	83 ec 08             	sub    $0x8,%esp
  800a2b:	ff 75 0c             	pushl  0xc(%ebp)
  800a2e:	6a 3f                	push   $0x3f
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	ff d0                	call   *%eax
  800a35:	83 c4 10             	add    $0x10,%esp
  800a38:	eb 0f                	jmp    800a49 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a3a:	83 ec 08             	sub    $0x8,%esp
  800a3d:	ff 75 0c             	pushl  0xc(%ebp)
  800a40:	53                   	push   %ebx
  800a41:	8b 45 08             	mov    0x8(%ebp),%eax
  800a44:	ff d0                	call   *%eax
  800a46:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a49:	ff 4d e4             	decl   -0x1c(%ebp)
  800a4c:	89 f0                	mov    %esi,%eax
  800a4e:	8d 70 01             	lea    0x1(%eax),%esi
  800a51:	8a 00                	mov    (%eax),%al
  800a53:	0f be d8             	movsbl %al,%ebx
  800a56:	85 db                	test   %ebx,%ebx
  800a58:	74 24                	je     800a7e <vprintfmt+0x24b>
  800a5a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a5e:	78 b8                	js     800a18 <vprintfmt+0x1e5>
  800a60:	ff 4d e0             	decl   -0x20(%ebp)
  800a63:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a67:	79 af                	jns    800a18 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a69:	eb 13                	jmp    800a7e <vprintfmt+0x24b>
				putch(' ', putdat);
  800a6b:	83 ec 08             	sub    $0x8,%esp
  800a6e:	ff 75 0c             	pushl  0xc(%ebp)
  800a71:	6a 20                	push   $0x20
  800a73:	8b 45 08             	mov    0x8(%ebp),%eax
  800a76:	ff d0                	call   *%eax
  800a78:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a7b:	ff 4d e4             	decl   -0x1c(%ebp)
  800a7e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a82:	7f e7                	jg     800a6b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a84:	e9 78 01 00 00       	jmp    800c01 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a89:	83 ec 08             	sub    $0x8,%esp
  800a8c:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8f:	8d 45 14             	lea    0x14(%ebp),%eax
  800a92:	50                   	push   %eax
  800a93:	e8 3c fd ff ff       	call   8007d4 <getint>
  800a98:	83 c4 10             	add    $0x10,%esp
  800a9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aa7:	85 d2                	test   %edx,%edx
  800aa9:	79 23                	jns    800ace <vprintfmt+0x29b>
				putch('-', putdat);
  800aab:	83 ec 08             	sub    $0x8,%esp
  800aae:	ff 75 0c             	pushl  0xc(%ebp)
  800ab1:	6a 2d                	push   $0x2d
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	ff d0                	call   *%eax
  800ab8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800abe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ac1:	f7 d8                	neg    %eax
  800ac3:	83 d2 00             	adc    $0x0,%edx
  800ac6:	f7 da                	neg    %edx
  800ac8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800acb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ace:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ad5:	e9 bc 00 00 00       	jmp    800b96 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ada:	83 ec 08             	sub    $0x8,%esp
  800add:	ff 75 e8             	pushl  -0x18(%ebp)
  800ae0:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae3:	50                   	push   %eax
  800ae4:	e8 84 fc ff ff       	call   80076d <getuint>
  800ae9:	83 c4 10             	add    $0x10,%esp
  800aec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aef:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800af2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800af9:	e9 98 00 00 00       	jmp    800b96 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800afe:	83 ec 08             	sub    $0x8,%esp
  800b01:	ff 75 0c             	pushl  0xc(%ebp)
  800b04:	6a 58                	push   $0x58
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	ff d0                	call   *%eax
  800b0b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b0e:	83 ec 08             	sub    $0x8,%esp
  800b11:	ff 75 0c             	pushl  0xc(%ebp)
  800b14:	6a 58                	push   $0x58
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	ff d0                	call   *%eax
  800b1b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b1e:	83 ec 08             	sub    $0x8,%esp
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	6a 58                	push   $0x58
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	ff d0                	call   *%eax
  800b2b:	83 c4 10             	add    $0x10,%esp
			break;
  800b2e:	e9 ce 00 00 00       	jmp    800c01 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b33:	83 ec 08             	sub    $0x8,%esp
  800b36:	ff 75 0c             	pushl  0xc(%ebp)
  800b39:	6a 30                	push   $0x30
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	ff d0                	call   *%eax
  800b40:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b43:	83 ec 08             	sub    $0x8,%esp
  800b46:	ff 75 0c             	pushl  0xc(%ebp)
  800b49:	6a 78                	push   $0x78
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	ff d0                	call   *%eax
  800b50:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b53:	8b 45 14             	mov    0x14(%ebp),%eax
  800b56:	83 c0 04             	add    $0x4,%eax
  800b59:	89 45 14             	mov    %eax,0x14(%ebp)
  800b5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5f:	83 e8 04             	sub    $0x4,%eax
  800b62:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b6e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b75:	eb 1f                	jmp    800b96 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b77:	83 ec 08             	sub    $0x8,%esp
  800b7a:	ff 75 e8             	pushl  -0x18(%ebp)
  800b7d:	8d 45 14             	lea    0x14(%ebp),%eax
  800b80:	50                   	push   %eax
  800b81:	e8 e7 fb ff ff       	call   80076d <getuint>
  800b86:	83 c4 10             	add    $0x10,%esp
  800b89:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b8f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b96:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b9d:	83 ec 04             	sub    $0x4,%esp
  800ba0:	52                   	push   %edx
  800ba1:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ba4:	50                   	push   %eax
  800ba5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba8:	ff 75 f0             	pushl  -0x10(%ebp)
  800bab:	ff 75 0c             	pushl  0xc(%ebp)
  800bae:	ff 75 08             	pushl  0x8(%ebp)
  800bb1:	e8 00 fb ff ff       	call   8006b6 <printnum>
  800bb6:	83 c4 20             	add    $0x20,%esp
			break;
  800bb9:	eb 46                	jmp    800c01 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bbb:	83 ec 08             	sub    $0x8,%esp
  800bbe:	ff 75 0c             	pushl  0xc(%ebp)
  800bc1:	53                   	push   %ebx
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	ff d0                	call   *%eax
  800bc7:	83 c4 10             	add    $0x10,%esp
			break;
  800bca:	eb 35                	jmp    800c01 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800bcc:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800bd3:	eb 2c                	jmp    800c01 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800bd5:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800bdc:	eb 23                	jmp    800c01 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bde:	83 ec 08             	sub    $0x8,%esp
  800be1:	ff 75 0c             	pushl  0xc(%ebp)
  800be4:	6a 25                	push   $0x25
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	ff d0                	call   *%eax
  800beb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bee:	ff 4d 10             	decl   0x10(%ebp)
  800bf1:	eb 03                	jmp    800bf6 <vprintfmt+0x3c3>
  800bf3:	ff 4d 10             	decl   0x10(%ebp)
  800bf6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf9:	48                   	dec    %eax
  800bfa:	8a 00                	mov    (%eax),%al
  800bfc:	3c 25                	cmp    $0x25,%al
  800bfe:	75 f3                	jne    800bf3 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c00:	90                   	nop
		}
	}
  800c01:	e9 35 fc ff ff       	jmp    80083b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c06:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c07:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c0a:	5b                   	pop    %ebx
  800c0b:	5e                   	pop    %esi
  800c0c:	5d                   	pop    %ebp
  800c0d:	c3                   	ret    

00800c0e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c14:	8d 45 10             	lea    0x10(%ebp),%eax
  800c17:	83 c0 04             	add    $0x4,%eax
  800c1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c20:	ff 75 f4             	pushl  -0xc(%ebp)
  800c23:	50                   	push   %eax
  800c24:	ff 75 0c             	pushl  0xc(%ebp)
  800c27:	ff 75 08             	pushl  0x8(%ebp)
  800c2a:	e8 04 fc ff ff       	call   800833 <vprintfmt>
  800c2f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c32:	90                   	nop
  800c33:	c9                   	leave  
  800c34:	c3                   	ret    

00800c35 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3b:	8b 40 08             	mov    0x8(%eax),%eax
  800c3e:	8d 50 01             	lea    0x1(%eax),%edx
  800c41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c44:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4a:	8b 10                	mov    (%eax),%edx
  800c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4f:	8b 40 04             	mov    0x4(%eax),%eax
  800c52:	39 c2                	cmp    %eax,%edx
  800c54:	73 12                	jae    800c68 <sprintputch+0x33>
		*b->buf++ = ch;
  800c56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c59:	8b 00                	mov    (%eax),%eax
  800c5b:	8d 48 01             	lea    0x1(%eax),%ecx
  800c5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c61:	89 0a                	mov    %ecx,(%edx)
  800c63:	8b 55 08             	mov    0x8(%ebp),%edx
  800c66:	88 10                	mov    %dl,(%eax)
}
  800c68:	90                   	nop
  800c69:	5d                   	pop    %ebp
  800c6a:	c3                   	ret    

00800c6b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	01 d0                	add    %edx,%eax
  800c82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c90:	74 06                	je     800c98 <vsnprintf+0x2d>
  800c92:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c96:	7f 07                	jg     800c9f <vsnprintf+0x34>
		return -E_INVAL;
  800c98:	b8 03 00 00 00       	mov    $0x3,%eax
  800c9d:	eb 20                	jmp    800cbf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c9f:	ff 75 14             	pushl  0x14(%ebp)
  800ca2:	ff 75 10             	pushl  0x10(%ebp)
  800ca5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ca8:	50                   	push   %eax
  800ca9:	68 35 0c 80 00       	push   $0x800c35
  800cae:	e8 80 fb ff ff       	call   800833 <vprintfmt>
  800cb3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cb9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cbf:	c9                   	leave  
  800cc0:	c3                   	ret    

00800cc1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cc7:	8d 45 10             	lea    0x10(%ebp),%eax
  800cca:	83 c0 04             	add    $0x4,%eax
  800ccd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd3:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd6:	50                   	push   %eax
  800cd7:	ff 75 0c             	pushl  0xc(%ebp)
  800cda:	ff 75 08             	pushl  0x8(%ebp)
  800cdd:	e8 89 ff ff ff       	call   800c6b <vsnprintf>
  800ce2:	83 c4 10             	add    $0x10,%esp
  800ce5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ce8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ceb:	c9                   	leave  
  800cec:	c3                   	ret    

00800ced <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ced:	55                   	push   %ebp
  800cee:	89 e5                	mov    %esp,%ebp
  800cf0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cf3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cfa:	eb 06                	jmp    800d02 <strlen+0x15>
		n++;
  800cfc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cff:	ff 45 08             	incl   0x8(%ebp)
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	8a 00                	mov    (%eax),%al
  800d07:	84 c0                	test   %al,%al
  800d09:	75 f1                	jne    800cfc <strlen+0xf>
		n++;
	return n;
  800d0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d0e:	c9                   	leave  
  800d0f:	c3                   	ret    

00800d10 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
  800d13:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d16:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d1d:	eb 09                	jmp    800d28 <strnlen+0x18>
		n++;
  800d1f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d22:	ff 45 08             	incl   0x8(%ebp)
  800d25:	ff 4d 0c             	decl   0xc(%ebp)
  800d28:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d2c:	74 09                	je     800d37 <strnlen+0x27>
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	8a 00                	mov    (%eax),%al
  800d33:	84 c0                	test   %al,%al
  800d35:	75 e8                	jne    800d1f <strnlen+0xf>
		n++;
	return n;
  800d37:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d3a:	c9                   	leave  
  800d3b:	c3                   	ret    

00800d3c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d48:	90                   	nop
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	8d 50 01             	lea    0x1(%eax),%edx
  800d4f:	89 55 08             	mov    %edx,0x8(%ebp)
  800d52:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d55:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d58:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d5b:	8a 12                	mov    (%edx),%dl
  800d5d:	88 10                	mov    %dl,(%eax)
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	84 c0                	test   %al,%al
  800d63:	75 e4                	jne    800d49 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d65:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d68:	c9                   	leave  
  800d69:	c3                   	ret    

00800d6a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d7d:	eb 1f                	jmp    800d9e <strncpy+0x34>
		*dst++ = *src;
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8d 50 01             	lea    0x1(%eax),%edx
  800d85:	89 55 08             	mov    %edx,0x8(%ebp)
  800d88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d8b:	8a 12                	mov    (%edx),%dl
  800d8d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d92:	8a 00                	mov    (%eax),%al
  800d94:	84 c0                	test   %al,%al
  800d96:	74 03                	je     800d9b <strncpy+0x31>
			src++;
  800d98:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d9b:	ff 45 fc             	incl   -0x4(%ebp)
  800d9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800da4:	72 d9                	jb     800d7f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800da6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800da9:	c9                   	leave  
  800daa:	c3                   	ret    

00800dab <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dab:	55                   	push   %ebp
  800dac:	89 e5                	mov    %esp,%ebp
  800dae:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800db7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbb:	74 30                	je     800ded <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dbd:	eb 16                	jmp    800dd5 <strlcpy+0x2a>
			*dst++ = *src++;
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	8d 50 01             	lea    0x1(%eax),%edx
  800dc5:	89 55 08             	mov    %edx,0x8(%ebp)
  800dc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dcb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dce:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dd1:	8a 12                	mov    (%edx),%dl
  800dd3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dd5:	ff 4d 10             	decl   0x10(%ebp)
  800dd8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ddc:	74 09                	je     800de7 <strlcpy+0x3c>
  800dde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de1:	8a 00                	mov    (%eax),%al
  800de3:	84 c0                	test   %al,%al
  800de5:	75 d8                	jne    800dbf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ded:	8b 55 08             	mov    0x8(%ebp),%edx
  800df0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df3:	29 c2                	sub    %eax,%edx
  800df5:	89 d0                	mov    %edx,%eax
}
  800df7:	c9                   	leave  
  800df8:	c3                   	ret    

00800df9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dfc:	eb 06                	jmp    800e04 <strcmp+0xb>
		p++, q++;
  800dfe:	ff 45 08             	incl   0x8(%ebp)
  800e01:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	8a 00                	mov    (%eax),%al
  800e09:	84 c0                	test   %al,%al
  800e0b:	74 0e                	je     800e1b <strcmp+0x22>
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	8a 10                	mov    (%eax),%dl
  800e12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e15:	8a 00                	mov    (%eax),%al
  800e17:	38 c2                	cmp    %al,%dl
  800e19:	74 e3                	je     800dfe <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	0f b6 d0             	movzbl %al,%edx
  800e23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e26:	8a 00                	mov    (%eax),%al
  800e28:	0f b6 c0             	movzbl %al,%eax
  800e2b:	29 c2                	sub    %eax,%edx
  800e2d:	89 d0                	mov    %edx,%eax
}
  800e2f:	5d                   	pop    %ebp
  800e30:	c3                   	ret    

00800e31 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e34:	eb 09                	jmp    800e3f <strncmp+0xe>
		n--, p++, q++;
  800e36:	ff 4d 10             	decl   0x10(%ebp)
  800e39:	ff 45 08             	incl   0x8(%ebp)
  800e3c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e3f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e43:	74 17                	je     800e5c <strncmp+0x2b>
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	8a 00                	mov    (%eax),%al
  800e4a:	84 c0                	test   %al,%al
  800e4c:	74 0e                	je     800e5c <strncmp+0x2b>
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	8a 10                	mov    (%eax),%dl
  800e53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e56:	8a 00                	mov    (%eax),%al
  800e58:	38 c2                	cmp    %al,%dl
  800e5a:	74 da                	je     800e36 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e5c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e60:	75 07                	jne    800e69 <strncmp+0x38>
		return 0;
  800e62:	b8 00 00 00 00       	mov    $0x0,%eax
  800e67:	eb 14                	jmp    800e7d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	0f b6 d0             	movzbl %al,%edx
  800e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	0f b6 c0             	movzbl %al,%eax
  800e79:	29 c2                	sub    %eax,%edx
  800e7b:	89 d0                	mov    %edx,%eax
}
  800e7d:	5d                   	pop    %ebp
  800e7e:	c3                   	ret    

00800e7f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	83 ec 04             	sub    $0x4,%esp
  800e85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e88:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e8b:	eb 12                	jmp    800e9f <strchr+0x20>
		if (*s == c)
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e90:	8a 00                	mov    (%eax),%al
  800e92:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e95:	75 05                	jne    800e9c <strchr+0x1d>
			return (char *) s;
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	eb 11                	jmp    800ead <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e9c:	ff 45 08             	incl   0x8(%ebp)
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	8a 00                	mov    (%eax),%al
  800ea4:	84 c0                	test   %al,%al
  800ea6:	75 e5                	jne    800e8d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ea8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ead:	c9                   	leave  
  800eae:	c3                   	ret    

00800eaf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	83 ec 04             	sub    $0x4,%esp
  800eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ebb:	eb 0d                	jmp    800eca <strfind+0x1b>
		if (*s == c)
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	8a 00                	mov    (%eax),%al
  800ec2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ec5:	74 0e                	je     800ed5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ec7:	ff 45 08             	incl   0x8(%ebp)
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	8a 00                	mov    (%eax),%al
  800ecf:	84 c0                	test   %al,%al
  800ed1:	75 ea                	jne    800ebd <strfind+0xe>
  800ed3:	eb 01                	jmp    800ed6 <strfind+0x27>
		if (*s == c)
			break;
  800ed5:	90                   	nop
	return (char *) s;
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed9:	c9                   	leave  
  800eda:	c3                   	ret    

00800edb <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
  800ede:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800ee7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800eeb:	76 63                	jbe    800f50 <memset+0x75>
		uint64 data_block = c;
  800eed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef0:	99                   	cltd   
  800ef1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ef4:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800ef7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800efa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800efd:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800f01:	c1 e0 08             	shl    $0x8,%eax
  800f04:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f07:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800f0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f10:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800f14:	c1 e0 10             	shl    $0x10,%eax
  800f17:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f1a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f23:	89 c2                	mov    %eax,%edx
  800f25:	b8 00 00 00 00       	mov    $0x0,%eax
  800f2a:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f2d:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f30:	eb 18                	jmp    800f4a <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f32:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f35:	8d 41 08             	lea    0x8(%ecx),%eax
  800f38:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f41:	89 01                	mov    %eax,(%ecx)
  800f43:	89 51 04             	mov    %edx,0x4(%ecx)
  800f46:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f4a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f4e:	77 e2                	ja     800f32 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f54:	74 23                	je     800f79 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f59:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f5c:	eb 0e                	jmp    800f6c <memset+0x91>
			*p8++ = (uint8)c;
  800f5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f61:	8d 50 01             	lea    0x1(%eax),%edx
  800f64:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f6a:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f72:	89 55 10             	mov    %edx,0x10(%ebp)
  800f75:	85 c0                	test   %eax,%eax
  800f77:	75 e5                	jne    800f5e <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f7c:	c9                   	leave  
  800f7d:	c3                   	ret    

00800f7e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
  800f81:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f90:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f94:	76 24                	jbe    800fba <memcpy+0x3c>
		while(n >= 8){
  800f96:	eb 1c                	jmp    800fb4 <memcpy+0x36>
			*d64 = *s64;
  800f98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9b:	8b 50 04             	mov    0x4(%eax),%edx
  800f9e:	8b 00                	mov    (%eax),%eax
  800fa0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fa3:	89 01                	mov    %eax,(%ecx)
  800fa5:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800fa8:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800fac:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800fb0:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800fb4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fb8:	77 de                	ja     800f98 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800fba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fbe:	74 31                	je     800ff1 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800fc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800fc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800fcc:	eb 16                	jmp    800fe4 <memcpy+0x66>
			*d8++ = *s8++;
  800fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd1:	8d 50 01             	lea    0x1(%eax),%edx
  800fd4:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800fd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fda:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fdd:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800fe0:	8a 12                	mov    (%edx),%dl
  800fe2:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800fe4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fea:	89 55 10             	mov    %edx,0x10(%ebp)
  800fed:	85 c0                	test   %eax,%eax
  800fef:	75 dd                	jne    800fce <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    

00800ff6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801008:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80100e:	73 50                	jae    801060 <memmove+0x6a>
  801010:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801013:	8b 45 10             	mov    0x10(%ebp),%eax
  801016:	01 d0                	add    %edx,%eax
  801018:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80101b:	76 43                	jbe    801060 <memmove+0x6a>
		s += n;
  80101d:	8b 45 10             	mov    0x10(%ebp),%eax
  801020:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801023:	8b 45 10             	mov    0x10(%ebp),%eax
  801026:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801029:	eb 10                	jmp    80103b <memmove+0x45>
			*--d = *--s;
  80102b:	ff 4d f8             	decl   -0x8(%ebp)
  80102e:	ff 4d fc             	decl   -0x4(%ebp)
  801031:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801034:	8a 10                	mov    (%eax),%dl
  801036:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801039:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80103b:	8b 45 10             	mov    0x10(%ebp),%eax
  80103e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801041:	89 55 10             	mov    %edx,0x10(%ebp)
  801044:	85 c0                	test   %eax,%eax
  801046:	75 e3                	jne    80102b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801048:	eb 23                	jmp    80106d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80104a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104d:	8d 50 01             	lea    0x1(%eax),%edx
  801050:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801053:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801056:	8d 4a 01             	lea    0x1(%edx),%ecx
  801059:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80105c:	8a 12                	mov    (%edx),%dl
  80105e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801060:	8b 45 10             	mov    0x10(%ebp),%eax
  801063:	8d 50 ff             	lea    -0x1(%eax),%edx
  801066:	89 55 10             	mov    %edx,0x10(%ebp)
  801069:	85 c0                	test   %eax,%eax
  80106b:	75 dd                	jne    80104a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801070:	c9                   	leave  
  801071:	c3                   	ret    

00801072 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
  801075:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80107e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801081:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801084:	eb 2a                	jmp    8010b0 <memcmp+0x3e>
		if (*s1 != *s2)
  801086:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801089:	8a 10                	mov    (%eax),%dl
  80108b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108e:	8a 00                	mov    (%eax),%al
  801090:	38 c2                	cmp    %al,%dl
  801092:	74 16                	je     8010aa <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801094:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801097:	8a 00                	mov    (%eax),%al
  801099:	0f b6 d0             	movzbl %al,%edx
  80109c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109f:	8a 00                	mov    (%eax),%al
  8010a1:	0f b6 c0             	movzbl %al,%eax
  8010a4:	29 c2                	sub    %eax,%edx
  8010a6:	89 d0                	mov    %edx,%eax
  8010a8:	eb 18                	jmp    8010c2 <memcmp+0x50>
		s1++, s2++;
  8010aa:	ff 45 fc             	incl   -0x4(%ebp)
  8010ad:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b9:	85 c0                	test   %eax,%eax
  8010bb:	75 c9                	jne    801086 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010c2:	c9                   	leave  
  8010c3:	c3                   	ret    

008010c4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8010cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d0:	01 d0                	add    %edx,%eax
  8010d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010d5:	eb 15                	jmp    8010ec <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8a 00                	mov    (%eax),%al
  8010dc:	0f b6 d0             	movzbl %al,%edx
  8010df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e2:	0f b6 c0             	movzbl %al,%eax
  8010e5:	39 c2                	cmp    %eax,%edx
  8010e7:	74 0d                	je     8010f6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010e9:	ff 45 08             	incl   0x8(%ebp)
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010f2:	72 e3                	jb     8010d7 <memfind+0x13>
  8010f4:	eb 01                	jmp    8010f7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010f6:	90                   	nop
	return (void *) s;
  8010f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010fa:	c9                   	leave  
  8010fb:	c3                   	ret    

008010fc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801102:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801109:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801110:	eb 03                	jmp    801115 <strtol+0x19>
		s++;
  801112:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	8a 00                	mov    (%eax),%al
  80111a:	3c 20                	cmp    $0x20,%al
  80111c:	74 f4                	je     801112 <strtol+0x16>
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	8a 00                	mov    (%eax),%al
  801123:	3c 09                	cmp    $0x9,%al
  801125:	74 eb                	je     801112 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
  80112a:	8a 00                	mov    (%eax),%al
  80112c:	3c 2b                	cmp    $0x2b,%al
  80112e:	75 05                	jne    801135 <strtol+0x39>
		s++;
  801130:	ff 45 08             	incl   0x8(%ebp)
  801133:	eb 13                	jmp    801148 <strtol+0x4c>
	else if (*s == '-')
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8a 00                	mov    (%eax),%al
  80113a:	3c 2d                	cmp    $0x2d,%al
  80113c:	75 0a                	jne    801148 <strtol+0x4c>
		s++, neg = 1;
  80113e:	ff 45 08             	incl   0x8(%ebp)
  801141:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801148:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80114c:	74 06                	je     801154 <strtol+0x58>
  80114e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801152:	75 20                	jne    801174 <strtol+0x78>
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	3c 30                	cmp    $0x30,%al
  80115b:	75 17                	jne    801174 <strtol+0x78>
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	40                   	inc    %eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	3c 78                	cmp    $0x78,%al
  801165:	75 0d                	jne    801174 <strtol+0x78>
		s += 2, base = 16;
  801167:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80116b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801172:	eb 28                	jmp    80119c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801174:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801178:	75 15                	jne    80118f <strtol+0x93>
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
  80117d:	8a 00                	mov    (%eax),%al
  80117f:	3c 30                	cmp    $0x30,%al
  801181:	75 0c                	jne    80118f <strtol+0x93>
		s++, base = 8;
  801183:	ff 45 08             	incl   0x8(%ebp)
  801186:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80118d:	eb 0d                	jmp    80119c <strtol+0xa0>
	else if (base == 0)
  80118f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801193:	75 07                	jne    80119c <strtol+0xa0>
		base = 10;
  801195:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	8a 00                	mov    (%eax),%al
  8011a1:	3c 2f                	cmp    $0x2f,%al
  8011a3:	7e 19                	jle    8011be <strtol+0xc2>
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	3c 39                	cmp    $0x39,%al
  8011ac:	7f 10                	jg     8011be <strtol+0xc2>
			dig = *s - '0';
  8011ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b1:	8a 00                	mov    (%eax),%al
  8011b3:	0f be c0             	movsbl %al,%eax
  8011b6:	83 e8 30             	sub    $0x30,%eax
  8011b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011bc:	eb 42                	jmp    801200 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	8a 00                	mov    (%eax),%al
  8011c3:	3c 60                	cmp    $0x60,%al
  8011c5:	7e 19                	jle    8011e0 <strtol+0xe4>
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	3c 7a                	cmp    $0x7a,%al
  8011ce:	7f 10                	jg     8011e0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	0f be c0             	movsbl %al,%eax
  8011d8:	83 e8 57             	sub    $0x57,%eax
  8011db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011de:	eb 20                	jmp    801200 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	3c 40                	cmp    $0x40,%al
  8011e7:	7e 39                	jle    801222 <strtol+0x126>
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	3c 5a                	cmp    $0x5a,%al
  8011f0:	7f 30                	jg     801222 <strtol+0x126>
			dig = *s - 'A' + 10;
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	0f be c0             	movsbl %al,%eax
  8011fa:	83 e8 37             	sub    $0x37,%eax
  8011fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801203:	3b 45 10             	cmp    0x10(%ebp),%eax
  801206:	7d 19                	jge    801221 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801208:	ff 45 08             	incl   0x8(%ebp)
  80120b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801212:	89 c2                	mov    %eax,%edx
  801214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801217:	01 d0                	add    %edx,%eax
  801219:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80121c:	e9 7b ff ff ff       	jmp    80119c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801221:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801222:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801226:	74 08                	je     801230 <strtol+0x134>
		*endptr = (char *) s;
  801228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122b:	8b 55 08             	mov    0x8(%ebp),%edx
  80122e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801230:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801234:	74 07                	je     80123d <strtol+0x141>
  801236:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801239:	f7 d8                	neg    %eax
  80123b:	eb 03                	jmp    801240 <strtol+0x144>
  80123d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <ltostr>:

void
ltostr(long value, char *str)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801248:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80124f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801256:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80125a:	79 13                	jns    80126f <ltostr+0x2d>
	{
		neg = 1;
  80125c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801263:	8b 45 0c             	mov    0xc(%ebp),%eax
  801266:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801269:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80126c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801277:	99                   	cltd   
  801278:	f7 f9                	idiv   %ecx
  80127a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80127d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801280:	8d 50 01             	lea    0x1(%eax),%edx
  801283:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801286:	89 c2                	mov    %eax,%edx
  801288:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128b:	01 d0                	add    %edx,%eax
  80128d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801290:	83 c2 30             	add    $0x30,%edx
  801293:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801295:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801298:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80129d:	f7 e9                	imul   %ecx
  80129f:	c1 fa 02             	sar    $0x2,%edx
  8012a2:	89 c8                	mov    %ecx,%eax
  8012a4:	c1 f8 1f             	sar    $0x1f,%eax
  8012a7:	29 c2                	sub    %eax,%edx
  8012a9:	89 d0                	mov    %edx,%eax
  8012ab:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8012ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012b2:	75 bb                	jne    80126f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012be:	48                   	dec    %eax
  8012bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8012c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012c6:	74 3d                	je     801305 <ltostr+0xc3>
		start = 1 ;
  8012c8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8012cf:	eb 34                	jmp    801305 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8012d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d7:	01 d0                	add    %edx,%eax
  8012d9:	8a 00                	mov    (%eax),%al
  8012db:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e4:	01 c2                	add    %eax,%edx
  8012e6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ec:	01 c8                	add    %ecx,%eax
  8012ee:	8a 00                	mov    (%eax),%al
  8012f0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f8:	01 c2                	add    %eax,%edx
  8012fa:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012fd:	88 02                	mov    %al,(%edx)
		start++ ;
  8012ff:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801302:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801308:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80130b:	7c c4                	jl     8012d1 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80130d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801310:	8b 45 0c             	mov    0xc(%ebp),%eax
  801313:	01 d0                	add    %edx,%eax
  801315:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801318:	90                   	nop
  801319:	c9                   	leave  
  80131a:	c3                   	ret    

0080131b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80131b:	55                   	push   %ebp
  80131c:	89 e5                	mov    %esp,%ebp
  80131e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801321:	ff 75 08             	pushl  0x8(%ebp)
  801324:	e8 c4 f9 ff ff       	call   800ced <strlen>
  801329:	83 c4 04             	add    $0x4,%esp
  80132c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80132f:	ff 75 0c             	pushl  0xc(%ebp)
  801332:	e8 b6 f9 ff ff       	call   800ced <strlen>
  801337:	83 c4 04             	add    $0x4,%esp
  80133a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80133d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801344:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80134b:	eb 17                	jmp    801364 <strcconcat+0x49>
		final[s] = str1[s] ;
  80134d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801350:	8b 45 10             	mov    0x10(%ebp),%eax
  801353:	01 c2                	add    %eax,%edx
  801355:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
  80135b:	01 c8                	add    %ecx,%eax
  80135d:	8a 00                	mov    (%eax),%al
  80135f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801361:	ff 45 fc             	incl   -0x4(%ebp)
  801364:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801367:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80136a:	7c e1                	jl     80134d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80136c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801373:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80137a:	eb 1f                	jmp    80139b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80137c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137f:	8d 50 01             	lea    0x1(%eax),%edx
  801382:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801385:	89 c2                	mov    %eax,%edx
  801387:	8b 45 10             	mov    0x10(%ebp),%eax
  80138a:	01 c2                	add    %eax,%edx
  80138c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80138f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801392:	01 c8                	add    %ecx,%eax
  801394:	8a 00                	mov    (%eax),%al
  801396:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801398:	ff 45 f8             	incl   -0x8(%ebp)
  80139b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80139e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013a1:	7c d9                	jl     80137c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a9:	01 d0                	add    %edx,%eax
  8013ab:	c6 00 00             	movb   $0x0,(%eax)
}
  8013ae:	90                   	nop
  8013af:	c9                   	leave  
  8013b0:	c3                   	ret    

008013b1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013b1:	55                   	push   %ebp
  8013b2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c0:	8b 00                	mov    (%eax),%eax
  8013c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cc:	01 d0                	add    %edx,%eax
  8013ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013d4:	eb 0c                	jmp    8013e2 <strsplit+0x31>
			*string++ = 0;
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	8d 50 01             	lea    0x1(%eax),%edx
  8013dc:	89 55 08             	mov    %edx,0x8(%ebp)
  8013df:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	8a 00                	mov    (%eax),%al
  8013e7:	84 c0                	test   %al,%al
  8013e9:	74 18                	je     801403 <strsplit+0x52>
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	8a 00                	mov    (%eax),%al
  8013f0:	0f be c0             	movsbl %al,%eax
  8013f3:	50                   	push   %eax
  8013f4:	ff 75 0c             	pushl  0xc(%ebp)
  8013f7:	e8 83 fa ff ff       	call   800e7f <strchr>
  8013fc:	83 c4 08             	add    $0x8,%esp
  8013ff:	85 c0                	test   %eax,%eax
  801401:	75 d3                	jne    8013d6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	84 c0                	test   %al,%al
  80140a:	74 5a                	je     801466 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80140c:	8b 45 14             	mov    0x14(%ebp),%eax
  80140f:	8b 00                	mov    (%eax),%eax
  801411:	83 f8 0f             	cmp    $0xf,%eax
  801414:	75 07                	jne    80141d <strsplit+0x6c>
		{
			return 0;
  801416:	b8 00 00 00 00       	mov    $0x0,%eax
  80141b:	eb 66                	jmp    801483 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80141d:	8b 45 14             	mov    0x14(%ebp),%eax
  801420:	8b 00                	mov    (%eax),%eax
  801422:	8d 48 01             	lea    0x1(%eax),%ecx
  801425:	8b 55 14             	mov    0x14(%ebp),%edx
  801428:	89 0a                	mov    %ecx,(%edx)
  80142a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801431:	8b 45 10             	mov    0x10(%ebp),%eax
  801434:	01 c2                	add    %eax,%edx
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80143b:	eb 03                	jmp    801440 <strsplit+0x8f>
			string++;
  80143d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	84 c0                	test   %al,%al
  801447:	74 8b                	je     8013d4 <strsplit+0x23>
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	0f be c0             	movsbl %al,%eax
  801451:	50                   	push   %eax
  801452:	ff 75 0c             	pushl  0xc(%ebp)
  801455:	e8 25 fa ff ff       	call   800e7f <strchr>
  80145a:	83 c4 08             	add    $0x8,%esp
  80145d:	85 c0                	test   %eax,%eax
  80145f:	74 dc                	je     80143d <strsplit+0x8c>
			string++;
	}
  801461:	e9 6e ff ff ff       	jmp    8013d4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801466:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801467:	8b 45 14             	mov    0x14(%ebp),%eax
  80146a:	8b 00                	mov    (%eax),%eax
  80146c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801473:	8b 45 10             	mov    0x10(%ebp),%eax
  801476:	01 d0                	add    %edx,%eax
  801478:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80147e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801483:	c9                   	leave  
  801484:	c3                   	ret    

00801485 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801491:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801498:	eb 4a                	jmp    8014e4 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80149a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	01 c2                	add    %eax,%edx
  8014a2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a8:	01 c8                	add    %ecx,%eax
  8014aa:	8a 00                	mov    (%eax),%al
  8014ac:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8014ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b4:	01 d0                	add    %edx,%eax
  8014b6:	8a 00                	mov    (%eax),%al
  8014b8:	3c 40                	cmp    $0x40,%al
  8014ba:	7e 25                	jle    8014e1 <str2lower+0x5c>
  8014bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c2:	01 d0                	add    %edx,%eax
  8014c4:	8a 00                	mov    (%eax),%al
  8014c6:	3c 5a                	cmp    $0x5a,%al
  8014c8:	7f 17                	jg     8014e1 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8014ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d0:	01 d0                	add    %edx,%eax
  8014d2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d8:	01 ca                	add    %ecx,%edx
  8014da:	8a 12                	mov    (%edx),%dl
  8014dc:	83 c2 20             	add    $0x20,%edx
  8014df:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8014e1:	ff 45 fc             	incl   -0x4(%ebp)
  8014e4:	ff 75 0c             	pushl  0xc(%ebp)
  8014e7:	e8 01 f8 ff ff       	call   800ced <strlen>
  8014ec:	83 c4 04             	add    $0x4,%esp
  8014ef:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014f2:	7f a6                	jg     80149a <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8014ff:	a1 08 30 80 00       	mov    0x803008,%eax
  801504:	85 c0                	test   %eax,%eax
  801506:	74 42                	je     80154a <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801508:	83 ec 08             	sub    $0x8,%esp
  80150b:	68 00 00 00 82       	push   $0x82000000
  801510:	68 00 00 00 80       	push   $0x80000000
  801515:	e8 8c 07 00 00       	call   801ca6 <initialize_dynamic_allocator>
  80151a:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80151d:	e8 e7 05 00 00       	call   801b09 <sys_get_uheap_strategy>
  801522:	a3 60 b0 81 00       	mov    %eax,0x81b060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801527:	a1 40 30 80 00       	mov    0x803040,%eax
  80152c:	05 00 10 00 00       	add    $0x1000,%eax
  801531:	a3 10 b1 81 00       	mov    %eax,0x81b110
		uheapPageAllocBreak = uheapPageAllocStart;
  801536:	a1 10 b1 81 00       	mov    0x81b110,%eax
  80153b:	a3 68 b0 81 00       	mov    %eax,0x81b068

		__firstTimeFlag = 0;
  801540:	c7 05 08 30 80 00 00 	movl   $0x0,0x803008
  801547:	00 00 00 
	}
}
  80154a:	90                   	nop
  80154b:	c9                   	leave  
  80154c:	c3                   	ret    

0080154d <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
  801550:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801553:	8b 45 08             	mov    0x8(%ebp),%eax
  801556:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801561:	83 ec 08             	sub    $0x8,%esp
  801564:	68 06 04 00 00       	push   $0x406
  801569:	50                   	push   %eax
  80156a:	e8 e4 01 00 00       	call   801753 <__sys_allocate_page>
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801575:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801579:	79 14                	jns    80158f <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  80157b:	83 ec 04             	sub    $0x4,%esp
  80157e:	68 a8 28 80 00       	push   $0x8028a8
  801583:	6a 1f                	push   $0x1f
  801585:	68 e4 28 80 00       	push   $0x8028e4
  80158a:	e8 b7 ed ff ff       	call   800346 <_panic>
	return 0;
  80158f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015aa:	83 ec 0c             	sub    $0xc,%esp
  8015ad:	50                   	push   %eax
  8015ae:	e8 e7 01 00 00       	call   80179a <__sys_unmap_frame>
  8015b3:	83 c4 10             	add    $0x10,%esp
  8015b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8015b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015bd:	79 14                	jns    8015d3 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8015bf:	83 ec 04             	sub    $0x4,%esp
  8015c2:	68 f0 28 80 00       	push   $0x8028f0
  8015c7:	6a 2a                	push   $0x2a
  8015c9:	68 e4 28 80 00       	push   $0x8028e4
  8015ce:	e8 73 ed ff ff       	call   800346 <_panic>
}
  8015d3:	90                   	nop
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    

008015d6 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8015dc:	e8 18 ff ff ff       	call   8014f9 <uheap_init>
	if (size == 0) return NULL ;
  8015e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015e5:	75 07                	jne    8015ee <malloc+0x18>
  8015e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ec:	eb 14                	jmp    801602 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  8015ee:	83 ec 04             	sub    $0x4,%esp
  8015f1:	68 30 29 80 00       	push   $0x802930
  8015f6:	6a 3e                	push   $0x3e
  8015f8:	68 e4 28 80 00       	push   $0x8028e4
  8015fd:	e8 44 ed ff ff       	call   800346 <_panic>
}
  801602:	c9                   	leave  
  801603:	c3                   	ret    

00801604 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
  801607:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  80160a:	83 ec 04             	sub    $0x4,%esp
  80160d:	68 58 29 80 00       	push   $0x802958
  801612:	6a 49                	push   $0x49
  801614:	68 e4 28 80 00       	push   $0x8028e4
  801619:	e8 28 ed ff ff       	call   800346 <_panic>

0080161e <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	83 ec 18             	sub    $0x18,%esp
  801624:	8b 45 10             	mov    0x10(%ebp),%eax
  801627:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80162a:	e8 ca fe ff ff       	call   8014f9 <uheap_init>
	if (size == 0) return NULL ;
  80162f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801633:	75 07                	jne    80163c <smalloc+0x1e>
  801635:	b8 00 00 00 00       	mov    $0x0,%eax
  80163a:	eb 14                	jmp    801650 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  80163c:	83 ec 04             	sub    $0x4,%esp
  80163f:	68 7c 29 80 00       	push   $0x80297c
  801644:	6a 5a                	push   $0x5a
  801646:	68 e4 28 80 00       	push   $0x8028e4
  80164b:	e8 f6 ec ff ff       	call   800346 <_panic>
}
  801650:	c9                   	leave  
  801651:	c3                   	ret    

00801652 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
  801655:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801658:	e8 9c fe ff ff       	call   8014f9 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  80165d:	83 ec 04             	sub    $0x4,%esp
  801660:	68 a4 29 80 00       	push   $0x8029a4
  801665:	6a 6a                	push   $0x6a
  801667:	68 e4 28 80 00       	push   $0x8028e4
  80166c:	e8 d5 ec ff ff       	call   800346 <_panic>

00801671 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
  801674:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801677:	e8 7d fe ff ff       	call   8014f9 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80167c:	83 ec 04             	sub    $0x4,%esp
  80167f:	68 c8 29 80 00       	push   $0x8029c8
  801684:	68 88 00 00 00       	push   $0x88
  801689:	68 e4 28 80 00       	push   $0x8028e4
  80168e:	e8 b3 ec ff ff       	call   800346 <_panic>

00801693 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801699:	83 ec 04             	sub    $0x4,%esp
  80169c:	68 f0 29 80 00       	push   $0x8029f0
  8016a1:	68 9b 00 00 00       	push   $0x9b
  8016a6:	68 e4 28 80 00       	push   $0x8028e4
  8016ab:	e8 96 ec ff ff       	call   800346 <_panic>

008016b0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	57                   	push   %edi
  8016b4:	56                   	push   %esi
  8016b5:	53                   	push   %ebx
  8016b6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016c2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016c5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016c8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016cb:	cd 30                	int    $0x30
  8016cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8016d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016d3:	83 c4 10             	add    $0x10,%esp
  8016d6:	5b                   	pop    %ebx
  8016d7:	5e                   	pop    %esi
  8016d8:	5f                   	pop    %edi
  8016d9:	5d                   	pop    %ebp
  8016da:	c3                   	ret    

008016db <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	83 ec 04             	sub    $0x4,%esp
  8016e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8016e7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016ea:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f1:	6a 00                	push   $0x0
  8016f3:	51                   	push   %ecx
  8016f4:	52                   	push   %edx
  8016f5:	ff 75 0c             	pushl  0xc(%ebp)
  8016f8:	50                   	push   %eax
  8016f9:	6a 00                	push   $0x0
  8016fb:	e8 b0 ff ff ff       	call   8016b0 <syscall>
  801700:	83 c4 18             	add    $0x18,%esp
}
  801703:	90                   	nop
  801704:	c9                   	leave  
  801705:	c3                   	ret    

00801706 <sys_cgetc>:

int
sys_cgetc(void)
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 02                	push   $0x2
  801715:	e8 96 ff ff ff       	call   8016b0 <syscall>
  80171a:	83 c4 18             	add    $0x18,%esp
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 03                	push   $0x3
  80172e:	e8 7d ff ff ff       	call   8016b0 <syscall>
  801733:	83 c4 18             	add    $0x18,%esp
}
  801736:	90                   	nop
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 04                	push   $0x4
  801748:	e8 63 ff ff ff       	call   8016b0 <syscall>
  80174d:	83 c4 18             	add    $0x18,%esp
}
  801750:	90                   	nop
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801756:	8b 55 0c             	mov    0xc(%ebp),%edx
  801759:	8b 45 08             	mov    0x8(%ebp),%eax
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	52                   	push   %edx
  801763:	50                   	push   %eax
  801764:	6a 08                	push   $0x8
  801766:	e8 45 ff ff ff       	call   8016b0 <syscall>
  80176b:	83 c4 18             	add    $0x18,%esp
}
  80176e:	c9                   	leave  
  80176f:	c3                   	ret    

00801770 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	56                   	push   %esi
  801774:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801775:	8b 75 18             	mov    0x18(%ebp),%esi
  801778:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80177b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80177e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801781:	8b 45 08             	mov    0x8(%ebp),%eax
  801784:	56                   	push   %esi
  801785:	53                   	push   %ebx
  801786:	51                   	push   %ecx
  801787:	52                   	push   %edx
  801788:	50                   	push   %eax
  801789:	6a 09                	push   $0x9
  80178b:	e8 20 ff ff ff       	call   8016b0 <syscall>
  801790:	83 c4 18             	add    $0x18,%esp
}
  801793:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801796:	5b                   	pop    %ebx
  801797:	5e                   	pop    %esi
  801798:	5d                   	pop    %ebp
  801799:	c3                   	ret    

0080179a <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	ff 75 08             	pushl  0x8(%ebp)
  8017a8:	6a 0a                	push   $0xa
  8017aa:	e8 01 ff ff ff       	call   8016b0 <syscall>
  8017af:	83 c4 18             	add    $0x18,%esp
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	ff 75 0c             	pushl  0xc(%ebp)
  8017c0:	ff 75 08             	pushl  0x8(%ebp)
  8017c3:	6a 0b                	push   $0xb
  8017c5:	e8 e6 fe ff ff       	call   8016b0 <syscall>
  8017ca:	83 c4 18             	add    $0x18,%esp
}
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 0c                	push   $0xc
  8017de:	e8 cd fe ff ff       	call   8016b0 <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
}
  8017e6:	c9                   	leave  
  8017e7:	c3                   	ret    

008017e8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 0d                	push   $0xd
  8017f7:	e8 b4 fe ff ff       	call   8016b0 <syscall>
  8017fc:	83 c4 18             	add    $0x18,%esp
}
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    

00801801 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 0e                	push   $0xe
  801810:	e8 9b fe ff ff       	call   8016b0 <syscall>
  801815:	83 c4 18             	add    $0x18,%esp
}
  801818:	c9                   	leave  
  801819:	c3                   	ret    

0080181a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 0f                	push   $0xf
  801829:	e8 82 fe ff ff       	call   8016b0 <syscall>
  80182e:	83 c4 18             	add    $0x18,%esp
}
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	ff 75 08             	pushl  0x8(%ebp)
  801841:	6a 10                	push   $0x10
  801843:	e8 68 fe ff ff       	call   8016b0 <syscall>
  801848:	83 c4 18             	add    $0x18,%esp
}
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 11                	push   $0x11
  80185c:	e8 4f fe ff ff       	call   8016b0 <syscall>
  801861:	83 c4 18             	add    $0x18,%esp
}
  801864:	90                   	nop
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <sys_cputc>:

void
sys_cputc(const char c)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	83 ec 04             	sub    $0x4,%esp
  80186d:	8b 45 08             	mov    0x8(%ebp),%eax
  801870:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801873:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	50                   	push   %eax
  801880:	6a 01                	push   $0x1
  801882:	e8 29 fe ff ff       	call   8016b0 <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
}
  80188a:	90                   	nop
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 14                	push   $0x14
  80189c:	e8 0f fe ff ff       	call   8016b0 <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
}
  8018a4:	90                   	nop
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
  8018aa:	83 ec 04             	sub    $0x4,%esp
  8018ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018b3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018b6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bd:	6a 00                	push   $0x0
  8018bf:	51                   	push   %ecx
  8018c0:	52                   	push   %edx
  8018c1:	ff 75 0c             	pushl  0xc(%ebp)
  8018c4:	50                   	push   %eax
  8018c5:	6a 15                	push   $0x15
  8018c7:	e8 e4 fd ff ff       	call   8016b0 <syscall>
  8018cc:	83 c4 18             	add    $0x18,%esp
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	52                   	push   %edx
  8018e1:	50                   	push   %eax
  8018e2:	6a 16                	push   $0x16
  8018e4:	e8 c7 fd ff ff       	call   8016b0 <syscall>
  8018e9:	83 c4 18             	add    $0x18,%esp
}
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    

008018ee <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	51                   	push   %ecx
  8018ff:	52                   	push   %edx
  801900:	50                   	push   %eax
  801901:	6a 17                	push   $0x17
  801903:	e8 a8 fd ff ff       	call   8016b0 <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
}
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801910:	8b 55 0c             	mov    0xc(%ebp),%edx
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	52                   	push   %edx
  80191d:	50                   	push   %eax
  80191e:	6a 18                	push   $0x18
  801920:	e8 8b fd ff ff       	call   8016b0 <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80192d:	8b 45 08             	mov    0x8(%ebp),%eax
  801930:	6a 00                	push   $0x0
  801932:	ff 75 14             	pushl  0x14(%ebp)
  801935:	ff 75 10             	pushl  0x10(%ebp)
  801938:	ff 75 0c             	pushl  0xc(%ebp)
  80193b:	50                   	push   %eax
  80193c:	6a 19                	push   $0x19
  80193e:	e8 6d fd ff ff       	call   8016b0 <syscall>
  801943:	83 c4 18             	add    $0x18,%esp
}
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80194b:	8b 45 08             	mov    0x8(%ebp),%eax
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	50                   	push   %eax
  801957:	6a 1a                	push   $0x1a
  801959:	e8 52 fd ff ff       	call   8016b0 <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
}
  801961:	90                   	nop
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801967:	8b 45 08             	mov    0x8(%ebp),%eax
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	50                   	push   %eax
  801973:	6a 1b                	push   $0x1b
  801975:	e8 36 fd ff ff       	call   8016b0 <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 05                	push   $0x5
  80198e:	e8 1d fd ff ff       	call   8016b0 <syscall>
  801993:	83 c4 18             	add    $0x18,%esp
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 06                	push   $0x6
  8019a7:	e8 04 fd ff ff       	call   8016b0 <syscall>
  8019ac:	83 c4 18             	add    $0x18,%esp
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 07                	push   $0x7
  8019c0:	e8 eb fc ff ff       	call   8016b0 <syscall>
  8019c5:	83 c4 18             	add    $0x18,%esp
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sys_exit_env>:


void sys_exit_env(void)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 1c                	push   $0x1c
  8019d9:	e8 d2 fc ff ff       	call   8016b0 <syscall>
  8019de:	83 c4 18             	add    $0x18,%esp
}
  8019e1:	90                   	nop
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019ea:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019ed:	8d 50 04             	lea    0x4(%eax),%edx
  8019f0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	52                   	push   %edx
  8019fa:	50                   	push   %eax
  8019fb:	6a 1d                	push   $0x1d
  8019fd:	e8 ae fc ff ff       	call   8016b0 <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
	return result;
  801a05:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a08:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a0b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a0e:	89 01                	mov    %eax,(%ecx)
  801a10:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	c9                   	leave  
  801a17:	c2 04 00             	ret    $0x4

00801a1a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	ff 75 10             	pushl  0x10(%ebp)
  801a24:	ff 75 0c             	pushl  0xc(%ebp)
  801a27:	ff 75 08             	pushl  0x8(%ebp)
  801a2a:	6a 13                	push   $0x13
  801a2c:	e8 7f fc ff ff       	call   8016b0 <syscall>
  801a31:	83 c4 18             	add    $0x18,%esp
	return ;
  801a34:	90                   	nop
}
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 1e                	push   $0x1e
  801a46:	e8 65 fc ff ff       	call   8016b0 <syscall>
  801a4b:	83 c4 18             	add    $0x18,%esp
}
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	83 ec 04             	sub    $0x4,%esp
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
  801a59:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a5c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	50                   	push   %eax
  801a69:	6a 1f                	push   $0x1f
  801a6b:	e8 40 fc ff ff       	call   8016b0 <syscall>
  801a70:	83 c4 18             	add    $0x18,%esp
	return ;
  801a73:	90                   	nop
}
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <rsttst>:
void rsttst()
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 21                	push   $0x21
  801a85:	e8 26 fc ff ff       	call   8016b0 <syscall>
  801a8a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a8d:	90                   	nop
}
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
  801a93:	83 ec 04             	sub    $0x4,%esp
  801a96:	8b 45 14             	mov    0x14(%ebp),%eax
  801a99:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a9c:	8b 55 18             	mov    0x18(%ebp),%edx
  801a9f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801aa3:	52                   	push   %edx
  801aa4:	50                   	push   %eax
  801aa5:	ff 75 10             	pushl  0x10(%ebp)
  801aa8:	ff 75 0c             	pushl  0xc(%ebp)
  801aab:	ff 75 08             	pushl  0x8(%ebp)
  801aae:	6a 20                	push   $0x20
  801ab0:	e8 fb fb ff ff       	call   8016b0 <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab8:	90                   	nop
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <chktst>:
void chktst(uint32 n)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	ff 75 08             	pushl  0x8(%ebp)
  801ac9:	6a 22                	push   $0x22
  801acb:	e8 e0 fb ff ff       	call   8016b0 <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad3:	90                   	nop
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <inctst>:

void inctst()
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 23                	push   $0x23
  801ae5:	e8 c6 fb ff ff       	call   8016b0 <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
	return ;
  801aed:	90                   	nop
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <gettst>:
uint32 gettst()
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 24                	push   $0x24
  801aff:	e8 ac fb ff ff       	call   8016b0 <syscall>
  801b04:	83 c4 18             	add    $0x18,%esp
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 25                	push   $0x25
  801b18:	e8 93 fb ff ff       	call   8016b0 <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
  801b20:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801b25:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b32:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	ff 75 08             	pushl  0x8(%ebp)
  801b42:	6a 26                	push   $0x26
  801b44:	e8 67 fb ff ff       	call   8016b0 <syscall>
  801b49:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4c:	90                   	nop
}
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b53:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b56:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	6a 00                	push   $0x0
  801b61:	53                   	push   %ebx
  801b62:	51                   	push   %ecx
  801b63:	52                   	push   %edx
  801b64:	50                   	push   %eax
  801b65:	6a 27                	push   $0x27
  801b67:	e8 44 fb ff ff       	call   8016b0 <syscall>
  801b6c:	83 c4 18             	add    $0x18,%esp
}
  801b6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	52                   	push   %edx
  801b84:	50                   	push   %eax
  801b85:	6a 28                	push   $0x28
  801b87:	e8 24 fb ff ff       	call   8016b0 <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b94:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9d:	6a 00                	push   $0x0
  801b9f:	51                   	push   %ecx
  801ba0:	ff 75 10             	pushl  0x10(%ebp)
  801ba3:	52                   	push   %edx
  801ba4:	50                   	push   %eax
  801ba5:	6a 29                	push   $0x29
  801ba7:	e8 04 fb ff ff       	call   8016b0 <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	ff 75 10             	pushl  0x10(%ebp)
  801bbb:	ff 75 0c             	pushl  0xc(%ebp)
  801bbe:	ff 75 08             	pushl  0x8(%ebp)
  801bc1:	6a 12                	push   $0x12
  801bc3:	e8 e8 fa ff ff       	call   8016b0 <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bcb:	90                   	nop
}
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	52                   	push   %edx
  801bde:	50                   	push   %eax
  801bdf:	6a 2a                	push   $0x2a
  801be1:	e8 ca fa ff ff       	call   8016b0 <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
	return;
  801be9:	90                   	nop
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 2b                	push   $0x2b
  801bfb:	e8 b0 fa ff ff       	call   8016b0 <syscall>
  801c00:	83 c4 18             	add    $0x18,%esp
}
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	ff 75 0c             	pushl  0xc(%ebp)
  801c11:	ff 75 08             	pushl  0x8(%ebp)
  801c14:	6a 2d                	push   $0x2d
  801c16:	e8 95 fa ff ff       	call   8016b0 <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
	return;
  801c1e:	90                   	nop
}
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	ff 75 0c             	pushl  0xc(%ebp)
  801c2d:	ff 75 08             	pushl  0x8(%ebp)
  801c30:	6a 2c                	push   $0x2c
  801c32:	e8 79 fa ff ff       	call   8016b0 <syscall>
  801c37:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3a:	90                   	nop
}
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
  801c40:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801c43:	83 ec 04             	sub    $0x4,%esp
  801c46:	68 14 2a 80 00       	push   $0x802a14
  801c4b:	68 25 01 00 00       	push   $0x125
  801c50:	68 47 2a 80 00       	push   $0x802a47
  801c55:	e8 ec e6 ff ff       	call   800346 <_panic>

00801c5a <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801c60:	8b 45 08             	mov    0x8(%ebp),%eax
  801c63:	ba 60 30 80 00       	mov    $0x803060,%edx
  801c68:	29 d0                	sub    %edx,%eax
  801c6a:	c1 f8 02             	sar    $0x2,%eax
  801c6d:	89 c2                	mov    %eax,%edx
  801c6f:	89 d0                	mov    %edx,%eax
  801c71:	c1 e0 02             	shl    $0x2,%eax
  801c74:	01 d0                	add    %edx,%eax
  801c76:	c1 e0 02             	shl    $0x2,%eax
  801c79:	01 d0                	add    %edx,%eax
  801c7b:	c1 e0 02             	shl    $0x2,%eax
  801c7e:	01 d0                	add    %edx,%eax
  801c80:	89 c1                	mov    %eax,%ecx
  801c82:	c1 e1 08             	shl    $0x8,%ecx
  801c85:	01 c8                	add    %ecx,%eax
  801c87:	89 c1                	mov    %eax,%ecx
  801c89:	c1 e1 10             	shl    $0x10,%ecx
  801c8c:	01 c8                	add    %ecx,%eax
  801c8e:	01 c0                	add    %eax,%eax
  801c90:	01 d0                	add    %edx,%eax
  801c92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801c95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c98:	c1 e0 0c             	shl    $0xc,%eax
  801c9b:	89 c2                	mov    %eax,%edx
  801c9d:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801ca2:	01 d0                	add    %edx,%eax
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801cac:	8b 45 08             	mov    0x8(%ebp),%eax
  801caf:	05 00 00 00 02       	add    $0x2000000,%eax
  801cb4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801cb7:	73 16                	jae    801ccf <initialize_dynamic_allocator+0x29>
  801cb9:	68 58 2a 80 00       	push   $0x802a58
  801cbe:	68 7e 2a 80 00       	push   $0x802a7e
  801cc3:	6a 26                	push   $0x26
  801cc5:	68 93 2a 80 00       	push   $0x802a93
  801cca:	e8 77 e6 ff ff       	call   800346 <_panic>
		is_initialized = 1;
  801ccf:	c7 05 24 30 80 00 01 	movl   $0x1,0x803024
  801cd6:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  801cd9:	83 ec 04             	sub    $0x4,%esp
  801cdc:	68 ac 2a 80 00       	push   $0x802aac
  801ce1:	6a 2e                	push   $0x2e
  801ce3:	68 93 2a 80 00       	push   $0x802a93
  801ce8:	e8 59 e6 ff ff       	call   800346 <_panic>

00801ced <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
  801cf0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  801cf3:	83 ec 04             	sub    $0x4,%esp
  801cf6:	68 e0 2a 80 00       	push   $0x802ae0
  801cfb:	6a 3a                	push   $0x3a
  801cfd:	68 93 2a 80 00       	push   $0x802a93
  801d02:	e8 3f e6 ff ff       	call   800346 <_panic>

00801d07 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
  801d0a:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801d0d:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801d14:	76 16                	jbe    801d2c <alloc_block+0x25>
  801d16:	68 08 2b 80 00       	push   $0x802b08
  801d1b:	68 7e 2a 80 00       	push   $0x802a7e
  801d20:	6a 46                	push   $0x46
  801d22:	68 93 2a 80 00       	push   $0x802a93
  801d27:	e8 1a e6 ff ff       	call   800346 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  801d2c:	83 ec 04             	sub    $0x4,%esp
  801d2f:	68 2c 2b 80 00       	push   $0x802b2c
  801d34:	6a 4d                	push   $0x4d
  801d36:	68 93 2a 80 00       	push   $0x802a93
  801d3b:	e8 06 e6 ff ff       	call   800346 <_panic>

00801d40 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  801d46:	8b 55 08             	mov    0x8(%ebp),%edx
  801d49:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801d4e:	39 c2                	cmp    %eax,%edx
  801d50:	72 0c                	jb     801d5e <free_block+0x1e>
  801d52:	8b 55 08             	mov    0x8(%ebp),%edx
  801d55:	a1 40 30 80 00       	mov    0x803040,%eax
  801d5a:	39 c2                	cmp    %eax,%edx
  801d5c:	72 16                	jb     801d74 <free_block+0x34>
  801d5e:	68 50 2b 80 00       	push   $0x802b50
  801d63:	68 7e 2a 80 00       	push   $0x802a7e
  801d68:	6a 5b                	push   $0x5b
  801d6a:	68 93 2a 80 00       	push   $0x802a93
  801d6f:	e8 d2 e5 ff ff       	call   800346 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  801d74:	83 ec 04             	sub    $0x4,%esp
  801d77:	68 88 2b 80 00       	push   $0x802b88
  801d7c:	6a 63                	push   $0x63
  801d7e:	68 93 2a 80 00       	push   $0x802a93
  801d83:	e8 be e5 ff ff       	call   800346 <_panic>

00801d88 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
  801d8b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  801d8e:	83 ec 04             	sub    $0x4,%esp
  801d91:	68 ac 2b 80 00       	push   $0x802bac
  801d96:	6a 72                	push   $0x72
  801d98:	68 93 2a 80 00       	push   $0x802a93
  801d9d:	e8 a4 e5 ff ff       	call   800346 <_panic>

00801da2 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
  801da5:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801da8:	8b 55 08             	mov    0x8(%ebp),%edx
  801dab:	89 d0                	mov    %edx,%eax
  801dad:	c1 e0 02             	shl    $0x2,%eax
  801db0:	01 d0                	add    %edx,%eax
  801db2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801db9:	01 d0                	add    %edx,%eax
  801dbb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801dc2:	01 d0                	add    %edx,%eax
  801dc4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801dcb:	01 d0                	add    %edx,%eax
  801dcd:	c1 e0 04             	shl    $0x4,%eax
  801dd0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801dd3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801dda:	0f 31                	rdtsc  
  801ddc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801ddf:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801de2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801de5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801de8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801deb:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801dee:	eb 46                	jmp    801e36 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801df0:	0f 31                	rdtsc  
  801df2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801df5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801df8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801dfb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801dfe:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e01:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801e04:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e0a:	29 c2                	sub    %eax,%edx
  801e0c:	89 d0                	mov    %edx,%eax
  801e0e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801e11:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e17:	89 d1                	mov    %edx,%ecx
  801e19:	29 c1                	sub    %eax,%ecx
  801e1b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e21:	39 c2                	cmp    %eax,%edx
  801e23:	0f 97 c0             	seta   %al
  801e26:	0f b6 c0             	movzbl %al,%eax
  801e29:	29 c1                	sub    %eax,%ecx
  801e2b:	89 c8                	mov    %ecx,%eax
  801e2d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801e30:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801e36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e39:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e3c:	72 b2                	jb     801df0 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801e3e:	90                   	nop
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801e47:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801e4e:	eb 03                	jmp    801e53 <busy_wait+0x12>
  801e50:	ff 45 fc             	incl   -0x4(%ebp)
  801e53:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e56:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e59:	72 f5                	jb     801e50 <busy_wait+0xf>
	return i;
  801e5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <__udivdi3>:
  801e60:	55                   	push   %ebp
  801e61:	57                   	push   %edi
  801e62:	56                   	push   %esi
  801e63:	53                   	push   %ebx
  801e64:	83 ec 1c             	sub    $0x1c,%esp
  801e67:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801e6b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801e6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e73:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e77:	89 ca                	mov    %ecx,%edx
  801e79:	89 f8                	mov    %edi,%eax
  801e7b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801e7f:	85 f6                	test   %esi,%esi
  801e81:	75 2d                	jne    801eb0 <__udivdi3+0x50>
  801e83:	39 cf                	cmp    %ecx,%edi
  801e85:	77 65                	ja     801eec <__udivdi3+0x8c>
  801e87:	89 fd                	mov    %edi,%ebp
  801e89:	85 ff                	test   %edi,%edi
  801e8b:	75 0b                	jne    801e98 <__udivdi3+0x38>
  801e8d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e92:	31 d2                	xor    %edx,%edx
  801e94:	f7 f7                	div    %edi
  801e96:	89 c5                	mov    %eax,%ebp
  801e98:	31 d2                	xor    %edx,%edx
  801e9a:	89 c8                	mov    %ecx,%eax
  801e9c:	f7 f5                	div    %ebp
  801e9e:	89 c1                	mov    %eax,%ecx
  801ea0:	89 d8                	mov    %ebx,%eax
  801ea2:	f7 f5                	div    %ebp
  801ea4:	89 cf                	mov    %ecx,%edi
  801ea6:	89 fa                	mov    %edi,%edx
  801ea8:	83 c4 1c             	add    $0x1c,%esp
  801eab:	5b                   	pop    %ebx
  801eac:	5e                   	pop    %esi
  801ead:	5f                   	pop    %edi
  801eae:	5d                   	pop    %ebp
  801eaf:	c3                   	ret    
  801eb0:	39 ce                	cmp    %ecx,%esi
  801eb2:	77 28                	ja     801edc <__udivdi3+0x7c>
  801eb4:	0f bd fe             	bsr    %esi,%edi
  801eb7:	83 f7 1f             	xor    $0x1f,%edi
  801eba:	75 40                	jne    801efc <__udivdi3+0x9c>
  801ebc:	39 ce                	cmp    %ecx,%esi
  801ebe:	72 0a                	jb     801eca <__udivdi3+0x6a>
  801ec0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ec4:	0f 87 9e 00 00 00    	ja     801f68 <__udivdi3+0x108>
  801eca:	b8 01 00 00 00       	mov    $0x1,%eax
  801ecf:	89 fa                	mov    %edi,%edx
  801ed1:	83 c4 1c             	add    $0x1c,%esp
  801ed4:	5b                   	pop    %ebx
  801ed5:	5e                   	pop    %esi
  801ed6:	5f                   	pop    %edi
  801ed7:	5d                   	pop    %ebp
  801ed8:	c3                   	ret    
  801ed9:	8d 76 00             	lea    0x0(%esi),%esi
  801edc:	31 ff                	xor    %edi,%edi
  801ede:	31 c0                	xor    %eax,%eax
  801ee0:	89 fa                	mov    %edi,%edx
  801ee2:	83 c4 1c             	add    $0x1c,%esp
  801ee5:	5b                   	pop    %ebx
  801ee6:	5e                   	pop    %esi
  801ee7:	5f                   	pop    %edi
  801ee8:	5d                   	pop    %ebp
  801ee9:	c3                   	ret    
  801eea:	66 90                	xchg   %ax,%ax
  801eec:	89 d8                	mov    %ebx,%eax
  801eee:	f7 f7                	div    %edi
  801ef0:	31 ff                	xor    %edi,%edi
  801ef2:	89 fa                	mov    %edi,%edx
  801ef4:	83 c4 1c             	add    $0x1c,%esp
  801ef7:	5b                   	pop    %ebx
  801ef8:	5e                   	pop    %esi
  801ef9:	5f                   	pop    %edi
  801efa:	5d                   	pop    %ebp
  801efb:	c3                   	ret    
  801efc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f01:	89 eb                	mov    %ebp,%ebx
  801f03:	29 fb                	sub    %edi,%ebx
  801f05:	89 f9                	mov    %edi,%ecx
  801f07:	d3 e6                	shl    %cl,%esi
  801f09:	89 c5                	mov    %eax,%ebp
  801f0b:	88 d9                	mov    %bl,%cl
  801f0d:	d3 ed                	shr    %cl,%ebp
  801f0f:	89 e9                	mov    %ebp,%ecx
  801f11:	09 f1                	or     %esi,%ecx
  801f13:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f17:	89 f9                	mov    %edi,%ecx
  801f19:	d3 e0                	shl    %cl,%eax
  801f1b:	89 c5                	mov    %eax,%ebp
  801f1d:	89 d6                	mov    %edx,%esi
  801f1f:	88 d9                	mov    %bl,%cl
  801f21:	d3 ee                	shr    %cl,%esi
  801f23:	89 f9                	mov    %edi,%ecx
  801f25:	d3 e2                	shl    %cl,%edx
  801f27:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f2b:	88 d9                	mov    %bl,%cl
  801f2d:	d3 e8                	shr    %cl,%eax
  801f2f:	09 c2                	or     %eax,%edx
  801f31:	89 d0                	mov    %edx,%eax
  801f33:	89 f2                	mov    %esi,%edx
  801f35:	f7 74 24 0c          	divl   0xc(%esp)
  801f39:	89 d6                	mov    %edx,%esi
  801f3b:	89 c3                	mov    %eax,%ebx
  801f3d:	f7 e5                	mul    %ebp
  801f3f:	39 d6                	cmp    %edx,%esi
  801f41:	72 19                	jb     801f5c <__udivdi3+0xfc>
  801f43:	74 0b                	je     801f50 <__udivdi3+0xf0>
  801f45:	89 d8                	mov    %ebx,%eax
  801f47:	31 ff                	xor    %edi,%edi
  801f49:	e9 58 ff ff ff       	jmp    801ea6 <__udivdi3+0x46>
  801f4e:	66 90                	xchg   %ax,%ax
  801f50:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f54:	89 f9                	mov    %edi,%ecx
  801f56:	d3 e2                	shl    %cl,%edx
  801f58:	39 c2                	cmp    %eax,%edx
  801f5a:	73 e9                	jae    801f45 <__udivdi3+0xe5>
  801f5c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f5f:	31 ff                	xor    %edi,%edi
  801f61:	e9 40 ff ff ff       	jmp    801ea6 <__udivdi3+0x46>
  801f66:	66 90                	xchg   %ax,%ax
  801f68:	31 c0                	xor    %eax,%eax
  801f6a:	e9 37 ff ff ff       	jmp    801ea6 <__udivdi3+0x46>
  801f6f:	90                   	nop

00801f70 <__umoddi3>:
  801f70:	55                   	push   %ebp
  801f71:	57                   	push   %edi
  801f72:	56                   	push   %esi
  801f73:	53                   	push   %ebx
  801f74:	83 ec 1c             	sub    $0x1c,%esp
  801f77:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801f7b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f83:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801f87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f8b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f8f:	89 f3                	mov    %esi,%ebx
  801f91:	89 fa                	mov    %edi,%edx
  801f93:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f97:	89 34 24             	mov    %esi,(%esp)
  801f9a:	85 c0                	test   %eax,%eax
  801f9c:	75 1a                	jne    801fb8 <__umoddi3+0x48>
  801f9e:	39 f7                	cmp    %esi,%edi
  801fa0:	0f 86 a2 00 00 00    	jbe    802048 <__umoddi3+0xd8>
  801fa6:	89 c8                	mov    %ecx,%eax
  801fa8:	89 f2                	mov    %esi,%edx
  801faa:	f7 f7                	div    %edi
  801fac:	89 d0                	mov    %edx,%eax
  801fae:	31 d2                	xor    %edx,%edx
  801fb0:	83 c4 1c             	add    $0x1c,%esp
  801fb3:	5b                   	pop    %ebx
  801fb4:	5e                   	pop    %esi
  801fb5:	5f                   	pop    %edi
  801fb6:	5d                   	pop    %ebp
  801fb7:	c3                   	ret    
  801fb8:	39 f0                	cmp    %esi,%eax
  801fba:	0f 87 ac 00 00 00    	ja     80206c <__umoddi3+0xfc>
  801fc0:	0f bd e8             	bsr    %eax,%ebp
  801fc3:	83 f5 1f             	xor    $0x1f,%ebp
  801fc6:	0f 84 ac 00 00 00    	je     802078 <__umoddi3+0x108>
  801fcc:	bf 20 00 00 00       	mov    $0x20,%edi
  801fd1:	29 ef                	sub    %ebp,%edi
  801fd3:	89 fe                	mov    %edi,%esi
  801fd5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801fd9:	89 e9                	mov    %ebp,%ecx
  801fdb:	d3 e0                	shl    %cl,%eax
  801fdd:	89 d7                	mov    %edx,%edi
  801fdf:	89 f1                	mov    %esi,%ecx
  801fe1:	d3 ef                	shr    %cl,%edi
  801fe3:	09 c7                	or     %eax,%edi
  801fe5:	89 e9                	mov    %ebp,%ecx
  801fe7:	d3 e2                	shl    %cl,%edx
  801fe9:	89 14 24             	mov    %edx,(%esp)
  801fec:	89 d8                	mov    %ebx,%eax
  801fee:	d3 e0                	shl    %cl,%eax
  801ff0:	89 c2                	mov    %eax,%edx
  801ff2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ff6:	d3 e0                	shl    %cl,%eax
  801ff8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ffc:	8b 44 24 08          	mov    0x8(%esp),%eax
  802000:	89 f1                	mov    %esi,%ecx
  802002:	d3 e8                	shr    %cl,%eax
  802004:	09 d0                	or     %edx,%eax
  802006:	d3 eb                	shr    %cl,%ebx
  802008:	89 da                	mov    %ebx,%edx
  80200a:	f7 f7                	div    %edi
  80200c:	89 d3                	mov    %edx,%ebx
  80200e:	f7 24 24             	mull   (%esp)
  802011:	89 c6                	mov    %eax,%esi
  802013:	89 d1                	mov    %edx,%ecx
  802015:	39 d3                	cmp    %edx,%ebx
  802017:	0f 82 87 00 00 00    	jb     8020a4 <__umoddi3+0x134>
  80201d:	0f 84 91 00 00 00    	je     8020b4 <__umoddi3+0x144>
  802023:	8b 54 24 04          	mov    0x4(%esp),%edx
  802027:	29 f2                	sub    %esi,%edx
  802029:	19 cb                	sbb    %ecx,%ebx
  80202b:	89 d8                	mov    %ebx,%eax
  80202d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802031:	d3 e0                	shl    %cl,%eax
  802033:	89 e9                	mov    %ebp,%ecx
  802035:	d3 ea                	shr    %cl,%edx
  802037:	09 d0                	or     %edx,%eax
  802039:	89 e9                	mov    %ebp,%ecx
  80203b:	d3 eb                	shr    %cl,%ebx
  80203d:	89 da                	mov    %ebx,%edx
  80203f:	83 c4 1c             	add    $0x1c,%esp
  802042:	5b                   	pop    %ebx
  802043:	5e                   	pop    %esi
  802044:	5f                   	pop    %edi
  802045:	5d                   	pop    %ebp
  802046:	c3                   	ret    
  802047:	90                   	nop
  802048:	89 fd                	mov    %edi,%ebp
  80204a:	85 ff                	test   %edi,%edi
  80204c:	75 0b                	jne    802059 <__umoddi3+0xe9>
  80204e:	b8 01 00 00 00       	mov    $0x1,%eax
  802053:	31 d2                	xor    %edx,%edx
  802055:	f7 f7                	div    %edi
  802057:	89 c5                	mov    %eax,%ebp
  802059:	89 f0                	mov    %esi,%eax
  80205b:	31 d2                	xor    %edx,%edx
  80205d:	f7 f5                	div    %ebp
  80205f:	89 c8                	mov    %ecx,%eax
  802061:	f7 f5                	div    %ebp
  802063:	89 d0                	mov    %edx,%eax
  802065:	e9 44 ff ff ff       	jmp    801fae <__umoddi3+0x3e>
  80206a:	66 90                	xchg   %ax,%ax
  80206c:	89 c8                	mov    %ecx,%eax
  80206e:	89 f2                	mov    %esi,%edx
  802070:	83 c4 1c             	add    $0x1c,%esp
  802073:	5b                   	pop    %ebx
  802074:	5e                   	pop    %esi
  802075:	5f                   	pop    %edi
  802076:	5d                   	pop    %ebp
  802077:	c3                   	ret    
  802078:	3b 04 24             	cmp    (%esp),%eax
  80207b:	72 06                	jb     802083 <__umoddi3+0x113>
  80207d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802081:	77 0f                	ja     802092 <__umoddi3+0x122>
  802083:	89 f2                	mov    %esi,%edx
  802085:	29 f9                	sub    %edi,%ecx
  802087:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80208b:	89 14 24             	mov    %edx,(%esp)
  80208e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802092:	8b 44 24 04          	mov    0x4(%esp),%eax
  802096:	8b 14 24             	mov    (%esp),%edx
  802099:	83 c4 1c             	add    $0x1c,%esp
  80209c:	5b                   	pop    %ebx
  80209d:	5e                   	pop    %esi
  80209e:	5f                   	pop    %edi
  80209f:	5d                   	pop    %ebp
  8020a0:	c3                   	ret    
  8020a1:	8d 76 00             	lea    0x0(%esi),%esi
  8020a4:	2b 04 24             	sub    (%esp),%eax
  8020a7:	19 fa                	sbb    %edi,%edx
  8020a9:	89 d1                	mov    %edx,%ecx
  8020ab:	89 c6                	mov    %eax,%esi
  8020ad:	e9 71 ff ff ff       	jmp    802023 <__umoddi3+0xb3>
  8020b2:	66 90                	xchg   %ax,%ax
  8020b4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8020b8:	72 ea                	jb     8020a4 <__umoddi3+0x134>
  8020ba:	89 d9                	mov    %ebx,%ecx
  8020bc:	e9 62 ff ff ff       	jmp    802023 <__umoddi3+0xb3>

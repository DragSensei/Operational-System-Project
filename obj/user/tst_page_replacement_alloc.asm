
obj/user/tst_page_replacement_alloc:     file format elf32-i386


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
  800031:	e8 22 01 00 00       	call   800158 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
		0x800000, 0x801000, 0x802000, 0x803000,											//Code & Data
		0xeebfd000, /*0xedbfd000 will be created during the call of sys_check_WS_list*/ //Stack
} ;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
	//("STEP 0: checking Initial WS entries ...\n");
	bool found ;

#if USE_KHEAP
	{
		found = sys_check_WS_list(expectedInitialVAs, 11, 0x200000, 1);
  80003f:	6a 01                	push   $0x1
  800041:	68 00 00 20 00       	push   $0x200000
  800046:	6a 0b                	push   $0xb
  800048:	68 20 30 80 00       	push   $0x803020
  80004d:	e8 4a 19 00 00       	call   80199c <sys_check_WS_list>
  800052:	83 c4 10             	add    $0x10,%esp
  800055:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  800058:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  80005c:	74 14                	je     800072 <_main+0x3a>
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	68 e0 1c 80 00       	push   $0x801ce0
  800066:	6a 1b                	push   $0x1b
  800068:	68 54 1d 80 00       	push   $0x801d54
  80006d:	e8 96 02 00 00       	call   800308 <_panic>
	}
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	int freePages = sys_calculate_free_frames();
  800072:	e8 63 15 00 00       	call   8015da <sys_calculate_free_frames>
  800077:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  80007a:	e8 a6 15 00 00       	call   801625 <sys_pf_calculate_allocated_pages>
  80007f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//Reading (Not Modified)
	char garbage1 = __arr__[PAGE_SIZE*11-1] ;
  800082:	a0 9f e0 80 00       	mov    0x80e09f,%al
  800087:	88 45 e3             	mov    %al,-0x1d(%ebp)
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
  80008a:	a0 9f f0 80 00       	mov    0x80f09f,%al
  80008f:	88 45 e2             	mov    %al,-0x1e(%ebp)
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800092:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800099:	eb 4a                	jmp    8000e5 <_main+0xad>
	{
		__arr__[i] = -1 ;
  80009b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009e:	05 a0 30 80 00       	add    $0x8030a0,%eax
  8000a3:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*__ptr__ = *__ptr2__ ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *__ptr__ + garbage5;
  8000a6:	a1 00 30 80 00       	mov    0x803000,%eax
  8000ab:	8a 00                	mov    (%eax),%al
  8000ad:	88 c2                	mov    %al,%dl
  8000af:	8a 45 f7             	mov    -0x9(%ebp),%al
  8000b2:	01 d0                	add    %edx,%eax
  8000b4:	88 45 e1             	mov    %al,-0x1f(%ebp)
		garbage5 = *__ptr2__ + garbage4;
  8000b7:	a1 04 30 80 00       	mov    0x803004,%eax
  8000bc:	8a 00                	mov    (%eax),%al
  8000be:	88 c2                	mov    %al,%dl
  8000c0:	8a 45 e1             	mov    -0x1f(%ebp),%al
  8000c3:	01 d0                	add    %edx,%eax
  8000c5:	88 45 f7             	mov    %al,-0x9(%ebp)
		__ptr__++ ; __ptr2__++ ;
  8000c8:	a1 00 30 80 00       	mov    0x803000,%eax
  8000cd:	40                   	inc    %eax
  8000ce:	a3 00 30 80 00       	mov    %eax,0x803000
  8000d3:	a1 04 30 80 00       	mov    0x803004,%eax
  8000d8:	40                   	inc    %eax
  8000d9:	a3 04 30 80 00       	mov    %eax,0x803004
	char garbage2 = __arr__[PAGE_SIZE*12-1] ;
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000de:	81 45 f0 00 08 00 00 	addl   $0x800,-0x10(%ebp)
  8000e5:	81 7d f0 ff 9f 00 00 	cmpl   $0x9fff,-0x10(%ebp)
  8000ec:	7e ad                	jle    80009b <_main+0x63>

	//===================

	//cprintf("Checking Allocation in Mem & Page File... \n");
	{
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  8000ee:	e8 32 15 00 00       	call   801625 <sys_pf_calculate_allocated_pages>
  8000f3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000f6:	74 14                	je     80010c <_main+0xd4>
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	68 78 1d 80 00       	push   $0x801d78
  800100:	6a 3b                	push   $0x3b
  800102:	68 54 1d 80 00       	push   $0x801d54
  800107:	e8 fc 01 00 00       	call   800308 <_panic>

		int freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  80010c:	e8 c9 14 00 00       	call   8015da <sys_calculate_free_frames>
  800111:	89 c3                	mov    %eax,%ebx
  800113:	e8 db 14 00 00       	call   8015f3 <sys_calculate_modified_frames>
  800118:	01 d8                	add    %ebx,%eax
  80011a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if( (freePages - freePagesAfter) != 0 )
  80011d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800120:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800123:	74 1d                	je     800142 <_main+0x10a>
			panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated. Expected = %d, Actual = %d", 0, (freePages - freePagesAfter));
  800125:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800128:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80012b:	83 ec 0c             	sub    $0xc,%esp
  80012e:	50                   	push   %eax
  80012f:	6a 00                	push   $0x0
  800131:	68 e4 1d 80 00       	push   $0x801de4
  800136:	6a 3f                	push   $0x3f
  800138:	68 54 1d 80 00       	push   $0x801d54
  80013d:	e8 c6 01 00 00       	call   800308 <_panic>

	}

	cprintf("Congratulations!! test PAGE replacement [ALLOCATION] is completed successfully\n");
  800142:	83 ec 0c             	sub    $0xc,%esp
  800145:	68 64 1e 80 00       	push   $0x801e64
  80014a:	e8 87 04 00 00       	call   8005d6 <cprintf>
  80014f:	83 c4 10             	add    $0x10,%esp
	return;
  800152:	90                   	nop
}
  800153:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800156:	c9                   	leave  
  800157:	c3                   	ret    

00800158 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800158:	55                   	push   %ebp
  800159:	89 e5                	mov    %esp,%ebp
  80015b:	57                   	push   %edi
  80015c:	56                   	push   %esi
  80015d:	53                   	push   %ebx
  80015e:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800161:	e8 3d 16 00 00       	call   8017a3 <sys_getenvindex>
  800166:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800169:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80016c:	89 d0                	mov    %edx,%eax
  80016e:	c1 e0 02             	shl    $0x2,%eax
  800171:	01 d0                	add    %edx,%eax
  800173:	c1 e0 03             	shl    $0x3,%eax
  800176:	01 d0                	add    %edx,%eax
  800178:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80017f:	01 d0                	add    %edx,%eax
  800181:	c1 e0 02             	shl    $0x2,%eax
  800184:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800189:	a3 60 30 80 00       	mov    %eax,0x803060

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80018e:	a1 60 30 80 00       	mov    0x803060,%eax
  800193:	8a 40 20             	mov    0x20(%eax),%al
  800196:	84 c0                	test   %al,%al
  800198:	74 0d                	je     8001a7 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80019a:	a1 60 30 80 00       	mov    0x803060,%eax
  80019f:	83 c0 20             	add    $0x20,%eax
  8001a2:	a3 50 30 80 00       	mov    %eax,0x803050

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001ab:	7e 0a                	jle    8001b7 <libmain+0x5f>
		binaryname = argv[0];
  8001ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b0:	8b 00                	mov    (%eax),%eax
  8001b2:	a3 50 30 80 00       	mov    %eax,0x803050

	// call user main routine
	_main(argc, argv);
  8001b7:	83 ec 08             	sub    $0x8,%esp
  8001ba:	ff 75 0c             	pushl  0xc(%ebp)
  8001bd:	ff 75 08             	pushl  0x8(%ebp)
  8001c0:	e8 73 fe ff ff       	call   800038 <_main>
  8001c5:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001c8:	a1 4c 30 80 00       	mov    0x80304c,%eax
  8001cd:	85 c0                	test   %eax,%eax
  8001cf:	0f 84 01 01 00 00    	je     8002d6 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001d5:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001db:	bb ac 1f 80 00       	mov    $0x801fac,%ebx
  8001e0:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001e5:	89 c7                	mov    %eax,%edi
  8001e7:	89 de                	mov    %ebx,%esi
  8001e9:	89 d1                	mov    %edx,%ecx
  8001eb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001ed:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001f0:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001f5:	b0 00                	mov    $0x0,%al
  8001f7:	89 d7                	mov    %edx,%edi
  8001f9:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001fb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800202:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800205:	83 ec 08             	sub    $0x8,%esp
  800208:	50                   	push   %eax
  800209:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80020f:	50                   	push   %eax
  800210:	e8 c4 17 00 00       	call   8019d9 <sys_utilities>
  800215:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800218:	e8 0d 13 00 00       	call   80152a <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80021d:	83 ec 0c             	sub    $0xc,%esp
  800220:	68 cc 1e 80 00       	push   $0x801ecc
  800225:	e8 ac 03 00 00       	call   8005d6 <cprintf>
  80022a:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80022d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800230:	85 c0                	test   %eax,%eax
  800232:	74 18                	je     80024c <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800234:	e8 be 17 00 00       	call   8019f7 <sys_get_optimal_num_faults>
  800239:	83 ec 08             	sub    $0x8,%esp
  80023c:	50                   	push   %eax
  80023d:	68 f4 1e 80 00       	push   $0x801ef4
  800242:	e8 8f 03 00 00       	call   8005d6 <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
  80024a:	eb 59                	jmp    8002a5 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80024c:	a1 60 30 80 00       	mov    0x803060,%eax
  800251:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800257:	a1 60 30 80 00       	mov    0x803060,%eax
  80025c:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800262:	83 ec 04             	sub    $0x4,%esp
  800265:	52                   	push   %edx
  800266:	50                   	push   %eax
  800267:	68 18 1f 80 00       	push   $0x801f18
  80026c:	e8 65 03 00 00       	call   8005d6 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800274:	a1 60 30 80 00       	mov    0x803060,%eax
  800279:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80027f:	a1 60 30 80 00       	mov    0x803060,%eax
  800284:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80028a:	a1 60 30 80 00       	mov    0x803060,%eax
  80028f:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800295:	51                   	push   %ecx
  800296:	52                   	push   %edx
  800297:	50                   	push   %eax
  800298:	68 40 1f 80 00       	push   $0x801f40
  80029d:	e8 34 03 00 00       	call   8005d6 <cprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002a5:	a1 60 30 80 00       	mov    0x803060,%eax
  8002aa:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8002b0:	83 ec 08             	sub    $0x8,%esp
  8002b3:	50                   	push   %eax
  8002b4:	68 98 1f 80 00       	push   $0x801f98
  8002b9:	e8 18 03 00 00       	call   8005d6 <cprintf>
  8002be:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002c1:	83 ec 0c             	sub    $0xc,%esp
  8002c4:	68 cc 1e 80 00       	push   $0x801ecc
  8002c9:	e8 08 03 00 00       	call   8005d6 <cprintf>
  8002ce:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002d1:	e8 6e 12 00 00       	call   801544 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002d6:	e8 1f 00 00 00       	call   8002fa <exit>
}
  8002db:	90                   	nop
  8002dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002df:	5b                   	pop    %ebx
  8002e0:	5e                   	pop    %esi
  8002e1:	5f                   	pop    %edi
  8002e2:	5d                   	pop    %ebp
  8002e3:	c3                   	ret    

008002e4 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002e4:	55                   	push   %ebp
  8002e5:	89 e5                	mov    %esp,%ebp
  8002e7:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	6a 00                	push   $0x0
  8002ef:	e8 7b 14 00 00       	call   80176f <sys_destroy_env>
  8002f4:	83 c4 10             	add    $0x10,%esp
}
  8002f7:	90                   	nop
  8002f8:	c9                   	leave  
  8002f9:	c3                   	ret    

008002fa <exit>:

void
exit(void)
{
  8002fa:	55                   	push   %ebp
  8002fb:	89 e5                	mov    %esp,%ebp
  8002fd:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800300:	e8 d0 14 00 00       	call   8017d5 <sys_exit_env>
}
  800305:	90                   	nop
  800306:	c9                   	leave  
  800307:	c3                   	ret    

00800308 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
  80030b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80030e:	8d 45 10             	lea    0x10(%ebp),%eax
  800311:	83 c0 04             	add    $0x4,%eax
  800314:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800317:	a1 78 71 82 00       	mov    0x827178,%eax
  80031c:	85 c0                	test   %eax,%eax
  80031e:	74 16                	je     800336 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800320:	a1 78 71 82 00       	mov    0x827178,%eax
  800325:	83 ec 08             	sub    $0x8,%esp
  800328:	50                   	push   %eax
  800329:	68 10 20 80 00       	push   $0x802010
  80032e:	e8 a3 02 00 00       	call   8005d6 <cprintf>
  800333:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800336:	a1 50 30 80 00       	mov    0x803050,%eax
  80033b:	83 ec 0c             	sub    $0xc,%esp
  80033e:	ff 75 0c             	pushl  0xc(%ebp)
  800341:	ff 75 08             	pushl  0x8(%ebp)
  800344:	50                   	push   %eax
  800345:	68 18 20 80 00       	push   $0x802018
  80034a:	6a 74                	push   $0x74
  80034c:	e8 b2 02 00 00       	call   800603 <cprintf_colored>
  800351:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800354:	8b 45 10             	mov    0x10(%ebp),%eax
  800357:	83 ec 08             	sub    $0x8,%esp
  80035a:	ff 75 f4             	pushl  -0xc(%ebp)
  80035d:	50                   	push   %eax
  80035e:	e8 04 02 00 00       	call   800567 <vcprintf>
  800363:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800366:	83 ec 08             	sub    $0x8,%esp
  800369:	6a 00                	push   $0x0
  80036b:	68 40 20 80 00       	push   $0x802040
  800370:	e8 f2 01 00 00       	call   800567 <vcprintf>
  800375:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800378:	e8 7d ff ff ff       	call   8002fa <exit>

	// should not return here
	while (1) ;
  80037d:	eb fe                	jmp    80037d <_panic+0x75>

0080037f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800385:	a1 60 30 80 00       	mov    0x803060,%eax
  80038a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800390:	8b 45 0c             	mov    0xc(%ebp),%eax
  800393:	39 c2                	cmp    %eax,%edx
  800395:	74 14                	je     8003ab <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800397:	83 ec 04             	sub    $0x4,%esp
  80039a:	68 44 20 80 00       	push   $0x802044
  80039f:	6a 26                	push   $0x26
  8003a1:	68 90 20 80 00       	push   $0x802090
  8003a6:	e8 5d ff ff ff       	call   800308 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003b2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003b9:	e9 c5 00 00 00       	jmp    800483 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cb:	01 d0                	add    %edx,%eax
  8003cd:	8b 00                	mov    (%eax),%eax
  8003cf:	85 c0                	test   %eax,%eax
  8003d1:	75 08                	jne    8003db <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003d3:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003d6:	e9 a5 00 00 00       	jmp    800480 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003db:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003e9:	eb 69                	jmp    800454 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003eb:	a1 60 30 80 00       	mov    0x803060,%eax
  8003f0:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003f9:	89 d0                	mov    %edx,%eax
  8003fb:	01 c0                	add    %eax,%eax
  8003fd:	01 d0                	add    %edx,%eax
  8003ff:	c1 e0 03             	shl    $0x3,%eax
  800402:	01 c8                	add    %ecx,%eax
  800404:	8a 40 04             	mov    0x4(%eax),%al
  800407:	84 c0                	test   %al,%al
  800409:	75 46                	jne    800451 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80040b:	a1 60 30 80 00       	mov    0x803060,%eax
  800410:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800416:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800419:	89 d0                	mov    %edx,%eax
  80041b:	01 c0                	add    %eax,%eax
  80041d:	01 d0                	add    %edx,%eax
  80041f:	c1 e0 03             	shl    $0x3,%eax
  800422:	01 c8                	add    %ecx,%eax
  800424:	8b 00                	mov    (%eax),%eax
  800426:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800429:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80042c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800431:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800433:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800436:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80043d:	8b 45 08             	mov    0x8(%ebp),%eax
  800440:	01 c8                	add    %ecx,%eax
  800442:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800444:	39 c2                	cmp    %eax,%edx
  800446:	75 09                	jne    800451 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800448:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80044f:	eb 15                	jmp    800466 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800451:	ff 45 e8             	incl   -0x18(%ebp)
  800454:	a1 60 30 80 00       	mov    0x803060,%eax
  800459:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80045f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800462:	39 c2                	cmp    %eax,%edx
  800464:	77 85                	ja     8003eb <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800466:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80046a:	75 14                	jne    800480 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80046c:	83 ec 04             	sub    $0x4,%esp
  80046f:	68 9c 20 80 00       	push   $0x80209c
  800474:	6a 3a                	push   $0x3a
  800476:	68 90 20 80 00       	push   $0x802090
  80047b:	e8 88 fe ff ff       	call   800308 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800480:	ff 45 f0             	incl   -0x10(%ebp)
  800483:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800486:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800489:	0f 8c 2f ff ff ff    	jl     8003be <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80048f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800496:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80049d:	eb 26                	jmp    8004c5 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80049f:	a1 60 30 80 00       	mov    0x803060,%eax
  8004a4:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8004aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004ad:	89 d0                	mov    %edx,%eax
  8004af:	01 c0                	add    %eax,%eax
  8004b1:	01 d0                	add    %edx,%eax
  8004b3:	c1 e0 03             	shl    $0x3,%eax
  8004b6:	01 c8                	add    %ecx,%eax
  8004b8:	8a 40 04             	mov    0x4(%eax),%al
  8004bb:	3c 01                	cmp    $0x1,%al
  8004bd:	75 03                	jne    8004c2 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004bf:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c2:	ff 45 e0             	incl   -0x20(%ebp)
  8004c5:	a1 60 30 80 00       	mov    0x803060,%eax
  8004ca:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d3:	39 c2                	cmp    %eax,%edx
  8004d5:	77 c8                	ja     80049f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004da:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004dd:	74 14                	je     8004f3 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004df:	83 ec 04             	sub    $0x4,%esp
  8004e2:	68 f0 20 80 00       	push   $0x8020f0
  8004e7:	6a 44                	push   $0x44
  8004e9:	68 90 20 80 00       	push   $0x802090
  8004ee:	e8 15 fe ff ff       	call   800308 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004f3:	90                   	nop
  8004f4:	c9                   	leave  
  8004f5:	c3                   	ret    

008004f6 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004f6:	55                   	push   %ebp
  8004f7:	89 e5                	mov    %esp,%ebp
  8004f9:	53                   	push   %ebx
  8004fa:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800500:	8b 00                	mov    (%eax),%eax
  800502:	8d 48 01             	lea    0x1(%eax),%ecx
  800505:	8b 55 0c             	mov    0xc(%ebp),%edx
  800508:	89 0a                	mov    %ecx,(%edx)
  80050a:	8b 55 08             	mov    0x8(%ebp),%edx
  80050d:	88 d1                	mov    %dl,%cl
  80050f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800512:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800516:	8b 45 0c             	mov    0xc(%ebp),%eax
  800519:	8b 00                	mov    (%eax),%eax
  80051b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800520:	75 30                	jne    800552 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800522:	8b 15 7c 71 82 00    	mov    0x82717c,%edx
  800528:	a0 84 30 80 00       	mov    0x803084,%al
  80052d:	0f b6 c0             	movzbl %al,%eax
  800530:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800533:	8b 09                	mov    (%ecx),%ecx
  800535:	89 cb                	mov    %ecx,%ebx
  800537:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80053a:	83 c1 08             	add    $0x8,%ecx
  80053d:	52                   	push   %edx
  80053e:	50                   	push   %eax
  80053f:	53                   	push   %ebx
  800540:	51                   	push   %ecx
  800541:	e8 a0 0f 00 00       	call   8014e6 <sys_cputs>
  800546:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800552:	8b 45 0c             	mov    0xc(%ebp),%eax
  800555:	8b 40 04             	mov    0x4(%eax),%eax
  800558:	8d 50 01             	lea    0x1(%eax),%edx
  80055b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80055e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800561:	90                   	nop
  800562:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800565:	c9                   	leave  
  800566:	c3                   	ret    

00800567 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800567:	55                   	push   %ebp
  800568:	89 e5                	mov    %esp,%ebp
  80056a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800570:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800577:	00 00 00 
	b.cnt = 0;
  80057a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800581:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800584:	ff 75 0c             	pushl  0xc(%ebp)
  800587:	ff 75 08             	pushl  0x8(%ebp)
  80058a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800590:	50                   	push   %eax
  800591:	68 f6 04 80 00       	push   $0x8004f6
  800596:	e8 5a 02 00 00       	call   8007f5 <vprintfmt>
  80059b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80059e:	8b 15 7c 71 82 00    	mov    0x82717c,%edx
  8005a4:	a0 84 30 80 00       	mov    0x803084,%al
  8005a9:	0f b6 c0             	movzbl %al,%eax
  8005ac:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8005b2:	52                   	push   %edx
  8005b3:	50                   	push   %eax
  8005b4:	51                   	push   %ecx
  8005b5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005bb:	83 c0 08             	add    $0x8,%eax
  8005be:	50                   	push   %eax
  8005bf:	e8 22 0f 00 00       	call   8014e6 <sys_cputs>
  8005c4:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005c7:	c6 05 84 30 80 00 00 	movb   $0x0,0x803084
	return b.cnt;
  8005ce:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005d4:	c9                   	leave  
  8005d5:	c3                   	ret    

008005d6 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005d6:	55                   	push   %ebp
  8005d7:	89 e5                	mov    %esp,%ebp
  8005d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005dc:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
	va_start(ap, fmt);
  8005e3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ec:	83 ec 08             	sub    $0x8,%esp
  8005ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f2:	50                   	push   %eax
  8005f3:	e8 6f ff ff ff       	call   800567 <vcprintf>
  8005f8:	83 c4 10             	add    $0x10,%esp
  8005fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800601:	c9                   	leave  
  800602:	c3                   	ret    

00800603 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800603:	55                   	push   %ebp
  800604:	89 e5                	mov    %esp,%ebp
  800606:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800609:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
	curTextClr = (textClr << 8) ; //set text color by the given value
  800610:	8b 45 08             	mov    0x8(%ebp),%eax
  800613:	c1 e0 08             	shl    $0x8,%eax
  800616:	a3 7c 71 82 00       	mov    %eax,0x82717c
	va_start(ap, fmt);
  80061b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80061e:	83 c0 04             	add    $0x4,%eax
  800621:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800624:	8b 45 0c             	mov    0xc(%ebp),%eax
  800627:	83 ec 08             	sub    $0x8,%esp
  80062a:	ff 75 f4             	pushl  -0xc(%ebp)
  80062d:	50                   	push   %eax
  80062e:	e8 34 ff ff ff       	call   800567 <vcprintf>
  800633:	83 c4 10             	add    $0x10,%esp
  800636:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800639:	c7 05 7c 71 82 00 00 	movl   $0x700,0x82717c
  800640:	07 00 00 

	return cnt;
  800643:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800646:	c9                   	leave  
  800647:	c3                   	ret    

00800648 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800648:	55                   	push   %ebp
  800649:	89 e5                	mov    %esp,%ebp
  80064b:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80064e:	e8 d7 0e 00 00       	call   80152a <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800653:	8d 45 0c             	lea    0xc(%ebp),%eax
  800656:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800659:	8b 45 08             	mov    0x8(%ebp),%eax
  80065c:	83 ec 08             	sub    $0x8,%esp
  80065f:	ff 75 f4             	pushl  -0xc(%ebp)
  800662:	50                   	push   %eax
  800663:	e8 ff fe ff ff       	call   800567 <vcprintf>
  800668:	83 c4 10             	add    $0x10,%esp
  80066b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80066e:	e8 d1 0e 00 00       	call   801544 <sys_unlock_cons>
	return cnt;
  800673:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800676:	c9                   	leave  
  800677:	c3                   	ret    

00800678 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800678:	55                   	push   %ebp
  800679:	89 e5                	mov    %esp,%ebp
  80067b:	53                   	push   %ebx
  80067c:	83 ec 14             	sub    $0x14,%esp
  80067f:	8b 45 10             	mov    0x10(%ebp),%eax
  800682:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80068b:	8b 45 18             	mov    0x18(%ebp),%eax
  80068e:	ba 00 00 00 00       	mov    $0x0,%edx
  800693:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800696:	77 55                	ja     8006ed <printnum+0x75>
  800698:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80069b:	72 05                	jb     8006a2 <printnum+0x2a>
  80069d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006a0:	77 4b                	ja     8006ed <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006a2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006a5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006a8:	8b 45 18             	mov    0x18(%ebp),%eax
  8006ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b0:	52                   	push   %edx
  8006b1:	50                   	push   %eax
  8006b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8006b5:	ff 75 f0             	pushl  -0x10(%ebp)
  8006b8:	e8 ab 13 00 00       	call   801a68 <__udivdi3>
  8006bd:	83 c4 10             	add    $0x10,%esp
  8006c0:	83 ec 04             	sub    $0x4,%esp
  8006c3:	ff 75 20             	pushl  0x20(%ebp)
  8006c6:	53                   	push   %ebx
  8006c7:	ff 75 18             	pushl  0x18(%ebp)
  8006ca:	52                   	push   %edx
  8006cb:	50                   	push   %eax
  8006cc:	ff 75 0c             	pushl  0xc(%ebp)
  8006cf:	ff 75 08             	pushl  0x8(%ebp)
  8006d2:	e8 a1 ff ff ff       	call   800678 <printnum>
  8006d7:	83 c4 20             	add    $0x20,%esp
  8006da:	eb 1a                	jmp    8006f6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006dc:	83 ec 08             	sub    $0x8,%esp
  8006df:	ff 75 0c             	pushl  0xc(%ebp)
  8006e2:	ff 75 20             	pushl  0x20(%ebp)
  8006e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e8:	ff d0                	call   *%eax
  8006ea:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006ed:	ff 4d 1c             	decl   0x1c(%ebp)
  8006f0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006f4:	7f e6                	jg     8006dc <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006f6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800701:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800704:	53                   	push   %ebx
  800705:	51                   	push   %ecx
  800706:	52                   	push   %edx
  800707:	50                   	push   %eax
  800708:	e8 6b 14 00 00       	call   801b78 <__umoddi3>
  80070d:	83 c4 10             	add    $0x10,%esp
  800710:	05 54 23 80 00       	add    $0x802354,%eax
  800715:	8a 00                	mov    (%eax),%al
  800717:	0f be c0             	movsbl %al,%eax
  80071a:	83 ec 08             	sub    $0x8,%esp
  80071d:	ff 75 0c             	pushl  0xc(%ebp)
  800720:	50                   	push   %eax
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	ff d0                	call   *%eax
  800726:	83 c4 10             	add    $0x10,%esp
}
  800729:	90                   	nop
  80072a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80072d:	c9                   	leave  
  80072e:	c3                   	ret    

0080072f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800732:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800736:	7e 1c                	jle    800754 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
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
  800752:	eb 40                	jmp    800794 <getuint+0x65>
	else if (lflag)
  800754:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800758:	74 1e                	je     800778 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	8b 00                	mov    (%eax),%eax
  80075f:	8d 50 04             	lea    0x4(%eax),%edx
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	89 10                	mov    %edx,(%eax)
  800767:	8b 45 08             	mov    0x8(%ebp),%eax
  80076a:	8b 00                	mov    (%eax),%eax
  80076c:	83 e8 04             	sub    $0x4,%eax
  80076f:	8b 00                	mov    (%eax),%eax
  800771:	ba 00 00 00 00       	mov    $0x0,%edx
  800776:	eb 1c                	jmp    800794 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	8b 00                	mov    (%eax),%eax
  80077d:	8d 50 04             	lea    0x4(%eax),%edx
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	89 10                	mov    %edx,(%eax)
  800785:	8b 45 08             	mov    0x8(%ebp),%eax
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	83 e8 04             	sub    $0x4,%eax
  80078d:	8b 00                	mov    (%eax),%eax
  80078f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800794:	5d                   	pop    %ebp
  800795:	c3                   	ret    

00800796 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800796:	55                   	push   %ebp
  800797:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800799:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80079d:	7e 1c                	jle    8007bb <getint+0x25>
		return va_arg(*ap, long long);
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	8d 50 08             	lea    0x8(%eax),%edx
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	89 10                	mov    %edx,(%eax)
  8007ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8007af:	8b 00                	mov    (%eax),%eax
  8007b1:	83 e8 08             	sub    $0x8,%eax
  8007b4:	8b 50 04             	mov    0x4(%eax),%edx
  8007b7:	8b 00                	mov    (%eax),%eax
  8007b9:	eb 38                	jmp    8007f3 <getint+0x5d>
	else if (lflag)
  8007bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007bf:	74 1a                	je     8007db <getint+0x45>
		return va_arg(*ap, long);
  8007c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c4:	8b 00                	mov    (%eax),%eax
  8007c6:	8d 50 04             	lea    0x4(%eax),%edx
  8007c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cc:	89 10                	mov    %edx,(%eax)
  8007ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	83 e8 04             	sub    $0x4,%eax
  8007d6:	8b 00                	mov    (%eax),%eax
  8007d8:	99                   	cltd   
  8007d9:	eb 18                	jmp    8007f3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007db:	8b 45 08             	mov    0x8(%ebp),%eax
  8007de:	8b 00                	mov    (%eax),%eax
  8007e0:	8d 50 04             	lea    0x4(%eax),%edx
  8007e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e6:	89 10                	mov    %edx,(%eax)
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	8b 00                	mov    (%eax),%eax
  8007ed:	83 e8 04             	sub    $0x4,%eax
  8007f0:	8b 00                	mov    (%eax),%eax
  8007f2:	99                   	cltd   
}
  8007f3:	5d                   	pop    %ebp
  8007f4:	c3                   	ret    

008007f5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007f5:	55                   	push   %ebp
  8007f6:	89 e5                	mov    %esp,%ebp
  8007f8:	56                   	push   %esi
  8007f9:	53                   	push   %ebx
  8007fa:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007fd:	eb 17                	jmp    800816 <vprintfmt+0x21>
			if (ch == '\0')
  8007ff:	85 db                	test   %ebx,%ebx
  800801:	0f 84 c1 03 00 00    	je     800bc8 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800807:	83 ec 08             	sub    $0x8,%esp
  80080a:	ff 75 0c             	pushl  0xc(%ebp)
  80080d:	53                   	push   %ebx
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	ff d0                	call   *%eax
  800813:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800816:	8b 45 10             	mov    0x10(%ebp),%eax
  800819:	8d 50 01             	lea    0x1(%eax),%edx
  80081c:	89 55 10             	mov    %edx,0x10(%ebp)
  80081f:	8a 00                	mov    (%eax),%al
  800821:	0f b6 d8             	movzbl %al,%ebx
  800824:	83 fb 25             	cmp    $0x25,%ebx
  800827:	75 d6                	jne    8007ff <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800829:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80082d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800834:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80083b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800842:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800849:	8b 45 10             	mov    0x10(%ebp),%eax
  80084c:	8d 50 01             	lea    0x1(%eax),%edx
  80084f:	89 55 10             	mov    %edx,0x10(%ebp)
  800852:	8a 00                	mov    (%eax),%al
  800854:	0f b6 d8             	movzbl %al,%ebx
  800857:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80085a:	83 f8 5b             	cmp    $0x5b,%eax
  80085d:	0f 87 3d 03 00 00    	ja     800ba0 <vprintfmt+0x3ab>
  800863:	8b 04 85 78 23 80 00 	mov    0x802378(,%eax,4),%eax
  80086a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80086c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800870:	eb d7                	jmp    800849 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800872:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800876:	eb d1                	jmp    800849 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800878:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80087f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800882:	89 d0                	mov    %edx,%eax
  800884:	c1 e0 02             	shl    $0x2,%eax
  800887:	01 d0                	add    %edx,%eax
  800889:	01 c0                	add    %eax,%eax
  80088b:	01 d8                	add    %ebx,%eax
  80088d:	83 e8 30             	sub    $0x30,%eax
  800890:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800893:	8b 45 10             	mov    0x10(%ebp),%eax
  800896:	8a 00                	mov    (%eax),%al
  800898:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80089b:	83 fb 2f             	cmp    $0x2f,%ebx
  80089e:	7e 3e                	jle    8008de <vprintfmt+0xe9>
  8008a0:	83 fb 39             	cmp    $0x39,%ebx
  8008a3:	7f 39                	jg     8008de <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008a8:	eb d5                	jmp    80087f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	83 c0 04             	add    $0x4,%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	83 e8 04             	sub    $0x4,%eax
  8008b9:	8b 00                	mov    (%eax),%eax
  8008bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008be:	eb 1f                	jmp    8008df <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c4:	79 83                	jns    800849 <vprintfmt+0x54>
				width = 0;
  8008c6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008cd:	e9 77 ff ff ff       	jmp    800849 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008d2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008d9:	e9 6b ff ff ff       	jmp    800849 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008de:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e3:	0f 89 60 ff ff ff    	jns    800849 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ef:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008f6:	e9 4e ff ff ff       	jmp    800849 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008fb:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008fe:	e9 46 ff ff ff       	jmp    800849 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800903:	8b 45 14             	mov    0x14(%ebp),%eax
  800906:	83 c0 04             	add    $0x4,%eax
  800909:	89 45 14             	mov    %eax,0x14(%ebp)
  80090c:	8b 45 14             	mov    0x14(%ebp),%eax
  80090f:	83 e8 04             	sub    $0x4,%eax
  800912:	8b 00                	mov    (%eax),%eax
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	ff 75 0c             	pushl  0xc(%ebp)
  80091a:	50                   	push   %eax
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	ff d0                	call   *%eax
  800920:	83 c4 10             	add    $0x10,%esp
			break;
  800923:	e9 9b 02 00 00       	jmp    800bc3 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800928:	8b 45 14             	mov    0x14(%ebp),%eax
  80092b:	83 c0 04             	add    $0x4,%eax
  80092e:	89 45 14             	mov    %eax,0x14(%ebp)
  800931:	8b 45 14             	mov    0x14(%ebp),%eax
  800934:	83 e8 04             	sub    $0x4,%eax
  800937:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800939:	85 db                	test   %ebx,%ebx
  80093b:	79 02                	jns    80093f <vprintfmt+0x14a>
				err = -err;
  80093d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80093f:	83 fb 64             	cmp    $0x64,%ebx
  800942:	7f 0b                	jg     80094f <vprintfmt+0x15a>
  800944:	8b 34 9d c0 21 80 00 	mov    0x8021c0(,%ebx,4),%esi
  80094b:	85 f6                	test   %esi,%esi
  80094d:	75 19                	jne    800968 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80094f:	53                   	push   %ebx
  800950:	68 65 23 80 00       	push   $0x802365
  800955:	ff 75 0c             	pushl  0xc(%ebp)
  800958:	ff 75 08             	pushl  0x8(%ebp)
  80095b:	e8 70 02 00 00       	call   800bd0 <printfmt>
  800960:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800963:	e9 5b 02 00 00       	jmp    800bc3 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800968:	56                   	push   %esi
  800969:	68 6e 23 80 00       	push   $0x80236e
  80096e:	ff 75 0c             	pushl  0xc(%ebp)
  800971:	ff 75 08             	pushl  0x8(%ebp)
  800974:	e8 57 02 00 00       	call   800bd0 <printfmt>
  800979:	83 c4 10             	add    $0x10,%esp
			break;
  80097c:	e9 42 02 00 00       	jmp    800bc3 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800981:	8b 45 14             	mov    0x14(%ebp),%eax
  800984:	83 c0 04             	add    $0x4,%eax
  800987:	89 45 14             	mov    %eax,0x14(%ebp)
  80098a:	8b 45 14             	mov    0x14(%ebp),%eax
  80098d:	83 e8 04             	sub    $0x4,%eax
  800990:	8b 30                	mov    (%eax),%esi
  800992:	85 f6                	test   %esi,%esi
  800994:	75 05                	jne    80099b <vprintfmt+0x1a6>
				p = "(null)";
  800996:	be 71 23 80 00       	mov    $0x802371,%esi
			if (width > 0 && padc != '-')
  80099b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80099f:	7e 6d                	jle    800a0e <vprintfmt+0x219>
  8009a1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009a5:	74 67                	je     800a0e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009aa:	83 ec 08             	sub    $0x8,%esp
  8009ad:	50                   	push   %eax
  8009ae:	56                   	push   %esi
  8009af:	e8 1e 03 00 00       	call   800cd2 <strnlen>
  8009b4:	83 c4 10             	add    $0x10,%esp
  8009b7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009ba:	eb 16                	jmp    8009d2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009bc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009c0:	83 ec 08             	sub    $0x8,%esp
  8009c3:	ff 75 0c             	pushl  0xc(%ebp)
  8009c6:	50                   	push   %eax
  8009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ca:	ff d0                	call   *%eax
  8009cc:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009cf:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d6:	7f e4                	jg     8009bc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d8:	eb 34                	jmp    800a0e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009da:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009de:	74 1c                	je     8009fc <vprintfmt+0x207>
  8009e0:	83 fb 1f             	cmp    $0x1f,%ebx
  8009e3:	7e 05                	jle    8009ea <vprintfmt+0x1f5>
  8009e5:	83 fb 7e             	cmp    $0x7e,%ebx
  8009e8:	7e 12                	jle    8009fc <vprintfmt+0x207>
					putch('?', putdat);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	6a 3f                	push   $0x3f
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	ff d0                	call   *%eax
  8009f7:	83 c4 10             	add    $0x10,%esp
  8009fa:	eb 0f                	jmp    800a0b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009fc:	83 ec 08             	sub    $0x8,%esp
  8009ff:	ff 75 0c             	pushl  0xc(%ebp)
  800a02:	53                   	push   %ebx
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	ff d0                	call   *%eax
  800a08:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0b:	ff 4d e4             	decl   -0x1c(%ebp)
  800a0e:	89 f0                	mov    %esi,%eax
  800a10:	8d 70 01             	lea    0x1(%eax),%esi
  800a13:	8a 00                	mov    (%eax),%al
  800a15:	0f be d8             	movsbl %al,%ebx
  800a18:	85 db                	test   %ebx,%ebx
  800a1a:	74 24                	je     800a40 <vprintfmt+0x24b>
  800a1c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a20:	78 b8                	js     8009da <vprintfmt+0x1e5>
  800a22:	ff 4d e0             	decl   -0x20(%ebp)
  800a25:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a29:	79 af                	jns    8009da <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a2b:	eb 13                	jmp    800a40 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a2d:	83 ec 08             	sub    $0x8,%esp
  800a30:	ff 75 0c             	pushl  0xc(%ebp)
  800a33:	6a 20                	push   $0x20
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	ff d0                	call   *%eax
  800a3a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a3d:	ff 4d e4             	decl   -0x1c(%ebp)
  800a40:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a44:	7f e7                	jg     800a2d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a46:	e9 78 01 00 00       	jmp    800bc3 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a4b:	83 ec 08             	sub    $0x8,%esp
  800a4e:	ff 75 e8             	pushl  -0x18(%ebp)
  800a51:	8d 45 14             	lea    0x14(%ebp),%eax
  800a54:	50                   	push   %eax
  800a55:	e8 3c fd ff ff       	call   800796 <getint>
  800a5a:	83 c4 10             	add    $0x10,%esp
  800a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a60:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a69:	85 d2                	test   %edx,%edx
  800a6b:	79 23                	jns    800a90 <vprintfmt+0x29b>
				putch('-', putdat);
  800a6d:	83 ec 08             	sub    $0x8,%esp
  800a70:	ff 75 0c             	pushl  0xc(%ebp)
  800a73:	6a 2d                	push   $0x2d
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	ff d0                	call   *%eax
  800a7a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a83:	f7 d8                	neg    %eax
  800a85:	83 d2 00             	adc    $0x0,%edx
  800a88:	f7 da                	neg    %edx
  800a8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a8d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a90:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a97:	e9 bc 00 00 00       	jmp    800b58 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a9c:	83 ec 08             	sub    $0x8,%esp
  800a9f:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa2:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa5:	50                   	push   %eax
  800aa6:	e8 84 fc ff ff       	call   80072f <getuint>
  800aab:	83 c4 10             	add    $0x10,%esp
  800aae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ab4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800abb:	e9 98 00 00 00       	jmp    800b58 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ac0:	83 ec 08             	sub    $0x8,%esp
  800ac3:	ff 75 0c             	pushl  0xc(%ebp)
  800ac6:	6a 58                	push   $0x58
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	ff d0                	call   *%eax
  800acd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ad0:	83 ec 08             	sub    $0x8,%esp
  800ad3:	ff 75 0c             	pushl  0xc(%ebp)
  800ad6:	6a 58                	push   $0x58
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	ff d0                	call   *%eax
  800add:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ae0:	83 ec 08             	sub    $0x8,%esp
  800ae3:	ff 75 0c             	pushl  0xc(%ebp)
  800ae6:	6a 58                	push   $0x58
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	ff d0                	call   *%eax
  800aed:	83 c4 10             	add    $0x10,%esp
			break;
  800af0:	e9 ce 00 00 00       	jmp    800bc3 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	6a 30                	push   $0x30
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	ff d0                	call   *%eax
  800b02:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b05:	83 ec 08             	sub    $0x8,%esp
  800b08:	ff 75 0c             	pushl  0xc(%ebp)
  800b0b:	6a 78                	push   $0x78
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	ff d0                	call   *%eax
  800b12:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b15:	8b 45 14             	mov    0x14(%ebp),%eax
  800b18:	83 c0 04             	add    $0x4,%eax
  800b1b:	89 45 14             	mov    %eax,0x14(%ebp)
  800b1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b21:	83 e8 04             	sub    $0x4,%eax
  800b24:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b29:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b30:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b37:	eb 1f                	jmp    800b58 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b39:	83 ec 08             	sub    $0x8,%esp
  800b3c:	ff 75 e8             	pushl  -0x18(%ebp)
  800b3f:	8d 45 14             	lea    0x14(%ebp),%eax
  800b42:	50                   	push   %eax
  800b43:	e8 e7 fb ff ff       	call   80072f <getuint>
  800b48:	83 c4 10             	add    $0x10,%esp
  800b4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b51:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b58:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b5f:	83 ec 04             	sub    $0x4,%esp
  800b62:	52                   	push   %edx
  800b63:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b66:	50                   	push   %eax
  800b67:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6a:	ff 75 f0             	pushl  -0x10(%ebp)
  800b6d:	ff 75 0c             	pushl  0xc(%ebp)
  800b70:	ff 75 08             	pushl  0x8(%ebp)
  800b73:	e8 00 fb ff ff       	call   800678 <printnum>
  800b78:	83 c4 20             	add    $0x20,%esp
			break;
  800b7b:	eb 46                	jmp    800bc3 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b7d:	83 ec 08             	sub    $0x8,%esp
  800b80:	ff 75 0c             	pushl  0xc(%ebp)
  800b83:	53                   	push   %ebx
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	ff d0                	call   *%eax
  800b89:	83 c4 10             	add    $0x10,%esp
			break;
  800b8c:	eb 35                	jmp    800bc3 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b8e:	c6 05 84 30 80 00 00 	movb   $0x0,0x803084
			break;
  800b95:	eb 2c                	jmp    800bc3 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b97:	c6 05 84 30 80 00 01 	movb   $0x1,0x803084
			break;
  800b9e:	eb 23                	jmp    800bc3 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ba0:	83 ec 08             	sub    $0x8,%esp
  800ba3:	ff 75 0c             	pushl  0xc(%ebp)
  800ba6:	6a 25                	push   $0x25
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	ff d0                	call   *%eax
  800bad:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bb0:	ff 4d 10             	decl   0x10(%ebp)
  800bb3:	eb 03                	jmp    800bb8 <vprintfmt+0x3c3>
  800bb5:	ff 4d 10             	decl   0x10(%ebp)
  800bb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbb:	48                   	dec    %eax
  800bbc:	8a 00                	mov    (%eax),%al
  800bbe:	3c 25                	cmp    $0x25,%al
  800bc0:	75 f3                	jne    800bb5 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800bc2:	90                   	nop
		}
	}
  800bc3:	e9 35 fc ff ff       	jmp    8007fd <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bc8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bc9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bcc:	5b                   	pop    %ebx
  800bcd:	5e                   	pop    %esi
  800bce:	5d                   	pop    %ebp
  800bcf:	c3                   	ret    

00800bd0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bd6:	8d 45 10             	lea    0x10(%ebp),%eax
  800bd9:	83 c0 04             	add    $0x4,%eax
  800bdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800be2:	ff 75 f4             	pushl  -0xc(%ebp)
  800be5:	50                   	push   %eax
  800be6:	ff 75 0c             	pushl  0xc(%ebp)
  800be9:	ff 75 08             	pushl  0x8(%ebp)
  800bec:	e8 04 fc ff ff       	call   8007f5 <vprintfmt>
  800bf1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bf4:	90                   	nop
  800bf5:	c9                   	leave  
  800bf6:	c3                   	ret    

00800bf7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfd:	8b 40 08             	mov    0x8(%eax),%eax
  800c00:	8d 50 01             	lea    0x1(%eax),%edx
  800c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c06:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0c:	8b 10                	mov    (%eax),%edx
  800c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c11:	8b 40 04             	mov    0x4(%eax),%eax
  800c14:	39 c2                	cmp    %eax,%edx
  800c16:	73 12                	jae    800c2a <sprintputch+0x33>
		*b->buf++ = ch;
  800c18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1b:	8b 00                	mov    (%eax),%eax
  800c1d:	8d 48 01             	lea    0x1(%eax),%ecx
  800c20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c23:	89 0a                	mov    %ecx,(%edx)
  800c25:	8b 55 08             	mov    0x8(%ebp),%edx
  800c28:	88 10                	mov    %dl,(%eax)
}
  800c2a:	90                   	nop
  800c2b:	5d                   	pop    %ebp
  800c2c:	c3                   	ret    

00800c2d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c2d:	55                   	push   %ebp
  800c2e:	89 e5                	mov    %esp,%ebp
  800c30:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	01 d0                	add    %edx,%eax
  800c44:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c47:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c52:	74 06                	je     800c5a <vsnprintf+0x2d>
  800c54:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c58:	7f 07                	jg     800c61 <vsnprintf+0x34>
		return -E_INVAL;
  800c5a:	b8 03 00 00 00       	mov    $0x3,%eax
  800c5f:	eb 20                	jmp    800c81 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c61:	ff 75 14             	pushl  0x14(%ebp)
  800c64:	ff 75 10             	pushl  0x10(%ebp)
  800c67:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c6a:	50                   	push   %eax
  800c6b:	68 f7 0b 80 00       	push   $0x800bf7
  800c70:	e8 80 fb ff ff       	call   8007f5 <vprintfmt>
  800c75:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c7b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

00800c83 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c89:	8d 45 10             	lea    0x10(%ebp),%eax
  800c8c:	83 c0 04             	add    $0x4,%eax
  800c8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c92:	8b 45 10             	mov    0x10(%ebp),%eax
  800c95:	ff 75 f4             	pushl  -0xc(%ebp)
  800c98:	50                   	push   %eax
  800c99:	ff 75 0c             	pushl  0xc(%ebp)
  800c9c:	ff 75 08             	pushl  0x8(%ebp)
  800c9f:	e8 89 ff ff ff       	call   800c2d <vsnprintf>
  800ca4:	83 c4 10             	add    $0x10,%esp
  800ca7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cad:	c9                   	leave  
  800cae:	c3                   	ret    

00800caf <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
  800cb2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cbc:	eb 06                	jmp    800cc4 <strlen+0x15>
		n++;
  800cbe:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cc1:	ff 45 08             	incl   0x8(%ebp)
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8a 00                	mov    (%eax),%al
  800cc9:	84 c0                	test   %al,%al
  800ccb:	75 f1                	jne    800cbe <strlen+0xf>
		n++;
	return n;
  800ccd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd0:	c9                   	leave  
  800cd1:	c3                   	ret    

00800cd2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cdf:	eb 09                	jmp    800cea <strnlen+0x18>
		n++;
  800ce1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ce4:	ff 45 08             	incl   0x8(%ebp)
  800ce7:	ff 4d 0c             	decl   0xc(%ebp)
  800cea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cee:	74 09                	je     800cf9 <strnlen+0x27>
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	8a 00                	mov    (%eax),%al
  800cf5:	84 c0                	test   %al,%al
  800cf7:	75 e8                	jne    800ce1 <strnlen+0xf>
		n++;
	return n;
  800cf9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    

00800cfe <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d0a:	90                   	nop
  800d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0e:	8d 50 01             	lea    0x1(%eax),%edx
  800d11:	89 55 08             	mov    %edx,0x8(%ebp)
  800d14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d17:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d1a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d1d:	8a 12                	mov    (%edx),%dl
  800d1f:	88 10                	mov    %dl,(%eax)
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	84 c0                	test   %al,%al
  800d25:	75 e4                	jne    800d0b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d27:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d2a:	c9                   	leave  
  800d2b:	c3                   	ret    

00800d2c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
  800d2f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d3f:	eb 1f                	jmp    800d60 <strncpy+0x34>
		*dst++ = *src;
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	8d 50 01             	lea    0x1(%eax),%edx
  800d47:	89 55 08             	mov    %edx,0x8(%ebp)
  800d4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d4d:	8a 12                	mov    (%edx),%dl
  800d4f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d54:	8a 00                	mov    (%eax),%al
  800d56:	84 c0                	test   %al,%al
  800d58:	74 03                	je     800d5d <strncpy+0x31>
			src++;
  800d5a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d5d:	ff 45 fc             	incl   -0x4(%ebp)
  800d60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d63:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d66:	72 d9                	jb     800d41 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d68:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d6b:	c9                   	leave  
  800d6c:	c3                   	ret    

00800d6d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7d:	74 30                	je     800daf <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d7f:	eb 16                	jmp    800d97 <strlcpy+0x2a>
			*dst++ = *src++;
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	8d 50 01             	lea    0x1(%eax),%edx
  800d87:	89 55 08             	mov    %edx,0x8(%ebp)
  800d8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d8d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d90:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d93:	8a 12                	mov    (%edx),%dl
  800d95:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d97:	ff 4d 10             	decl   0x10(%ebp)
  800d9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d9e:	74 09                	je     800da9 <strlcpy+0x3c>
  800da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da3:	8a 00                	mov    (%eax),%al
  800da5:	84 c0                	test   %al,%al
  800da7:	75 d8                	jne    800d81 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800daf:	8b 55 08             	mov    0x8(%ebp),%edx
  800db2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db5:	29 c2                	sub    %eax,%edx
  800db7:	89 d0                	mov    %edx,%eax
}
  800db9:	c9                   	leave  
  800dba:	c3                   	ret    

00800dbb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dbe:	eb 06                	jmp    800dc6 <strcmp+0xb>
		p++, q++;
  800dc0:	ff 45 08             	incl   0x8(%ebp)
  800dc3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	8a 00                	mov    (%eax),%al
  800dcb:	84 c0                	test   %al,%al
  800dcd:	74 0e                	je     800ddd <strcmp+0x22>
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	8a 10                	mov    (%eax),%dl
  800dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	38 c2                	cmp    %al,%dl
  800ddb:	74 e3                	je     800dc0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	8a 00                	mov    (%eax),%al
  800de2:	0f b6 d0             	movzbl %al,%edx
  800de5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de8:	8a 00                	mov    (%eax),%al
  800dea:	0f b6 c0             	movzbl %al,%eax
  800ded:	29 c2                	sub    %eax,%edx
  800def:	89 d0                	mov    %edx,%eax
}
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    

00800df3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800df6:	eb 09                	jmp    800e01 <strncmp+0xe>
		n--, p++, q++;
  800df8:	ff 4d 10             	decl   0x10(%ebp)
  800dfb:	ff 45 08             	incl   0x8(%ebp)
  800dfe:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e05:	74 17                	je     800e1e <strncmp+0x2b>
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8a 00                	mov    (%eax),%al
  800e0c:	84 c0                	test   %al,%al
  800e0e:	74 0e                	je     800e1e <strncmp+0x2b>
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8a 10                	mov    (%eax),%dl
  800e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e18:	8a 00                	mov    (%eax),%al
  800e1a:	38 c2                	cmp    %al,%dl
  800e1c:	74 da                	je     800df8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e1e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e22:	75 07                	jne    800e2b <strncmp+0x38>
		return 0;
  800e24:	b8 00 00 00 00       	mov    $0x0,%eax
  800e29:	eb 14                	jmp    800e3f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	8a 00                	mov    (%eax),%al
  800e30:	0f b6 d0             	movzbl %al,%edx
  800e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e36:	8a 00                	mov    (%eax),%al
  800e38:	0f b6 c0             	movzbl %al,%eax
  800e3b:	29 c2                	sub    %eax,%edx
  800e3d:	89 d0                	mov    %edx,%eax
}
  800e3f:	5d                   	pop    %ebp
  800e40:	c3                   	ret    

00800e41 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	83 ec 04             	sub    $0x4,%esp
  800e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e4d:	eb 12                	jmp    800e61 <strchr+0x20>
		if (*s == c)
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e57:	75 05                	jne    800e5e <strchr+0x1d>
			return (char *) s;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	eb 11                	jmp    800e6f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e5e:	ff 45 08             	incl   0x8(%ebp)
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	8a 00                	mov    (%eax),%al
  800e66:	84 c0                	test   %al,%al
  800e68:	75 e5                	jne    800e4f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e6f:	c9                   	leave  
  800e70:	c3                   	ret    

00800e71 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e71:	55                   	push   %ebp
  800e72:	89 e5                	mov    %esp,%ebp
  800e74:	83 ec 04             	sub    $0x4,%esp
  800e77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e7d:	eb 0d                	jmp    800e8c <strfind+0x1b>
		if (*s == c)
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	8a 00                	mov    (%eax),%al
  800e84:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e87:	74 0e                	je     800e97 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e89:	ff 45 08             	incl   0x8(%ebp)
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	8a 00                	mov    (%eax),%al
  800e91:	84 c0                	test   %al,%al
  800e93:	75 ea                	jne    800e7f <strfind+0xe>
  800e95:	eb 01                	jmp    800e98 <strfind+0x27>
		if (*s == c)
			break;
  800e97:	90                   	nop
	return (char *) s;
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e9b:	c9                   	leave  
  800e9c:	c3                   	ret    

00800e9d <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e9d:	55                   	push   %ebp
  800e9e:	89 e5                	mov    %esp,%ebp
  800ea0:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800ea9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ead:	76 63                	jbe    800f12 <memset+0x75>
		uint64 data_block = c;
  800eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb2:	99                   	cltd   
  800eb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800eb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ebc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ebf:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ec3:	c1 e0 08             	shl    $0x8,%eax
  800ec6:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ec9:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ecf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed2:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ed6:	c1 e0 10             	shl    $0x10,%eax
  800ed9:	09 45 f0             	or     %eax,-0x10(%ebp)
  800edc:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee5:	89 c2                	mov    %eax,%edx
  800ee7:	b8 00 00 00 00       	mov    $0x0,%eax
  800eec:	09 45 f0             	or     %eax,-0x10(%ebp)
  800eef:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ef2:	eb 18                	jmp    800f0c <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ef4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ef7:	8d 41 08             	lea    0x8(%ecx),%eax
  800efa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f03:	89 01                	mov    %eax,(%ecx)
  800f05:	89 51 04             	mov    %edx,0x4(%ecx)
  800f08:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f0c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f10:	77 e2                	ja     800ef4 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f16:	74 23                	je     800f3b <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f1e:	eb 0e                	jmp    800f2e <memset+0x91>
			*p8++ = (uint8)c;
  800f20:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f23:	8d 50 01             	lea    0x1(%eax),%edx
  800f26:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f2c:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f34:	89 55 10             	mov    %edx,0x10(%ebp)
  800f37:	85 c0                	test   %eax,%eax
  800f39:	75 e5                	jne    800f20 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3e:	c9                   	leave  
  800f3f:	c3                   	ret    

00800f40 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f52:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f56:	76 24                	jbe    800f7c <memcpy+0x3c>
		while(n >= 8){
  800f58:	eb 1c                	jmp    800f76 <memcpy+0x36>
			*d64 = *s64;
  800f5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5d:	8b 50 04             	mov    0x4(%eax),%edx
  800f60:	8b 00                	mov    (%eax),%eax
  800f62:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f65:	89 01                	mov    %eax,(%ecx)
  800f67:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f6a:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f6e:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f72:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f76:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f7a:	77 de                	ja     800f5a <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f80:	74 31                	je     800fb3 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f82:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f85:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f88:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f8e:	eb 16                	jmp    800fa6 <memcpy+0x66>
			*d8++ = *s8++;
  800f90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f93:	8d 50 01             	lea    0x1(%eax),%edx
  800f96:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f9c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f9f:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800fa2:	8a 12                	mov    (%edx),%dl
  800fa4:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800fa6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fac:	89 55 10             	mov    %edx,0x10(%ebp)
  800faf:	85 c0                	test   %eax,%eax
  800fb1:	75 dd                	jne    800f90 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb6:	c9                   	leave  
  800fb7:	c3                   	ret    

00800fb8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fb8:	55                   	push   %ebp
  800fb9:	89 e5                	mov    %esp,%ebp
  800fbb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fcd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fd0:	73 50                	jae    801022 <memmove+0x6a>
  800fd2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd8:	01 d0                	add    %edx,%eax
  800fda:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fdd:	76 43                	jbe    801022 <memmove+0x6a>
		s += n;
  800fdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fe5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800feb:	eb 10                	jmp    800ffd <memmove+0x45>
			*--d = *--s;
  800fed:	ff 4d f8             	decl   -0x8(%ebp)
  800ff0:	ff 4d fc             	decl   -0x4(%ebp)
  800ff3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff6:	8a 10                	mov    (%eax),%dl
  800ff8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ffb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ffd:	8b 45 10             	mov    0x10(%ebp),%eax
  801000:	8d 50 ff             	lea    -0x1(%eax),%edx
  801003:	89 55 10             	mov    %edx,0x10(%ebp)
  801006:	85 c0                	test   %eax,%eax
  801008:	75 e3                	jne    800fed <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80100a:	eb 23                	jmp    80102f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80100c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80100f:	8d 50 01             	lea    0x1(%eax),%edx
  801012:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801015:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801018:	8d 4a 01             	lea    0x1(%edx),%ecx
  80101b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80101e:	8a 12                	mov    (%edx),%dl
  801020:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
  801025:	8d 50 ff             	lea    -0x1(%eax),%edx
  801028:	89 55 10             	mov    %edx,0x10(%ebp)
  80102b:	85 c0                	test   %eax,%eax
  80102d:	75 dd                	jne    80100c <memmove+0x54>
			*d++ = *s++;

	return dst;
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801032:	c9                   	leave  
  801033:	c3                   	ret    

00801034 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801040:	8b 45 0c             	mov    0xc(%ebp),%eax
  801043:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801046:	eb 2a                	jmp    801072 <memcmp+0x3e>
		if (*s1 != *s2)
  801048:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104b:	8a 10                	mov    (%eax),%dl
  80104d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801050:	8a 00                	mov    (%eax),%al
  801052:	38 c2                	cmp    %al,%dl
  801054:	74 16                	je     80106c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801056:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801059:	8a 00                	mov    (%eax),%al
  80105b:	0f b6 d0             	movzbl %al,%edx
  80105e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801061:	8a 00                	mov    (%eax),%al
  801063:	0f b6 c0             	movzbl %al,%eax
  801066:	29 c2                	sub    %eax,%edx
  801068:	89 d0                	mov    %edx,%eax
  80106a:	eb 18                	jmp    801084 <memcmp+0x50>
		s1++, s2++;
  80106c:	ff 45 fc             	incl   -0x4(%ebp)
  80106f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801072:	8b 45 10             	mov    0x10(%ebp),%eax
  801075:	8d 50 ff             	lea    -0x1(%eax),%edx
  801078:	89 55 10             	mov    %edx,0x10(%ebp)
  80107b:	85 c0                	test   %eax,%eax
  80107d:	75 c9                	jne    801048 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80107f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801084:	c9                   	leave  
  801085:	c3                   	ret    

00801086 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801086:	55                   	push   %ebp
  801087:	89 e5                	mov    %esp,%ebp
  801089:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80108c:	8b 55 08             	mov    0x8(%ebp),%edx
  80108f:	8b 45 10             	mov    0x10(%ebp),%eax
  801092:	01 d0                	add    %edx,%eax
  801094:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801097:	eb 15                	jmp    8010ae <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	8a 00                	mov    (%eax),%al
  80109e:	0f b6 d0             	movzbl %al,%edx
  8010a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a4:	0f b6 c0             	movzbl %al,%eax
  8010a7:	39 c2                	cmp    %eax,%edx
  8010a9:	74 0d                	je     8010b8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010ab:	ff 45 08             	incl   0x8(%ebp)
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010b4:	72 e3                	jb     801099 <memfind+0x13>
  8010b6:	eb 01                	jmp    8010b9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010b8:	90                   	nop
	return (void *) s;
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010bc:	c9                   	leave  
  8010bd:	c3                   	ret    

008010be <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010be:	55                   	push   %ebp
  8010bf:	89 e5                	mov    %esp,%ebp
  8010c1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010d2:	eb 03                	jmp    8010d7 <strtol+0x19>
		s++;
  8010d4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8a 00                	mov    (%eax),%al
  8010dc:	3c 20                	cmp    $0x20,%al
  8010de:	74 f4                	je     8010d4 <strtol+0x16>
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	3c 09                	cmp    $0x9,%al
  8010e7:	74 eb                	je     8010d4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	8a 00                	mov    (%eax),%al
  8010ee:	3c 2b                	cmp    $0x2b,%al
  8010f0:	75 05                	jne    8010f7 <strtol+0x39>
		s++;
  8010f2:	ff 45 08             	incl   0x8(%ebp)
  8010f5:	eb 13                	jmp    80110a <strtol+0x4c>
	else if (*s == '-')
  8010f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fa:	8a 00                	mov    (%eax),%al
  8010fc:	3c 2d                	cmp    $0x2d,%al
  8010fe:	75 0a                	jne    80110a <strtol+0x4c>
		s++, neg = 1;
  801100:	ff 45 08             	incl   0x8(%ebp)
  801103:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80110a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110e:	74 06                	je     801116 <strtol+0x58>
  801110:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801114:	75 20                	jne    801136 <strtol+0x78>
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	8a 00                	mov    (%eax),%al
  80111b:	3c 30                	cmp    $0x30,%al
  80111d:	75 17                	jne    801136 <strtol+0x78>
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
  801122:	40                   	inc    %eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	3c 78                	cmp    $0x78,%al
  801127:	75 0d                	jne    801136 <strtol+0x78>
		s += 2, base = 16;
  801129:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80112d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801134:	eb 28                	jmp    80115e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801136:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80113a:	75 15                	jne    801151 <strtol+0x93>
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	3c 30                	cmp    $0x30,%al
  801143:	75 0c                	jne    801151 <strtol+0x93>
		s++, base = 8;
  801145:	ff 45 08             	incl   0x8(%ebp)
  801148:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80114f:	eb 0d                	jmp    80115e <strtol+0xa0>
	else if (base == 0)
  801151:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801155:	75 07                	jne    80115e <strtol+0xa0>
		base = 10;
  801157:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	3c 2f                	cmp    $0x2f,%al
  801165:	7e 19                	jle    801180 <strtol+0xc2>
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
  80116a:	8a 00                	mov    (%eax),%al
  80116c:	3c 39                	cmp    $0x39,%al
  80116e:	7f 10                	jg     801180 <strtol+0xc2>
			dig = *s - '0';
  801170:	8b 45 08             	mov    0x8(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	0f be c0             	movsbl %al,%eax
  801178:	83 e8 30             	sub    $0x30,%eax
  80117b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80117e:	eb 42                	jmp    8011c2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	3c 60                	cmp    $0x60,%al
  801187:	7e 19                	jle    8011a2 <strtol+0xe4>
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	3c 7a                	cmp    $0x7a,%al
  801190:	7f 10                	jg     8011a2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801192:	8b 45 08             	mov    0x8(%ebp),%eax
  801195:	8a 00                	mov    (%eax),%al
  801197:	0f be c0             	movsbl %al,%eax
  80119a:	83 e8 57             	sub    $0x57,%eax
  80119d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011a0:	eb 20                	jmp    8011c2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a5:	8a 00                	mov    (%eax),%al
  8011a7:	3c 40                	cmp    $0x40,%al
  8011a9:	7e 39                	jle    8011e4 <strtol+0x126>
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ae:	8a 00                	mov    (%eax),%al
  8011b0:	3c 5a                	cmp    $0x5a,%al
  8011b2:	7f 30                	jg     8011e4 <strtol+0x126>
			dig = *s - 'A' + 10;
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	0f be c0             	movsbl %al,%eax
  8011bc:	83 e8 37             	sub    $0x37,%eax
  8011bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011c8:	7d 19                	jge    8011e3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011ca:	ff 45 08             	incl   0x8(%ebp)
  8011cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d0:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011d4:	89 c2                	mov    %eax,%edx
  8011d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d9:	01 d0                	add    %edx,%eax
  8011db:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011de:	e9 7b ff ff ff       	jmp    80115e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011e3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011e8:	74 08                	je     8011f2 <strtol+0x134>
		*endptr = (char *) s;
  8011ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011f6:	74 07                	je     8011ff <strtol+0x141>
  8011f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011fb:	f7 d8                	neg    %eax
  8011fd:	eb 03                	jmp    801202 <strtol+0x144>
  8011ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801202:	c9                   	leave  
  801203:	c3                   	ret    

00801204 <ltostr>:

void
ltostr(long value, char *str)
{
  801204:	55                   	push   %ebp
  801205:	89 e5                	mov    %esp,%ebp
  801207:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80120a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801211:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801218:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80121c:	79 13                	jns    801231 <ltostr+0x2d>
	{
		neg = 1;
  80121e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801225:	8b 45 0c             	mov    0xc(%ebp),%eax
  801228:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80122b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80122e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801239:	99                   	cltd   
  80123a:	f7 f9                	idiv   %ecx
  80123c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80123f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801242:	8d 50 01             	lea    0x1(%eax),%edx
  801245:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801248:	89 c2                	mov    %eax,%edx
  80124a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124d:	01 d0                	add    %edx,%eax
  80124f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801252:	83 c2 30             	add    $0x30,%edx
  801255:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801257:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80125a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80125f:	f7 e9                	imul   %ecx
  801261:	c1 fa 02             	sar    $0x2,%edx
  801264:	89 c8                	mov    %ecx,%eax
  801266:	c1 f8 1f             	sar    $0x1f,%eax
  801269:	29 c2                	sub    %eax,%edx
  80126b:	89 d0                	mov    %edx,%eax
  80126d:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801270:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801274:	75 bb                	jne    801231 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801276:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80127d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801280:	48                   	dec    %eax
  801281:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801284:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801288:	74 3d                	je     8012c7 <ltostr+0xc3>
		start = 1 ;
  80128a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801291:	eb 34                	jmp    8012c7 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801293:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	01 d0                	add    %edx,%eax
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a6:	01 c2                	add    %eax,%edx
  8012a8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ae:	01 c8                	add    %ecx,%eax
  8012b0:	8a 00                	mov    (%eax),%al
  8012b2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ba:	01 c2                	add    %eax,%edx
  8012bc:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012bf:	88 02                	mov    %al,(%edx)
		start++ ;
  8012c1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012c4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ca:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012cd:	7c c4                	jl     801293 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012cf:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d5:	01 d0                	add    %edx,%eax
  8012d7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012da:	90                   	nop
  8012db:	c9                   	leave  
  8012dc:	c3                   	ret    

008012dd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012dd:	55                   	push   %ebp
  8012de:	89 e5                	mov    %esp,%ebp
  8012e0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012e3:	ff 75 08             	pushl  0x8(%ebp)
  8012e6:	e8 c4 f9 ff ff       	call   800caf <strlen>
  8012eb:	83 c4 04             	add    $0x4,%esp
  8012ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012f1:	ff 75 0c             	pushl  0xc(%ebp)
  8012f4:	e8 b6 f9 ff ff       	call   800caf <strlen>
  8012f9:	83 c4 04             	add    $0x4,%esp
  8012fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801306:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80130d:	eb 17                	jmp    801326 <strcconcat+0x49>
		final[s] = str1[s] ;
  80130f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801312:	8b 45 10             	mov    0x10(%ebp),%eax
  801315:	01 c2                	add    %eax,%edx
  801317:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	01 c8                	add    %ecx,%eax
  80131f:	8a 00                	mov    (%eax),%al
  801321:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801323:	ff 45 fc             	incl   -0x4(%ebp)
  801326:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801329:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80132c:	7c e1                	jl     80130f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80132e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801335:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80133c:	eb 1f                	jmp    80135d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80133e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801341:	8d 50 01             	lea    0x1(%eax),%edx
  801344:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801347:	89 c2                	mov    %eax,%edx
  801349:	8b 45 10             	mov    0x10(%ebp),%eax
  80134c:	01 c2                	add    %eax,%edx
  80134e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801351:	8b 45 0c             	mov    0xc(%ebp),%eax
  801354:	01 c8                	add    %ecx,%eax
  801356:	8a 00                	mov    (%eax),%al
  801358:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80135a:	ff 45 f8             	incl   -0x8(%ebp)
  80135d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801360:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801363:	7c d9                	jl     80133e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801365:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801368:	8b 45 10             	mov    0x10(%ebp),%eax
  80136b:	01 d0                	add    %edx,%eax
  80136d:	c6 00 00             	movb   $0x0,(%eax)
}
  801370:	90                   	nop
  801371:	c9                   	leave  
  801372:	c3                   	ret    

00801373 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801376:	8b 45 14             	mov    0x14(%ebp),%eax
  801379:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80137f:	8b 45 14             	mov    0x14(%ebp),%eax
  801382:	8b 00                	mov    (%eax),%eax
  801384:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80138b:	8b 45 10             	mov    0x10(%ebp),%eax
  80138e:	01 d0                	add    %edx,%eax
  801390:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801396:	eb 0c                	jmp    8013a4 <strsplit+0x31>
			*string++ = 0;
  801398:	8b 45 08             	mov    0x8(%ebp),%eax
  80139b:	8d 50 01             	lea    0x1(%eax),%edx
  80139e:	89 55 08             	mov    %edx,0x8(%ebp)
  8013a1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	8a 00                	mov    (%eax),%al
  8013a9:	84 c0                	test   %al,%al
  8013ab:	74 18                	je     8013c5 <strsplit+0x52>
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	0f be c0             	movsbl %al,%eax
  8013b5:	50                   	push   %eax
  8013b6:	ff 75 0c             	pushl  0xc(%ebp)
  8013b9:	e8 83 fa ff ff       	call   800e41 <strchr>
  8013be:	83 c4 08             	add    $0x8,%esp
  8013c1:	85 c0                	test   %eax,%eax
  8013c3:	75 d3                	jne    801398 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c8:	8a 00                	mov    (%eax),%al
  8013ca:	84 c0                	test   %al,%al
  8013cc:	74 5a                	je     801428 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d1:	8b 00                	mov    (%eax),%eax
  8013d3:	83 f8 0f             	cmp    $0xf,%eax
  8013d6:	75 07                	jne    8013df <strsplit+0x6c>
		{
			return 0;
  8013d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8013dd:	eb 66                	jmp    801445 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013df:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e2:	8b 00                	mov    (%eax),%eax
  8013e4:	8d 48 01             	lea    0x1(%eax),%ecx
  8013e7:	8b 55 14             	mov    0x14(%ebp),%edx
  8013ea:	89 0a                	mov    %ecx,(%edx)
  8013ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f6:	01 c2                	add    %eax,%edx
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013fd:	eb 03                	jmp    801402 <strsplit+0x8f>
			string++;
  8013ff:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	8a 00                	mov    (%eax),%al
  801407:	84 c0                	test   %al,%al
  801409:	74 8b                	je     801396 <strsplit+0x23>
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	8a 00                	mov    (%eax),%al
  801410:	0f be c0             	movsbl %al,%eax
  801413:	50                   	push   %eax
  801414:	ff 75 0c             	pushl  0xc(%ebp)
  801417:	e8 25 fa ff ff       	call   800e41 <strchr>
  80141c:	83 c4 08             	add    $0x8,%esp
  80141f:	85 c0                	test   %eax,%eax
  801421:	74 dc                	je     8013ff <strsplit+0x8c>
			string++;
	}
  801423:	e9 6e ff ff ff       	jmp    801396 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801428:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801429:	8b 45 14             	mov    0x14(%ebp),%eax
  80142c:	8b 00                	mov    (%eax),%eax
  80142e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801435:	8b 45 10             	mov    0x10(%ebp),%eax
  801438:	01 d0                	add    %edx,%eax
  80143a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801440:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
  801450:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801453:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80145a:	eb 4a                	jmp    8014a6 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80145c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80145f:	8b 45 08             	mov    0x8(%ebp),%eax
  801462:	01 c2                	add    %eax,%edx
  801464:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801467:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146a:	01 c8                	add    %ecx,%eax
  80146c:	8a 00                	mov    (%eax),%al
  80146e:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801470:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801473:	8b 45 0c             	mov    0xc(%ebp),%eax
  801476:	01 d0                	add    %edx,%eax
  801478:	8a 00                	mov    (%eax),%al
  80147a:	3c 40                	cmp    $0x40,%al
  80147c:	7e 25                	jle    8014a3 <str2lower+0x5c>
  80147e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801481:	8b 45 0c             	mov    0xc(%ebp),%eax
  801484:	01 d0                	add    %edx,%eax
  801486:	8a 00                	mov    (%eax),%al
  801488:	3c 5a                	cmp    $0x5a,%al
  80148a:	7f 17                	jg     8014a3 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80148c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	01 d0                	add    %edx,%eax
  801494:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801497:	8b 55 08             	mov    0x8(%ebp),%edx
  80149a:	01 ca                	add    %ecx,%edx
  80149c:	8a 12                	mov    (%edx),%dl
  80149e:	83 c2 20             	add    $0x20,%edx
  8014a1:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8014a3:	ff 45 fc             	incl   -0x4(%ebp)
  8014a6:	ff 75 0c             	pushl  0xc(%ebp)
  8014a9:	e8 01 f8 ff ff       	call   800caf <strlen>
  8014ae:	83 c4 04             	add    $0x4,%esp
  8014b1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014b4:	7f a6                	jg     80145c <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	57                   	push   %edi
  8014bf:	56                   	push   %esi
  8014c0:	53                   	push   %ebx
  8014c1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014cd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014d0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014d3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014d6:	cd 30                	int    $0x30
  8014d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8014db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014de:	83 c4 10             	add    $0x10,%esp
  8014e1:	5b                   	pop    %ebx
  8014e2:	5e                   	pop    %esi
  8014e3:	5f                   	pop    %edi
  8014e4:	5d                   	pop    %ebp
  8014e5:	c3                   	ret    

008014e6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	83 ec 04             	sub    $0x4,%esp
  8014ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8014f2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014f5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	6a 00                	push   $0x0
  8014fe:	51                   	push   %ecx
  8014ff:	52                   	push   %edx
  801500:	ff 75 0c             	pushl  0xc(%ebp)
  801503:	50                   	push   %eax
  801504:	6a 00                	push   $0x0
  801506:	e8 b0 ff ff ff       	call   8014bb <syscall>
  80150b:	83 c4 18             	add    $0x18,%esp
}
  80150e:	90                   	nop
  80150f:	c9                   	leave  
  801510:	c3                   	ret    

00801511 <sys_cgetc>:

int
sys_cgetc(void)
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	6a 02                	push   $0x2
  801520:	e8 96 ff ff ff       	call   8014bb <syscall>
  801525:	83 c4 18             	add    $0x18,%esp
}
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <sys_lock_cons>:

void sys_lock_cons(void)
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	6a 03                	push   $0x3
  801539:	e8 7d ff ff ff       	call   8014bb <syscall>
  80153e:	83 c4 18             	add    $0x18,%esp
}
  801541:	90                   	nop
  801542:	c9                   	leave  
  801543:	c3                   	ret    

00801544 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801544:	55                   	push   %ebp
  801545:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	6a 00                	push   $0x0
  801551:	6a 04                	push   $0x4
  801553:	e8 63 ff ff ff       	call   8014bb <syscall>
  801558:	83 c4 18             	add    $0x18,%esp
}
  80155b:	90                   	nop
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    

0080155e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801561:	8b 55 0c             	mov    0xc(%ebp),%edx
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	52                   	push   %edx
  80156e:	50                   	push   %eax
  80156f:	6a 08                	push   $0x8
  801571:	e8 45 ff ff ff       	call   8014bb <syscall>
  801576:	83 c4 18             	add    $0x18,%esp
}
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	56                   	push   %esi
  80157f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801580:	8b 75 18             	mov    0x18(%ebp),%esi
  801583:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801586:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801589:	8b 55 0c             	mov    0xc(%ebp),%edx
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	56                   	push   %esi
  801590:	53                   	push   %ebx
  801591:	51                   	push   %ecx
  801592:	52                   	push   %edx
  801593:	50                   	push   %eax
  801594:	6a 09                	push   $0x9
  801596:	e8 20 ff ff ff       	call   8014bb <syscall>
  80159b:	83 c4 18             	add    $0x18,%esp
}
  80159e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015a1:	5b                   	pop    %ebx
  8015a2:	5e                   	pop    %esi
  8015a3:	5d                   	pop    %ebp
  8015a4:	c3                   	ret    

008015a5 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	ff 75 08             	pushl  0x8(%ebp)
  8015b3:	6a 0a                	push   $0xa
  8015b5:	e8 01 ff ff ff       	call   8014bb <syscall>
  8015ba:	83 c4 18             	add    $0x18,%esp
}
  8015bd:	c9                   	leave  
  8015be:	c3                   	ret    

008015bf <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	ff 75 0c             	pushl  0xc(%ebp)
  8015cb:	ff 75 08             	pushl  0x8(%ebp)
  8015ce:	6a 0b                	push   $0xb
  8015d0:	e8 e6 fe ff ff       	call   8014bb <syscall>
  8015d5:	83 c4 18             	add    $0x18,%esp
}
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 0c                	push   $0xc
  8015e9:	e8 cd fe ff ff       	call   8014bb <syscall>
  8015ee:	83 c4 18             	add    $0x18,%esp
}
  8015f1:	c9                   	leave  
  8015f2:	c3                   	ret    

008015f3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 0d                	push   $0xd
  801602:	e8 b4 fe ff ff       	call   8014bb <syscall>
  801607:	83 c4 18             	add    $0x18,%esp
}
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    

0080160c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 0e                	push   $0xe
  80161b:	e8 9b fe ff ff       	call   8014bb <syscall>
  801620:	83 c4 18             	add    $0x18,%esp
}
  801623:	c9                   	leave  
  801624:	c3                   	ret    

00801625 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 0f                	push   $0xf
  801634:	e8 82 fe ff ff       	call   8014bb <syscall>
  801639:	83 c4 18             	add    $0x18,%esp
}
  80163c:	c9                   	leave  
  80163d:	c3                   	ret    

0080163e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	ff 75 08             	pushl  0x8(%ebp)
  80164c:	6a 10                	push   $0x10
  80164e:	e8 68 fe ff ff       	call   8014bb <syscall>
  801653:	83 c4 18             	add    $0x18,%esp
}
  801656:	c9                   	leave  
  801657:	c3                   	ret    

00801658 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 11                	push   $0x11
  801667:	e8 4f fe ff ff       	call   8014bb <syscall>
  80166c:	83 c4 18             	add    $0x18,%esp
}
  80166f:	90                   	nop
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <sys_cputc>:

void
sys_cputc(const char c)
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
  801675:	83 ec 04             	sub    $0x4,%esp
  801678:	8b 45 08             	mov    0x8(%ebp),%eax
  80167b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80167e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	50                   	push   %eax
  80168b:	6a 01                	push   $0x1
  80168d:	e8 29 fe ff ff       	call   8014bb <syscall>
  801692:	83 c4 18             	add    $0x18,%esp
}
  801695:	90                   	nop
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 14                	push   $0x14
  8016a7:	e8 0f fe ff ff       	call   8014bb <syscall>
  8016ac:	83 c4 18             	add    $0x18,%esp
}
  8016af:	90                   	nop
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    

008016b2 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
  8016b5:	83 ec 04             	sub    $0x4,%esp
  8016b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bb:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016be:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016c1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	6a 00                	push   $0x0
  8016ca:	51                   	push   %ecx
  8016cb:	52                   	push   %edx
  8016cc:	ff 75 0c             	pushl  0xc(%ebp)
  8016cf:	50                   	push   %eax
  8016d0:	6a 15                	push   $0x15
  8016d2:	e8 e4 fd ff ff       	call   8014bb <syscall>
  8016d7:	83 c4 18             	add    $0x18,%esp
}
  8016da:	c9                   	leave  
  8016db:	c3                   	ret    

008016dc <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	52                   	push   %edx
  8016ec:	50                   	push   %eax
  8016ed:	6a 16                	push   $0x16
  8016ef:	e8 c7 fd ff ff       	call   8014bb <syscall>
  8016f4:	83 c4 18             	add    $0x18,%esp
}
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    

008016f9 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	51                   	push   %ecx
  80170a:	52                   	push   %edx
  80170b:	50                   	push   %eax
  80170c:	6a 17                	push   $0x17
  80170e:	e8 a8 fd ff ff       	call   8014bb <syscall>
  801713:	83 c4 18             	add    $0x18,%esp
}
  801716:	c9                   	leave  
  801717:	c3                   	ret    

00801718 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80171b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	52                   	push   %edx
  801728:	50                   	push   %eax
  801729:	6a 18                	push   $0x18
  80172b:	e8 8b fd ff ff       	call   8014bb <syscall>
  801730:	83 c4 18             	add    $0x18,%esp
}
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	6a 00                	push   $0x0
  80173d:	ff 75 14             	pushl  0x14(%ebp)
  801740:	ff 75 10             	pushl  0x10(%ebp)
  801743:	ff 75 0c             	pushl  0xc(%ebp)
  801746:	50                   	push   %eax
  801747:	6a 19                	push   $0x19
  801749:	e8 6d fd ff ff       	call   8014bb <syscall>
  80174e:	83 c4 18             	add    $0x18,%esp
}
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801756:	8b 45 08             	mov    0x8(%ebp),%eax
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	50                   	push   %eax
  801762:	6a 1a                	push   $0x1a
  801764:	e8 52 fd ff ff       	call   8014bb <syscall>
  801769:	83 c4 18             	add    $0x18,%esp
}
  80176c:	90                   	nop
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    

0080176f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801772:	8b 45 08             	mov    0x8(%ebp),%eax
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	50                   	push   %eax
  80177e:	6a 1b                	push   $0x1b
  801780:	e8 36 fd ff ff       	call   8014bb <syscall>
  801785:	83 c4 18             	add    $0x18,%esp
}
  801788:	c9                   	leave  
  801789:	c3                   	ret    

0080178a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 05                	push   $0x5
  801799:	e8 1d fd ff ff       	call   8014bb <syscall>
  80179e:	83 c4 18             	add    $0x18,%esp
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 06                	push   $0x6
  8017b2:	e8 04 fd ff ff       	call   8014bb <syscall>
  8017b7:	83 c4 18             	add    $0x18,%esp
}
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    

008017bc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 07                	push   $0x7
  8017cb:	e8 eb fc ff ff       	call   8014bb <syscall>
  8017d0:	83 c4 18             	add    $0x18,%esp
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <sys_exit_env>:


void sys_exit_env(void)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 1c                	push   $0x1c
  8017e4:	e8 d2 fc ff ff       	call   8014bb <syscall>
  8017e9:	83 c4 18             	add    $0x18,%esp
}
  8017ec:	90                   	nop
  8017ed:	c9                   	leave  
  8017ee:	c3                   	ret    

008017ef <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
  8017f2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017f5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017f8:	8d 50 04             	lea    0x4(%eax),%edx
  8017fb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	52                   	push   %edx
  801805:	50                   	push   %eax
  801806:	6a 1d                	push   $0x1d
  801808:	e8 ae fc ff ff       	call   8014bb <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
	return result;
  801810:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801813:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801816:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801819:	89 01                	mov    %eax,(%ecx)
  80181b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80181e:	8b 45 08             	mov    0x8(%ebp),%eax
  801821:	c9                   	leave  
  801822:	c2 04 00             	ret    $0x4

00801825 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	ff 75 10             	pushl  0x10(%ebp)
  80182f:	ff 75 0c             	pushl  0xc(%ebp)
  801832:	ff 75 08             	pushl  0x8(%ebp)
  801835:	6a 13                	push   $0x13
  801837:	e8 7f fc ff ff       	call   8014bb <syscall>
  80183c:	83 c4 18             	add    $0x18,%esp
	return ;
  80183f:	90                   	nop
}
  801840:	c9                   	leave  
  801841:	c3                   	ret    

00801842 <sys_rcr2>:
uint32 sys_rcr2()
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 1e                	push   $0x1e
  801851:	e8 65 fc ff ff       	call   8014bb <syscall>
  801856:	83 c4 18             	add    $0x18,%esp
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
  80185e:	83 ec 04             	sub    $0x4,%esp
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801867:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	50                   	push   %eax
  801874:	6a 1f                	push   $0x1f
  801876:	e8 40 fc ff ff       	call   8014bb <syscall>
  80187b:	83 c4 18             	add    $0x18,%esp
	return ;
  80187e:	90                   	nop
}
  80187f:	c9                   	leave  
  801880:	c3                   	ret    

00801881 <rsttst>:
void rsttst()
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 21                	push   $0x21
  801890:	e8 26 fc ff ff       	call   8014bb <syscall>
  801895:	83 c4 18             	add    $0x18,%esp
	return ;
  801898:	90                   	nop
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
  80189e:	83 ec 04             	sub    $0x4,%esp
  8018a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8018a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8018a7:	8b 55 18             	mov    0x18(%ebp),%edx
  8018aa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018ae:	52                   	push   %edx
  8018af:	50                   	push   %eax
  8018b0:	ff 75 10             	pushl  0x10(%ebp)
  8018b3:	ff 75 0c             	pushl  0xc(%ebp)
  8018b6:	ff 75 08             	pushl  0x8(%ebp)
  8018b9:	6a 20                	push   $0x20
  8018bb:	e8 fb fb ff ff       	call   8014bb <syscall>
  8018c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8018c3:	90                   	nop
}
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <chktst>:
void chktst(uint32 n)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	ff 75 08             	pushl  0x8(%ebp)
  8018d4:	6a 22                	push   $0x22
  8018d6:	e8 e0 fb ff ff       	call   8014bb <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
	return ;
  8018de:	90                   	nop
}
  8018df:	c9                   	leave  
  8018e0:	c3                   	ret    

008018e1 <inctst>:

void inctst()
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 23                	push   $0x23
  8018f0:	e8 c6 fb ff ff       	call   8014bb <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f8:	90                   	nop
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <gettst>:
uint32 gettst()
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 24                	push   $0x24
  80190a:	e8 ac fb ff ff       	call   8014bb <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 25                	push   $0x25
  801923:	e8 93 fb ff ff       	call   8014bb <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
  80192b:	a3 c0 70 82 00       	mov    %eax,0x8270c0
	return uheapPlaceStrategy ;
  801930:	a1 c0 70 82 00       	mov    0x8270c0,%eax
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	a3 c0 70 82 00       	mov    %eax,0x8270c0
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	ff 75 08             	pushl  0x8(%ebp)
  80194d:	6a 26                	push   $0x26
  80194f:	e8 67 fb ff ff       	call   8014bb <syscall>
  801954:	83 c4 18             	add    $0x18,%esp
	return ;
  801957:	90                   	nop
}
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
  80195d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80195e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801961:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801964:	8b 55 0c             	mov    0xc(%ebp),%edx
  801967:	8b 45 08             	mov    0x8(%ebp),%eax
  80196a:	6a 00                	push   $0x0
  80196c:	53                   	push   %ebx
  80196d:	51                   	push   %ecx
  80196e:	52                   	push   %edx
  80196f:	50                   	push   %eax
  801970:	6a 27                	push   $0x27
  801972:	e8 44 fb ff ff       	call   8014bb <syscall>
  801977:	83 c4 18             	add    $0x18,%esp
}
  80197a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801982:	8b 55 0c             	mov    0xc(%ebp),%edx
  801985:	8b 45 08             	mov    0x8(%ebp),%eax
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	52                   	push   %edx
  80198f:	50                   	push   %eax
  801990:	6a 28                	push   $0x28
  801992:	e8 24 fb ff ff       	call   8014bb <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80199f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	6a 00                	push   $0x0
  8019aa:	51                   	push   %ecx
  8019ab:	ff 75 10             	pushl  0x10(%ebp)
  8019ae:	52                   	push   %edx
  8019af:	50                   	push   %eax
  8019b0:	6a 29                	push   $0x29
  8019b2:	e8 04 fb ff ff       	call   8014bb <syscall>
  8019b7:	83 c4 18             	add    $0x18,%esp
}
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	ff 75 10             	pushl  0x10(%ebp)
  8019c6:	ff 75 0c             	pushl  0xc(%ebp)
  8019c9:	ff 75 08             	pushl  0x8(%ebp)
  8019cc:	6a 12                	push   $0x12
  8019ce:	e8 e8 fa ff ff       	call   8014bb <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d6:	90                   	nop
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8019dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	52                   	push   %edx
  8019e9:	50                   	push   %eax
  8019ea:	6a 2a                	push   $0x2a
  8019ec:	e8 ca fa ff ff       	call   8014bb <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
	return;
  8019f4:	90                   	nop
}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 2b                	push   $0x2b
  801a06:	e8 b0 fa ff ff       	call   8014bb <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
}
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	ff 75 0c             	pushl  0xc(%ebp)
  801a1c:	ff 75 08             	pushl  0x8(%ebp)
  801a1f:	6a 2d                	push   $0x2d
  801a21:	e8 95 fa ff ff       	call   8014bb <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
	return;
  801a29:	90                   	nop
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	ff 75 0c             	pushl  0xc(%ebp)
  801a38:	ff 75 08             	pushl  0x8(%ebp)
  801a3b:	6a 2c                	push   $0x2c
  801a3d:	e8 79 fa ff ff       	call   8014bb <syscall>
  801a42:	83 c4 18             	add    $0x18,%esp
	return ;
  801a45:	90                   	nop
}
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801a4e:	83 ec 04             	sub    $0x4,%esp
  801a51:	68 e8 24 80 00       	push   $0x8024e8
  801a56:	68 25 01 00 00       	push   $0x125
  801a5b:	68 1b 25 80 00       	push   $0x80251b
  801a60:	e8 a3 e8 ff ff       	call   800308 <_panic>
  801a65:	66 90                	xchg   %ax,%ax
  801a67:	90                   	nop

00801a68 <__udivdi3>:
  801a68:	55                   	push   %ebp
  801a69:	57                   	push   %edi
  801a6a:	56                   	push   %esi
  801a6b:	53                   	push   %ebx
  801a6c:	83 ec 1c             	sub    $0x1c,%esp
  801a6f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a73:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a7b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a7f:	89 ca                	mov    %ecx,%edx
  801a81:	89 f8                	mov    %edi,%eax
  801a83:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a87:	85 f6                	test   %esi,%esi
  801a89:	75 2d                	jne    801ab8 <__udivdi3+0x50>
  801a8b:	39 cf                	cmp    %ecx,%edi
  801a8d:	77 65                	ja     801af4 <__udivdi3+0x8c>
  801a8f:	89 fd                	mov    %edi,%ebp
  801a91:	85 ff                	test   %edi,%edi
  801a93:	75 0b                	jne    801aa0 <__udivdi3+0x38>
  801a95:	b8 01 00 00 00       	mov    $0x1,%eax
  801a9a:	31 d2                	xor    %edx,%edx
  801a9c:	f7 f7                	div    %edi
  801a9e:	89 c5                	mov    %eax,%ebp
  801aa0:	31 d2                	xor    %edx,%edx
  801aa2:	89 c8                	mov    %ecx,%eax
  801aa4:	f7 f5                	div    %ebp
  801aa6:	89 c1                	mov    %eax,%ecx
  801aa8:	89 d8                	mov    %ebx,%eax
  801aaa:	f7 f5                	div    %ebp
  801aac:	89 cf                	mov    %ecx,%edi
  801aae:	89 fa                	mov    %edi,%edx
  801ab0:	83 c4 1c             	add    $0x1c,%esp
  801ab3:	5b                   	pop    %ebx
  801ab4:	5e                   	pop    %esi
  801ab5:	5f                   	pop    %edi
  801ab6:	5d                   	pop    %ebp
  801ab7:	c3                   	ret    
  801ab8:	39 ce                	cmp    %ecx,%esi
  801aba:	77 28                	ja     801ae4 <__udivdi3+0x7c>
  801abc:	0f bd fe             	bsr    %esi,%edi
  801abf:	83 f7 1f             	xor    $0x1f,%edi
  801ac2:	75 40                	jne    801b04 <__udivdi3+0x9c>
  801ac4:	39 ce                	cmp    %ecx,%esi
  801ac6:	72 0a                	jb     801ad2 <__udivdi3+0x6a>
  801ac8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801acc:	0f 87 9e 00 00 00    	ja     801b70 <__udivdi3+0x108>
  801ad2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad7:	89 fa                	mov    %edi,%edx
  801ad9:	83 c4 1c             	add    $0x1c,%esp
  801adc:	5b                   	pop    %ebx
  801add:	5e                   	pop    %esi
  801ade:	5f                   	pop    %edi
  801adf:	5d                   	pop    %ebp
  801ae0:	c3                   	ret    
  801ae1:	8d 76 00             	lea    0x0(%esi),%esi
  801ae4:	31 ff                	xor    %edi,%edi
  801ae6:	31 c0                	xor    %eax,%eax
  801ae8:	89 fa                	mov    %edi,%edx
  801aea:	83 c4 1c             	add    $0x1c,%esp
  801aed:	5b                   	pop    %ebx
  801aee:	5e                   	pop    %esi
  801aef:	5f                   	pop    %edi
  801af0:	5d                   	pop    %ebp
  801af1:	c3                   	ret    
  801af2:	66 90                	xchg   %ax,%ax
  801af4:	89 d8                	mov    %ebx,%eax
  801af6:	f7 f7                	div    %edi
  801af8:	31 ff                	xor    %edi,%edi
  801afa:	89 fa                	mov    %edi,%edx
  801afc:	83 c4 1c             	add    $0x1c,%esp
  801aff:	5b                   	pop    %ebx
  801b00:	5e                   	pop    %esi
  801b01:	5f                   	pop    %edi
  801b02:	5d                   	pop    %ebp
  801b03:	c3                   	ret    
  801b04:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b09:	89 eb                	mov    %ebp,%ebx
  801b0b:	29 fb                	sub    %edi,%ebx
  801b0d:	89 f9                	mov    %edi,%ecx
  801b0f:	d3 e6                	shl    %cl,%esi
  801b11:	89 c5                	mov    %eax,%ebp
  801b13:	88 d9                	mov    %bl,%cl
  801b15:	d3 ed                	shr    %cl,%ebp
  801b17:	89 e9                	mov    %ebp,%ecx
  801b19:	09 f1                	or     %esi,%ecx
  801b1b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b1f:	89 f9                	mov    %edi,%ecx
  801b21:	d3 e0                	shl    %cl,%eax
  801b23:	89 c5                	mov    %eax,%ebp
  801b25:	89 d6                	mov    %edx,%esi
  801b27:	88 d9                	mov    %bl,%cl
  801b29:	d3 ee                	shr    %cl,%esi
  801b2b:	89 f9                	mov    %edi,%ecx
  801b2d:	d3 e2                	shl    %cl,%edx
  801b2f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b33:	88 d9                	mov    %bl,%cl
  801b35:	d3 e8                	shr    %cl,%eax
  801b37:	09 c2                	or     %eax,%edx
  801b39:	89 d0                	mov    %edx,%eax
  801b3b:	89 f2                	mov    %esi,%edx
  801b3d:	f7 74 24 0c          	divl   0xc(%esp)
  801b41:	89 d6                	mov    %edx,%esi
  801b43:	89 c3                	mov    %eax,%ebx
  801b45:	f7 e5                	mul    %ebp
  801b47:	39 d6                	cmp    %edx,%esi
  801b49:	72 19                	jb     801b64 <__udivdi3+0xfc>
  801b4b:	74 0b                	je     801b58 <__udivdi3+0xf0>
  801b4d:	89 d8                	mov    %ebx,%eax
  801b4f:	31 ff                	xor    %edi,%edi
  801b51:	e9 58 ff ff ff       	jmp    801aae <__udivdi3+0x46>
  801b56:	66 90                	xchg   %ax,%ax
  801b58:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b5c:	89 f9                	mov    %edi,%ecx
  801b5e:	d3 e2                	shl    %cl,%edx
  801b60:	39 c2                	cmp    %eax,%edx
  801b62:	73 e9                	jae    801b4d <__udivdi3+0xe5>
  801b64:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b67:	31 ff                	xor    %edi,%edi
  801b69:	e9 40 ff ff ff       	jmp    801aae <__udivdi3+0x46>
  801b6e:	66 90                	xchg   %ax,%ax
  801b70:	31 c0                	xor    %eax,%eax
  801b72:	e9 37 ff ff ff       	jmp    801aae <__udivdi3+0x46>
  801b77:	90                   	nop

00801b78 <__umoddi3>:
  801b78:	55                   	push   %ebp
  801b79:	57                   	push   %edi
  801b7a:	56                   	push   %esi
  801b7b:	53                   	push   %ebx
  801b7c:	83 ec 1c             	sub    $0x1c,%esp
  801b7f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b83:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b87:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b93:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b97:	89 f3                	mov    %esi,%ebx
  801b99:	89 fa                	mov    %edi,%edx
  801b9b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b9f:	89 34 24             	mov    %esi,(%esp)
  801ba2:	85 c0                	test   %eax,%eax
  801ba4:	75 1a                	jne    801bc0 <__umoddi3+0x48>
  801ba6:	39 f7                	cmp    %esi,%edi
  801ba8:	0f 86 a2 00 00 00    	jbe    801c50 <__umoddi3+0xd8>
  801bae:	89 c8                	mov    %ecx,%eax
  801bb0:	89 f2                	mov    %esi,%edx
  801bb2:	f7 f7                	div    %edi
  801bb4:	89 d0                	mov    %edx,%eax
  801bb6:	31 d2                	xor    %edx,%edx
  801bb8:	83 c4 1c             	add    $0x1c,%esp
  801bbb:	5b                   	pop    %ebx
  801bbc:	5e                   	pop    %esi
  801bbd:	5f                   	pop    %edi
  801bbe:	5d                   	pop    %ebp
  801bbf:	c3                   	ret    
  801bc0:	39 f0                	cmp    %esi,%eax
  801bc2:	0f 87 ac 00 00 00    	ja     801c74 <__umoddi3+0xfc>
  801bc8:	0f bd e8             	bsr    %eax,%ebp
  801bcb:	83 f5 1f             	xor    $0x1f,%ebp
  801bce:	0f 84 ac 00 00 00    	je     801c80 <__umoddi3+0x108>
  801bd4:	bf 20 00 00 00       	mov    $0x20,%edi
  801bd9:	29 ef                	sub    %ebp,%edi
  801bdb:	89 fe                	mov    %edi,%esi
  801bdd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801be1:	89 e9                	mov    %ebp,%ecx
  801be3:	d3 e0                	shl    %cl,%eax
  801be5:	89 d7                	mov    %edx,%edi
  801be7:	89 f1                	mov    %esi,%ecx
  801be9:	d3 ef                	shr    %cl,%edi
  801beb:	09 c7                	or     %eax,%edi
  801bed:	89 e9                	mov    %ebp,%ecx
  801bef:	d3 e2                	shl    %cl,%edx
  801bf1:	89 14 24             	mov    %edx,(%esp)
  801bf4:	89 d8                	mov    %ebx,%eax
  801bf6:	d3 e0                	shl    %cl,%eax
  801bf8:	89 c2                	mov    %eax,%edx
  801bfa:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bfe:	d3 e0                	shl    %cl,%eax
  801c00:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c04:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c08:	89 f1                	mov    %esi,%ecx
  801c0a:	d3 e8                	shr    %cl,%eax
  801c0c:	09 d0                	or     %edx,%eax
  801c0e:	d3 eb                	shr    %cl,%ebx
  801c10:	89 da                	mov    %ebx,%edx
  801c12:	f7 f7                	div    %edi
  801c14:	89 d3                	mov    %edx,%ebx
  801c16:	f7 24 24             	mull   (%esp)
  801c19:	89 c6                	mov    %eax,%esi
  801c1b:	89 d1                	mov    %edx,%ecx
  801c1d:	39 d3                	cmp    %edx,%ebx
  801c1f:	0f 82 87 00 00 00    	jb     801cac <__umoddi3+0x134>
  801c25:	0f 84 91 00 00 00    	je     801cbc <__umoddi3+0x144>
  801c2b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c2f:	29 f2                	sub    %esi,%edx
  801c31:	19 cb                	sbb    %ecx,%ebx
  801c33:	89 d8                	mov    %ebx,%eax
  801c35:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c39:	d3 e0                	shl    %cl,%eax
  801c3b:	89 e9                	mov    %ebp,%ecx
  801c3d:	d3 ea                	shr    %cl,%edx
  801c3f:	09 d0                	or     %edx,%eax
  801c41:	89 e9                	mov    %ebp,%ecx
  801c43:	d3 eb                	shr    %cl,%ebx
  801c45:	89 da                	mov    %ebx,%edx
  801c47:	83 c4 1c             	add    $0x1c,%esp
  801c4a:	5b                   	pop    %ebx
  801c4b:	5e                   	pop    %esi
  801c4c:	5f                   	pop    %edi
  801c4d:	5d                   	pop    %ebp
  801c4e:	c3                   	ret    
  801c4f:	90                   	nop
  801c50:	89 fd                	mov    %edi,%ebp
  801c52:	85 ff                	test   %edi,%edi
  801c54:	75 0b                	jne    801c61 <__umoddi3+0xe9>
  801c56:	b8 01 00 00 00       	mov    $0x1,%eax
  801c5b:	31 d2                	xor    %edx,%edx
  801c5d:	f7 f7                	div    %edi
  801c5f:	89 c5                	mov    %eax,%ebp
  801c61:	89 f0                	mov    %esi,%eax
  801c63:	31 d2                	xor    %edx,%edx
  801c65:	f7 f5                	div    %ebp
  801c67:	89 c8                	mov    %ecx,%eax
  801c69:	f7 f5                	div    %ebp
  801c6b:	89 d0                	mov    %edx,%eax
  801c6d:	e9 44 ff ff ff       	jmp    801bb6 <__umoddi3+0x3e>
  801c72:	66 90                	xchg   %ax,%ax
  801c74:	89 c8                	mov    %ecx,%eax
  801c76:	89 f2                	mov    %esi,%edx
  801c78:	83 c4 1c             	add    $0x1c,%esp
  801c7b:	5b                   	pop    %ebx
  801c7c:	5e                   	pop    %esi
  801c7d:	5f                   	pop    %edi
  801c7e:	5d                   	pop    %ebp
  801c7f:	c3                   	ret    
  801c80:	3b 04 24             	cmp    (%esp),%eax
  801c83:	72 06                	jb     801c8b <__umoddi3+0x113>
  801c85:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c89:	77 0f                	ja     801c9a <__umoddi3+0x122>
  801c8b:	89 f2                	mov    %esi,%edx
  801c8d:	29 f9                	sub    %edi,%ecx
  801c8f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c93:	89 14 24             	mov    %edx,(%esp)
  801c96:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c9a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c9e:	8b 14 24             	mov    (%esp),%edx
  801ca1:	83 c4 1c             	add    $0x1c,%esp
  801ca4:	5b                   	pop    %ebx
  801ca5:	5e                   	pop    %esi
  801ca6:	5f                   	pop    %edi
  801ca7:	5d                   	pop    %ebp
  801ca8:	c3                   	ret    
  801ca9:	8d 76 00             	lea    0x0(%esi),%esi
  801cac:	2b 04 24             	sub    (%esp),%eax
  801caf:	19 fa                	sbb    %edi,%edx
  801cb1:	89 d1                	mov    %edx,%ecx
  801cb3:	89 c6                	mov    %eax,%esi
  801cb5:	e9 71 ff ff ff       	jmp    801c2b <__umoddi3+0xb3>
  801cba:	66 90                	xchg   %ax,%ax
  801cbc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801cc0:	72 ea                	jb     801cac <__umoddi3+0x134>
  801cc2:	89 d9                	mov    %ebx,%ecx
  801cc4:	e9 62 ff ff ff       	jmp    801c2b <__umoddi3+0xb3>

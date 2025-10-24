
obj/user/tst_envfree3_slave:     file format elf32-i386


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
  800031:	e8 43 01 00 00       	call   800179 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

extern void destroy(void);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	// Testing scenario 3: using dynamic allocation and free. Kill itself!
	// Testing removing the allocated pages (static & dynamic) in mem, WS, mapped page tables, env's directory and env's page file

	int freeFrames_before = sys_calculate_free_frames() ;
  800044:	e8 c4 13 00 00       	call   80140d <sys_calculate_free_frames>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  80004c:	e8 07 14 00 00       	call   801458 <sys_pf_calculate_allocated_pages>
  800051:	89 45 e0             	mov    %eax,-0x20(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  800054:	83 ec 08             	sub    $0x8,%esp
  800057:	ff 75 e4             	pushl  -0x1c(%ebp)
  80005a:	68 00 1d 80 00       	push   $0x801d00
  80005f:	e8 a5 03 00 00       	call   800409 <cprintf>
  800064:	83 c4 10             	add    $0x10,%esp

	/*[4] CREATE AND RUN ProcessA & ProcessB*/
	//Create 3 processes
	int32 envIdProcessA = sys_create_env("sc_ms_leak_small", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800067:	a1 20 30 80 00       	mov    0x803020,%eax
  80006c:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800072:	89 c2                	mov    %eax,%edx
  800074:	a1 20 30 80 00       	mov    0x803020,%eax
  800079:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80007f:	6a 32                	push   $0x32
  800081:	52                   	push   %edx
  800082:	50                   	push   %eax
  800083:	68 33 1d 80 00       	push   $0x801d33
  800088:	e8 db 14 00 00       	call   801568 <sys_create_env>
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdProcessB = sys_create_env("sc_ms_noleak_small", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800093:	a1 20 30 80 00       	mov    0x803020,%eax
  800098:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  80009e:	89 c2                	mov    %eax,%edx
  8000a0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a5:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000ab:	6a 32                	push   $0x32
  8000ad:	52                   	push   %edx
  8000ae:	50                   	push   %eax
  8000af:	68 44 1d 80 00       	push   $0x801d44
  8000b4:	e8 af 14 00 00       	call   801568 <sys_create_env>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	89 45 d8             	mov    %eax,-0x28(%ebp)

	rsttst();
  8000bf:	e8 f0 15 00 00       	call   8016b4 <rsttst>

	//Run 2 processes
	sys_run_env(envIdProcessA);
  8000c4:	83 ec 0c             	sub    $0xc,%esp
  8000c7:	ff 75 dc             	pushl  -0x24(%ebp)
  8000ca:	e8 b7 14 00 00       	call   801586 <sys_run_env>
  8000cf:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	ff 75 d8             	pushl  -0x28(%ebp)
  8000d8:	e8 a9 14 00 00       	call   801586 <sys_run_env>
  8000dd:	83 c4 10             	add    $0x10,%esp

	//env_sleep(30000);

	//to ensure that the slave environments completed successfully
	while (gettst()!=2) ;// panic("test failed");
  8000e0:	90                   	nop
  8000e1:	e8 48 16 00 00       	call   80172e <gettst>
  8000e6:	83 f8 02             	cmp    $0x2,%eax
  8000e9:	75 f6                	jne    8000e1 <_main+0xa9>

	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000eb:	e8 1d 13 00 00       	call   80140d <sys_calculate_free_frames>
  8000f0:	83 ec 08             	sub    $0x8,%esp
  8000f3:	50                   	push   %eax
  8000f4:	68 58 1d 80 00       	push   $0x801d58
  8000f9:	e8 0b 03 00 00       	call   800409 <cprintf>
  8000fe:	83 c4 10             	add    $0x10,%esp
	//Kill the 3 processes [including itself]
	//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
	//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
	//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
	//	2. changing the # free frames
	char changeIntCmd[100] = "__changeInterruptStatus__";
  800101:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
  800107:	bb 8a 1d 80 00       	mov    $0x801d8a,%ebx
  80010c:	ba 1a 00 00 00       	mov    $0x1a,%edx
  800111:	89 c7                	mov    %eax,%edi
  800113:	89 de                	mov    %ebx,%esi
  800115:	89 d1                	mov    %edx,%ecx
  800117:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800119:	8d 55 8e             	lea    -0x72(%ebp),%edx
  80011c:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  800121:	b0 00                	mov    $0x0,%al
  800123:	89 d7                	mov    %edx,%edi
  800125:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(changeIntCmd, 0);
  800127:	83 ec 08             	sub    $0x8,%esp
  80012a:	6a 00                	push   $0x0
  80012c:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
  800132:	50                   	push   %eax
  800133:	e8 d4 16 00 00       	call   80180c <sys_utilities>
  800138:	83 c4 10             	add    $0x10,%esp
	{
		sys_destroy_env(envIdProcessA);
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	ff 75 dc             	pushl  -0x24(%ebp)
  800141:	e8 5c 14 00 00       	call   8015a2 <sys_destroy_env>
  800146:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  800149:	83 ec 0c             	sub    $0xc,%esp
  80014c:	ff 75 d8             	pushl  -0x28(%ebp)
  80014f:	e8 4e 14 00 00       	call   8015a2 <sys_destroy_env>
  800154:	83 c4 10             	add    $0x10,%esp
		//KILL ITSELF
		destroy();
  800157:	e8 a9 01 00 00       	call   800305 <destroy>
	}
	sys_utilities(changeIntCmd, 1);
  80015c:	83 ec 08             	sub    $0x8,%esp
  80015f:	6a 01                	push   $0x1
  800161:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
  800167:	50                   	push   %eax
  800168:	e8 9f 16 00 00       	call   80180c <sys_utilities>
  80016d:	83 c4 10             	add    $0x10,%esp
}
  800170:	90                   	nop
  800171:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800174:	5b                   	pop    %ebx
  800175:	5e                   	pop    %esi
  800176:	5f                   	pop    %edi
  800177:	5d                   	pop    %ebp
  800178:	c3                   	ret    

00800179 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800179:	55                   	push   %ebp
  80017a:	89 e5                	mov    %esp,%ebp
  80017c:	57                   	push   %edi
  80017d:	56                   	push   %esi
  80017e:	53                   	push   %ebx
  80017f:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800182:	e8 4f 14 00 00       	call   8015d6 <sys_getenvindex>
  800187:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80018a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80018d:	89 d0                	mov    %edx,%eax
  80018f:	c1 e0 02             	shl    $0x2,%eax
  800192:	01 d0                	add    %edx,%eax
  800194:	c1 e0 03             	shl    $0x3,%eax
  800197:	01 d0                	add    %edx,%eax
  800199:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8001a0:	01 d0                	add    %edx,%eax
  8001a2:	c1 e0 02             	shl    $0x2,%eax
  8001a5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001aa:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001af:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b4:	8a 40 20             	mov    0x20(%eax),%al
  8001b7:	84 c0                	test   %al,%al
  8001b9:	74 0d                	je     8001c8 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8001bb:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c0:	83 c0 20             	add    $0x20,%eax
  8001c3:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001cc:	7e 0a                	jle    8001d8 <libmain+0x5f>
		binaryname = argv[0];
  8001ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d1:	8b 00                	mov    (%eax),%eax
  8001d3:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8001d8:	83 ec 08             	sub    $0x8,%esp
  8001db:	ff 75 0c             	pushl  0xc(%ebp)
  8001de:	ff 75 08             	pushl  0x8(%ebp)
  8001e1:	e8 52 fe ff ff       	call   800038 <_main>
  8001e6:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001e9:	a1 00 30 80 00       	mov    0x803000,%eax
  8001ee:	85 c0                	test   %eax,%eax
  8001f0:	0f 84 01 01 00 00    	je     8002f7 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001f6:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001fc:	bb e8 1e 80 00       	mov    $0x801ee8,%ebx
  800201:	ba 0e 00 00 00       	mov    $0xe,%edx
  800206:	89 c7                	mov    %eax,%edi
  800208:	89 de                	mov    %ebx,%esi
  80020a:	89 d1                	mov    %edx,%ecx
  80020c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80020e:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800211:	b9 56 00 00 00       	mov    $0x56,%ecx
  800216:	b0 00                	mov    $0x0,%al
  800218:	89 d7                	mov    %edx,%edi
  80021a:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80021c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800223:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800226:	83 ec 08             	sub    $0x8,%esp
  800229:	50                   	push   %eax
  80022a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800230:	50                   	push   %eax
  800231:	e8 d6 15 00 00       	call   80180c <sys_utilities>
  800236:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800239:	e8 1f 11 00 00       	call   80135d <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	68 08 1e 80 00       	push   $0x801e08
  800246:	e8 be 01 00 00       	call   800409 <cprintf>
  80024b:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80024e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800251:	85 c0                	test   %eax,%eax
  800253:	74 18                	je     80026d <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800255:	e8 d0 15 00 00       	call   80182a <sys_get_optimal_num_faults>
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	50                   	push   %eax
  80025e:	68 30 1e 80 00       	push   $0x801e30
  800263:	e8 a1 01 00 00       	call   800409 <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
  80026b:	eb 59                	jmp    8002c6 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80026d:	a1 20 30 80 00       	mov    0x803020,%eax
  800272:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800278:	a1 20 30 80 00       	mov    0x803020,%eax
  80027d:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800283:	83 ec 04             	sub    $0x4,%esp
  800286:	52                   	push   %edx
  800287:	50                   	push   %eax
  800288:	68 54 1e 80 00       	push   $0x801e54
  80028d:	e8 77 01 00 00       	call   800409 <cprintf>
  800292:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800295:	a1 20 30 80 00       	mov    0x803020,%eax
  80029a:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8002a0:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a5:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8002ab:	a1 20 30 80 00       	mov    0x803020,%eax
  8002b0:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8002b6:	51                   	push   %ecx
  8002b7:	52                   	push   %edx
  8002b8:	50                   	push   %eax
  8002b9:	68 7c 1e 80 00       	push   $0x801e7c
  8002be:	e8 46 01 00 00       	call   800409 <cprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002c6:	a1 20 30 80 00       	mov    0x803020,%eax
  8002cb:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8002d1:	83 ec 08             	sub    $0x8,%esp
  8002d4:	50                   	push   %eax
  8002d5:	68 d4 1e 80 00       	push   $0x801ed4
  8002da:	e8 2a 01 00 00       	call   800409 <cprintf>
  8002df:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002e2:	83 ec 0c             	sub    $0xc,%esp
  8002e5:	68 08 1e 80 00       	push   $0x801e08
  8002ea:	e8 1a 01 00 00       	call   800409 <cprintf>
  8002ef:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002f2:	e8 80 10 00 00       	call   801377 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002f7:	e8 1f 00 00 00       	call   80031b <exit>
}
  8002fc:	90                   	nop
  8002fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800300:	5b                   	pop    %ebx
  800301:	5e                   	pop    %esi
  800302:	5f                   	pop    %edi
  800303:	5d                   	pop    %ebp
  800304:	c3                   	ret    

00800305 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800305:	55                   	push   %ebp
  800306:	89 e5                	mov    %esp,%ebp
  800308:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80030b:	83 ec 0c             	sub    $0xc,%esp
  80030e:	6a 00                	push   $0x0
  800310:	e8 8d 12 00 00       	call   8015a2 <sys_destroy_env>
  800315:	83 c4 10             	add    $0x10,%esp
}
  800318:	90                   	nop
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <exit>:

void
exit(void)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800321:	e8 e2 12 00 00       	call   801608 <sys_exit_env>
}
  800326:	90                   	nop
  800327:	c9                   	leave  
  800328:	c3                   	ret    

00800329 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800329:	55                   	push   %ebp
  80032a:	89 e5                	mov    %esp,%ebp
  80032c:	53                   	push   %ebx
  80032d:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800330:	8b 45 0c             	mov    0xc(%ebp),%eax
  800333:	8b 00                	mov    (%eax),%eax
  800335:	8d 48 01             	lea    0x1(%eax),%ecx
  800338:	8b 55 0c             	mov    0xc(%ebp),%edx
  80033b:	89 0a                	mov    %ecx,(%edx)
  80033d:	8b 55 08             	mov    0x8(%ebp),%edx
  800340:	88 d1                	mov    %dl,%cl
  800342:	8b 55 0c             	mov    0xc(%ebp),%edx
  800345:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800349:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034c:	8b 00                	mov    (%eax),%eax
  80034e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800353:	75 30                	jne    800385 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800355:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  80035b:	a0 44 30 80 00       	mov    0x803044,%al
  800360:	0f b6 c0             	movzbl %al,%eax
  800363:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800366:	8b 09                	mov    (%ecx),%ecx
  800368:	89 cb                	mov    %ecx,%ebx
  80036a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80036d:	83 c1 08             	add    $0x8,%ecx
  800370:	52                   	push   %edx
  800371:	50                   	push   %eax
  800372:	53                   	push   %ebx
  800373:	51                   	push   %ecx
  800374:	e8 a0 0f 00 00       	call   801319 <sys_cputs>
  800379:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80037c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80037f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800385:	8b 45 0c             	mov    0xc(%ebp),%eax
  800388:	8b 40 04             	mov    0x4(%eax),%eax
  80038b:	8d 50 01             	lea    0x1(%eax),%edx
  80038e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800391:	89 50 04             	mov    %edx,0x4(%eax)
}
  800394:	90                   	nop
  800395:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800398:	c9                   	leave  
  800399:	c3                   	ret    

0080039a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80039a:	55                   	push   %ebp
  80039b:	89 e5                	mov    %esp,%ebp
  80039d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003a3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003aa:	00 00 00 
	b.cnt = 0;
  8003ad:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003b4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8003b7:	ff 75 0c             	pushl  0xc(%ebp)
  8003ba:	ff 75 08             	pushl  0x8(%ebp)
  8003bd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003c3:	50                   	push   %eax
  8003c4:	68 29 03 80 00       	push   $0x800329
  8003c9:	e8 5a 02 00 00       	call   800628 <vprintfmt>
  8003ce:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8003d1:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8003d7:	a0 44 30 80 00       	mov    0x803044,%al
  8003dc:	0f b6 c0             	movzbl %al,%eax
  8003df:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8003e5:	52                   	push   %edx
  8003e6:	50                   	push   %eax
  8003e7:	51                   	push   %ecx
  8003e8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003ee:	83 c0 08             	add    $0x8,%eax
  8003f1:	50                   	push   %eax
  8003f2:	e8 22 0f 00 00       	call   801319 <sys_cputs>
  8003f7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8003fa:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800401:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800407:	c9                   	leave  
  800408:	c3                   	ret    

00800409 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
  80040c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80040f:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800416:	8d 45 0c             	lea    0xc(%ebp),%eax
  800419:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80041c:	8b 45 08             	mov    0x8(%ebp),%eax
  80041f:	83 ec 08             	sub    $0x8,%esp
  800422:	ff 75 f4             	pushl  -0xc(%ebp)
  800425:	50                   	push   %eax
  800426:	e8 6f ff ff ff       	call   80039a <vcprintf>
  80042b:	83 c4 10             	add    $0x10,%esp
  80042e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800431:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800434:	c9                   	leave  
  800435:	c3                   	ret    

00800436 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800436:	55                   	push   %ebp
  800437:	89 e5                	mov    %esp,%ebp
  800439:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80043c:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800443:	8b 45 08             	mov    0x8(%ebp),%eax
  800446:	c1 e0 08             	shl    $0x8,%eax
  800449:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  80044e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800451:	83 c0 04             	add    $0x4,%eax
  800454:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045a:	83 ec 08             	sub    $0x8,%esp
  80045d:	ff 75 f4             	pushl  -0xc(%ebp)
  800460:	50                   	push   %eax
  800461:	e8 34 ff ff ff       	call   80039a <vcprintf>
  800466:	83 c4 10             	add    $0x10,%esp
  800469:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80046c:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  800473:	07 00 00 

	return cnt;
  800476:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800479:	c9                   	leave  
  80047a:	c3                   	ret    

0080047b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80047b:	55                   	push   %ebp
  80047c:	89 e5                	mov    %esp,%ebp
  80047e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800481:	e8 d7 0e 00 00       	call   80135d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800486:	8d 45 0c             	lea    0xc(%ebp),%eax
  800489:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80048c:	8b 45 08             	mov    0x8(%ebp),%eax
  80048f:	83 ec 08             	sub    $0x8,%esp
  800492:	ff 75 f4             	pushl  -0xc(%ebp)
  800495:	50                   	push   %eax
  800496:	e8 ff fe ff ff       	call   80039a <vcprintf>
  80049b:	83 c4 10             	add    $0x10,%esp
  80049e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004a1:	e8 d1 0e 00 00       	call   801377 <sys_unlock_cons>
	return cnt;
  8004a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004a9:	c9                   	leave  
  8004aa:	c3                   	ret    

008004ab <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004ab:	55                   	push   %ebp
  8004ac:	89 e5                	mov    %esp,%ebp
  8004ae:	53                   	push   %ebx
  8004af:	83 ec 14             	sub    $0x14,%esp
  8004b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004be:	8b 45 18             	mov    0x18(%ebp),%eax
  8004c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004c9:	77 55                	ja     800520 <printnum+0x75>
  8004cb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004ce:	72 05                	jb     8004d5 <printnum+0x2a>
  8004d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004d3:	77 4b                	ja     800520 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004d5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004d8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004db:	8b 45 18             	mov    0x18(%ebp),%eax
  8004de:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e3:	52                   	push   %edx
  8004e4:	50                   	push   %eax
  8004e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8004eb:	e8 98 15 00 00       	call   801a88 <__udivdi3>
  8004f0:	83 c4 10             	add    $0x10,%esp
  8004f3:	83 ec 04             	sub    $0x4,%esp
  8004f6:	ff 75 20             	pushl  0x20(%ebp)
  8004f9:	53                   	push   %ebx
  8004fa:	ff 75 18             	pushl  0x18(%ebp)
  8004fd:	52                   	push   %edx
  8004fe:	50                   	push   %eax
  8004ff:	ff 75 0c             	pushl  0xc(%ebp)
  800502:	ff 75 08             	pushl  0x8(%ebp)
  800505:	e8 a1 ff ff ff       	call   8004ab <printnum>
  80050a:	83 c4 20             	add    $0x20,%esp
  80050d:	eb 1a                	jmp    800529 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80050f:	83 ec 08             	sub    $0x8,%esp
  800512:	ff 75 0c             	pushl  0xc(%ebp)
  800515:	ff 75 20             	pushl  0x20(%ebp)
  800518:	8b 45 08             	mov    0x8(%ebp),%eax
  80051b:	ff d0                	call   *%eax
  80051d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800520:	ff 4d 1c             	decl   0x1c(%ebp)
  800523:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800527:	7f e6                	jg     80050f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800529:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80052c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800531:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800534:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800537:	53                   	push   %ebx
  800538:	51                   	push   %ecx
  800539:	52                   	push   %edx
  80053a:	50                   	push   %eax
  80053b:	e8 58 16 00 00       	call   801b98 <__umoddi3>
  800540:	83 c4 10             	add    $0x10,%esp
  800543:	05 74 21 80 00       	add    $0x802174,%eax
  800548:	8a 00                	mov    (%eax),%al
  80054a:	0f be c0             	movsbl %al,%eax
  80054d:	83 ec 08             	sub    $0x8,%esp
  800550:	ff 75 0c             	pushl  0xc(%ebp)
  800553:	50                   	push   %eax
  800554:	8b 45 08             	mov    0x8(%ebp),%eax
  800557:	ff d0                	call   *%eax
  800559:	83 c4 10             	add    $0x10,%esp
}
  80055c:	90                   	nop
  80055d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800560:	c9                   	leave  
  800561:	c3                   	ret    

00800562 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800562:	55                   	push   %ebp
  800563:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800565:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800569:	7e 1c                	jle    800587 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80056b:	8b 45 08             	mov    0x8(%ebp),%eax
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	8d 50 08             	lea    0x8(%eax),%edx
  800573:	8b 45 08             	mov    0x8(%ebp),%eax
  800576:	89 10                	mov    %edx,(%eax)
  800578:	8b 45 08             	mov    0x8(%ebp),%eax
  80057b:	8b 00                	mov    (%eax),%eax
  80057d:	83 e8 08             	sub    $0x8,%eax
  800580:	8b 50 04             	mov    0x4(%eax),%edx
  800583:	8b 00                	mov    (%eax),%eax
  800585:	eb 40                	jmp    8005c7 <getuint+0x65>
	else if (lflag)
  800587:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80058b:	74 1e                	je     8005ab <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80058d:	8b 45 08             	mov    0x8(%ebp),%eax
  800590:	8b 00                	mov    (%eax),%eax
  800592:	8d 50 04             	lea    0x4(%eax),%edx
  800595:	8b 45 08             	mov    0x8(%ebp),%eax
  800598:	89 10                	mov    %edx,(%eax)
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	8b 00                	mov    (%eax),%eax
  80059f:	83 e8 04             	sub    $0x4,%eax
  8005a2:	8b 00                	mov    (%eax),%eax
  8005a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a9:	eb 1c                	jmp    8005c7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ae:	8b 00                	mov    (%eax),%eax
  8005b0:	8d 50 04             	lea    0x4(%eax),%edx
  8005b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b6:	89 10                	mov    %edx,(%eax)
  8005b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bb:	8b 00                	mov    (%eax),%eax
  8005bd:	83 e8 04             	sub    $0x4,%eax
  8005c0:	8b 00                	mov    (%eax),%eax
  8005c2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005c7:	5d                   	pop    %ebp
  8005c8:	c3                   	ret    

008005c9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005c9:	55                   	push   %ebp
  8005ca:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005cc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005d0:	7e 1c                	jle    8005ee <getint+0x25>
		return va_arg(*ap, long long);
  8005d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	8d 50 08             	lea    0x8(%eax),%edx
  8005da:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dd:	89 10                	mov    %edx,(%eax)
  8005df:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	83 e8 08             	sub    $0x8,%eax
  8005e7:	8b 50 04             	mov    0x4(%eax),%edx
  8005ea:	8b 00                	mov    (%eax),%eax
  8005ec:	eb 38                	jmp    800626 <getint+0x5d>
	else if (lflag)
  8005ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005f2:	74 1a                	je     80060e <getint+0x45>
		return va_arg(*ap, long);
  8005f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	8d 50 04             	lea    0x4(%eax),%edx
  8005fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ff:	89 10                	mov    %edx,(%eax)
  800601:	8b 45 08             	mov    0x8(%ebp),%eax
  800604:	8b 00                	mov    (%eax),%eax
  800606:	83 e8 04             	sub    $0x4,%eax
  800609:	8b 00                	mov    (%eax),%eax
  80060b:	99                   	cltd   
  80060c:	eb 18                	jmp    800626 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	8b 00                	mov    (%eax),%eax
  800613:	8d 50 04             	lea    0x4(%eax),%edx
  800616:	8b 45 08             	mov    0x8(%ebp),%eax
  800619:	89 10                	mov    %edx,(%eax)
  80061b:	8b 45 08             	mov    0x8(%ebp),%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	83 e8 04             	sub    $0x4,%eax
  800623:	8b 00                	mov    (%eax),%eax
  800625:	99                   	cltd   
}
  800626:	5d                   	pop    %ebp
  800627:	c3                   	ret    

00800628 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800628:	55                   	push   %ebp
  800629:	89 e5                	mov    %esp,%ebp
  80062b:	56                   	push   %esi
  80062c:	53                   	push   %ebx
  80062d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800630:	eb 17                	jmp    800649 <vprintfmt+0x21>
			if (ch == '\0')
  800632:	85 db                	test   %ebx,%ebx
  800634:	0f 84 c1 03 00 00    	je     8009fb <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80063a:	83 ec 08             	sub    $0x8,%esp
  80063d:	ff 75 0c             	pushl  0xc(%ebp)
  800640:	53                   	push   %ebx
  800641:	8b 45 08             	mov    0x8(%ebp),%eax
  800644:	ff d0                	call   *%eax
  800646:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800649:	8b 45 10             	mov    0x10(%ebp),%eax
  80064c:	8d 50 01             	lea    0x1(%eax),%edx
  80064f:	89 55 10             	mov    %edx,0x10(%ebp)
  800652:	8a 00                	mov    (%eax),%al
  800654:	0f b6 d8             	movzbl %al,%ebx
  800657:	83 fb 25             	cmp    $0x25,%ebx
  80065a:	75 d6                	jne    800632 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80065c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800660:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800667:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80066e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800675:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80067c:	8b 45 10             	mov    0x10(%ebp),%eax
  80067f:	8d 50 01             	lea    0x1(%eax),%edx
  800682:	89 55 10             	mov    %edx,0x10(%ebp)
  800685:	8a 00                	mov    (%eax),%al
  800687:	0f b6 d8             	movzbl %al,%ebx
  80068a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80068d:	83 f8 5b             	cmp    $0x5b,%eax
  800690:	0f 87 3d 03 00 00    	ja     8009d3 <vprintfmt+0x3ab>
  800696:	8b 04 85 98 21 80 00 	mov    0x802198(,%eax,4),%eax
  80069d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80069f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006a3:	eb d7                	jmp    80067c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006a5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006a9:	eb d1                	jmp    80067c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006ab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006b5:	89 d0                	mov    %edx,%eax
  8006b7:	c1 e0 02             	shl    $0x2,%eax
  8006ba:	01 d0                	add    %edx,%eax
  8006bc:	01 c0                	add    %eax,%eax
  8006be:	01 d8                	add    %ebx,%eax
  8006c0:	83 e8 30             	sub    $0x30,%eax
  8006c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8006c9:	8a 00                	mov    (%eax),%al
  8006cb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006ce:	83 fb 2f             	cmp    $0x2f,%ebx
  8006d1:	7e 3e                	jle    800711 <vprintfmt+0xe9>
  8006d3:	83 fb 39             	cmp    $0x39,%ebx
  8006d6:	7f 39                	jg     800711 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006d8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006db:	eb d5                	jmp    8006b2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	83 c0 04             	add    $0x4,%eax
  8006e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e9:	83 e8 04             	sub    $0x4,%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006f1:	eb 1f                	jmp    800712 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006f7:	79 83                	jns    80067c <vprintfmt+0x54>
				width = 0;
  8006f9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800700:	e9 77 ff ff ff       	jmp    80067c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800705:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80070c:	e9 6b ff ff ff       	jmp    80067c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800711:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800712:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800716:	0f 89 60 ff ff ff    	jns    80067c <vprintfmt+0x54>
				width = precision, precision = -1;
  80071c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80071f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800722:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800729:	e9 4e ff ff ff       	jmp    80067c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80072e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800731:	e9 46 ff ff ff       	jmp    80067c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800736:	8b 45 14             	mov    0x14(%ebp),%eax
  800739:	83 c0 04             	add    $0x4,%eax
  80073c:	89 45 14             	mov    %eax,0x14(%ebp)
  80073f:	8b 45 14             	mov    0x14(%ebp),%eax
  800742:	83 e8 04             	sub    $0x4,%eax
  800745:	8b 00                	mov    (%eax),%eax
  800747:	83 ec 08             	sub    $0x8,%esp
  80074a:	ff 75 0c             	pushl  0xc(%ebp)
  80074d:	50                   	push   %eax
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	ff d0                	call   *%eax
  800753:	83 c4 10             	add    $0x10,%esp
			break;
  800756:	e9 9b 02 00 00       	jmp    8009f6 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80075b:	8b 45 14             	mov    0x14(%ebp),%eax
  80075e:	83 c0 04             	add    $0x4,%eax
  800761:	89 45 14             	mov    %eax,0x14(%ebp)
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	83 e8 04             	sub    $0x4,%eax
  80076a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80076c:	85 db                	test   %ebx,%ebx
  80076e:	79 02                	jns    800772 <vprintfmt+0x14a>
				err = -err;
  800770:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800772:	83 fb 64             	cmp    $0x64,%ebx
  800775:	7f 0b                	jg     800782 <vprintfmt+0x15a>
  800777:	8b 34 9d e0 1f 80 00 	mov    0x801fe0(,%ebx,4),%esi
  80077e:	85 f6                	test   %esi,%esi
  800780:	75 19                	jne    80079b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800782:	53                   	push   %ebx
  800783:	68 85 21 80 00       	push   $0x802185
  800788:	ff 75 0c             	pushl  0xc(%ebp)
  80078b:	ff 75 08             	pushl  0x8(%ebp)
  80078e:	e8 70 02 00 00       	call   800a03 <printfmt>
  800793:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800796:	e9 5b 02 00 00       	jmp    8009f6 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80079b:	56                   	push   %esi
  80079c:	68 8e 21 80 00       	push   $0x80218e
  8007a1:	ff 75 0c             	pushl  0xc(%ebp)
  8007a4:	ff 75 08             	pushl  0x8(%ebp)
  8007a7:	e8 57 02 00 00       	call   800a03 <printfmt>
  8007ac:	83 c4 10             	add    $0x10,%esp
			break;
  8007af:	e9 42 02 00 00       	jmp    8009f6 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	83 c0 04             	add    $0x4,%eax
  8007ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	83 e8 04             	sub    $0x4,%eax
  8007c3:	8b 30                	mov    (%eax),%esi
  8007c5:	85 f6                	test   %esi,%esi
  8007c7:	75 05                	jne    8007ce <vprintfmt+0x1a6>
				p = "(null)";
  8007c9:	be 91 21 80 00       	mov    $0x802191,%esi
			if (width > 0 && padc != '-')
  8007ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d2:	7e 6d                	jle    800841 <vprintfmt+0x219>
  8007d4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007d8:	74 67                	je     800841 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007dd:	83 ec 08             	sub    $0x8,%esp
  8007e0:	50                   	push   %eax
  8007e1:	56                   	push   %esi
  8007e2:	e8 1e 03 00 00       	call   800b05 <strnlen>
  8007e7:	83 c4 10             	add    $0x10,%esp
  8007ea:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007ed:	eb 16                	jmp    800805 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007ef:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007f3:	83 ec 08             	sub    $0x8,%esp
  8007f6:	ff 75 0c             	pushl  0xc(%ebp)
  8007f9:	50                   	push   %eax
  8007fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fd:	ff d0                	call   *%eax
  8007ff:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800802:	ff 4d e4             	decl   -0x1c(%ebp)
  800805:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800809:	7f e4                	jg     8007ef <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80080b:	eb 34                	jmp    800841 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80080d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800811:	74 1c                	je     80082f <vprintfmt+0x207>
  800813:	83 fb 1f             	cmp    $0x1f,%ebx
  800816:	7e 05                	jle    80081d <vprintfmt+0x1f5>
  800818:	83 fb 7e             	cmp    $0x7e,%ebx
  80081b:	7e 12                	jle    80082f <vprintfmt+0x207>
					putch('?', putdat);
  80081d:	83 ec 08             	sub    $0x8,%esp
  800820:	ff 75 0c             	pushl  0xc(%ebp)
  800823:	6a 3f                	push   $0x3f
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
  80082d:	eb 0f                	jmp    80083e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80082f:	83 ec 08             	sub    $0x8,%esp
  800832:	ff 75 0c             	pushl  0xc(%ebp)
  800835:	53                   	push   %ebx
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	ff d0                	call   *%eax
  80083b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80083e:	ff 4d e4             	decl   -0x1c(%ebp)
  800841:	89 f0                	mov    %esi,%eax
  800843:	8d 70 01             	lea    0x1(%eax),%esi
  800846:	8a 00                	mov    (%eax),%al
  800848:	0f be d8             	movsbl %al,%ebx
  80084b:	85 db                	test   %ebx,%ebx
  80084d:	74 24                	je     800873 <vprintfmt+0x24b>
  80084f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800853:	78 b8                	js     80080d <vprintfmt+0x1e5>
  800855:	ff 4d e0             	decl   -0x20(%ebp)
  800858:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80085c:	79 af                	jns    80080d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80085e:	eb 13                	jmp    800873 <vprintfmt+0x24b>
				putch(' ', putdat);
  800860:	83 ec 08             	sub    $0x8,%esp
  800863:	ff 75 0c             	pushl  0xc(%ebp)
  800866:	6a 20                	push   $0x20
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	ff d0                	call   *%eax
  80086d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800870:	ff 4d e4             	decl   -0x1c(%ebp)
  800873:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800877:	7f e7                	jg     800860 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800879:	e9 78 01 00 00       	jmp    8009f6 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80087e:	83 ec 08             	sub    $0x8,%esp
  800881:	ff 75 e8             	pushl  -0x18(%ebp)
  800884:	8d 45 14             	lea    0x14(%ebp),%eax
  800887:	50                   	push   %eax
  800888:	e8 3c fd ff ff       	call   8005c9 <getint>
  80088d:	83 c4 10             	add    $0x10,%esp
  800890:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800893:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800899:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80089c:	85 d2                	test   %edx,%edx
  80089e:	79 23                	jns    8008c3 <vprintfmt+0x29b>
				putch('-', putdat);
  8008a0:	83 ec 08             	sub    $0x8,%esp
  8008a3:	ff 75 0c             	pushl  0xc(%ebp)
  8008a6:	6a 2d                	push   $0x2d
  8008a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ab:	ff d0                	call   *%eax
  8008ad:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b6:	f7 d8                	neg    %eax
  8008b8:	83 d2 00             	adc    $0x0,%edx
  8008bb:	f7 da                	neg    %edx
  8008bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008c3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008ca:	e9 bc 00 00 00       	jmp    80098b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008cf:	83 ec 08             	sub    $0x8,%esp
  8008d2:	ff 75 e8             	pushl  -0x18(%ebp)
  8008d5:	8d 45 14             	lea    0x14(%ebp),%eax
  8008d8:	50                   	push   %eax
  8008d9:	e8 84 fc ff ff       	call   800562 <getuint>
  8008de:	83 c4 10             	add    $0x10,%esp
  8008e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008e7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008ee:	e9 98 00 00 00       	jmp    80098b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008f3:	83 ec 08             	sub    $0x8,%esp
  8008f6:	ff 75 0c             	pushl  0xc(%ebp)
  8008f9:	6a 58                	push   $0x58
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	ff d0                	call   *%eax
  800900:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800903:	83 ec 08             	sub    $0x8,%esp
  800906:	ff 75 0c             	pushl  0xc(%ebp)
  800909:	6a 58                	push   $0x58
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	ff d0                	call   *%eax
  800910:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800913:	83 ec 08             	sub    $0x8,%esp
  800916:	ff 75 0c             	pushl  0xc(%ebp)
  800919:	6a 58                	push   $0x58
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	ff d0                	call   *%eax
  800920:	83 c4 10             	add    $0x10,%esp
			break;
  800923:	e9 ce 00 00 00       	jmp    8009f6 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800928:	83 ec 08             	sub    $0x8,%esp
  80092b:	ff 75 0c             	pushl  0xc(%ebp)
  80092e:	6a 30                	push   $0x30
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	ff d0                	call   *%eax
  800935:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800938:	83 ec 08             	sub    $0x8,%esp
  80093b:	ff 75 0c             	pushl  0xc(%ebp)
  80093e:	6a 78                	push   $0x78
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	ff d0                	call   *%eax
  800945:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	83 c0 04             	add    $0x4,%eax
  80094e:	89 45 14             	mov    %eax,0x14(%ebp)
  800951:	8b 45 14             	mov    0x14(%ebp),%eax
  800954:	83 e8 04             	sub    $0x4,%eax
  800957:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800959:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80095c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800963:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80096a:	eb 1f                	jmp    80098b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80096c:	83 ec 08             	sub    $0x8,%esp
  80096f:	ff 75 e8             	pushl  -0x18(%ebp)
  800972:	8d 45 14             	lea    0x14(%ebp),%eax
  800975:	50                   	push   %eax
  800976:	e8 e7 fb ff ff       	call   800562 <getuint>
  80097b:	83 c4 10             	add    $0x10,%esp
  80097e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800981:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800984:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80098b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80098f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800992:	83 ec 04             	sub    $0x4,%esp
  800995:	52                   	push   %edx
  800996:	ff 75 e4             	pushl  -0x1c(%ebp)
  800999:	50                   	push   %eax
  80099a:	ff 75 f4             	pushl  -0xc(%ebp)
  80099d:	ff 75 f0             	pushl  -0x10(%ebp)
  8009a0:	ff 75 0c             	pushl  0xc(%ebp)
  8009a3:	ff 75 08             	pushl  0x8(%ebp)
  8009a6:	e8 00 fb ff ff       	call   8004ab <printnum>
  8009ab:	83 c4 20             	add    $0x20,%esp
			break;
  8009ae:	eb 46                	jmp    8009f6 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009b0:	83 ec 08             	sub    $0x8,%esp
  8009b3:	ff 75 0c             	pushl  0xc(%ebp)
  8009b6:	53                   	push   %ebx
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	ff d0                	call   *%eax
  8009bc:	83 c4 10             	add    $0x10,%esp
			break;
  8009bf:	eb 35                	jmp    8009f6 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009c1:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  8009c8:	eb 2c                	jmp    8009f6 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009ca:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  8009d1:	eb 23                	jmp    8009f6 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	ff 75 0c             	pushl  0xc(%ebp)
  8009d9:	6a 25                	push   $0x25
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	ff d0                	call   *%eax
  8009e0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009e3:	ff 4d 10             	decl   0x10(%ebp)
  8009e6:	eb 03                	jmp    8009eb <vprintfmt+0x3c3>
  8009e8:	ff 4d 10             	decl   0x10(%ebp)
  8009eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ee:	48                   	dec    %eax
  8009ef:	8a 00                	mov    (%eax),%al
  8009f1:	3c 25                	cmp    $0x25,%al
  8009f3:	75 f3                	jne    8009e8 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8009f5:	90                   	nop
		}
	}
  8009f6:	e9 35 fc ff ff       	jmp    800630 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009fb:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009ff:	5b                   	pop    %ebx
  800a00:	5e                   	pop    %esi
  800a01:	5d                   	pop    %ebp
  800a02:	c3                   	ret    

00800a03 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a09:	8d 45 10             	lea    0x10(%ebp),%eax
  800a0c:	83 c0 04             	add    $0x4,%eax
  800a0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a12:	8b 45 10             	mov    0x10(%ebp),%eax
  800a15:	ff 75 f4             	pushl  -0xc(%ebp)
  800a18:	50                   	push   %eax
  800a19:	ff 75 0c             	pushl  0xc(%ebp)
  800a1c:	ff 75 08             	pushl  0x8(%ebp)
  800a1f:	e8 04 fc ff ff       	call   800628 <vprintfmt>
  800a24:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a27:	90                   	nop
  800a28:	c9                   	leave  
  800a29:	c3                   	ret    

00800a2a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a30:	8b 40 08             	mov    0x8(%eax),%eax
  800a33:	8d 50 01             	lea    0x1(%eax),%edx
  800a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a39:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3f:	8b 10                	mov    (%eax),%edx
  800a41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a44:	8b 40 04             	mov    0x4(%eax),%eax
  800a47:	39 c2                	cmp    %eax,%edx
  800a49:	73 12                	jae    800a5d <sprintputch+0x33>
		*b->buf++ = ch;
  800a4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4e:	8b 00                	mov    (%eax),%eax
  800a50:	8d 48 01             	lea    0x1(%eax),%ecx
  800a53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a56:	89 0a                	mov    %ecx,(%edx)
  800a58:	8b 55 08             	mov    0x8(%ebp),%edx
  800a5b:	88 10                	mov    %dl,(%eax)
}
  800a5d:	90                   	nop
  800a5e:	5d                   	pop    %ebp
  800a5f:	c3                   	ret    

00800a60 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a66:	8b 45 08             	mov    0x8(%ebp),%eax
  800a69:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	01 d0                	add    %edx,%eax
  800a77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a85:	74 06                	je     800a8d <vsnprintf+0x2d>
  800a87:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a8b:	7f 07                	jg     800a94 <vsnprintf+0x34>
		return -E_INVAL;
  800a8d:	b8 03 00 00 00       	mov    $0x3,%eax
  800a92:	eb 20                	jmp    800ab4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a94:	ff 75 14             	pushl  0x14(%ebp)
  800a97:	ff 75 10             	pushl  0x10(%ebp)
  800a9a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a9d:	50                   	push   %eax
  800a9e:	68 2a 0a 80 00       	push   $0x800a2a
  800aa3:	e8 80 fb ff ff       	call   800628 <vprintfmt>
  800aa8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aae:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ab4:	c9                   	leave  
  800ab5:	c3                   	ret    

00800ab6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ab6:	55                   	push   %ebp
  800ab7:	89 e5                	mov    %esp,%ebp
  800ab9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800abc:	8d 45 10             	lea    0x10(%ebp),%eax
  800abf:	83 c0 04             	add    $0x4,%eax
  800ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ac5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac8:	ff 75 f4             	pushl  -0xc(%ebp)
  800acb:	50                   	push   %eax
  800acc:	ff 75 0c             	pushl  0xc(%ebp)
  800acf:	ff 75 08             	pushl  0x8(%ebp)
  800ad2:	e8 89 ff ff ff       	call   800a60 <vsnprintf>
  800ad7:	83 c4 10             	add    $0x10,%esp
  800ada:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800add:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ae0:	c9                   	leave  
  800ae1:	c3                   	ret    

00800ae2 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
  800ae5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ae8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800aef:	eb 06                	jmp    800af7 <strlen+0x15>
		n++;
  800af1:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800af4:	ff 45 08             	incl   0x8(%ebp)
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	8a 00                	mov    (%eax),%al
  800afc:	84 c0                	test   %al,%al
  800afe:	75 f1                	jne    800af1 <strlen+0xf>
		n++;
	return n;
  800b00:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b03:	c9                   	leave  
  800b04:	c3                   	ret    

00800b05 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b12:	eb 09                	jmp    800b1d <strnlen+0x18>
		n++;
  800b14:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b17:	ff 45 08             	incl   0x8(%ebp)
  800b1a:	ff 4d 0c             	decl   0xc(%ebp)
  800b1d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b21:	74 09                	je     800b2c <strnlen+0x27>
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	8a 00                	mov    (%eax),%al
  800b28:	84 c0                	test   %al,%al
  800b2a:	75 e8                	jne    800b14 <strnlen+0xf>
		n++;
	return n;
  800b2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b2f:	c9                   	leave  
  800b30:	c3                   	ret    

00800b31 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
  800b34:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b3d:	90                   	nop
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	8d 50 01             	lea    0x1(%eax),%edx
  800b44:	89 55 08             	mov    %edx,0x8(%ebp)
  800b47:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b4d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b50:	8a 12                	mov    (%edx),%dl
  800b52:	88 10                	mov    %dl,(%eax)
  800b54:	8a 00                	mov    (%eax),%al
  800b56:	84 c0                	test   %al,%al
  800b58:	75 e4                	jne    800b3e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b5d:	c9                   	leave  
  800b5e:	c3                   	ret    

00800b5f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b6b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b72:	eb 1f                	jmp    800b93 <strncpy+0x34>
		*dst++ = *src;
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	8d 50 01             	lea    0x1(%eax),%edx
  800b7a:	89 55 08             	mov    %edx,0x8(%ebp)
  800b7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b80:	8a 12                	mov    (%edx),%dl
  800b82:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b87:	8a 00                	mov    (%eax),%al
  800b89:	84 c0                	test   %al,%al
  800b8b:	74 03                	je     800b90 <strncpy+0x31>
			src++;
  800b8d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b90:	ff 45 fc             	incl   -0x4(%ebp)
  800b93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b96:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b99:	72 d9                	jb     800b74 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b9e:	c9                   	leave  
  800b9f:	c3                   	ret    

00800ba0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bb0:	74 30                	je     800be2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bb2:	eb 16                	jmp    800bca <strlcpy+0x2a>
			*dst++ = *src++;
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	8d 50 01             	lea    0x1(%eax),%edx
  800bba:	89 55 08             	mov    %edx,0x8(%ebp)
  800bbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bc3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bc6:	8a 12                	mov    (%edx),%dl
  800bc8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bca:	ff 4d 10             	decl   0x10(%ebp)
  800bcd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bd1:	74 09                	je     800bdc <strlcpy+0x3c>
  800bd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd6:	8a 00                	mov    (%eax),%al
  800bd8:	84 c0                	test   %al,%al
  800bda:	75 d8                	jne    800bb4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdf:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800be2:	8b 55 08             	mov    0x8(%ebp),%edx
  800be5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be8:	29 c2                	sub    %eax,%edx
  800bea:	89 d0                	mov    %edx,%eax
}
  800bec:	c9                   	leave  
  800bed:	c3                   	ret    

00800bee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bf1:	eb 06                	jmp    800bf9 <strcmp+0xb>
		p++, q++;
  800bf3:	ff 45 08             	incl   0x8(%ebp)
  800bf6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8a 00                	mov    (%eax),%al
  800bfe:	84 c0                	test   %al,%al
  800c00:	74 0e                	je     800c10 <strcmp+0x22>
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	8a 10                	mov    (%eax),%dl
  800c07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0a:	8a 00                	mov    (%eax),%al
  800c0c:	38 c2                	cmp    %al,%dl
  800c0e:	74 e3                	je     800bf3 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c10:	8b 45 08             	mov    0x8(%ebp),%eax
  800c13:	8a 00                	mov    (%eax),%al
  800c15:	0f b6 d0             	movzbl %al,%edx
  800c18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1b:	8a 00                	mov    (%eax),%al
  800c1d:	0f b6 c0             	movzbl %al,%eax
  800c20:	29 c2                	sub    %eax,%edx
  800c22:	89 d0                	mov    %edx,%eax
}
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    

00800c26 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c29:	eb 09                	jmp    800c34 <strncmp+0xe>
		n--, p++, q++;
  800c2b:	ff 4d 10             	decl   0x10(%ebp)
  800c2e:	ff 45 08             	incl   0x8(%ebp)
  800c31:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c38:	74 17                	je     800c51 <strncmp+0x2b>
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	8a 00                	mov    (%eax),%al
  800c3f:	84 c0                	test   %al,%al
  800c41:	74 0e                	je     800c51 <strncmp+0x2b>
  800c43:	8b 45 08             	mov    0x8(%ebp),%eax
  800c46:	8a 10                	mov    (%eax),%dl
  800c48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	38 c2                	cmp    %al,%dl
  800c4f:	74 da                	je     800c2b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c55:	75 07                	jne    800c5e <strncmp+0x38>
		return 0;
  800c57:	b8 00 00 00 00       	mov    $0x0,%eax
  800c5c:	eb 14                	jmp    800c72 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	8a 00                	mov    (%eax),%al
  800c63:	0f b6 d0             	movzbl %al,%edx
  800c66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c69:	8a 00                	mov    (%eax),%al
  800c6b:	0f b6 c0             	movzbl %al,%eax
  800c6e:	29 c2                	sub    %eax,%edx
  800c70:	89 d0                	mov    %edx,%eax
}
  800c72:	5d                   	pop    %ebp
  800c73:	c3                   	ret    

00800c74 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	83 ec 04             	sub    $0x4,%esp
  800c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c80:	eb 12                	jmp    800c94 <strchr+0x20>
		if (*s == c)
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	8a 00                	mov    (%eax),%al
  800c87:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c8a:	75 05                	jne    800c91 <strchr+0x1d>
			return (char *) s;
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	eb 11                	jmp    800ca2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c91:	ff 45 08             	incl   0x8(%ebp)
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	8a 00                	mov    (%eax),%al
  800c99:	84 c0                	test   %al,%al
  800c9b:	75 e5                	jne    800c82 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    

00800ca4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	83 ec 04             	sub    $0x4,%esp
  800caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cad:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cb0:	eb 0d                	jmp    800cbf <strfind+0x1b>
		if (*s == c)
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	8a 00                	mov    (%eax),%al
  800cb7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cba:	74 0e                	je     800cca <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cbc:	ff 45 08             	incl   0x8(%ebp)
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	8a 00                	mov    (%eax),%al
  800cc4:	84 c0                	test   %al,%al
  800cc6:	75 ea                	jne    800cb2 <strfind+0xe>
  800cc8:	eb 01                	jmp    800ccb <strfind+0x27>
		if (*s == c)
			break;
  800cca:	90                   	nop
	return (char *) s;
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cce:	c9                   	leave  
  800ccf:	c3                   	ret    

00800cd0 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800cdc:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ce0:	76 63                	jbe    800d45 <memset+0x75>
		uint64 data_block = c;
  800ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce5:	99                   	cltd   
  800ce6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce9:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cf2:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800cf6:	c1 e0 08             	shl    $0x8,%eax
  800cf9:	09 45 f0             	or     %eax,-0x10(%ebp)
  800cfc:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d05:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800d09:	c1 e0 10             	shl    $0x10,%eax
  800d0c:	09 45 f0             	or     %eax,-0x10(%ebp)
  800d0f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d18:	89 c2                	mov    %eax,%edx
  800d1a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1f:	09 45 f0             	or     %eax,-0x10(%ebp)
  800d22:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800d25:	eb 18                	jmp    800d3f <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800d27:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800d2a:	8d 41 08             	lea    0x8(%ecx),%eax
  800d2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d36:	89 01                	mov    %eax,(%ecx)
  800d38:	89 51 04             	mov    %edx,0x4(%ecx)
  800d3b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800d3f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d43:	77 e2                	ja     800d27 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800d45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d49:	74 23                	je     800d6e <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800d4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d51:	eb 0e                	jmp    800d61 <memset+0x91>
			*p8++ = (uint8)c;
  800d53:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d56:	8d 50 01             	lea    0x1(%eax),%edx
  800d59:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d5f:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800d61:	8b 45 10             	mov    0x10(%ebp),%eax
  800d64:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d67:	89 55 10             	mov    %edx,0x10(%ebp)
  800d6a:	85 c0                	test   %eax,%eax
  800d6c:	75 e5                	jne    800d53 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d71:	c9                   	leave  
  800d72:	c3                   	ret    

00800d73 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800d79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800d85:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d89:	76 24                	jbe    800daf <memcpy+0x3c>
		while(n >= 8){
  800d8b:	eb 1c                	jmp    800da9 <memcpy+0x36>
			*d64 = *s64;
  800d8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d90:	8b 50 04             	mov    0x4(%eax),%edx
  800d93:	8b 00                	mov    (%eax),%eax
  800d95:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800d98:	89 01                	mov    %eax,(%ecx)
  800d9a:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800d9d:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800da1:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800da5:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800da9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800dad:	77 de                	ja     800d8d <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800daf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db3:	74 31                	je     800de6 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800db5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800dbb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800dc1:	eb 16                	jmp    800dd9 <memcpy+0x66>
			*d8++ = *s8++;
  800dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dc6:	8d 50 01             	lea    0x1(%eax),%edx
  800dc9:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800dcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dcf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dd2:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800dd5:	8a 12                	mov    (%edx),%dl
  800dd7:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800dd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ddc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ddf:	89 55 10             	mov    %edx,0x10(%ebp)
  800de2:	85 c0                	test   %eax,%eax
  800de4:	75 dd                	jne    800dc3 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de9:	c9                   	leave  
  800dea:	c3                   	ret    

00800deb <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e00:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e03:	73 50                	jae    800e55 <memmove+0x6a>
  800e05:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e08:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0b:	01 d0                	add    %edx,%eax
  800e0d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e10:	76 43                	jbe    800e55 <memmove+0x6a>
		s += n;
  800e12:	8b 45 10             	mov    0x10(%ebp),%eax
  800e15:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e18:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e1e:	eb 10                	jmp    800e30 <memmove+0x45>
			*--d = *--s;
  800e20:	ff 4d f8             	decl   -0x8(%ebp)
  800e23:	ff 4d fc             	decl   -0x4(%ebp)
  800e26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e29:	8a 10                	mov    (%eax),%dl
  800e2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e2e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e30:	8b 45 10             	mov    0x10(%ebp),%eax
  800e33:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e36:	89 55 10             	mov    %edx,0x10(%ebp)
  800e39:	85 c0                	test   %eax,%eax
  800e3b:	75 e3                	jne    800e20 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e3d:	eb 23                	jmp    800e62 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e42:	8d 50 01             	lea    0x1(%eax),%edx
  800e45:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e48:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e4b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e4e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e51:	8a 12                	mov    (%edx),%dl
  800e53:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e55:	8b 45 10             	mov    0x10(%ebp),%eax
  800e58:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5e:	85 c0                	test   %eax,%eax
  800e60:	75 dd                	jne    800e3f <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e65:	c9                   	leave  
  800e66:	c3                   	ret    

00800e67 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e76:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e79:	eb 2a                	jmp    800ea5 <memcmp+0x3e>
		if (*s1 != *s2)
  800e7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7e:	8a 10                	mov    (%eax),%dl
  800e80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e83:	8a 00                	mov    (%eax),%al
  800e85:	38 c2                	cmp    %al,%dl
  800e87:	74 16                	je     800e9f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	0f b6 d0             	movzbl %al,%edx
  800e91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	0f b6 c0             	movzbl %al,%eax
  800e99:	29 c2                	sub    %eax,%edx
  800e9b:	89 d0                	mov    %edx,%eax
  800e9d:	eb 18                	jmp    800eb7 <memcmp+0x50>
		s1++, s2++;
  800e9f:	ff 45 fc             	incl   -0x4(%ebp)
  800ea2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ea5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eab:	89 55 10             	mov    %edx,0x10(%ebp)
  800eae:	85 c0                	test   %eax,%eax
  800eb0:	75 c9                	jne    800e7b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800eb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eb7:	c9                   	leave  
  800eb8:	c3                   	ret    

00800eb9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec5:	01 d0                	add    %edx,%eax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eca:	eb 15                	jmp    800ee1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	8a 00                	mov    (%eax),%al
  800ed1:	0f b6 d0             	movzbl %al,%edx
  800ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed7:	0f b6 c0             	movzbl %al,%eax
  800eda:	39 c2                	cmp    %eax,%edx
  800edc:	74 0d                	je     800eeb <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ede:	ff 45 08             	incl   0x8(%ebp)
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ee7:	72 e3                	jb     800ecc <memfind+0x13>
  800ee9:	eb 01                	jmp    800eec <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800eeb:	90                   	nop
	return (void *) s;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eef:	c9                   	leave  
  800ef0:	c3                   	ret    

00800ef1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ef7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800efe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f05:	eb 03                	jmp    800f0a <strtol+0x19>
		s++;
  800f07:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	3c 20                	cmp    $0x20,%al
  800f11:	74 f4                	je     800f07 <strtol+0x16>
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	3c 09                	cmp    $0x9,%al
  800f1a:	74 eb                	je     800f07 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8a 00                	mov    (%eax),%al
  800f21:	3c 2b                	cmp    $0x2b,%al
  800f23:	75 05                	jne    800f2a <strtol+0x39>
		s++;
  800f25:	ff 45 08             	incl   0x8(%ebp)
  800f28:	eb 13                	jmp    800f3d <strtol+0x4c>
	else if (*s == '-')
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	3c 2d                	cmp    $0x2d,%al
  800f31:	75 0a                	jne    800f3d <strtol+0x4c>
		s++, neg = 1;
  800f33:	ff 45 08             	incl   0x8(%ebp)
  800f36:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f41:	74 06                	je     800f49 <strtol+0x58>
  800f43:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f47:	75 20                	jne    800f69 <strtol+0x78>
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	3c 30                	cmp    $0x30,%al
  800f50:	75 17                	jne    800f69 <strtol+0x78>
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	40                   	inc    %eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	3c 78                	cmp    $0x78,%al
  800f5a:	75 0d                	jne    800f69 <strtol+0x78>
		s += 2, base = 16;
  800f5c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f60:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f67:	eb 28                	jmp    800f91 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6d:	75 15                	jne    800f84 <strtol+0x93>
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	3c 30                	cmp    $0x30,%al
  800f76:	75 0c                	jne    800f84 <strtol+0x93>
		s++, base = 8;
  800f78:	ff 45 08             	incl   0x8(%ebp)
  800f7b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f82:	eb 0d                	jmp    800f91 <strtol+0xa0>
	else if (base == 0)
  800f84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f88:	75 07                	jne    800f91 <strtol+0xa0>
		base = 10;
  800f8a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	3c 2f                	cmp    $0x2f,%al
  800f98:	7e 19                	jle    800fb3 <strtol+0xc2>
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	8a 00                	mov    (%eax),%al
  800f9f:	3c 39                	cmp    $0x39,%al
  800fa1:	7f 10                	jg     800fb3 <strtol+0xc2>
			dig = *s - '0';
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	0f be c0             	movsbl %al,%eax
  800fab:	83 e8 30             	sub    $0x30,%eax
  800fae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fb1:	eb 42                	jmp    800ff5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	3c 60                	cmp    $0x60,%al
  800fba:	7e 19                	jle    800fd5 <strtol+0xe4>
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	8a 00                	mov    (%eax),%al
  800fc1:	3c 7a                	cmp    $0x7a,%al
  800fc3:	7f 10                	jg     800fd5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	8a 00                	mov    (%eax),%al
  800fca:	0f be c0             	movsbl %al,%eax
  800fcd:	83 e8 57             	sub    $0x57,%eax
  800fd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd3:	eb 20                	jmp    800ff5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	3c 40                	cmp    $0x40,%al
  800fdc:	7e 39                	jle    801017 <strtol+0x126>
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	3c 5a                	cmp    $0x5a,%al
  800fe5:	7f 30                	jg     801017 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	0f be c0             	movsbl %al,%eax
  800fef:	83 e8 37             	sub    $0x37,%eax
  800ff2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ffb:	7d 19                	jge    801016 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ffd:	ff 45 08             	incl   0x8(%ebp)
  801000:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801003:	0f af 45 10          	imul   0x10(%ebp),%eax
  801007:	89 c2                	mov    %eax,%edx
  801009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100c:	01 d0                	add    %edx,%eax
  80100e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801011:	e9 7b ff ff ff       	jmp    800f91 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801016:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801017:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80101b:	74 08                	je     801025 <strtol+0x134>
		*endptr = (char *) s;
  80101d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801020:	8b 55 08             	mov    0x8(%ebp),%edx
  801023:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801025:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801029:	74 07                	je     801032 <strtol+0x141>
  80102b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102e:	f7 d8                	neg    %eax
  801030:	eb 03                	jmp    801035 <strtol+0x144>
  801032:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801035:	c9                   	leave  
  801036:	c3                   	ret    

00801037 <ltostr>:

void
ltostr(long value, char *str)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80103d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801044:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80104b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80104f:	79 13                	jns    801064 <ltostr+0x2d>
	{
		neg = 1;
  801051:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801058:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80105e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801061:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80106c:	99                   	cltd   
  80106d:	f7 f9                	idiv   %ecx
  80106f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801072:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801075:	8d 50 01             	lea    0x1(%eax),%edx
  801078:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80107b:	89 c2                	mov    %eax,%edx
  80107d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801080:	01 d0                	add    %edx,%eax
  801082:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801085:	83 c2 30             	add    $0x30,%edx
  801088:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80108a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80108d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801092:	f7 e9                	imul   %ecx
  801094:	c1 fa 02             	sar    $0x2,%edx
  801097:	89 c8                	mov    %ecx,%eax
  801099:	c1 f8 1f             	sar    $0x1f,%eax
  80109c:	29 c2                	sub    %eax,%edx
  80109e:	89 d0                	mov    %edx,%eax
  8010a0:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010a7:	75 bb                	jne    801064 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b3:	48                   	dec    %eax
  8010b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010bb:	74 3d                	je     8010fa <ltostr+0xc3>
		start = 1 ;
  8010bd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010c4:	eb 34                	jmp    8010fa <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cc:	01 d0                	add    %edx,%eax
  8010ce:	8a 00                	mov    (%eax),%al
  8010d0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d9:	01 c2                	add    %eax,%edx
  8010db:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e1:	01 c8                	add    %ecx,%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ed:	01 c2                	add    %eax,%edx
  8010ef:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010f2:	88 02                	mov    %al,(%edx)
		start++ ;
  8010f4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010f7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801100:	7c c4                	jl     8010c6 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801102:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801105:	8b 45 0c             	mov    0xc(%ebp),%eax
  801108:	01 d0                	add    %edx,%eax
  80110a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80110d:	90                   	nop
  80110e:	c9                   	leave  
  80110f:	c3                   	ret    

00801110 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
  801113:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801116:	ff 75 08             	pushl  0x8(%ebp)
  801119:	e8 c4 f9 ff ff       	call   800ae2 <strlen>
  80111e:	83 c4 04             	add    $0x4,%esp
  801121:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801124:	ff 75 0c             	pushl  0xc(%ebp)
  801127:	e8 b6 f9 ff ff       	call   800ae2 <strlen>
  80112c:	83 c4 04             	add    $0x4,%esp
  80112f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801132:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801139:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801140:	eb 17                	jmp    801159 <strcconcat+0x49>
		final[s] = str1[s] ;
  801142:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801145:	8b 45 10             	mov    0x10(%ebp),%eax
  801148:	01 c2                	add    %eax,%edx
  80114a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80114d:	8b 45 08             	mov    0x8(%ebp),%eax
  801150:	01 c8                	add    %ecx,%eax
  801152:	8a 00                	mov    (%eax),%al
  801154:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801156:	ff 45 fc             	incl   -0x4(%ebp)
  801159:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80115f:	7c e1                	jl     801142 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801161:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801168:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80116f:	eb 1f                	jmp    801190 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801171:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801174:	8d 50 01             	lea    0x1(%eax),%edx
  801177:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80117a:	89 c2                	mov    %eax,%edx
  80117c:	8b 45 10             	mov    0x10(%ebp),%eax
  80117f:	01 c2                	add    %eax,%edx
  801181:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801184:	8b 45 0c             	mov    0xc(%ebp),%eax
  801187:	01 c8                	add    %ecx,%eax
  801189:	8a 00                	mov    (%eax),%al
  80118b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80118d:	ff 45 f8             	incl   -0x8(%ebp)
  801190:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801193:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801196:	7c d9                	jl     801171 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801198:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80119b:	8b 45 10             	mov    0x10(%ebp),%eax
  80119e:	01 d0                	add    %edx,%eax
  8011a0:	c6 00 00             	movb   $0x0,(%eax)
}
  8011a3:	90                   	nop
  8011a4:	c9                   	leave  
  8011a5:	c3                   	ret    

008011a6 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b5:	8b 00                	mov    (%eax),%eax
  8011b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011be:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c1:	01 d0                	add    %edx,%eax
  8011c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011c9:	eb 0c                	jmp    8011d7 <strsplit+0x31>
			*string++ = 0;
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	8d 50 01             	lea    0x1(%eax),%edx
  8011d1:	89 55 08             	mov    %edx,0x8(%ebp)
  8011d4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011da:	8a 00                	mov    (%eax),%al
  8011dc:	84 c0                	test   %al,%al
  8011de:	74 18                	je     8011f8 <strsplit+0x52>
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	0f be c0             	movsbl %al,%eax
  8011e8:	50                   	push   %eax
  8011e9:	ff 75 0c             	pushl  0xc(%ebp)
  8011ec:	e8 83 fa ff ff       	call   800c74 <strchr>
  8011f1:	83 c4 08             	add    $0x8,%esp
  8011f4:	85 c0                	test   %eax,%eax
  8011f6:	75 d3                	jne    8011cb <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	8a 00                	mov    (%eax),%al
  8011fd:	84 c0                	test   %al,%al
  8011ff:	74 5a                	je     80125b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801201:	8b 45 14             	mov    0x14(%ebp),%eax
  801204:	8b 00                	mov    (%eax),%eax
  801206:	83 f8 0f             	cmp    $0xf,%eax
  801209:	75 07                	jne    801212 <strsplit+0x6c>
		{
			return 0;
  80120b:	b8 00 00 00 00       	mov    $0x0,%eax
  801210:	eb 66                	jmp    801278 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801212:	8b 45 14             	mov    0x14(%ebp),%eax
  801215:	8b 00                	mov    (%eax),%eax
  801217:	8d 48 01             	lea    0x1(%eax),%ecx
  80121a:	8b 55 14             	mov    0x14(%ebp),%edx
  80121d:	89 0a                	mov    %ecx,(%edx)
  80121f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801226:	8b 45 10             	mov    0x10(%ebp),%eax
  801229:	01 c2                	add    %eax,%edx
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801230:	eb 03                	jmp    801235 <strsplit+0x8f>
			string++;
  801232:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	8a 00                	mov    (%eax),%al
  80123a:	84 c0                	test   %al,%al
  80123c:	74 8b                	je     8011c9 <strsplit+0x23>
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	0f be c0             	movsbl %al,%eax
  801246:	50                   	push   %eax
  801247:	ff 75 0c             	pushl  0xc(%ebp)
  80124a:	e8 25 fa ff ff       	call   800c74 <strchr>
  80124f:	83 c4 08             	add    $0x8,%esp
  801252:	85 c0                	test   %eax,%eax
  801254:	74 dc                	je     801232 <strsplit+0x8c>
			string++;
	}
  801256:	e9 6e ff ff ff       	jmp    8011c9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80125b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80125c:	8b 45 14             	mov    0x14(%ebp),%eax
  80125f:	8b 00                	mov    (%eax),%eax
  801261:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801268:	8b 45 10             	mov    0x10(%ebp),%eax
  80126b:	01 d0                	add    %edx,%eax
  80126d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801273:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801278:	c9                   	leave  
  801279:	c3                   	ret    

0080127a <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80127a:	55                   	push   %ebp
  80127b:	89 e5                	mov    %esp,%ebp
  80127d:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
  801283:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801286:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80128d:	eb 4a                	jmp    8012d9 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80128f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	01 c2                	add    %eax,%edx
  801297:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80129a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129d:	01 c8                	add    %ecx,%eax
  80129f:	8a 00                	mov    (%eax),%al
  8012a1:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8012a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a9:	01 d0                	add    %edx,%eax
  8012ab:	8a 00                	mov    (%eax),%al
  8012ad:	3c 40                	cmp    $0x40,%al
  8012af:	7e 25                	jle    8012d6 <str2lower+0x5c>
  8012b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	01 d0                	add    %edx,%eax
  8012b9:	8a 00                	mov    (%eax),%al
  8012bb:	3c 5a                	cmp    $0x5a,%al
  8012bd:	7f 17                	jg     8012d6 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8012bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	01 d0                	add    %edx,%eax
  8012c7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8012cd:	01 ca                	add    %ecx,%edx
  8012cf:	8a 12                	mov    (%edx),%dl
  8012d1:	83 c2 20             	add    $0x20,%edx
  8012d4:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8012d6:	ff 45 fc             	incl   -0x4(%ebp)
  8012d9:	ff 75 0c             	pushl  0xc(%ebp)
  8012dc:	e8 01 f8 ff ff       	call   800ae2 <strlen>
  8012e1:	83 c4 04             	add    $0x4,%esp
  8012e4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8012e7:	7f a6                	jg     80128f <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8012e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012ec:	c9                   	leave  
  8012ed:	c3                   	ret    

008012ee <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	57                   	push   %edi
  8012f2:	56                   	push   %esi
  8012f3:	53                   	push   %ebx
  8012f4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801300:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801303:	8b 7d 18             	mov    0x18(%ebp),%edi
  801306:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801309:	cd 30                	int    $0x30
  80130b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80130e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801311:	83 c4 10             	add    $0x10,%esp
  801314:	5b                   	pop    %ebx
  801315:	5e                   	pop    %esi
  801316:	5f                   	pop    %edi
  801317:	5d                   	pop    %ebp
  801318:	c3                   	ret    

00801319 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
  80131c:	83 ec 04             	sub    $0x4,%esp
  80131f:	8b 45 10             	mov    0x10(%ebp),%eax
  801322:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801325:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801328:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	6a 00                	push   $0x0
  801331:	51                   	push   %ecx
  801332:	52                   	push   %edx
  801333:	ff 75 0c             	pushl  0xc(%ebp)
  801336:	50                   	push   %eax
  801337:	6a 00                	push   $0x0
  801339:	e8 b0 ff ff ff       	call   8012ee <syscall>
  80133e:	83 c4 18             	add    $0x18,%esp
}
  801341:	90                   	nop
  801342:	c9                   	leave  
  801343:	c3                   	ret    

00801344 <sys_cgetc>:

int
sys_cgetc(void)
{
  801344:	55                   	push   %ebp
  801345:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 00                	push   $0x0
  80134f:	6a 00                	push   $0x0
  801351:	6a 02                	push   $0x2
  801353:	e8 96 ff ff ff       	call   8012ee <syscall>
  801358:	83 c4 18             	add    $0x18,%esp
}
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801360:	6a 00                	push   $0x0
  801362:	6a 00                	push   $0x0
  801364:	6a 00                	push   $0x0
  801366:	6a 00                	push   $0x0
  801368:	6a 00                	push   $0x0
  80136a:	6a 03                	push   $0x3
  80136c:	e8 7d ff ff ff       	call   8012ee <syscall>
  801371:	83 c4 18             	add    $0x18,%esp
}
  801374:	90                   	nop
  801375:	c9                   	leave  
  801376:	c3                   	ret    

00801377 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80137a:	6a 00                	push   $0x0
  80137c:	6a 00                	push   $0x0
  80137e:	6a 00                	push   $0x0
  801380:	6a 00                	push   $0x0
  801382:	6a 00                	push   $0x0
  801384:	6a 04                	push   $0x4
  801386:	e8 63 ff ff ff       	call   8012ee <syscall>
  80138b:	83 c4 18             	add    $0x18,%esp
}
  80138e:	90                   	nop
  80138f:	c9                   	leave  
  801390:	c3                   	ret    

00801391 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801394:	8b 55 0c             	mov    0xc(%ebp),%edx
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	52                   	push   %edx
  8013a1:	50                   	push   %eax
  8013a2:	6a 08                	push   $0x8
  8013a4:	e8 45 ff ff ff       	call   8012ee <syscall>
  8013a9:	83 c4 18             	add    $0x18,%esp
}
  8013ac:	c9                   	leave  
  8013ad:	c3                   	ret    

008013ae <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
  8013b1:	56                   	push   %esi
  8013b2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8013b3:	8b 75 18             	mov    0x18(%ebp),%esi
  8013b6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c2:	56                   	push   %esi
  8013c3:	53                   	push   %ebx
  8013c4:	51                   	push   %ecx
  8013c5:	52                   	push   %edx
  8013c6:	50                   	push   %eax
  8013c7:	6a 09                	push   $0x9
  8013c9:	e8 20 ff ff ff       	call   8012ee <syscall>
  8013ce:	83 c4 18             	add    $0x18,%esp
}
  8013d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013d4:	5b                   	pop    %ebx
  8013d5:	5e                   	pop    %esi
  8013d6:	5d                   	pop    %ebp
  8013d7:	c3                   	ret    

008013d8 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8013db:	6a 00                	push   $0x0
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 00                	push   $0x0
  8013e1:	6a 00                	push   $0x0
  8013e3:	ff 75 08             	pushl  0x8(%ebp)
  8013e6:	6a 0a                	push   $0xa
  8013e8:	e8 01 ff ff ff       	call   8012ee <syscall>
  8013ed:	83 c4 18             	add    $0x18,%esp
}
  8013f0:	c9                   	leave  
  8013f1:	c3                   	ret    

008013f2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013f2:	55                   	push   %ebp
  8013f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	ff 75 0c             	pushl  0xc(%ebp)
  8013fe:	ff 75 08             	pushl  0x8(%ebp)
  801401:	6a 0b                	push   $0xb
  801403:	e8 e6 fe ff ff       	call   8012ee <syscall>
  801408:	83 c4 18             	add    $0x18,%esp
}
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

0080140d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	6a 0c                	push   $0xc
  80141c:	e8 cd fe ff ff       	call   8012ee <syscall>
  801421:	83 c4 18             	add    $0x18,%esp
}
  801424:	c9                   	leave  
  801425:	c3                   	ret    

00801426 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	6a 0d                	push   $0xd
  801435:	e8 b4 fe ff ff       	call   8012ee <syscall>
  80143a:	83 c4 18             	add    $0x18,%esp
}
  80143d:	c9                   	leave  
  80143e:	c3                   	ret    

0080143f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80143f:	55                   	push   %ebp
  801440:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	6a 0e                	push   $0xe
  80144e:	e8 9b fe ff ff       	call   8012ee <syscall>
  801453:	83 c4 18             	add    $0x18,%esp
}
  801456:	c9                   	leave  
  801457:	c3                   	ret    

00801458 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80145b:	6a 00                	push   $0x0
  80145d:	6a 00                	push   $0x0
  80145f:	6a 00                	push   $0x0
  801461:	6a 00                	push   $0x0
  801463:	6a 00                	push   $0x0
  801465:	6a 0f                	push   $0xf
  801467:	e8 82 fe ff ff       	call   8012ee <syscall>
  80146c:	83 c4 18             	add    $0x18,%esp
}
  80146f:	c9                   	leave  
  801470:	c3                   	ret    

00801471 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801474:	6a 00                	push   $0x0
  801476:	6a 00                	push   $0x0
  801478:	6a 00                	push   $0x0
  80147a:	6a 00                	push   $0x0
  80147c:	ff 75 08             	pushl  0x8(%ebp)
  80147f:	6a 10                	push   $0x10
  801481:	e8 68 fe ff ff       	call   8012ee <syscall>
  801486:	83 c4 18             	add    $0x18,%esp
}
  801489:	c9                   	leave  
  80148a:	c3                   	ret    

0080148b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80148b:	55                   	push   %ebp
  80148c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80148e:	6a 00                	push   $0x0
  801490:	6a 00                	push   $0x0
  801492:	6a 00                	push   $0x0
  801494:	6a 00                	push   $0x0
  801496:	6a 00                	push   $0x0
  801498:	6a 11                	push   $0x11
  80149a:	e8 4f fe ff ff       	call   8012ee <syscall>
  80149f:	83 c4 18             	add    $0x18,%esp
}
  8014a2:	90                   	nop
  8014a3:	c9                   	leave  
  8014a4:	c3                   	ret    

008014a5 <sys_cputc>:

void
sys_cputc(const char c)
{
  8014a5:	55                   	push   %ebp
  8014a6:	89 e5                	mov    %esp,%ebp
  8014a8:	83 ec 04             	sub    $0x4,%esp
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8014b1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	50                   	push   %eax
  8014be:	6a 01                	push   $0x1
  8014c0:	e8 29 fe ff ff       	call   8012ee <syscall>
  8014c5:	83 c4 18             	add    $0x18,%esp
}
  8014c8:	90                   	nop
  8014c9:	c9                   	leave  
  8014ca:	c3                   	ret    

008014cb <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 14                	push   $0x14
  8014da:	e8 0f fe ff ff       	call   8012ee <syscall>
  8014df:	83 c4 18             	add    $0x18,%esp
}
  8014e2:	90                   	nop
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	83 ec 04             	sub    $0x4,%esp
  8014eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ee:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014f1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014f4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	6a 00                	push   $0x0
  8014fd:	51                   	push   %ecx
  8014fe:	52                   	push   %edx
  8014ff:	ff 75 0c             	pushl  0xc(%ebp)
  801502:	50                   	push   %eax
  801503:	6a 15                	push   $0x15
  801505:	e8 e4 fd ff ff       	call   8012ee <syscall>
  80150a:	83 c4 18             	add    $0x18,%esp
}
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    

0080150f <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801512:	8b 55 0c             	mov    0xc(%ebp),%edx
  801515:	8b 45 08             	mov    0x8(%ebp),%eax
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	52                   	push   %edx
  80151f:	50                   	push   %eax
  801520:	6a 16                	push   $0x16
  801522:	e8 c7 fd ff ff       	call   8012ee <syscall>
  801527:	83 c4 18             	add    $0x18,%esp
}
  80152a:	c9                   	leave  
  80152b:	c3                   	ret    

0080152c <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80152f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801532:	8b 55 0c             	mov    0xc(%ebp),%edx
  801535:	8b 45 08             	mov    0x8(%ebp),%eax
  801538:	6a 00                	push   $0x0
  80153a:	6a 00                	push   $0x0
  80153c:	51                   	push   %ecx
  80153d:	52                   	push   %edx
  80153e:	50                   	push   %eax
  80153f:	6a 17                	push   $0x17
  801541:	e8 a8 fd ff ff       	call   8012ee <syscall>
  801546:	83 c4 18             	add    $0x18,%esp
}
  801549:	c9                   	leave  
  80154a:	c3                   	ret    

0080154b <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80154e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	52                   	push   %edx
  80155b:	50                   	push   %eax
  80155c:	6a 18                	push   $0x18
  80155e:	e8 8b fd ff ff       	call   8012ee <syscall>
  801563:	83 c4 18             	add    $0x18,%esp
}
  801566:	c9                   	leave  
  801567:	c3                   	ret    

00801568 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	6a 00                	push   $0x0
  801570:	ff 75 14             	pushl  0x14(%ebp)
  801573:	ff 75 10             	pushl  0x10(%ebp)
  801576:	ff 75 0c             	pushl  0xc(%ebp)
  801579:	50                   	push   %eax
  80157a:	6a 19                	push   $0x19
  80157c:	e8 6d fd ff ff       	call   8012ee <syscall>
  801581:	83 c4 18             	add    $0x18,%esp
}
  801584:	c9                   	leave  
  801585:	c3                   	ret    

00801586 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	50                   	push   %eax
  801595:	6a 1a                	push   $0x1a
  801597:	e8 52 fd ff ff       	call   8012ee <syscall>
  80159c:	83 c4 18             	add    $0x18,%esp
}
  80159f:	90                   	nop
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

008015a2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8015a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	50                   	push   %eax
  8015b1:	6a 1b                	push   $0x1b
  8015b3:	e8 36 fd ff ff       	call   8012ee <syscall>
  8015b8:	83 c4 18             	add    $0x18,%esp
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <sys_getenvid>:

int32 sys_getenvid(void)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 05                	push   $0x5
  8015cc:	e8 1d fd ff ff       	call   8012ee <syscall>
  8015d1:	83 c4 18             	add    $0x18,%esp
}
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    

008015d6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 06                	push   $0x6
  8015e5:	e8 04 fd ff ff       	call   8012ee <syscall>
  8015ea:	83 c4 18             	add    $0x18,%esp
}
  8015ed:	c9                   	leave  
  8015ee:	c3                   	ret    

008015ef <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 07                	push   $0x7
  8015fe:	e8 eb fc ff ff       	call   8012ee <syscall>
  801603:	83 c4 18             	add    $0x18,%esp
}
  801606:	c9                   	leave  
  801607:	c3                   	ret    

00801608 <sys_exit_env>:


void sys_exit_env(void)
{
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	6a 1c                	push   $0x1c
  801617:	e8 d2 fc ff ff       	call   8012ee <syscall>
  80161c:	83 c4 18             	add    $0x18,%esp
}
  80161f:	90                   	nop
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
  801625:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801628:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80162b:	8d 50 04             	lea    0x4(%eax),%edx
  80162e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	52                   	push   %edx
  801638:	50                   	push   %eax
  801639:	6a 1d                	push   $0x1d
  80163b:	e8 ae fc ff ff       	call   8012ee <syscall>
  801640:	83 c4 18             	add    $0x18,%esp
	return result;
  801643:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801646:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801649:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80164c:	89 01                	mov    %eax,(%ecx)
  80164e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	c9                   	leave  
  801655:	c2 04 00             	ret    $0x4

00801658 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	ff 75 10             	pushl  0x10(%ebp)
  801662:	ff 75 0c             	pushl  0xc(%ebp)
  801665:	ff 75 08             	pushl  0x8(%ebp)
  801668:	6a 13                	push   $0x13
  80166a:	e8 7f fc ff ff       	call   8012ee <syscall>
  80166f:	83 c4 18             	add    $0x18,%esp
	return ;
  801672:	90                   	nop
}
  801673:	c9                   	leave  
  801674:	c3                   	ret    

00801675 <sys_rcr2>:
uint32 sys_rcr2()
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 1e                	push   $0x1e
  801684:	e8 65 fc ff ff       	call   8012ee <syscall>
  801689:	83 c4 18             	add    $0x18,%esp
}
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	83 ec 04             	sub    $0x4,%esp
  801694:	8b 45 08             	mov    0x8(%ebp),%eax
  801697:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80169a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	50                   	push   %eax
  8016a7:	6a 1f                	push   $0x1f
  8016a9:	e8 40 fc ff ff       	call   8012ee <syscall>
  8016ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8016b1:	90                   	nop
}
  8016b2:	c9                   	leave  
  8016b3:	c3                   	ret    

008016b4 <rsttst>:
void rsttst()
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 21                	push   $0x21
  8016c3:	e8 26 fc ff ff       	call   8012ee <syscall>
  8016c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8016cb:	90                   	nop
}
  8016cc:	c9                   	leave  
  8016cd:	c3                   	ret    

008016ce <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	83 ec 04             	sub    $0x4,%esp
  8016d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016da:	8b 55 18             	mov    0x18(%ebp),%edx
  8016dd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016e1:	52                   	push   %edx
  8016e2:	50                   	push   %eax
  8016e3:	ff 75 10             	pushl  0x10(%ebp)
  8016e6:	ff 75 0c             	pushl  0xc(%ebp)
  8016e9:	ff 75 08             	pushl  0x8(%ebp)
  8016ec:	6a 20                	push   $0x20
  8016ee:	e8 fb fb ff ff       	call   8012ee <syscall>
  8016f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f6:	90                   	nop
}
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    

008016f9 <chktst>:
void chktst(uint32 n)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	ff 75 08             	pushl  0x8(%ebp)
  801707:	6a 22                	push   $0x22
  801709:	e8 e0 fb ff ff       	call   8012ee <syscall>
  80170e:	83 c4 18             	add    $0x18,%esp
	return ;
  801711:	90                   	nop
}
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <inctst>:

void inctst()
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 23                	push   $0x23
  801723:	e8 c6 fb ff ff       	call   8012ee <syscall>
  801728:	83 c4 18             	add    $0x18,%esp
	return ;
  80172b:	90                   	nop
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <gettst>:
uint32 gettst()
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 24                	push   $0x24
  80173d:	e8 ac fb ff ff       	call   8012ee <syscall>
  801742:	83 c4 18             	add    $0x18,%esp
}
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 25                	push   $0x25
  801756:	e8 93 fb ff ff       	call   8012ee <syscall>
  80175b:	83 c4 18             	add    $0x18,%esp
  80175e:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801763:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	ff 75 08             	pushl  0x8(%ebp)
  801780:	6a 26                	push   $0x26
  801782:	e8 67 fb ff ff       	call   8012ee <syscall>
  801787:	83 c4 18             	add    $0x18,%esp
	return ;
  80178a:	90                   	nop
}
  80178b:	c9                   	leave  
  80178c:	c3                   	ret    

0080178d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801791:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801794:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801797:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	6a 00                	push   $0x0
  80179f:	53                   	push   %ebx
  8017a0:	51                   	push   %ecx
  8017a1:	52                   	push   %edx
  8017a2:	50                   	push   %eax
  8017a3:	6a 27                	push   $0x27
  8017a5:	e8 44 fb ff ff       	call   8012ee <syscall>
  8017aa:	83 c4 18             	add    $0x18,%esp
}
  8017ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    

008017b2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8017b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	52                   	push   %edx
  8017c2:	50                   	push   %eax
  8017c3:	6a 28                	push   $0x28
  8017c5:	e8 24 fb ff ff       	call   8012ee <syscall>
  8017ca:	83 c4 18             	add    $0x18,%esp
}
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8017d2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017db:	6a 00                	push   $0x0
  8017dd:	51                   	push   %ecx
  8017de:	ff 75 10             	pushl  0x10(%ebp)
  8017e1:	52                   	push   %edx
  8017e2:	50                   	push   %eax
  8017e3:	6a 29                	push   $0x29
  8017e5:	e8 04 fb ff ff       	call   8012ee <syscall>
  8017ea:	83 c4 18             	add    $0x18,%esp
}
  8017ed:	c9                   	leave  
  8017ee:	c3                   	ret    

008017ef <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	ff 75 10             	pushl  0x10(%ebp)
  8017f9:	ff 75 0c             	pushl  0xc(%ebp)
  8017fc:	ff 75 08             	pushl  0x8(%ebp)
  8017ff:	6a 12                	push   $0x12
  801801:	e8 e8 fa ff ff       	call   8012ee <syscall>
  801806:	83 c4 18             	add    $0x18,%esp
	return ;
  801809:	90                   	nop
}
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80180f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	52                   	push   %edx
  80181c:	50                   	push   %eax
  80181d:	6a 2a                	push   $0x2a
  80181f:	e8 ca fa ff ff       	call   8012ee <syscall>
  801824:	83 c4 18             	add    $0x18,%esp
	return;
  801827:	90                   	nop
}
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 2b                	push   $0x2b
  801839:	e8 b0 fa ff ff       	call   8012ee <syscall>
  80183e:	83 c4 18             	add    $0x18,%esp
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	ff 75 0c             	pushl  0xc(%ebp)
  80184f:	ff 75 08             	pushl  0x8(%ebp)
  801852:	6a 2d                	push   $0x2d
  801854:	e8 95 fa ff ff       	call   8012ee <syscall>
  801859:	83 c4 18             	add    $0x18,%esp
	return;
  80185c:	90                   	nop
}
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	ff 75 0c             	pushl  0xc(%ebp)
  80186b:	ff 75 08             	pushl  0x8(%ebp)
  80186e:	6a 2c                	push   $0x2c
  801870:	e8 79 fa ff ff       	call   8012ee <syscall>
  801875:	83 c4 18             	add    $0x18,%esp
	return ;
  801878:	90                   	nop
}
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801881:	83 ec 04             	sub    $0x4,%esp
  801884:	68 08 23 80 00       	push   $0x802308
  801889:	68 25 01 00 00       	push   $0x125
  80188e:	68 3b 23 80 00       	push   $0x80233b
  801893:	e8 00 00 00 00       	call   801898 <_panic>

00801898 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
  80189b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80189e:	8d 45 10             	lea    0x10(%ebp),%eax
  8018a1:	83 c0 04             	add    $0x4,%eax
  8018a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8018a7:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	74 16                	je     8018c6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8018b0:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  8018b5:	83 ec 08             	sub    $0x8,%esp
  8018b8:	50                   	push   %eax
  8018b9:	68 4c 23 80 00       	push   $0x80234c
  8018be:	e8 46 eb ff ff       	call   800409 <cprintf>
  8018c3:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8018c6:	a1 04 30 80 00       	mov    0x803004,%eax
  8018cb:	83 ec 0c             	sub    $0xc,%esp
  8018ce:	ff 75 0c             	pushl  0xc(%ebp)
  8018d1:	ff 75 08             	pushl  0x8(%ebp)
  8018d4:	50                   	push   %eax
  8018d5:	68 54 23 80 00       	push   $0x802354
  8018da:	6a 74                	push   $0x74
  8018dc:	e8 55 eb ff ff       	call   800436 <cprintf_colored>
  8018e1:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8018e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e7:	83 ec 08             	sub    $0x8,%esp
  8018ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ed:	50                   	push   %eax
  8018ee:	e8 a7 ea ff ff       	call   80039a <vcprintf>
  8018f3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8018f6:	83 ec 08             	sub    $0x8,%esp
  8018f9:	6a 00                	push   $0x0
  8018fb:	68 7c 23 80 00       	push   $0x80237c
  801900:	e8 95 ea ff ff       	call   80039a <vcprintf>
  801905:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801908:	e8 0e ea ff ff       	call   80031b <exit>

	// should not return here
	while (1) ;
  80190d:	eb fe                	jmp    80190d <_panic+0x75>

0080190f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801915:	a1 20 30 80 00       	mov    0x803020,%eax
  80191a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801920:	8b 45 0c             	mov    0xc(%ebp),%eax
  801923:	39 c2                	cmp    %eax,%edx
  801925:	74 14                	je     80193b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801927:	83 ec 04             	sub    $0x4,%esp
  80192a:	68 80 23 80 00       	push   $0x802380
  80192f:	6a 26                	push   $0x26
  801931:	68 cc 23 80 00       	push   $0x8023cc
  801936:	e8 5d ff ff ff       	call   801898 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80193b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801942:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801949:	e9 c5 00 00 00       	jmp    801a13 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80194e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801951:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801958:	8b 45 08             	mov    0x8(%ebp),%eax
  80195b:	01 d0                	add    %edx,%eax
  80195d:	8b 00                	mov    (%eax),%eax
  80195f:	85 c0                	test   %eax,%eax
  801961:	75 08                	jne    80196b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801963:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801966:	e9 a5 00 00 00       	jmp    801a10 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80196b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801972:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801979:	eb 69                	jmp    8019e4 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80197b:	a1 20 30 80 00       	mov    0x803020,%eax
  801980:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801986:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801989:	89 d0                	mov    %edx,%eax
  80198b:	01 c0                	add    %eax,%eax
  80198d:	01 d0                	add    %edx,%eax
  80198f:	c1 e0 03             	shl    $0x3,%eax
  801992:	01 c8                	add    %ecx,%eax
  801994:	8a 40 04             	mov    0x4(%eax),%al
  801997:	84 c0                	test   %al,%al
  801999:	75 46                	jne    8019e1 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80199b:	a1 20 30 80 00       	mov    0x803020,%eax
  8019a0:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8019a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019a9:	89 d0                	mov    %edx,%eax
  8019ab:	01 c0                	add    %eax,%eax
  8019ad:	01 d0                	add    %edx,%eax
  8019af:	c1 e0 03             	shl    $0x3,%eax
  8019b2:	01 c8                	add    %ecx,%eax
  8019b4:	8b 00                	mov    (%eax),%eax
  8019b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8019b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019c1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8019c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	01 c8                	add    %ecx,%eax
  8019d2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8019d4:	39 c2                	cmp    %eax,%edx
  8019d6:	75 09                	jne    8019e1 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8019d8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8019df:	eb 15                	jmp    8019f6 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019e1:	ff 45 e8             	incl   -0x18(%ebp)
  8019e4:	a1 20 30 80 00       	mov    0x803020,%eax
  8019e9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8019ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019f2:	39 c2                	cmp    %eax,%edx
  8019f4:	77 85                	ja     80197b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8019f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019fa:	75 14                	jne    801a10 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8019fc:	83 ec 04             	sub    $0x4,%esp
  8019ff:	68 d8 23 80 00       	push   $0x8023d8
  801a04:	6a 3a                	push   $0x3a
  801a06:	68 cc 23 80 00       	push   $0x8023cc
  801a0b:	e8 88 fe ff ff       	call   801898 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801a10:	ff 45 f0             	incl   -0x10(%ebp)
  801a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a16:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801a19:	0f 8c 2f ff ff ff    	jl     80194e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801a1f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a26:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a2d:	eb 26                	jmp    801a55 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801a2f:	a1 20 30 80 00       	mov    0x803020,%eax
  801a34:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801a3a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a3d:	89 d0                	mov    %edx,%eax
  801a3f:	01 c0                	add    %eax,%eax
  801a41:	01 d0                	add    %edx,%eax
  801a43:	c1 e0 03             	shl    $0x3,%eax
  801a46:	01 c8                	add    %ecx,%eax
  801a48:	8a 40 04             	mov    0x4(%eax),%al
  801a4b:	3c 01                	cmp    $0x1,%al
  801a4d:	75 03                	jne    801a52 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801a4f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a52:	ff 45 e0             	incl   -0x20(%ebp)
  801a55:	a1 20 30 80 00       	mov    0x803020,%eax
  801a5a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801a60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a63:	39 c2                	cmp    %eax,%edx
  801a65:	77 c8                	ja     801a2f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801a6d:	74 14                	je     801a83 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801a6f:	83 ec 04             	sub    $0x4,%esp
  801a72:	68 2c 24 80 00       	push   $0x80242c
  801a77:	6a 44                	push   $0x44
  801a79:	68 cc 23 80 00       	push   $0x8023cc
  801a7e:	e8 15 fe ff ff       	call   801898 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801a83:	90                   	nop
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    
  801a86:	66 90                	xchg   %ax,%ax

00801a88 <__udivdi3>:
  801a88:	55                   	push   %ebp
  801a89:	57                   	push   %edi
  801a8a:	56                   	push   %esi
  801a8b:	53                   	push   %ebx
  801a8c:	83 ec 1c             	sub    $0x1c,%esp
  801a8f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a93:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a9b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a9f:	89 ca                	mov    %ecx,%edx
  801aa1:	89 f8                	mov    %edi,%eax
  801aa3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801aa7:	85 f6                	test   %esi,%esi
  801aa9:	75 2d                	jne    801ad8 <__udivdi3+0x50>
  801aab:	39 cf                	cmp    %ecx,%edi
  801aad:	77 65                	ja     801b14 <__udivdi3+0x8c>
  801aaf:	89 fd                	mov    %edi,%ebp
  801ab1:	85 ff                	test   %edi,%edi
  801ab3:	75 0b                	jne    801ac0 <__udivdi3+0x38>
  801ab5:	b8 01 00 00 00       	mov    $0x1,%eax
  801aba:	31 d2                	xor    %edx,%edx
  801abc:	f7 f7                	div    %edi
  801abe:	89 c5                	mov    %eax,%ebp
  801ac0:	31 d2                	xor    %edx,%edx
  801ac2:	89 c8                	mov    %ecx,%eax
  801ac4:	f7 f5                	div    %ebp
  801ac6:	89 c1                	mov    %eax,%ecx
  801ac8:	89 d8                	mov    %ebx,%eax
  801aca:	f7 f5                	div    %ebp
  801acc:	89 cf                	mov    %ecx,%edi
  801ace:	89 fa                	mov    %edi,%edx
  801ad0:	83 c4 1c             	add    $0x1c,%esp
  801ad3:	5b                   	pop    %ebx
  801ad4:	5e                   	pop    %esi
  801ad5:	5f                   	pop    %edi
  801ad6:	5d                   	pop    %ebp
  801ad7:	c3                   	ret    
  801ad8:	39 ce                	cmp    %ecx,%esi
  801ada:	77 28                	ja     801b04 <__udivdi3+0x7c>
  801adc:	0f bd fe             	bsr    %esi,%edi
  801adf:	83 f7 1f             	xor    $0x1f,%edi
  801ae2:	75 40                	jne    801b24 <__udivdi3+0x9c>
  801ae4:	39 ce                	cmp    %ecx,%esi
  801ae6:	72 0a                	jb     801af2 <__udivdi3+0x6a>
  801ae8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801aec:	0f 87 9e 00 00 00    	ja     801b90 <__udivdi3+0x108>
  801af2:	b8 01 00 00 00       	mov    $0x1,%eax
  801af7:	89 fa                	mov    %edi,%edx
  801af9:	83 c4 1c             	add    $0x1c,%esp
  801afc:	5b                   	pop    %ebx
  801afd:	5e                   	pop    %esi
  801afe:	5f                   	pop    %edi
  801aff:	5d                   	pop    %ebp
  801b00:	c3                   	ret    
  801b01:	8d 76 00             	lea    0x0(%esi),%esi
  801b04:	31 ff                	xor    %edi,%edi
  801b06:	31 c0                	xor    %eax,%eax
  801b08:	89 fa                	mov    %edi,%edx
  801b0a:	83 c4 1c             	add    $0x1c,%esp
  801b0d:	5b                   	pop    %ebx
  801b0e:	5e                   	pop    %esi
  801b0f:	5f                   	pop    %edi
  801b10:	5d                   	pop    %ebp
  801b11:	c3                   	ret    
  801b12:	66 90                	xchg   %ax,%ax
  801b14:	89 d8                	mov    %ebx,%eax
  801b16:	f7 f7                	div    %edi
  801b18:	31 ff                	xor    %edi,%edi
  801b1a:	89 fa                	mov    %edi,%edx
  801b1c:	83 c4 1c             	add    $0x1c,%esp
  801b1f:	5b                   	pop    %ebx
  801b20:	5e                   	pop    %esi
  801b21:	5f                   	pop    %edi
  801b22:	5d                   	pop    %ebp
  801b23:	c3                   	ret    
  801b24:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b29:	89 eb                	mov    %ebp,%ebx
  801b2b:	29 fb                	sub    %edi,%ebx
  801b2d:	89 f9                	mov    %edi,%ecx
  801b2f:	d3 e6                	shl    %cl,%esi
  801b31:	89 c5                	mov    %eax,%ebp
  801b33:	88 d9                	mov    %bl,%cl
  801b35:	d3 ed                	shr    %cl,%ebp
  801b37:	89 e9                	mov    %ebp,%ecx
  801b39:	09 f1                	or     %esi,%ecx
  801b3b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b3f:	89 f9                	mov    %edi,%ecx
  801b41:	d3 e0                	shl    %cl,%eax
  801b43:	89 c5                	mov    %eax,%ebp
  801b45:	89 d6                	mov    %edx,%esi
  801b47:	88 d9                	mov    %bl,%cl
  801b49:	d3 ee                	shr    %cl,%esi
  801b4b:	89 f9                	mov    %edi,%ecx
  801b4d:	d3 e2                	shl    %cl,%edx
  801b4f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b53:	88 d9                	mov    %bl,%cl
  801b55:	d3 e8                	shr    %cl,%eax
  801b57:	09 c2                	or     %eax,%edx
  801b59:	89 d0                	mov    %edx,%eax
  801b5b:	89 f2                	mov    %esi,%edx
  801b5d:	f7 74 24 0c          	divl   0xc(%esp)
  801b61:	89 d6                	mov    %edx,%esi
  801b63:	89 c3                	mov    %eax,%ebx
  801b65:	f7 e5                	mul    %ebp
  801b67:	39 d6                	cmp    %edx,%esi
  801b69:	72 19                	jb     801b84 <__udivdi3+0xfc>
  801b6b:	74 0b                	je     801b78 <__udivdi3+0xf0>
  801b6d:	89 d8                	mov    %ebx,%eax
  801b6f:	31 ff                	xor    %edi,%edi
  801b71:	e9 58 ff ff ff       	jmp    801ace <__udivdi3+0x46>
  801b76:	66 90                	xchg   %ax,%ax
  801b78:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b7c:	89 f9                	mov    %edi,%ecx
  801b7e:	d3 e2                	shl    %cl,%edx
  801b80:	39 c2                	cmp    %eax,%edx
  801b82:	73 e9                	jae    801b6d <__udivdi3+0xe5>
  801b84:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b87:	31 ff                	xor    %edi,%edi
  801b89:	e9 40 ff ff ff       	jmp    801ace <__udivdi3+0x46>
  801b8e:	66 90                	xchg   %ax,%ax
  801b90:	31 c0                	xor    %eax,%eax
  801b92:	e9 37 ff ff ff       	jmp    801ace <__udivdi3+0x46>
  801b97:	90                   	nop

00801b98 <__umoddi3>:
  801b98:	55                   	push   %ebp
  801b99:	57                   	push   %edi
  801b9a:	56                   	push   %esi
  801b9b:	53                   	push   %ebx
  801b9c:	83 ec 1c             	sub    $0x1c,%esp
  801b9f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ba3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ba7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801baf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bb3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bb7:	89 f3                	mov    %esi,%ebx
  801bb9:	89 fa                	mov    %edi,%edx
  801bbb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bbf:	89 34 24             	mov    %esi,(%esp)
  801bc2:	85 c0                	test   %eax,%eax
  801bc4:	75 1a                	jne    801be0 <__umoddi3+0x48>
  801bc6:	39 f7                	cmp    %esi,%edi
  801bc8:	0f 86 a2 00 00 00    	jbe    801c70 <__umoddi3+0xd8>
  801bce:	89 c8                	mov    %ecx,%eax
  801bd0:	89 f2                	mov    %esi,%edx
  801bd2:	f7 f7                	div    %edi
  801bd4:	89 d0                	mov    %edx,%eax
  801bd6:	31 d2                	xor    %edx,%edx
  801bd8:	83 c4 1c             	add    $0x1c,%esp
  801bdb:	5b                   	pop    %ebx
  801bdc:	5e                   	pop    %esi
  801bdd:	5f                   	pop    %edi
  801bde:	5d                   	pop    %ebp
  801bdf:	c3                   	ret    
  801be0:	39 f0                	cmp    %esi,%eax
  801be2:	0f 87 ac 00 00 00    	ja     801c94 <__umoddi3+0xfc>
  801be8:	0f bd e8             	bsr    %eax,%ebp
  801beb:	83 f5 1f             	xor    $0x1f,%ebp
  801bee:	0f 84 ac 00 00 00    	je     801ca0 <__umoddi3+0x108>
  801bf4:	bf 20 00 00 00       	mov    $0x20,%edi
  801bf9:	29 ef                	sub    %ebp,%edi
  801bfb:	89 fe                	mov    %edi,%esi
  801bfd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c01:	89 e9                	mov    %ebp,%ecx
  801c03:	d3 e0                	shl    %cl,%eax
  801c05:	89 d7                	mov    %edx,%edi
  801c07:	89 f1                	mov    %esi,%ecx
  801c09:	d3 ef                	shr    %cl,%edi
  801c0b:	09 c7                	or     %eax,%edi
  801c0d:	89 e9                	mov    %ebp,%ecx
  801c0f:	d3 e2                	shl    %cl,%edx
  801c11:	89 14 24             	mov    %edx,(%esp)
  801c14:	89 d8                	mov    %ebx,%eax
  801c16:	d3 e0                	shl    %cl,%eax
  801c18:	89 c2                	mov    %eax,%edx
  801c1a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c1e:	d3 e0                	shl    %cl,%eax
  801c20:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c24:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c28:	89 f1                	mov    %esi,%ecx
  801c2a:	d3 e8                	shr    %cl,%eax
  801c2c:	09 d0                	or     %edx,%eax
  801c2e:	d3 eb                	shr    %cl,%ebx
  801c30:	89 da                	mov    %ebx,%edx
  801c32:	f7 f7                	div    %edi
  801c34:	89 d3                	mov    %edx,%ebx
  801c36:	f7 24 24             	mull   (%esp)
  801c39:	89 c6                	mov    %eax,%esi
  801c3b:	89 d1                	mov    %edx,%ecx
  801c3d:	39 d3                	cmp    %edx,%ebx
  801c3f:	0f 82 87 00 00 00    	jb     801ccc <__umoddi3+0x134>
  801c45:	0f 84 91 00 00 00    	je     801cdc <__umoddi3+0x144>
  801c4b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c4f:	29 f2                	sub    %esi,%edx
  801c51:	19 cb                	sbb    %ecx,%ebx
  801c53:	89 d8                	mov    %ebx,%eax
  801c55:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c59:	d3 e0                	shl    %cl,%eax
  801c5b:	89 e9                	mov    %ebp,%ecx
  801c5d:	d3 ea                	shr    %cl,%edx
  801c5f:	09 d0                	or     %edx,%eax
  801c61:	89 e9                	mov    %ebp,%ecx
  801c63:	d3 eb                	shr    %cl,%ebx
  801c65:	89 da                	mov    %ebx,%edx
  801c67:	83 c4 1c             	add    $0x1c,%esp
  801c6a:	5b                   	pop    %ebx
  801c6b:	5e                   	pop    %esi
  801c6c:	5f                   	pop    %edi
  801c6d:	5d                   	pop    %ebp
  801c6e:	c3                   	ret    
  801c6f:	90                   	nop
  801c70:	89 fd                	mov    %edi,%ebp
  801c72:	85 ff                	test   %edi,%edi
  801c74:	75 0b                	jne    801c81 <__umoddi3+0xe9>
  801c76:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7b:	31 d2                	xor    %edx,%edx
  801c7d:	f7 f7                	div    %edi
  801c7f:	89 c5                	mov    %eax,%ebp
  801c81:	89 f0                	mov    %esi,%eax
  801c83:	31 d2                	xor    %edx,%edx
  801c85:	f7 f5                	div    %ebp
  801c87:	89 c8                	mov    %ecx,%eax
  801c89:	f7 f5                	div    %ebp
  801c8b:	89 d0                	mov    %edx,%eax
  801c8d:	e9 44 ff ff ff       	jmp    801bd6 <__umoddi3+0x3e>
  801c92:	66 90                	xchg   %ax,%ax
  801c94:	89 c8                	mov    %ecx,%eax
  801c96:	89 f2                	mov    %esi,%edx
  801c98:	83 c4 1c             	add    $0x1c,%esp
  801c9b:	5b                   	pop    %ebx
  801c9c:	5e                   	pop    %esi
  801c9d:	5f                   	pop    %edi
  801c9e:	5d                   	pop    %ebp
  801c9f:	c3                   	ret    
  801ca0:	3b 04 24             	cmp    (%esp),%eax
  801ca3:	72 06                	jb     801cab <__umoddi3+0x113>
  801ca5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ca9:	77 0f                	ja     801cba <__umoddi3+0x122>
  801cab:	89 f2                	mov    %esi,%edx
  801cad:	29 f9                	sub    %edi,%ecx
  801caf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801cb3:	89 14 24             	mov    %edx,(%esp)
  801cb6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cba:	8b 44 24 04          	mov    0x4(%esp),%eax
  801cbe:	8b 14 24             	mov    (%esp),%edx
  801cc1:	83 c4 1c             	add    $0x1c,%esp
  801cc4:	5b                   	pop    %ebx
  801cc5:	5e                   	pop    %esi
  801cc6:	5f                   	pop    %edi
  801cc7:	5d                   	pop    %ebp
  801cc8:	c3                   	ret    
  801cc9:	8d 76 00             	lea    0x0(%esi),%esi
  801ccc:	2b 04 24             	sub    (%esp),%eax
  801ccf:	19 fa                	sbb    %edi,%edx
  801cd1:	89 d1                	mov    %edx,%ecx
  801cd3:	89 c6                	mov    %eax,%esi
  801cd5:	e9 71 ff ff ff       	jmp    801c4b <__umoddi3+0xb3>
  801cda:	66 90                	xchg   %ax,%ax
  801cdc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ce0:	72 ea                	jb     801ccc <__umoddi3+0x134>
  801ce2:	89 d9                	mov    %ebx,%ecx
  801ce4:	e9 62 ff ff ff       	jmp    801c4b <__umoddi3+0xb3>

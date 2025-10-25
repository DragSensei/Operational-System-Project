
obj/user/fos_add:     file format elf32-i386


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
  800031:	e8 d9 00 00 00       	call   80010f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// hello, world
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int i1=0;
  80003e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int i2=0;
  800045:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

	i1 = strtol("1", NULL, 10);
  80004c:	83 ec 04             	sub    $0x4,%esp
  80004f:	6a 0a                	push   $0xa
  800051:	6a 00                	push   $0x0
  800053:	68 80 1c 80 00       	push   $0x801c80
  800058:	e8 2a 0e 00 00       	call   800e87 <strtol>
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	89 45 e8             	mov    %eax,-0x18(%ebp)
	i2 = strtol("2", NULL, 10);
  800063:	83 ec 04             	sub    $0x4,%esp
  800066:	6a 0a                	push   $0xa
  800068:	6a 00                	push   $0x0
  80006a:	68 82 1c 80 00       	push   $0x801c82
  80006f:	e8 13 0e 00 00       	call   800e87 <strtol>
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
  80007a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80007d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800080:	01 d0                	add    %edx,%eax
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	50                   	push   %eax
  800086:	68 84 1c 80 00       	push   $0x801c84
  80008b:	e8 81 03 00 00       	call   800411 <atomic_cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
	cprintf("%~number 1 + number 2 = \n");
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	68 9e 1c 80 00       	push   $0x801c9e
  80009b:	e8 ff 02 00 00       	call   80039f <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp

	int N = 100000;
  8000a3:	c7 45 e0 a0 86 01 00 	movl   $0x186a0,-0x20(%ebp)
	int64 sum = 0;
  8000aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = 0; i < N; ++i) {
  8000b8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8000bf:	eb 0d                	jmp    8000ce <_main+0x96>
		sum+=i ;
  8000c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000c4:	99                   	cltd   
  8000c5:	01 45 f0             	add    %eax,-0x10(%ebp)
  8000c8:	11 55 f4             	adc    %edx,-0xc(%ebp)
	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
	cprintf("%~number 1 + number 2 = \n");

	int N = 100000;
	int64 sum = 0;
	for (int i = 0; i < N; ++i) {
  8000cb:	ff 45 ec             	incl   -0x14(%ebp)
  8000ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000d1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000d4:	7c eb                	jl     8000c1 <_main+0x89>
		sum+=i ;
	}
	cprintf_colored(TEXT_green + TEXTBG_blue, "sum 1->%d = %d\n", N, sum);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8000dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8000df:	ff 75 e0             	pushl  -0x20(%ebp)
  8000e2:	68 b8 1c 80 00       	push   $0x801cb8
  8000e7:	6a 12                	push   $0x12
  8000e9:	e8 de 02 00 00       	call   8003cc <cprintf_colored>
  8000ee:	83 c4 20             	add    $0x20,%esp
	cprintf_colored(TEXT_magenta + TEXTBG_cyan, "%~sum 1->%d = %d\n", N, sum);
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8000f7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8000fd:	68 c8 1c 80 00       	push   $0x801cc8
  800102:	6a 35                	push   $0x35
  800104:	e8 c3 02 00 00       	call   8003cc <cprintf_colored>
  800109:	83 c4 20             	add    $0x20,%esp

	return;
  80010c:	90                   	nop
}
  80010d:	c9                   	leave  
  80010e:	c3                   	ret    

0080010f <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80010f:	55                   	push   %ebp
  800110:	89 e5                	mov    %esp,%ebp
  800112:	57                   	push   %edi
  800113:	56                   	push   %esi
  800114:	53                   	push   %ebx
  800115:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800118:	e8 4f 14 00 00       	call   80156c <sys_getenvindex>
  80011d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800120:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800123:	89 d0                	mov    %edx,%eax
  800125:	c1 e0 02             	shl    $0x2,%eax
  800128:	01 d0                	add    %edx,%eax
  80012a:	c1 e0 03             	shl    $0x3,%eax
  80012d:	01 d0                	add    %edx,%eax
  80012f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800136:	01 d0                	add    %edx,%eax
  800138:	c1 e0 02             	shl    $0x2,%eax
  80013b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800140:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800145:	a1 20 30 80 00       	mov    0x803020,%eax
  80014a:	8a 40 20             	mov    0x20(%eax),%al
  80014d:	84 c0                	test   %al,%al
  80014f:	74 0d                	je     80015e <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800151:	a1 20 30 80 00       	mov    0x803020,%eax
  800156:	83 c0 20             	add    $0x20,%eax
  800159:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80015e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800162:	7e 0a                	jle    80016e <libmain+0x5f>
		binaryname = argv[0];
  800164:	8b 45 0c             	mov    0xc(%ebp),%eax
  800167:	8b 00                	mov    (%eax),%eax
  800169:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	ff 75 0c             	pushl  0xc(%ebp)
  800174:	ff 75 08             	pushl  0x8(%ebp)
  800177:	e8 bc fe ff ff       	call   800038 <_main>
  80017c:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80017f:	a1 00 30 80 00       	mov    0x803000,%eax
  800184:	85 c0                	test   %eax,%eax
  800186:	0f 84 01 01 00 00    	je     80028d <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80018c:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800192:	bb d4 1d 80 00       	mov    $0x801dd4,%ebx
  800197:	ba 0e 00 00 00       	mov    $0xe,%edx
  80019c:	89 c7                	mov    %eax,%edi
  80019e:	89 de                	mov    %ebx,%esi
  8001a0:	89 d1                	mov    %edx,%ecx
  8001a2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001a4:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001a7:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001ac:	b0 00                	mov    $0x0,%al
  8001ae:	89 d7                	mov    %edx,%edi
  8001b0:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001b2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001b9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001bc:	83 ec 08             	sub    $0x8,%esp
  8001bf:	50                   	push   %eax
  8001c0:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001c6:	50                   	push   %eax
  8001c7:	e8 d6 15 00 00       	call   8017a2 <sys_utilities>
  8001cc:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001cf:	e8 1f 11 00 00       	call   8012f3 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001d4:	83 ec 0c             	sub    $0xc,%esp
  8001d7:	68 f4 1c 80 00       	push   $0x801cf4
  8001dc:	e8 be 01 00 00       	call   80039f <cprintf>
  8001e1:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001e7:	85 c0                	test   %eax,%eax
  8001e9:	74 18                	je     800203 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001eb:	e8 d0 15 00 00       	call   8017c0 <sys_get_optimal_num_faults>
  8001f0:	83 ec 08             	sub    $0x8,%esp
  8001f3:	50                   	push   %eax
  8001f4:	68 1c 1d 80 00       	push   $0x801d1c
  8001f9:	e8 a1 01 00 00       	call   80039f <cprintf>
  8001fe:	83 c4 10             	add    $0x10,%esp
  800201:	eb 59                	jmp    80025c <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800203:	a1 20 30 80 00       	mov    0x803020,%eax
  800208:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80020e:	a1 20 30 80 00       	mov    0x803020,%eax
  800213:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800219:	83 ec 04             	sub    $0x4,%esp
  80021c:	52                   	push   %edx
  80021d:	50                   	push   %eax
  80021e:	68 40 1d 80 00       	push   $0x801d40
  800223:	e8 77 01 00 00       	call   80039f <cprintf>
  800228:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80022b:	a1 20 30 80 00       	mov    0x803020,%eax
  800230:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800236:	a1 20 30 80 00       	mov    0x803020,%eax
  80023b:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800241:	a1 20 30 80 00       	mov    0x803020,%eax
  800246:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80024c:	51                   	push   %ecx
  80024d:	52                   	push   %edx
  80024e:	50                   	push   %eax
  80024f:	68 68 1d 80 00       	push   $0x801d68
  800254:	e8 46 01 00 00       	call   80039f <cprintf>
  800259:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80025c:	a1 20 30 80 00       	mov    0x803020,%eax
  800261:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800267:	83 ec 08             	sub    $0x8,%esp
  80026a:	50                   	push   %eax
  80026b:	68 c0 1d 80 00       	push   $0x801dc0
  800270:	e8 2a 01 00 00       	call   80039f <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800278:	83 ec 0c             	sub    $0xc,%esp
  80027b:	68 f4 1c 80 00       	push   $0x801cf4
  800280:	e8 1a 01 00 00       	call   80039f <cprintf>
  800285:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800288:	e8 80 10 00 00       	call   80130d <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80028d:	e8 1f 00 00 00       	call   8002b1 <exit>
}
  800292:	90                   	nop
  800293:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800296:	5b                   	pop    %ebx
  800297:	5e                   	pop    %esi
  800298:	5f                   	pop    %edi
  800299:	5d                   	pop    %ebp
  80029a:	c3                   	ret    

0080029b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80029b:	55                   	push   %ebp
  80029c:	89 e5                	mov    %esp,%ebp
  80029e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002a1:	83 ec 0c             	sub    $0xc,%esp
  8002a4:	6a 00                	push   $0x0
  8002a6:	e8 8d 12 00 00       	call   801538 <sys_destroy_env>
  8002ab:	83 c4 10             	add    $0x10,%esp
}
  8002ae:	90                   	nop
  8002af:	c9                   	leave  
  8002b0:	c3                   	ret    

008002b1 <exit>:

void
exit(void)
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002b7:	e8 e2 12 00 00       	call   80159e <sys_exit_env>
}
  8002bc:	90                   	nop
  8002bd:	c9                   	leave  
  8002be:	c3                   	ret    

008002bf <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002bf:	55                   	push   %ebp
  8002c0:	89 e5                	mov    %esp,%ebp
  8002c2:	53                   	push   %ebx
  8002c3:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8002c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c9:	8b 00                	mov    (%eax),%eax
  8002cb:	8d 48 01             	lea    0x1(%eax),%ecx
  8002ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002d1:	89 0a                	mov    %ecx,(%edx)
  8002d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d6:	88 d1                	mov    %dl,%cl
  8002d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002db:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e2:	8b 00                	mov    (%eax),%eax
  8002e4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002e9:	75 30                	jne    80031b <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8002eb:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8002f1:	a0 44 30 80 00       	mov    0x803044,%al
  8002f6:	0f b6 c0             	movzbl %al,%eax
  8002f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002fc:	8b 09                	mov    (%ecx),%ecx
  8002fe:	89 cb                	mov    %ecx,%ebx
  800300:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800303:	83 c1 08             	add    $0x8,%ecx
  800306:	52                   	push   %edx
  800307:	50                   	push   %eax
  800308:	53                   	push   %ebx
  800309:	51                   	push   %ecx
  80030a:	e8 a0 0f 00 00       	call   8012af <sys_cputs>
  80030f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800312:	8b 45 0c             	mov    0xc(%ebp),%eax
  800315:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80031b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031e:	8b 40 04             	mov    0x4(%eax),%eax
  800321:	8d 50 01             	lea    0x1(%eax),%edx
  800324:	8b 45 0c             	mov    0xc(%ebp),%eax
  800327:	89 50 04             	mov    %edx,0x4(%eax)
}
  80032a:	90                   	nop
  80032b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80032e:	c9                   	leave  
  80032f:	c3                   	ret    

00800330 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800330:	55                   	push   %ebp
  800331:	89 e5                	mov    %esp,%ebp
  800333:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800339:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800340:	00 00 00 
	b.cnt = 0;
  800343:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80034a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80034d:	ff 75 0c             	pushl  0xc(%ebp)
  800350:	ff 75 08             	pushl  0x8(%ebp)
  800353:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800359:	50                   	push   %eax
  80035a:	68 bf 02 80 00       	push   $0x8002bf
  80035f:	e8 5a 02 00 00       	call   8005be <vprintfmt>
  800364:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800367:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  80036d:	a0 44 30 80 00       	mov    0x803044,%al
  800372:	0f b6 c0             	movzbl %al,%eax
  800375:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80037b:	52                   	push   %edx
  80037c:	50                   	push   %eax
  80037d:	51                   	push   %ecx
  80037e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800384:	83 c0 08             	add    $0x8,%eax
  800387:	50                   	push   %eax
  800388:	e8 22 0f 00 00       	call   8012af <sys_cputs>
  80038d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800390:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800397:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003a5:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8003ac:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003af:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b5:	83 ec 08             	sub    $0x8,%esp
  8003b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8003bb:	50                   	push   %eax
  8003bc:	e8 6f ff ff ff       	call   800330 <vcprintf>
  8003c1:	83 c4 10             	add    $0x10,%esp
  8003c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003ca:	c9                   	leave  
  8003cb:	c3                   	ret    

008003cc <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8003cc:	55                   	push   %ebp
  8003cd:	89 e5                	mov    %esp,%ebp
  8003cf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003d2:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8003d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003dc:	c1 e0 08             	shl    $0x8,%eax
  8003df:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  8003e4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003e7:	83 c0 04             	add    $0x4,%eax
  8003ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f0:	83 ec 08             	sub    $0x8,%esp
  8003f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8003f6:	50                   	push   %eax
  8003f7:	e8 34 ff ff ff       	call   800330 <vcprintf>
  8003fc:	83 c4 10             	add    $0x10,%esp
  8003ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800402:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  800409:	07 00 00 

	return cnt;
  80040c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80040f:	c9                   	leave  
  800410:	c3                   	ret    

00800411 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800411:	55                   	push   %ebp
  800412:	89 e5                	mov    %esp,%ebp
  800414:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800417:	e8 d7 0e 00 00       	call   8012f3 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80041c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80041f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800422:	8b 45 08             	mov    0x8(%ebp),%eax
  800425:	83 ec 08             	sub    $0x8,%esp
  800428:	ff 75 f4             	pushl  -0xc(%ebp)
  80042b:	50                   	push   %eax
  80042c:	e8 ff fe ff ff       	call   800330 <vcprintf>
  800431:	83 c4 10             	add    $0x10,%esp
  800434:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800437:	e8 d1 0e 00 00       	call   80130d <sys_unlock_cons>
	return cnt;
  80043c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80043f:	c9                   	leave  
  800440:	c3                   	ret    

00800441 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800441:	55                   	push   %ebp
  800442:	89 e5                	mov    %esp,%ebp
  800444:	53                   	push   %ebx
  800445:	83 ec 14             	sub    $0x14,%esp
  800448:	8b 45 10             	mov    0x10(%ebp),%eax
  80044b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80044e:	8b 45 14             	mov    0x14(%ebp),%eax
  800451:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800454:	8b 45 18             	mov    0x18(%ebp),%eax
  800457:	ba 00 00 00 00       	mov    $0x0,%edx
  80045c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80045f:	77 55                	ja     8004b6 <printnum+0x75>
  800461:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800464:	72 05                	jb     80046b <printnum+0x2a>
  800466:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800469:	77 4b                	ja     8004b6 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80046b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80046e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800471:	8b 45 18             	mov    0x18(%ebp),%eax
  800474:	ba 00 00 00 00       	mov    $0x0,%edx
  800479:	52                   	push   %edx
  80047a:	50                   	push   %eax
  80047b:	ff 75 f4             	pushl  -0xc(%ebp)
  80047e:	ff 75 f0             	pushl  -0x10(%ebp)
  800481:	e8 96 15 00 00       	call   801a1c <__udivdi3>
  800486:	83 c4 10             	add    $0x10,%esp
  800489:	83 ec 04             	sub    $0x4,%esp
  80048c:	ff 75 20             	pushl  0x20(%ebp)
  80048f:	53                   	push   %ebx
  800490:	ff 75 18             	pushl  0x18(%ebp)
  800493:	52                   	push   %edx
  800494:	50                   	push   %eax
  800495:	ff 75 0c             	pushl  0xc(%ebp)
  800498:	ff 75 08             	pushl  0x8(%ebp)
  80049b:	e8 a1 ff ff ff       	call   800441 <printnum>
  8004a0:	83 c4 20             	add    $0x20,%esp
  8004a3:	eb 1a                	jmp    8004bf <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004a5:	83 ec 08             	sub    $0x8,%esp
  8004a8:	ff 75 0c             	pushl  0xc(%ebp)
  8004ab:	ff 75 20             	pushl  0x20(%ebp)
  8004ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b1:	ff d0                	call   *%eax
  8004b3:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004b6:	ff 4d 1c             	decl   0x1c(%ebp)
  8004b9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8004bd:	7f e6                	jg     8004a5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004bf:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004cd:	53                   	push   %ebx
  8004ce:	51                   	push   %ecx
  8004cf:	52                   	push   %edx
  8004d0:	50                   	push   %eax
  8004d1:	e8 56 16 00 00       	call   801b2c <__umoddi3>
  8004d6:	83 c4 10             	add    $0x10,%esp
  8004d9:	05 54 20 80 00       	add    $0x802054,%eax
  8004de:	8a 00                	mov    (%eax),%al
  8004e0:	0f be c0             	movsbl %al,%eax
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	ff 75 0c             	pushl  0xc(%ebp)
  8004e9:	50                   	push   %eax
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	ff d0                	call   *%eax
  8004ef:	83 c4 10             	add    $0x10,%esp
}
  8004f2:	90                   	nop
  8004f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004f6:	c9                   	leave  
  8004f7:	c3                   	ret    

008004f8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004f8:	55                   	push   %ebp
  8004f9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004fb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004ff:	7e 1c                	jle    80051d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800501:	8b 45 08             	mov    0x8(%ebp),%eax
  800504:	8b 00                	mov    (%eax),%eax
  800506:	8d 50 08             	lea    0x8(%eax),%edx
  800509:	8b 45 08             	mov    0x8(%ebp),%eax
  80050c:	89 10                	mov    %edx,(%eax)
  80050e:	8b 45 08             	mov    0x8(%ebp),%eax
  800511:	8b 00                	mov    (%eax),%eax
  800513:	83 e8 08             	sub    $0x8,%eax
  800516:	8b 50 04             	mov    0x4(%eax),%edx
  800519:	8b 00                	mov    (%eax),%eax
  80051b:	eb 40                	jmp    80055d <getuint+0x65>
	else if (lflag)
  80051d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800521:	74 1e                	je     800541 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800523:	8b 45 08             	mov    0x8(%ebp),%eax
  800526:	8b 00                	mov    (%eax),%eax
  800528:	8d 50 04             	lea    0x4(%eax),%edx
  80052b:	8b 45 08             	mov    0x8(%ebp),%eax
  80052e:	89 10                	mov    %edx,(%eax)
  800530:	8b 45 08             	mov    0x8(%ebp),%eax
  800533:	8b 00                	mov    (%eax),%eax
  800535:	83 e8 04             	sub    $0x4,%eax
  800538:	8b 00                	mov    (%eax),%eax
  80053a:	ba 00 00 00 00       	mov    $0x0,%edx
  80053f:	eb 1c                	jmp    80055d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800541:	8b 45 08             	mov    0x8(%ebp),%eax
  800544:	8b 00                	mov    (%eax),%eax
  800546:	8d 50 04             	lea    0x4(%eax),%edx
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	89 10                	mov    %edx,(%eax)
  80054e:	8b 45 08             	mov    0x8(%ebp),%eax
  800551:	8b 00                	mov    (%eax),%eax
  800553:	83 e8 04             	sub    $0x4,%eax
  800556:	8b 00                	mov    (%eax),%eax
  800558:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80055d:	5d                   	pop    %ebp
  80055e:	c3                   	ret    

0080055f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80055f:	55                   	push   %ebp
  800560:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800562:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800566:	7e 1c                	jle    800584 <getint+0x25>
		return va_arg(*ap, long long);
  800568:	8b 45 08             	mov    0x8(%ebp),%eax
  80056b:	8b 00                	mov    (%eax),%eax
  80056d:	8d 50 08             	lea    0x8(%eax),%edx
  800570:	8b 45 08             	mov    0x8(%ebp),%eax
  800573:	89 10                	mov    %edx,(%eax)
  800575:	8b 45 08             	mov    0x8(%ebp),%eax
  800578:	8b 00                	mov    (%eax),%eax
  80057a:	83 e8 08             	sub    $0x8,%eax
  80057d:	8b 50 04             	mov    0x4(%eax),%edx
  800580:	8b 00                	mov    (%eax),%eax
  800582:	eb 38                	jmp    8005bc <getint+0x5d>
	else if (lflag)
  800584:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800588:	74 1a                	je     8005a4 <getint+0x45>
		return va_arg(*ap, long);
  80058a:	8b 45 08             	mov    0x8(%ebp),%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	8d 50 04             	lea    0x4(%eax),%edx
  800592:	8b 45 08             	mov    0x8(%ebp),%eax
  800595:	89 10                	mov    %edx,(%eax)
  800597:	8b 45 08             	mov    0x8(%ebp),%eax
  80059a:	8b 00                	mov    (%eax),%eax
  80059c:	83 e8 04             	sub    $0x4,%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	99                   	cltd   
  8005a2:	eb 18                	jmp    8005bc <getint+0x5d>
	else
		return va_arg(*ap, int);
  8005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a7:	8b 00                	mov    (%eax),%eax
  8005a9:	8d 50 04             	lea    0x4(%eax),%edx
  8005ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8005af:	89 10                	mov    %edx,(%eax)
  8005b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b4:	8b 00                	mov    (%eax),%eax
  8005b6:	83 e8 04             	sub    $0x4,%eax
  8005b9:	8b 00                	mov    (%eax),%eax
  8005bb:	99                   	cltd   
}
  8005bc:	5d                   	pop    %ebp
  8005bd:	c3                   	ret    

008005be <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005be:	55                   	push   %ebp
  8005bf:	89 e5                	mov    %esp,%ebp
  8005c1:	56                   	push   %esi
  8005c2:	53                   	push   %ebx
  8005c3:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005c6:	eb 17                	jmp    8005df <vprintfmt+0x21>
			if (ch == '\0')
  8005c8:	85 db                	test   %ebx,%ebx
  8005ca:	0f 84 c1 03 00 00    	je     800991 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	ff 75 0c             	pushl  0xc(%ebp)
  8005d6:	53                   	push   %ebx
  8005d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005da:	ff d0                	call   *%eax
  8005dc:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005df:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e2:	8d 50 01             	lea    0x1(%eax),%edx
  8005e5:	89 55 10             	mov    %edx,0x10(%ebp)
  8005e8:	8a 00                	mov    (%eax),%al
  8005ea:	0f b6 d8             	movzbl %al,%ebx
  8005ed:	83 fb 25             	cmp    $0x25,%ebx
  8005f0:	75 d6                	jne    8005c8 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005f2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005f6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005fd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800604:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80060b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800612:	8b 45 10             	mov    0x10(%ebp),%eax
  800615:	8d 50 01             	lea    0x1(%eax),%edx
  800618:	89 55 10             	mov    %edx,0x10(%ebp)
  80061b:	8a 00                	mov    (%eax),%al
  80061d:	0f b6 d8             	movzbl %al,%ebx
  800620:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800623:	83 f8 5b             	cmp    $0x5b,%eax
  800626:	0f 87 3d 03 00 00    	ja     800969 <vprintfmt+0x3ab>
  80062c:	8b 04 85 78 20 80 00 	mov    0x802078(,%eax,4),%eax
  800633:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800635:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800639:	eb d7                	jmp    800612 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80063b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80063f:	eb d1                	jmp    800612 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800641:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800648:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80064b:	89 d0                	mov    %edx,%eax
  80064d:	c1 e0 02             	shl    $0x2,%eax
  800650:	01 d0                	add    %edx,%eax
  800652:	01 c0                	add    %eax,%eax
  800654:	01 d8                	add    %ebx,%eax
  800656:	83 e8 30             	sub    $0x30,%eax
  800659:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80065c:	8b 45 10             	mov    0x10(%ebp),%eax
  80065f:	8a 00                	mov    (%eax),%al
  800661:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800664:	83 fb 2f             	cmp    $0x2f,%ebx
  800667:	7e 3e                	jle    8006a7 <vprintfmt+0xe9>
  800669:	83 fb 39             	cmp    $0x39,%ebx
  80066c:	7f 39                	jg     8006a7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80066e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800671:	eb d5                	jmp    800648 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800673:	8b 45 14             	mov    0x14(%ebp),%eax
  800676:	83 c0 04             	add    $0x4,%eax
  800679:	89 45 14             	mov    %eax,0x14(%ebp)
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	83 e8 04             	sub    $0x4,%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800687:	eb 1f                	jmp    8006a8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800689:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80068d:	79 83                	jns    800612 <vprintfmt+0x54>
				width = 0;
  80068f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800696:	e9 77 ff ff ff       	jmp    800612 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80069b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8006a2:	e9 6b ff ff ff       	jmp    800612 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8006a7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8006a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ac:	0f 89 60 ff ff ff    	jns    800612 <vprintfmt+0x54>
				width = precision, precision = -1;
  8006b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006b8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8006bf:	e9 4e ff ff ff       	jmp    800612 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006c4:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8006c7:	e9 46 ff ff ff       	jmp    800612 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cf:	83 c0 04             	add    $0x4,%eax
  8006d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d8:	83 e8 04             	sub    $0x4,%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	83 ec 08             	sub    $0x8,%esp
  8006e0:	ff 75 0c             	pushl  0xc(%ebp)
  8006e3:	50                   	push   %eax
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	ff d0                	call   *%eax
  8006e9:	83 c4 10             	add    $0x10,%esp
			break;
  8006ec:	e9 9b 02 00 00       	jmp    80098c <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f4:	83 c0 04             	add    $0x4,%eax
  8006f7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fd:	83 e8 04             	sub    $0x4,%eax
  800700:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800702:	85 db                	test   %ebx,%ebx
  800704:	79 02                	jns    800708 <vprintfmt+0x14a>
				err = -err;
  800706:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800708:	83 fb 64             	cmp    $0x64,%ebx
  80070b:	7f 0b                	jg     800718 <vprintfmt+0x15a>
  80070d:	8b 34 9d c0 1e 80 00 	mov    0x801ec0(,%ebx,4),%esi
  800714:	85 f6                	test   %esi,%esi
  800716:	75 19                	jne    800731 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800718:	53                   	push   %ebx
  800719:	68 65 20 80 00       	push   $0x802065
  80071e:	ff 75 0c             	pushl  0xc(%ebp)
  800721:	ff 75 08             	pushl  0x8(%ebp)
  800724:	e8 70 02 00 00       	call   800999 <printfmt>
  800729:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80072c:	e9 5b 02 00 00       	jmp    80098c <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800731:	56                   	push   %esi
  800732:	68 6e 20 80 00       	push   $0x80206e
  800737:	ff 75 0c             	pushl  0xc(%ebp)
  80073a:	ff 75 08             	pushl  0x8(%ebp)
  80073d:	e8 57 02 00 00       	call   800999 <printfmt>
  800742:	83 c4 10             	add    $0x10,%esp
			break;
  800745:	e9 42 02 00 00       	jmp    80098c <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80074a:	8b 45 14             	mov    0x14(%ebp),%eax
  80074d:	83 c0 04             	add    $0x4,%eax
  800750:	89 45 14             	mov    %eax,0x14(%ebp)
  800753:	8b 45 14             	mov    0x14(%ebp),%eax
  800756:	83 e8 04             	sub    $0x4,%eax
  800759:	8b 30                	mov    (%eax),%esi
  80075b:	85 f6                	test   %esi,%esi
  80075d:	75 05                	jne    800764 <vprintfmt+0x1a6>
				p = "(null)";
  80075f:	be 71 20 80 00       	mov    $0x802071,%esi
			if (width > 0 && padc != '-')
  800764:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800768:	7e 6d                	jle    8007d7 <vprintfmt+0x219>
  80076a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80076e:	74 67                	je     8007d7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800770:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800773:	83 ec 08             	sub    $0x8,%esp
  800776:	50                   	push   %eax
  800777:	56                   	push   %esi
  800778:	e8 1e 03 00 00       	call   800a9b <strnlen>
  80077d:	83 c4 10             	add    $0x10,%esp
  800780:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800783:	eb 16                	jmp    80079b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800785:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	50                   	push   %eax
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	ff d0                	call   *%eax
  800795:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800798:	ff 4d e4             	decl   -0x1c(%ebp)
  80079b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80079f:	7f e4                	jg     800785 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007a1:	eb 34                	jmp    8007d7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8007a3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007a7:	74 1c                	je     8007c5 <vprintfmt+0x207>
  8007a9:	83 fb 1f             	cmp    $0x1f,%ebx
  8007ac:	7e 05                	jle    8007b3 <vprintfmt+0x1f5>
  8007ae:	83 fb 7e             	cmp    $0x7e,%ebx
  8007b1:	7e 12                	jle    8007c5 <vprintfmt+0x207>
					putch('?', putdat);
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	ff 75 0c             	pushl  0xc(%ebp)
  8007b9:	6a 3f                	push   $0x3f
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	ff d0                	call   *%eax
  8007c0:	83 c4 10             	add    $0x10,%esp
  8007c3:	eb 0f                	jmp    8007d4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8007c5:	83 ec 08             	sub    $0x8,%esp
  8007c8:	ff 75 0c             	pushl  0xc(%ebp)
  8007cb:	53                   	push   %ebx
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	ff d0                	call   *%eax
  8007d1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007d4:	ff 4d e4             	decl   -0x1c(%ebp)
  8007d7:	89 f0                	mov    %esi,%eax
  8007d9:	8d 70 01             	lea    0x1(%eax),%esi
  8007dc:	8a 00                	mov    (%eax),%al
  8007de:	0f be d8             	movsbl %al,%ebx
  8007e1:	85 db                	test   %ebx,%ebx
  8007e3:	74 24                	je     800809 <vprintfmt+0x24b>
  8007e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007e9:	78 b8                	js     8007a3 <vprintfmt+0x1e5>
  8007eb:	ff 4d e0             	decl   -0x20(%ebp)
  8007ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007f2:	79 af                	jns    8007a3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007f4:	eb 13                	jmp    800809 <vprintfmt+0x24b>
				putch(' ', putdat);
  8007f6:	83 ec 08             	sub    $0x8,%esp
  8007f9:	ff 75 0c             	pushl  0xc(%ebp)
  8007fc:	6a 20                	push   $0x20
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	ff d0                	call   *%eax
  800803:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800806:	ff 4d e4             	decl   -0x1c(%ebp)
  800809:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080d:	7f e7                	jg     8007f6 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80080f:	e9 78 01 00 00       	jmp    80098c <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800814:	83 ec 08             	sub    $0x8,%esp
  800817:	ff 75 e8             	pushl  -0x18(%ebp)
  80081a:	8d 45 14             	lea    0x14(%ebp),%eax
  80081d:	50                   	push   %eax
  80081e:	e8 3c fd ff ff       	call   80055f <getint>
  800823:	83 c4 10             	add    $0x10,%esp
  800826:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800829:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80082c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80082f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800832:	85 d2                	test   %edx,%edx
  800834:	79 23                	jns    800859 <vprintfmt+0x29b>
				putch('-', putdat);
  800836:	83 ec 08             	sub    $0x8,%esp
  800839:	ff 75 0c             	pushl  0xc(%ebp)
  80083c:	6a 2d                	push   $0x2d
  80083e:	8b 45 08             	mov    0x8(%ebp),%eax
  800841:	ff d0                	call   *%eax
  800843:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800846:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800849:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80084c:	f7 d8                	neg    %eax
  80084e:	83 d2 00             	adc    $0x0,%edx
  800851:	f7 da                	neg    %edx
  800853:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800856:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800859:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800860:	e9 bc 00 00 00       	jmp    800921 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800865:	83 ec 08             	sub    $0x8,%esp
  800868:	ff 75 e8             	pushl  -0x18(%ebp)
  80086b:	8d 45 14             	lea    0x14(%ebp),%eax
  80086e:	50                   	push   %eax
  80086f:	e8 84 fc ff ff       	call   8004f8 <getuint>
  800874:	83 c4 10             	add    $0x10,%esp
  800877:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80087a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80087d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800884:	e9 98 00 00 00       	jmp    800921 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800889:	83 ec 08             	sub    $0x8,%esp
  80088c:	ff 75 0c             	pushl  0xc(%ebp)
  80088f:	6a 58                	push   $0x58
  800891:	8b 45 08             	mov    0x8(%ebp),%eax
  800894:	ff d0                	call   *%eax
  800896:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800899:	83 ec 08             	sub    $0x8,%esp
  80089c:	ff 75 0c             	pushl  0xc(%ebp)
  80089f:	6a 58                	push   $0x58
  8008a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a4:	ff d0                	call   *%eax
  8008a6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008a9:	83 ec 08             	sub    $0x8,%esp
  8008ac:	ff 75 0c             	pushl  0xc(%ebp)
  8008af:	6a 58                	push   $0x58
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	ff d0                	call   *%eax
  8008b6:	83 c4 10             	add    $0x10,%esp
			break;
  8008b9:	e9 ce 00 00 00       	jmp    80098c <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8008be:	83 ec 08             	sub    $0x8,%esp
  8008c1:	ff 75 0c             	pushl  0xc(%ebp)
  8008c4:	6a 30                	push   $0x30
  8008c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c9:	ff d0                	call   *%eax
  8008cb:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008ce:	83 ec 08             	sub    $0x8,%esp
  8008d1:	ff 75 0c             	pushl  0xc(%ebp)
  8008d4:	6a 78                	push   $0x78
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	ff d0                	call   *%eax
  8008db:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8008de:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e1:	83 c0 04             	add    $0x4,%eax
  8008e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ea:	83 e8 04             	sub    $0x4,%eax
  8008ed:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008f9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800900:	eb 1f                	jmp    800921 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800902:	83 ec 08             	sub    $0x8,%esp
  800905:	ff 75 e8             	pushl  -0x18(%ebp)
  800908:	8d 45 14             	lea    0x14(%ebp),%eax
  80090b:	50                   	push   %eax
  80090c:	e8 e7 fb ff ff       	call   8004f8 <getuint>
  800911:	83 c4 10             	add    $0x10,%esp
  800914:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800917:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80091a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800921:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800925:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800928:	83 ec 04             	sub    $0x4,%esp
  80092b:	52                   	push   %edx
  80092c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80092f:	50                   	push   %eax
  800930:	ff 75 f4             	pushl  -0xc(%ebp)
  800933:	ff 75 f0             	pushl  -0x10(%ebp)
  800936:	ff 75 0c             	pushl  0xc(%ebp)
  800939:	ff 75 08             	pushl  0x8(%ebp)
  80093c:	e8 00 fb ff ff       	call   800441 <printnum>
  800941:	83 c4 20             	add    $0x20,%esp
			break;
  800944:	eb 46                	jmp    80098c <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800946:	83 ec 08             	sub    $0x8,%esp
  800949:	ff 75 0c             	pushl  0xc(%ebp)
  80094c:	53                   	push   %ebx
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	ff d0                	call   *%eax
  800952:	83 c4 10             	add    $0x10,%esp
			break;
  800955:	eb 35                	jmp    80098c <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800957:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  80095e:	eb 2c                	jmp    80098c <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800960:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800967:	eb 23                	jmp    80098c <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800969:	83 ec 08             	sub    $0x8,%esp
  80096c:	ff 75 0c             	pushl  0xc(%ebp)
  80096f:	6a 25                	push   $0x25
  800971:	8b 45 08             	mov    0x8(%ebp),%eax
  800974:	ff d0                	call   *%eax
  800976:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800979:	ff 4d 10             	decl   0x10(%ebp)
  80097c:	eb 03                	jmp    800981 <vprintfmt+0x3c3>
  80097e:	ff 4d 10             	decl   0x10(%ebp)
  800981:	8b 45 10             	mov    0x10(%ebp),%eax
  800984:	48                   	dec    %eax
  800985:	8a 00                	mov    (%eax),%al
  800987:	3c 25                	cmp    $0x25,%al
  800989:	75 f3                	jne    80097e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80098b:	90                   	nop
		}
	}
  80098c:	e9 35 fc ff ff       	jmp    8005c6 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800991:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800992:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800995:	5b                   	pop    %ebx
  800996:	5e                   	pop    %esi
  800997:	5d                   	pop    %ebp
  800998:	c3                   	ret    

00800999 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80099f:	8d 45 10             	lea    0x10(%ebp),%eax
  8009a2:	83 c0 04             	add    $0x4,%eax
  8009a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8009a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ae:	50                   	push   %eax
  8009af:	ff 75 0c             	pushl  0xc(%ebp)
  8009b2:	ff 75 08             	pushl  0x8(%ebp)
  8009b5:	e8 04 fc ff ff       	call   8005be <vprintfmt>
  8009ba:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8009bd:	90                   	nop
  8009be:	c9                   	leave  
  8009bf:	c3                   	ret    

008009c0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009c0:	55                   	push   %ebp
  8009c1:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8009c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c6:	8b 40 08             	mov    0x8(%eax),%eax
  8009c9:	8d 50 01             	lea    0x1(%eax),%edx
  8009cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cf:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8009d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d5:	8b 10                	mov    (%eax),%edx
  8009d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009da:	8b 40 04             	mov    0x4(%eax),%eax
  8009dd:	39 c2                	cmp    %eax,%edx
  8009df:	73 12                	jae    8009f3 <sprintputch+0x33>
		*b->buf++ = ch;
  8009e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e4:	8b 00                	mov    (%eax),%eax
  8009e6:	8d 48 01             	lea    0x1(%eax),%ecx
  8009e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ec:	89 0a                	mov    %ecx,(%edx)
  8009ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8009f1:	88 10                	mov    %dl,(%eax)
}
  8009f3:	90                   	nop
  8009f4:	5d                   	pop    %ebp
  8009f5:	c3                   	ret    

008009f6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a05:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a08:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0b:	01 d0                	add    %edx,%eax
  800a0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a10:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a17:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a1b:	74 06                	je     800a23 <vsnprintf+0x2d>
  800a1d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a21:	7f 07                	jg     800a2a <vsnprintf+0x34>
		return -E_INVAL;
  800a23:	b8 03 00 00 00       	mov    $0x3,%eax
  800a28:	eb 20                	jmp    800a4a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a2a:	ff 75 14             	pushl  0x14(%ebp)
  800a2d:	ff 75 10             	pushl  0x10(%ebp)
  800a30:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a33:	50                   	push   %eax
  800a34:	68 c0 09 80 00       	push   $0x8009c0
  800a39:	e8 80 fb ff ff       	call   8005be <vprintfmt>
  800a3e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a44:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a4a:	c9                   	leave  
  800a4b:	c3                   	ret    

00800a4c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a52:	8d 45 10             	lea    0x10(%ebp),%eax
  800a55:	83 c0 04             	add    $0x4,%eax
  800a58:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a5b:	8b 45 10             	mov    0x10(%ebp),%eax
  800a5e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a61:	50                   	push   %eax
  800a62:	ff 75 0c             	pushl  0xc(%ebp)
  800a65:	ff 75 08             	pushl  0x8(%ebp)
  800a68:	e8 89 ff ff ff       	call   8009f6 <vsnprintf>
  800a6d:	83 c4 10             	add    $0x10,%esp
  800a70:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a76:	c9                   	leave  
  800a77:	c3                   	ret    

00800a78 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
  800a7b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a7e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a85:	eb 06                	jmp    800a8d <strlen+0x15>
		n++;
  800a87:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a8a:	ff 45 08             	incl   0x8(%ebp)
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	8a 00                	mov    (%eax),%al
  800a92:	84 c0                	test   %al,%al
  800a94:	75 f1                	jne    800a87 <strlen+0xf>
		n++;
	return n;
  800a96:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a99:	c9                   	leave  
  800a9a:	c3                   	ret    

00800a9b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aa1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800aa8:	eb 09                	jmp    800ab3 <strnlen+0x18>
		n++;
  800aaa:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aad:	ff 45 08             	incl   0x8(%ebp)
  800ab0:	ff 4d 0c             	decl   0xc(%ebp)
  800ab3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ab7:	74 09                	je     800ac2 <strnlen+0x27>
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	8a 00                	mov    (%eax),%al
  800abe:	84 c0                	test   %al,%al
  800ac0:	75 e8                	jne    800aaa <strnlen+0xf>
		n++;
	return n;
  800ac2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ac5:	c9                   	leave  
  800ac6:	c3                   	ret    

00800ac7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ac7:	55                   	push   %ebp
  800ac8:	89 e5                	mov    %esp,%ebp
  800aca:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800acd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ad3:	90                   	nop
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	8d 50 01             	lea    0x1(%eax),%edx
  800ada:	89 55 08             	mov    %edx,0x8(%ebp)
  800add:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ae3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ae6:	8a 12                	mov    (%edx),%dl
  800ae8:	88 10                	mov    %dl,(%eax)
  800aea:	8a 00                	mov    (%eax),%al
  800aec:	84 c0                	test   %al,%al
  800aee:	75 e4                	jne    800ad4 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800af0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800af3:	c9                   	leave  
  800af4:	c3                   	ret    

00800af5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
  800af8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800afb:	8b 45 08             	mov    0x8(%ebp),%eax
  800afe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b08:	eb 1f                	jmp    800b29 <strncpy+0x34>
		*dst++ = *src;
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	8d 50 01             	lea    0x1(%eax),%edx
  800b10:	89 55 08             	mov    %edx,0x8(%ebp)
  800b13:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b16:	8a 12                	mov    (%edx),%dl
  800b18:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1d:	8a 00                	mov    (%eax),%al
  800b1f:	84 c0                	test   %al,%al
  800b21:	74 03                	je     800b26 <strncpy+0x31>
			src++;
  800b23:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b26:	ff 45 fc             	incl   -0x4(%ebp)
  800b29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b2c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b2f:	72 d9                	jb     800b0a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b31:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b34:	c9                   	leave  
  800b35:	c3                   	ret    

00800b36 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b46:	74 30                	je     800b78 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b48:	eb 16                	jmp    800b60 <strlcpy+0x2a>
			*dst++ = *src++;
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	8d 50 01             	lea    0x1(%eax),%edx
  800b50:	89 55 08             	mov    %edx,0x8(%ebp)
  800b53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b56:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b59:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b5c:	8a 12                	mov    (%edx),%dl
  800b5e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b60:	ff 4d 10             	decl   0x10(%ebp)
  800b63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b67:	74 09                	je     800b72 <strlcpy+0x3c>
  800b69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6c:	8a 00                	mov    (%eax),%al
  800b6e:	84 c0                	test   %al,%al
  800b70:	75 d8                	jne    800b4a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b78:	8b 55 08             	mov    0x8(%ebp),%edx
  800b7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b7e:	29 c2                	sub    %eax,%edx
  800b80:	89 d0                	mov    %edx,%eax
}
  800b82:	c9                   	leave  
  800b83:	c3                   	ret    

00800b84 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b87:	eb 06                	jmp    800b8f <strcmp+0xb>
		p++, q++;
  800b89:	ff 45 08             	incl   0x8(%ebp)
  800b8c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	8a 00                	mov    (%eax),%al
  800b94:	84 c0                	test   %al,%al
  800b96:	74 0e                	je     800ba6 <strcmp+0x22>
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	8a 10                	mov    (%eax),%dl
  800b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba0:	8a 00                	mov    (%eax),%al
  800ba2:	38 c2                	cmp    %al,%dl
  800ba4:	74 e3                	je     800b89 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	8a 00                	mov    (%eax),%al
  800bab:	0f b6 d0             	movzbl %al,%edx
  800bae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb1:	8a 00                	mov    (%eax),%al
  800bb3:	0f b6 c0             	movzbl %al,%eax
  800bb6:	29 c2                	sub    %eax,%edx
  800bb8:	89 d0                	mov    %edx,%eax
}
  800bba:	5d                   	pop    %ebp
  800bbb:	c3                   	ret    

00800bbc <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800bbf:	eb 09                	jmp    800bca <strncmp+0xe>
		n--, p++, q++;
  800bc1:	ff 4d 10             	decl   0x10(%ebp)
  800bc4:	ff 45 08             	incl   0x8(%ebp)
  800bc7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800bca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bce:	74 17                	je     800be7 <strncmp+0x2b>
  800bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd3:	8a 00                	mov    (%eax),%al
  800bd5:	84 c0                	test   %al,%al
  800bd7:	74 0e                	je     800be7 <strncmp+0x2b>
  800bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdc:	8a 10                	mov    (%eax),%dl
  800bde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be1:	8a 00                	mov    (%eax),%al
  800be3:	38 c2                	cmp    %al,%dl
  800be5:	74 da                	je     800bc1 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800be7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800beb:	75 07                	jne    800bf4 <strncmp+0x38>
		return 0;
  800bed:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf2:	eb 14                	jmp    800c08 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	8a 00                	mov    (%eax),%al
  800bf9:	0f b6 d0             	movzbl %al,%edx
  800bfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bff:	8a 00                	mov    (%eax),%al
  800c01:	0f b6 c0             	movzbl %al,%eax
  800c04:	29 c2                	sub    %eax,%edx
  800c06:	89 d0                	mov    %edx,%eax
}
  800c08:	5d                   	pop    %ebp
  800c09:	c3                   	ret    

00800c0a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	83 ec 04             	sub    $0x4,%esp
  800c10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c13:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c16:	eb 12                	jmp    800c2a <strchr+0x20>
		if (*s == c)
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	8a 00                	mov    (%eax),%al
  800c1d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c20:	75 05                	jne    800c27 <strchr+0x1d>
			return (char *) s;
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	eb 11                	jmp    800c38 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c27:	ff 45 08             	incl   0x8(%ebp)
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	8a 00                	mov    (%eax),%al
  800c2f:	84 c0                	test   %al,%al
  800c31:	75 e5                	jne    800c18 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c38:	c9                   	leave  
  800c39:	c3                   	ret    

00800c3a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c3a:	55                   	push   %ebp
  800c3b:	89 e5                	mov    %esp,%ebp
  800c3d:	83 ec 04             	sub    $0x4,%esp
  800c40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c43:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c46:	eb 0d                	jmp    800c55 <strfind+0x1b>
		if (*s == c)
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c50:	74 0e                	je     800c60 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c52:	ff 45 08             	incl   0x8(%ebp)
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	8a 00                	mov    (%eax),%al
  800c5a:	84 c0                	test   %al,%al
  800c5c:	75 ea                	jne    800c48 <strfind+0xe>
  800c5e:	eb 01                	jmp    800c61 <strfind+0x27>
		if (*s == c)
			break;
  800c60:	90                   	nop
	return (char *) s;
  800c61:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c64:	c9                   	leave  
  800c65:	c3                   	ret    

00800c66 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800c66:	55                   	push   %ebp
  800c67:	89 e5                	mov    %esp,%ebp
  800c69:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800c72:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c76:	76 63                	jbe    800cdb <memset+0x75>
		uint64 data_block = c;
  800c78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7b:	99                   	cltd   
  800c7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c7f:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800c82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c88:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800c8c:	c1 e0 08             	shl    $0x8,%eax
  800c8f:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c92:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c9b:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800c9f:	c1 e0 10             	shl    $0x10,%eax
  800ca2:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ca5:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ca8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cae:	89 c2                	mov    %eax,%edx
  800cb0:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb5:	09 45 f0             	or     %eax,-0x10(%ebp)
  800cb8:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800cbb:	eb 18                	jmp    800cd5 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800cbd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800cc0:	8d 41 08             	lea    0x8(%ecx),%eax
  800cc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800cc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ccc:	89 01                	mov    %eax,(%ecx)
  800cce:	89 51 04             	mov    %edx,0x4(%ecx)
  800cd1:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800cd5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800cd9:	77 e2                	ja     800cbd <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800cdb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cdf:	74 23                	je     800d04 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ce1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ce7:	eb 0e                	jmp    800cf7 <memset+0x91>
			*p8++ = (uint8)c;
  800ce9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cec:	8d 50 01             	lea    0x1(%eax),%edx
  800cef:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cf2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf5:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800cf7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfa:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cfd:	89 55 10             	mov    %edx,0x10(%ebp)
  800d00:	85 c0                	test   %eax,%eax
  800d02:	75 e5                	jne    800ce9 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d07:	c9                   	leave  
  800d08:	c3                   	ret    

00800d09 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800d1b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d1f:	76 24                	jbe    800d45 <memcpy+0x3c>
		while(n >= 8){
  800d21:	eb 1c                	jmp    800d3f <memcpy+0x36>
			*d64 = *s64;
  800d23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d26:	8b 50 04             	mov    0x4(%eax),%edx
  800d29:	8b 00                	mov    (%eax),%eax
  800d2b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800d2e:	89 01                	mov    %eax,(%ecx)
  800d30:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800d33:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800d37:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800d3b:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800d3f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d43:	77 de                	ja     800d23 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800d45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d49:	74 31                	je     800d7c <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800d4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800d51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d54:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800d57:	eb 16                	jmp    800d6f <memcpy+0x66>
			*d8++ = *s8++;
  800d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d5c:	8d 50 01             	lea    0x1(%eax),%edx
  800d5f:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800d62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d65:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d68:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800d6b:	8a 12                	mov    (%edx),%dl
  800d6d:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800d6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d72:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d75:	89 55 10             	mov    %edx,0x10(%ebp)
  800d78:	85 c0                	test   %eax,%eax
  800d7a:	75 dd                	jne    800d59 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d7f:	c9                   	leave  
  800d80:	c3                   	ret    

00800d81 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d96:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d99:	73 50                	jae    800deb <memmove+0x6a>
  800d9b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800da1:	01 d0                	add    %edx,%eax
  800da3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800da6:	76 43                	jbe    800deb <memmove+0x6a>
		s += n;
  800da8:	8b 45 10             	mov    0x10(%ebp),%eax
  800dab:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800dae:	8b 45 10             	mov    0x10(%ebp),%eax
  800db1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800db4:	eb 10                	jmp    800dc6 <memmove+0x45>
			*--d = *--s;
  800db6:	ff 4d f8             	decl   -0x8(%ebp)
  800db9:	ff 4d fc             	decl   -0x4(%ebp)
  800dbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dbf:	8a 10                	mov    (%eax),%dl
  800dc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800dc6:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dcc:	89 55 10             	mov    %edx,0x10(%ebp)
  800dcf:	85 c0                	test   %eax,%eax
  800dd1:	75 e3                	jne    800db6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dd3:	eb 23                	jmp    800df8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800dd5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd8:	8d 50 01             	lea    0x1(%eax),%edx
  800ddb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dde:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800de1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800de7:	8a 12                	mov    (%edx),%dl
  800de9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800deb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dee:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df1:	89 55 10             	mov    %edx,0x10(%ebp)
  800df4:	85 c0                	test   %eax,%eax
  800df6:	75 dd                	jne    800dd5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dfb:	c9                   	leave  
  800dfc:	c3                   	ret    

00800dfd <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e03:	8b 45 08             	mov    0x8(%ebp),%eax
  800e06:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e0f:	eb 2a                	jmp    800e3b <memcmp+0x3e>
		if (*s1 != *s2)
  800e11:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e14:	8a 10                	mov    (%eax),%dl
  800e16:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e19:	8a 00                	mov    (%eax),%al
  800e1b:	38 c2                	cmp    %al,%dl
  800e1d:	74 16                	je     800e35 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	0f b6 d0             	movzbl %al,%edx
  800e27:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e2a:	8a 00                	mov    (%eax),%al
  800e2c:	0f b6 c0             	movzbl %al,%eax
  800e2f:	29 c2                	sub    %eax,%edx
  800e31:	89 d0                	mov    %edx,%eax
  800e33:	eb 18                	jmp    800e4d <memcmp+0x50>
		s1++, s2++;
  800e35:	ff 45 fc             	incl   -0x4(%ebp)
  800e38:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e41:	89 55 10             	mov    %edx,0x10(%ebp)
  800e44:	85 c0                	test   %eax,%eax
  800e46:	75 c9                	jne    800e11 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e4d:	c9                   	leave  
  800e4e:	c3                   	ret    

00800e4f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e55:	8b 55 08             	mov    0x8(%ebp),%edx
  800e58:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5b:	01 d0                	add    %edx,%eax
  800e5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e60:	eb 15                	jmp    800e77 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	8a 00                	mov    (%eax),%al
  800e67:	0f b6 d0             	movzbl %al,%edx
  800e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6d:	0f b6 c0             	movzbl %al,%eax
  800e70:	39 c2                	cmp    %eax,%edx
  800e72:	74 0d                	je     800e81 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e74:	ff 45 08             	incl   0x8(%ebp)
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e7d:	72 e3                	jb     800e62 <memfind+0x13>
  800e7f:	eb 01                	jmp    800e82 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e81:	90                   	nop
	return (void *) s;
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e85:	c9                   	leave  
  800e86:	c3                   	ret    

00800e87 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e94:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e9b:	eb 03                	jmp    800ea0 <strtol+0x19>
		s++;
  800e9d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	8a 00                	mov    (%eax),%al
  800ea5:	3c 20                	cmp    $0x20,%al
  800ea7:	74 f4                	je     800e9d <strtol+0x16>
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	8a 00                	mov    (%eax),%al
  800eae:	3c 09                	cmp    $0x9,%al
  800eb0:	74 eb                	je     800e9d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb5:	8a 00                	mov    (%eax),%al
  800eb7:	3c 2b                	cmp    $0x2b,%al
  800eb9:	75 05                	jne    800ec0 <strtol+0x39>
		s++;
  800ebb:	ff 45 08             	incl   0x8(%ebp)
  800ebe:	eb 13                	jmp    800ed3 <strtol+0x4c>
	else if (*s == '-')
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	8a 00                	mov    (%eax),%al
  800ec5:	3c 2d                	cmp    $0x2d,%al
  800ec7:	75 0a                	jne    800ed3 <strtol+0x4c>
		s++, neg = 1;
  800ec9:	ff 45 08             	incl   0x8(%ebp)
  800ecc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ed3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed7:	74 06                	je     800edf <strtol+0x58>
  800ed9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800edd:	75 20                	jne    800eff <strtol+0x78>
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	8a 00                	mov    (%eax),%al
  800ee4:	3c 30                	cmp    $0x30,%al
  800ee6:	75 17                	jne    800eff <strtol+0x78>
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	40                   	inc    %eax
  800eec:	8a 00                	mov    (%eax),%al
  800eee:	3c 78                	cmp    $0x78,%al
  800ef0:	75 0d                	jne    800eff <strtol+0x78>
		s += 2, base = 16;
  800ef2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ef6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800efd:	eb 28                	jmp    800f27 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800eff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f03:	75 15                	jne    800f1a <strtol+0x93>
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	8a 00                	mov    (%eax),%al
  800f0a:	3c 30                	cmp    $0x30,%al
  800f0c:	75 0c                	jne    800f1a <strtol+0x93>
		s++, base = 8;
  800f0e:	ff 45 08             	incl   0x8(%ebp)
  800f11:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f18:	eb 0d                	jmp    800f27 <strtol+0xa0>
	else if (base == 0)
  800f1a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1e:	75 07                	jne    800f27 <strtol+0xa0>
		base = 10;
  800f20:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	3c 2f                	cmp    $0x2f,%al
  800f2e:	7e 19                	jle    800f49 <strtol+0xc2>
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	8a 00                	mov    (%eax),%al
  800f35:	3c 39                	cmp    $0x39,%al
  800f37:	7f 10                	jg     800f49 <strtol+0xc2>
			dig = *s - '0';
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	8a 00                	mov    (%eax),%al
  800f3e:	0f be c0             	movsbl %al,%eax
  800f41:	83 e8 30             	sub    $0x30,%eax
  800f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f47:	eb 42                	jmp    800f8b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	3c 60                	cmp    $0x60,%al
  800f50:	7e 19                	jle    800f6b <strtol+0xe4>
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8a 00                	mov    (%eax),%al
  800f57:	3c 7a                	cmp    $0x7a,%al
  800f59:	7f 10                	jg     800f6b <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	8a 00                	mov    (%eax),%al
  800f60:	0f be c0             	movsbl %al,%eax
  800f63:	83 e8 57             	sub    $0x57,%eax
  800f66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f69:	eb 20                	jmp    800f8b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	3c 40                	cmp    $0x40,%al
  800f72:	7e 39                	jle    800fad <strtol+0x126>
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	8a 00                	mov    (%eax),%al
  800f79:	3c 5a                	cmp    $0x5a,%al
  800f7b:	7f 30                	jg     800fad <strtol+0x126>
			dig = *s - 'A' + 10;
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	0f be c0             	movsbl %al,%eax
  800f85:	83 e8 37             	sub    $0x37,%eax
  800f88:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f8e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f91:	7d 19                	jge    800fac <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f93:	ff 45 08             	incl   0x8(%ebp)
  800f96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f99:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f9d:	89 c2                	mov    %eax,%edx
  800f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fa2:	01 d0                	add    %edx,%eax
  800fa4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800fa7:	e9 7b ff ff ff       	jmp    800f27 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800fac:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800fad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fb1:	74 08                	je     800fbb <strtol+0x134>
		*endptr = (char *) s;
  800fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800fbb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fbf:	74 07                	je     800fc8 <strtol+0x141>
  800fc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc4:	f7 d8                	neg    %eax
  800fc6:	eb 03                	jmp    800fcb <strtol+0x144>
  800fc8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fcb:	c9                   	leave  
  800fcc:	c3                   	ret    

00800fcd <ltostr>:

void
ltostr(long value, char *str)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
  800fd0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800fd3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800fda:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fe1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fe5:	79 13                	jns    800ffa <ltostr+0x2d>
	{
		neg = 1;
  800fe7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ff4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ff7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801002:	99                   	cltd   
  801003:	f7 f9                	idiv   %ecx
  801005:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801008:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80100b:	8d 50 01             	lea    0x1(%eax),%edx
  80100e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801011:	89 c2                	mov    %eax,%edx
  801013:	8b 45 0c             	mov    0xc(%ebp),%eax
  801016:	01 d0                	add    %edx,%eax
  801018:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80101b:	83 c2 30             	add    $0x30,%edx
  80101e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801020:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801023:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801028:	f7 e9                	imul   %ecx
  80102a:	c1 fa 02             	sar    $0x2,%edx
  80102d:	89 c8                	mov    %ecx,%eax
  80102f:	c1 f8 1f             	sar    $0x1f,%eax
  801032:	29 c2                	sub    %eax,%edx
  801034:	89 d0                	mov    %edx,%eax
  801036:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801039:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80103d:	75 bb                	jne    800ffa <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80103f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801046:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801049:	48                   	dec    %eax
  80104a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80104d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801051:	74 3d                	je     801090 <ltostr+0xc3>
		start = 1 ;
  801053:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80105a:	eb 34                	jmp    801090 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80105c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80105f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801062:	01 d0                	add    %edx,%eax
  801064:	8a 00                	mov    (%eax),%al
  801066:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801069:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80106c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106f:	01 c2                	add    %eax,%edx
  801071:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801074:	8b 45 0c             	mov    0xc(%ebp),%eax
  801077:	01 c8                	add    %ecx,%eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80107d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801080:	8b 45 0c             	mov    0xc(%ebp),%eax
  801083:	01 c2                	add    %eax,%edx
  801085:	8a 45 eb             	mov    -0x15(%ebp),%al
  801088:	88 02                	mov    %al,(%edx)
		start++ ;
  80108a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80108d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801090:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801093:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801096:	7c c4                	jl     80105c <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801098:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80109b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109e:	01 d0                	add    %edx,%eax
  8010a0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8010a3:	90                   	nop
  8010a4:	c9                   	leave  
  8010a5:	c3                   	ret    

008010a6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
  8010a9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8010ac:	ff 75 08             	pushl  0x8(%ebp)
  8010af:	e8 c4 f9 ff ff       	call   800a78 <strlen>
  8010b4:	83 c4 04             	add    $0x4,%esp
  8010b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8010ba:	ff 75 0c             	pushl  0xc(%ebp)
  8010bd:	e8 b6 f9 ff ff       	call   800a78 <strlen>
  8010c2:	83 c4 04             	add    $0x4,%esp
  8010c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8010c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010d6:	eb 17                	jmp    8010ef <strcconcat+0x49>
		final[s] = str1[s] ;
  8010d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010db:	8b 45 10             	mov    0x10(%ebp),%eax
  8010de:	01 c2                	add    %eax,%edx
  8010e0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	01 c8                	add    %ecx,%eax
  8010e8:	8a 00                	mov    (%eax),%al
  8010ea:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010ec:	ff 45 fc             	incl   -0x4(%ebp)
  8010ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010f5:	7c e1                	jl     8010d8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010f7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010fe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801105:	eb 1f                	jmp    801126 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801107:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80110a:	8d 50 01             	lea    0x1(%eax),%edx
  80110d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801110:	89 c2                	mov    %eax,%edx
  801112:	8b 45 10             	mov    0x10(%ebp),%eax
  801115:	01 c2                	add    %eax,%edx
  801117:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80111a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111d:	01 c8                	add    %ecx,%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801123:	ff 45 f8             	incl   -0x8(%ebp)
  801126:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801129:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80112c:	7c d9                	jl     801107 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80112e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801131:	8b 45 10             	mov    0x10(%ebp),%eax
  801134:	01 d0                	add    %edx,%eax
  801136:	c6 00 00             	movb   $0x0,(%eax)
}
  801139:	90                   	nop
  80113a:	c9                   	leave  
  80113b:	c3                   	ret    

0080113c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80113f:	8b 45 14             	mov    0x14(%ebp),%eax
  801142:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801148:	8b 45 14             	mov    0x14(%ebp),%eax
  80114b:	8b 00                	mov    (%eax),%eax
  80114d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801154:	8b 45 10             	mov    0x10(%ebp),%eax
  801157:	01 d0                	add    %edx,%eax
  801159:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80115f:	eb 0c                	jmp    80116d <strsplit+0x31>
			*string++ = 0;
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	8d 50 01             	lea    0x1(%eax),%edx
  801167:	89 55 08             	mov    %edx,0x8(%ebp)
  80116a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	84 c0                	test   %al,%al
  801174:	74 18                	je     80118e <strsplit+0x52>
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	0f be c0             	movsbl %al,%eax
  80117e:	50                   	push   %eax
  80117f:	ff 75 0c             	pushl  0xc(%ebp)
  801182:	e8 83 fa ff ff       	call   800c0a <strchr>
  801187:	83 c4 08             	add    $0x8,%esp
  80118a:	85 c0                	test   %eax,%eax
  80118c:	75 d3                	jne    801161 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	8a 00                	mov    (%eax),%al
  801193:	84 c0                	test   %al,%al
  801195:	74 5a                	je     8011f1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801197:	8b 45 14             	mov    0x14(%ebp),%eax
  80119a:	8b 00                	mov    (%eax),%eax
  80119c:	83 f8 0f             	cmp    $0xf,%eax
  80119f:	75 07                	jne    8011a8 <strsplit+0x6c>
		{
			return 0;
  8011a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a6:	eb 66                	jmp    80120e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8011a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ab:	8b 00                	mov    (%eax),%eax
  8011ad:	8d 48 01             	lea    0x1(%eax),%ecx
  8011b0:	8b 55 14             	mov    0x14(%ebp),%edx
  8011b3:	89 0a                	mov    %ecx,(%edx)
  8011b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bf:	01 c2                	add    %eax,%edx
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011c6:	eb 03                	jmp    8011cb <strsplit+0x8f>
			string++;
  8011c8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	8a 00                	mov    (%eax),%al
  8011d0:	84 c0                	test   %al,%al
  8011d2:	74 8b                	je     80115f <strsplit+0x23>
  8011d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d7:	8a 00                	mov    (%eax),%al
  8011d9:	0f be c0             	movsbl %al,%eax
  8011dc:	50                   	push   %eax
  8011dd:	ff 75 0c             	pushl  0xc(%ebp)
  8011e0:	e8 25 fa ff ff       	call   800c0a <strchr>
  8011e5:	83 c4 08             	add    $0x8,%esp
  8011e8:	85 c0                	test   %eax,%eax
  8011ea:	74 dc                	je     8011c8 <strsplit+0x8c>
			string++;
	}
  8011ec:	e9 6e ff ff ff       	jmp    80115f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011f1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f5:	8b 00                	mov    (%eax),%eax
  8011f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801201:	01 d0                	add    %edx,%eax
  801203:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801209:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80120e:	c9                   	leave  
  80120f:	c3                   	ret    

00801210 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
  801213:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80121c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801223:	eb 4a                	jmp    80126f <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801225:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	01 c2                	add    %eax,%edx
  80122d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801230:	8b 45 0c             	mov    0xc(%ebp),%eax
  801233:	01 c8                	add    %ecx,%eax
  801235:	8a 00                	mov    (%eax),%al
  801237:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801239:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80123c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123f:	01 d0                	add    %edx,%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	3c 40                	cmp    $0x40,%al
  801245:	7e 25                	jle    80126c <str2lower+0x5c>
  801247:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80124a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124d:	01 d0                	add    %edx,%eax
  80124f:	8a 00                	mov    (%eax),%al
  801251:	3c 5a                	cmp    $0x5a,%al
  801253:	7f 17                	jg     80126c <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801255:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	01 d0                	add    %edx,%eax
  80125d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801260:	8b 55 08             	mov    0x8(%ebp),%edx
  801263:	01 ca                	add    %ecx,%edx
  801265:	8a 12                	mov    (%edx),%dl
  801267:	83 c2 20             	add    $0x20,%edx
  80126a:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80126c:	ff 45 fc             	incl   -0x4(%ebp)
  80126f:	ff 75 0c             	pushl  0xc(%ebp)
  801272:	e8 01 f8 ff ff       	call   800a78 <strlen>
  801277:	83 c4 04             	add    $0x4,%esp
  80127a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80127d:	7f a6                	jg     801225 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80127f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801282:	c9                   	leave  
  801283:	c3                   	ret    

00801284 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
  801287:	57                   	push   %edi
  801288:	56                   	push   %esi
  801289:	53                   	push   %ebx
  80128a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	8b 55 0c             	mov    0xc(%ebp),%edx
  801293:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801296:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801299:	8b 7d 18             	mov    0x18(%ebp),%edi
  80129c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80129f:	cd 30                	int    $0x30
  8012a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8012a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012a7:	83 c4 10             	add    $0x10,%esp
  8012aa:	5b                   	pop    %ebx
  8012ab:	5e                   	pop    %esi
  8012ac:	5f                   	pop    %edi
  8012ad:	5d                   	pop    %ebp
  8012ae:	c3                   	ret    

008012af <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
  8012b2:	83 ec 04             	sub    $0x4,%esp
  8012b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8012bb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8012be:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	6a 00                	push   $0x0
  8012c7:	51                   	push   %ecx
  8012c8:	52                   	push   %edx
  8012c9:	ff 75 0c             	pushl  0xc(%ebp)
  8012cc:	50                   	push   %eax
  8012cd:	6a 00                	push   $0x0
  8012cf:	e8 b0 ff ff ff       	call   801284 <syscall>
  8012d4:	83 c4 18             	add    $0x18,%esp
}
  8012d7:	90                   	nop
  8012d8:	c9                   	leave  
  8012d9:	c3                   	ret    

008012da <sys_cgetc>:

int
sys_cgetc(void)
{
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012dd:	6a 00                	push   $0x0
  8012df:	6a 00                	push   $0x0
  8012e1:	6a 00                	push   $0x0
  8012e3:	6a 00                	push   $0x0
  8012e5:	6a 00                	push   $0x0
  8012e7:	6a 02                	push   $0x2
  8012e9:	e8 96 ff ff ff       	call   801284 <syscall>
  8012ee:	83 c4 18             	add    $0x18,%esp
}
  8012f1:	c9                   	leave  
  8012f2:	c3                   	ret    

008012f3 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8012f3:	55                   	push   %ebp
  8012f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8012f6:	6a 00                	push   $0x0
  8012f8:	6a 00                	push   $0x0
  8012fa:	6a 00                	push   $0x0
  8012fc:	6a 00                	push   $0x0
  8012fe:	6a 00                	push   $0x0
  801300:	6a 03                	push   $0x3
  801302:	e8 7d ff ff ff       	call   801284 <syscall>
  801307:	83 c4 18             	add    $0x18,%esp
}
  80130a:	90                   	nop
  80130b:	c9                   	leave  
  80130c:	c3                   	ret    

0080130d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801310:	6a 00                	push   $0x0
  801312:	6a 00                	push   $0x0
  801314:	6a 00                	push   $0x0
  801316:	6a 00                	push   $0x0
  801318:	6a 00                	push   $0x0
  80131a:	6a 04                	push   $0x4
  80131c:	e8 63 ff ff ff       	call   801284 <syscall>
  801321:	83 c4 18             	add    $0x18,%esp
}
  801324:	90                   	nop
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80132a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132d:	8b 45 08             	mov    0x8(%ebp),%eax
  801330:	6a 00                	push   $0x0
  801332:	6a 00                	push   $0x0
  801334:	6a 00                	push   $0x0
  801336:	52                   	push   %edx
  801337:	50                   	push   %eax
  801338:	6a 08                	push   $0x8
  80133a:	e8 45 ff ff ff       	call   801284 <syscall>
  80133f:	83 c4 18             	add    $0x18,%esp
}
  801342:	c9                   	leave  
  801343:	c3                   	ret    

00801344 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801344:	55                   	push   %ebp
  801345:	89 e5                	mov    %esp,%ebp
  801347:	56                   	push   %esi
  801348:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801349:	8b 75 18             	mov    0x18(%ebp),%esi
  80134c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80134f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801352:	8b 55 0c             	mov    0xc(%ebp),%edx
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	56                   	push   %esi
  801359:	53                   	push   %ebx
  80135a:	51                   	push   %ecx
  80135b:	52                   	push   %edx
  80135c:	50                   	push   %eax
  80135d:	6a 09                	push   $0x9
  80135f:	e8 20 ff ff ff       	call   801284 <syscall>
  801364:	83 c4 18             	add    $0x18,%esp
}
  801367:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80136a:	5b                   	pop    %ebx
  80136b:	5e                   	pop    %esi
  80136c:	5d                   	pop    %ebp
  80136d:	c3                   	ret    

0080136e <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801371:	6a 00                	push   $0x0
  801373:	6a 00                	push   $0x0
  801375:	6a 00                	push   $0x0
  801377:	6a 00                	push   $0x0
  801379:	ff 75 08             	pushl  0x8(%ebp)
  80137c:	6a 0a                	push   $0xa
  80137e:	e8 01 ff ff ff       	call   801284 <syscall>
  801383:	83 c4 18             	add    $0x18,%esp
}
  801386:	c9                   	leave  
  801387:	c3                   	ret    

00801388 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	ff 75 0c             	pushl  0xc(%ebp)
  801394:	ff 75 08             	pushl  0x8(%ebp)
  801397:	6a 0b                	push   $0xb
  801399:	e8 e6 fe ff ff       	call   801284 <syscall>
  80139e:	83 c4 18             	add    $0x18,%esp
}
  8013a1:	c9                   	leave  
  8013a2:	c3                   	ret    

008013a3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013a3:	55                   	push   %ebp
  8013a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 0c                	push   $0xc
  8013b2:	e8 cd fe ff ff       	call   801284 <syscall>
  8013b7:	83 c4 18             	add    $0x18,%esp
}
  8013ba:	c9                   	leave  
  8013bb:	c3                   	ret    

008013bc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 0d                	push   $0xd
  8013cb:	e8 b4 fe ff ff       	call   801284 <syscall>
  8013d0:	83 c4 18             	add    $0x18,%esp
}
  8013d3:	c9                   	leave  
  8013d4:	c3                   	ret    

008013d5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 0e                	push   $0xe
  8013e4:	e8 9b fe ff ff       	call   801284 <syscall>
  8013e9:	83 c4 18             	add    $0x18,%esp
}
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    

008013ee <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 0f                	push   $0xf
  8013fd:	e8 82 fe ff ff       	call   801284 <syscall>
  801402:	83 c4 18             	add    $0x18,%esp
}
  801405:	c9                   	leave  
  801406:	c3                   	ret    

00801407 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801407:	55                   	push   %ebp
  801408:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80140a:	6a 00                	push   $0x0
  80140c:	6a 00                	push   $0x0
  80140e:	6a 00                	push   $0x0
  801410:	6a 00                	push   $0x0
  801412:	ff 75 08             	pushl  0x8(%ebp)
  801415:	6a 10                	push   $0x10
  801417:	e8 68 fe ff ff       	call   801284 <syscall>
  80141c:	83 c4 18             	add    $0x18,%esp
}
  80141f:	c9                   	leave  
  801420:	c3                   	ret    

00801421 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801421:	55                   	push   %ebp
  801422:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 11                	push   $0x11
  801430:	e8 4f fe ff ff       	call   801284 <syscall>
  801435:	83 c4 18             	add    $0x18,%esp
}
  801438:	90                   	nop
  801439:	c9                   	leave  
  80143a:	c3                   	ret    

0080143b <sys_cputc>:

void
sys_cputc(const char c)
{
  80143b:	55                   	push   %ebp
  80143c:	89 e5                	mov    %esp,%ebp
  80143e:	83 ec 04             	sub    $0x4,%esp
  801441:	8b 45 08             	mov    0x8(%ebp),%eax
  801444:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801447:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80144b:	6a 00                	push   $0x0
  80144d:	6a 00                	push   $0x0
  80144f:	6a 00                	push   $0x0
  801451:	6a 00                	push   $0x0
  801453:	50                   	push   %eax
  801454:	6a 01                	push   $0x1
  801456:	e8 29 fe ff ff       	call   801284 <syscall>
  80145b:	83 c4 18             	add    $0x18,%esp
}
  80145e:	90                   	nop
  80145f:	c9                   	leave  
  801460:	c3                   	ret    

00801461 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801464:	6a 00                	push   $0x0
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	6a 00                	push   $0x0
  80146c:	6a 00                	push   $0x0
  80146e:	6a 14                	push   $0x14
  801470:	e8 0f fe ff ff       	call   801284 <syscall>
  801475:	83 c4 18             	add    $0x18,%esp
}
  801478:	90                   	nop
  801479:	c9                   	leave  
  80147a:	c3                   	ret    

0080147b <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
  80147e:	83 ec 04             	sub    $0x4,%esp
  801481:	8b 45 10             	mov    0x10(%ebp),%eax
  801484:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801487:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80148a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	6a 00                	push   $0x0
  801493:	51                   	push   %ecx
  801494:	52                   	push   %edx
  801495:	ff 75 0c             	pushl  0xc(%ebp)
  801498:	50                   	push   %eax
  801499:	6a 15                	push   $0x15
  80149b:	e8 e4 fd ff ff       	call   801284 <syscall>
  8014a0:	83 c4 18             	add    $0x18,%esp
}
  8014a3:	c9                   	leave  
  8014a4:	c3                   	ret    

008014a5 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8014a5:	55                   	push   %ebp
  8014a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	6a 00                	push   $0x0
  8014b0:	6a 00                	push   $0x0
  8014b2:	6a 00                	push   $0x0
  8014b4:	52                   	push   %edx
  8014b5:	50                   	push   %eax
  8014b6:	6a 16                	push   $0x16
  8014b8:	e8 c7 fd ff ff       	call   801284 <syscall>
  8014bd:	83 c4 18             	add    $0x18,%esp
}
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    

008014c2 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8014c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	51                   	push   %ecx
  8014d3:	52                   	push   %edx
  8014d4:	50                   	push   %eax
  8014d5:	6a 17                	push   $0x17
  8014d7:	e8 a8 fd ff ff       	call   801284 <syscall>
  8014dc:	83 c4 18             	add    $0x18,%esp
}
  8014df:	c9                   	leave  
  8014e0:	c3                   	ret    

008014e1 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8014e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	52                   	push   %edx
  8014f1:	50                   	push   %eax
  8014f2:	6a 18                	push   $0x18
  8014f4:	e8 8b fd ff ff       	call   801284 <syscall>
  8014f9:	83 c4 18             	add    $0x18,%esp
}
  8014fc:	c9                   	leave  
  8014fd:	c3                   	ret    

008014fe <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	6a 00                	push   $0x0
  801506:	ff 75 14             	pushl  0x14(%ebp)
  801509:	ff 75 10             	pushl  0x10(%ebp)
  80150c:	ff 75 0c             	pushl  0xc(%ebp)
  80150f:	50                   	push   %eax
  801510:	6a 19                	push   $0x19
  801512:	e8 6d fd ff ff       	call   801284 <syscall>
  801517:	83 c4 18             	add    $0x18,%esp
}
  80151a:	c9                   	leave  
  80151b:	c3                   	ret    

0080151c <sys_run_env>:

void sys_run_env(int32 envId)
{
  80151c:	55                   	push   %ebp
  80151d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	50                   	push   %eax
  80152b:	6a 1a                	push   $0x1a
  80152d:	e8 52 fd ff ff       	call   801284 <syscall>
  801532:	83 c4 18             	add    $0x18,%esp
}
  801535:	90                   	nop
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	50                   	push   %eax
  801547:	6a 1b                	push   $0x1b
  801549:	e8 36 fd ff ff       	call   801284 <syscall>
  80154e:	83 c4 18             	add    $0x18,%esp
}
  801551:	c9                   	leave  
  801552:	c3                   	ret    

00801553 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	6a 00                	push   $0x0
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	6a 05                	push   $0x5
  801562:	e8 1d fd ff ff       	call   801284 <syscall>
  801567:	83 c4 18             	add    $0x18,%esp
}
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    

0080156c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 06                	push   $0x6
  80157b:	e8 04 fd ff ff       	call   801284 <syscall>
  801580:	83 c4 18             	add    $0x18,%esp
}
  801583:	c9                   	leave  
  801584:	c3                   	ret    

00801585 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 07                	push   $0x7
  801594:	e8 eb fc ff ff       	call   801284 <syscall>
  801599:	83 c4 18             	add    $0x18,%esp
}
  80159c:	c9                   	leave  
  80159d:	c3                   	ret    

0080159e <sys_exit_env>:


void sys_exit_env(void)
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 1c                	push   $0x1c
  8015ad:	e8 d2 fc ff ff       	call   801284 <syscall>
  8015b2:	83 c4 18             	add    $0x18,%esp
}
  8015b5:	90                   	nop
  8015b6:	c9                   	leave  
  8015b7:	c3                   	ret    

008015b8 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8015be:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015c1:	8d 50 04             	lea    0x4(%eax),%edx
  8015c4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	52                   	push   %edx
  8015ce:	50                   	push   %eax
  8015cf:	6a 1d                	push   $0x1d
  8015d1:	e8 ae fc ff ff       	call   801284 <syscall>
  8015d6:	83 c4 18             	add    $0x18,%esp
	return result;
  8015d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e2:	89 01                	mov    %eax,(%ecx)
  8015e4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	c9                   	leave  
  8015eb:	c2 04 00             	ret    $0x4

008015ee <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	ff 75 10             	pushl  0x10(%ebp)
  8015f8:	ff 75 0c             	pushl  0xc(%ebp)
  8015fb:	ff 75 08             	pushl  0x8(%ebp)
  8015fe:	6a 13                	push   $0x13
  801600:	e8 7f fc ff ff       	call   801284 <syscall>
  801605:	83 c4 18             	add    $0x18,%esp
	return ;
  801608:	90                   	nop
}
  801609:	c9                   	leave  
  80160a:	c3                   	ret    

0080160b <sys_rcr2>:
uint32 sys_rcr2()
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 1e                	push   $0x1e
  80161a:	e8 65 fc ff ff       	call   801284 <syscall>
  80161f:	83 c4 18             	add    $0x18,%esp
}
  801622:	c9                   	leave  
  801623:	c3                   	ret    

00801624 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
  801627:	83 ec 04             	sub    $0x4,%esp
  80162a:	8b 45 08             	mov    0x8(%ebp),%eax
  80162d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801630:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	50                   	push   %eax
  80163d:	6a 1f                	push   $0x1f
  80163f:	e8 40 fc ff ff       	call   801284 <syscall>
  801644:	83 c4 18             	add    $0x18,%esp
	return ;
  801647:	90                   	nop
}
  801648:	c9                   	leave  
  801649:	c3                   	ret    

0080164a <rsttst>:
void rsttst()
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 21                	push   $0x21
  801659:	e8 26 fc ff ff       	call   801284 <syscall>
  80165e:	83 c4 18             	add    $0x18,%esp
	return ;
  801661:	90                   	nop
}
  801662:	c9                   	leave  
  801663:	c3                   	ret    

00801664 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
  801667:	83 ec 04             	sub    $0x4,%esp
  80166a:	8b 45 14             	mov    0x14(%ebp),%eax
  80166d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801670:	8b 55 18             	mov    0x18(%ebp),%edx
  801673:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801677:	52                   	push   %edx
  801678:	50                   	push   %eax
  801679:	ff 75 10             	pushl  0x10(%ebp)
  80167c:	ff 75 0c             	pushl  0xc(%ebp)
  80167f:	ff 75 08             	pushl  0x8(%ebp)
  801682:	6a 20                	push   $0x20
  801684:	e8 fb fb ff ff       	call   801284 <syscall>
  801689:	83 c4 18             	add    $0x18,%esp
	return ;
  80168c:	90                   	nop
}
  80168d:	c9                   	leave  
  80168e:	c3                   	ret    

0080168f <chktst>:
void chktst(uint32 n)
{
  80168f:	55                   	push   %ebp
  801690:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	ff 75 08             	pushl  0x8(%ebp)
  80169d:	6a 22                	push   $0x22
  80169f:	e8 e0 fb ff ff       	call   801284 <syscall>
  8016a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8016a7:	90                   	nop
}
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    

008016aa <inctst>:

void inctst()
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 23                	push   $0x23
  8016b9:	e8 c6 fb ff ff       	call   801284 <syscall>
  8016be:	83 c4 18             	add    $0x18,%esp
	return ;
  8016c1:	90                   	nop
}
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    

008016c4 <gettst>:
uint32 gettst()
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 24                	push   $0x24
  8016d3:	e8 ac fb ff ff       	call   801284 <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
}
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 25                	push   $0x25
  8016ec:	e8 93 fb ff ff       	call   801284 <syscall>
  8016f1:	83 c4 18             	add    $0x18,%esp
  8016f4:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8016f9:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8016fe:	c9                   	leave  
  8016ff:	c3                   	ret    

00801700 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	ff 75 08             	pushl  0x8(%ebp)
  801716:	6a 26                	push   $0x26
  801718:	e8 67 fb ff ff       	call   801284 <syscall>
  80171d:	83 c4 18             	add    $0x18,%esp
	return ;
  801720:	90                   	nop
}
  801721:	c9                   	leave  
  801722:	c3                   	ret    

00801723 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801727:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80172a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80172d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801730:	8b 45 08             	mov    0x8(%ebp),%eax
  801733:	6a 00                	push   $0x0
  801735:	53                   	push   %ebx
  801736:	51                   	push   %ecx
  801737:	52                   	push   %edx
  801738:	50                   	push   %eax
  801739:	6a 27                	push   $0x27
  80173b:	e8 44 fb ff ff       	call   801284 <syscall>
  801740:	83 c4 18             	add    $0x18,%esp
}
  801743:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801746:	c9                   	leave  
  801747:	c3                   	ret    

00801748 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80174b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	52                   	push   %edx
  801758:	50                   	push   %eax
  801759:	6a 28                	push   $0x28
  80175b:	e8 24 fb ff ff       	call   801284 <syscall>
  801760:	83 c4 18             	add    $0x18,%esp
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801768:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80176b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
  801771:	6a 00                	push   $0x0
  801773:	51                   	push   %ecx
  801774:	ff 75 10             	pushl  0x10(%ebp)
  801777:	52                   	push   %edx
  801778:	50                   	push   %eax
  801779:	6a 29                	push   $0x29
  80177b:	e8 04 fb ff ff       	call   801284 <syscall>
  801780:	83 c4 18             	add    $0x18,%esp
}
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	ff 75 10             	pushl  0x10(%ebp)
  80178f:	ff 75 0c             	pushl  0xc(%ebp)
  801792:	ff 75 08             	pushl  0x8(%ebp)
  801795:	6a 12                	push   $0x12
  801797:	e8 e8 fa ff ff       	call   801284 <syscall>
  80179c:	83 c4 18             	add    $0x18,%esp
	return ;
  80179f:	90                   	nop
}
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8017a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	52                   	push   %edx
  8017b2:	50                   	push   %eax
  8017b3:	6a 2a                	push   $0x2a
  8017b5:	e8 ca fa ff ff       	call   801284 <syscall>
  8017ba:	83 c4 18             	add    $0x18,%esp
	return;
  8017bd:	90                   	nop
}
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 2b                	push   $0x2b
  8017cf:	e8 b0 fa ff ff       	call   801284 <syscall>
  8017d4:	83 c4 18             	add    $0x18,%esp
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	ff 75 0c             	pushl  0xc(%ebp)
  8017e5:	ff 75 08             	pushl  0x8(%ebp)
  8017e8:	6a 2d                	push   $0x2d
  8017ea:	e8 95 fa ff ff       	call   801284 <syscall>
  8017ef:	83 c4 18             	add    $0x18,%esp
	return;
  8017f2:	90                   	nop
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	ff 75 0c             	pushl  0xc(%ebp)
  801801:	ff 75 08             	pushl  0x8(%ebp)
  801804:	6a 2c                	push   $0x2c
  801806:	e8 79 fa ff ff       	call   801284 <syscall>
  80180b:	83 c4 18             	add    $0x18,%esp
	return ;
  80180e:	90                   	nop
}
  80180f:	c9                   	leave  
  801810:	c3                   	ret    

00801811 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
  801814:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801817:	83 ec 04             	sub    $0x4,%esp
  80181a:	68 e8 21 80 00       	push   $0x8021e8
  80181f:	68 25 01 00 00       	push   $0x125
  801824:	68 1b 22 80 00       	push   $0x80221b
  801829:	e8 00 00 00 00       	call   80182e <_panic>

0080182e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
  801831:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801834:	8d 45 10             	lea    0x10(%ebp),%eax
  801837:	83 c0 04             	add    $0x4,%eax
  80183a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80183d:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801842:	85 c0                	test   %eax,%eax
  801844:	74 16                	je     80185c <_panic+0x2e>
		cprintf("%s: ", argv0);
  801846:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  80184b:	83 ec 08             	sub    $0x8,%esp
  80184e:	50                   	push   %eax
  80184f:	68 2c 22 80 00       	push   $0x80222c
  801854:	e8 46 eb ff ff       	call   80039f <cprintf>
  801859:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80185c:	a1 04 30 80 00       	mov    0x803004,%eax
  801861:	83 ec 0c             	sub    $0xc,%esp
  801864:	ff 75 0c             	pushl  0xc(%ebp)
  801867:	ff 75 08             	pushl  0x8(%ebp)
  80186a:	50                   	push   %eax
  80186b:	68 34 22 80 00       	push   $0x802234
  801870:	6a 74                	push   $0x74
  801872:	e8 55 eb ff ff       	call   8003cc <cprintf_colored>
  801877:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80187a:	8b 45 10             	mov    0x10(%ebp),%eax
  80187d:	83 ec 08             	sub    $0x8,%esp
  801880:	ff 75 f4             	pushl  -0xc(%ebp)
  801883:	50                   	push   %eax
  801884:	e8 a7 ea ff ff       	call   800330 <vcprintf>
  801889:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80188c:	83 ec 08             	sub    $0x8,%esp
  80188f:	6a 00                	push   $0x0
  801891:	68 5c 22 80 00       	push   $0x80225c
  801896:	e8 95 ea ff ff       	call   800330 <vcprintf>
  80189b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80189e:	e8 0e ea ff ff       	call   8002b1 <exit>

	// should not return here
	while (1) ;
  8018a3:	eb fe                	jmp    8018a3 <_panic+0x75>

008018a5 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
  8018a8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8018ab:	a1 20 30 80 00       	mov    0x803020,%eax
  8018b0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8018b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b9:	39 c2                	cmp    %eax,%edx
  8018bb:	74 14                	je     8018d1 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8018bd:	83 ec 04             	sub    $0x4,%esp
  8018c0:	68 60 22 80 00       	push   $0x802260
  8018c5:	6a 26                	push   $0x26
  8018c7:	68 ac 22 80 00       	push   $0x8022ac
  8018cc:	e8 5d ff ff ff       	call   80182e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8018d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8018d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8018df:	e9 c5 00 00 00       	jmp    8019a9 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8018e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	01 d0                	add    %edx,%eax
  8018f3:	8b 00                	mov    (%eax),%eax
  8018f5:	85 c0                	test   %eax,%eax
  8018f7:	75 08                	jne    801901 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8018f9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8018fc:	e9 a5 00 00 00       	jmp    8019a6 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801901:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801908:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80190f:	eb 69                	jmp    80197a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801911:	a1 20 30 80 00       	mov    0x803020,%eax
  801916:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80191c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80191f:	89 d0                	mov    %edx,%eax
  801921:	01 c0                	add    %eax,%eax
  801923:	01 d0                	add    %edx,%eax
  801925:	c1 e0 03             	shl    $0x3,%eax
  801928:	01 c8                	add    %ecx,%eax
  80192a:	8a 40 04             	mov    0x4(%eax),%al
  80192d:	84 c0                	test   %al,%al
  80192f:	75 46                	jne    801977 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801931:	a1 20 30 80 00       	mov    0x803020,%eax
  801936:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80193c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80193f:	89 d0                	mov    %edx,%eax
  801941:	01 c0                	add    %eax,%eax
  801943:	01 d0                	add    %edx,%eax
  801945:	c1 e0 03             	shl    $0x3,%eax
  801948:	01 c8                	add    %ecx,%eax
  80194a:	8b 00                	mov    (%eax),%eax
  80194c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80194f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801952:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801957:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801959:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80195c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801963:	8b 45 08             	mov    0x8(%ebp),%eax
  801966:	01 c8                	add    %ecx,%eax
  801968:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80196a:	39 c2                	cmp    %eax,%edx
  80196c:	75 09                	jne    801977 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80196e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801975:	eb 15                	jmp    80198c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801977:	ff 45 e8             	incl   -0x18(%ebp)
  80197a:	a1 20 30 80 00       	mov    0x803020,%eax
  80197f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801985:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801988:	39 c2                	cmp    %eax,%edx
  80198a:	77 85                	ja     801911 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80198c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801990:	75 14                	jne    8019a6 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801992:	83 ec 04             	sub    $0x4,%esp
  801995:	68 b8 22 80 00       	push   $0x8022b8
  80199a:	6a 3a                	push   $0x3a
  80199c:	68 ac 22 80 00       	push   $0x8022ac
  8019a1:	e8 88 fe ff ff       	call   80182e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8019a6:	ff 45 f0             	incl   -0x10(%ebp)
  8019a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ac:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8019af:	0f 8c 2f ff ff ff    	jl     8018e4 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8019b5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019bc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8019c3:	eb 26                	jmp    8019eb <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8019c5:	a1 20 30 80 00       	mov    0x803020,%eax
  8019ca:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8019d0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019d3:	89 d0                	mov    %edx,%eax
  8019d5:	01 c0                	add    %eax,%eax
  8019d7:	01 d0                	add    %edx,%eax
  8019d9:	c1 e0 03             	shl    $0x3,%eax
  8019dc:	01 c8                	add    %ecx,%eax
  8019de:	8a 40 04             	mov    0x4(%eax),%al
  8019e1:	3c 01                	cmp    $0x1,%al
  8019e3:	75 03                	jne    8019e8 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8019e5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019e8:	ff 45 e0             	incl   -0x20(%ebp)
  8019eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8019f0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8019f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019f9:	39 c2                	cmp    %eax,%edx
  8019fb:	77 c8                	ja     8019c5 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8019fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a00:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801a03:	74 14                	je     801a19 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801a05:	83 ec 04             	sub    $0x4,%esp
  801a08:	68 0c 23 80 00       	push   $0x80230c
  801a0d:	6a 44                	push   $0x44
  801a0f:	68 ac 22 80 00       	push   $0x8022ac
  801a14:	e8 15 fe ff ff       	call   80182e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801a19:	90                   	nop
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <__udivdi3>:
  801a1c:	55                   	push   %ebp
  801a1d:	57                   	push   %edi
  801a1e:	56                   	push   %esi
  801a1f:	53                   	push   %ebx
  801a20:	83 ec 1c             	sub    $0x1c,%esp
  801a23:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a27:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a2b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a2f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a33:	89 ca                	mov    %ecx,%edx
  801a35:	89 f8                	mov    %edi,%eax
  801a37:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a3b:	85 f6                	test   %esi,%esi
  801a3d:	75 2d                	jne    801a6c <__udivdi3+0x50>
  801a3f:	39 cf                	cmp    %ecx,%edi
  801a41:	77 65                	ja     801aa8 <__udivdi3+0x8c>
  801a43:	89 fd                	mov    %edi,%ebp
  801a45:	85 ff                	test   %edi,%edi
  801a47:	75 0b                	jne    801a54 <__udivdi3+0x38>
  801a49:	b8 01 00 00 00       	mov    $0x1,%eax
  801a4e:	31 d2                	xor    %edx,%edx
  801a50:	f7 f7                	div    %edi
  801a52:	89 c5                	mov    %eax,%ebp
  801a54:	31 d2                	xor    %edx,%edx
  801a56:	89 c8                	mov    %ecx,%eax
  801a58:	f7 f5                	div    %ebp
  801a5a:	89 c1                	mov    %eax,%ecx
  801a5c:	89 d8                	mov    %ebx,%eax
  801a5e:	f7 f5                	div    %ebp
  801a60:	89 cf                	mov    %ecx,%edi
  801a62:	89 fa                	mov    %edi,%edx
  801a64:	83 c4 1c             	add    $0x1c,%esp
  801a67:	5b                   	pop    %ebx
  801a68:	5e                   	pop    %esi
  801a69:	5f                   	pop    %edi
  801a6a:	5d                   	pop    %ebp
  801a6b:	c3                   	ret    
  801a6c:	39 ce                	cmp    %ecx,%esi
  801a6e:	77 28                	ja     801a98 <__udivdi3+0x7c>
  801a70:	0f bd fe             	bsr    %esi,%edi
  801a73:	83 f7 1f             	xor    $0x1f,%edi
  801a76:	75 40                	jne    801ab8 <__udivdi3+0x9c>
  801a78:	39 ce                	cmp    %ecx,%esi
  801a7a:	72 0a                	jb     801a86 <__udivdi3+0x6a>
  801a7c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a80:	0f 87 9e 00 00 00    	ja     801b24 <__udivdi3+0x108>
  801a86:	b8 01 00 00 00       	mov    $0x1,%eax
  801a8b:	89 fa                	mov    %edi,%edx
  801a8d:	83 c4 1c             	add    $0x1c,%esp
  801a90:	5b                   	pop    %ebx
  801a91:	5e                   	pop    %esi
  801a92:	5f                   	pop    %edi
  801a93:	5d                   	pop    %ebp
  801a94:	c3                   	ret    
  801a95:	8d 76 00             	lea    0x0(%esi),%esi
  801a98:	31 ff                	xor    %edi,%edi
  801a9a:	31 c0                	xor    %eax,%eax
  801a9c:	89 fa                	mov    %edi,%edx
  801a9e:	83 c4 1c             	add    $0x1c,%esp
  801aa1:	5b                   	pop    %ebx
  801aa2:	5e                   	pop    %esi
  801aa3:	5f                   	pop    %edi
  801aa4:	5d                   	pop    %ebp
  801aa5:	c3                   	ret    
  801aa6:	66 90                	xchg   %ax,%ax
  801aa8:	89 d8                	mov    %ebx,%eax
  801aaa:	f7 f7                	div    %edi
  801aac:	31 ff                	xor    %edi,%edi
  801aae:	89 fa                	mov    %edi,%edx
  801ab0:	83 c4 1c             	add    $0x1c,%esp
  801ab3:	5b                   	pop    %ebx
  801ab4:	5e                   	pop    %esi
  801ab5:	5f                   	pop    %edi
  801ab6:	5d                   	pop    %ebp
  801ab7:	c3                   	ret    
  801ab8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801abd:	89 eb                	mov    %ebp,%ebx
  801abf:	29 fb                	sub    %edi,%ebx
  801ac1:	89 f9                	mov    %edi,%ecx
  801ac3:	d3 e6                	shl    %cl,%esi
  801ac5:	89 c5                	mov    %eax,%ebp
  801ac7:	88 d9                	mov    %bl,%cl
  801ac9:	d3 ed                	shr    %cl,%ebp
  801acb:	89 e9                	mov    %ebp,%ecx
  801acd:	09 f1                	or     %esi,%ecx
  801acf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ad3:	89 f9                	mov    %edi,%ecx
  801ad5:	d3 e0                	shl    %cl,%eax
  801ad7:	89 c5                	mov    %eax,%ebp
  801ad9:	89 d6                	mov    %edx,%esi
  801adb:	88 d9                	mov    %bl,%cl
  801add:	d3 ee                	shr    %cl,%esi
  801adf:	89 f9                	mov    %edi,%ecx
  801ae1:	d3 e2                	shl    %cl,%edx
  801ae3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ae7:	88 d9                	mov    %bl,%cl
  801ae9:	d3 e8                	shr    %cl,%eax
  801aeb:	09 c2                	or     %eax,%edx
  801aed:	89 d0                	mov    %edx,%eax
  801aef:	89 f2                	mov    %esi,%edx
  801af1:	f7 74 24 0c          	divl   0xc(%esp)
  801af5:	89 d6                	mov    %edx,%esi
  801af7:	89 c3                	mov    %eax,%ebx
  801af9:	f7 e5                	mul    %ebp
  801afb:	39 d6                	cmp    %edx,%esi
  801afd:	72 19                	jb     801b18 <__udivdi3+0xfc>
  801aff:	74 0b                	je     801b0c <__udivdi3+0xf0>
  801b01:	89 d8                	mov    %ebx,%eax
  801b03:	31 ff                	xor    %edi,%edi
  801b05:	e9 58 ff ff ff       	jmp    801a62 <__udivdi3+0x46>
  801b0a:	66 90                	xchg   %ax,%ax
  801b0c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b10:	89 f9                	mov    %edi,%ecx
  801b12:	d3 e2                	shl    %cl,%edx
  801b14:	39 c2                	cmp    %eax,%edx
  801b16:	73 e9                	jae    801b01 <__udivdi3+0xe5>
  801b18:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b1b:	31 ff                	xor    %edi,%edi
  801b1d:	e9 40 ff ff ff       	jmp    801a62 <__udivdi3+0x46>
  801b22:	66 90                	xchg   %ax,%ax
  801b24:	31 c0                	xor    %eax,%eax
  801b26:	e9 37 ff ff ff       	jmp    801a62 <__udivdi3+0x46>
  801b2b:	90                   	nop

00801b2c <__umoddi3>:
  801b2c:	55                   	push   %ebp
  801b2d:	57                   	push   %edi
  801b2e:	56                   	push   %esi
  801b2f:	53                   	push   %ebx
  801b30:	83 ec 1c             	sub    $0x1c,%esp
  801b33:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b37:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b3b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b3f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b43:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b47:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b4b:	89 f3                	mov    %esi,%ebx
  801b4d:	89 fa                	mov    %edi,%edx
  801b4f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b53:	89 34 24             	mov    %esi,(%esp)
  801b56:	85 c0                	test   %eax,%eax
  801b58:	75 1a                	jne    801b74 <__umoddi3+0x48>
  801b5a:	39 f7                	cmp    %esi,%edi
  801b5c:	0f 86 a2 00 00 00    	jbe    801c04 <__umoddi3+0xd8>
  801b62:	89 c8                	mov    %ecx,%eax
  801b64:	89 f2                	mov    %esi,%edx
  801b66:	f7 f7                	div    %edi
  801b68:	89 d0                	mov    %edx,%eax
  801b6a:	31 d2                	xor    %edx,%edx
  801b6c:	83 c4 1c             	add    $0x1c,%esp
  801b6f:	5b                   	pop    %ebx
  801b70:	5e                   	pop    %esi
  801b71:	5f                   	pop    %edi
  801b72:	5d                   	pop    %ebp
  801b73:	c3                   	ret    
  801b74:	39 f0                	cmp    %esi,%eax
  801b76:	0f 87 ac 00 00 00    	ja     801c28 <__umoddi3+0xfc>
  801b7c:	0f bd e8             	bsr    %eax,%ebp
  801b7f:	83 f5 1f             	xor    $0x1f,%ebp
  801b82:	0f 84 ac 00 00 00    	je     801c34 <__umoddi3+0x108>
  801b88:	bf 20 00 00 00       	mov    $0x20,%edi
  801b8d:	29 ef                	sub    %ebp,%edi
  801b8f:	89 fe                	mov    %edi,%esi
  801b91:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b95:	89 e9                	mov    %ebp,%ecx
  801b97:	d3 e0                	shl    %cl,%eax
  801b99:	89 d7                	mov    %edx,%edi
  801b9b:	89 f1                	mov    %esi,%ecx
  801b9d:	d3 ef                	shr    %cl,%edi
  801b9f:	09 c7                	or     %eax,%edi
  801ba1:	89 e9                	mov    %ebp,%ecx
  801ba3:	d3 e2                	shl    %cl,%edx
  801ba5:	89 14 24             	mov    %edx,(%esp)
  801ba8:	89 d8                	mov    %ebx,%eax
  801baa:	d3 e0                	shl    %cl,%eax
  801bac:	89 c2                	mov    %eax,%edx
  801bae:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bb2:	d3 e0                	shl    %cl,%eax
  801bb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bbc:	89 f1                	mov    %esi,%ecx
  801bbe:	d3 e8                	shr    %cl,%eax
  801bc0:	09 d0                	or     %edx,%eax
  801bc2:	d3 eb                	shr    %cl,%ebx
  801bc4:	89 da                	mov    %ebx,%edx
  801bc6:	f7 f7                	div    %edi
  801bc8:	89 d3                	mov    %edx,%ebx
  801bca:	f7 24 24             	mull   (%esp)
  801bcd:	89 c6                	mov    %eax,%esi
  801bcf:	89 d1                	mov    %edx,%ecx
  801bd1:	39 d3                	cmp    %edx,%ebx
  801bd3:	0f 82 87 00 00 00    	jb     801c60 <__umoddi3+0x134>
  801bd9:	0f 84 91 00 00 00    	je     801c70 <__umoddi3+0x144>
  801bdf:	8b 54 24 04          	mov    0x4(%esp),%edx
  801be3:	29 f2                	sub    %esi,%edx
  801be5:	19 cb                	sbb    %ecx,%ebx
  801be7:	89 d8                	mov    %ebx,%eax
  801be9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bed:	d3 e0                	shl    %cl,%eax
  801bef:	89 e9                	mov    %ebp,%ecx
  801bf1:	d3 ea                	shr    %cl,%edx
  801bf3:	09 d0                	or     %edx,%eax
  801bf5:	89 e9                	mov    %ebp,%ecx
  801bf7:	d3 eb                	shr    %cl,%ebx
  801bf9:	89 da                	mov    %ebx,%edx
  801bfb:	83 c4 1c             	add    $0x1c,%esp
  801bfe:	5b                   	pop    %ebx
  801bff:	5e                   	pop    %esi
  801c00:	5f                   	pop    %edi
  801c01:	5d                   	pop    %ebp
  801c02:	c3                   	ret    
  801c03:	90                   	nop
  801c04:	89 fd                	mov    %edi,%ebp
  801c06:	85 ff                	test   %edi,%edi
  801c08:	75 0b                	jne    801c15 <__umoddi3+0xe9>
  801c0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0f:	31 d2                	xor    %edx,%edx
  801c11:	f7 f7                	div    %edi
  801c13:	89 c5                	mov    %eax,%ebp
  801c15:	89 f0                	mov    %esi,%eax
  801c17:	31 d2                	xor    %edx,%edx
  801c19:	f7 f5                	div    %ebp
  801c1b:	89 c8                	mov    %ecx,%eax
  801c1d:	f7 f5                	div    %ebp
  801c1f:	89 d0                	mov    %edx,%eax
  801c21:	e9 44 ff ff ff       	jmp    801b6a <__umoddi3+0x3e>
  801c26:	66 90                	xchg   %ax,%ax
  801c28:	89 c8                	mov    %ecx,%eax
  801c2a:	89 f2                	mov    %esi,%edx
  801c2c:	83 c4 1c             	add    $0x1c,%esp
  801c2f:	5b                   	pop    %ebx
  801c30:	5e                   	pop    %esi
  801c31:	5f                   	pop    %edi
  801c32:	5d                   	pop    %ebp
  801c33:	c3                   	ret    
  801c34:	3b 04 24             	cmp    (%esp),%eax
  801c37:	72 06                	jb     801c3f <__umoddi3+0x113>
  801c39:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c3d:	77 0f                	ja     801c4e <__umoddi3+0x122>
  801c3f:	89 f2                	mov    %esi,%edx
  801c41:	29 f9                	sub    %edi,%ecx
  801c43:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c47:	89 14 24             	mov    %edx,(%esp)
  801c4a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c4e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c52:	8b 14 24             	mov    (%esp),%edx
  801c55:	83 c4 1c             	add    $0x1c,%esp
  801c58:	5b                   	pop    %ebx
  801c59:	5e                   	pop    %esi
  801c5a:	5f                   	pop    %edi
  801c5b:	5d                   	pop    %ebp
  801c5c:	c3                   	ret    
  801c5d:	8d 76 00             	lea    0x0(%esi),%esi
  801c60:	2b 04 24             	sub    (%esp),%eax
  801c63:	19 fa                	sbb    %edi,%edx
  801c65:	89 d1                	mov    %edx,%ecx
  801c67:	89 c6                	mov    %eax,%esi
  801c69:	e9 71 ff ff ff       	jmp    801bdf <__umoddi3+0xb3>
  801c6e:	66 90                	xchg   %ax,%ax
  801c70:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c74:	72 ea                	jb     801c60 <__umoddi3+0x134>
  801c76:	89 d9                	mov    %ebx,%ecx
  801c78:	e9 62 ff ff ff       	jmp    801bdf <__umoddi3+0xb3>

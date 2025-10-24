
obj/user/fos_factorial:     file format elf32-i386


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
  800031:	e8 be 00 00 00       	call   8000f4 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int64 factorial(int n);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	atomic_readline("Please enter a number:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 c0 1e 80 00       	push   $0x801ec0
  800057:	e8 00 0b 00 00       	call   800b5c <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 02 10 00 00       	call   801074 <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int64 res = factorial(i1) ;
  800078:	83 ec 0c             	sub    $0xc,%esp
  80007b:	ff 75 f4             	pushl  -0xc(%ebp)
  80007e:	e8 22 00 00 00       	call   8000a5 <factorial>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800089:	89 55 ec             	mov    %edx,-0x14(%ebp)

	atomic_cprintf("Factorial %d = %lld\n",i1, res);
  80008c:	ff 75 ec             	pushl  -0x14(%ebp)
  80008f:	ff 75 e8             	pushl  -0x18(%ebp)
  800092:	ff 75 f4             	pushl  -0xc(%ebp)
  800095:	68 d7 1e 80 00       	push   $0x801ed7
  80009a:	e8 57 03 00 00       	call   8003f6 <atomic_cprintf>
  80009f:	83 c4 10             	add    $0x10,%esp
	return;
  8000a2:	90                   	nop
}
  8000a3:	c9                   	leave  
  8000a4:	c3                   	ret    

008000a5 <factorial>:


int64 factorial(int n)
{
  8000a5:	55                   	push   %ebp
  8000a6:	89 e5                	mov    %esp,%ebp
  8000a8:	57                   	push   %edi
  8000a9:	56                   	push   %esi
  8000aa:	53                   	push   %ebx
  8000ab:	83 ec 0c             	sub    $0xc,%esp
	if (n <= 1)
  8000ae:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000b2:	7f 0c                	jg     8000c0 <factorial+0x1b>
		return 1 ;
  8000b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000be:	eb 2c                	jmp    8000ec <factorial+0x47>
	return n * factorial(n-1) ;
  8000c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8000c3:	89 c3                	mov    %eax,%ebx
  8000c5:	89 c6                	mov    %eax,%esi
  8000c7:	c1 fe 1f             	sar    $0x1f,%esi
  8000ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8000cd:	48                   	dec    %eax
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	50                   	push   %eax
  8000d2:	e8 ce ff ff ff       	call   8000a5 <factorial>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	89 f7                	mov    %esi,%edi
  8000dc:	0f af f8             	imul   %eax,%edi
  8000df:	89 d1                	mov    %edx,%ecx
  8000e1:	0f af cb             	imul   %ebx,%ecx
  8000e4:	01 f9                	add    %edi,%ecx
  8000e6:	f7 e3                	mul    %ebx
  8000e8:	01 d1                	add    %edx,%ecx
  8000ea:	89 ca                	mov    %ecx,%edx
}
  8000ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000ef:	5b                   	pop    %ebx
  8000f0:	5e                   	pop    %esi
  8000f1:	5f                   	pop    %edi
  8000f2:	5d                   	pop    %ebp
  8000f3:	c3                   	ret    

008000f4 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	57                   	push   %edi
  8000f8:	56                   	push   %esi
  8000f9:	53                   	push   %ebx
  8000fa:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000fd:	e8 57 16 00 00       	call   801759 <sys_getenvindex>
  800102:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800105:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800108:	89 d0                	mov    %edx,%eax
  80010a:	c1 e0 02             	shl    $0x2,%eax
  80010d:	01 d0                	add    %edx,%eax
  80010f:	c1 e0 03             	shl    $0x3,%eax
  800112:	01 d0                	add    %edx,%eax
  800114:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80011b:	01 d0                	add    %edx,%eax
  80011d:	c1 e0 02             	shl    $0x2,%eax
  800120:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800125:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80012a:	a1 20 30 80 00       	mov    0x803020,%eax
  80012f:	8a 40 20             	mov    0x20(%eax),%al
  800132:	84 c0                	test   %al,%al
  800134:	74 0d                	je     800143 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800136:	a1 20 30 80 00       	mov    0x803020,%eax
  80013b:	83 c0 20             	add    $0x20,%eax
  80013e:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800143:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800147:	7e 0a                	jle    800153 <libmain+0x5f>
		binaryname = argv[0];
  800149:	8b 45 0c             	mov    0xc(%ebp),%eax
  80014c:	8b 00                	mov    (%eax),%eax
  80014e:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800153:	83 ec 08             	sub    $0x8,%esp
  800156:	ff 75 0c             	pushl  0xc(%ebp)
  800159:	ff 75 08             	pushl  0x8(%ebp)
  80015c:	e8 d7 fe ff ff       	call   800038 <_main>
  800161:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800164:	a1 00 30 80 00       	mov    0x803000,%eax
  800169:	85 c0                	test   %eax,%eax
  80016b:	0f 84 01 01 00 00    	je     800272 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800171:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800177:	bb e4 1f 80 00       	mov    $0x801fe4,%ebx
  80017c:	ba 0e 00 00 00       	mov    $0xe,%edx
  800181:	89 c7                	mov    %eax,%edi
  800183:	89 de                	mov    %ebx,%esi
  800185:	89 d1                	mov    %edx,%ecx
  800187:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800189:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80018c:	b9 56 00 00 00       	mov    $0x56,%ecx
  800191:	b0 00                	mov    $0x0,%al
  800193:	89 d7                	mov    %edx,%edi
  800195:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800197:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80019e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	50                   	push   %eax
  8001a5:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001ab:	50                   	push   %eax
  8001ac:	e8 de 17 00 00       	call   80198f <sys_utilities>
  8001b1:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001b4:	e8 27 13 00 00       	call   8014e0 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001b9:	83 ec 0c             	sub    $0xc,%esp
  8001bc:	68 04 1f 80 00       	push   $0x801f04
  8001c1:	e8 be 01 00 00       	call   800384 <cprintf>
  8001c6:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001cc:	85 c0                	test   %eax,%eax
  8001ce:	74 18                	je     8001e8 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001d0:	e8 d8 17 00 00       	call   8019ad <sys_get_optimal_num_faults>
  8001d5:	83 ec 08             	sub    $0x8,%esp
  8001d8:	50                   	push   %eax
  8001d9:	68 2c 1f 80 00       	push   $0x801f2c
  8001de:	e8 a1 01 00 00       	call   800384 <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp
  8001e6:	eb 59                	jmp    800241 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001e8:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ed:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8001f3:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f8:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8001fe:	83 ec 04             	sub    $0x4,%esp
  800201:	52                   	push   %edx
  800202:	50                   	push   %eax
  800203:	68 50 1f 80 00       	push   $0x801f50
  800208:	e8 77 01 00 00       	call   800384 <cprintf>
  80020d:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800210:	a1 20 30 80 00       	mov    0x803020,%eax
  800215:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80021b:	a1 20 30 80 00       	mov    0x803020,%eax
  800220:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800226:	a1 20 30 80 00       	mov    0x803020,%eax
  80022b:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800231:	51                   	push   %ecx
  800232:	52                   	push   %edx
  800233:	50                   	push   %eax
  800234:	68 78 1f 80 00       	push   $0x801f78
  800239:	e8 46 01 00 00       	call   800384 <cprintf>
  80023e:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800241:	a1 20 30 80 00       	mov    0x803020,%eax
  800246:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80024c:	83 ec 08             	sub    $0x8,%esp
  80024f:	50                   	push   %eax
  800250:	68 d0 1f 80 00       	push   $0x801fd0
  800255:	e8 2a 01 00 00       	call   800384 <cprintf>
  80025a:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80025d:	83 ec 0c             	sub    $0xc,%esp
  800260:	68 04 1f 80 00       	push   $0x801f04
  800265:	e8 1a 01 00 00       	call   800384 <cprintf>
  80026a:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80026d:	e8 88 12 00 00       	call   8014fa <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800272:	e8 1f 00 00 00       	call   800296 <exit>
}
  800277:	90                   	nop
  800278:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80027b:	5b                   	pop    %ebx
  80027c:	5e                   	pop    %esi
  80027d:	5f                   	pop    %edi
  80027e:	5d                   	pop    %ebp
  80027f:	c3                   	ret    

00800280 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	6a 00                	push   $0x0
  80028b:	e8 95 14 00 00       	call   801725 <sys_destroy_env>
  800290:	83 c4 10             	add    $0x10,%esp
}
  800293:	90                   	nop
  800294:	c9                   	leave  
  800295:	c3                   	ret    

00800296 <exit>:

void
exit(void)
{
  800296:	55                   	push   %ebp
  800297:	89 e5                	mov    %esp,%ebp
  800299:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80029c:	e8 ea 14 00 00       	call   80178b <sys_exit_env>
}
  8002a1:	90                   	nop
  8002a2:	c9                   	leave  
  8002a3:	c3                   	ret    

008002a4 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002a4:	55                   	push   %ebp
  8002a5:	89 e5                	mov    %esp,%ebp
  8002a7:	53                   	push   %ebx
  8002a8:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8002ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ae:	8b 00                	mov    (%eax),%eax
  8002b0:	8d 48 01             	lea    0x1(%eax),%ecx
  8002b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b6:	89 0a                	mov    %ecx,(%edx)
  8002b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8002bb:	88 d1                	mov    %dl,%cl
  8002bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c7:	8b 00                	mov    (%eax),%eax
  8002c9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ce:	75 30                	jne    800300 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8002d0:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8002d6:	a0 44 30 80 00       	mov    0x803044,%al
  8002db:	0f b6 c0             	movzbl %al,%eax
  8002de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002e1:	8b 09                	mov    (%ecx),%ecx
  8002e3:	89 cb                	mov    %ecx,%ebx
  8002e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002e8:	83 c1 08             	add    $0x8,%ecx
  8002eb:	52                   	push   %edx
  8002ec:	50                   	push   %eax
  8002ed:	53                   	push   %ebx
  8002ee:	51                   	push   %ecx
  8002ef:	e8 a8 11 00 00       	call   80149c <sys_cputs>
  8002f4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800300:	8b 45 0c             	mov    0xc(%ebp),%eax
  800303:	8b 40 04             	mov    0x4(%eax),%eax
  800306:	8d 50 01             	lea    0x1(%eax),%edx
  800309:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80030f:	90                   	nop
  800310:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800313:	c9                   	leave  
  800314:	c3                   	ret    

00800315 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80031e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800325:	00 00 00 
	b.cnt = 0;
  800328:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80032f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800332:	ff 75 0c             	pushl  0xc(%ebp)
  800335:	ff 75 08             	pushl  0x8(%ebp)
  800338:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80033e:	50                   	push   %eax
  80033f:	68 a4 02 80 00       	push   $0x8002a4
  800344:	e8 5a 02 00 00       	call   8005a3 <vprintfmt>
  800349:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80034c:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  800352:	a0 44 30 80 00       	mov    0x803044,%al
  800357:	0f b6 c0             	movzbl %al,%eax
  80035a:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800360:	52                   	push   %edx
  800361:	50                   	push   %eax
  800362:	51                   	push   %ecx
  800363:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800369:	83 c0 08             	add    $0x8,%eax
  80036c:	50                   	push   %eax
  80036d:	e8 2a 11 00 00       	call   80149c <sys_cputs>
  800372:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800375:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  80037c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800382:	c9                   	leave  
  800383:	c3                   	ret    

00800384 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80038a:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800391:	8d 45 0c             	lea    0xc(%ebp),%eax
  800394:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800397:	8b 45 08             	mov    0x8(%ebp),%eax
  80039a:	83 ec 08             	sub    $0x8,%esp
  80039d:	ff 75 f4             	pushl  -0xc(%ebp)
  8003a0:	50                   	push   %eax
  8003a1:	e8 6f ff ff ff       	call   800315 <vcprintf>
  8003a6:	83 c4 10             	add    $0x10,%esp
  8003a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003af:	c9                   	leave  
  8003b0:	c3                   	ret    

008003b1 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8003b1:	55                   	push   %ebp
  8003b2:	89 e5                	mov    %esp,%ebp
  8003b4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003b7:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c1:	c1 e0 08             	shl    $0x8,%eax
  8003c4:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  8003c9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003cc:	83 c0 04             	add    $0x4,%eax
  8003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d5:	83 ec 08             	sub    $0x8,%esp
  8003d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8003db:	50                   	push   %eax
  8003dc:	e8 34 ff ff ff       	call   800315 <vcprintf>
  8003e1:	83 c4 10             	add    $0x10,%esp
  8003e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8003e7:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  8003ee:	07 00 00 

	return cnt;
  8003f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003f4:	c9                   	leave  
  8003f5:	c3                   	ret    

008003f6 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003f6:	55                   	push   %ebp
  8003f7:	89 e5                	mov    %esp,%ebp
  8003f9:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003fc:	e8 df 10 00 00       	call   8014e0 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800401:	8d 45 0c             	lea    0xc(%ebp),%eax
  800404:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800407:	8b 45 08             	mov    0x8(%ebp),%eax
  80040a:	83 ec 08             	sub    $0x8,%esp
  80040d:	ff 75 f4             	pushl  -0xc(%ebp)
  800410:	50                   	push   %eax
  800411:	e8 ff fe ff ff       	call   800315 <vcprintf>
  800416:	83 c4 10             	add    $0x10,%esp
  800419:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80041c:	e8 d9 10 00 00       	call   8014fa <sys_unlock_cons>
	return cnt;
  800421:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800424:	c9                   	leave  
  800425:	c3                   	ret    

00800426 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800426:	55                   	push   %ebp
  800427:	89 e5                	mov    %esp,%ebp
  800429:	53                   	push   %ebx
  80042a:	83 ec 14             	sub    $0x14,%esp
  80042d:	8b 45 10             	mov    0x10(%ebp),%eax
  800430:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800433:	8b 45 14             	mov    0x14(%ebp),%eax
  800436:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800439:	8b 45 18             	mov    0x18(%ebp),%eax
  80043c:	ba 00 00 00 00       	mov    $0x0,%edx
  800441:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800444:	77 55                	ja     80049b <printnum+0x75>
  800446:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800449:	72 05                	jb     800450 <printnum+0x2a>
  80044b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80044e:	77 4b                	ja     80049b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800450:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800453:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800456:	8b 45 18             	mov    0x18(%ebp),%eax
  800459:	ba 00 00 00 00       	mov    $0x0,%edx
  80045e:	52                   	push   %edx
  80045f:	50                   	push   %eax
  800460:	ff 75 f4             	pushl  -0xc(%ebp)
  800463:	ff 75 f0             	pushl  -0x10(%ebp)
  800466:	e8 dd 17 00 00       	call   801c48 <__udivdi3>
  80046b:	83 c4 10             	add    $0x10,%esp
  80046e:	83 ec 04             	sub    $0x4,%esp
  800471:	ff 75 20             	pushl  0x20(%ebp)
  800474:	53                   	push   %ebx
  800475:	ff 75 18             	pushl  0x18(%ebp)
  800478:	52                   	push   %edx
  800479:	50                   	push   %eax
  80047a:	ff 75 0c             	pushl  0xc(%ebp)
  80047d:	ff 75 08             	pushl  0x8(%ebp)
  800480:	e8 a1 ff ff ff       	call   800426 <printnum>
  800485:	83 c4 20             	add    $0x20,%esp
  800488:	eb 1a                	jmp    8004a4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80048a:	83 ec 08             	sub    $0x8,%esp
  80048d:	ff 75 0c             	pushl  0xc(%ebp)
  800490:	ff 75 20             	pushl  0x20(%ebp)
  800493:	8b 45 08             	mov    0x8(%ebp),%eax
  800496:	ff d0                	call   *%eax
  800498:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80049b:	ff 4d 1c             	decl   0x1c(%ebp)
  80049e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8004a2:	7f e6                	jg     80048a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004a4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004b2:	53                   	push   %ebx
  8004b3:	51                   	push   %ecx
  8004b4:	52                   	push   %edx
  8004b5:	50                   	push   %eax
  8004b6:	e8 9d 18 00 00       	call   801d58 <__umoddi3>
  8004bb:	83 c4 10             	add    $0x10,%esp
  8004be:	05 74 22 80 00       	add    $0x802274,%eax
  8004c3:	8a 00                	mov    (%eax),%al
  8004c5:	0f be c0             	movsbl %al,%eax
  8004c8:	83 ec 08             	sub    $0x8,%esp
  8004cb:	ff 75 0c             	pushl  0xc(%ebp)
  8004ce:	50                   	push   %eax
  8004cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d2:	ff d0                	call   *%eax
  8004d4:	83 c4 10             	add    $0x10,%esp
}
  8004d7:	90                   	nop
  8004d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004db:	c9                   	leave  
  8004dc:	c3                   	ret    

008004dd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004dd:	55                   	push   %ebp
  8004de:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004e0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004e4:	7e 1c                	jle    800502 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e9:	8b 00                	mov    (%eax),%eax
  8004eb:	8d 50 08             	lea    0x8(%eax),%edx
  8004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f1:	89 10                	mov    %edx,(%eax)
  8004f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f6:	8b 00                	mov    (%eax),%eax
  8004f8:	83 e8 08             	sub    $0x8,%eax
  8004fb:	8b 50 04             	mov    0x4(%eax),%edx
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	eb 40                	jmp    800542 <getuint+0x65>
	else if (lflag)
  800502:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800506:	74 1e                	je     800526 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	8d 50 04             	lea    0x4(%eax),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	89 10                	mov    %edx,(%eax)
  800515:	8b 45 08             	mov    0x8(%ebp),%eax
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	83 e8 04             	sub    $0x4,%eax
  80051d:	8b 00                	mov    (%eax),%eax
  80051f:	ba 00 00 00 00       	mov    $0x0,%edx
  800524:	eb 1c                	jmp    800542 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800526:	8b 45 08             	mov    0x8(%ebp),%eax
  800529:	8b 00                	mov    (%eax),%eax
  80052b:	8d 50 04             	lea    0x4(%eax),%edx
  80052e:	8b 45 08             	mov    0x8(%ebp),%eax
  800531:	89 10                	mov    %edx,(%eax)
  800533:	8b 45 08             	mov    0x8(%ebp),%eax
  800536:	8b 00                	mov    (%eax),%eax
  800538:	83 e8 04             	sub    $0x4,%eax
  80053b:	8b 00                	mov    (%eax),%eax
  80053d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800542:	5d                   	pop    %ebp
  800543:	c3                   	ret    

00800544 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800544:	55                   	push   %ebp
  800545:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800547:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80054b:	7e 1c                	jle    800569 <getint+0x25>
		return va_arg(*ap, long long);
  80054d:	8b 45 08             	mov    0x8(%ebp),%eax
  800550:	8b 00                	mov    (%eax),%eax
  800552:	8d 50 08             	lea    0x8(%eax),%edx
  800555:	8b 45 08             	mov    0x8(%ebp),%eax
  800558:	89 10                	mov    %edx,(%eax)
  80055a:	8b 45 08             	mov    0x8(%ebp),%eax
  80055d:	8b 00                	mov    (%eax),%eax
  80055f:	83 e8 08             	sub    $0x8,%eax
  800562:	8b 50 04             	mov    0x4(%eax),%edx
  800565:	8b 00                	mov    (%eax),%eax
  800567:	eb 38                	jmp    8005a1 <getint+0x5d>
	else if (lflag)
  800569:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80056d:	74 1a                	je     800589 <getint+0x45>
		return va_arg(*ap, long);
  80056f:	8b 45 08             	mov    0x8(%ebp),%eax
  800572:	8b 00                	mov    (%eax),%eax
  800574:	8d 50 04             	lea    0x4(%eax),%edx
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	89 10                	mov    %edx,(%eax)
  80057c:	8b 45 08             	mov    0x8(%ebp),%eax
  80057f:	8b 00                	mov    (%eax),%eax
  800581:	83 e8 04             	sub    $0x4,%eax
  800584:	8b 00                	mov    (%eax),%eax
  800586:	99                   	cltd   
  800587:	eb 18                	jmp    8005a1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800589:	8b 45 08             	mov    0x8(%ebp),%eax
  80058c:	8b 00                	mov    (%eax),%eax
  80058e:	8d 50 04             	lea    0x4(%eax),%edx
  800591:	8b 45 08             	mov    0x8(%ebp),%eax
  800594:	89 10                	mov    %edx,(%eax)
  800596:	8b 45 08             	mov    0x8(%ebp),%eax
  800599:	8b 00                	mov    (%eax),%eax
  80059b:	83 e8 04             	sub    $0x4,%eax
  80059e:	8b 00                	mov    (%eax),%eax
  8005a0:	99                   	cltd   
}
  8005a1:	5d                   	pop    %ebp
  8005a2:	c3                   	ret    

008005a3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005a3:	55                   	push   %ebp
  8005a4:	89 e5                	mov    %esp,%ebp
  8005a6:	56                   	push   %esi
  8005a7:	53                   	push   %ebx
  8005a8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005ab:	eb 17                	jmp    8005c4 <vprintfmt+0x21>
			if (ch == '\0')
  8005ad:	85 db                	test   %ebx,%ebx
  8005af:	0f 84 c1 03 00 00    	je     800976 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8005b5:	83 ec 08             	sub    $0x8,%esp
  8005b8:	ff 75 0c             	pushl  0xc(%ebp)
  8005bb:	53                   	push   %ebx
  8005bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bf:	ff d0                	call   *%eax
  8005c1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c7:	8d 50 01             	lea    0x1(%eax),%edx
  8005ca:	89 55 10             	mov    %edx,0x10(%ebp)
  8005cd:	8a 00                	mov    (%eax),%al
  8005cf:	0f b6 d8             	movzbl %al,%ebx
  8005d2:	83 fb 25             	cmp    $0x25,%ebx
  8005d5:	75 d6                	jne    8005ad <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005d7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005db:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005e2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005e9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005f0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8005fa:	8d 50 01             	lea    0x1(%eax),%edx
  8005fd:	89 55 10             	mov    %edx,0x10(%ebp)
  800600:	8a 00                	mov    (%eax),%al
  800602:	0f b6 d8             	movzbl %al,%ebx
  800605:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800608:	83 f8 5b             	cmp    $0x5b,%eax
  80060b:	0f 87 3d 03 00 00    	ja     80094e <vprintfmt+0x3ab>
  800611:	8b 04 85 98 22 80 00 	mov    0x802298(,%eax,4),%eax
  800618:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80061a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80061e:	eb d7                	jmp    8005f7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800620:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800624:	eb d1                	jmp    8005f7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800626:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80062d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800630:	89 d0                	mov    %edx,%eax
  800632:	c1 e0 02             	shl    $0x2,%eax
  800635:	01 d0                	add    %edx,%eax
  800637:	01 c0                	add    %eax,%eax
  800639:	01 d8                	add    %ebx,%eax
  80063b:	83 e8 30             	sub    $0x30,%eax
  80063e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800641:	8b 45 10             	mov    0x10(%ebp),%eax
  800644:	8a 00                	mov    (%eax),%al
  800646:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800649:	83 fb 2f             	cmp    $0x2f,%ebx
  80064c:	7e 3e                	jle    80068c <vprintfmt+0xe9>
  80064e:	83 fb 39             	cmp    $0x39,%ebx
  800651:	7f 39                	jg     80068c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800653:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800656:	eb d5                	jmp    80062d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	83 c0 04             	add    $0x4,%eax
  80065e:	89 45 14             	mov    %eax,0x14(%ebp)
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	83 e8 04             	sub    $0x4,%eax
  800667:	8b 00                	mov    (%eax),%eax
  800669:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80066c:	eb 1f                	jmp    80068d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80066e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800672:	79 83                	jns    8005f7 <vprintfmt+0x54>
				width = 0;
  800674:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80067b:	e9 77 ff ff ff       	jmp    8005f7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800680:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800687:	e9 6b ff ff ff       	jmp    8005f7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80068c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80068d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800691:	0f 89 60 ff ff ff    	jns    8005f7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800697:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80069a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80069d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8006a4:	e9 4e ff ff ff       	jmp    8005f7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006a9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8006ac:	e9 46 ff ff ff       	jmp    8005f7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	83 c0 04             	add    $0x4,%eax
  8006b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bd:	83 e8 04             	sub    $0x4,%eax
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	83 ec 08             	sub    $0x8,%esp
  8006c5:	ff 75 0c             	pushl  0xc(%ebp)
  8006c8:	50                   	push   %eax
  8006c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cc:	ff d0                	call   *%eax
  8006ce:	83 c4 10             	add    $0x10,%esp
			break;
  8006d1:	e9 9b 02 00 00       	jmp    800971 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	83 c0 04             	add    $0x4,%eax
  8006dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	83 e8 04             	sub    $0x4,%eax
  8006e5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006e7:	85 db                	test   %ebx,%ebx
  8006e9:	79 02                	jns    8006ed <vprintfmt+0x14a>
				err = -err;
  8006eb:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006ed:	83 fb 64             	cmp    $0x64,%ebx
  8006f0:	7f 0b                	jg     8006fd <vprintfmt+0x15a>
  8006f2:	8b 34 9d e0 20 80 00 	mov    0x8020e0(,%ebx,4),%esi
  8006f9:	85 f6                	test   %esi,%esi
  8006fb:	75 19                	jne    800716 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006fd:	53                   	push   %ebx
  8006fe:	68 85 22 80 00       	push   $0x802285
  800703:	ff 75 0c             	pushl  0xc(%ebp)
  800706:	ff 75 08             	pushl  0x8(%ebp)
  800709:	e8 70 02 00 00       	call   80097e <printfmt>
  80070e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800711:	e9 5b 02 00 00       	jmp    800971 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800716:	56                   	push   %esi
  800717:	68 8e 22 80 00       	push   $0x80228e
  80071c:	ff 75 0c             	pushl  0xc(%ebp)
  80071f:	ff 75 08             	pushl  0x8(%ebp)
  800722:	e8 57 02 00 00       	call   80097e <printfmt>
  800727:	83 c4 10             	add    $0x10,%esp
			break;
  80072a:	e9 42 02 00 00       	jmp    800971 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80072f:	8b 45 14             	mov    0x14(%ebp),%eax
  800732:	83 c0 04             	add    $0x4,%eax
  800735:	89 45 14             	mov    %eax,0x14(%ebp)
  800738:	8b 45 14             	mov    0x14(%ebp),%eax
  80073b:	83 e8 04             	sub    $0x4,%eax
  80073e:	8b 30                	mov    (%eax),%esi
  800740:	85 f6                	test   %esi,%esi
  800742:	75 05                	jne    800749 <vprintfmt+0x1a6>
				p = "(null)";
  800744:	be 91 22 80 00       	mov    $0x802291,%esi
			if (width > 0 && padc != '-')
  800749:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80074d:	7e 6d                	jle    8007bc <vprintfmt+0x219>
  80074f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800753:	74 67                	je     8007bc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800755:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800758:	83 ec 08             	sub    $0x8,%esp
  80075b:	50                   	push   %eax
  80075c:	56                   	push   %esi
  80075d:	e8 26 05 00 00       	call   800c88 <strnlen>
  800762:	83 c4 10             	add    $0x10,%esp
  800765:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800768:	eb 16                	jmp    800780 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80076a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80076e:	83 ec 08             	sub    $0x8,%esp
  800771:	ff 75 0c             	pushl  0xc(%ebp)
  800774:	50                   	push   %eax
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	ff d0                	call   *%eax
  80077a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80077d:	ff 4d e4             	decl   -0x1c(%ebp)
  800780:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800784:	7f e4                	jg     80076a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800786:	eb 34                	jmp    8007bc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800788:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80078c:	74 1c                	je     8007aa <vprintfmt+0x207>
  80078e:	83 fb 1f             	cmp    $0x1f,%ebx
  800791:	7e 05                	jle    800798 <vprintfmt+0x1f5>
  800793:	83 fb 7e             	cmp    $0x7e,%ebx
  800796:	7e 12                	jle    8007aa <vprintfmt+0x207>
					putch('?', putdat);
  800798:	83 ec 08             	sub    $0x8,%esp
  80079b:	ff 75 0c             	pushl  0xc(%ebp)
  80079e:	6a 3f                	push   $0x3f
  8007a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a3:	ff d0                	call   *%eax
  8007a5:	83 c4 10             	add    $0x10,%esp
  8007a8:	eb 0f                	jmp    8007b9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8007aa:	83 ec 08             	sub    $0x8,%esp
  8007ad:	ff 75 0c             	pushl  0xc(%ebp)
  8007b0:	53                   	push   %ebx
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	ff d0                	call   *%eax
  8007b6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007b9:	ff 4d e4             	decl   -0x1c(%ebp)
  8007bc:	89 f0                	mov    %esi,%eax
  8007be:	8d 70 01             	lea    0x1(%eax),%esi
  8007c1:	8a 00                	mov    (%eax),%al
  8007c3:	0f be d8             	movsbl %al,%ebx
  8007c6:	85 db                	test   %ebx,%ebx
  8007c8:	74 24                	je     8007ee <vprintfmt+0x24b>
  8007ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007ce:	78 b8                	js     800788 <vprintfmt+0x1e5>
  8007d0:	ff 4d e0             	decl   -0x20(%ebp)
  8007d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007d7:	79 af                	jns    800788 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007d9:	eb 13                	jmp    8007ee <vprintfmt+0x24b>
				putch(' ', putdat);
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	ff 75 0c             	pushl  0xc(%ebp)
  8007e1:	6a 20                	push   $0x20
  8007e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e6:	ff d0                	call   *%eax
  8007e8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007eb:	ff 4d e4             	decl   -0x1c(%ebp)
  8007ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f2:	7f e7                	jg     8007db <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007f4:	e9 78 01 00 00       	jmp    800971 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007f9:	83 ec 08             	sub    $0x8,%esp
  8007fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8007ff:	8d 45 14             	lea    0x14(%ebp),%eax
  800802:	50                   	push   %eax
  800803:	e8 3c fd ff ff       	call   800544 <getint>
  800808:	83 c4 10             	add    $0x10,%esp
  80080b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80080e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800811:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800814:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800817:	85 d2                	test   %edx,%edx
  800819:	79 23                	jns    80083e <vprintfmt+0x29b>
				putch('-', putdat);
  80081b:	83 ec 08             	sub    $0x8,%esp
  80081e:	ff 75 0c             	pushl  0xc(%ebp)
  800821:	6a 2d                	push   $0x2d
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	ff d0                	call   *%eax
  800828:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80082b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80082e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800831:	f7 d8                	neg    %eax
  800833:	83 d2 00             	adc    $0x0,%edx
  800836:	f7 da                	neg    %edx
  800838:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80083b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80083e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800845:	e9 bc 00 00 00       	jmp    800906 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80084a:	83 ec 08             	sub    $0x8,%esp
  80084d:	ff 75 e8             	pushl  -0x18(%ebp)
  800850:	8d 45 14             	lea    0x14(%ebp),%eax
  800853:	50                   	push   %eax
  800854:	e8 84 fc ff ff       	call   8004dd <getuint>
  800859:	83 c4 10             	add    $0x10,%esp
  80085c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80085f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800862:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800869:	e9 98 00 00 00       	jmp    800906 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80086e:	83 ec 08             	sub    $0x8,%esp
  800871:	ff 75 0c             	pushl  0xc(%ebp)
  800874:	6a 58                	push   $0x58
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	ff d0                	call   *%eax
  80087b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80087e:	83 ec 08             	sub    $0x8,%esp
  800881:	ff 75 0c             	pushl  0xc(%ebp)
  800884:	6a 58                	push   $0x58
  800886:	8b 45 08             	mov    0x8(%ebp),%eax
  800889:	ff d0                	call   *%eax
  80088b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80088e:	83 ec 08             	sub    $0x8,%esp
  800891:	ff 75 0c             	pushl  0xc(%ebp)
  800894:	6a 58                	push   $0x58
  800896:	8b 45 08             	mov    0x8(%ebp),%eax
  800899:	ff d0                	call   *%eax
  80089b:	83 c4 10             	add    $0x10,%esp
			break;
  80089e:	e9 ce 00 00 00       	jmp    800971 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8008a3:	83 ec 08             	sub    $0x8,%esp
  8008a6:	ff 75 0c             	pushl  0xc(%ebp)
  8008a9:	6a 30                	push   $0x30
  8008ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ae:	ff d0                	call   *%eax
  8008b0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008b3:	83 ec 08             	sub    $0x8,%esp
  8008b6:	ff 75 0c             	pushl  0xc(%ebp)
  8008b9:	6a 78                	push   $0x78
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	ff d0                	call   *%eax
  8008c0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8008c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c6:	83 c0 04             	add    $0x4,%eax
  8008c9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cf:	83 e8 04             	sub    $0x4,%eax
  8008d2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008de:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008e5:	eb 1f                	jmp    800906 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008e7:	83 ec 08             	sub    $0x8,%esp
  8008ea:	ff 75 e8             	pushl  -0x18(%ebp)
  8008ed:	8d 45 14             	lea    0x14(%ebp),%eax
  8008f0:	50                   	push   %eax
  8008f1:	e8 e7 fb ff ff       	call   8004dd <getuint>
  8008f6:	83 c4 10             	add    $0x10,%esp
  8008f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008ff:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800906:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80090a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80090d:	83 ec 04             	sub    $0x4,%esp
  800910:	52                   	push   %edx
  800911:	ff 75 e4             	pushl  -0x1c(%ebp)
  800914:	50                   	push   %eax
  800915:	ff 75 f4             	pushl  -0xc(%ebp)
  800918:	ff 75 f0             	pushl  -0x10(%ebp)
  80091b:	ff 75 0c             	pushl  0xc(%ebp)
  80091e:	ff 75 08             	pushl  0x8(%ebp)
  800921:	e8 00 fb ff ff       	call   800426 <printnum>
  800926:	83 c4 20             	add    $0x20,%esp
			break;
  800929:	eb 46                	jmp    800971 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	ff 75 0c             	pushl  0xc(%ebp)
  800931:	53                   	push   %ebx
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	ff d0                	call   *%eax
  800937:	83 c4 10             	add    $0x10,%esp
			break;
  80093a:	eb 35                	jmp    800971 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80093c:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800943:	eb 2c                	jmp    800971 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800945:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  80094c:	eb 23                	jmp    800971 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80094e:	83 ec 08             	sub    $0x8,%esp
  800951:	ff 75 0c             	pushl  0xc(%ebp)
  800954:	6a 25                	push   $0x25
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	ff d0                	call   *%eax
  80095b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80095e:	ff 4d 10             	decl   0x10(%ebp)
  800961:	eb 03                	jmp    800966 <vprintfmt+0x3c3>
  800963:	ff 4d 10             	decl   0x10(%ebp)
  800966:	8b 45 10             	mov    0x10(%ebp),%eax
  800969:	48                   	dec    %eax
  80096a:	8a 00                	mov    (%eax),%al
  80096c:	3c 25                	cmp    $0x25,%al
  80096e:	75 f3                	jne    800963 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800970:	90                   	nop
		}
	}
  800971:	e9 35 fc ff ff       	jmp    8005ab <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800976:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800977:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80097a:	5b                   	pop    %ebx
  80097b:	5e                   	pop    %esi
  80097c:	5d                   	pop    %ebp
  80097d:	c3                   	ret    

0080097e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800984:	8d 45 10             	lea    0x10(%ebp),%eax
  800987:	83 c0 04             	add    $0x4,%eax
  80098a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80098d:	8b 45 10             	mov    0x10(%ebp),%eax
  800990:	ff 75 f4             	pushl  -0xc(%ebp)
  800993:	50                   	push   %eax
  800994:	ff 75 0c             	pushl  0xc(%ebp)
  800997:	ff 75 08             	pushl  0x8(%ebp)
  80099a:	e8 04 fc ff ff       	call   8005a3 <vprintfmt>
  80099f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8009a2:	90                   	nop
  8009a3:	c9                   	leave  
  8009a4:	c3                   	ret    

008009a5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8009a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ab:	8b 40 08             	mov    0x8(%eax),%eax
  8009ae:	8d 50 01             	lea    0x1(%eax),%edx
  8009b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8009b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ba:	8b 10                	mov    (%eax),%edx
  8009bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009bf:	8b 40 04             	mov    0x4(%eax),%eax
  8009c2:	39 c2                	cmp    %eax,%edx
  8009c4:	73 12                	jae    8009d8 <sprintputch+0x33>
		*b->buf++ = ch;
  8009c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c9:	8b 00                	mov    (%eax),%eax
  8009cb:	8d 48 01             	lea    0x1(%eax),%ecx
  8009ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d1:	89 0a                	mov    %ecx,(%edx)
  8009d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8009d6:	88 10                	mov    %dl,(%eax)
}
  8009d8:	90                   	nop
  8009d9:	5d                   	pop    %ebp
  8009da:	c3                   	ret    

008009db <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ea:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	01 d0                	add    %edx,%eax
  8009f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a00:	74 06                	je     800a08 <vsnprintf+0x2d>
  800a02:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a06:	7f 07                	jg     800a0f <vsnprintf+0x34>
		return -E_INVAL;
  800a08:	b8 03 00 00 00       	mov    $0x3,%eax
  800a0d:	eb 20                	jmp    800a2f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a0f:	ff 75 14             	pushl  0x14(%ebp)
  800a12:	ff 75 10             	pushl  0x10(%ebp)
  800a15:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a18:	50                   	push   %eax
  800a19:	68 a5 09 80 00       	push   $0x8009a5
  800a1e:	e8 80 fb ff ff       	call   8005a3 <vprintfmt>
  800a23:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a29:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a2f:	c9                   	leave  
  800a30:	c3                   	ret    

00800a31 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a31:	55                   	push   %ebp
  800a32:	89 e5                	mov    %esp,%ebp
  800a34:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a37:	8d 45 10             	lea    0x10(%ebp),%eax
  800a3a:	83 c0 04             	add    $0x4,%eax
  800a3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a40:	8b 45 10             	mov    0x10(%ebp),%eax
  800a43:	ff 75 f4             	pushl  -0xc(%ebp)
  800a46:	50                   	push   %eax
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	ff 75 08             	pushl  0x8(%ebp)
  800a4d:	e8 89 ff ff ff       	call   8009db <vsnprintf>
  800a52:	83 c4 10             	add    $0x10,%esp
  800a55:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a5b:	c9                   	leave  
  800a5c:	c3                   	ret    

00800a5d <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800a5d:	55                   	push   %ebp
  800a5e:	89 e5                	mov    %esp,%ebp
  800a60:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800a63:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a67:	74 13                	je     800a7c <readline+0x1f>
		cprintf("%s", prompt);
  800a69:	83 ec 08             	sub    $0x8,%esp
  800a6c:	ff 75 08             	pushl  0x8(%ebp)
  800a6f:	68 08 24 80 00       	push   $0x802408
  800a74:	e8 0b f9 ff ff       	call   800384 <cprintf>
  800a79:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a83:	83 ec 0c             	sub    $0xc,%esp
  800a86:	6a 00                	push   $0x0
  800a88:	e8 c0 0f 00 00       	call   801a4d <iscons>
  800a8d:	83 c4 10             	add    $0x10,%esp
  800a90:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a93:	e8 a2 0f 00 00       	call   801a3a <getchar>
  800a98:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800a9b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a9f:	79 22                	jns    800ac3 <readline+0x66>
			if (c != -E_EOF)
  800aa1:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800aa5:	0f 84 ad 00 00 00    	je     800b58 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800aab:	83 ec 08             	sub    $0x8,%esp
  800aae:	ff 75 ec             	pushl  -0x14(%ebp)
  800ab1:	68 0b 24 80 00       	push   $0x80240b
  800ab6:	e8 c9 f8 ff ff       	call   800384 <cprintf>
  800abb:	83 c4 10             	add    $0x10,%esp
			break;
  800abe:	e9 95 00 00 00       	jmp    800b58 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ac3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ac7:	7e 34                	jle    800afd <readline+0xa0>
  800ac9:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ad0:	7f 2b                	jg     800afd <readline+0xa0>
			if (echoing)
  800ad2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ad6:	74 0e                	je     800ae6 <readline+0x89>
				cputchar(c);
  800ad8:	83 ec 0c             	sub    $0xc,%esp
  800adb:	ff 75 ec             	pushl  -0x14(%ebp)
  800ade:	e8 38 0f 00 00       	call   801a1b <cputchar>
  800ae3:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ae9:	8d 50 01             	lea    0x1(%eax),%edx
  800aec:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800aef:	89 c2                	mov    %eax,%edx
  800af1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af4:	01 d0                	add    %edx,%eax
  800af6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800af9:	88 10                	mov    %dl,(%eax)
  800afb:	eb 56                	jmp    800b53 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800afd:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b01:	75 1f                	jne    800b22 <readline+0xc5>
  800b03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b07:	7e 19                	jle    800b22 <readline+0xc5>
			if (echoing)
  800b09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b0d:	74 0e                	je     800b1d <readline+0xc0>
				cputchar(c);
  800b0f:	83 ec 0c             	sub    $0xc,%esp
  800b12:	ff 75 ec             	pushl  -0x14(%ebp)
  800b15:	e8 01 0f 00 00       	call   801a1b <cputchar>
  800b1a:	83 c4 10             	add    $0x10,%esp

			i--;
  800b1d:	ff 4d f4             	decl   -0xc(%ebp)
  800b20:	eb 31                	jmp    800b53 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800b22:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b26:	74 0a                	je     800b32 <readline+0xd5>
  800b28:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b2c:	0f 85 61 ff ff ff    	jne    800a93 <readline+0x36>
			if (echoing)
  800b32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b36:	74 0e                	je     800b46 <readline+0xe9>
				cputchar(c);
  800b38:	83 ec 0c             	sub    $0xc,%esp
  800b3b:	ff 75 ec             	pushl  -0x14(%ebp)
  800b3e:	e8 d8 0e 00 00       	call   801a1b <cputchar>
  800b43:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800b46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4c:	01 d0                	add    %edx,%eax
  800b4e:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800b51:	eb 06                	jmp    800b59 <readline+0xfc>
		}
	}
  800b53:	e9 3b ff ff ff       	jmp    800a93 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800b58:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800b59:	90                   	nop
  800b5a:	c9                   	leave  
  800b5b:	c3                   	ret    

00800b5c <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800b62:	e8 79 09 00 00       	call   8014e0 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b6b:	74 13                	je     800b80 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 08             	pushl  0x8(%ebp)
  800b73:	68 08 24 80 00       	push   $0x802408
  800b78:	e8 07 f8 ff ff       	call   800384 <cprintf>
  800b7d:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b87:	83 ec 0c             	sub    $0xc,%esp
  800b8a:	6a 00                	push   $0x0
  800b8c:	e8 bc 0e 00 00       	call   801a4d <iscons>
  800b91:	83 c4 10             	add    $0x10,%esp
  800b94:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800b97:	e8 9e 0e 00 00       	call   801a3a <getchar>
  800b9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800b9f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ba3:	79 22                	jns    800bc7 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800ba5:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800ba9:	0f 84 ad 00 00 00    	je     800c5c <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800baf:	83 ec 08             	sub    $0x8,%esp
  800bb2:	ff 75 ec             	pushl  -0x14(%ebp)
  800bb5:	68 0b 24 80 00       	push   $0x80240b
  800bba:	e8 c5 f7 ff ff       	call   800384 <cprintf>
  800bbf:	83 c4 10             	add    $0x10,%esp
				break;
  800bc2:	e9 95 00 00 00       	jmp    800c5c <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800bc7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800bcb:	7e 34                	jle    800c01 <atomic_readline+0xa5>
  800bcd:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800bd4:	7f 2b                	jg     800c01 <atomic_readline+0xa5>
				if (echoing)
  800bd6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bda:	74 0e                	je     800bea <atomic_readline+0x8e>
					cputchar(c);
  800bdc:	83 ec 0c             	sub    $0xc,%esp
  800bdf:	ff 75 ec             	pushl  -0x14(%ebp)
  800be2:	e8 34 0e 00 00       	call   801a1b <cputchar>
  800be7:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bed:	8d 50 01             	lea    0x1(%eax),%edx
  800bf0:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800bf3:	89 c2                	mov    %eax,%edx
  800bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf8:	01 d0                	add    %edx,%eax
  800bfa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800bfd:	88 10                	mov    %dl,(%eax)
  800bff:	eb 56                	jmp    800c57 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800c01:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800c05:	75 1f                	jne    800c26 <atomic_readline+0xca>
  800c07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800c0b:	7e 19                	jle    800c26 <atomic_readline+0xca>
				if (echoing)
  800c0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c11:	74 0e                	je     800c21 <atomic_readline+0xc5>
					cputchar(c);
  800c13:	83 ec 0c             	sub    $0xc,%esp
  800c16:	ff 75 ec             	pushl  -0x14(%ebp)
  800c19:	e8 fd 0d 00 00       	call   801a1b <cputchar>
  800c1e:	83 c4 10             	add    $0x10,%esp
				i--;
  800c21:	ff 4d f4             	decl   -0xc(%ebp)
  800c24:	eb 31                	jmp    800c57 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800c26:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800c2a:	74 0a                	je     800c36 <atomic_readline+0xda>
  800c2c:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800c30:	0f 85 61 ff ff ff    	jne    800b97 <atomic_readline+0x3b>
				if (echoing)
  800c36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c3a:	74 0e                	je     800c4a <atomic_readline+0xee>
					cputchar(c);
  800c3c:	83 ec 0c             	sub    $0xc,%esp
  800c3f:	ff 75 ec             	pushl  -0x14(%ebp)
  800c42:	e8 d4 0d 00 00       	call   801a1b <cputchar>
  800c47:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800c4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c50:	01 d0                	add    %edx,%eax
  800c52:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800c55:	eb 06                	jmp    800c5d <atomic_readline+0x101>
			}
		}
  800c57:	e9 3b ff ff ff       	jmp    800b97 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800c5c:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800c5d:	e8 98 08 00 00       	call   8014fa <sys_unlock_cons>
}
  800c62:	90                   	nop
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c6b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c72:	eb 06                	jmp    800c7a <strlen+0x15>
		n++;
  800c74:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c77:	ff 45 08             	incl   0x8(%ebp)
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	8a 00                	mov    (%eax),%al
  800c7f:	84 c0                	test   %al,%al
  800c81:	75 f1                	jne    800c74 <strlen+0xf>
		n++;
	return n;
  800c83:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c86:	c9                   	leave  
  800c87:	c3                   	ret    

00800c88 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c95:	eb 09                	jmp    800ca0 <strnlen+0x18>
		n++;
  800c97:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c9a:	ff 45 08             	incl   0x8(%ebp)
  800c9d:	ff 4d 0c             	decl   0xc(%ebp)
  800ca0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca4:	74 09                	je     800caf <strnlen+0x27>
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	8a 00                	mov    (%eax),%al
  800cab:	84 c0                	test   %al,%al
  800cad:	75 e8                	jne    800c97 <strnlen+0xf>
		n++;
	return n;
  800caf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb2:	c9                   	leave  
  800cb3:	c3                   	ret    

00800cb4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cc0:	90                   	nop
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	8d 50 01             	lea    0x1(%eax),%edx
  800cc7:	89 55 08             	mov    %edx,0x8(%ebp)
  800cca:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ccd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd3:	8a 12                	mov    (%edx),%dl
  800cd5:	88 10                	mov    %dl,(%eax)
  800cd7:	8a 00                	mov    (%eax),%al
  800cd9:	84 c0                	test   %al,%al
  800cdb:	75 e4                	jne    800cc1 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce0:	c9                   	leave  
  800ce1:	c3                   	ret    

00800ce2 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf5:	eb 1f                	jmp    800d16 <strncpy+0x34>
		*dst++ = *src;
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	8d 50 01             	lea    0x1(%eax),%edx
  800cfd:	89 55 08             	mov    %edx,0x8(%ebp)
  800d00:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d03:	8a 12                	mov    (%edx),%dl
  800d05:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0a:	8a 00                	mov    (%eax),%al
  800d0c:	84 c0                	test   %al,%al
  800d0e:	74 03                	je     800d13 <strncpy+0x31>
			src++;
  800d10:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d13:	ff 45 fc             	incl   -0x4(%ebp)
  800d16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d19:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d1c:	72 d9                	jb     800cf7 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d21:	c9                   	leave  
  800d22:	c3                   	ret    

00800d23 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d33:	74 30                	je     800d65 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d35:	eb 16                	jmp    800d4d <strlcpy+0x2a>
			*dst++ = *src++;
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	8d 50 01             	lea    0x1(%eax),%edx
  800d3d:	89 55 08             	mov    %edx,0x8(%ebp)
  800d40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d43:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d46:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d49:	8a 12                	mov    (%edx),%dl
  800d4b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d4d:	ff 4d 10             	decl   0x10(%ebp)
  800d50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d54:	74 09                	je     800d5f <strlcpy+0x3c>
  800d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d59:	8a 00                	mov    (%eax),%al
  800d5b:	84 c0                	test   %al,%al
  800d5d:	75 d8                	jne    800d37 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d65:	8b 55 08             	mov    0x8(%ebp),%edx
  800d68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6b:	29 c2                	sub    %eax,%edx
  800d6d:	89 d0                	mov    %edx,%eax
}
  800d6f:	c9                   	leave  
  800d70:	c3                   	ret    

00800d71 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d71:	55                   	push   %ebp
  800d72:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d74:	eb 06                	jmp    800d7c <strcmp+0xb>
		p++, q++;
  800d76:	ff 45 08             	incl   0x8(%ebp)
  800d79:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	8a 00                	mov    (%eax),%al
  800d81:	84 c0                	test   %al,%al
  800d83:	74 0e                	je     800d93 <strcmp+0x22>
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	8a 10                	mov    (%eax),%dl
  800d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	38 c2                	cmp    %al,%dl
  800d91:	74 e3                	je     800d76 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8a 00                	mov    (%eax),%al
  800d98:	0f b6 d0             	movzbl %al,%edx
  800d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9e:	8a 00                	mov    (%eax),%al
  800da0:	0f b6 c0             	movzbl %al,%eax
  800da3:	29 c2                	sub    %eax,%edx
  800da5:	89 d0                	mov    %edx,%eax
}
  800da7:	5d                   	pop    %ebp
  800da8:	c3                   	ret    

00800da9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800da9:	55                   	push   %ebp
  800daa:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dac:	eb 09                	jmp    800db7 <strncmp+0xe>
		n--, p++, q++;
  800dae:	ff 4d 10             	decl   0x10(%ebp)
  800db1:	ff 45 08             	incl   0x8(%ebp)
  800db4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800db7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbb:	74 17                	je     800dd4 <strncmp+0x2b>
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8a 00                	mov    (%eax),%al
  800dc2:	84 c0                	test   %al,%al
  800dc4:	74 0e                	je     800dd4 <strncmp+0x2b>
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	8a 10                	mov    (%eax),%dl
  800dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dce:	8a 00                	mov    (%eax),%al
  800dd0:	38 c2                	cmp    %al,%dl
  800dd2:	74 da                	je     800dae <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd8:	75 07                	jne    800de1 <strncmp+0x38>
		return 0;
  800dda:	b8 00 00 00 00       	mov    $0x0,%eax
  800ddf:	eb 14                	jmp    800df5 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	8a 00                	mov    (%eax),%al
  800de6:	0f b6 d0             	movzbl %al,%edx
  800de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dec:	8a 00                	mov    (%eax),%al
  800dee:	0f b6 c0             	movzbl %al,%eax
  800df1:	29 c2                	sub    %eax,%edx
  800df3:	89 d0                	mov    %edx,%eax
}
  800df5:	5d                   	pop    %ebp
  800df6:	c3                   	ret    

00800df7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800df7:	55                   	push   %ebp
  800df8:	89 e5                	mov    %esp,%ebp
  800dfa:	83 ec 04             	sub    $0x4,%esp
  800dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e00:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e03:	eb 12                	jmp    800e17 <strchr+0x20>
		if (*s == c)
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8a 00                	mov    (%eax),%al
  800e0a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e0d:	75 05                	jne    800e14 <strchr+0x1d>
			return (char *) s;
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	eb 11                	jmp    800e25 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e14:	ff 45 08             	incl   0x8(%ebp)
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	84 c0                	test   %al,%al
  800e1e:	75 e5                	jne    800e05 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e25:	c9                   	leave  
  800e26:	c3                   	ret    

00800e27 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
  800e2a:	83 ec 04             	sub    $0x4,%esp
  800e2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e30:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e33:	eb 0d                	jmp    800e42 <strfind+0x1b>
		if (*s == c)
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
  800e38:	8a 00                	mov    (%eax),%al
  800e3a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e3d:	74 0e                	je     800e4d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e3f:	ff 45 08             	incl   0x8(%ebp)
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	84 c0                	test   %al,%al
  800e49:	75 ea                	jne    800e35 <strfind+0xe>
  800e4b:	eb 01                	jmp    800e4e <strfind+0x27>
		if (*s == c)
			break;
  800e4d:	90                   	nop
	return (char *) s;
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e51:	c9                   	leave  
  800e52:	c3                   	ret    

00800e53 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
  800e56:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e5f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e63:	76 63                	jbe    800ec8 <memset+0x75>
		uint64 data_block = c;
  800e65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e68:	99                   	cltd   
  800e69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e6c:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e75:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e79:	c1 e0 08             	shl    $0x8,%eax
  800e7c:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e7f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e88:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e8c:	c1 e0 10             	shl    $0x10,%eax
  800e8f:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e92:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9b:	89 c2                	mov    %eax,%edx
  800e9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea2:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ea5:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ea8:	eb 18                	jmp    800ec2 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800eaa:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ead:	8d 41 08             	lea    0x8(%ecx),%eax
  800eb0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800eb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb9:	89 01                	mov    %eax,(%ecx)
  800ebb:	89 51 04             	mov    %edx,0x4(%ecx)
  800ebe:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ec2:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ec6:	77 e2                	ja     800eaa <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ec8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecc:	74 23                	je     800ef1 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ece:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ed4:	eb 0e                	jmp    800ee4 <memset+0x91>
			*p8++ = (uint8)c;
  800ed6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed9:	8d 50 01             	lea    0x1(%eax),%edx
  800edc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800edf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee2:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800ee4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eea:	89 55 10             	mov    %edx,0x10(%ebp)
  800eed:	85 c0                	test   %eax,%eax
  800eef:	75 e5                	jne    800ed6 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef4:	c9                   	leave  
  800ef5:	c3                   	ret    

00800ef6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ef6:	55                   	push   %ebp
  800ef7:	89 e5                	mov    %esp,%ebp
  800ef9:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800efc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f08:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f0c:	76 24                	jbe    800f32 <memcpy+0x3c>
		while(n >= 8){
  800f0e:	eb 1c                	jmp    800f2c <memcpy+0x36>
			*d64 = *s64;
  800f10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f13:	8b 50 04             	mov    0x4(%eax),%edx
  800f16:	8b 00                	mov    (%eax),%eax
  800f18:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f1b:	89 01                	mov    %eax,(%ecx)
  800f1d:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f20:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f24:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f28:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f2c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f30:	77 de                	ja     800f10 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f36:	74 31                	je     800f69 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f38:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f41:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f44:	eb 16                	jmp    800f5c <memcpy+0x66>
			*d8++ = *s8++;
  800f46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f49:	8d 50 01             	lea    0x1(%eax),%edx
  800f4c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f52:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f55:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f58:	8a 12                	mov    (%edx),%dl
  800f5a:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f62:	89 55 10             	mov    %edx,0x10(%ebp)
  800f65:	85 c0                	test   %eax,%eax
  800f67:	75 dd                	jne    800f46 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f6c:	c9                   	leave  
  800f6d:	c3                   	ret    

00800f6e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f6e:	55                   	push   %ebp
  800f6f:	89 e5                	mov    %esp,%ebp
  800f71:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f83:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f86:	73 50                	jae    800fd8 <memmove+0x6a>
  800f88:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8e:	01 d0                	add    %edx,%eax
  800f90:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f93:	76 43                	jbe    800fd8 <memmove+0x6a>
		s += n;
  800f95:	8b 45 10             	mov    0x10(%ebp),%eax
  800f98:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fa1:	eb 10                	jmp    800fb3 <memmove+0x45>
			*--d = *--s;
  800fa3:	ff 4d f8             	decl   -0x8(%ebp)
  800fa6:	ff 4d fc             	decl   -0x4(%ebp)
  800fa9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fac:	8a 10                	mov    (%eax),%dl
  800fae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb9:	89 55 10             	mov    %edx,0x10(%ebp)
  800fbc:	85 c0                	test   %eax,%eax
  800fbe:	75 e3                	jne    800fa3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fc0:	eb 23                	jmp    800fe5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc5:	8d 50 01             	lea    0x1(%eax),%edx
  800fc8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fcb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fce:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fd1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fd4:	8a 12                	mov    (%edx),%dl
  800fd6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fd8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fde:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe1:	85 c0                	test   %eax,%eax
  800fe3:	75 dd                	jne    800fc2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fe8:	c9                   	leave  
  800fe9:	c3                   	ret    

00800fea <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ffc:	eb 2a                	jmp    801028 <memcmp+0x3e>
		if (*s1 != *s2)
  800ffe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801001:	8a 10                	mov    (%eax),%dl
  801003:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	38 c2                	cmp    %al,%dl
  80100a:	74 16                	je     801022 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80100c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100f:	8a 00                	mov    (%eax),%al
  801011:	0f b6 d0             	movzbl %al,%edx
  801014:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801017:	8a 00                	mov    (%eax),%al
  801019:	0f b6 c0             	movzbl %al,%eax
  80101c:	29 c2                	sub    %eax,%edx
  80101e:	89 d0                	mov    %edx,%eax
  801020:	eb 18                	jmp    80103a <memcmp+0x50>
		s1++, s2++;
  801022:	ff 45 fc             	incl   -0x4(%ebp)
  801025:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801028:	8b 45 10             	mov    0x10(%ebp),%eax
  80102b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80102e:	89 55 10             	mov    %edx,0x10(%ebp)
  801031:	85 c0                	test   %eax,%eax
  801033:	75 c9                	jne    800ffe <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801035:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80103a:	c9                   	leave  
  80103b:	c3                   	ret    

0080103c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801042:	8b 55 08             	mov    0x8(%ebp),%edx
  801045:	8b 45 10             	mov    0x10(%ebp),%eax
  801048:	01 d0                	add    %edx,%eax
  80104a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80104d:	eb 15                	jmp    801064 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
  801052:	8a 00                	mov    (%eax),%al
  801054:	0f b6 d0             	movzbl %al,%edx
  801057:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105a:	0f b6 c0             	movzbl %al,%eax
  80105d:	39 c2                	cmp    %eax,%edx
  80105f:	74 0d                	je     80106e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801061:	ff 45 08             	incl   0x8(%ebp)
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80106a:	72 e3                	jb     80104f <memfind+0x13>
  80106c:	eb 01                	jmp    80106f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80106e:	90                   	nop
	return (void *) s;
  80106f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801072:	c9                   	leave  
  801073:	c3                   	ret    

00801074 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801074:	55                   	push   %ebp
  801075:	89 e5                	mov    %esp,%ebp
  801077:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80107a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801081:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801088:	eb 03                	jmp    80108d <strtol+0x19>
		s++;
  80108a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	8a 00                	mov    (%eax),%al
  801092:	3c 20                	cmp    $0x20,%al
  801094:	74 f4                	je     80108a <strtol+0x16>
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8a 00                	mov    (%eax),%al
  80109b:	3c 09                	cmp    $0x9,%al
  80109d:	74 eb                	je     80108a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	8a 00                	mov    (%eax),%al
  8010a4:	3c 2b                	cmp    $0x2b,%al
  8010a6:	75 05                	jne    8010ad <strtol+0x39>
		s++;
  8010a8:	ff 45 08             	incl   0x8(%ebp)
  8010ab:	eb 13                	jmp    8010c0 <strtol+0x4c>
	else if (*s == '-')
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	8a 00                	mov    (%eax),%al
  8010b2:	3c 2d                	cmp    $0x2d,%al
  8010b4:	75 0a                	jne    8010c0 <strtol+0x4c>
		s++, neg = 1;
  8010b6:	ff 45 08             	incl   0x8(%ebp)
  8010b9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010c4:	74 06                	je     8010cc <strtol+0x58>
  8010c6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010ca:	75 20                	jne    8010ec <strtol+0x78>
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	3c 30                	cmp    $0x30,%al
  8010d3:	75 17                	jne    8010ec <strtol+0x78>
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	40                   	inc    %eax
  8010d9:	8a 00                	mov    (%eax),%al
  8010db:	3c 78                	cmp    $0x78,%al
  8010dd:	75 0d                	jne    8010ec <strtol+0x78>
		s += 2, base = 16;
  8010df:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010e3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010ea:	eb 28                	jmp    801114 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f0:	75 15                	jne    801107 <strtol+0x93>
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	8a 00                	mov    (%eax),%al
  8010f7:	3c 30                	cmp    $0x30,%al
  8010f9:	75 0c                	jne    801107 <strtol+0x93>
		s++, base = 8;
  8010fb:	ff 45 08             	incl   0x8(%ebp)
  8010fe:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801105:	eb 0d                	jmp    801114 <strtol+0xa0>
	else if (base == 0)
  801107:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110b:	75 07                	jne    801114 <strtol+0xa0>
		base = 10;
  80110d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	8a 00                	mov    (%eax),%al
  801119:	3c 2f                	cmp    $0x2f,%al
  80111b:	7e 19                	jle    801136 <strtol+0xc2>
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	8a 00                	mov    (%eax),%al
  801122:	3c 39                	cmp    $0x39,%al
  801124:	7f 10                	jg     801136 <strtol+0xc2>
			dig = *s - '0';
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	0f be c0             	movsbl %al,%eax
  80112e:	83 e8 30             	sub    $0x30,%eax
  801131:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801134:	eb 42                	jmp    801178 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	8a 00                	mov    (%eax),%al
  80113b:	3c 60                	cmp    $0x60,%al
  80113d:	7e 19                	jle    801158 <strtol+0xe4>
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	3c 7a                	cmp    $0x7a,%al
  801146:	7f 10                	jg     801158 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	0f be c0             	movsbl %al,%eax
  801150:	83 e8 57             	sub    $0x57,%eax
  801153:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801156:	eb 20                	jmp    801178 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	8a 00                	mov    (%eax),%al
  80115d:	3c 40                	cmp    $0x40,%al
  80115f:	7e 39                	jle    80119a <strtol+0x126>
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	8a 00                	mov    (%eax),%al
  801166:	3c 5a                	cmp    $0x5a,%al
  801168:	7f 30                	jg     80119a <strtol+0x126>
			dig = *s - 'A' + 10;
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
  80116d:	8a 00                	mov    (%eax),%al
  80116f:	0f be c0             	movsbl %al,%eax
  801172:	83 e8 37             	sub    $0x37,%eax
  801175:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80117b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80117e:	7d 19                	jge    801199 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801180:	ff 45 08             	incl   0x8(%ebp)
  801183:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801186:	0f af 45 10          	imul   0x10(%ebp),%eax
  80118a:	89 c2                	mov    %eax,%edx
  80118c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118f:	01 d0                	add    %edx,%eax
  801191:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801194:	e9 7b ff ff ff       	jmp    801114 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801199:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80119a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80119e:	74 08                	je     8011a8 <strtol+0x134>
		*endptr = (char *) s;
  8011a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011ac:	74 07                	je     8011b5 <strtol+0x141>
  8011ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b1:	f7 d8                	neg    %eax
  8011b3:	eb 03                	jmp    8011b8 <strtol+0x144>
  8011b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011b8:	c9                   	leave  
  8011b9:	c3                   	ret    

008011ba <ltostr>:

void
ltostr(long value, char *str)
{
  8011ba:	55                   	push   %ebp
  8011bb:	89 e5                	mov    %esp,%ebp
  8011bd:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011c7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d2:	79 13                	jns    8011e7 <ltostr+0x2d>
	{
		neg = 1;
  8011d4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011de:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011e1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011e4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011ef:	99                   	cltd   
  8011f0:	f7 f9                	idiv   %ecx
  8011f2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f8:	8d 50 01             	lea    0x1(%eax),%edx
  8011fb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011fe:	89 c2                	mov    %eax,%edx
  801200:	8b 45 0c             	mov    0xc(%ebp),%eax
  801203:	01 d0                	add    %edx,%eax
  801205:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801208:	83 c2 30             	add    $0x30,%edx
  80120b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80120d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801210:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801215:	f7 e9                	imul   %ecx
  801217:	c1 fa 02             	sar    $0x2,%edx
  80121a:	89 c8                	mov    %ecx,%eax
  80121c:	c1 f8 1f             	sar    $0x1f,%eax
  80121f:	29 c2                	sub    %eax,%edx
  801221:	89 d0                	mov    %edx,%eax
  801223:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801226:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80122a:	75 bb                	jne    8011e7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80122c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801233:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801236:	48                   	dec    %eax
  801237:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80123a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80123e:	74 3d                	je     80127d <ltostr+0xc3>
		start = 1 ;
  801240:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801247:	eb 34                	jmp    80127d <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801249:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80124c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124f:	01 d0                	add    %edx,%eax
  801251:	8a 00                	mov    (%eax),%al
  801253:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801256:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801259:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125c:	01 c2                	add    %eax,%edx
  80125e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801261:	8b 45 0c             	mov    0xc(%ebp),%eax
  801264:	01 c8                	add    %ecx,%eax
  801266:	8a 00                	mov    (%eax),%al
  801268:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80126a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80126d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801270:	01 c2                	add    %eax,%edx
  801272:	8a 45 eb             	mov    -0x15(%ebp),%al
  801275:	88 02                	mov    %al,(%edx)
		start++ ;
  801277:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80127a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80127d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801280:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801283:	7c c4                	jl     801249 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801285:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801288:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128b:	01 d0                	add    %edx,%eax
  80128d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801290:	90                   	nop
  801291:	c9                   	leave  
  801292:	c3                   	ret    

00801293 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801299:	ff 75 08             	pushl  0x8(%ebp)
  80129c:	e8 c4 f9 ff ff       	call   800c65 <strlen>
  8012a1:	83 c4 04             	add    $0x4,%esp
  8012a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012a7:	ff 75 0c             	pushl  0xc(%ebp)
  8012aa:	e8 b6 f9 ff ff       	call   800c65 <strlen>
  8012af:	83 c4 04             	add    $0x4,%esp
  8012b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012c3:	eb 17                	jmp    8012dc <strcconcat+0x49>
		final[s] = str1[s] ;
  8012c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cb:	01 c2                	add    %eax,%edx
  8012cd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	01 c8                	add    %ecx,%eax
  8012d5:	8a 00                	mov    (%eax),%al
  8012d7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012d9:	ff 45 fc             	incl   -0x4(%ebp)
  8012dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012df:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012e2:	7c e1                	jl     8012c5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012e4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012eb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012f2:	eb 1f                	jmp    801313 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f7:	8d 50 01             	lea    0x1(%eax),%edx
  8012fa:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012fd:	89 c2                	mov    %eax,%edx
  8012ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801302:	01 c2                	add    %eax,%edx
  801304:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801307:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130a:	01 c8                	add    %ecx,%eax
  80130c:	8a 00                	mov    (%eax),%al
  80130e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801310:	ff 45 f8             	incl   -0x8(%ebp)
  801313:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801316:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801319:	7c d9                	jl     8012f4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80131b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80131e:	8b 45 10             	mov    0x10(%ebp),%eax
  801321:	01 d0                	add    %edx,%eax
  801323:	c6 00 00             	movb   $0x0,(%eax)
}
  801326:	90                   	nop
  801327:	c9                   	leave  
  801328:	c3                   	ret    

00801329 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801329:	55                   	push   %ebp
  80132a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80132c:	8b 45 14             	mov    0x14(%ebp),%eax
  80132f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801335:	8b 45 14             	mov    0x14(%ebp),%eax
  801338:	8b 00                	mov    (%eax),%eax
  80133a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801341:	8b 45 10             	mov    0x10(%ebp),%eax
  801344:	01 d0                	add    %edx,%eax
  801346:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80134c:	eb 0c                	jmp    80135a <strsplit+0x31>
			*string++ = 0;
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	8d 50 01             	lea    0x1(%eax),%edx
  801354:	89 55 08             	mov    %edx,0x8(%ebp)
  801357:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80135a:	8b 45 08             	mov    0x8(%ebp),%eax
  80135d:	8a 00                	mov    (%eax),%al
  80135f:	84 c0                	test   %al,%al
  801361:	74 18                	je     80137b <strsplit+0x52>
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	8a 00                	mov    (%eax),%al
  801368:	0f be c0             	movsbl %al,%eax
  80136b:	50                   	push   %eax
  80136c:	ff 75 0c             	pushl  0xc(%ebp)
  80136f:	e8 83 fa ff ff       	call   800df7 <strchr>
  801374:	83 c4 08             	add    $0x8,%esp
  801377:	85 c0                	test   %eax,%eax
  801379:	75 d3                	jne    80134e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	8a 00                	mov    (%eax),%al
  801380:	84 c0                	test   %al,%al
  801382:	74 5a                	je     8013de <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801384:	8b 45 14             	mov    0x14(%ebp),%eax
  801387:	8b 00                	mov    (%eax),%eax
  801389:	83 f8 0f             	cmp    $0xf,%eax
  80138c:	75 07                	jne    801395 <strsplit+0x6c>
		{
			return 0;
  80138e:	b8 00 00 00 00       	mov    $0x0,%eax
  801393:	eb 66                	jmp    8013fb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801395:	8b 45 14             	mov    0x14(%ebp),%eax
  801398:	8b 00                	mov    (%eax),%eax
  80139a:	8d 48 01             	lea    0x1(%eax),%ecx
  80139d:	8b 55 14             	mov    0x14(%ebp),%edx
  8013a0:	89 0a                	mov    %ecx,(%edx)
  8013a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ac:	01 c2                	add    %eax,%edx
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013b3:	eb 03                	jmp    8013b8 <strsplit+0x8f>
			string++;
  8013b5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	84 c0                	test   %al,%al
  8013bf:	74 8b                	je     80134c <strsplit+0x23>
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	8a 00                	mov    (%eax),%al
  8013c6:	0f be c0             	movsbl %al,%eax
  8013c9:	50                   	push   %eax
  8013ca:	ff 75 0c             	pushl  0xc(%ebp)
  8013cd:	e8 25 fa ff ff       	call   800df7 <strchr>
  8013d2:	83 c4 08             	add    $0x8,%esp
  8013d5:	85 c0                	test   %eax,%eax
  8013d7:	74 dc                	je     8013b5 <strsplit+0x8c>
			string++;
	}
  8013d9:	e9 6e ff ff ff       	jmp    80134c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013de:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013df:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e2:	8b 00                	mov    (%eax),%eax
  8013e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ee:	01 d0                	add    %edx,%eax
  8013f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013f6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013fb:	c9                   	leave  
  8013fc:	c3                   	ret    

008013fd <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
  801400:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801409:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801410:	eb 4a                	jmp    80145c <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801412:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
  801418:	01 c2                	add    %eax,%edx
  80141a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80141d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801420:	01 c8                	add    %ecx,%eax
  801422:	8a 00                	mov    (%eax),%al
  801424:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801426:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801429:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142c:	01 d0                	add    %edx,%eax
  80142e:	8a 00                	mov    (%eax),%al
  801430:	3c 40                	cmp    $0x40,%al
  801432:	7e 25                	jle    801459 <str2lower+0x5c>
  801434:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801437:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143a:	01 d0                	add    %edx,%eax
  80143c:	8a 00                	mov    (%eax),%al
  80143e:	3c 5a                	cmp    $0x5a,%al
  801440:	7f 17                	jg     801459 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801442:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	01 d0                	add    %edx,%eax
  80144a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80144d:	8b 55 08             	mov    0x8(%ebp),%edx
  801450:	01 ca                	add    %ecx,%edx
  801452:	8a 12                	mov    (%edx),%dl
  801454:	83 c2 20             	add    $0x20,%edx
  801457:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801459:	ff 45 fc             	incl   -0x4(%ebp)
  80145c:	ff 75 0c             	pushl  0xc(%ebp)
  80145f:	e8 01 f8 ff ff       	call   800c65 <strlen>
  801464:	83 c4 04             	add    $0x4,%esp
  801467:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80146a:	7f a6                	jg     801412 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80146c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80146f:	c9                   	leave  
  801470:	c3                   	ret    

00801471 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	57                   	push   %edi
  801475:	56                   	push   %esi
  801476:	53                   	push   %ebx
  801477:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80147a:	8b 45 08             	mov    0x8(%ebp),%eax
  80147d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801480:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801483:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801486:	8b 7d 18             	mov    0x18(%ebp),%edi
  801489:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80148c:	cd 30                	int    $0x30
  80148e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801491:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801494:	83 c4 10             	add    $0x10,%esp
  801497:	5b                   	pop    %ebx
  801498:	5e                   	pop    %esi
  801499:	5f                   	pop    %edi
  80149a:	5d                   	pop    %ebp
  80149b:	c3                   	ret    

0080149c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	83 ec 04             	sub    $0x4,%esp
  8014a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8014a8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014ab:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	6a 00                	push   $0x0
  8014b4:	51                   	push   %ecx
  8014b5:	52                   	push   %edx
  8014b6:	ff 75 0c             	pushl  0xc(%ebp)
  8014b9:	50                   	push   %eax
  8014ba:	6a 00                	push   $0x0
  8014bc:	e8 b0 ff ff ff       	call   801471 <syscall>
  8014c1:	83 c4 18             	add    $0x18,%esp
}
  8014c4:	90                   	nop
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 02                	push   $0x2
  8014d6:	e8 96 ff ff ff       	call   801471 <syscall>
  8014db:	83 c4 18             	add    $0x18,%esp
}
  8014de:	c9                   	leave  
  8014df:	c3                   	ret    

008014e0 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 03                	push   $0x3
  8014ef:	e8 7d ff ff ff       	call   801471 <syscall>
  8014f4:	83 c4 18             	add    $0x18,%esp
}
  8014f7:	90                   	nop
  8014f8:	c9                   	leave  
  8014f9:	c3                   	ret    

008014fa <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	6a 04                	push   $0x4
  801509:	e8 63 ff ff ff       	call   801471 <syscall>
  80150e:	83 c4 18             	add    $0x18,%esp
}
  801511:	90                   	nop
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801517:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151a:	8b 45 08             	mov    0x8(%ebp),%eax
  80151d:	6a 00                	push   $0x0
  80151f:	6a 00                	push   $0x0
  801521:	6a 00                	push   $0x0
  801523:	52                   	push   %edx
  801524:	50                   	push   %eax
  801525:	6a 08                	push   $0x8
  801527:	e8 45 ff ff ff       	call   801471 <syscall>
  80152c:	83 c4 18             	add    $0x18,%esp
}
  80152f:	c9                   	leave  
  801530:	c3                   	ret    

00801531 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801531:	55                   	push   %ebp
  801532:	89 e5                	mov    %esp,%ebp
  801534:	56                   	push   %esi
  801535:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801536:	8b 75 18             	mov    0x18(%ebp),%esi
  801539:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80153c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80153f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801542:	8b 45 08             	mov    0x8(%ebp),%eax
  801545:	56                   	push   %esi
  801546:	53                   	push   %ebx
  801547:	51                   	push   %ecx
  801548:	52                   	push   %edx
  801549:	50                   	push   %eax
  80154a:	6a 09                	push   $0x9
  80154c:	e8 20 ff ff ff       	call   801471 <syscall>
  801551:	83 c4 18             	add    $0x18,%esp
}
  801554:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801557:	5b                   	pop    %ebx
  801558:	5e                   	pop    %esi
  801559:	5d                   	pop    %ebp
  80155a:	c3                   	ret    

0080155b <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	ff 75 08             	pushl  0x8(%ebp)
  801569:	6a 0a                	push   $0xa
  80156b:	e8 01 ff ff ff       	call   801471 <syscall>
  801570:	83 c4 18             	add    $0x18,%esp
}
  801573:	c9                   	leave  
  801574:	c3                   	ret    

00801575 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	ff 75 0c             	pushl  0xc(%ebp)
  801581:	ff 75 08             	pushl  0x8(%ebp)
  801584:	6a 0b                	push   $0xb
  801586:	e8 e6 fe ff ff       	call   801471 <syscall>
  80158b:	83 c4 18             	add    $0x18,%esp
}
  80158e:	c9                   	leave  
  80158f:	c3                   	ret    

00801590 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 0c                	push   $0xc
  80159f:	e8 cd fe ff ff       	call   801471 <syscall>
  8015a4:	83 c4 18             	add    $0x18,%esp
}
  8015a7:	c9                   	leave  
  8015a8:	c3                   	ret    

008015a9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 0d                	push   $0xd
  8015b8:	e8 b4 fe ff ff       	call   801471 <syscall>
  8015bd:	83 c4 18             	add    $0x18,%esp
}
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    

008015c2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 0e                	push   $0xe
  8015d1:	e8 9b fe ff ff       	call   801471 <syscall>
  8015d6:	83 c4 18             	add    $0x18,%esp
}
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    

008015db <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 0f                	push   $0xf
  8015ea:	e8 82 fe ff ff       	call   801471 <syscall>
  8015ef:	83 c4 18             	add    $0x18,%esp
}
  8015f2:	c9                   	leave  
  8015f3:	c3                   	ret    

008015f4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	ff 75 08             	pushl  0x8(%ebp)
  801602:	6a 10                	push   $0x10
  801604:	e8 68 fe ff ff       	call   801471 <syscall>
  801609:	83 c4 18             	add    $0x18,%esp
}
  80160c:	c9                   	leave  
  80160d:	c3                   	ret    

0080160e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 11                	push   $0x11
  80161d:	e8 4f fe ff ff       	call   801471 <syscall>
  801622:	83 c4 18             	add    $0x18,%esp
}
  801625:	90                   	nop
  801626:	c9                   	leave  
  801627:	c3                   	ret    

00801628 <sys_cputc>:

void
sys_cputc(const char c)
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
  80162b:	83 ec 04             	sub    $0x4,%esp
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
  801631:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801634:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	50                   	push   %eax
  801641:	6a 01                	push   $0x1
  801643:	e8 29 fe ff ff       	call   801471 <syscall>
  801648:	83 c4 18             	add    $0x18,%esp
}
  80164b:	90                   	nop
  80164c:	c9                   	leave  
  80164d:	c3                   	ret    

0080164e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 14                	push   $0x14
  80165d:	e8 0f fe ff ff       	call   801471 <syscall>
  801662:	83 c4 18             	add    $0x18,%esp
}
  801665:	90                   	nop
  801666:	c9                   	leave  
  801667:	c3                   	ret    

00801668 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
  80166b:	83 ec 04             	sub    $0x4,%esp
  80166e:	8b 45 10             	mov    0x10(%ebp),%eax
  801671:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801674:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801677:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80167b:	8b 45 08             	mov    0x8(%ebp),%eax
  80167e:	6a 00                	push   $0x0
  801680:	51                   	push   %ecx
  801681:	52                   	push   %edx
  801682:	ff 75 0c             	pushl  0xc(%ebp)
  801685:	50                   	push   %eax
  801686:	6a 15                	push   $0x15
  801688:	e8 e4 fd ff ff       	call   801471 <syscall>
  80168d:	83 c4 18             	add    $0x18,%esp
}
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801695:	8b 55 0c             	mov    0xc(%ebp),%edx
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	52                   	push   %edx
  8016a2:	50                   	push   %eax
  8016a3:	6a 16                	push   $0x16
  8016a5:	e8 c7 fd ff ff       	call   801471 <syscall>
  8016aa:	83 c4 18             	add    $0x18,%esp
}
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016b2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	51                   	push   %ecx
  8016c0:	52                   	push   %edx
  8016c1:	50                   	push   %eax
  8016c2:	6a 17                	push   $0x17
  8016c4:	e8 a8 fd ff ff       	call   801471 <syscall>
  8016c9:	83 c4 18             	add    $0x18,%esp
}
  8016cc:	c9                   	leave  
  8016cd:	c3                   	ret    

008016ce <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	52                   	push   %edx
  8016de:	50                   	push   %eax
  8016df:	6a 18                	push   $0x18
  8016e1:	e8 8b fd ff ff       	call   801471 <syscall>
  8016e6:	83 c4 18             	add    $0x18,%esp
}
  8016e9:	c9                   	leave  
  8016ea:	c3                   	ret    

008016eb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f1:	6a 00                	push   $0x0
  8016f3:	ff 75 14             	pushl  0x14(%ebp)
  8016f6:	ff 75 10             	pushl  0x10(%ebp)
  8016f9:	ff 75 0c             	pushl  0xc(%ebp)
  8016fc:	50                   	push   %eax
  8016fd:	6a 19                	push   $0x19
  8016ff:	e8 6d fd ff ff       	call   801471 <syscall>
  801704:	83 c4 18             	add    $0x18,%esp
}
  801707:	c9                   	leave  
  801708:	c3                   	ret    

00801709 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80170c:	8b 45 08             	mov    0x8(%ebp),%eax
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	50                   	push   %eax
  801718:	6a 1a                	push   $0x1a
  80171a:	e8 52 fd ff ff       	call   801471 <syscall>
  80171f:	83 c4 18             	add    $0x18,%esp
}
  801722:	90                   	nop
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801728:	8b 45 08             	mov    0x8(%ebp),%eax
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	50                   	push   %eax
  801734:	6a 1b                	push   $0x1b
  801736:	e8 36 fd ff ff       	call   801471 <syscall>
  80173b:	83 c4 18             	add    $0x18,%esp
}
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 05                	push   $0x5
  80174f:	e8 1d fd ff ff       	call   801471 <syscall>
  801754:	83 c4 18             	add    $0x18,%esp
}
  801757:	c9                   	leave  
  801758:	c3                   	ret    

00801759 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 06                	push   $0x6
  801768:	e8 04 fd ff ff       	call   801471 <syscall>
  80176d:	83 c4 18             	add    $0x18,%esp
}
  801770:	c9                   	leave  
  801771:	c3                   	ret    

00801772 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 07                	push   $0x7
  801781:	e8 eb fc ff ff       	call   801471 <syscall>
  801786:	83 c4 18             	add    $0x18,%esp
}
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <sys_exit_env>:


void sys_exit_env(void)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 1c                	push   $0x1c
  80179a:	e8 d2 fc ff ff       	call   801471 <syscall>
  80179f:	83 c4 18             	add    $0x18,%esp
}
  8017a2:	90                   	nop
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
  8017a8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017ab:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017ae:	8d 50 04             	lea    0x4(%eax),%edx
  8017b1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	52                   	push   %edx
  8017bb:	50                   	push   %eax
  8017bc:	6a 1d                	push   $0x1d
  8017be:	e8 ae fc ff ff       	call   801471 <syscall>
  8017c3:	83 c4 18             	add    $0x18,%esp
	return result;
  8017c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017cf:	89 01                	mov    %eax,(%ecx)
  8017d1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	c9                   	leave  
  8017d8:	c2 04 00             	ret    $0x4

008017db <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	ff 75 10             	pushl  0x10(%ebp)
  8017e5:	ff 75 0c             	pushl  0xc(%ebp)
  8017e8:	ff 75 08             	pushl  0x8(%ebp)
  8017eb:	6a 13                	push   $0x13
  8017ed:	e8 7f fc ff ff       	call   801471 <syscall>
  8017f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f5:	90                   	nop
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 1e                	push   $0x1e
  801807:	e8 65 fc ff ff       	call   801471 <syscall>
  80180c:	83 c4 18             	add    $0x18,%esp
}
  80180f:	c9                   	leave  
  801810:	c3                   	ret    

00801811 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
  801814:	83 ec 04             	sub    $0x4,%esp
  801817:	8b 45 08             	mov    0x8(%ebp),%eax
  80181a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80181d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	50                   	push   %eax
  80182a:	6a 1f                	push   $0x1f
  80182c:	e8 40 fc ff ff       	call   801471 <syscall>
  801831:	83 c4 18             	add    $0x18,%esp
	return ;
  801834:	90                   	nop
}
  801835:	c9                   	leave  
  801836:	c3                   	ret    

00801837 <rsttst>:
void rsttst()
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 21                	push   $0x21
  801846:	e8 26 fc ff ff       	call   801471 <syscall>
  80184b:	83 c4 18             	add    $0x18,%esp
	return ;
  80184e:	90                   	nop
}
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	83 ec 04             	sub    $0x4,%esp
  801857:	8b 45 14             	mov    0x14(%ebp),%eax
  80185a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80185d:	8b 55 18             	mov    0x18(%ebp),%edx
  801860:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801864:	52                   	push   %edx
  801865:	50                   	push   %eax
  801866:	ff 75 10             	pushl  0x10(%ebp)
  801869:	ff 75 0c             	pushl  0xc(%ebp)
  80186c:	ff 75 08             	pushl  0x8(%ebp)
  80186f:	6a 20                	push   $0x20
  801871:	e8 fb fb ff ff       	call   801471 <syscall>
  801876:	83 c4 18             	add    $0x18,%esp
	return ;
  801879:	90                   	nop
}
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <chktst>:
void chktst(uint32 n)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	ff 75 08             	pushl  0x8(%ebp)
  80188a:	6a 22                	push   $0x22
  80188c:	e8 e0 fb ff ff       	call   801471 <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
	return ;
  801894:	90                   	nop
}
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <inctst>:

void inctst()
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 23                	push   $0x23
  8018a6:	e8 c6 fb ff ff       	call   801471 <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ae:	90                   	nop
}
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <gettst>:
uint32 gettst()
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 24                	push   $0x24
  8018c0:	e8 ac fb ff ff       	call   801471 <syscall>
  8018c5:	83 c4 18             	add    $0x18,%esp
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 25                	push   $0x25
  8018d9:	e8 93 fb ff ff       	call   801471 <syscall>
  8018de:	83 c4 18             	add    $0x18,%esp
  8018e1:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8018e6:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	ff 75 08             	pushl  0x8(%ebp)
  801903:	6a 26                	push   $0x26
  801905:	e8 67 fb ff ff       	call   801471 <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
	return ;
  80190d:	90                   	nop
}
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
  801913:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801914:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801917:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80191a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	6a 00                	push   $0x0
  801922:	53                   	push   %ebx
  801923:	51                   	push   %ecx
  801924:	52                   	push   %edx
  801925:	50                   	push   %eax
  801926:	6a 27                	push   $0x27
  801928:	e8 44 fb ff ff       	call   801471 <syscall>
  80192d:	83 c4 18             	add    $0x18,%esp
}
  801930:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801938:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	52                   	push   %edx
  801945:	50                   	push   %eax
  801946:	6a 28                	push   $0x28
  801948:	e8 24 fb ff ff       	call   801471 <syscall>
  80194d:	83 c4 18             	add    $0x18,%esp
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801955:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801958:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195b:	8b 45 08             	mov    0x8(%ebp),%eax
  80195e:	6a 00                	push   $0x0
  801960:	51                   	push   %ecx
  801961:	ff 75 10             	pushl  0x10(%ebp)
  801964:	52                   	push   %edx
  801965:	50                   	push   %eax
  801966:	6a 29                	push   $0x29
  801968:	e8 04 fb ff ff       	call   801471 <syscall>
  80196d:	83 c4 18             	add    $0x18,%esp
}
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	ff 75 10             	pushl  0x10(%ebp)
  80197c:	ff 75 0c             	pushl  0xc(%ebp)
  80197f:	ff 75 08             	pushl  0x8(%ebp)
  801982:	6a 12                	push   $0x12
  801984:	e8 e8 fa ff ff       	call   801471 <syscall>
  801989:	83 c4 18             	add    $0x18,%esp
	return ;
  80198c:	90                   	nop
}
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801992:	8b 55 0c             	mov    0xc(%ebp),%edx
  801995:	8b 45 08             	mov    0x8(%ebp),%eax
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	52                   	push   %edx
  80199f:	50                   	push   %eax
  8019a0:	6a 2a                	push   $0x2a
  8019a2:	e8 ca fa ff ff       	call   801471 <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
	return;
  8019aa:	90                   	nop
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 2b                	push   $0x2b
  8019bc:	e8 b0 fa ff ff       	call   801471 <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	ff 75 0c             	pushl  0xc(%ebp)
  8019d2:	ff 75 08             	pushl  0x8(%ebp)
  8019d5:	6a 2d                	push   $0x2d
  8019d7:	e8 95 fa ff ff       	call   801471 <syscall>
  8019dc:	83 c4 18             	add    $0x18,%esp
	return;
  8019df:	90                   	nop
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	ff 75 0c             	pushl  0xc(%ebp)
  8019ee:	ff 75 08             	pushl  0x8(%ebp)
  8019f1:	6a 2c                	push   $0x2c
  8019f3:	e8 79 fa ff ff       	call   801471 <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
	return ;
  8019fb:	90                   	nop
}
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801a04:	83 ec 04             	sub    $0x4,%esp
  801a07:	68 1c 24 80 00       	push   $0x80241c
  801a0c:	68 25 01 00 00       	push   $0x125
  801a11:	68 4f 24 80 00       	push   $0x80244f
  801a16:	e8 3c 00 00 00       	call   801a57 <_panic>

00801a1b <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
  801a1e:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801a21:	8b 45 08             	mov    0x8(%ebp),%eax
  801a24:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801a27:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801a2b:	83 ec 0c             	sub    $0xc,%esp
  801a2e:	50                   	push   %eax
  801a2f:	e8 f4 fb ff ff       	call   801628 <sys_cputc>
  801a34:	83 c4 10             	add    $0x10,%esp
}
  801a37:	90                   	nop
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <getchar>:


int
getchar(void)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
  801a3d:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801a40:	e8 82 fa ff ff       	call   8014c7 <sys_cgetc>
  801a45:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <iscons>:

int iscons(int fdnum)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801a50:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a55:	5d                   	pop    %ebp
  801a56:	c3                   	ret    

00801a57 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801a5d:	8d 45 10             	lea    0x10(%ebp),%eax
  801a60:	83 c0 04             	add    $0x4,%eax
  801a63:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801a66:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801a6b:	85 c0                	test   %eax,%eax
  801a6d:	74 16                	je     801a85 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801a6f:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801a74:	83 ec 08             	sub    $0x8,%esp
  801a77:	50                   	push   %eax
  801a78:	68 60 24 80 00       	push   $0x802460
  801a7d:	e8 02 e9 ff ff       	call   800384 <cprintf>
  801a82:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801a85:	a1 04 30 80 00       	mov    0x803004,%eax
  801a8a:	83 ec 0c             	sub    $0xc,%esp
  801a8d:	ff 75 0c             	pushl  0xc(%ebp)
  801a90:	ff 75 08             	pushl  0x8(%ebp)
  801a93:	50                   	push   %eax
  801a94:	68 68 24 80 00       	push   $0x802468
  801a99:	6a 74                	push   $0x74
  801a9b:	e8 11 e9 ff ff       	call   8003b1 <cprintf_colored>
  801aa0:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801aa3:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa6:	83 ec 08             	sub    $0x8,%esp
  801aa9:	ff 75 f4             	pushl  -0xc(%ebp)
  801aac:	50                   	push   %eax
  801aad:	e8 63 e8 ff ff       	call   800315 <vcprintf>
  801ab2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801ab5:	83 ec 08             	sub    $0x8,%esp
  801ab8:	6a 00                	push   $0x0
  801aba:	68 90 24 80 00       	push   $0x802490
  801abf:	e8 51 e8 ff ff       	call   800315 <vcprintf>
  801ac4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801ac7:	e8 ca e7 ff ff       	call   800296 <exit>

	// should not return here
	while (1) ;
  801acc:	eb fe                	jmp    801acc <_panic+0x75>

00801ace <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
  801ad1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801ad4:	a1 20 30 80 00       	mov    0x803020,%eax
  801ad9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801adf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae2:	39 c2                	cmp    %eax,%edx
  801ae4:	74 14                	je     801afa <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801ae6:	83 ec 04             	sub    $0x4,%esp
  801ae9:	68 94 24 80 00       	push   $0x802494
  801aee:	6a 26                	push   $0x26
  801af0:	68 e0 24 80 00       	push   $0x8024e0
  801af5:	e8 5d ff ff ff       	call   801a57 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801afa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801b01:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801b08:	e9 c5 00 00 00       	jmp    801bd2 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b10:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b17:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1a:	01 d0                	add    %edx,%eax
  801b1c:	8b 00                	mov    (%eax),%eax
  801b1e:	85 c0                	test   %eax,%eax
  801b20:	75 08                	jne    801b2a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801b22:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801b25:	e9 a5 00 00 00       	jmp    801bcf <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801b2a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b31:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801b38:	eb 69                	jmp    801ba3 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801b3a:	a1 20 30 80 00       	mov    0x803020,%eax
  801b3f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801b45:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b48:	89 d0                	mov    %edx,%eax
  801b4a:	01 c0                	add    %eax,%eax
  801b4c:	01 d0                	add    %edx,%eax
  801b4e:	c1 e0 03             	shl    $0x3,%eax
  801b51:	01 c8                	add    %ecx,%eax
  801b53:	8a 40 04             	mov    0x4(%eax),%al
  801b56:	84 c0                	test   %al,%al
  801b58:	75 46                	jne    801ba0 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801b5a:	a1 20 30 80 00       	mov    0x803020,%eax
  801b5f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801b65:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b68:	89 d0                	mov    %edx,%eax
  801b6a:	01 c0                	add    %eax,%eax
  801b6c:	01 d0                	add    %edx,%eax
  801b6e:	c1 e0 03             	shl    $0x3,%eax
  801b71:	01 c8                	add    %ecx,%eax
  801b73:	8b 00                	mov    (%eax),%eax
  801b75:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b78:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b80:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b85:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8f:	01 c8                	add    %ecx,%eax
  801b91:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801b93:	39 c2                	cmp    %eax,%edx
  801b95:	75 09                	jne    801ba0 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801b97:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801b9e:	eb 15                	jmp    801bb5 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ba0:	ff 45 e8             	incl   -0x18(%ebp)
  801ba3:	a1 20 30 80 00       	mov    0x803020,%eax
  801ba8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801bae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bb1:	39 c2                	cmp    %eax,%edx
  801bb3:	77 85                	ja     801b3a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801bb5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bb9:	75 14                	jne    801bcf <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801bbb:	83 ec 04             	sub    $0x4,%esp
  801bbe:	68 ec 24 80 00       	push   $0x8024ec
  801bc3:	6a 3a                	push   $0x3a
  801bc5:	68 e0 24 80 00       	push   $0x8024e0
  801bca:	e8 88 fe ff ff       	call   801a57 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801bcf:	ff 45 f0             	incl   -0x10(%ebp)
  801bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801bd8:	0f 8c 2f ff ff ff    	jl     801b0d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801bde:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801be5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801bec:	eb 26                	jmp    801c14 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801bee:	a1 20 30 80 00       	mov    0x803020,%eax
  801bf3:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801bf9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bfc:	89 d0                	mov    %edx,%eax
  801bfe:	01 c0                	add    %eax,%eax
  801c00:	01 d0                	add    %edx,%eax
  801c02:	c1 e0 03             	shl    $0x3,%eax
  801c05:	01 c8                	add    %ecx,%eax
  801c07:	8a 40 04             	mov    0x4(%eax),%al
  801c0a:	3c 01                	cmp    $0x1,%al
  801c0c:	75 03                	jne    801c11 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801c0e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c11:	ff 45 e0             	incl   -0x20(%ebp)
  801c14:	a1 20 30 80 00       	mov    0x803020,%eax
  801c19:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801c1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c22:	39 c2                	cmp    %eax,%edx
  801c24:	77 c8                	ja     801bee <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c29:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801c2c:	74 14                	je     801c42 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801c2e:	83 ec 04             	sub    $0x4,%esp
  801c31:	68 40 25 80 00       	push   $0x802540
  801c36:	6a 44                	push   $0x44
  801c38:	68 e0 24 80 00       	push   $0x8024e0
  801c3d:	e8 15 fe ff ff       	call   801a57 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801c42:	90                   	nop
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    
  801c45:	66 90                	xchg   %ax,%ax
  801c47:	90                   	nop

00801c48 <__udivdi3>:
  801c48:	55                   	push   %ebp
  801c49:	57                   	push   %edi
  801c4a:	56                   	push   %esi
  801c4b:	53                   	push   %ebx
  801c4c:	83 ec 1c             	sub    $0x1c,%esp
  801c4f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c53:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c5b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c5f:	89 ca                	mov    %ecx,%edx
  801c61:	89 f8                	mov    %edi,%eax
  801c63:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c67:	85 f6                	test   %esi,%esi
  801c69:	75 2d                	jne    801c98 <__udivdi3+0x50>
  801c6b:	39 cf                	cmp    %ecx,%edi
  801c6d:	77 65                	ja     801cd4 <__udivdi3+0x8c>
  801c6f:	89 fd                	mov    %edi,%ebp
  801c71:	85 ff                	test   %edi,%edi
  801c73:	75 0b                	jne    801c80 <__udivdi3+0x38>
  801c75:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7a:	31 d2                	xor    %edx,%edx
  801c7c:	f7 f7                	div    %edi
  801c7e:	89 c5                	mov    %eax,%ebp
  801c80:	31 d2                	xor    %edx,%edx
  801c82:	89 c8                	mov    %ecx,%eax
  801c84:	f7 f5                	div    %ebp
  801c86:	89 c1                	mov    %eax,%ecx
  801c88:	89 d8                	mov    %ebx,%eax
  801c8a:	f7 f5                	div    %ebp
  801c8c:	89 cf                	mov    %ecx,%edi
  801c8e:	89 fa                	mov    %edi,%edx
  801c90:	83 c4 1c             	add    $0x1c,%esp
  801c93:	5b                   	pop    %ebx
  801c94:	5e                   	pop    %esi
  801c95:	5f                   	pop    %edi
  801c96:	5d                   	pop    %ebp
  801c97:	c3                   	ret    
  801c98:	39 ce                	cmp    %ecx,%esi
  801c9a:	77 28                	ja     801cc4 <__udivdi3+0x7c>
  801c9c:	0f bd fe             	bsr    %esi,%edi
  801c9f:	83 f7 1f             	xor    $0x1f,%edi
  801ca2:	75 40                	jne    801ce4 <__udivdi3+0x9c>
  801ca4:	39 ce                	cmp    %ecx,%esi
  801ca6:	72 0a                	jb     801cb2 <__udivdi3+0x6a>
  801ca8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801cac:	0f 87 9e 00 00 00    	ja     801d50 <__udivdi3+0x108>
  801cb2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb7:	89 fa                	mov    %edi,%edx
  801cb9:	83 c4 1c             	add    $0x1c,%esp
  801cbc:	5b                   	pop    %ebx
  801cbd:	5e                   	pop    %esi
  801cbe:	5f                   	pop    %edi
  801cbf:	5d                   	pop    %ebp
  801cc0:	c3                   	ret    
  801cc1:	8d 76 00             	lea    0x0(%esi),%esi
  801cc4:	31 ff                	xor    %edi,%edi
  801cc6:	31 c0                	xor    %eax,%eax
  801cc8:	89 fa                	mov    %edi,%edx
  801cca:	83 c4 1c             	add    $0x1c,%esp
  801ccd:	5b                   	pop    %ebx
  801cce:	5e                   	pop    %esi
  801ccf:	5f                   	pop    %edi
  801cd0:	5d                   	pop    %ebp
  801cd1:	c3                   	ret    
  801cd2:	66 90                	xchg   %ax,%ax
  801cd4:	89 d8                	mov    %ebx,%eax
  801cd6:	f7 f7                	div    %edi
  801cd8:	31 ff                	xor    %edi,%edi
  801cda:	89 fa                	mov    %edi,%edx
  801cdc:	83 c4 1c             	add    $0x1c,%esp
  801cdf:	5b                   	pop    %ebx
  801ce0:	5e                   	pop    %esi
  801ce1:	5f                   	pop    %edi
  801ce2:	5d                   	pop    %ebp
  801ce3:	c3                   	ret    
  801ce4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ce9:	89 eb                	mov    %ebp,%ebx
  801ceb:	29 fb                	sub    %edi,%ebx
  801ced:	89 f9                	mov    %edi,%ecx
  801cef:	d3 e6                	shl    %cl,%esi
  801cf1:	89 c5                	mov    %eax,%ebp
  801cf3:	88 d9                	mov    %bl,%cl
  801cf5:	d3 ed                	shr    %cl,%ebp
  801cf7:	89 e9                	mov    %ebp,%ecx
  801cf9:	09 f1                	or     %esi,%ecx
  801cfb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801cff:	89 f9                	mov    %edi,%ecx
  801d01:	d3 e0                	shl    %cl,%eax
  801d03:	89 c5                	mov    %eax,%ebp
  801d05:	89 d6                	mov    %edx,%esi
  801d07:	88 d9                	mov    %bl,%cl
  801d09:	d3 ee                	shr    %cl,%esi
  801d0b:	89 f9                	mov    %edi,%ecx
  801d0d:	d3 e2                	shl    %cl,%edx
  801d0f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d13:	88 d9                	mov    %bl,%cl
  801d15:	d3 e8                	shr    %cl,%eax
  801d17:	09 c2                	or     %eax,%edx
  801d19:	89 d0                	mov    %edx,%eax
  801d1b:	89 f2                	mov    %esi,%edx
  801d1d:	f7 74 24 0c          	divl   0xc(%esp)
  801d21:	89 d6                	mov    %edx,%esi
  801d23:	89 c3                	mov    %eax,%ebx
  801d25:	f7 e5                	mul    %ebp
  801d27:	39 d6                	cmp    %edx,%esi
  801d29:	72 19                	jb     801d44 <__udivdi3+0xfc>
  801d2b:	74 0b                	je     801d38 <__udivdi3+0xf0>
  801d2d:	89 d8                	mov    %ebx,%eax
  801d2f:	31 ff                	xor    %edi,%edi
  801d31:	e9 58 ff ff ff       	jmp    801c8e <__udivdi3+0x46>
  801d36:	66 90                	xchg   %ax,%ax
  801d38:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d3c:	89 f9                	mov    %edi,%ecx
  801d3e:	d3 e2                	shl    %cl,%edx
  801d40:	39 c2                	cmp    %eax,%edx
  801d42:	73 e9                	jae    801d2d <__udivdi3+0xe5>
  801d44:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d47:	31 ff                	xor    %edi,%edi
  801d49:	e9 40 ff ff ff       	jmp    801c8e <__udivdi3+0x46>
  801d4e:	66 90                	xchg   %ax,%ax
  801d50:	31 c0                	xor    %eax,%eax
  801d52:	e9 37 ff ff ff       	jmp    801c8e <__udivdi3+0x46>
  801d57:	90                   	nop

00801d58 <__umoddi3>:
  801d58:	55                   	push   %ebp
  801d59:	57                   	push   %edi
  801d5a:	56                   	push   %esi
  801d5b:	53                   	push   %ebx
  801d5c:	83 ec 1c             	sub    $0x1c,%esp
  801d5f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d63:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d73:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d77:	89 f3                	mov    %esi,%ebx
  801d79:	89 fa                	mov    %edi,%edx
  801d7b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d7f:	89 34 24             	mov    %esi,(%esp)
  801d82:	85 c0                	test   %eax,%eax
  801d84:	75 1a                	jne    801da0 <__umoddi3+0x48>
  801d86:	39 f7                	cmp    %esi,%edi
  801d88:	0f 86 a2 00 00 00    	jbe    801e30 <__umoddi3+0xd8>
  801d8e:	89 c8                	mov    %ecx,%eax
  801d90:	89 f2                	mov    %esi,%edx
  801d92:	f7 f7                	div    %edi
  801d94:	89 d0                	mov    %edx,%eax
  801d96:	31 d2                	xor    %edx,%edx
  801d98:	83 c4 1c             	add    $0x1c,%esp
  801d9b:	5b                   	pop    %ebx
  801d9c:	5e                   	pop    %esi
  801d9d:	5f                   	pop    %edi
  801d9e:	5d                   	pop    %ebp
  801d9f:	c3                   	ret    
  801da0:	39 f0                	cmp    %esi,%eax
  801da2:	0f 87 ac 00 00 00    	ja     801e54 <__umoddi3+0xfc>
  801da8:	0f bd e8             	bsr    %eax,%ebp
  801dab:	83 f5 1f             	xor    $0x1f,%ebp
  801dae:	0f 84 ac 00 00 00    	je     801e60 <__umoddi3+0x108>
  801db4:	bf 20 00 00 00       	mov    $0x20,%edi
  801db9:	29 ef                	sub    %ebp,%edi
  801dbb:	89 fe                	mov    %edi,%esi
  801dbd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801dc1:	89 e9                	mov    %ebp,%ecx
  801dc3:	d3 e0                	shl    %cl,%eax
  801dc5:	89 d7                	mov    %edx,%edi
  801dc7:	89 f1                	mov    %esi,%ecx
  801dc9:	d3 ef                	shr    %cl,%edi
  801dcb:	09 c7                	or     %eax,%edi
  801dcd:	89 e9                	mov    %ebp,%ecx
  801dcf:	d3 e2                	shl    %cl,%edx
  801dd1:	89 14 24             	mov    %edx,(%esp)
  801dd4:	89 d8                	mov    %ebx,%eax
  801dd6:	d3 e0                	shl    %cl,%eax
  801dd8:	89 c2                	mov    %eax,%edx
  801dda:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dde:	d3 e0                	shl    %cl,%eax
  801de0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801de4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801de8:	89 f1                	mov    %esi,%ecx
  801dea:	d3 e8                	shr    %cl,%eax
  801dec:	09 d0                	or     %edx,%eax
  801dee:	d3 eb                	shr    %cl,%ebx
  801df0:	89 da                	mov    %ebx,%edx
  801df2:	f7 f7                	div    %edi
  801df4:	89 d3                	mov    %edx,%ebx
  801df6:	f7 24 24             	mull   (%esp)
  801df9:	89 c6                	mov    %eax,%esi
  801dfb:	89 d1                	mov    %edx,%ecx
  801dfd:	39 d3                	cmp    %edx,%ebx
  801dff:	0f 82 87 00 00 00    	jb     801e8c <__umoddi3+0x134>
  801e05:	0f 84 91 00 00 00    	je     801e9c <__umoddi3+0x144>
  801e0b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e0f:	29 f2                	sub    %esi,%edx
  801e11:	19 cb                	sbb    %ecx,%ebx
  801e13:	89 d8                	mov    %ebx,%eax
  801e15:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e19:	d3 e0                	shl    %cl,%eax
  801e1b:	89 e9                	mov    %ebp,%ecx
  801e1d:	d3 ea                	shr    %cl,%edx
  801e1f:	09 d0                	or     %edx,%eax
  801e21:	89 e9                	mov    %ebp,%ecx
  801e23:	d3 eb                	shr    %cl,%ebx
  801e25:	89 da                	mov    %ebx,%edx
  801e27:	83 c4 1c             	add    $0x1c,%esp
  801e2a:	5b                   	pop    %ebx
  801e2b:	5e                   	pop    %esi
  801e2c:	5f                   	pop    %edi
  801e2d:	5d                   	pop    %ebp
  801e2e:	c3                   	ret    
  801e2f:	90                   	nop
  801e30:	89 fd                	mov    %edi,%ebp
  801e32:	85 ff                	test   %edi,%edi
  801e34:	75 0b                	jne    801e41 <__umoddi3+0xe9>
  801e36:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3b:	31 d2                	xor    %edx,%edx
  801e3d:	f7 f7                	div    %edi
  801e3f:	89 c5                	mov    %eax,%ebp
  801e41:	89 f0                	mov    %esi,%eax
  801e43:	31 d2                	xor    %edx,%edx
  801e45:	f7 f5                	div    %ebp
  801e47:	89 c8                	mov    %ecx,%eax
  801e49:	f7 f5                	div    %ebp
  801e4b:	89 d0                	mov    %edx,%eax
  801e4d:	e9 44 ff ff ff       	jmp    801d96 <__umoddi3+0x3e>
  801e52:	66 90                	xchg   %ax,%ax
  801e54:	89 c8                	mov    %ecx,%eax
  801e56:	89 f2                	mov    %esi,%edx
  801e58:	83 c4 1c             	add    $0x1c,%esp
  801e5b:	5b                   	pop    %ebx
  801e5c:	5e                   	pop    %esi
  801e5d:	5f                   	pop    %edi
  801e5e:	5d                   	pop    %ebp
  801e5f:	c3                   	ret    
  801e60:	3b 04 24             	cmp    (%esp),%eax
  801e63:	72 06                	jb     801e6b <__umoddi3+0x113>
  801e65:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e69:	77 0f                	ja     801e7a <__umoddi3+0x122>
  801e6b:	89 f2                	mov    %esi,%edx
  801e6d:	29 f9                	sub    %edi,%ecx
  801e6f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e73:	89 14 24             	mov    %edx,(%esp)
  801e76:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e7a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e7e:	8b 14 24             	mov    (%esp),%edx
  801e81:	83 c4 1c             	add    $0x1c,%esp
  801e84:	5b                   	pop    %ebx
  801e85:	5e                   	pop    %esi
  801e86:	5f                   	pop    %edi
  801e87:	5d                   	pop    %ebp
  801e88:	c3                   	ret    
  801e89:	8d 76 00             	lea    0x0(%esi),%esi
  801e8c:	2b 04 24             	sub    (%esp),%eax
  801e8f:	19 fa                	sbb    %edi,%edx
  801e91:	89 d1                	mov    %edx,%ecx
  801e93:	89 c6                	mov    %eax,%esi
  801e95:	e9 71 ff ff ff       	jmp    801e0b <__umoddi3+0xb3>
  801e9a:	66 90                	xchg   %ax,%ax
  801e9c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ea0:	72 ea                	jb     801e8c <__umoddi3+0x134>
  801ea2:	89 d9                	mov    %ebx,%ecx
  801ea4:	e9 62 ff ff ff       	jmp    801e0b <__umoddi3+0xb3>

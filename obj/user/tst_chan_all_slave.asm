
obj/user/tst_chan_all_slave:     file format elf32-i386


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
  800031:	e8 2a 00 00 00       	call   800060 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program: sleep, increment test after wakeup
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	int envID = sys_getenvid();
  80003e:	e8 61 14 00 00       	call   8014a4 <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	//Sleep on the channel
	sys_utilities("__Sleep__", 0);
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	6a 00                	push   $0x0
  80004b:	68 e0 1b 80 00       	push   $0x801be0
  800050:	e8 9e 16 00 00       	call   8016f3 <sys_utilities>
  800055:	83 c4 10             	add    $0x10,%esp

	//indicates wakenup
	inctst();
  800058:	e8 9e 15 00 00       	call   8015fb <inctst>

	return;
  80005d:	90                   	nop
}
  80005e:	c9                   	leave  
  80005f:	c3                   	ret    

00800060 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800060:	55                   	push   %ebp
  800061:	89 e5                	mov    %esp,%ebp
  800063:	57                   	push   %edi
  800064:	56                   	push   %esi
  800065:	53                   	push   %ebx
  800066:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800069:	e8 4f 14 00 00       	call   8014bd <sys_getenvindex>
  80006e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800071:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800074:	89 d0                	mov    %edx,%eax
  800076:	c1 e0 02             	shl    $0x2,%eax
  800079:	01 d0                	add    %edx,%eax
  80007b:	c1 e0 03             	shl    $0x3,%eax
  80007e:	01 d0                	add    %edx,%eax
  800080:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800087:	01 d0                	add    %edx,%eax
  800089:	c1 e0 02             	shl    $0x2,%eax
  80008c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800091:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800096:	a1 20 30 80 00       	mov    0x803020,%eax
  80009b:	8a 40 20             	mov    0x20(%eax),%al
  80009e:	84 c0                	test   %al,%al
  8000a0:	74 0d                	je     8000af <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8000a2:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a7:	83 c0 20             	add    $0x20,%eax
  8000aa:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b3:	7e 0a                	jle    8000bf <libmain+0x5f>
		binaryname = argv[0];
  8000b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000b8:	8b 00                	mov    (%eax),%eax
  8000ba:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000bf:	83 ec 08             	sub    $0x8,%esp
  8000c2:	ff 75 0c             	pushl  0xc(%ebp)
  8000c5:	ff 75 08             	pushl  0x8(%ebp)
  8000c8:	e8 6b ff ff ff       	call   800038 <_main>
  8000cd:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000d0:	a1 00 30 80 00       	mov    0x803000,%eax
  8000d5:	85 c0                	test   %eax,%eax
  8000d7:	0f 84 01 01 00 00    	je     8001de <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8000dd:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8000e3:	bb e4 1c 80 00       	mov    $0x801ce4,%ebx
  8000e8:	ba 0e 00 00 00       	mov    $0xe,%edx
  8000ed:	89 c7                	mov    %eax,%edi
  8000ef:	89 de                	mov    %ebx,%esi
  8000f1:	89 d1                	mov    %edx,%ecx
  8000f3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000f5:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8000f8:	b9 56 00 00 00       	mov    $0x56,%ecx
  8000fd:	b0 00                	mov    $0x0,%al
  8000ff:	89 d7                	mov    %edx,%edi
  800101:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800103:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80010a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80010d:	83 ec 08             	sub    $0x8,%esp
  800110:	50                   	push   %eax
  800111:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800117:	50                   	push   %eax
  800118:	e8 d6 15 00 00       	call   8016f3 <sys_utilities>
  80011d:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800120:	e8 1f 11 00 00       	call   801244 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800125:	83 ec 0c             	sub    $0xc,%esp
  800128:	68 04 1c 80 00       	push   $0x801c04
  80012d:	e8 be 01 00 00       	call   8002f0 <cprintf>
  800132:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800135:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800138:	85 c0                	test   %eax,%eax
  80013a:	74 18                	je     800154 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80013c:	e8 d0 15 00 00       	call   801711 <sys_get_optimal_num_faults>
  800141:	83 ec 08             	sub    $0x8,%esp
  800144:	50                   	push   %eax
  800145:	68 2c 1c 80 00       	push   $0x801c2c
  80014a:	e8 a1 01 00 00       	call   8002f0 <cprintf>
  80014f:	83 c4 10             	add    $0x10,%esp
  800152:	eb 59                	jmp    8001ad <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800154:	a1 20 30 80 00       	mov    0x803020,%eax
  800159:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80015f:	a1 20 30 80 00       	mov    0x803020,%eax
  800164:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80016a:	83 ec 04             	sub    $0x4,%esp
  80016d:	52                   	push   %edx
  80016e:	50                   	push   %eax
  80016f:	68 50 1c 80 00       	push   $0x801c50
  800174:	e8 77 01 00 00       	call   8002f0 <cprintf>
  800179:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80017c:	a1 20 30 80 00       	mov    0x803020,%eax
  800181:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800187:	a1 20 30 80 00       	mov    0x803020,%eax
  80018c:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800192:	a1 20 30 80 00       	mov    0x803020,%eax
  800197:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80019d:	51                   	push   %ecx
  80019e:	52                   	push   %edx
  80019f:	50                   	push   %eax
  8001a0:	68 78 1c 80 00       	push   $0x801c78
  8001a5:	e8 46 01 00 00       	call   8002f0 <cprintf>
  8001aa:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001ad:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b2:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8001b8:	83 ec 08             	sub    $0x8,%esp
  8001bb:	50                   	push   %eax
  8001bc:	68 d0 1c 80 00       	push   $0x801cd0
  8001c1:	e8 2a 01 00 00       	call   8002f0 <cprintf>
  8001c6:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	68 04 1c 80 00       	push   $0x801c04
  8001d1:	e8 1a 01 00 00       	call   8002f0 <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001d9:	e8 80 10 00 00       	call   80125e <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001de:	e8 1f 00 00 00       	call   800202 <exit>
}
  8001e3:	90                   	nop
  8001e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001e7:	5b                   	pop    %ebx
  8001e8:	5e                   	pop    %esi
  8001e9:	5f                   	pop    %edi
  8001ea:	5d                   	pop    %ebp
  8001eb:	c3                   	ret    

008001ec <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001f2:	83 ec 0c             	sub    $0xc,%esp
  8001f5:	6a 00                	push   $0x0
  8001f7:	e8 8d 12 00 00       	call   801489 <sys_destroy_env>
  8001fc:	83 c4 10             	add    $0x10,%esp
}
  8001ff:	90                   	nop
  800200:	c9                   	leave  
  800201:	c3                   	ret    

00800202 <exit>:

void
exit(void)
{
  800202:	55                   	push   %ebp
  800203:	89 e5                	mov    %esp,%ebp
  800205:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800208:	e8 e2 12 00 00       	call   8014ef <sys_exit_env>
}
  80020d:	90                   	nop
  80020e:	c9                   	leave  
  80020f:	c3                   	ret    

00800210 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	53                   	push   %ebx
  800214:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80021a:	8b 00                	mov    (%eax),%eax
  80021c:	8d 48 01             	lea    0x1(%eax),%ecx
  80021f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800222:	89 0a                	mov    %ecx,(%edx)
  800224:	8b 55 08             	mov    0x8(%ebp),%edx
  800227:	88 d1                	mov    %dl,%cl
  800229:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800230:	8b 45 0c             	mov    0xc(%ebp),%eax
  800233:	8b 00                	mov    (%eax),%eax
  800235:	3d ff 00 00 00       	cmp    $0xff,%eax
  80023a:	75 30                	jne    80026c <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80023c:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  800242:	a0 44 30 80 00       	mov    0x803044,%al
  800247:	0f b6 c0             	movzbl %al,%eax
  80024a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80024d:	8b 09                	mov    (%ecx),%ecx
  80024f:	89 cb                	mov    %ecx,%ebx
  800251:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800254:	83 c1 08             	add    $0x8,%ecx
  800257:	52                   	push   %edx
  800258:	50                   	push   %eax
  800259:	53                   	push   %ebx
  80025a:	51                   	push   %ecx
  80025b:	e8 a0 0f 00 00       	call   801200 <sys_cputs>
  800260:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800263:	8b 45 0c             	mov    0xc(%ebp),%eax
  800266:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80026c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80026f:	8b 40 04             	mov    0x4(%eax),%eax
  800272:	8d 50 01             	lea    0x1(%eax),%edx
  800275:	8b 45 0c             	mov    0xc(%ebp),%eax
  800278:	89 50 04             	mov    %edx,0x4(%eax)
}
  80027b:	90                   	nop
  80027c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80027f:	c9                   	leave  
  800280:	c3                   	ret    

00800281 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800281:	55                   	push   %ebp
  800282:	89 e5                	mov    %esp,%ebp
  800284:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80028a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800291:	00 00 00 
	b.cnt = 0;
  800294:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80029b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80029e:	ff 75 0c             	pushl  0xc(%ebp)
  8002a1:	ff 75 08             	pushl  0x8(%ebp)
  8002a4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002aa:	50                   	push   %eax
  8002ab:	68 10 02 80 00       	push   $0x800210
  8002b0:	e8 5a 02 00 00       	call   80050f <vprintfmt>
  8002b5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8002b8:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8002be:	a0 44 30 80 00       	mov    0x803044,%al
  8002c3:	0f b6 c0             	movzbl %al,%eax
  8002c6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8002cc:	52                   	push   %edx
  8002cd:	50                   	push   %eax
  8002ce:	51                   	push   %ecx
  8002cf:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002d5:	83 c0 08             	add    $0x8,%eax
  8002d8:	50                   	push   %eax
  8002d9:	e8 22 0f 00 00       	call   801200 <sys_cputs>
  8002de:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002e1:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8002e8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002ee:	c9                   	leave  
  8002ef:	c3                   	ret    

008002f0 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002f6:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8002fd:	8d 45 0c             	lea    0xc(%ebp),%eax
  800300:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800303:	8b 45 08             	mov    0x8(%ebp),%eax
  800306:	83 ec 08             	sub    $0x8,%esp
  800309:	ff 75 f4             	pushl  -0xc(%ebp)
  80030c:	50                   	push   %eax
  80030d:	e8 6f ff ff ff       	call   800281 <vcprintf>
  800312:	83 c4 10             	add    $0x10,%esp
  800315:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800318:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80031b:	c9                   	leave  
  80031c:	c3                   	ret    

0080031d <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80031d:	55                   	push   %ebp
  80031e:	89 e5                	mov    %esp,%ebp
  800320:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800323:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	c1 e0 08             	shl    $0x8,%eax
  800330:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  800335:	8d 45 0c             	lea    0xc(%ebp),%eax
  800338:	83 c0 04             	add    $0x4,%eax
  80033b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80033e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	ff 75 f4             	pushl  -0xc(%ebp)
  800347:	50                   	push   %eax
  800348:	e8 34 ff ff ff       	call   800281 <vcprintf>
  80034d:	83 c4 10             	add    $0x10,%esp
  800350:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800353:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  80035a:	07 00 00 

	return cnt;
  80035d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800360:	c9                   	leave  
  800361:	c3                   	ret    

00800362 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800362:	55                   	push   %ebp
  800363:	89 e5                	mov    %esp,%ebp
  800365:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800368:	e8 d7 0e 00 00       	call   801244 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80036d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800370:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800373:	8b 45 08             	mov    0x8(%ebp),%eax
  800376:	83 ec 08             	sub    $0x8,%esp
  800379:	ff 75 f4             	pushl  -0xc(%ebp)
  80037c:	50                   	push   %eax
  80037d:	e8 ff fe ff ff       	call   800281 <vcprintf>
  800382:	83 c4 10             	add    $0x10,%esp
  800385:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800388:	e8 d1 0e 00 00       	call   80125e <sys_unlock_cons>
	return cnt;
  80038d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800390:	c9                   	leave  
  800391:	c3                   	ret    

00800392 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800392:	55                   	push   %ebp
  800393:	89 e5                	mov    %esp,%ebp
  800395:	53                   	push   %ebx
  800396:	83 ec 14             	sub    $0x14,%esp
  800399:	8b 45 10             	mov    0x10(%ebp),%eax
  80039c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80039f:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003a5:	8b 45 18             	mov    0x18(%ebp),%eax
  8003a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ad:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003b0:	77 55                	ja     800407 <printnum+0x75>
  8003b2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003b5:	72 05                	jb     8003bc <printnum+0x2a>
  8003b7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003ba:	77 4b                	ja     800407 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003bc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003bf:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003c2:	8b 45 18             	mov    0x18(%ebp),%eax
  8003c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ca:	52                   	push   %edx
  8003cb:	50                   	push   %eax
  8003cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8003cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8003d2:	e8 99 15 00 00       	call   801970 <__udivdi3>
  8003d7:	83 c4 10             	add    $0x10,%esp
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	ff 75 20             	pushl  0x20(%ebp)
  8003e0:	53                   	push   %ebx
  8003e1:	ff 75 18             	pushl  0x18(%ebp)
  8003e4:	52                   	push   %edx
  8003e5:	50                   	push   %eax
  8003e6:	ff 75 0c             	pushl  0xc(%ebp)
  8003e9:	ff 75 08             	pushl  0x8(%ebp)
  8003ec:	e8 a1 ff ff ff       	call   800392 <printnum>
  8003f1:	83 c4 20             	add    $0x20,%esp
  8003f4:	eb 1a                	jmp    800410 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003f6:	83 ec 08             	sub    $0x8,%esp
  8003f9:	ff 75 0c             	pushl  0xc(%ebp)
  8003fc:	ff 75 20             	pushl  0x20(%ebp)
  8003ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800402:	ff d0                	call   *%eax
  800404:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800407:	ff 4d 1c             	decl   0x1c(%ebp)
  80040a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80040e:	7f e6                	jg     8003f6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800410:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800413:	bb 00 00 00 00       	mov    $0x0,%ebx
  800418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80041b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80041e:	53                   	push   %ebx
  80041f:	51                   	push   %ecx
  800420:	52                   	push   %edx
  800421:	50                   	push   %eax
  800422:	e8 59 16 00 00       	call   801a80 <__umoddi3>
  800427:	83 c4 10             	add    $0x10,%esp
  80042a:	05 74 1f 80 00       	add    $0x801f74,%eax
  80042f:	8a 00                	mov    (%eax),%al
  800431:	0f be c0             	movsbl %al,%eax
  800434:	83 ec 08             	sub    $0x8,%esp
  800437:	ff 75 0c             	pushl  0xc(%ebp)
  80043a:	50                   	push   %eax
  80043b:	8b 45 08             	mov    0x8(%ebp),%eax
  80043e:	ff d0                	call   *%eax
  800440:	83 c4 10             	add    $0x10,%esp
}
  800443:	90                   	nop
  800444:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800447:	c9                   	leave  
  800448:	c3                   	ret    

00800449 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800449:	55                   	push   %ebp
  80044a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80044c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800450:	7e 1c                	jle    80046e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800452:	8b 45 08             	mov    0x8(%ebp),%eax
  800455:	8b 00                	mov    (%eax),%eax
  800457:	8d 50 08             	lea    0x8(%eax),%edx
  80045a:	8b 45 08             	mov    0x8(%ebp),%eax
  80045d:	89 10                	mov    %edx,(%eax)
  80045f:	8b 45 08             	mov    0x8(%ebp),%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 e8 08             	sub    $0x8,%eax
  800467:	8b 50 04             	mov    0x4(%eax),%edx
  80046a:	8b 00                	mov    (%eax),%eax
  80046c:	eb 40                	jmp    8004ae <getuint+0x65>
	else if (lflag)
  80046e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800472:	74 1e                	je     800492 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800474:	8b 45 08             	mov    0x8(%ebp),%eax
  800477:	8b 00                	mov    (%eax),%eax
  800479:	8d 50 04             	lea    0x4(%eax),%edx
  80047c:	8b 45 08             	mov    0x8(%ebp),%eax
  80047f:	89 10                	mov    %edx,(%eax)
  800481:	8b 45 08             	mov    0x8(%ebp),%eax
  800484:	8b 00                	mov    (%eax),%eax
  800486:	83 e8 04             	sub    $0x4,%eax
  800489:	8b 00                	mov    (%eax),%eax
  80048b:	ba 00 00 00 00       	mov    $0x0,%edx
  800490:	eb 1c                	jmp    8004ae <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	8b 00                	mov    (%eax),%eax
  800497:	8d 50 04             	lea    0x4(%eax),%edx
  80049a:	8b 45 08             	mov    0x8(%ebp),%eax
  80049d:	89 10                	mov    %edx,(%eax)
  80049f:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a2:	8b 00                	mov    (%eax),%eax
  8004a4:	83 e8 04             	sub    $0x4,%eax
  8004a7:	8b 00                	mov    (%eax),%eax
  8004a9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004ae:	5d                   	pop    %ebp
  8004af:	c3                   	ret    

008004b0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004b3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004b7:	7e 1c                	jle    8004d5 <getint+0x25>
		return va_arg(*ap, long long);
  8004b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bc:	8b 00                	mov    (%eax),%eax
  8004be:	8d 50 08             	lea    0x8(%eax),%edx
  8004c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c4:	89 10                	mov    %edx,(%eax)
  8004c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c9:	8b 00                	mov    (%eax),%eax
  8004cb:	83 e8 08             	sub    $0x8,%eax
  8004ce:	8b 50 04             	mov    0x4(%eax),%edx
  8004d1:	8b 00                	mov    (%eax),%eax
  8004d3:	eb 38                	jmp    80050d <getint+0x5d>
	else if (lflag)
  8004d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004d9:	74 1a                	je     8004f5 <getint+0x45>
		return va_arg(*ap, long);
  8004db:	8b 45 08             	mov    0x8(%ebp),%eax
  8004de:	8b 00                	mov    (%eax),%eax
  8004e0:	8d 50 04             	lea    0x4(%eax),%edx
  8004e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e6:	89 10                	mov    %edx,(%eax)
  8004e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004eb:	8b 00                	mov    (%eax),%eax
  8004ed:	83 e8 04             	sub    $0x4,%eax
  8004f0:	8b 00                	mov    (%eax),%eax
  8004f2:	99                   	cltd   
  8004f3:	eb 18                	jmp    80050d <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f8:	8b 00                	mov    (%eax),%eax
  8004fa:	8d 50 04             	lea    0x4(%eax),%edx
  8004fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800500:	89 10                	mov    %edx,(%eax)
  800502:	8b 45 08             	mov    0x8(%ebp),%eax
  800505:	8b 00                	mov    (%eax),%eax
  800507:	83 e8 04             	sub    $0x4,%eax
  80050a:	8b 00                	mov    (%eax),%eax
  80050c:	99                   	cltd   
}
  80050d:	5d                   	pop    %ebp
  80050e:	c3                   	ret    

0080050f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80050f:	55                   	push   %ebp
  800510:	89 e5                	mov    %esp,%ebp
  800512:	56                   	push   %esi
  800513:	53                   	push   %ebx
  800514:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800517:	eb 17                	jmp    800530 <vprintfmt+0x21>
			if (ch == '\0')
  800519:	85 db                	test   %ebx,%ebx
  80051b:	0f 84 c1 03 00 00    	je     8008e2 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800521:	83 ec 08             	sub    $0x8,%esp
  800524:	ff 75 0c             	pushl  0xc(%ebp)
  800527:	53                   	push   %ebx
  800528:	8b 45 08             	mov    0x8(%ebp),%eax
  80052b:	ff d0                	call   *%eax
  80052d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800530:	8b 45 10             	mov    0x10(%ebp),%eax
  800533:	8d 50 01             	lea    0x1(%eax),%edx
  800536:	89 55 10             	mov    %edx,0x10(%ebp)
  800539:	8a 00                	mov    (%eax),%al
  80053b:	0f b6 d8             	movzbl %al,%ebx
  80053e:	83 fb 25             	cmp    $0x25,%ebx
  800541:	75 d6                	jne    800519 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800543:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800547:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80054e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800555:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80055c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800563:	8b 45 10             	mov    0x10(%ebp),%eax
  800566:	8d 50 01             	lea    0x1(%eax),%edx
  800569:	89 55 10             	mov    %edx,0x10(%ebp)
  80056c:	8a 00                	mov    (%eax),%al
  80056e:	0f b6 d8             	movzbl %al,%ebx
  800571:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800574:	83 f8 5b             	cmp    $0x5b,%eax
  800577:	0f 87 3d 03 00 00    	ja     8008ba <vprintfmt+0x3ab>
  80057d:	8b 04 85 98 1f 80 00 	mov    0x801f98(,%eax,4),%eax
  800584:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800586:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80058a:	eb d7                	jmp    800563 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80058c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800590:	eb d1                	jmp    800563 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800592:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800599:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80059c:	89 d0                	mov    %edx,%eax
  80059e:	c1 e0 02             	shl    $0x2,%eax
  8005a1:	01 d0                	add    %edx,%eax
  8005a3:	01 c0                	add    %eax,%eax
  8005a5:	01 d8                	add    %ebx,%eax
  8005a7:	83 e8 30             	sub    $0x30,%eax
  8005aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8005b0:	8a 00                	mov    (%eax),%al
  8005b2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005b5:	83 fb 2f             	cmp    $0x2f,%ebx
  8005b8:	7e 3e                	jle    8005f8 <vprintfmt+0xe9>
  8005ba:	83 fb 39             	cmp    $0x39,%ebx
  8005bd:	7f 39                	jg     8005f8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005bf:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005c2:	eb d5                	jmp    800599 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c7:	83 c0 04             	add    $0x4,%eax
  8005ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8005cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d0:	83 e8 04             	sub    $0x4,%eax
  8005d3:	8b 00                	mov    (%eax),%eax
  8005d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005d8:	eb 1f                	jmp    8005f9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005de:	79 83                	jns    800563 <vprintfmt+0x54>
				width = 0;
  8005e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005e7:	e9 77 ff ff ff       	jmp    800563 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005ec:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005f3:	e9 6b ff ff ff       	jmp    800563 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005f8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005fd:	0f 89 60 ff ff ff    	jns    800563 <vprintfmt+0x54>
				width = precision, precision = -1;
  800603:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800606:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800609:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800610:	e9 4e ff ff ff       	jmp    800563 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800615:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800618:	e9 46 ff ff ff       	jmp    800563 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80061d:	8b 45 14             	mov    0x14(%ebp),%eax
  800620:	83 c0 04             	add    $0x4,%eax
  800623:	89 45 14             	mov    %eax,0x14(%ebp)
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	83 e8 04             	sub    $0x4,%eax
  80062c:	8b 00                	mov    (%eax),%eax
  80062e:	83 ec 08             	sub    $0x8,%esp
  800631:	ff 75 0c             	pushl  0xc(%ebp)
  800634:	50                   	push   %eax
  800635:	8b 45 08             	mov    0x8(%ebp),%eax
  800638:	ff d0                	call   *%eax
  80063a:	83 c4 10             	add    $0x10,%esp
			break;
  80063d:	e9 9b 02 00 00       	jmp    8008dd <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	83 c0 04             	add    $0x4,%eax
  800648:	89 45 14             	mov    %eax,0x14(%ebp)
  80064b:	8b 45 14             	mov    0x14(%ebp),%eax
  80064e:	83 e8 04             	sub    $0x4,%eax
  800651:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800653:	85 db                	test   %ebx,%ebx
  800655:	79 02                	jns    800659 <vprintfmt+0x14a>
				err = -err;
  800657:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800659:	83 fb 64             	cmp    $0x64,%ebx
  80065c:	7f 0b                	jg     800669 <vprintfmt+0x15a>
  80065e:	8b 34 9d e0 1d 80 00 	mov    0x801de0(,%ebx,4),%esi
  800665:	85 f6                	test   %esi,%esi
  800667:	75 19                	jne    800682 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800669:	53                   	push   %ebx
  80066a:	68 85 1f 80 00       	push   $0x801f85
  80066f:	ff 75 0c             	pushl  0xc(%ebp)
  800672:	ff 75 08             	pushl  0x8(%ebp)
  800675:	e8 70 02 00 00       	call   8008ea <printfmt>
  80067a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80067d:	e9 5b 02 00 00       	jmp    8008dd <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800682:	56                   	push   %esi
  800683:	68 8e 1f 80 00       	push   $0x801f8e
  800688:	ff 75 0c             	pushl  0xc(%ebp)
  80068b:	ff 75 08             	pushl  0x8(%ebp)
  80068e:	e8 57 02 00 00       	call   8008ea <printfmt>
  800693:	83 c4 10             	add    $0x10,%esp
			break;
  800696:	e9 42 02 00 00       	jmp    8008dd <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80069b:	8b 45 14             	mov    0x14(%ebp),%eax
  80069e:	83 c0 04             	add    $0x4,%eax
  8006a1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a7:	83 e8 04             	sub    $0x4,%eax
  8006aa:	8b 30                	mov    (%eax),%esi
  8006ac:	85 f6                	test   %esi,%esi
  8006ae:	75 05                	jne    8006b5 <vprintfmt+0x1a6>
				p = "(null)";
  8006b0:	be 91 1f 80 00       	mov    $0x801f91,%esi
			if (width > 0 && padc != '-')
  8006b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006b9:	7e 6d                	jle    800728 <vprintfmt+0x219>
  8006bb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006bf:	74 67                	je     800728 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	50                   	push   %eax
  8006c8:	56                   	push   %esi
  8006c9:	e8 1e 03 00 00       	call   8009ec <strnlen>
  8006ce:	83 c4 10             	add    $0x10,%esp
  8006d1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006d4:	eb 16                	jmp    8006ec <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006d6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006da:	83 ec 08             	sub    $0x8,%esp
  8006dd:	ff 75 0c             	pushl  0xc(%ebp)
  8006e0:	50                   	push   %eax
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	ff d0                	call   *%eax
  8006e6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e9:	ff 4d e4             	decl   -0x1c(%ebp)
  8006ec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006f0:	7f e4                	jg     8006d6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006f2:	eb 34                	jmp    800728 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006f4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006f8:	74 1c                	je     800716 <vprintfmt+0x207>
  8006fa:	83 fb 1f             	cmp    $0x1f,%ebx
  8006fd:	7e 05                	jle    800704 <vprintfmt+0x1f5>
  8006ff:	83 fb 7e             	cmp    $0x7e,%ebx
  800702:	7e 12                	jle    800716 <vprintfmt+0x207>
					putch('?', putdat);
  800704:	83 ec 08             	sub    $0x8,%esp
  800707:	ff 75 0c             	pushl  0xc(%ebp)
  80070a:	6a 3f                	push   $0x3f
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	ff d0                	call   *%eax
  800711:	83 c4 10             	add    $0x10,%esp
  800714:	eb 0f                	jmp    800725 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800716:	83 ec 08             	sub    $0x8,%esp
  800719:	ff 75 0c             	pushl  0xc(%ebp)
  80071c:	53                   	push   %ebx
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	ff d0                	call   *%eax
  800722:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800725:	ff 4d e4             	decl   -0x1c(%ebp)
  800728:	89 f0                	mov    %esi,%eax
  80072a:	8d 70 01             	lea    0x1(%eax),%esi
  80072d:	8a 00                	mov    (%eax),%al
  80072f:	0f be d8             	movsbl %al,%ebx
  800732:	85 db                	test   %ebx,%ebx
  800734:	74 24                	je     80075a <vprintfmt+0x24b>
  800736:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80073a:	78 b8                	js     8006f4 <vprintfmt+0x1e5>
  80073c:	ff 4d e0             	decl   -0x20(%ebp)
  80073f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800743:	79 af                	jns    8006f4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800745:	eb 13                	jmp    80075a <vprintfmt+0x24b>
				putch(' ', putdat);
  800747:	83 ec 08             	sub    $0x8,%esp
  80074a:	ff 75 0c             	pushl  0xc(%ebp)
  80074d:	6a 20                	push   $0x20
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	ff d0                	call   *%eax
  800754:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800757:	ff 4d e4             	decl   -0x1c(%ebp)
  80075a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80075e:	7f e7                	jg     800747 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800760:	e9 78 01 00 00       	jmp    8008dd <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800765:	83 ec 08             	sub    $0x8,%esp
  800768:	ff 75 e8             	pushl  -0x18(%ebp)
  80076b:	8d 45 14             	lea    0x14(%ebp),%eax
  80076e:	50                   	push   %eax
  80076f:	e8 3c fd ff ff       	call   8004b0 <getint>
  800774:	83 c4 10             	add    $0x10,%esp
  800777:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80077a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80077d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800780:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800783:	85 d2                	test   %edx,%edx
  800785:	79 23                	jns    8007aa <vprintfmt+0x29b>
				putch('-', putdat);
  800787:	83 ec 08             	sub    $0x8,%esp
  80078a:	ff 75 0c             	pushl  0xc(%ebp)
  80078d:	6a 2d                	push   $0x2d
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	ff d0                	call   *%eax
  800794:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80079a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80079d:	f7 d8                	neg    %eax
  80079f:	83 d2 00             	adc    $0x0,%edx
  8007a2:	f7 da                	neg    %edx
  8007a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007aa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007b1:	e9 bc 00 00 00       	jmp    800872 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	ff 75 e8             	pushl  -0x18(%ebp)
  8007bc:	8d 45 14             	lea    0x14(%ebp),%eax
  8007bf:	50                   	push   %eax
  8007c0:	e8 84 fc ff ff       	call   800449 <getuint>
  8007c5:	83 c4 10             	add    $0x10,%esp
  8007c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007ce:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007d5:	e9 98 00 00 00       	jmp    800872 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007da:	83 ec 08             	sub    $0x8,%esp
  8007dd:	ff 75 0c             	pushl  0xc(%ebp)
  8007e0:	6a 58                	push   $0x58
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	ff d0                	call   *%eax
  8007e7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	ff 75 0c             	pushl  0xc(%ebp)
  8007f0:	6a 58                	push   $0x58
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	ff d0                	call   *%eax
  8007f7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007fa:	83 ec 08             	sub    $0x8,%esp
  8007fd:	ff 75 0c             	pushl  0xc(%ebp)
  800800:	6a 58                	push   $0x58
  800802:	8b 45 08             	mov    0x8(%ebp),%eax
  800805:	ff d0                	call   *%eax
  800807:	83 c4 10             	add    $0x10,%esp
			break;
  80080a:	e9 ce 00 00 00       	jmp    8008dd <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80080f:	83 ec 08             	sub    $0x8,%esp
  800812:	ff 75 0c             	pushl  0xc(%ebp)
  800815:	6a 30                	push   $0x30
  800817:	8b 45 08             	mov    0x8(%ebp),%eax
  80081a:	ff d0                	call   *%eax
  80081c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80081f:	83 ec 08             	sub    $0x8,%esp
  800822:	ff 75 0c             	pushl  0xc(%ebp)
  800825:	6a 78                	push   $0x78
  800827:	8b 45 08             	mov    0x8(%ebp),%eax
  80082a:	ff d0                	call   *%eax
  80082c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80082f:	8b 45 14             	mov    0x14(%ebp),%eax
  800832:	83 c0 04             	add    $0x4,%eax
  800835:	89 45 14             	mov    %eax,0x14(%ebp)
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	83 e8 04             	sub    $0x4,%eax
  80083e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800840:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800843:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80084a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800851:	eb 1f                	jmp    800872 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800853:	83 ec 08             	sub    $0x8,%esp
  800856:	ff 75 e8             	pushl  -0x18(%ebp)
  800859:	8d 45 14             	lea    0x14(%ebp),%eax
  80085c:	50                   	push   %eax
  80085d:	e8 e7 fb ff ff       	call   800449 <getuint>
  800862:	83 c4 10             	add    $0x10,%esp
  800865:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800868:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80086b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800872:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800876:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800879:	83 ec 04             	sub    $0x4,%esp
  80087c:	52                   	push   %edx
  80087d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800880:	50                   	push   %eax
  800881:	ff 75 f4             	pushl  -0xc(%ebp)
  800884:	ff 75 f0             	pushl  -0x10(%ebp)
  800887:	ff 75 0c             	pushl  0xc(%ebp)
  80088a:	ff 75 08             	pushl  0x8(%ebp)
  80088d:	e8 00 fb ff ff       	call   800392 <printnum>
  800892:	83 c4 20             	add    $0x20,%esp
			break;
  800895:	eb 46                	jmp    8008dd <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800897:	83 ec 08             	sub    $0x8,%esp
  80089a:	ff 75 0c             	pushl  0xc(%ebp)
  80089d:	53                   	push   %ebx
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	ff d0                	call   *%eax
  8008a3:	83 c4 10             	add    $0x10,%esp
			break;
  8008a6:	eb 35                	jmp    8008dd <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8008a8:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  8008af:	eb 2c                	jmp    8008dd <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8008b1:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  8008b8:	eb 23                	jmp    8008dd <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	ff 75 0c             	pushl  0xc(%ebp)
  8008c0:	6a 25                	push   $0x25
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	ff d0                	call   *%eax
  8008c7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008ca:	ff 4d 10             	decl   0x10(%ebp)
  8008cd:	eb 03                	jmp    8008d2 <vprintfmt+0x3c3>
  8008cf:	ff 4d 10             	decl   0x10(%ebp)
  8008d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d5:	48                   	dec    %eax
  8008d6:	8a 00                	mov    (%eax),%al
  8008d8:	3c 25                	cmp    $0x25,%al
  8008da:	75 f3                	jne    8008cf <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008dc:	90                   	nop
		}
	}
  8008dd:	e9 35 fc ff ff       	jmp    800517 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008e2:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008e6:	5b                   	pop    %ebx
  8008e7:	5e                   	pop    %esi
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
  8008ed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008f0:	8d 45 10             	lea    0x10(%ebp),%eax
  8008f3:	83 c0 04             	add    $0x4,%eax
  8008f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ff:	50                   	push   %eax
  800900:	ff 75 0c             	pushl  0xc(%ebp)
  800903:	ff 75 08             	pushl  0x8(%ebp)
  800906:	e8 04 fc ff ff       	call   80050f <vprintfmt>
  80090b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80090e:	90                   	nop
  80090f:	c9                   	leave  
  800910:	c3                   	ret    

00800911 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800911:	55                   	push   %ebp
  800912:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800914:	8b 45 0c             	mov    0xc(%ebp),%eax
  800917:	8b 40 08             	mov    0x8(%eax),%eax
  80091a:	8d 50 01             	lea    0x1(%eax),%edx
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800923:	8b 45 0c             	mov    0xc(%ebp),%eax
  800926:	8b 10                	mov    (%eax),%edx
  800928:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092b:	8b 40 04             	mov    0x4(%eax),%eax
  80092e:	39 c2                	cmp    %eax,%edx
  800930:	73 12                	jae    800944 <sprintputch+0x33>
		*b->buf++ = ch;
  800932:	8b 45 0c             	mov    0xc(%ebp),%eax
  800935:	8b 00                	mov    (%eax),%eax
  800937:	8d 48 01             	lea    0x1(%eax),%ecx
  80093a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093d:	89 0a                	mov    %ecx,(%edx)
  80093f:	8b 55 08             	mov    0x8(%ebp),%edx
  800942:	88 10                	mov    %dl,(%eax)
}
  800944:	90                   	nop
  800945:	5d                   	pop    %ebp
  800946:	c3                   	ret    

00800947 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800947:	55                   	push   %ebp
  800948:	89 e5                	mov    %esp,%ebp
  80094a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800953:	8b 45 0c             	mov    0xc(%ebp),%eax
  800956:	8d 50 ff             	lea    -0x1(%eax),%edx
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	01 d0                	add    %edx,%eax
  80095e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800961:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800968:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80096c:	74 06                	je     800974 <vsnprintf+0x2d>
  80096e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800972:	7f 07                	jg     80097b <vsnprintf+0x34>
		return -E_INVAL;
  800974:	b8 03 00 00 00       	mov    $0x3,%eax
  800979:	eb 20                	jmp    80099b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80097b:	ff 75 14             	pushl  0x14(%ebp)
  80097e:	ff 75 10             	pushl  0x10(%ebp)
  800981:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800984:	50                   	push   %eax
  800985:	68 11 09 80 00       	push   $0x800911
  80098a:	e8 80 fb ff ff       	call   80050f <vprintfmt>
  80098f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800992:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800995:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800998:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80099b:	c9                   	leave  
  80099c:	c3                   	ret    

0080099d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
  8009a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8009a6:	83 c0 04             	add    $0x4,%eax
  8009a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8009af:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b2:	50                   	push   %eax
  8009b3:	ff 75 0c             	pushl  0xc(%ebp)
  8009b6:	ff 75 08             	pushl  0x8(%ebp)
  8009b9:	e8 89 ff ff ff       	call   800947 <vsnprintf>
  8009be:	83 c4 10             	add    $0x10,%esp
  8009c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c7:	c9                   	leave  
  8009c8:	c3                   	ret    

008009c9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009d6:	eb 06                	jmp    8009de <strlen+0x15>
		n++;
  8009d8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009db:	ff 45 08             	incl   0x8(%ebp)
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	8a 00                	mov    (%eax),%al
  8009e3:	84 c0                	test   %al,%al
  8009e5:	75 f1                	jne    8009d8 <strlen+0xf>
		n++;
	return n;
  8009e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009ea:	c9                   	leave  
  8009eb:	c3                   	ret    

008009ec <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009ec:	55                   	push   %ebp
  8009ed:	89 e5                	mov    %esp,%ebp
  8009ef:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009f9:	eb 09                	jmp    800a04 <strnlen+0x18>
		n++;
  8009fb:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009fe:	ff 45 08             	incl   0x8(%ebp)
  800a01:	ff 4d 0c             	decl   0xc(%ebp)
  800a04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a08:	74 09                	je     800a13 <strnlen+0x27>
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	8a 00                	mov    (%eax),%al
  800a0f:	84 c0                	test   %al,%al
  800a11:	75 e8                	jne    8009fb <strnlen+0xf>
		n++;
	return n;
  800a13:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a16:	c9                   	leave  
  800a17:	c3                   	ret    

00800a18 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a18:	55                   	push   %ebp
  800a19:	89 e5                	mov    %esp,%ebp
  800a1b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a24:	90                   	nop
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	8d 50 01             	lea    0x1(%eax),%edx
  800a2b:	89 55 08             	mov    %edx,0x8(%ebp)
  800a2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a31:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a34:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a37:	8a 12                	mov    (%edx),%dl
  800a39:	88 10                	mov    %dl,(%eax)
  800a3b:	8a 00                	mov    (%eax),%al
  800a3d:	84 c0                	test   %al,%al
  800a3f:	75 e4                	jne    800a25 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a41:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a44:	c9                   	leave  
  800a45:	c3                   	ret    

00800a46 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
  800a49:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a59:	eb 1f                	jmp    800a7a <strncpy+0x34>
		*dst++ = *src;
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	8d 50 01             	lea    0x1(%eax),%edx
  800a61:	89 55 08             	mov    %edx,0x8(%ebp)
  800a64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a67:	8a 12                	mov    (%edx),%dl
  800a69:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6e:	8a 00                	mov    (%eax),%al
  800a70:	84 c0                	test   %al,%al
  800a72:	74 03                	je     800a77 <strncpy+0x31>
			src++;
  800a74:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a77:	ff 45 fc             	incl   -0x4(%ebp)
  800a7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a7d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a80:	72 d9                	jb     800a5b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a82:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a85:	c9                   	leave  
  800a86:	c3                   	ret    

00800a87 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a87:	55                   	push   %ebp
  800a88:	89 e5                	mov    %esp,%ebp
  800a8a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a93:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a97:	74 30                	je     800ac9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a99:	eb 16                	jmp    800ab1 <strlcpy+0x2a>
			*dst++ = *src++;
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	8d 50 01             	lea    0x1(%eax),%edx
  800aa1:	89 55 08             	mov    %edx,0x8(%ebp)
  800aa4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800aaa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800aad:	8a 12                	mov    (%edx),%dl
  800aaf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ab1:	ff 4d 10             	decl   0x10(%ebp)
  800ab4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ab8:	74 09                	je     800ac3 <strlcpy+0x3c>
  800aba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abd:	8a 00                	mov    (%eax),%al
  800abf:	84 c0                	test   %al,%al
  800ac1:	75 d8                	jne    800a9b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ac9:	8b 55 08             	mov    0x8(%ebp),%edx
  800acc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800acf:	29 c2                	sub    %eax,%edx
  800ad1:	89 d0                	mov    %edx,%eax
}
  800ad3:	c9                   	leave  
  800ad4:	c3                   	ret    

00800ad5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ad5:	55                   	push   %ebp
  800ad6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ad8:	eb 06                	jmp    800ae0 <strcmp+0xb>
		p++, q++;
  800ada:	ff 45 08             	incl   0x8(%ebp)
  800add:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	8a 00                	mov    (%eax),%al
  800ae5:	84 c0                	test   %al,%al
  800ae7:	74 0e                	je     800af7 <strcmp+0x22>
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	8a 10                	mov    (%eax),%dl
  800aee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af1:	8a 00                	mov    (%eax),%al
  800af3:	38 c2                	cmp    %al,%dl
  800af5:	74 e3                	je     800ada <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	8a 00                	mov    (%eax),%al
  800afc:	0f b6 d0             	movzbl %al,%edx
  800aff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b02:	8a 00                	mov    (%eax),%al
  800b04:	0f b6 c0             	movzbl %al,%eax
  800b07:	29 c2                	sub    %eax,%edx
  800b09:	89 d0                	mov    %edx,%eax
}
  800b0b:	5d                   	pop    %ebp
  800b0c:	c3                   	ret    

00800b0d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b10:	eb 09                	jmp    800b1b <strncmp+0xe>
		n--, p++, q++;
  800b12:	ff 4d 10             	decl   0x10(%ebp)
  800b15:	ff 45 08             	incl   0x8(%ebp)
  800b18:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b1f:	74 17                	je     800b38 <strncmp+0x2b>
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	8a 00                	mov    (%eax),%al
  800b26:	84 c0                	test   %al,%al
  800b28:	74 0e                	je     800b38 <strncmp+0x2b>
  800b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2d:	8a 10                	mov    (%eax),%dl
  800b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b32:	8a 00                	mov    (%eax),%al
  800b34:	38 c2                	cmp    %al,%dl
  800b36:	74 da                	je     800b12 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b38:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b3c:	75 07                	jne    800b45 <strncmp+0x38>
		return 0;
  800b3e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b43:	eb 14                	jmp    800b59 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
  800b48:	8a 00                	mov    (%eax),%al
  800b4a:	0f b6 d0             	movzbl %al,%edx
  800b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b50:	8a 00                	mov    (%eax),%al
  800b52:	0f b6 c0             	movzbl %al,%eax
  800b55:	29 c2                	sub    %eax,%edx
  800b57:	89 d0                	mov    %edx,%eax
}
  800b59:	5d                   	pop    %ebp
  800b5a:	c3                   	ret    

00800b5b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	83 ec 04             	sub    $0x4,%esp
  800b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b64:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b67:	eb 12                	jmp    800b7b <strchr+0x20>
		if (*s == c)
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	8a 00                	mov    (%eax),%al
  800b6e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b71:	75 05                	jne    800b78 <strchr+0x1d>
			return (char *) s;
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	eb 11                	jmp    800b89 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b78:	ff 45 08             	incl   0x8(%ebp)
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	8a 00                	mov    (%eax),%al
  800b80:	84 c0                	test   %al,%al
  800b82:	75 e5                	jne    800b69 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b89:	c9                   	leave  
  800b8a:	c3                   	ret    

00800b8b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	83 ec 04             	sub    $0x4,%esp
  800b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b94:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b97:	eb 0d                	jmp    800ba6 <strfind+0x1b>
		if (*s == c)
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8a 00                	mov    (%eax),%al
  800b9e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba1:	74 0e                	je     800bb1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ba3:	ff 45 08             	incl   0x8(%ebp)
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	8a 00                	mov    (%eax),%al
  800bab:	84 c0                	test   %al,%al
  800bad:	75 ea                	jne    800b99 <strfind+0xe>
  800baf:	eb 01                	jmp    800bb2 <strfind+0x27>
		if (*s == c)
			break;
  800bb1:	90                   	nop
	return (char *) s;
  800bb2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bb5:	c9                   	leave  
  800bb6:	c3                   	ret    

00800bb7 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800bc3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800bc7:	76 63                	jbe    800c2c <memset+0x75>
		uint64 data_block = c;
  800bc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcc:	99                   	cltd   
  800bcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd0:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800bd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd9:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800bdd:	c1 e0 08             	shl    $0x8,%eax
  800be0:	09 45 f0             	or     %eax,-0x10(%ebp)
  800be3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bec:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800bf0:	c1 e0 10             	shl    $0x10,%eax
  800bf3:	09 45 f0             	or     %eax,-0x10(%ebp)
  800bf6:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800bf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bff:	89 c2                	mov    %eax,%edx
  800c01:	b8 00 00 00 00       	mov    $0x0,%eax
  800c06:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c09:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800c0c:	eb 18                	jmp    800c26 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800c0e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800c11:	8d 41 08             	lea    0x8(%ecx),%eax
  800c14:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c1d:	89 01                	mov    %eax,(%ecx)
  800c1f:	89 51 04             	mov    %edx,0x4(%ecx)
  800c22:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800c26:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c2a:	77 e2                	ja     800c0e <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800c2c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c30:	74 23                	je     800c55 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800c32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c35:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c38:	eb 0e                	jmp    800c48 <memset+0x91>
			*p8++ = (uint8)c;
  800c3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c3d:	8d 50 01             	lea    0x1(%eax),%edx
  800c40:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c43:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c46:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800c48:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c4e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c51:	85 c0                	test   %eax,%eax
  800c53:	75 e5                	jne    800c3a <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c58:	c9                   	leave  
  800c59:	c3                   	ret    

00800c5a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800c6c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c70:	76 24                	jbe    800c96 <memcpy+0x3c>
		while(n >= 8){
  800c72:	eb 1c                	jmp    800c90 <memcpy+0x36>
			*d64 = *s64;
  800c74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c77:	8b 50 04             	mov    0x4(%eax),%edx
  800c7a:	8b 00                	mov    (%eax),%eax
  800c7c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800c7f:	89 01                	mov    %eax,(%ecx)
  800c81:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800c84:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800c88:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800c8c:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800c90:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c94:	77 de                	ja     800c74 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800c96:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c9a:	74 31                	je     800ccd <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800c9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800ca2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ca5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800ca8:	eb 16                	jmp    800cc0 <memcpy+0x66>
			*d8++ = *s8++;
  800caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cad:	8d 50 01             	lea    0x1(%eax),%edx
  800cb0:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800cb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cb6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cb9:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800cbc:	8a 12                	mov    (%edx),%dl
  800cbe:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800cc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc6:	89 55 10             	mov    %edx,0x10(%ebp)
  800cc9:	85 c0                	test   %eax,%eax
  800ccb:	75 dd                	jne    800caa <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd0:	c9                   	leave  
  800cd1:	c3                   	ret    

00800cd2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ce4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800cea:	73 50                	jae    800d3c <memmove+0x6a>
  800cec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cef:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf2:	01 d0                	add    %edx,%eax
  800cf4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800cf7:	76 43                	jbe    800d3c <memmove+0x6a>
		s += n;
  800cf9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfc:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800cff:	8b 45 10             	mov    0x10(%ebp),%eax
  800d02:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d05:	eb 10                	jmp    800d17 <memmove+0x45>
			*--d = *--s;
  800d07:	ff 4d f8             	decl   -0x8(%ebp)
  800d0a:	ff 4d fc             	decl   -0x4(%ebp)
  800d0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d10:	8a 10                	mov    (%eax),%dl
  800d12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d15:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d17:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d1d:	89 55 10             	mov    %edx,0x10(%ebp)
  800d20:	85 c0                	test   %eax,%eax
  800d22:	75 e3                	jne    800d07 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d24:	eb 23                	jmp    800d49 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d29:	8d 50 01             	lea    0x1(%eax),%edx
  800d2c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d2f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d32:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d35:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d38:	8a 12                	mov    (%edx),%dl
  800d3a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d42:	89 55 10             	mov    %edx,0x10(%ebp)
  800d45:	85 c0                	test   %eax,%eax
  800d47:	75 dd                	jne    800d26 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d4c:	c9                   	leave  
  800d4d:	c3                   	ret    

00800d4e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
  800d51:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d60:	eb 2a                	jmp    800d8c <memcmp+0x3e>
		if (*s1 != *s2)
  800d62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d65:	8a 10                	mov    (%eax),%dl
  800d67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	38 c2                	cmp    %al,%dl
  800d6e:	74 16                	je     800d86 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	0f b6 d0             	movzbl %al,%edx
  800d78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	0f b6 c0             	movzbl %al,%eax
  800d80:	29 c2                	sub    %eax,%edx
  800d82:	89 d0                	mov    %edx,%eax
  800d84:	eb 18                	jmp    800d9e <memcmp+0x50>
		s1++, s2++;
  800d86:	ff 45 fc             	incl   -0x4(%ebp)
  800d89:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d92:	89 55 10             	mov    %edx,0x10(%ebp)
  800d95:	85 c0                	test   %eax,%eax
  800d97:	75 c9                	jne    800d62 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d9e:	c9                   	leave  
  800d9f:	c3                   	ret    

00800da0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800da6:	8b 55 08             	mov    0x8(%ebp),%edx
  800da9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dac:	01 d0                	add    %edx,%eax
  800dae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800db1:	eb 15                	jmp    800dc8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	8a 00                	mov    (%eax),%al
  800db8:	0f b6 d0             	movzbl %al,%edx
  800dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbe:	0f b6 c0             	movzbl %al,%eax
  800dc1:	39 c2                	cmp    %eax,%edx
  800dc3:	74 0d                	je     800dd2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800dc5:	ff 45 08             	incl   0x8(%ebp)
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800dce:	72 e3                	jb     800db3 <memfind+0x13>
  800dd0:	eb 01                	jmp    800dd3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800dd2:	90                   	nop
	return (void *) s;
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd6:	c9                   	leave  
  800dd7:	c3                   	ret    

00800dd8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800dde:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800de5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dec:	eb 03                	jmp    800df1 <strtol+0x19>
		s++;
  800dee:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	8a 00                	mov    (%eax),%al
  800df6:	3c 20                	cmp    $0x20,%al
  800df8:	74 f4                	je     800dee <strtol+0x16>
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	8a 00                	mov    (%eax),%al
  800dff:	3c 09                	cmp    $0x9,%al
  800e01:	74 eb                	je     800dee <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e03:	8b 45 08             	mov    0x8(%ebp),%eax
  800e06:	8a 00                	mov    (%eax),%al
  800e08:	3c 2b                	cmp    $0x2b,%al
  800e0a:	75 05                	jne    800e11 <strtol+0x39>
		s++;
  800e0c:	ff 45 08             	incl   0x8(%ebp)
  800e0f:	eb 13                	jmp    800e24 <strtol+0x4c>
	else if (*s == '-')
  800e11:	8b 45 08             	mov    0x8(%ebp),%eax
  800e14:	8a 00                	mov    (%eax),%al
  800e16:	3c 2d                	cmp    $0x2d,%al
  800e18:	75 0a                	jne    800e24 <strtol+0x4c>
		s++, neg = 1;
  800e1a:	ff 45 08             	incl   0x8(%ebp)
  800e1d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e28:	74 06                	je     800e30 <strtol+0x58>
  800e2a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e2e:	75 20                	jne    800e50 <strtol+0x78>
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	8a 00                	mov    (%eax),%al
  800e35:	3c 30                	cmp    $0x30,%al
  800e37:	75 17                	jne    800e50 <strtol+0x78>
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	40                   	inc    %eax
  800e3d:	8a 00                	mov    (%eax),%al
  800e3f:	3c 78                	cmp    $0x78,%al
  800e41:	75 0d                	jne    800e50 <strtol+0x78>
		s += 2, base = 16;
  800e43:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e47:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e4e:	eb 28                	jmp    800e78 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e54:	75 15                	jne    800e6b <strtol+0x93>
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	8a 00                	mov    (%eax),%al
  800e5b:	3c 30                	cmp    $0x30,%al
  800e5d:	75 0c                	jne    800e6b <strtol+0x93>
		s++, base = 8;
  800e5f:	ff 45 08             	incl   0x8(%ebp)
  800e62:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e69:	eb 0d                	jmp    800e78 <strtol+0xa0>
	else if (base == 0)
  800e6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e6f:	75 07                	jne    800e78 <strtol+0xa0>
		base = 10;
  800e71:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	3c 2f                	cmp    $0x2f,%al
  800e7f:	7e 19                	jle    800e9a <strtol+0xc2>
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	3c 39                	cmp    $0x39,%al
  800e88:	7f 10                	jg     800e9a <strtol+0xc2>
			dig = *s - '0';
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	0f be c0             	movsbl %al,%eax
  800e92:	83 e8 30             	sub    $0x30,%eax
  800e95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e98:	eb 42                	jmp    800edc <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	8a 00                	mov    (%eax),%al
  800e9f:	3c 60                	cmp    $0x60,%al
  800ea1:	7e 19                	jle    800ebc <strtol+0xe4>
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	3c 7a                	cmp    $0x7a,%al
  800eaa:	7f 10                	jg     800ebc <strtol+0xe4>
			dig = *s - 'a' + 10;
  800eac:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaf:	8a 00                	mov    (%eax),%al
  800eb1:	0f be c0             	movsbl %al,%eax
  800eb4:	83 e8 57             	sub    $0x57,%eax
  800eb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800eba:	eb 20                	jmp    800edc <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	8a 00                	mov    (%eax),%al
  800ec1:	3c 40                	cmp    $0x40,%al
  800ec3:	7e 39                	jle    800efe <strtol+0x126>
  800ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec8:	8a 00                	mov    (%eax),%al
  800eca:	3c 5a                	cmp    $0x5a,%al
  800ecc:	7f 30                	jg     800efe <strtol+0x126>
			dig = *s - 'A' + 10;
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	0f be c0             	movsbl %al,%eax
  800ed6:	83 e8 37             	sub    $0x37,%eax
  800ed9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800edf:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ee2:	7d 19                	jge    800efd <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ee4:	ff 45 08             	incl   0x8(%ebp)
  800ee7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eea:	0f af 45 10          	imul   0x10(%ebp),%eax
  800eee:	89 c2                	mov    %eax,%edx
  800ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef3:	01 d0                	add    %edx,%eax
  800ef5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800ef8:	e9 7b ff ff ff       	jmp    800e78 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800efd:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800efe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f02:	74 08                	je     800f0c <strtol+0x134>
		*endptr = (char *) s;
  800f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f07:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f10:	74 07                	je     800f19 <strtol+0x141>
  800f12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f15:	f7 d8                	neg    %eax
  800f17:	eb 03                	jmp    800f1c <strtol+0x144>
  800f19:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f1c:	c9                   	leave  
  800f1d:	c3                   	ret    

00800f1e <ltostr>:

void
ltostr(long value, char *str)
{
  800f1e:	55                   	push   %ebp
  800f1f:	89 e5                	mov    %esp,%ebp
  800f21:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f2b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f32:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f36:	79 13                	jns    800f4b <ltostr+0x2d>
	{
		neg = 1;
  800f38:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f42:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f45:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f48:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f53:	99                   	cltd   
  800f54:	f7 f9                	idiv   %ecx
  800f56:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5c:	8d 50 01             	lea    0x1(%eax),%edx
  800f5f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f62:	89 c2                	mov    %eax,%edx
  800f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f67:	01 d0                	add    %edx,%eax
  800f69:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f6c:	83 c2 30             	add    $0x30,%edx
  800f6f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f74:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f79:	f7 e9                	imul   %ecx
  800f7b:	c1 fa 02             	sar    $0x2,%edx
  800f7e:	89 c8                	mov    %ecx,%eax
  800f80:	c1 f8 1f             	sar    $0x1f,%eax
  800f83:	29 c2                	sub    %eax,%edx
  800f85:	89 d0                	mov    %edx,%eax
  800f87:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800f8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f8e:	75 bb                	jne    800f4b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9a:	48                   	dec    %eax
  800f9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fa2:	74 3d                	je     800fe1 <ltostr+0xc3>
		start = 1 ;
  800fa4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800fab:	eb 34                	jmp    800fe1 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800fad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb3:	01 d0                	add    %edx,%eax
  800fb5:	8a 00                	mov    (%eax),%al
  800fb7:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800fba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc0:	01 c2                	add    %eax,%edx
  800fc2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc8:	01 c8                	add    %ecx,%eax
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800fce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd4:	01 c2                	add    %eax,%edx
  800fd6:	8a 45 eb             	mov    -0x15(%ebp),%al
  800fd9:	88 02                	mov    %al,(%edx)
		start++ ;
  800fdb:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800fde:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fe7:	7c c4                	jl     800fad <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800fe9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fef:	01 d0                	add    %edx,%eax
  800ff1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800ff4:	90                   	nop
  800ff5:	c9                   	leave  
  800ff6:	c3                   	ret    

00800ff7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800ff7:	55                   	push   %ebp
  800ff8:	89 e5                	mov    %esp,%ebp
  800ffa:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ffd:	ff 75 08             	pushl  0x8(%ebp)
  801000:	e8 c4 f9 ff ff       	call   8009c9 <strlen>
  801005:	83 c4 04             	add    $0x4,%esp
  801008:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80100b:	ff 75 0c             	pushl  0xc(%ebp)
  80100e:	e8 b6 f9 ff ff       	call   8009c9 <strlen>
  801013:	83 c4 04             	add    $0x4,%esp
  801016:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801019:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801020:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801027:	eb 17                	jmp    801040 <strcconcat+0x49>
		final[s] = str1[s] ;
  801029:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80102c:	8b 45 10             	mov    0x10(%ebp),%eax
  80102f:	01 c2                	add    %eax,%edx
  801031:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801034:	8b 45 08             	mov    0x8(%ebp),%eax
  801037:	01 c8                	add    %ecx,%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80103d:	ff 45 fc             	incl   -0x4(%ebp)
  801040:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801043:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801046:	7c e1                	jl     801029 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801048:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80104f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801056:	eb 1f                	jmp    801077 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801058:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80105b:	8d 50 01             	lea    0x1(%eax),%edx
  80105e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801061:	89 c2                	mov    %eax,%edx
  801063:	8b 45 10             	mov    0x10(%ebp),%eax
  801066:	01 c2                	add    %eax,%edx
  801068:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80106b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106e:	01 c8                	add    %ecx,%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801074:	ff 45 f8             	incl   -0x8(%ebp)
  801077:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80107d:	7c d9                	jl     801058 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80107f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801082:	8b 45 10             	mov    0x10(%ebp),%eax
  801085:	01 d0                	add    %edx,%eax
  801087:	c6 00 00             	movb   $0x0,(%eax)
}
  80108a:	90                   	nop
  80108b:	c9                   	leave  
  80108c:	c3                   	ret    

0080108d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80108d:	55                   	push   %ebp
  80108e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801090:	8b 45 14             	mov    0x14(%ebp),%eax
  801093:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801099:	8b 45 14             	mov    0x14(%ebp),%eax
  80109c:	8b 00                	mov    (%eax),%eax
  80109e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a8:	01 d0                	add    %edx,%eax
  8010aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010b0:	eb 0c                	jmp    8010be <strsplit+0x31>
			*string++ = 0;
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	8d 50 01             	lea    0x1(%eax),%edx
  8010b8:	89 55 08             	mov    %edx,0x8(%ebp)
  8010bb:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	8a 00                	mov    (%eax),%al
  8010c3:	84 c0                	test   %al,%al
  8010c5:	74 18                	je     8010df <strsplit+0x52>
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	0f be c0             	movsbl %al,%eax
  8010cf:	50                   	push   %eax
  8010d0:	ff 75 0c             	pushl  0xc(%ebp)
  8010d3:	e8 83 fa ff ff       	call   800b5b <strchr>
  8010d8:	83 c4 08             	add    $0x8,%esp
  8010db:	85 c0                	test   %eax,%eax
  8010dd:	75 d3                	jne    8010b2 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	8a 00                	mov    (%eax),%al
  8010e4:	84 c0                	test   %al,%al
  8010e6:	74 5a                	je     801142 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8010e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010eb:	8b 00                	mov    (%eax),%eax
  8010ed:	83 f8 0f             	cmp    $0xf,%eax
  8010f0:	75 07                	jne    8010f9 <strsplit+0x6c>
		{
			return 0;
  8010f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f7:	eb 66                	jmp    80115f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8010f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8010fc:	8b 00                	mov    (%eax),%eax
  8010fe:	8d 48 01             	lea    0x1(%eax),%ecx
  801101:	8b 55 14             	mov    0x14(%ebp),%edx
  801104:	89 0a                	mov    %ecx,(%edx)
  801106:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80110d:	8b 45 10             	mov    0x10(%ebp),%eax
  801110:	01 c2                	add    %eax,%edx
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801117:	eb 03                	jmp    80111c <strsplit+0x8f>
			string++;
  801119:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	84 c0                	test   %al,%al
  801123:	74 8b                	je     8010b0 <strsplit+0x23>
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	8a 00                	mov    (%eax),%al
  80112a:	0f be c0             	movsbl %al,%eax
  80112d:	50                   	push   %eax
  80112e:	ff 75 0c             	pushl  0xc(%ebp)
  801131:	e8 25 fa ff ff       	call   800b5b <strchr>
  801136:	83 c4 08             	add    $0x8,%esp
  801139:	85 c0                	test   %eax,%eax
  80113b:	74 dc                	je     801119 <strsplit+0x8c>
			string++;
	}
  80113d:	e9 6e ff ff ff       	jmp    8010b0 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801142:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801143:	8b 45 14             	mov    0x14(%ebp),%eax
  801146:	8b 00                	mov    (%eax),%eax
  801148:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80114f:	8b 45 10             	mov    0x10(%ebp),%eax
  801152:	01 d0                	add    %edx,%eax
  801154:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80115a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80115f:	c9                   	leave  
  801160:	c3                   	ret    

00801161 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801161:	55                   	push   %ebp
  801162:	89 e5                	mov    %esp,%ebp
  801164:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
  80116a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80116d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801174:	eb 4a                	jmp    8011c0 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801176:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	01 c2                	add    %eax,%edx
  80117e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801181:	8b 45 0c             	mov    0xc(%ebp),%eax
  801184:	01 c8                	add    %ecx,%eax
  801186:	8a 00                	mov    (%eax),%al
  801188:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80118a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80118d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801190:	01 d0                	add    %edx,%eax
  801192:	8a 00                	mov    (%eax),%al
  801194:	3c 40                	cmp    $0x40,%al
  801196:	7e 25                	jle    8011bd <str2lower+0x5c>
  801198:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80119b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119e:	01 d0                	add    %edx,%eax
  8011a0:	8a 00                	mov    (%eax),%al
  8011a2:	3c 5a                	cmp    $0x5a,%al
  8011a4:	7f 17                	jg     8011bd <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8011a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	01 d0                	add    %edx,%eax
  8011ae:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b4:	01 ca                	add    %ecx,%edx
  8011b6:	8a 12                	mov    (%edx),%dl
  8011b8:	83 c2 20             	add    $0x20,%edx
  8011bb:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8011bd:	ff 45 fc             	incl   -0x4(%ebp)
  8011c0:	ff 75 0c             	pushl  0xc(%ebp)
  8011c3:	e8 01 f8 ff ff       	call   8009c9 <strlen>
  8011c8:	83 c4 04             	add    $0x4,%esp
  8011cb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011ce:	7f a6                	jg     801176 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8011d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011d3:	c9                   	leave  
  8011d4:	c3                   	ret    

008011d5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011d5:	55                   	push   %ebp
  8011d6:	89 e5                	mov    %esp,%ebp
  8011d8:	57                   	push   %edi
  8011d9:	56                   	push   %esi
  8011da:	53                   	push   %ebx
  8011db:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011de:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011e7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011ea:	8b 7d 18             	mov    0x18(%ebp),%edi
  8011ed:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8011f0:	cd 30                	int    $0x30
  8011f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8011f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011f8:	83 c4 10             	add    $0x10,%esp
  8011fb:	5b                   	pop    %ebx
  8011fc:	5e                   	pop    %esi
  8011fd:	5f                   	pop    %edi
  8011fe:	5d                   	pop    %ebp
  8011ff:	c3                   	ret    

00801200 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	83 ec 04             	sub    $0x4,%esp
  801206:	8b 45 10             	mov    0x10(%ebp),%eax
  801209:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80120c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80120f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	6a 00                	push   $0x0
  801218:	51                   	push   %ecx
  801219:	52                   	push   %edx
  80121a:	ff 75 0c             	pushl  0xc(%ebp)
  80121d:	50                   	push   %eax
  80121e:	6a 00                	push   $0x0
  801220:	e8 b0 ff ff ff       	call   8011d5 <syscall>
  801225:	83 c4 18             	add    $0x18,%esp
}
  801228:	90                   	nop
  801229:	c9                   	leave  
  80122a:	c3                   	ret    

0080122b <sys_cgetc>:

int
sys_cgetc(void)
{
  80122b:	55                   	push   %ebp
  80122c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80122e:	6a 00                	push   $0x0
  801230:	6a 00                	push   $0x0
  801232:	6a 00                	push   $0x0
  801234:	6a 00                	push   $0x0
  801236:	6a 00                	push   $0x0
  801238:	6a 02                	push   $0x2
  80123a:	e8 96 ff ff ff       	call   8011d5 <syscall>
  80123f:	83 c4 18             	add    $0x18,%esp
}
  801242:	c9                   	leave  
  801243:	c3                   	ret    

00801244 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801244:	55                   	push   %ebp
  801245:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801247:	6a 00                	push   $0x0
  801249:	6a 00                	push   $0x0
  80124b:	6a 00                	push   $0x0
  80124d:	6a 00                	push   $0x0
  80124f:	6a 00                	push   $0x0
  801251:	6a 03                	push   $0x3
  801253:	e8 7d ff ff ff       	call   8011d5 <syscall>
  801258:	83 c4 18             	add    $0x18,%esp
}
  80125b:	90                   	nop
  80125c:	c9                   	leave  
  80125d:	c3                   	ret    

0080125e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80125e:	55                   	push   %ebp
  80125f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801261:	6a 00                	push   $0x0
  801263:	6a 00                	push   $0x0
  801265:	6a 00                	push   $0x0
  801267:	6a 00                	push   $0x0
  801269:	6a 00                	push   $0x0
  80126b:	6a 04                	push   $0x4
  80126d:	e8 63 ff ff ff       	call   8011d5 <syscall>
  801272:	83 c4 18             	add    $0x18,%esp
}
  801275:	90                   	nop
  801276:	c9                   	leave  
  801277:	c3                   	ret    

00801278 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80127b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	6a 00                	push   $0x0
  801283:	6a 00                	push   $0x0
  801285:	6a 00                	push   $0x0
  801287:	52                   	push   %edx
  801288:	50                   	push   %eax
  801289:	6a 08                	push   $0x8
  80128b:	e8 45 ff ff ff       	call   8011d5 <syscall>
  801290:	83 c4 18             	add    $0x18,%esp
}
  801293:	c9                   	leave  
  801294:	c3                   	ret    

00801295 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801295:	55                   	push   %ebp
  801296:	89 e5                	mov    %esp,%ebp
  801298:	56                   	push   %esi
  801299:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80129a:	8b 75 18             	mov    0x18(%ebp),%esi
  80129d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a9:	56                   	push   %esi
  8012aa:	53                   	push   %ebx
  8012ab:	51                   	push   %ecx
  8012ac:	52                   	push   %edx
  8012ad:	50                   	push   %eax
  8012ae:	6a 09                	push   $0x9
  8012b0:	e8 20 ff ff ff       	call   8011d5 <syscall>
  8012b5:	83 c4 18             	add    $0x18,%esp
}
  8012b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012bb:	5b                   	pop    %ebx
  8012bc:	5e                   	pop    %esi
  8012bd:	5d                   	pop    %ebp
  8012be:	c3                   	ret    

008012bf <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8012c2:	6a 00                	push   $0x0
  8012c4:	6a 00                	push   $0x0
  8012c6:	6a 00                	push   $0x0
  8012c8:	6a 00                	push   $0x0
  8012ca:	ff 75 08             	pushl  0x8(%ebp)
  8012cd:	6a 0a                	push   $0xa
  8012cf:	e8 01 ff ff ff       	call   8011d5 <syscall>
  8012d4:	83 c4 18             	add    $0x18,%esp
}
  8012d7:	c9                   	leave  
  8012d8:	c3                   	ret    

008012d9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012d9:	55                   	push   %ebp
  8012da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8012dc:	6a 00                	push   $0x0
  8012de:	6a 00                	push   $0x0
  8012e0:	6a 00                	push   $0x0
  8012e2:	ff 75 0c             	pushl  0xc(%ebp)
  8012e5:	ff 75 08             	pushl  0x8(%ebp)
  8012e8:	6a 0b                	push   $0xb
  8012ea:	e8 e6 fe ff ff       	call   8011d5 <syscall>
  8012ef:	83 c4 18             	add    $0x18,%esp
}
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8012f7:	6a 00                	push   $0x0
  8012f9:	6a 00                	push   $0x0
  8012fb:	6a 00                	push   $0x0
  8012fd:	6a 00                	push   $0x0
  8012ff:	6a 00                	push   $0x0
  801301:	6a 0c                	push   $0xc
  801303:	e8 cd fe ff ff       	call   8011d5 <syscall>
  801308:	83 c4 18             	add    $0x18,%esp
}
  80130b:	c9                   	leave  
  80130c:	c3                   	ret    

0080130d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801310:	6a 00                	push   $0x0
  801312:	6a 00                	push   $0x0
  801314:	6a 00                	push   $0x0
  801316:	6a 00                	push   $0x0
  801318:	6a 00                	push   $0x0
  80131a:	6a 0d                	push   $0xd
  80131c:	e8 b4 fe ff ff       	call   8011d5 <syscall>
  801321:	83 c4 18             	add    $0x18,%esp
}
  801324:	c9                   	leave  
  801325:	c3                   	ret    

00801326 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801329:	6a 00                	push   $0x0
  80132b:	6a 00                	push   $0x0
  80132d:	6a 00                	push   $0x0
  80132f:	6a 00                	push   $0x0
  801331:	6a 00                	push   $0x0
  801333:	6a 0e                	push   $0xe
  801335:	e8 9b fe ff ff       	call   8011d5 <syscall>
  80133a:	83 c4 18             	add    $0x18,%esp
}
  80133d:	c9                   	leave  
  80133e:	c3                   	ret    

0080133f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801342:	6a 00                	push   $0x0
  801344:	6a 00                	push   $0x0
  801346:	6a 00                	push   $0x0
  801348:	6a 00                	push   $0x0
  80134a:	6a 00                	push   $0x0
  80134c:	6a 0f                	push   $0xf
  80134e:	e8 82 fe ff ff       	call   8011d5 <syscall>
  801353:	83 c4 18             	add    $0x18,%esp
}
  801356:	c9                   	leave  
  801357:	c3                   	ret    

00801358 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801358:	55                   	push   %ebp
  801359:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80135b:	6a 00                	push   $0x0
  80135d:	6a 00                	push   $0x0
  80135f:	6a 00                	push   $0x0
  801361:	6a 00                	push   $0x0
  801363:	ff 75 08             	pushl  0x8(%ebp)
  801366:	6a 10                	push   $0x10
  801368:	e8 68 fe ff ff       	call   8011d5 <syscall>
  80136d:	83 c4 18             	add    $0x18,%esp
}
  801370:	c9                   	leave  
  801371:	c3                   	ret    

00801372 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801372:	55                   	push   %ebp
  801373:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801375:	6a 00                	push   $0x0
  801377:	6a 00                	push   $0x0
  801379:	6a 00                	push   $0x0
  80137b:	6a 00                	push   $0x0
  80137d:	6a 00                	push   $0x0
  80137f:	6a 11                	push   $0x11
  801381:	e8 4f fe ff ff       	call   8011d5 <syscall>
  801386:	83 c4 18             	add    $0x18,%esp
}
  801389:	90                   	nop
  80138a:	c9                   	leave  
  80138b:	c3                   	ret    

0080138c <sys_cputc>:

void
sys_cputc(const char c)
{
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
  80138f:	83 ec 04             	sub    $0x4,%esp
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801398:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	50                   	push   %eax
  8013a5:	6a 01                	push   $0x1
  8013a7:	e8 29 fe ff ff       	call   8011d5 <syscall>
  8013ac:	83 c4 18             	add    $0x18,%esp
}
  8013af:	90                   	nop
  8013b0:	c9                   	leave  
  8013b1:	c3                   	ret    

008013b2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013b2:	55                   	push   %ebp
  8013b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 14                	push   $0x14
  8013c1:	e8 0f fe ff ff       	call   8011d5 <syscall>
  8013c6:	83 c4 18             	add    $0x18,%esp
}
  8013c9:	90                   	nop
  8013ca:	c9                   	leave  
  8013cb:	c3                   	ret    

008013cc <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
  8013cf:	83 ec 04             	sub    $0x4,%esp
  8013d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8013d8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013db:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	6a 00                	push   $0x0
  8013e4:	51                   	push   %ecx
  8013e5:	52                   	push   %edx
  8013e6:	ff 75 0c             	pushl  0xc(%ebp)
  8013e9:	50                   	push   %eax
  8013ea:	6a 15                	push   $0x15
  8013ec:	e8 e4 fd ff ff       	call   8011d5 <syscall>
  8013f1:	83 c4 18             	add    $0x18,%esp
}
  8013f4:	c9                   	leave  
  8013f5:	c3                   	ret    

008013f6 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8013f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ff:	6a 00                	push   $0x0
  801401:	6a 00                	push   $0x0
  801403:	6a 00                	push   $0x0
  801405:	52                   	push   %edx
  801406:	50                   	push   %eax
  801407:	6a 16                	push   $0x16
  801409:	e8 c7 fd ff ff       	call   8011d5 <syscall>
  80140e:	83 c4 18             	add    $0x18,%esp
}
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801416:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801419:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141c:	8b 45 08             	mov    0x8(%ebp),%eax
  80141f:	6a 00                	push   $0x0
  801421:	6a 00                	push   $0x0
  801423:	51                   	push   %ecx
  801424:	52                   	push   %edx
  801425:	50                   	push   %eax
  801426:	6a 17                	push   $0x17
  801428:	e8 a8 fd ff ff       	call   8011d5 <syscall>
  80142d:	83 c4 18             	add    $0x18,%esp
}
  801430:	c9                   	leave  
  801431:	c3                   	ret    

00801432 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801435:	8b 55 0c             	mov    0xc(%ebp),%edx
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	52                   	push   %edx
  801442:	50                   	push   %eax
  801443:	6a 18                	push   $0x18
  801445:	e8 8b fd ff ff       	call   8011d5 <syscall>
  80144a:	83 c4 18             	add    $0x18,%esp
}
  80144d:	c9                   	leave  
  80144e:	c3                   	ret    

0080144f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	6a 00                	push   $0x0
  801457:	ff 75 14             	pushl  0x14(%ebp)
  80145a:	ff 75 10             	pushl  0x10(%ebp)
  80145d:	ff 75 0c             	pushl  0xc(%ebp)
  801460:	50                   	push   %eax
  801461:	6a 19                	push   $0x19
  801463:	e8 6d fd ff ff       	call   8011d5 <syscall>
  801468:	83 c4 18             	add    $0x18,%esp
}
  80146b:	c9                   	leave  
  80146c:	c3                   	ret    

0080146d <sys_run_env>:

void sys_run_env(int32 envId)
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801470:	8b 45 08             	mov    0x8(%ebp),%eax
  801473:	6a 00                	push   $0x0
  801475:	6a 00                	push   $0x0
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	50                   	push   %eax
  80147c:	6a 1a                	push   $0x1a
  80147e:	e8 52 fd ff ff       	call   8011d5 <syscall>
  801483:	83 c4 18             	add    $0x18,%esp
}
  801486:	90                   	nop
  801487:	c9                   	leave  
  801488:	c3                   	ret    

00801489 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801489:	55                   	push   %ebp
  80148a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	6a 00                	push   $0x0
  801491:	6a 00                	push   $0x0
  801493:	6a 00                	push   $0x0
  801495:	6a 00                	push   $0x0
  801497:	50                   	push   %eax
  801498:	6a 1b                	push   $0x1b
  80149a:	e8 36 fd ff ff       	call   8011d5 <syscall>
  80149f:	83 c4 18             	add    $0x18,%esp
}
  8014a2:	c9                   	leave  
  8014a3:	c3                   	ret    

008014a4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 05                	push   $0x5
  8014b3:	e8 1d fd ff ff       	call   8011d5 <syscall>
  8014b8:	83 c4 18             	add    $0x18,%esp
}
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    

008014bd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 06                	push   $0x6
  8014cc:	e8 04 fd ff ff       	call   8011d5 <syscall>
  8014d1:	83 c4 18             	add    $0x18,%esp
}
  8014d4:	c9                   	leave  
  8014d5:	c3                   	ret    

008014d6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 00                	push   $0x0
  8014e1:	6a 00                	push   $0x0
  8014e3:	6a 07                	push   $0x7
  8014e5:	e8 eb fc ff ff       	call   8011d5 <syscall>
  8014ea:	83 c4 18             	add    $0x18,%esp
}
  8014ed:	c9                   	leave  
  8014ee:	c3                   	ret    

008014ef <sys_exit_env>:


void sys_exit_env(void)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 1c                	push   $0x1c
  8014fe:	e8 d2 fc ff ff       	call   8011d5 <syscall>
  801503:	83 c4 18             	add    $0x18,%esp
}
  801506:	90                   	nop
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
  80150c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80150f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801512:	8d 50 04             	lea    0x4(%eax),%edx
  801515:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	52                   	push   %edx
  80151f:	50                   	push   %eax
  801520:	6a 1d                	push   $0x1d
  801522:	e8 ae fc ff ff       	call   8011d5 <syscall>
  801527:	83 c4 18             	add    $0x18,%esp
	return result;
  80152a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80152d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801530:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801533:	89 01                	mov    %eax,(%ecx)
  801535:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	c9                   	leave  
  80153c:	c2 04 00             	ret    $0x4

0080153f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	ff 75 10             	pushl  0x10(%ebp)
  801549:	ff 75 0c             	pushl  0xc(%ebp)
  80154c:	ff 75 08             	pushl  0x8(%ebp)
  80154f:	6a 13                	push   $0x13
  801551:	e8 7f fc ff ff       	call   8011d5 <syscall>
  801556:	83 c4 18             	add    $0x18,%esp
	return ;
  801559:	90                   	nop
}
  80155a:	c9                   	leave  
  80155b:	c3                   	ret    

0080155c <sys_rcr2>:
uint32 sys_rcr2()
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	6a 00                	push   $0x0
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 1e                	push   $0x1e
  80156b:	e8 65 fc ff ff       	call   8011d5 <syscall>
  801570:	83 c4 18             	add    $0x18,%esp
}
  801573:	c9                   	leave  
  801574:	c3                   	ret    

00801575 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
  801578:	83 ec 04             	sub    $0x4,%esp
  80157b:	8b 45 08             	mov    0x8(%ebp),%eax
  80157e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801581:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	50                   	push   %eax
  80158e:	6a 1f                	push   $0x1f
  801590:	e8 40 fc ff ff       	call   8011d5 <syscall>
  801595:	83 c4 18             	add    $0x18,%esp
	return ;
  801598:	90                   	nop
}
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <rsttst>:
void rsttst()
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 21                	push   $0x21
  8015aa:	e8 26 fc ff ff       	call   8011d5 <syscall>
  8015af:	83 c4 18             	add    $0x18,%esp
	return ;
  8015b2:	90                   	nop
}
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	83 ec 04             	sub    $0x4,%esp
  8015bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8015be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015c1:	8b 55 18             	mov    0x18(%ebp),%edx
  8015c4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015c8:	52                   	push   %edx
  8015c9:	50                   	push   %eax
  8015ca:	ff 75 10             	pushl  0x10(%ebp)
  8015cd:	ff 75 0c             	pushl  0xc(%ebp)
  8015d0:	ff 75 08             	pushl  0x8(%ebp)
  8015d3:	6a 20                	push   $0x20
  8015d5:	e8 fb fb ff ff       	call   8011d5 <syscall>
  8015da:	83 c4 18             	add    $0x18,%esp
	return ;
  8015dd:	90                   	nop
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <chktst>:
void chktst(uint32 n)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	ff 75 08             	pushl  0x8(%ebp)
  8015ee:	6a 22                	push   $0x22
  8015f0:	e8 e0 fb ff ff       	call   8011d5 <syscall>
  8015f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8015f8:	90                   	nop
}
  8015f9:	c9                   	leave  
  8015fa:	c3                   	ret    

008015fb <inctst>:

void inctst()
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 23                	push   $0x23
  80160a:	e8 c6 fb ff ff       	call   8011d5 <syscall>
  80160f:	83 c4 18             	add    $0x18,%esp
	return ;
  801612:	90                   	nop
}
  801613:	c9                   	leave  
  801614:	c3                   	ret    

00801615 <gettst>:
uint32 gettst()
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 24                	push   $0x24
  801624:	e8 ac fb ff ff       	call   8011d5 <syscall>
  801629:	83 c4 18             	add    $0x18,%esp
}
  80162c:	c9                   	leave  
  80162d:	c3                   	ret    

0080162e <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 25                	push   $0x25
  80163d:	e8 93 fb ff ff       	call   8011d5 <syscall>
  801642:	83 c4 18             	add    $0x18,%esp
  801645:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  80164a:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  80164f:	c9                   	leave  
  801650:	c3                   	ret    

00801651 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801651:	55                   	push   %ebp
  801652:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	ff 75 08             	pushl  0x8(%ebp)
  801667:	6a 26                	push   $0x26
  801669:	e8 67 fb ff ff       	call   8011d5 <syscall>
  80166e:	83 c4 18             	add    $0x18,%esp
	return ;
  801671:	90                   	nop
}
  801672:	c9                   	leave  
  801673:	c3                   	ret    

00801674 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
  801677:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801678:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80167b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80167e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
  801684:	6a 00                	push   $0x0
  801686:	53                   	push   %ebx
  801687:	51                   	push   %ecx
  801688:	52                   	push   %edx
  801689:	50                   	push   %eax
  80168a:	6a 27                	push   $0x27
  80168c:	e8 44 fb ff ff       	call   8011d5 <syscall>
  801691:	83 c4 18             	add    $0x18,%esp
}
  801694:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801697:	c9                   	leave  
  801698:	c3                   	ret    

00801699 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80169c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	52                   	push   %edx
  8016a9:	50                   	push   %eax
  8016aa:	6a 28                	push   $0x28
  8016ac:	e8 24 fb ff ff       	call   8011d5 <syscall>
  8016b1:	83 c4 18             	add    $0x18,%esp
}
  8016b4:	c9                   	leave  
  8016b5:	c3                   	ret    

008016b6 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8016b9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c2:	6a 00                	push   $0x0
  8016c4:	51                   	push   %ecx
  8016c5:	ff 75 10             	pushl  0x10(%ebp)
  8016c8:	52                   	push   %edx
  8016c9:	50                   	push   %eax
  8016ca:	6a 29                	push   $0x29
  8016cc:	e8 04 fb ff ff       	call   8011d5 <syscall>
  8016d1:	83 c4 18             	add    $0x18,%esp
}
  8016d4:	c9                   	leave  
  8016d5:	c3                   	ret    

008016d6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	ff 75 10             	pushl  0x10(%ebp)
  8016e0:	ff 75 0c             	pushl  0xc(%ebp)
  8016e3:	ff 75 08             	pushl  0x8(%ebp)
  8016e6:	6a 12                	push   $0x12
  8016e8:	e8 e8 fa ff ff       	call   8011d5 <syscall>
  8016ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f0:	90                   	nop
}
  8016f1:	c9                   	leave  
  8016f2:	c3                   	ret    

008016f3 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8016f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	52                   	push   %edx
  801703:	50                   	push   %eax
  801704:	6a 2a                	push   $0x2a
  801706:	e8 ca fa ff ff       	call   8011d5 <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
	return;
  80170e:	90                   	nop
}
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 2b                	push   $0x2b
  801720:	e8 b0 fa ff ff       	call   8011d5 <syscall>
  801725:	83 c4 18             	add    $0x18,%esp
}
  801728:	c9                   	leave  
  801729:	c3                   	ret    

0080172a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80172a:	55                   	push   %ebp
  80172b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	ff 75 0c             	pushl  0xc(%ebp)
  801736:	ff 75 08             	pushl  0x8(%ebp)
  801739:	6a 2d                	push   $0x2d
  80173b:	e8 95 fa ff ff       	call   8011d5 <syscall>
  801740:	83 c4 18             	add    $0x18,%esp
	return;
  801743:	90                   	nop
}
  801744:	c9                   	leave  
  801745:	c3                   	ret    

00801746 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	ff 75 0c             	pushl  0xc(%ebp)
  801752:	ff 75 08             	pushl  0x8(%ebp)
  801755:	6a 2c                	push   $0x2c
  801757:	e8 79 fa ff ff       	call   8011d5 <syscall>
  80175c:	83 c4 18             	add    $0x18,%esp
	return ;
  80175f:	90                   	nop
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801768:	83 ec 04             	sub    $0x4,%esp
  80176b:	68 08 21 80 00       	push   $0x802108
  801770:	68 25 01 00 00       	push   $0x125
  801775:	68 3b 21 80 00       	push   $0x80213b
  80177a:	e8 00 00 00 00       	call   80177f <_panic>

0080177f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801785:	8d 45 10             	lea    0x10(%ebp),%eax
  801788:	83 c0 04             	add    $0x4,%eax
  80178b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80178e:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801793:	85 c0                	test   %eax,%eax
  801795:	74 16                	je     8017ad <_panic+0x2e>
		cprintf("%s: ", argv0);
  801797:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  80179c:	83 ec 08             	sub    $0x8,%esp
  80179f:	50                   	push   %eax
  8017a0:	68 4c 21 80 00       	push   $0x80214c
  8017a5:	e8 46 eb ff ff       	call   8002f0 <cprintf>
  8017aa:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8017ad:	a1 04 30 80 00       	mov    0x803004,%eax
  8017b2:	83 ec 0c             	sub    $0xc,%esp
  8017b5:	ff 75 0c             	pushl  0xc(%ebp)
  8017b8:	ff 75 08             	pushl  0x8(%ebp)
  8017bb:	50                   	push   %eax
  8017bc:	68 54 21 80 00       	push   $0x802154
  8017c1:	6a 74                	push   $0x74
  8017c3:	e8 55 eb ff ff       	call   80031d <cprintf_colored>
  8017c8:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8017cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ce:	83 ec 08             	sub    $0x8,%esp
  8017d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d4:	50                   	push   %eax
  8017d5:	e8 a7 ea ff ff       	call   800281 <vcprintf>
  8017da:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8017dd:	83 ec 08             	sub    $0x8,%esp
  8017e0:	6a 00                	push   $0x0
  8017e2:	68 7c 21 80 00       	push   $0x80217c
  8017e7:	e8 95 ea ff ff       	call   800281 <vcprintf>
  8017ec:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8017ef:	e8 0e ea ff ff       	call   800202 <exit>

	// should not return here
	while (1) ;
  8017f4:	eb fe                	jmp    8017f4 <_panic+0x75>

008017f6 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8017fc:	a1 20 30 80 00       	mov    0x803020,%eax
  801801:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801807:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180a:	39 c2                	cmp    %eax,%edx
  80180c:	74 14                	je     801822 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80180e:	83 ec 04             	sub    $0x4,%esp
  801811:	68 80 21 80 00       	push   $0x802180
  801816:	6a 26                	push   $0x26
  801818:	68 cc 21 80 00       	push   $0x8021cc
  80181d:	e8 5d ff ff ff       	call   80177f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801822:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801829:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801830:	e9 c5 00 00 00       	jmp    8018fa <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801835:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801838:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	01 d0                	add    %edx,%eax
  801844:	8b 00                	mov    (%eax),%eax
  801846:	85 c0                	test   %eax,%eax
  801848:	75 08                	jne    801852 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80184a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80184d:	e9 a5 00 00 00       	jmp    8018f7 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801852:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801859:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801860:	eb 69                	jmp    8018cb <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801862:	a1 20 30 80 00       	mov    0x803020,%eax
  801867:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80186d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801870:	89 d0                	mov    %edx,%eax
  801872:	01 c0                	add    %eax,%eax
  801874:	01 d0                	add    %edx,%eax
  801876:	c1 e0 03             	shl    $0x3,%eax
  801879:	01 c8                	add    %ecx,%eax
  80187b:	8a 40 04             	mov    0x4(%eax),%al
  80187e:	84 c0                	test   %al,%al
  801880:	75 46                	jne    8018c8 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801882:	a1 20 30 80 00       	mov    0x803020,%eax
  801887:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80188d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801890:	89 d0                	mov    %edx,%eax
  801892:	01 c0                	add    %eax,%eax
  801894:	01 d0                	add    %edx,%eax
  801896:	c1 e0 03             	shl    $0x3,%eax
  801899:	01 c8                	add    %ecx,%eax
  80189b:	8b 00                	mov    (%eax),%eax
  80189d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8018a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018a8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8018aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ad:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b7:	01 c8                	add    %ecx,%eax
  8018b9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018bb:	39 c2                	cmp    %eax,%edx
  8018bd:	75 09                	jne    8018c8 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8018bf:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8018c6:	eb 15                	jmp    8018dd <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018c8:	ff 45 e8             	incl   -0x18(%ebp)
  8018cb:	a1 20 30 80 00       	mov    0x803020,%eax
  8018d0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8018d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018d9:	39 c2                	cmp    %eax,%edx
  8018db:	77 85                	ja     801862 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8018dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018e1:	75 14                	jne    8018f7 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8018e3:	83 ec 04             	sub    $0x4,%esp
  8018e6:	68 d8 21 80 00       	push   $0x8021d8
  8018eb:	6a 3a                	push   $0x3a
  8018ed:	68 cc 21 80 00       	push   $0x8021cc
  8018f2:	e8 88 fe ff ff       	call   80177f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8018f7:	ff 45 f0             	incl   -0x10(%ebp)
  8018fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018fd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801900:	0f 8c 2f ff ff ff    	jl     801835 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801906:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80190d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801914:	eb 26                	jmp    80193c <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801916:	a1 20 30 80 00       	mov    0x803020,%eax
  80191b:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801921:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801924:	89 d0                	mov    %edx,%eax
  801926:	01 c0                	add    %eax,%eax
  801928:	01 d0                	add    %edx,%eax
  80192a:	c1 e0 03             	shl    $0x3,%eax
  80192d:	01 c8                	add    %ecx,%eax
  80192f:	8a 40 04             	mov    0x4(%eax),%al
  801932:	3c 01                	cmp    $0x1,%al
  801934:	75 03                	jne    801939 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801936:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801939:	ff 45 e0             	incl   -0x20(%ebp)
  80193c:	a1 20 30 80 00       	mov    0x803020,%eax
  801941:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801947:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80194a:	39 c2                	cmp    %eax,%edx
  80194c:	77 c8                	ja     801916 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80194e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801951:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801954:	74 14                	je     80196a <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801956:	83 ec 04             	sub    $0x4,%esp
  801959:	68 2c 22 80 00       	push   $0x80222c
  80195e:	6a 44                	push   $0x44
  801960:	68 cc 21 80 00       	push   $0x8021cc
  801965:	e8 15 fe ff ff       	call   80177f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80196a:	90                   	nop
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    
  80196d:	66 90                	xchg   %ax,%ax
  80196f:	90                   	nop

00801970 <__udivdi3>:
  801970:	55                   	push   %ebp
  801971:	57                   	push   %edi
  801972:	56                   	push   %esi
  801973:	53                   	push   %ebx
  801974:	83 ec 1c             	sub    $0x1c,%esp
  801977:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80197b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80197f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801983:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801987:	89 ca                	mov    %ecx,%edx
  801989:	89 f8                	mov    %edi,%eax
  80198b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80198f:	85 f6                	test   %esi,%esi
  801991:	75 2d                	jne    8019c0 <__udivdi3+0x50>
  801993:	39 cf                	cmp    %ecx,%edi
  801995:	77 65                	ja     8019fc <__udivdi3+0x8c>
  801997:	89 fd                	mov    %edi,%ebp
  801999:	85 ff                	test   %edi,%edi
  80199b:	75 0b                	jne    8019a8 <__udivdi3+0x38>
  80199d:	b8 01 00 00 00       	mov    $0x1,%eax
  8019a2:	31 d2                	xor    %edx,%edx
  8019a4:	f7 f7                	div    %edi
  8019a6:	89 c5                	mov    %eax,%ebp
  8019a8:	31 d2                	xor    %edx,%edx
  8019aa:	89 c8                	mov    %ecx,%eax
  8019ac:	f7 f5                	div    %ebp
  8019ae:	89 c1                	mov    %eax,%ecx
  8019b0:	89 d8                	mov    %ebx,%eax
  8019b2:	f7 f5                	div    %ebp
  8019b4:	89 cf                	mov    %ecx,%edi
  8019b6:	89 fa                	mov    %edi,%edx
  8019b8:	83 c4 1c             	add    $0x1c,%esp
  8019bb:	5b                   	pop    %ebx
  8019bc:	5e                   	pop    %esi
  8019bd:	5f                   	pop    %edi
  8019be:	5d                   	pop    %ebp
  8019bf:	c3                   	ret    
  8019c0:	39 ce                	cmp    %ecx,%esi
  8019c2:	77 28                	ja     8019ec <__udivdi3+0x7c>
  8019c4:	0f bd fe             	bsr    %esi,%edi
  8019c7:	83 f7 1f             	xor    $0x1f,%edi
  8019ca:	75 40                	jne    801a0c <__udivdi3+0x9c>
  8019cc:	39 ce                	cmp    %ecx,%esi
  8019ce:	72 0a                	jb     8019da <__udivdi3+0x6a>
  8019d0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019d4:	0f 87 9e 00 00 00    	ja     801a78 <__udivdi3+0x108>
  8019da:	b8 01 00 00 00       	mov    $0x1,%eax
  8019df:	89 fa                	mov    %edi,%edx
  8019e1:	83 c4 1c             	add    $0x1c,%esp
  8019e4:	5b                   	pop    %ebx
  8019e5:	5e                   	pop    %esi
  8019e6:	5f                   	pop    %edi
  8019e7:	5d                   	pop    %ebp
  8019e8:	c3                   	ret    
  8019e9:	8d 76 00             	lea    0x0(%esi),%esi
  8019ec:	31 ff                	xor    %edi,%edi
  8019ee:	31 c0                	xor    %eax,%eax
  8019f0:	89 fa                	mov    %edi,%edx
  8019f2:	83 c4 1c             	add    $0x1c,%esp
  8019f5:	5b                   	pop    %ebx
  8019f6:	5e                   	pop    %esi
  8019f7:	5f                   	pop    %edi
  8019f8:	5d                   	pop    %ebp
  8019f9:	c3                   	ret    
  8019fa:	66 90                	xchg   %ax,%ax
  8019fc:	89 d8                	mov    %ebx,%eax
  8019fe:	f7 f7                	div    %edi
  801a00:	31 ff                	xor    %edi,%edi
  801a02:	89 fa                	mov    %edi,%edx
  801a04:	83 c4 1c             	add    $0x1c,%esp
  801a07:	5b                   	pop    %ebx
  801a08:	5e                   	pop    %esi
  801a09:	5f                   	pop    %edi
  801a0a:	5d                   	pop    %ebp
  801a0b:	c3                   	ret    
  801a0c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a11:	89 eb                	mov    %ebp,%ebx
  801a13:	29 fb                	sub    %edi,%ebx
  801a15:	89 f9                	mov    %edi,%ecx
  801a17:	d3 e6                	shl    %cl,%esi
  801a19:	89 c5                	mov    %eax,%ebp
  801a1b:	88 d9                	mov    %bl,%cl
  801a1d:	d3 ed                	shr    %cl,%ebp
  801a1f:	89 e9                	mov    %ebp,%ecx
  801a21:	09 f1                	or     %esi,%ecx
  801a23:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a27:	89 f9                	mov    %edi,%ecx
  801a29:	d3 e0                	shl    %cl,%eax
  801a2b:	89 c5                	mov    %eax,%ebp
  801a2d:	89 d6                	mov    %edx,%esi
  801a2f:	88 d9                	mov    %bl,%cl
  801a31:	d3 ee                	shr    %cl,%esi
  801a33:	89 f9                	mov    %edi,%ecx
  801a35:	d3 e2                	shl    %cl,%edx
  801a37:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a3b:	88 d9                	mov    %bl,%cl
  801a3d:	d3 e8                	shr    %cl,%eax
  801a3f:	09 c2                	or     %eax,%edx
  801a41:	89 d0                	mov    %edx,%eax
  801a43:	89 f2                	mov    %esi,%edx
  801a45:	f7 74 24 0c          	divl   0xc(%esp)
  801a49:	89 d6                	mov    %edx,%esi
  801a4b:	89 c3                	mov    %eax,%ebx
  801a4d:	f7 e5                	mul    %ebp
  801a4f:	39 d6                	cmp    %edx,%esi
  801a51:	72 19                	jb     801a6c <__udivdi3+0xfc>
  801a53:	74 0b                	je     801a60 <__udivdi3+0xf0>
  801a55:	89 d8                	mov    %ebx,%eax
  801a57:	31 ff                	xor    %edi,%edi
  801a59:	e9 58 ff ff ff       	jmp    8019b6 <__udivdi3+0x46>
  801a5e:	66 90                	xchg   %ax,%ax
  801a60:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a64:	89 f9                	mov    %edi,%ecx
  801a66:	d3 e2                	shl    %cl,%edx
  801a68:	39 c2                	cmp    %eax,%edx
  801a6a:	73 e9                	jae    801a55 <__udivdi3+0xe5>
  801a6c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a6f:	31 ff                	xor    %edi,%edi
  801a71:	e9 40 ff ff ff       	jmp    8019b6 <__udivdi3+0x46>
  801a76:	66 90                	xchg   %ax,%ax
  801a78:	31 c0                	xor    %eax,%eax
  801a7a:	e9 37 ff ff ff       	jmp    8019b6 <__udivdi3+0x46>
  801a7f:	90                   	nop

00801a80 <__umoddi3>:
  801a80:	55                   	push   %ebp
  801a81:	57                   	push   %edi
  801a82:	56                   	push   %esi
  801a83:	53                   	push   %ebx
  801a84:	83 ec 1c             	sub    $0x1c,%esp
  801a87:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a8b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a8f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a93:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a97:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a9b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a9f:	89 f3                	mov    %esi,%ebx
  801aa1:	89 fa                	mov    %edi,%edx
  801aa3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801aa7:	89 34 24             	mov    %esi,(%esp)
  801aaa:	85 c0                	test   %eax,%eax
  801aac:	75 1a                	jne    801ac8 <__umoddi3+0x48>
  801aae:	39 f7                	cmp    %esi,%edi
  801ab0:	0f 86 a2 00 00 00    	jbe    801b58 <__umoddi3+0xd8>
  801ab6:	89 c8                	mov    %ecx,%eax
  801ab8:	89 f2                	mov    %esi,%edx
  801aba:	f7 f7                	div    %edi
  801abc:	89 d0                	mov    %edx,%eax
  801abe:	31 d2                	xor    %edx,%edx
  801ac0:	83 c4 1c             	add    $0x1c,%esp
  801ac3:	5b                   	pop    %ebx
  801ac4:	5e                   	pop    %esi
  801ac5:	5f                   	pop    %edi
  801ac6:	5d                   	pop    %ebp
  801ac7:	c3                   	ret    
  801ac8:	39 f0                	cmp    %esi,%eax
  801aca:	0f 87 ac 00 00 00    	ja     801b7c <__umoddi3+0xfc>
  801ad0:	0f bd e8             	bsr    %eax,%ebp
  801ad3:	83 f5 1f             	xor    $0x1f,%ebp
  801ad6:	0f 84 ac 00 00 00    	je     801b88 <__umoddi3+0x108>
  801adc:	bf 20 00 00 00       	mov    $0x20,%edi
  801ae1:	29 ef                	sub    %ebp,%edi
  801ae3:	89 fe                	mov    %edi,%esi
  801ae5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ae9:	89 e9                	mov    %ebp,%ecx
  801aeb:	d3 e0                	shl    %cl,%eax
  801aed:	89 d7                	mov    %edx,%edi
  801aef:	89 f1                	mov    %esi,%ecx
  801af1:	d3 ef                	shr    %cl,%edi
  801af3:	09 c7                	or     %eax,%edi
  801af5:	89 e9                	mov    %ebp,%ecx
  801af7:	d3 e2                	shl    %cl,%edx
  801af9:	89 14 24             	mov    %edx,(%esp)
  801afc:	89 d8                	mov    %ebx,%eax
  801afe:	d3 e0                	shl    %cl,%eax
  801b00:	89 c2                	mov    %eax,%edx
  801b02:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b06:	d3 e0                	shl    %cl,%eax
  801b08:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b0c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b10:	89 f1                	mov    %esi,%ecx
  801b12:	d3 e8                	shr    %cl,%eax
  801b14:	09 d0                	or     %edx,%eax
  801b16:	d3 eb                	shr    %cl,%ebx
  801b18:	89 da                	mov    %ebx,%edx
  801b1a:	f7 f7                	div    %edi
  801b1c:	89 d3                	mov    %edx,%ebx
  801b1e:	f7 24 24             	mull   (%esp)
  801b21:	89 c6                	mov    %eax,%esi
  801b23:	89 d1                	mov    %edx,%ecx
  801b25:	39 d3                	cmp    %edx,%ebx
  801b27:	0f 82 87 00 00 00    	jb     801bb4 <__umoddi3+0x134>
  801b2d:	0f 84 91 00 00 00    	je     801bc4 <__umoddi3+0x144>
  801b33:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b37:	29 f2                	sub    %esi,%edx
  801b39:	19 cb                	sbb    %ecx,%ebx
  801b3b:	89 d8                	mov    %ebx,%eax
  801b3d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b41:	d3 e0                	shl    %cl,%eax
  801b43:	89 e9                	mov    %ebp,%ecx
  801b45:	d3 ea                	shr    %cl,%edx
  801b47:	09 d0                	or     %edx,%eax
  801b49:	89 e9                	mov    %ebp,%ecx
  801b4b:	d3 eb                	shr    %cl,%ebx
  801b4d:	89 da                	mov    %ebx,%edx
  801b4f:	83 c4 1c             	add    $0x1c,%esp
  801b52:	5b                   	pop    %ebx
  801b53:	5e                   	pop    %esi
  801b54:	5f                   	pop    %edi
  801b55:	5d                   	pop    %ebp
  801b56:	c3                   	ret    
  801b57:	90                   	nop
  801b58:	89 fd                	mov    %edi,%ebp
  801b5a:	85 ff                	test   %edi,%edi
  801b5c:	75 0b                	jne    801b69 <__umoddi3+0xe9>
  801b5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b63:	31 d2                	xor    %edx,%edx
  801b65:	f7 f7                	div    %edi
  801b67:	89 c5                	mov    %eax,%ebp
  801b69:	89 f0                	mov    %esi,%eax
  801b6b:	31 d2                	xor    %edx,%edx
  801b6d:	f7 f5                	div    %ebp
  801b6f:	89 c8                	mov    %ecx,%eax
  801b71:	f7 f5                	div    %ebp
  801b73:	89 d0                	mov    %edx,%eax
  801b75:	e9 44 ff ff ff       	jmp    801abe <__umoddi3+0x3e>
  801b7a:	66 90                	xchg   %ax,%ax
  801b7c:	89 c8                	mov    %ecx,%eax
  801b7e:	89 f2                	mov    %esi,%edx
  801b80:	83 c4 1c             	add    $0x1c,%esp
  801b83:	5b                   	pop    %ebx
  801b84:	5e                   	pop    %esi
  801b85:	5f                   	pop    %edi
  801b86:	5d                   	pop    %ebp
  801b87:	c3                   	ret    
  801b88:	3b 04 24             	cmp    (%esp),%eax
  801b8b:	72 06                	jb     801b93 <__umoddi3+0x113>
  801b8d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b91:	77 0f                	ja     801ba2 <__umoddi3+0x122>
  801b93:	89 f2                	mov    %esi,%edx
  801b95:	29 f9                	sub    %edi,%ecx
  801b97:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b9b:	89 14 24             	mov    %edx,(%esp)
  801b9e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ba2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ba6:	8b 14 24             	mov    (%esp),%edx
  801ba9:	83 c4 1c             	add    $0x1c,%esp
  801bac:	5b                   	pop    %ebx
  801bad:	5e                   	pop    %esi
  801bae:	5f                   	pop    %edi
  801baf:	5d                   	pop    %ebp
  801bb0:	c3                   	ret    
  801bb1:	8d 76 00             	lea    0x0(%esi),%esi
  801bb4:	2b 04 24             	sub    (%esp),%eax
  801bb7:	19 fa                	sbb    %edi,%edx
  801bb9:	89 d1                	mov    %edx,%ecx
  801bbb:	89 c6                	mov    %eax,%esi
  801bbd:	e9 71 ff ff ff       	jmp    801b33 <__umoddi3+0xb3>
  801bc2:	66 90                	xchg   %ax,%ax
  801bc4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bc8:	72 ea                	jb     801bb4 <__umoddi3+0x134>
  801bca:	89 d9                	mov    %ebx,%ecx
  801bcc:	e9 62 ff ff ff       	jmp    801b33 <__umoddi3+0xb3>

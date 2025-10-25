
obj/user/fos_fibonacci:     file format elf32-i386


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
  800031:	e8 b7 00 00 00       	call   8000ed <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int64 fibonacci(int n);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];

	atomic_readline("Please enter Fibonacci index:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 c0 1e 80 00       	push   $0x801ec0
  800057:	e8 f9 0a 00 00       	call   800b55 <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp

	i1 = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 fb 0f 00 00       	call   80106d <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int64 res = fibonacci(i1) ;
  800078:	83 ec 0c             	sub    $0xc,%esp
  80007b:	ff 75 f4             	pushl  -0xc(%ebp)
  80007e:	e8 22 00 00 00       	call   8000a5 <fibonacci>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800089:	89 55 ec             	mov    %edx,-0x14(%ebp)

	atomic_cprintf("%@Fibonacci #%d = %lld\n",i1, res);
  80008c:	ff 75 ec             	pushl  -0x14(%ebp)
  80008f:	ff 75 e8             	pushl  -0x18(%ebp)
  800092:	ff 75 f4             	pushl  -0xc(%ebp)
  800095:	68 de 1e 80 00       	push   $0x801ede
  80009a:	e8 50 03 00 00       	call   8003ef <atomic_cprintf>
  80009f:	83 c4 10             	add    $0x10,%esp

	return;
  8000a2:	90                   	nop
}
  8000a3:	c9                   	leave  
  8000a4:	c3                   	ret    

008000a5 <fibonacci>:


int64 fibonacci(int n)
{
  8000a5:	55                   	push   %ebp
  8000a6:	89 e5                	mov    %esp,%ebp
  8000a8:	56                   	push   %esi
  8000a9:	53                   	push   %ebx
	if (n <= 1)
  8000aa:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ae:	7f 0c                	jg     8000bc <fibonacci+0x17>
		return 1 ;
  8000b0:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ba:	eb 2a                	jmp    8000e6 <fibonacci+0x41>
	return fibonacci(n-1) + fibonacci(n-2) ;
  8000bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8000bf:	48                   	dec    %eax
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	50                   	push   %eax
  8000c4:	e8 dc ff ff ff       	call   8000a5 <fibonacci>
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	89 c3                	mov    %eax,%ebx
  8000ce:	89 d6                	mov    %edx,%esi
  8000d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8000d3:	83 e8 02             	sub    $0x2,%eax
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	50                   	push   %eax
  8000da:	e8 c6 ff ff ff       	call   8000a5 <fibonacci>
  8000df:	83 c4 10             	add    $0x10,%esp
  8000e2:	01 d8                	add    %ebx,%eax
  8000e4:	11 f2                	adc    %esi,%edx
}
  8000e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000e9:	5b                   	pop    %ebx
  8000ea:	5e                   	pop    %esi
  8000eb:	5d                   	pop    %ebp
  8000ec:	c3                   	ret    

008000ed <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000ed:	55                   	push   %ebp
  8000ee:	89 e5                	mov    %esp,%ebp
  8000f0:	57                   	push   %edi
  8000f1:	56                   	push   %esi
  8000f2:	53                   	push   %ebx
  8000f3:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000f6:	e8 57 16 00 00       	call   801752 <sys_getenvindex>
  8000fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800101:	89 d0                	mov    %edx,%eax
  800103:	c1 e0 02             	shl    $0x2,%eax
  800106:	01 d0                	add    %edx,%eax
  800108:	c1 e0 03             	shl    $0x3,%eax
  80010b:	01 d0                	add    %edx,%eax
  80010d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800114:	01 d0                	add    %edx,%eax
  800116:	c1 e0 02             	shl    $0x2,%eax
  800119:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80011e:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800123:	a1 20 30 80 00       	mov    0x803020,%eax
  800128:	8a 40 20             	mov    0x20(%eax),%al
  80012b:	84 c0                	test   %al,%al
  80012d:	74 0d                	je     80013c <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80012f:	a1 20 30 80 00       	mov    0x803020,%eax
  800134:	83 c0 20             	add    $0x20,%eax
  800137:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80013c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800140:	7e 0a                	jle    80014c <libmain+0x5f>
		binaryname = argv[0];
  800142:	8b 45 0c             	mov    0xc(%ebp),%eax
  800145:	8b 00                	mov    (%eax),%eax
  800147:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80014c:	83 ec 08             	sub    $0x8,%esp
  80014f:	ff 75 0c             	pushl  0xc(%ebp)
  800152:	ff 75 08             	pushl  0x8(%ebp)
  800155:	e8 de fe ff ff       	call   800038 <_main>
  80015a:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80015d:	a1 00 30 80 00       	mov    0x803000,%eax
  800162:	85 c0                	test   %eax,%eax
  800164:	0f 84 01 01 00 00    	je     80026b <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80016a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800170:	bb f0 1f 80 00       	mov    $0x801ff0,%ebx
  800175:	ba 0e 00 00 00       	mov    $0xe,%edx
  80017a:	89 c7                	mov    %eax,%edi
  80017c:	89 de                	mov    %ebx,%esi
  80017e:	89 d1                	mov    %edx,%ecx
  800180:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800182:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800185:	b9 56 00 00 00       	mov    $0x56,%ecx
  80018a:	b0 00                	mov    $0x0,%al
  80018c:	89 d7                	mov    %edx,%edi
  80018e:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800190:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800197:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80019a:	83 ec 08             	sub    $0x8,%esp
  80019d:	50                   	push   %eax
  80019e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001a4:	50                   	push   %eax
  8001a5:	e8 de 17 00 00       	call   801988 <sys_utilities>
  8001aa:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001ad:	e8 27 13 00 00       	call   8014d9 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001b2:	83 ec 0c             	sub    $0xc,%esp
  8001b5:	68 10 1f 80 00       	push   $0x801f10
  8001ba:	e8 be 01 00 00       	call   80037d <cprintf>
  8001bf:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	74 18                	je     8001e1 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001c9:	e8 d8 17 00 00       	call   8019a6 <sys_get_optimal_num_faults>
  8001ce:	83 ec 08             	sub    $0x8,%esp
  8001d1:	50                   	push   %eax
  8001d2:	68 38 1f 80 00       	push   $0x801f38
  8001d7:	e8 a1 01 00 00       	call   80037d <cprintf>
  8001dc:	83 c4 10             	add    $0x10,%esp
  8001df:	eb 59                	jmp    80023a <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001e1:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e6:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8001ec:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f1:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8001f7:	83 ec 04             	sub    $0x4,%esp
  8001fa:	52                   	push   %edx
  8001fb:	50                   	push   %eax
  8001fc:	68 5c 1f 80 00       	push   $0x801f5c
  800201:	e8 77 01 00 00       	call   80037d <cprintf>
  800206:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800209:	a1 20 30 80 00       	mov    0x803020,%eax
  80020e:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800214:	a1 20 30 80 00       	mov    0x803020,%eax
  800219:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80021f:	a1 20 30 80 00       	mov    0x803020,%eax
  800224:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80022a:	51                   	push   %ecx
  80022b:	52                   	push   %edx
  80022c:	50                   	push   %eax
  80022d:	68 84 1f 80 00       	push   $0x801f84
  800232:	e8 46 01 00 00       	call   80037d <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80023a:	a1 20 30 80 00       	mov    0x803020,%eax
  80023f:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800245:	83 ec 08             	sub    $0x8,%esp
  800248:	50                   	push   %eax
  800249:	68 dc 1f 80 00       	push   $0x801fdc
  80024e:	e8 2a 01 00 00       	call   80037d <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	68 10 1f 80 00       	push   $0x801f10
  80025e:	e8 1a 01 00 00       	call   80037d <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800266:	e8 88 12 00 00       	call   8014f3 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80026b:	e8 1f 00 00 00       	call   80028f <exit>
}
  800270:	90                   	nop
  800271:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800274:	5b                   	pop    %ebx
  800275:	5e                   	pop    %esi
  800276:	5f                   	pop    %edi
  800277:	5d                   	pop    %ebp
  800278:	c3                   	ret    

00800279 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80027f:	83 ec 0c             	sub    $0xc,%esp
  800282:	6a 00                	push   $0x0
  800284:	e8 95 14 00 00       	call   80171e <sys_destroy_env>
  800289:	83 c4 10             	add    $0x10,%esp
}
  80028c:	90                   	nop
  80028d:	c9                   	leave  
  80028e:	c3                   	ret    

0080028f <exit>:

void
exit(void)
{
  80028f:	55                   	push   %ebp
  800290:	89 e5                	mov    %esp,%ebp
  800292:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800295:	e8 ea 14 00 00       	call   801784 <sys_exit_env>
}
  80029a:	90                   	nop
  80029b:	c9                   	leave  
  80029c:	c3                   	ret    

0080029d <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80029d:	55                   	push   %ebp
  80029e:	89 e5                	mov    %esp,%ebp
  8002a0:	53                   	push   %ebx
  8002a1:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8002a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a7:	8b 00                	mov    (%eax),%eax
  8002a9:	8d 48 01             	lea    0x1(%eax),%ecx
  8002ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002af:	89 0a                	mov    %ecx,(%edx)
  8002b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b4:	88 d1                	mov    %dl,%cl
  8002b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c0:	8b 00                	mov    (%eax),%eax
  8002c2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002c7:	75 30                	jne    8002f9 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8002c9:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8002cf:	a0 44 30 80 00       	mov    0x803044,%al
  8002d4:	0f b6 c0             	movzbl %al,%eax
  8002d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002da:	8b 09                	mov    (%ecx),%ecx
  8002dc:	89 cb                	mov    %ecx,%ebx
  8002de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002e1:	83 c1 08             	add    $0x8,%ecx
  8002e4:	52                   	push   %edx
  8002e5:	50                   	push   %eax
  8002e6:	53                   	push   %ebx
  8002e7:	51                   	push   %ecx
  8002e8:	e8 a8 11 00 00       	call   801495 <sys_cputs>
  8002ed:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fc:	8b 40 04             	mov    0x4(%eax),%eax
  8002ff:	8d 50 01             	lea    0x1(%eax),%edx
  800302:	8b 45 0c             	mov    0xc(%ebp),%eax
  800305:	89 50 04             	mov    %edx,0x4(%eax)
}
  800308:	90                   	nop
  800309:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80030c:	c9                   	leave  
  80030d:	c3                   	ret    

0080030e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800317:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80031e:	00 00 00 
	b.cnt = 0;
  800321:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800328:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80032b:	ff 75 0c             	pushl  0xc(%ebp)
  80032e:	ff 75 08             	pushl  0x8(%ebp)
  800331:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800337:	50                   	push   %eax
  800338:	68 9d 02 80 00       	push   $0x80029d
  80033d:	e8 5a 02 00 00       	call   80059c <vprintfmt>
  800342:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800345:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  80034b:	a0 44 30 80 00       	mov    0x803044,%al
  800350:	0f b6 c0             	movzbl %al,%eax
  800353:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800359:	52                   	push   %edx
  80035a:	50                   	push   %eax
  80035b:	51                   	push   %ecx
  80035c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800362:	83 c0 08             	add    $0x8,%eax
  800365:	50                   	push   %eax
  800366:	e8 2a 11 00 00       	call   801495 <sys_cputs>
  80036b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80036e:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800375:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80037b:	c9                   	leave  
  80037c:	c3                   	ret    

0080037d <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80037d:	55                   	push   %ebp
  80037e:	89 e5                	mov    %esp,%ebp
  800380:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800383:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80038a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80038d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800390:	8b 45 08             	mov    0x8(%ebp),%eax
  800393:	83 ec 08             	sub    $0x8,%esp
  800396:	ff 75 f4             	pushl  -0xc(%ebp)
  800399:	50                   	push   %eax
  80039a:	e8 6f ff ff ff       	call   80030e <vcprintf>
  80039f:	83 c4 10             	add    $0x10,%esp
  8003a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a8:	c9                   	leave  
  8003a9:	c3                   	ret    

008003aa <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8003aa:	55                   	push   %ebp
  8003ab:	89 e5                	mov    %esp,%ebp
  8003ad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003b0:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8003b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ba:	c1 e0 08             	shl    $0x8,%eax
  8003bd:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  8003c2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003c5:	83 c0 04             	add    $0x4,%eax
  8003c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ce:	83 ec 08             	sub    $0x8,%esp
  8003d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8003d4:	50                   	push   %eax
  8003d5:	e8 34 ff ff ff       	call   80030e <vcprintf>
  8003da:	83 c4 10             	add    $0x10,%esp
  8003dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8003e0:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  8003e7:	07 00 00 

	return cnt;
  8003ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003ed:	c9                   	leave  
  8003ee:	c3                   	ret    

008003ef <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
  8003f2:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003f5:	e8 df 10 00 00       	call   8014d9 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8003fa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800400:	8b 45 08             	mov    0x8(%ebp),%eax
  800403:	83 ec 08             	sub    $0x8,%esp
  800406:	ff 75 f4             	pushl  -0xc(%ebp)
  800409:	50                   	push   %eax
  80040a:	e8 ff fe ff ff       	call   80030e <vcprintf>
  80040f:	83 c4 10             	add    $0x10,%esp
  800412:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800415:	e8 d9 10 00 00       	call   8014f3 <sys_unlock_cons>
	return cnt;
  80041a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80041d:	c9                   	leave  
  80041e:	c3                   	ret    

0080041f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80041f:	55                   	push   %ebp
  800420:	89 e5                	mov    %esp,%ebp
  800422:	53                   	push   %ebx
  800423:	83 ec 14             	sub    $0x14,%esp
  800426:	8b 45 10             	mov    0x10(%ebp),%eax
  800429:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80042c:	8b 45 14             	mov    0x14(%ebp),%eax
  80042f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800432:	8b 45 18             	mov    0x18(%ebp),%eax
  800435:	ba 00 00 00 00       	mov    $0x0,%edx
  80043a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80043d:	77 55                	ja     800494 <printnum+0x75>
  80043f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800442:	72 05                	jb     800449 <printnum+0x2a>
  800444:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800447:	77 4b                	ja     800494 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800449:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80044c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80044f:	8b 45 18             	mov    0x18(%ebp),%eax
  800452:	ba 00 00 00 00       	mov    $0x0,%edx
  800457:	52                   	push   %edx
  800458:	50                   	push   %eax
  800459:	ff 75 f4             	pushl  -0xc(%ebp)
  80045c:	ff 75 f0             	pushl  -0x10(%ebp)
  80045f:	e8 dc 17 00 00       	call   801c40 <__udivdi3>
  800464:	83 c4 10             	add    $0x10,%esp
  800467:	83 ec 04             	sub    $0x4,%esp
  80046a:	ff 75 20             	pushl  0x20(%ebp)
  80046d:	53                   	push   %ebx
  80046e:	ff 75 18             	pushl  0x18(%ebp)
  800471:	52                   	push   %edx
  800472:	50                   	push   %eax
  800473:	ff 75 0c             	pushl  0xc(%ebp)
  800476:	ff 75 08             	pushl  0x8(%ebp)
  800479:	e8 a1 ff ff ff       	call   80041f <printnum>
  80047e:	83 c4 20             	add    $0x20,%esp
  800481:	eb 1a                	jmp    80049d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800483:	83 ec 08             	sub    $0x8,%esp
  800486:	ff 75 0c             	pushl  0xc(%ebp)
  800489:	ff 75 20             	pushl  0x20(%ebp)
  80048c:	8b 45 08             	mov    0x8(%ebp),%eax
  80048f:	ff d0                	call   *%eax
  800491:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800494:	ff 4d 1c             	decl   0x1c(%ebp)
  800497:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80049b:	7f e6                	jg     800483 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80049d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004ab:	53                   	push   %ebx
  8004ac:	51                   	push   %ecx
  8004ad:	52                   	push   %edx
  8004ae:	50                   	push   %eax
  8004af:	e8 9c 18 00 00       	call   801d50 <__umoddi3>
  8004b4:	83 c4 10             	add    $0x10,%esp
  8004b7:	05 74 22 80 00       	add    $0x802274,%eax
  8004bc:	8a 00                	mov    (%eax),%al
  8004be:	0f be c0             	movsbl %al,%eax
  8004c1:	83 ec 08             	sub    $0x8,%esp
  8004c4:	ff 75 0c             	pushl  0xc(%ebp)
  8004c7:	50                   	push   %eax
  8004c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cb:	ff d0                	call   *%eax
  8004cd:	83 c4 10             	add    $0x10,%esp
}
  8004d0:	90                   	nop
  8004d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004d4:	c9                   	leave  
  8004d5:	c3                   	ret    

008004d6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004d9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004dd:	7e 1c                	jle    8004fb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004df:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e2:	8b 00                	mov    (%eax),%eax
  8004e4:	8d 50 08             	lea    0x8(%eax),%edx
  8004e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ea:	89 10                	mov    %edx,(%eax)
  8004ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ef:	8b 00                	mov    (%eax),%eax
  8004f1:	83 e8 08             	sub    $0x8,%eax
  8004f4:	8b 50 04             	mov    0x4(%eax),%edx
  8004f7:	8b 00                	mov    (%eax),%eax
  8004f9:	eb 40                	jmp    80053b <getuint+0x65>
	else if (lflag)
  8004fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004ff:	74 1e                	je     80051f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800501:	8b 45 08             	mov    0x8(%ebp),%eax
  800504:	8b 00                	mov    (%eax),%eax
  800506:	8d 50 04             	lea    0x4(%eax),%edx
  800509:	8b 45 08             	mov    0x8(%ebp),%eax
  80050c:	89 10                	mov    %edx,(%eax)
  80050e:	8b 45 08             	mov    0x8(%ebp),%eax
  800511:	8b 00                	mov    (%eax),%eax
  800513:	83 e8 04             	sub    $0x4,%eax
  800516:	8b 00                	mov    (%eax),%eax
  800518:	ba 00 00 00 00       	mov    $0x0,%edx
  80051d:	eb 1c                	jmp    80053b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80051f:	8b 45 08             	mov    0x8(%ebp),%eax
  800522:	8b 00                	mov    (%eax),%eax
  800524:	8d 50 04             	lea    0x4(%eax),%edx
  800527:	8b 45 08             	mov    0x8(%ebp),%eax
  80052a:	89 10                	mov    %edx,(%eax)
  80052c:	8b 45 08             	mov    0x8(%ebp),%eax
  80052f:	8b 00                	mov    (%eax),%eax
  800531:	83 e8 04             	sub    $0x4,%eax
  800534:	8b 00                	mov    (%eax),%eax
  800536:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80053b:	5d                   	pop    %ebp
  80053c:	c3                   	ret    

0080053d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80053d:	55                   	push   %ebp
  80053e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800540:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800544:	7e 1c                	jle    800562 <getint+0x25>
		return va_arg(*ap, long long);
  800546:	8b 45 08             	mov    0x8(%ebp),%eax
  800549:	8b 00                	mov    (%eax),%eax
  80054b:	8d 50 08             	lea    0x8(%eax),%edx
  80054e:	8b 45 08             	mov    0x8(%ebp),%eax
  800551:	89 10                	mov    %edx,(%eax)
  800553:	8b 45 08             	mov    0x8(%ebp),%eax
  800556:	8b 00                	mov    (%eax),%eax
  800558:	83 e8 08             	sub    $0x8,%eax
  80055b:	8b 50 04             	mov    0x4(%eax),%edx
  80055e:	8b 00                	mov    (%eax),%eax
  800560:	eb 38                	jmp    80059a <getint+0x5d>
	else if (lflag)
  800562:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800566:	74 1a                	je     800582 <getint+0x45>
		return va_arg(*ap, long);
  800568:	8b 45 08             	mov    0x8(%ebp),%eax
  80056b:	8b 00                	mov    (%eax),%eax
  80056d:	8d 50 04             	lea    0x4(%eax),%edx
  800570:	8b 45 08             	mov    0x8(%ebp),%eax
  800573:	89 10                	mov    %edx,(%eax)
  800575:	8b 45 08             	mov    0x8(%ebp),%eax
  800578:	8b 00                	mov    (%eax),%eax
  80057a:	83 e8 04             	sub    $0x4,%eax
  80057d:	8b 00                	mov    (%eax),%eax
  80057f:	99                   	cltd   
  800580:	eb 18                	jmp    80059a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800582:	8b 45 08             	mov    0x8(%ebp),%eax
  800585:	8b 00                	mov    (%eax),%eax
  800587:	8d 50 04             	lea    0x4(%eax),%edx
  80058a:	8b 45 08             	mov    0x8(%ebp),%eax
  80058d:	89 10                	mov    %edx,(%eax)
  80058f:	8b 45 08             	mov    0x8(%ebp),%eax
  800592:	8b 00                	mov    (%eax),%eax
  800594:	83 e8 04             	sub    $0x4,%eax
  800597:	8b 00                	mov    (%eax),%eax
  800599:	99                   	cltd   
}
  80059a:	5d                   	pop    %ebp
  80059b:	c3                   	ret    

0080059c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80059c:	55                   	push   %ebp
  80059d:	89 e5                	mov    %esp,%ebp
  80059f:	56                   	push   %esi
  8005a0:	53                   	push   %ebx
  8005a1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005a4:	eb 17                	jmp    8005bd <vprintfmt+0x21>
			if (ch == '\0')
  8005a6:	85 db                	test   %ebx,%ebx
  8005a8:	0f 84 c1 03 00 00    	je     80096f <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8005ae:	83 ec 08             	sub    $0x8,%esp
  8005b1:	ff 75 0c             	pushl  0xc(%ebp)
  8005b4:	53                   	push   %ebx
  8005b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b8:	ff d0                	call   *%eax
  8005ba:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c0:	8d 50 01             	lea    0x1(%eax),%edx
  8005c3:	89 55 10             	mov    %edx,0x10(%ebp)
  8005c6:	8a 00                	mov    (%eax),%al
  8005c8:	0f b6 d8             	movzbl %al,%ebx
  8005cb:	83 fb 25             	cmp    $0x25,%ebx
  8005ce:	75 d6                	jne    8005a6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005d0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005d4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005db:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005e2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005e9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f3:	8d 50 01             	lea    0x1(%eax),%edx
  8005f6:	89 55 10             	mov    %edx,0x10(%ebp)
  8005f9:	8a 00                	mov    (%eax),%al
  8005fb:	0f b6 d8             	movzbl %al,%ebx
  8005fe:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800601:	83 f8 5b             	cmp    $0x5b,%eax
  800604:	0f 87 3d 03 00 00    	ja     800947 <vprintfmt+0x3ab>
  80060a:	8b 04 85 98 22 80 00 	mov    0x802298(,%eax,4),%eax
  800611:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800613:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800617:	eb d7                	jmp    8005f0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800619:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80061d:	eb d1                	jmp    8005f0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80061f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800626:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800629:	89 d0                	mov    %edx,%eax
  80062b:	c1 e0 02             	shl    $0x2,%eax
  80062e:	01 d0                	add    %edx,%eax
  800630:	01 c0                	add    %eax,%eax
  800632:	01 d8                	add    %ebx,%eax
  800634:	83 e8 30             	sub    $0x30,%eax
  800637:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80063a:	8b 45 10             	mov    0x10(%ebp),%eax
  80063d:	8a 00                	mov    (%eax),%al
  80063f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800642:	83 fb 2f             	cmp    $0x2f,%ebx
  800645:	7e 3e                	jle    800685 <vprintfmt+0xe9>
  800647:	83 fb 39             	cmp    $0x39,%ebx
  80064a:	7f 39                	jg     800685 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80064c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80064f:	eb d5                	jmp    800626 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	83 c0 04             	add    $0x4,%eax
  800657:	89 45 14             	mov    %eax,0x14(%ebp)
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	83 e8 04             	sub    $0x4,%eax
  800660:	8b 00                	mov    (%eax),%eax
  800662:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800665:	eb 1f                	jmp    800686 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800667:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80066b:	79 83                	jns    8005f0 <vprintfmt+0x54>
				width = 0;
  80066d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800674:	e9 77 ff ff ff       	jmp    8005f0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800679:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800680:	e9 6b ff ff ff       	jmp    8005f0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800685:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800686:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80068a:	0f 89 60 ff ff ff    	jns    8005f0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800690:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800693:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800696:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80069d:	e9 4e ff ff ff       	jmp    8005f0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006a2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8006a5:	e9 46 ff ff ff       	jmp    8005f0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	83 c0 04             	add    $0x4,%eax
  8006b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b6:	83 e8 04             	sub    $0x4,%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	83 ec 08             	sub    $0x8,%esp
  8006be:	ff 75 0c             	pushl  0xc(%ebp)
  8006c1:	50                   	push   %eax
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	ff d0                	call   *%eax
  8006c7:	83 c4 10             	add    $0x10,%esp
			break;
  8006ca:	e9 9b 02 00 00       	jmp    80096a <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	83 c0 04             	add    $0x4,%eax
  8006d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8006d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006db:	83 e8 04             	sub    $0x4,%eax
  8006de:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006e0:	85 db                	test   %ebx,%ebx
  8006e2:	79 02                	jns    8006e6 <vprintfmt+0x14a>
				err = -err;
  8006e4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006e6:	83 fb 64             	cmp    $0x64,%ebx
  8006e9:	7f 0b                	jg     8006f6 <vprintfmt+0x15a>
  8006eb:	8b 34 9d e0 20 80 00 	mov    0x8020e0(,%ebx,4),%esi
  8006f2:	85 f6                	test   %esi,%esi
  8006f4:	75 19                	jne    80070f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006f6:	53                   	push   %ebx
  8006f7:	68 85 22 80 00       	push   $0x802285
  8006fc:	ff 75 0c             	pushl  0xc(%ebp)
  8006ff:	ff 75 08             	pushl  0x8(%ebp)
  800702:	e8 70 02 00 00       	call   800977 <printfmt>
  800707:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80070a:	e9 5b 02 00 00       	jmp    80096a <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80070f:	56                   	push   %esi
  800710:	68 8e 22 80 00       	push   $0x80228e
  800715:	ff 75 0c             	pushl  0xc(%ebp)
  800718:	ff 75 08             	pushl  0x8(%ebp)
  80071b:	e8 57 02 00 00       	call   800977 <printfmt>
  800720:	83 c4 10             	add    $0x10,%esp
			break;
  800723:	e9 42 02 00 00       	jmp    80096a <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800728:	8b 45 14             	mov    0x14(%ebp),%eax
  80072b:	83 c0 04             	add    $0x4,%eax
  80072e:	89 45 14             	mov    %eax,0x14(%ebp)
  800731:	8b 45 14             	mov    0x14(%ebp),%eax
  800734:	83 e8 04             	sub    $0x4,%eax
  800737:	8b 30                	mov    (%eax),%esi
  800739:	85 f6                	test   %esi,%esi
  80073b:	75 05                	jne    800742 <vprintfmt+0x1a6>
				p = "(null)";
  80073d:	be 91 22 80 00       	mov    $0x802291,%esi
			if (width > 0 && padc != '-')
  800742:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800746:	7e 6d                	jle    8007b5 <vprintfmt+0x219>
  800748:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80074c:	74 67                	je     8007b5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80074e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	50                   	push   %eax
  800755:	56                   	push   %esi
  800756:	e8 26 05 00 00       	call   800c81 <strnlen>
  80075b:	83 c4 10             	add    $0x10,%esp
  80075e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800761:	eb 16                	jmp    800779 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800763:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	ff 75 0c             	pushl  0xc(%ebp)
  80076d:	50                   	push   %eax
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	ff d0                	call   *%eax
  800773:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800776:	ff 4d e4             	decl   -0x1c(%ebp)
  800779:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80077d:	7f e4                	jg     800763 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80077f:	eb 34                	jmp    8007b5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800781:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800785:	74 1c                	je     8007a3 <vprintfmt+0x207>
  800787:	83 fb 1f             	cmp    $0x1f,%ebx
  80078a:	7e 05                	jle    800791 <vprintfmt+0x1f5>
  80078c:	83 fb 7e             	cmp    $0x7e,%ebx
  80078f:	7e 12                	jle    8007a3 <vprintfmt+0x207>
					putch('?', putdat);
  800791:	83 ec 08             	sub    $0x8,%esp
  800794:	ff 75 0c             	pushl  0xc(%ebp)
  800797:	6a 3f                	push   $0x3f
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	ff d0                	call   *%eax
  80079e:	83 c4 10             	add    $0x10,%esp
  8007a1:	eb 0f                	jmp    8007b2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	ff 75 0c             	pushl  0xc(%ebp)
  8007a9:	53                   	push   %ebx
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	ff d0                	call   *%eax
  8007af:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007b2:	ff 4d e4             	decl   -0x1c(%ebp)
  8007b5:	89 f0                	mov    %esi,%eax
  8007b7:	8d 70 01             	lea    0x1(%eax),%esi
  8007ba:	8a 00                	mov    (%eax),%al
  8007bc:	0f be d8             	movsbl %al,%ebx
  8007bf:	85 db                	test   %ebx,%ebx
  8007c1:	74 24                	je     8007e7 <vprintfmt+0x24b>
  8007c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007c7:	78 b8                	js     800781 <vprintfmt+0x1e5>
  8007c9:	ff 4d e0             	decl   -0x20(%ebp)
  8007cc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007d0:	79 af                	jns    800781 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007d2:	eb 13                	jmp    8007e7 <vprintfmt+0x24b>
				putch(' ', putdat);
  8007d4:	83 ec 08             	sub    $0x8,%esp
  8007d7:	ff 75 0c             	pushl  0xc(%ebp)
  8007da:	6a 20                	push   $0x20
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	ff d0                	call   *%eax
  8007e1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007e4:	ff 4d e4             	decl   -0x1c(%ebp)
  8007e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007eb:	7f e7                	jg     8007d4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007ed:	e9 78 01 00 00       	jmp    80096a <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007f2:	83 ec 08             	sub    $0x8,%esp
  8007f5:	ff 75 e8             	pushl  -0x18(%ebp)
  8007f8:	8d 45 14             	lea    0x14(%ebp),%eax
  8007fb:	50                   	push   %eax
  8007fc:	e8 3c fd ff ff       	call   80053d <getint>
  800801:	83 c4 10             	add    $0x10,%esp
  800804:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800807:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80080a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80080d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800810:	85 d2                	test   %edx,%edx
  800812:	79 23                	jns    800837 <vprintfmt+0x29b>
				putch('-', putdat);
  800814:	83 ec 08             	sub    $0x8,%esp
  800817:	ff 75 0c             	pushl  0xc(%ebp)
  80081a:	6a 2d                	push   $0x2d
  80081c:	8b 45 08             	mov    0x8(%ebp),%eax
  80081f:	ff d0                	call   *%eax
  800821:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800824:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800827:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80082a:	f7 d8                	neg    %eax
  80082c:	83 d2 00             	adc    $0x0,%edx
  80082f:	f7 da                	neg    %edx
  800831:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800834:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800837:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80083e:	e9 bc 00 00 00       	jmp    8008ff <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800843:	83 ec 08             	sub    $0x8,%esp
  800846:	ff 75 e8             	pushl  -0x18(%ebp)
  800849:	8d 45 14             	lea    0x14(%ebp),%eax
  80084c:	50                   	push   %eax
  80084d:	e8 84 fc ff ff       	call   8004d6 <getuint>
  800852:	83 c4 10             	add    $0x10,%esp
  800855:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800858:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80085b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800862:	e9 98 00 00 00       	jmp    8008ff <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800867:	83 ec 08             	sub    $0x8,%esp
  80086a:	ff 75 0c             	pushl  0xc(%ebp)
  80086d:	6a 58                	push   $0x58
  80086f:	8b 45 08             	mov    0x8(%ebp),%eax
  800872:	ff d0                	call   *%eax
  800874:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800877:	83 ec 08             	sub    $0x8,%esp
  80087a:	ff 75 0c             	pushl  0xc(%ebp)
  80087d:	6a 58                	push   $0x58
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	ff d0                	call   *%eax
  800884:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800887:	83 ec 08             	sub    $0x8,%esp
  80088a:	ff 75 0c             	pushl  0xc(%ebp)
  80088d:	6a 58                	push   $0x58
  80088f:	8b 45 08             	mov    0x8(%ebp),%eax
  800892:	ff d0                	call   *%eax
  800894:	83 c4 10             	add    $0x10,%esp
			break;
  800897:	e9 ce 00 00 00       	jmp    80096a <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80089c:	83 ec 08             	sub    $0x8,%esp
  80089f:	ff 75 0c             	pushl  0xc(%ebp)
  8008a2:	6a 30                	push   $0x30
  8008a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a7:	ff d0                	call   *%eax
  8008a9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008ac:	83 ec 08             	sub    $0x8,%esp
  8008af:	ff 75 0c             	pushl  0xc(%ebp)
  8008b2:	6a 78                	push   $0x78
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	ff d0                	call   *%eax
  8008b9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8008bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bf:	83 c0 04             	add    $0x4,%eax
  8008c2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c8:	83 e8 04             	sub    $0x4,%eax
  8008cb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008d7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008de:	eb 1f                	jmp    8008ff <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008e0:	83 ec 08             	sub    $0x8,%esp
  8008e3:	ff 75 e8             	pushl  -0x18(%ebp)
  8008e6:	8d 45 14             	lea    0x14(%ebp),%eax
  8008e9:	50                   	push   %eax
  8008ea:	e8 e7 fb ff ff       	call   8004d6 <getuint>
  8008ef:	83 c4 10             	add    $0x10,%esp
  8008f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008f8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008ff:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800903:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800906:	83 ec 04             	sub    $0x4,%esp
  800909:	52                   	push   %edx
  80090a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80090d:	50                   	push   %eax
  80090e:	ff 75 f4             	pushl  -0xc(%ebp)
  800911:	ff 75 f0             	pushl  -0x10(%ebp)
  800914:	ff 75 0c             	pushl  0xc(%ebp)
  800917:	ff 75 08             	pushl  0x8(%ebp)
  80091a:	e8 00 fb ff ff       	call   80041f <printnum>
  80091f:	83 c4 20             	add    $0x20,%esp
			break;
  800922:	eb 46                	jmp    80096a <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	ff 75 0c             	pushl  0xc(%ebp)
  80092a:	53                   	push   %ebx
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	ff d0                	call   *%eax
  800930:	83 c4 10             	add    $0x10,%esp
			break;
  800933:	eb 35                	jmp    80096a <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800935:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  80093c:	eb 2c                	jmp    80096a <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80093e:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800945:	eb 23                	jmp    80096a <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	6a 25                	push   $0x25
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	ff d0                	call   *%eax
  800954:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800957:	ff 4d 10             	decl   0x10(%ebp)
  80095a:	eb 03                	jmp    80095f <vprintfmt+0x3c3>
  80095c:	ff 4d 10             	decl   0x10(%ebp)
  80095f:	8b 45 10             	mov    0x10(%ebp),%eax
  800962:	48                   	dec    %eax
  800963:	8a 00                	mov    (%eax),%al
  800965:	3c 25                	cmp    $0x25,%al
  800967:	75 f3                	jne    80095c <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800969:	90                   	nop
		}
	}
  80096a:	e9 35 fc ff ff       	jmp    8005a4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80096f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800970:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800973:	5b                   	pop    %ebx
  800974:	5e                   	pop    %esi
  800975:	5d                   	pop    %ebp
  800976:	c3                   	ret    

00800977 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80097d:	8d 45 10             	lea    0x10(%ebp),%eax
  800980:	83 c0 04             	add    $0x4,%eax
  800983:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800986:	8b 45 10             	mov    0x10(%ebp),%eax
  800989:	ff 75 f4             	pushl  -0xc(%ebp)
  80098c:	50                   	push   %eax
  80098d:	ff 75 0c             	pushl  0xc(%ebp)
  800990:	ff 75 08             	pushl  0x8(%ebp)
  800993:	e8 04 fc ff ff       	call   80059c <vprintfmt>
  800998:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80099b:	90                   	nop
  80099c:	c9                   	leave  
  80099d:	c3                   	ret    

0080099e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80099e:	55                   	push   %ebp
  80099f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8009a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a4:	8b 40 08             	mov    0x8(%eax),%eax
  8009a7:	8d 50 01             	lea    0x1(%eax),%edx
  8009aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ad:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8009b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b3:	8b 10                	mov    (%eax),%edx
  8009b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b8:	8b 40 04             	mov    0x4(%eax),%eax
  8009bb:	39 c2                	cmp    %eax,%edx
  8009bd:	73 12                	jae    8009d1 <sprintputch+0x33>
		*b->buf++ = ch;
  8009bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c2:	8b 00                	mov    (%eax),%eax
  8009c4:	8d 48 01             	lea    0x1(%eax),%ecx
  8009c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ca:	89 0a                	mov    %ecx,(%edx)
  8009cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8009cf:	88 10                	mov    %dl,(%eax)
}
  8009d1:	90                   	nop
  8009d2:	5d                   	pop    %ebp
  8009d3:	c3                   	ret    

008009d4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
  8009d7:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009da:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	01 d0                	add    %edx,%eax
  8009eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009f9:	74 06                	je     800a01 <vsnprintf+0x2d>
  8009fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009ff:	7f 07                	jg     800a08 <vsnprintf+0x34>
		return -E_INVAL;
  800a01:	b8 03 00 00 00       	mov    $0x3,%eax
  800a06:	eb 20                	jmp    800a28 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a08:	ff 75 14             	pushl  0x14(%ebp)
  800a0b:	ff 75 10             	pushl  0x10(%ebp)
  800a0e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a11:	50                   	push   %eax
  800a12:	68 9e 09 80 00       	push   $0x80099e
  800a17:	e8 80 fb ff ff       	call   80059c <vprintfmt>
  800a1c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a22:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a28:	c9                   	leave  
  800a29:	c3                   	ret    

00800a2a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a30:	8d 45 10             	lea    0x10(%ebp),%eax
  800a33:	83 c0 04             	add    $0x4,%eax
  800a36:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a39:	8b 45 10             	mov    0x10(%ebp),%eax
  800a3c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a3f:	50                   	push   %eax
  800a40:	ff 75 0c             	pushl  0xc(%ebp)
  800a43:	ff 75 08             	pushl  0x8(%ebp)
  800a46:	e8 89 ff ff ff       	call   8009d4 <vsnprintf>
  800a4b:	83 c4 10             	add    $0x10,%esp
  800a4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a54:	c9                   	leave  
  800a55:	c3                   	ret    

00800a56 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800a5c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a60:	74 13                	je     800a75 <readline+0x1f>
		cprintf("%s", prompt);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 08             	pushl  0x8(%ebp)
  800a68:	68 08 24 80 00       	push   $0x802408
  800a6d:	e8 0b f9 ff ff       	call   80037d <cprintf>
  800a72:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a7c:	83 ec 0c             	sub    $0xc,%esp
  800a7f:	6a 00                	push   $0x0
  800a81:	e8 c0 0f 00 00       	call   801a46 <iscons>
  800a86:	83 c4 10             	add    $0x10,%esp
  800a89:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a8c:	e8 a2 0f 00 00       	call   801a33 <getchar>
  800a91:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800a94:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a98:	79 22                	jns    800abc <readline+0x66>
			if (c != -E_EOF)
  800a9a:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800a9e:	0f 84 ad 00 00 00    	je     800b51 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800aa4:	83 ec 08             	sub    $0x8,%esp
  800aa7:	ff 75 ec             	pushl  -0x14(%ebp)
  800aaa:	68 0b 24 80 00       	push   $0x80240b
  800aaf:	e8 c9 f8 ff ff       	call   80037d <cprintf>
  800ab4:	83 c4 10             	add    $0x10,%esp
			break;
  800ab7:	e9 95 00 00 00       	jmp    800b51 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800abc:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ac0:	7e 34                	jle    800af6 <readline+0xa0>
  800ac2:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ac9:	7f 2b                	jg     800af6 <readline+0xa0>
			if (echoing)
  800acb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800acf:	74 0e                	je     800adf <readline+0x89>
				cputchar(c);
  800ad1:	83 ec 0c             	sub    $0xc,%esp
  800ad4:	ff 75 ec             	pushl  -0x14(%ebp)
  800ad7:	e8 38 0f 00 00       	call   801a14 <cputchar>
  800adc:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ae2:	8d 50 01             	lea    0x1(%eax),%edx
  800ae5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800ae8:	89 c2                	mov    %eax,%edx
  800aea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aed:	01 d0                	add    %edx,%eax
  800aef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800af2:	88 10                	mov    %dl,(%eax)
  800af4:	eb 56                	jmp    800b4c <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800af6:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800afa:	75 1f                	jne    800b1b <readline+0xc5>
  800afc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b00:	7e 19                	jle    800b1b <readline+0xc5>
			if (echoing)
  800b02:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b06:	74 0e                	je     800b16 <readline+0xc0>
				cputchar(c);
  800b08:	83 ec 0c             	sub    $0xc,%esp
  800b0b:	ff 75 ec             	pushl  -0x14(%ebp)
  800b0e:	e8 01 0f 00 00       	call   801a14 <cputchar>
  800b13:	83 c4 10             	add    $0x10,%esp

			i--;
  800b16:	ff 4d f4             	decl   -0xc(%ebp)
  800b19:	eb 31                	jmp    800b4c <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800b1b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b1f:	74 0a                	je     800b2b <readline+0xd5>
  800b21:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b25:	0f 85 61 ff ff ff    	jne    800a8c <readline+0x36>
			if (echoing)
  800b2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b2f:	74 0e                	je     800b3f <readline+0xe9>
				cputchar(c);
  800b31:	83 ec 0c             	sub    $0xc,%esp
  800b34:	ff 75 ec             	pushl  -0x14(%ebp)
  800b37:	e8 d8 0e 00 00       	call   801a14 <cputchar>
  800b3c:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800b3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	01 d0                	add    %edx,%eax
  800b47:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800b4a:	eb 06                	jmp    800b52 <readline+0xfc>
		}
	}
  800b4c:	e9 3b ff ff ff       	jmp    800a8c <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800b51:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800b52:	90                   	nop
  800b53:	c9                   	leave  
  800b54:	c3                   	ret    

00800b55 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800b5b:	e8 79 09 00 00       	call   8014d9 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b64:	74 13                	je     800b79 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b66:	83 ec 08             	sub    $0x8,%esp
  800b69:	ff 75 08             	pushl  0x8(%ebp)
  800b6c:	68 08 24 80 00       	push   $0x802408
  800b71:	e8 07 f8 ff ff       	call   80037d <cprintf>
  800b76:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b80:	83 ec 0c             	sub    $0xc,%esp
  800b83:	6a 00                	push   $0x0
  800b85:	e8 bc 0e 00 00       	call   801a46 <iscons>
  800b8a:	83 c4 10             	add    $0x10,%esp
  800b8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800b90:	e8 9e 0e 00 00       	call   801a33 <getchar>
  800b95:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800b98:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b9c:	79 22                	jns    800bc0 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800b9e:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800ba2:	0f 84 ad 00 00 00    	je     800c55 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800ba8:	83 ec 08             	sub    $0x8,%esp
  800bab:	ff 75 ec             	pushl  -0x14(%ebp)
  800bae:	68 0b 24 80 00       	push   $0x80240b
  800bb3:	e8 c5 f7 ff ff       	call   80037d <cprintf>
  800bb8:	83 c4 10             	add    $0x10,%esp
				break;
  800bbb:	e9 95 00 00 00       	jmp    800c55 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800bc0:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800bc4:	7e 34                	jle    800bfa <atomic_readline+0xa5>
  800bc6:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800bcd:	7f 2b                	jg     800bfa <atomic_readline+0xa5>
				if (echoing)
  800bcf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bd3:	74 0e                	je     800be3 <atomic_readline+0x8e>
					cputchar(c);
  800bd5:	83 ec 0c             	sub    $0xc,%esp
  800bd8:	ff 75 ec             	pushl  -0x14(%ebp)
  800bdb:	e8 34 0e 00 00       	call   801a14 <cputchar>
  800be0:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800be6:	8d 50 01             	lea    0x1(%eax),%edx
  800be9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800bec:	89 c2                	mov    %eax,%edx
  800bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf1:	01 d0                	add    %edx,%eax
  800bf3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800bf6:	88 10                	mov    %dl,(%eax)
  800bf8:	eb 56                	jmp    800c50 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800bfa:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800bfe:	75 1f                	jne    800c1f <atomic_readline+0xca>
  800c00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800c04:	7e 19                	jle    800c1f <atomic_readline+0xca>
				if (echoing)
  800c06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c0a:	74 0e                	je     800c1a <atomic_readline+0xc5>
					cputchar(c);
  800c0c:	83 ec 0c             	sub    $0xc,%esp
  800c0f:	ff 75 ec             	pushl  -0x14(%ebp)
  800c12:	e8 fd 0d 00 00       	call   801a14 <cputchar>
  800c17:	83 c4 10             	add    $0x10,%esp
				i--;
  800c1a:	ff 4d f4             	decl   -0xc(%ebp)
  800c1d:	eb 31                	jmp    800c50 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800c1f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800c23:	74 0a                	je     800c2f <atomic_readline+0xda>
  800c25:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800c29:	0f 85 61 ff ff ff    	jne    800b90 <atomic_readline+0x3b>
				if (echoing)
  800c2f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c33:	74 0e                	je     800c43 <atomic_readline+0xee>
					cputchar(c);
  800c35:	83 ec 0c             	sub    $0xc,%esp
  800c38:	ff 75 ec             	pushl  -0x14(%ebp)
  800c3b:	e8 d4 0d 00 00       	call   801a14 <cputchar>
  800c40:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800c43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c49:	01 d0                	add    %edx,%eax
  800c4b:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800c4e:	eb 06                	jmp    800c56 <atomic_readline+0x101>
			}
		}
  800c50:	e9 3b ff ff ff       	jmp    800b90 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800c55:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800c56:	e8 98 08 00 00       	call   8014f3 <sys_unlock_cons>
}
  800c5b:	90                   	nop
  800c5c:	c9                   	leave  
  800c5d:	c3                   	ret    

00800c5e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c5e:	55                   	push   %ebp
  800c5f:	89 e5                	mov    %esp,%ebp
  800c61:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c6b:	eb 06                	jmp    800c73 <strlen+0x15>
		n++;
  800c6d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c70:	ff 45 08             	incl   0x8(%ebp)
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	8a 00                	mov    (%eax),%al
  800c78:	84 c0                	test   %al,%al
  800c7a:	75 f1                	jne    800c6d <strlen+0xf>
		n++;
	return n;
  800c7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c7f:	c9                   	leave  
  800c80:	c3                   	ret    

00800c81 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c8e:	eb 09                	jmp    800c99 <strnlen+0x18>
		n++;
  800c90:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c93:	ff 45 08             	incl   0x8(%ebp)
  800c96:	ff 4d 0c             	decl   0xc(%ebp)
  800c99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c9d:	74 09                	je     800ca8 <strnlen+0x27>
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	8a 00                	mov    (%eax),%al
  800ca4:	84 c0                	test   %al,%al
  800ca6:	75 e8                	jne    800c90 <strnlen+0xf>
		n++;
	return n;
  800ca8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cab:	c9                   	leave  
  800cac:	c3                   	ret    

00800cad <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cb9:	90                   	nop
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	8d 50 01             	lea    0x1(%eax),%edx
  800cc0:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ccc:	8a 12                	mov    (%edx),%dl
  800cce:	88 10                	mov    %dl,(%eax)
  800cd0:	8a 00                	mov    (%eax),%al
  800cd2:	84 c0                	test   %al,%al
  800cd4:	75 e4                	jne    800cba <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd9:	c9                   	leave  
  800cda:	c3                   	ret    

00800cdb <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ce7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cee:	eb 1f                	jmp    800d0f <strncpy+0x34>
		*dst++ = *src;
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	8d 50 01             	lea    0x1(%eax),%edx
  800cf6:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfc:	8a 12                	mov    (%edx),%dl
  800cfe:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d03:	8a 00                	mov    (%eax),%al
  800d05:	84 c0                	test   %al,%al
  800d07:	74 03                	je     800d0c <strncpy+0x31>
			src++;
  800d09:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d0c:	ff 45 fc             	incl   -0x4(%ebp)
  800d0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d12:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d15:	72 d9                	jb     800cf0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d17:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d1a:	c9                   	leave  
  800d1b:	c3                   	ret    

00800d1c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2c:	74 30                	je     800d5e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d2e:	eb 16                	jmp    800d46 <strlcpy+0x2a>
			*dst++ = *src++;
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	8d 50 01             	lea    0x1(%eax),%edx
  800d36:	89 55 08             	mov    %edx,0x8(%ebp)
  800d39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d42:	8a 12                	mov    (%edx),%dl
  800d44:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d46:	ff 4d 10             	decl   0x10(%ebp)
  800d49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4d:	74 09                	je     800d58 <strlcpy+0x3c>
  800d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d52:	8a 00                	mov    (%eax),%al
  800d54:	84 c0                	test   %al,%al
  800d56:	75 d8                	jne    800d30 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d64:	29 c2                	sub    %eax,%edx
  800d66:	89 d0                	mov    %edx,%eax
}
  800d68:	c9                   	leave  
  800d69:	c3                   	ret    

00800d6a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d6d:	eb 06                	jmp    800d75 <strcmp+0xb>
		p++, q++;
  800d6f:	ff 45 08             	incl   0x8(%ebp)
  800d72:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	8a 00                	mov    (%eax),%al
  800d7a:	84 c0                	test   %al,%al
  800d7c:	74 0e                	je     800d8c <strcmp+0x22>
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	8a 10                	mov    (%eax),%dl
  800d83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d86:	8a 00                	mov    (%eax),%al
  800d88:	38 c2                	cmp    %al,%dl
  800d8a:	74 e3                	je     800d6f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	0f b6 d0             	movzbl %al,%edx
  800d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d97:	8a 00                	mov    (%eax),%al
  800d99:	0f b6 c0             	movzbl %al,%eax
  800d9c:	29 c2                	sub    %eax,%edx
  800d9e:	89 d0                	mov    %edx,%eax
}
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    

00800da2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800da5:	eb 09                	jmp    800db0 <strncmp+0xe>
		n--, p++, q++;
  800da7:	ff 4d 10             	decl   0x10(%ebp)
  800daa:	ff 45 08             	incl   0x8(%ebp)
  800dad:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800db0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db4:	74 17                	je     800dcd <strncmp+0x2b>
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	84 c0                	test   %al,%al
  800dbd:	74 0e                	je     800dcd <strncmp+0x2b>
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	8a 10                	mov    (%eax),%dl
  800dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc7:	8a 00                	mov    (%eax),%al
  800dc9:	38 c2                	cmp    %al,%dl
  800dcb:	74 da                	je     800da7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dcd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd1:	75 07                	jne    800dda <strncmp+0x38>
		return 0;
  800dd3:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd8:	eb 14                	jmp    800dee <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	0f b6 d0             	movzbl %al,%edx
  800de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	0f b6 c0             	movzbl %al,%eax
  800dea:	29 c2                	sub    %eax,%edx
  800dec:	89 d0                	mov    %edx,%eax
}
  800dee:	5d                   	pop    %ebp
  800def:	c3                   	ret    

00800df0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	83 ec 04             	sub    $0x4,%esp
  800df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dfc:	eb 12                	jmp    800e10 <strchr+0x20>
		if (*s == c)
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e06:	75 05                	jne    800e0d <strchr+0x1d>
			return (char *) s;
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	eb 11                	jmp    800e1e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e0d:	ff 45 08             	incl   0x8(%ebp)
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	84 c0                	test   %al,%al
  800e17:	75 e5                	jne    800dfe <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e1e:	c9                   	leave  
  800e1f:	c3                   	ret    

00800e20 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	83 ec 04             	sub    $0x4,%esp
  800e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e29:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e2c:	eb 0d                	jmp    800e3b <strfind+0x1b>
		if (*s == c)
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	8a 00                	mov    (%eax),%al
  800e33:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e36:	74 0e                	je     800e46 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e38:	ff 45 08             	incl   0x8(%ebp)
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	84 c0                	test   %al,%al
  800e42:	75 ea                	jne    800e2e <strfind+0xe>
  800e44:	eb 01                	jmp    800e47 <strfind+0x27>
		if (*s == c)
			break;
  800e46:	90                   	nop
	return (char *) s;
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4a:	c9                   	leave  
  800e4b:	c3                   	ret    

00800e4c <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e58:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e5c:	76 63                	jbe    800ec1 <memset+0x75>
		uint64 data_block = c;
  800e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e61:	99                   	cltd   
  800e62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e65:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e6e:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e72:	c1 e0 08             	shl    $0x8,%eax
  800e75:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e78:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e81:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e85:	c1 e0 10             	shl    $0x10,%eax
  800e88:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e8b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e94:	89 c2                	mov    %eax,%edx
  800e96:	b8 00 00 00 00       	mov    $0x0,%eax
  800e9b:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e9e:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ea1:	eb 18                	jmp    800ebb <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ea3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ea6:	8d 41 08             	lea    0x8(%ecx),%eax
  800ea9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb2:	89 01                	mov    %eax,(%ecx)
  800eb4:	89 51 04             	mov    %edx,0x4(%ecx)
  800eb7:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ebb:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ebf:	77 e2                	ja     800ea3 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ec1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec5:	74 23                	je     800eea <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ec7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eca:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ecd:	eb 0e                	jmp    800edd <memset+0x91>
			*p8++ = (uint8)c;
  800ecf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed2:	8d 50 01             	lea    0x1(%eax),%edx
  800ed5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ed8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800edb:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800edd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee3:	89 55 10             	mov    %edx,0x10(%ebp)
  800ee6:	85 c0                	test   %eax,%eax
  800ee8:	75 e5                	jne    800ecf <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eed:	c9                   	leave  
  800eee:	c3                   	ret    

00800eef <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800eef:	55                   	push   %ebp
  800ef0:	89 e5                	mov    %esp,%ebp
  800ef2:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f01:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f05:	76 24                	jbe    800f2b <memcpy+0x3c>
		while(n >= 8){
  800f07:	eb 1c                	jmp    800f25 <memcpy+0x36>
			*d64 = *s64;
  800f09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0c:	8b 50 04             	mov    0x4(%eax),%edx
  800f0f:	8b 00                	mov    (%eax),%eax
  800f11:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f14:	89 01                	mov    %eax,(%ecx)
  800f16:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f19:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f1d:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f21:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f25:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f29:	77 de                	ja     800f09 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f2b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f2f:	74 31                	je     800f62 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f34:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f37:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f3d:	eb 16                	jmp    800f55 <memcpy+0x66>
			*d8++ = *s8++;
  800f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f42:	8d 50 01             	lea    0x1(%eax),%edx
  800f45:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f4b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f4e:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f51:	8a 12                	mov    (%edx),%dl
  800f53:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f55:	8b 45 10             	mov    0x10(%ebp),%eax
  800f58:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f5b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f5e:	85 c0                	test   %eax,%eax
  800f60:	75 dd                	jne    800f3f <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f65:	c9                   	leave  
  800f66:	c3                   	ret    

00800f67 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f7c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f7f:	73 50                	jae    800fd1 <memmove+0x6a>
  800f81:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f84:	8b 45 10             	mov    0x10(%ebp),%eax
  800f87:	01 d0                	add    %edx,%eax
  800f89:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f8c:	76 43                	jbe    800fd1 <memmove+0x6a>
		s += n;
  800f8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f91:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f94:	8b 45 10             	mov    0x10(%ebp),%eax
  800f97:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f9a:	eb 10                	jmp    800fac <memmove+0x45>
			*--d = *--s;
  800f9c:	ff 4d f8             	decl   -0x8(%ebp)
  800f9f:	ff 4d fc             	decl   -0x4(%ebp)
  800fa2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa5:	8a 10                	mov    (%eax),%dl
  800fa7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800faa:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fac:	8b 45 10             	mov    0x10(%ebp),%eax
  800faf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb2:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb5:	85 c0                	test   %eax,%eax
  800fb7:	75 e3                	jne    800f9c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fb9:	eb 23                	jmp    800fde <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fbb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fbe:	8d 50 01             	lea    0x1(%eax),%edx
  800fc1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fc4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fc7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fca:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fcd:	8a 12                	mov    (%edx),%dl
  800fcf:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd7:	89 55 10             	mov    %edx,0x10(%ebp)
  800fda:	85 c0                	test   %eax,%eax
  800fdc:	75 dd                	jne    800fbb <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fe1:	c9                   	leave  
  800fe2:	c3                   	ret    

00800fe3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fe3:	55                   	push   %ebp
  800fe4:	89 e5                	mov    %esp,%ebp
  800fe6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ff5:	eb 2a                	jmp    801021 <memcmp+0x3e>
		if (*s1 != *s2)
  800ff7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ffa:	8a 10                	mov    (%eax),%dl
  800ffc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	38 c2                	cmp    %al,%dl
  801003:	74 16                	je     80101b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801005:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	0f b6 d0             	movzbl %al,%edx
  80100d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	0f b6 c0             	movzbl %al,%eax
  801015:	29 c2                	sub    %eax,%edx
  801017:	89 d0                	mov    %edx,%eax
  801019:	eb 18                	jmp    801033 <memcmp+0x50>
		s1++, s2++;
  80101b:	ff 45 fc             	incl   -0x4(%ebp)
  80101e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801021:	8b 45 10             	mov    0x10(%ebp),%eax
  801024:	8d 50 ff             	lea    -0x1(%eax),%edx
  801027:	89 55 10             	mov    %edx,0x10(%ebp)
  80102a:	85 c0                	test   %eax,%eax
  80102c:	75 c9                	jne    800ff7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80102e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801033:	c9                   	leave  
  801034:	c3                   	ret    

00801035 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801035:	55                   	push   %ebp
  801036:	89 e5                	mov    %esp,%ebp
  801038:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80103b:	8b 55 08             	mov    0x8(%ebp),%edx
  80103e:	8b 45 10             	mov    0x10(%ebp),%eax
  801041:	01 d0                	add    %edx,%eax
  801043:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801046:	eb 15                	jmp    80105d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	0f b6 d0             	movzbl %al,%edx
  801050:	8b 45 0c             	mov    0xc(%ebp),%eax
  801053:	0f b6 c0             	movzbl %al,%eax
  801056:	39 c2                	cmp    %eax,%edx
  801058:	74 0d                	je     801067 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80105a:	ff 45 08             	incl   0x8(%ebp)
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801063:	72 e3                	jb     801048 <memfind+0x13>
  801065:	eb 01                	jmp    801068 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801067:	90                   	nop
	return (void *) s;
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80106b:	c9                   	leave  
  80106c:	c3                   	ret    

0080106d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80106d:	55                   	push   %ebp
  80106e:	89 e5                	mov    %esp,%ebp
  801070:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801073:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80107a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801081:	eb 03                	jmp    801086 <strtol+0x19>
		s++;
  801083:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
  801089:	8a 00                	mov    (%eax),%al
  80108b:	3c 20                	cmp    $0x20,%al
  80108d:	74 f4                	je     801083 <strtol+0x16>
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	8a 00                	mov    (%eax),%al
  801094:	3c 09                	cmp    $0x9,%al
  801096:	74 eb                	je     801083 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	3c 2b                	cmp    $0x2b,%al
  80109f:	75 05                	jne    8010a6 <strtol+0x39>
		s++;
  8010a1:	ff 45 08             	incl   0x8(%ebp)
  8010a4:	eb 13                	jmp    8010b9 <strtol+0x4c>
	else if (*s == '-')
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	8a 00                	mov    (%eax),%al
  8010ab:	3c 2d                	cmp    $0x2d,%al
  8010ad:	75 0a                	jne    8010b9 <strtol+0x4c>
		s++, neg = 1;
  8010af:	ff 45 08             	incl   0x8(%ebp)
  8010b2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010bd:	74 06                	je     8010c5 <strtol+0x58>
  8010bf:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010c3:	75 20                	jne    8010e5 <strtol+0x78>
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	8a 00                	mov    (%eax),%al
  8010ca:	3c 30                	cmp    $0x30,%al
  8010cc:	75 17                	jne    8010e5 <strtol+0x78>
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d1:	40                   	inc    %eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	3c 78                	cmp    $0x78,%al
  8010d6:	75 0d                	jne    8010e5 <strtol+0x78>
		s += 2, base = 16;
  8010d8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010dc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010e3:	eb 28                	jmp    80110d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e9:	75 15                	jne    801100 <strtol+0x93>
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	8a 00                	mov    (%eax),%al
  8010f0:	3c 30                	cmp    $0x30,%al
  8010f2:	75 0c                	jne    801100 <strtol+0x93>
		s++, base = 8;
  8010f4:	ff 45 08             	incl   0x8(%ebp)
  8010f7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010fe:	eb 0d                	jmp    80110d <strtol+0xa0>
	else if (base == 0)
  801100:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801104:	75 07                	jne    80110d <strtol+0xa0>
		base = 10;
  801106:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
  801110:	8a 00                	mov    (%eax),%al
  801112:	3c 2f                	cmp    $0x2f,%al
  801114:	7e 19                	jle    80112f <strtol+0xc2>
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	8a 00                	mov    (%eax),%al
  80111b:	3c 39                	cmp    $0x39,%al
  80111d:	7f 10                	jg     80112f <strtol+0xc2>
			dig = *s - '0';
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
  801122:	8a 00                	mov    (%eax),%al
  801124:	0f be c0             	movsbl %al,%eax
  801127:	83 e8 30             	sub    $0x30,%eax
  80112a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80112d:	eb 42                	jmp    801171 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	8a 00                	mov    (%eax),%al
  801134:	3c 60                	cmp    $0x60,%al
  801136:	7e 19                	jle    801151 <strtol+0xe4>
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	8a 00                	mov    (%eax),%al
  80113d:	3c 7a                	cmp    $0x7a,%al
  80113f:	7f 10                	jg     801151 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	0f be c0             	movsbl %al,%eax
  801149:	83 e8 57             	sub    $0x57,%eax
  80114c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80114f:	eb 20                	jmp    801171 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	8a 00                	mov    (%eax),%al
  801156:	3c 40                	cmp    $0x40,%al
  801158:	7e 39                	jle    801193 <strtol+0x126>
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	3c 5a                	cmp    $0x5a,%al
  801161:	7f 30                	jg     801193 <strtol+0x126>
			dig = *s - 'A' + 10;
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8a 00                	mov    (%eax),%al
  801168:	0f be c0             	movsbl %al,%eax
  80116b:	83 e8 37             	sub    $0x37,%eax
  80116e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801174:	3b 45 10             	cmp    0x10(%ebp),%eax
  801177:	7d 19                	jge    801192 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801179:	ff 45 08             	incl   0x8(%ebp)
  80117c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801183:	89 c2                	mov    %eax,%edx
  801185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801188:	01 d0                	add    %edx,%eax
  80118a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80118d:	e9 7b ff ff ff       	jmp    80110d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801192:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801193:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801197:	74 08                	je     8011a1 <strtol+0x134>
		*endptr = (char *) s;
  801199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119c:	8b 55 08             	mov    0x8(%ebp),%edx
  80119f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011a5:	74 07                	je     8011ae <strtol+0x141>
  8011a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011aa:	f7 d8                	neg    %eax
  8011ac:	eb 03                	jmp    8011b1 <strtol+0x144>
  8011ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011b1:	c9                   	leave  
  8011b2:	c3                   	ret    

008011b3 <ltostr>:

void
ltostr(long value, char *str)
{
  8011b3:	55                   	push   %ebp
  8011b4:	89 e5                	mov    %esp,%ebp
  8011b6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011cb:	79 13                	jns    8011e0 <ltostr+0x2d>
	{
		neg = 1;
  8011cd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011da:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011dd:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011e8:	99                   	cltd   
  8011e9:	f7 f9                	idiv   %ecx
  8011eb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f1:	8d 50 01             	lea    0x1(%eax),%edx
  8011f4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011f7:	89 c2                	mov    %eax,%edx
  8011f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fc:	01 d0                	add    %edx,%eax
  8011fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801201:	83 c2 30             	add    $0x30,%edx
  801204:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801206:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801209:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80120e:	f7 e9                	imul   %ecx
  801210:	c1 fa 02             	sar    $0x2,%edx
  801213:	89 c8                	mov    %ecx,%eax
  801215:	c1 f8 1f             	sar    $0x1f,%eax
  801218:	29 c2                	sub    %eax,%edx
  80121a:	89 d0                	mov    %edx,%eax
  80121c:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80121f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801223:	75 bb                	jne    8011e0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801225:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80122c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80122f:	48                   	dec    %eax
  801230:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801233:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801237:	74 3d                	je     801276 <ltostr+0xc3>
		start = 1 ;
  801239:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801240:	eb 34                	jmp    801276 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801242:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801245:	8b 45 0c             	mov    0xc(%ebp),%eax
  801248:	01 d0                	add    %edx,%eax
  80124a:	8a 00                	mov    (%eax),%al
  80124c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80124f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801252:	8b 45 0c             	mov    0xc(%ebp),%eax
  801255:	01 c2                	add    %eax,%edx
  801257:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80125a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125d:	01 c8                	add    %ecx,%eax
  80125f:	8a 00                	mov    (%eax),%al
  801261:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801263:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801266:	8b 45 0c             	mov    0xc(%ebp),%eax
  801269:	01 c2                	add    %eax,%edx
  80126b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80126e:	88 02                	mov    %al,(%edx)
		start++ ;
  801270:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801273:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801279:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80127c:	7c c4                	jl     801242 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80127e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801281:	8b 45 0c             	mov    0xc(%ebp),%eax
  801284:	01 d0                	add    %edx,%eax
  801286:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801289:	90                   	nop
  80128a:	c9                   	leave  
  80128b:	c3                   	ret    

0080128c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80128c:	55                   	push   %ebp
  80128d:	89 e5                	mov    %esp,%ebp
  80128f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801292:	ff 75 08             	pushl  0x8(%ebp)
  801295:	e8 c4 f9 ff ff       	call   800c5e <strlen>
  80129a:	83 c4 04             	add    $0x4,%esp
  80129d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012a0:	ff 75 0c             	pushl  0xc(%ebp)
  8012a3:	e8 b6 f9 ff ff       	call   800c5e <strlen>
  8012a8:	83 c4 04             	add    $0x4,%esp
  8012ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012bc:	eb 17                	jmp    8012d5 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c4:	01 c2                	add    %eax,%edx
  8012c6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cc:	01 c8                	add    %ecx,%eax
  8012ce:	8a 00                	mov    (%eax),%al
  8012d0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012d2:	ff 45 fc             	incl   -0x4(%ebp)
  8012d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012db:	7c e1                	jl     8012be <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012dd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012e4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012eb:	eb 1f                	jmp    80130c <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f0:	8d 50 01             	lea    0x1(%eax),%edx
  8012f3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012f6:	89 c2                	mov    %eax,%edx
  8012f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fb:	01 c2                	add    %eax,%edx
  8012fd:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801300:	8b 45 0c             	mov    0xc(%ebp),%eax
  801303:	01 c8                	add    %ecx,%eax
  801305:	8a 00                	mov    (%eax),%al
  801307:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801309:	ff 45 f8             	incl   -0x8(%ebp)
  80130c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80130f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801312:	7c d9                	jl     8012ed <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801314:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801317:	8b 45 10             	mov    0x10(%ebp),%eax
  80131a:	01 d0                	add    %edx,%eax
  80131c:	c6 00 00             	movb   $0x0,(%eax)
}
  80131f:	90                   	nop
  801320:	c9                   	leave  
  801321:	c3                   	ret    

00801322 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801322:	55                   	push   %ebp
  801323:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801325:	8b 45 14             	mov    0x14(%ebp),%eax
  801328:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80132e:	8b 45 14             	mov    0x14(%ebp),%eax
  801331:	8b 00                	mov    (%eax),%eax
  801333:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80133a:	8b 45 10             	mov    0x10(%ebp),%eax
  80133d:	01 d0                	add    %edx,%eax
  80133f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801345:	eb 0c                	jmp    801353 <strsplit+0x31>
			*string++ = 0;
  801347:	8b 45 08             	mov    0x8(%ebp),%eax
  80134a:	8d 50 01             	lea    0x1(%eax),%edx
  80134d:	89 55 08             	mov    %edx,0x8(%ebp)
  801350:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	8a 00                	mov    (%eax),%al
  801358:	84 c0                	test   %al,%al
  80135a:	74 18                	je     801374 <strsplit+0x52>
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	8a 00                	mov    (%eax),%al
  801361:	0f be c0             	movsbl %al,%eax
  801364:	50                   	push   %eax
  801365:	ff 75 0c             	pushl  0xc(%ebp)
  801368:	e8 83 fa ff ff       	call   800df0 <strchr>
  80136d:	83 c4 08             	add    $0x8,%esp
  801370:	85 c0                	test   %eax,%eax
  801372:	75 d3                	jne    801347 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801374:	8b 45 08             	mov    0x8(%ebp),%eax
  801377:	8a 00                	mov    (%eax),%al
  801379:	84 c0                	test   %al,%al
  80137b:	74 5a                	je     8013d7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80137d:	8b 45 14             	mov    0x14(%ebp),%eax
  801380:	8b 00                	mov    (%eax),%eax
  801382:	83 f8 0f             	cmp    $0xf,%eax
  801385:	75 07                	jne    80138e <strsplit+0x6c>
		{
			return 0;
  801387:	b8 00 00 00 00       	mov    $0x0,%eax
  80138c:	eb 66                	jmp    8013f4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80138e:	8b 45 14             	mov    0x14(%ebp),%eax
  801391:	8b 00                	mov    (%eax),%eax
  801393:	8d 48 01             	lea    0x1(%eax),%ecx
  801396:	8b 55 14             	mov    0x14(%ebp),%edx
  801399:	89 0a                	mov    %ecx,(%edx)
  80139b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a5:	01 c2                	add    %eax,%edx
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013ac:	eb 03                	jmp    8013b1 <strsplit+0x8f>
			string++;
  8013ae:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b4:	8a 00                	mov    (%eax),%al
  8013b6:	84 c0                	test   %al,%al
  8013b8:	74 8b                	je     801345 <strsplit+0x23>
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	0f be c0             	movsbl %al,%eax
  8013c2:	50                   	push   %eax
  8013c3:	ff 75 0c             	pushl  0xc(%ebp)
  8013c6:	e8 25 fa ff ff       	call   800df0 <strchr>
  8013cb:	83 c4 08             	add    $0x8,%esp
  8013ce:	85 c0                	test   %eax,%eax
  8013d0:	74 dc                	je     8013ae <strsplit+0x8c>
			string++;
	}
  8013d2:	e9 6e ff ff ff       	jmp    801345 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013d7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013db:	8b 00                	mov    (%eax),%eax
  8013dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e7:	01 d0                	add    %edx,%eax
  8013e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013ef:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013f4:	c9                   	leave  
  8013f5:	c3                   	ret    

008013f6 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
  8013f9:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8013fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801402:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801409:	eb 4a                	jmp    801455 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80140b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	01 c2                	add    %eax,%edx
  801413:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801416:	8b 45 0c             	mov    0xc(%ebp),%eax
  801419:	01 c8                	add    %ecx,%eax
  80141b:	8a 00                	mov    (%eax),%al
  80141d:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80141f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801422:	8b 45 0c             	mov    0xc(%ebp),%eax
  801425:	01 d0                	add    %edx,%eax
  801427:	8a 00                	mov    (%eax),%al
  801429:	3c 40                	cmp    $0x40,%al
  80142b:	7e 25                	jle    801452 <str2lower+0x5c>
  80142d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801430:	8b 45 0c             	mov    0xc(%ebp),%eax
  801433:	01 d0                	add    %edx,%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	3c 5a                	cmp    $0x5a,%al
  801439:	7f 17                	jg     801452 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80143b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80143e:	8b 45 08             	mov    0x8(%ebp),%eax
  801441:	01 d0                	add    %edx,%eax
  801443:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801446:	8b 55 08             	mov    0x8(%ebp),%edx
  801449:	01 ca                	add    %ecx,%edx
  80144b:	8a 12                	mov    (%edx),%dl
  80144d:	83 c2 20             	add    $0x20,%edx
  801450:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801452:	ff 45 fc             	incl   -0x4(%ebp)
  801455:	ff 75 0c             	pushl  0xc(%ebp)
  801458:	e8 01 f8 ff ff       	call   800c5e <strlen>
  80145d:	83 c4 04             	add    $0x4,%esp
  801460:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801463:	7f a6                	jg     80140b <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801465:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801468:	c9                   	leave  
  801469:	c3                   	ret    

0080146a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80146a:	55                   	push   %ebp
  80146b:	89 e5                	mov    %esp,%ebp
  80146d:	57                   	push   %edi
  80146e:	56                   	push   %esi
  80146f:	53                   	push   %ebx
  801470:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	8b 55 0c             	mov    0xc(%ebp),%edx
  801479:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80147c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80147f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801482:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801485:	cd 30                	int    $0x30
  801487:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80148a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80148d:	83 c4 10             	add    $0x10,%esp
  801490:	5b                   	pop    %ebx
  801491:	5e                   	pop    %esi
  801492:	5f                   	pop    %edi
  801493:	5d                   	pop    %ebp
  801494:	c3                   	ret    

00801495 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
  801498:	83 ec 04             	sub    $0x4,%esp
  80149b:	8b 45 10             	mov    0x10(%ebp),%eax
  80149e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8014a1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014a4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ab:	6a 00                	push   $0x0
  8014ad:	51                   	push   %ecx
  8014ae:	52                   	push   %edx
  8014af:	ff 75 0c             	pushl  0xc(%ebp)
  8014b2:	50                   	push   %eax
  8014b3:	6a 00                	push   $0x0
  8014b5:	e8 b0 ff ff ff       	call   80146a <syscall>
  8014ba:	83 c4 18             	add    $0x18,%esp
}
  8014bd:	90                   	nop
  8014be:	c9                   	leave  
  8014bf:	c3                   	ret    

008014c0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 00                	push   $0x0
  8014cd:	6a 02                	push   $0x2
  8014cf:	e8 96 ff ff ff       	call   80146a <syscall>
  8014d4:	83 c4 18             	add    $0x18,%esp
}
  8014d7:	c9                   	leave  
  8014d8:	c3                   	ret    

008014d9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 03                	push   $0x3
  8014e8:	e8 7d ff ff ff       	call   80146a <syscall>
  8014ed:	83 c4 18             	add    $0x18,%esp
}
  8014f0:	90                   	nop
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    

008014f3 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8014f3:	55                   	push   %ebp
  8014f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 04                	push   $0x4
  801502:	e8 63 ff ff ff       	call   80146a <syscall>
  801507:	83 c4 18             	add    $0x18,%esp
}
  80150a:	90                   	nop
  80150b:	c9                   	leave  
  80150c:	c3                   	ret    

0080150d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801510:	8b 55 0c             	mov    0xc(%ebp),%edx
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	52                   	push   %edx
  80151d:	50                   	push   %eax
  80151e:	6a 08                	push   $0x8
  801520:	e8 45 ff ff ff       	call   80146a <syscall>
  801525:	83 c4 18             	add    $0x18,%esp
}
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
  80152d:	56                   	push   %esi
  80152e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80152f:	8b 75 18             	mov    0x18(%ebp),%esi
  801532:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801535:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801538:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	56                   	push   %esi
  80153f:	53                   	push   %ebx
  801540:	51                   	push   %ecx
  801541:	52                   	push   %edx
  801542:	50                   	push   %eax
  801543:	6a 09                	push   $0x9
  801545:	e8 20 ff ff ff       	call   80146a <syscall>
  80154a:	83 c4 18             	add    $0x18,%esp
}
  80154d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801550:	5b                   	pop    %ebx
  801551:	5e                   	pop    %esi
  801552:	5d                   	pop    %ebp
  801553:	c3                   	ret    

00801554 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	ff 75 08             	pushl  0x8(%ebp)
  801562:	6a 0a                	push   $0xa
  801564:	e8 01 ff ff ff       	call   80146a <syscall>
  801569:	83 c4 18             	add    $0x18,%esp
}
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    

0080156e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	ff 75 0c             	pushl  0xc(%ebp)
  80157a:	ff 75 08             	pushl  0x8(%ebp)
  80157d:	6a 0b                	push   $0xb
  80157f:	e8 e6 fe ff ff       	call   80146a <syscall>
  801584:	83 c4 18             	add    $0x18,%esp
}
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 0c                	push   $0xc
  801598:	e8 cd fe ff ff       	call   80146a <syscall>
  80159d:	83 c4 18             	add    $0x18,%esp
}
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

008015a2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 0d                	push   $0xd
  8015b1:	e8 b4 fe ff ff       	call   80146a <syscall>
  8015b6:	83 c4 18             	add    $0x18,%esp
}
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    

008015bb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 0e                	push   $0xe
  8015ca:	e8 9b fe ff ff       	call   80146a <syscall>
  8015cf:	83 c4 18             	add    $0x18,%esp
}
  8015d2:	c9                   	leave  
  8015d3:	c3                   	ret    

008015d4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 0f                	push   $0xf
  8015e3:	e8 82 fe ff ff       	call   80146a <syscall>
  8015e8:	83 c4 18             	add    $0x18,%esp
}
  8015eb:	c9                   	leave  
  8015ec:	c3                   	ret    

008015ed <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	ff 75 08             	pushl  0x8(%ebp)
  8015fb:	6a 10                	push   $0x10
  8015fd:	e8 68 fe ff ff       	call   80146a <syscall>
  801602:	83 c4 18             	add    $0x18,%esp
}
  801605:	c9                   	leave  
  801606:	c3                   	ret    

00801607 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 11                	push   $0x11
  801616:	e8 4f fe ff ff       	call   80146a <syscall>
  80161b:	83 c4 18             	add    $0x18,%esp
}
  80161e:	90                   	nop
  80161f:	c9                   	leave  
  801620:	c3                   	ret    

00801621 <sys_cputc>:

void
sys_cputc(const char c)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	83 ec 04             	sub    $0x4,%esp
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
  80162a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80162d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	50                   	push   %eax
  80163a:	6a 01                	push   $0x1
  80163c:	e8 29 fe ff ff       	call   80146a <syscall>
  801641:	83 c4 18             	add    $0x18,%esp
}
  801644:	90                   	nop
  801645:	c9                   	leave  
  801646:	c3                   	ret    

00801647 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 14                	push   $0x14
  801656:	e8 0f fe ff ff       	call   80146a <syscall>
  80165b:	83 c4 18             	add    $0x18,%esp
}
  80165e:	90                   	nop
  80165f:	c9                   	leave  
  801660:	c3                   	ret    

00801661 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
  801664:	83 ec 04             	sub    $0x4,%esp
  801667:	8b 45 10             	mov    0x10(%ebp),%eax
  80166a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80166d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801670:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	6a 00                	push   $0x0
  801679:	51                   	push   %ecx
  80167a:	52                   	push   %edx
  80167b:	ff 75 0c             	pushl  0xc(%ebp)
  80167e:	50                   	push   %eax
  80167f:	6a 15                	push   $0x15
  801681:	e8 e4 fd ff ff       	call   80146a <syscall>
  801686:	83 c4 18             	add    $0x18,%esp
}
  801689:	c9                   	leave  
  80168a:	c3                   	ret    

0080168b <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80168e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	52                   	push   %edx
  80169b:	50                   	push   %eax
  80169c:	6a 16                	push   $0x16
  80169e:	e8 c7 fd ff ff       	call   80146a <syscall>
  8016a3:	83 c4 18             	add    $0x18,%esp
}
  8016a6:	c9                   	leave  
  8016a7:	c3                   	ret    

008016a8 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	51                   	push   %ecx
  8016b9:	52                   	push   %edx
  8016ba:	50                   	push   %eax
  8016bb:	6a 17                	push   $0x17
  8016bd:	e8 a8 fd ff ff       	call   80146a <syscall>
  8016c2:	83 c4 18             	add    $0x18,%esp
}
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    

008016c7 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	52                   	push   %edx
  8016d7:	50                   	push   %eax
  8016d8:	6a 18                	push   $0x18
  8016da:	e8 8b fd ff ff       	call   80146a <syscall>
  8016df:	83 c4 18             	add    $0x18,%esp
}
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	6a 00                	push   $0x0
  8016ec:	ff 75 14             	pushl  0x14(%ebp)
  8016ef:	ff 75 10             	pushl  0x10(%ebp)
  8016f2:	ff 75 0c             	pushl  0xc(%ebp)
  8016f5:	50                   	push   %eax
  8016f6:	6a 19                	push   $0x19
  8016f8:	e8 6d fd ff ff       	call   80146a <syscall>
  8016fd:	83 c4 18             	add    $0x18,%esp
}
  801700:	c9                   	leave  
  801701:	c3                   	ret    

00801702 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801705:	8b 45 08             	mov    0x8(%ebp),%eax
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	50                   	push   %eax
  801711:	6a 1a                	push   $0x1a
  801713:	e8 52 fd ff ff       	call   80146a <syscall>
  801718:	83 c4 18             	add    $0x18,%esp
}
  80171b:	90                   	nop
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801721:	8b 45 08             	mov    0x8(%ebp),%eax
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	50                   	push   %eax
  80172d:	6a 1b                	push   $0x1b
  80172f:	e8 36 fd ff ff       	call   80146a <syscall>
  801734:	83 c4 18             	add    $0x18,%esp
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 05                	push   $0x5
  801748:	e8 1d fd ff ff       	call   80146a <syscall>
  80174d:	83 c4 18             	add    $0x18,%esp
}
  801750:	c9                   	leave  
  801751:	c3                   	ret    

00801752 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 06                	push   $0x6
  801761:	e8 04 fd ff ff       	call   80146a <syscall>
  801766:	83 c4 18             	add    $0x18,%esp
}
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 07                	push   $0x7
  80177a:	e8 eb fc ff ff       	call   80146a <syscall>
  80177f:	83 c4 18             	add    $0x18,%esp
}
  801782:	c9                   	leave  
  801783:	c3                   	ret    

00801784 <sys_exit_env>:


void sys_exit_env(void)
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 1c                	push   $0x1c
  801793:	e8 d2 fc ff ff       	call   80146a <syscall>
  801798:	83 c4 18             	add    $0x18,%esp
}
  80179b:	90                   	nop
  80179c:	c9                   	leave  
  80179d:	c3                   	ret    

0080179e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
  8017a1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017a4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017a7:	8d 50 04             	lea    0x4(%eax),%edx
  8017aa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	52                   	push   %edx
  8017b4:	50                   	push   %eax
  8017b5:	6a 1d                	push   $0x1d
  8017b7:	e8 ae fc ff ff       	call   80146a <syscall>
  8017bc:	83 c4 18             	add    $0x18,%esp
	return result;
  8017bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017c8:	89 01                	mov    %eax,(%ecx)
  8017ca:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	c9                   	leave  
  8017d1:	c2 04 00             	ret    $0x4

008017d4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	ff 75 10             	pushl  0x10(%ebp)
  8017de:	ff 75 0c             	pushl  0xc(%ebp)
  8017e1:	ff 75 08             	pushl  0x8(%ebp)
  8017e4:	6a 13                	push   $0x13
  8017e6:	e8 7f fc ff ff       	call   80146a <syscall>
  8017eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8017ee:	90                   	nop
}
  8017ef:	c9                   	leave  
  8017f0:	c3                   	ret    

008017f1 <sys_rcr2>:
uint32 sys_rcr2()
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 1e                	push   $0x1e
  801800:	e8 65 fc ff ff       	call   80146a <syscall>
  801805:	83 c4 18             	add    $0x18,%esp
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 04             	sub    $0x4,%esp
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801816:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	50                   	push   %eax
  801823:	6a 1f                	push   $0x1f
  801825:	e8 40 fc ff ff       	call   80146a <syscall>
  80182a:	83 c4 18             	add    $0x18,%esp
	return ;
  80182d:	90                   	nop
}
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <rsttst>:
void rsttst()
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 21                	push   $0x21
  80183f:	e8 26 fc ff ff       	call   80146a <syscall>
  801844:	83 c4 18             	add    $0x18,%esp
	return ;
  801847:	90                   	nop
}
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
  80184d:	83 ec 04             	sub    $0x4,%esp
  801850:	8b 45 14             	mov    0x14(%ebp),%eax
  801853:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801856:	8b 55 18             	mov    0x18(%ebp),%edx
  801859:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80185d:	52                   	push   %edx
  80185e:	50                   	push   %eax
  80185f:	ff 75 10             	pushl  0x10(%ebp)
  801862:	ff 75 0c             	pushl  0xc(%ebp)
  801865:	ff 75 08             	pushl  0x8(%ebp)
  801868:	6a 20                	push   $0x20
  80186a:	e8 fb fb ff ff       	call   80146a <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
	return ;
  801872:	90                   	nop
}
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <chktst>:
void chktst(uint32 n)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	ff 75 08             	pushl  0x8(%ebp)
  801883:	6a 22                	push   $0x22
  801885:	e8 e0 fb ff ff       	call   80146a <syscall>
  80188a:	83 c4 18             	add    $0x18,%esp
	return ;
  80188d:	90                   	nop
}
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <inctst>:

void inctst()
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 23                	push   $0x23
  80189f:	e8 c6 fb ff ff       	call   80146a <syscall>
  8018a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a7:	90                   	nop
}
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <gettst>:
uint32 gettst()
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 24                	push   $0x24
  8018b9:	e8 ac fb ff ff       	call   80146a <syscall>
  8018be:	83 c4 18             	add    $0x18,%esp
}
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 25                	push   $0x25
  8018d2:	e8 93 fb ff ff       	call   80146a <syscall>
  8018d7:	83 c4 18             	add    $0x18,%esp
  8018da:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8018df:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	ff 75 08             	pushl  0x8(%ebp)
  8018fc:	6a 26                	push   $0x26
  8018fe:	e8 67 fb ff ff       	call   80146a <syscall>
  801903:	83 c4 18             	add    $0x18,%esp
	return ;
  801906:	90                   	nop
}
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
  80190c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80190d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801910:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801913:	8b 55 0c             	mov    0xc(%ebp),%edx
  801916:	8b 45 08             	mov    0x8(%ebp),%eax
  801919:	6a 00                	push   $0x0
  80191b:	53                   	push   %ebx
  80191c:	51                   	push   %ecx
  80191d:	52                   	push   %edx
  80191e:	50                   	push   %eax
  80191f:	6a 27                	push   $0x27
  801921:	e8 44 fb ff ff       	call   80146a <syscall>
  801926:	83 c4 18             	add    $0x18,%esp
}
  801929:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801931:	8b 55 0c             	mov    0xc(%ebp),%edx
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	52                   	push   %edx
  80193e:	50                   	push   %eax
  80193f:	6a 28                	push   $0x28
  801941:	e8 24 fb ff ff       	call   80146a <syscall>
  801946:	83 c4 18             	add    $0x18,%esp
}
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80194e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801951:	8b 55 0c             	mov    0xc(%ebp),%edx
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	6a 00                	push   $0x0
  801959:	51                   	push   %ecx
  80195a:	ff 75 10             	pushl  0x10(%ebp)
  80195d:	52                   	push   %edx
  80195e:	50                   	push   %eax
  80195f:	6a 29                	push   $0x29
  801961:	e8 04 fb ff ff       	call   80146a <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	ff 75 10             	pushl  0x10(%ebp)
  801975:	ff 75 0c             	pushl  0xc(%ebp)
  801978:	ff 75 08             	pushl  0x8(%ebp)
  80197b:	6a 12                	push   $0x12
  80197d:	e8 e8 fa ff ff       	call   80146a <syscall>
  801982:	83 c4 18             	add    $0x18,%esp
	return ;
  801985:	90                   	nop
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80198b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198e:	8b 45 08             	mov    0x8(%ebp),%eax
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	52                   	push   %edx
  801998:	50                   	push   %eax
  801999:	6a 2a                	push   $0x2a
  80199b:	e8 ca fa ff ff       	call   80146a <syscall>
  8019a0:	83 c4 18             	add    $0x18,%esp
	return;
  8019a3:	90                   	nop
}
  8019a4:	c9                   	leave  
  8019a5:	c3                   	ret    

008019a6 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 2b                	push   $0x2b
  8019b5:	e8 b0 fa ff ff       	call   80146a <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
}
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	ff 75 0c             	pushl  0xc(%ebp)
  8019cb:	ff 75 08             	pushl  0x8(%ebp)
  8019ce:	6a 2d                	push   $0x2d
  8019d0:	e8 95 fa ff ff       	call   80146a <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
	return;
  8019d8:	90                   	nop
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	ff 75 0c             	pushl  0xc(%ebp)
  8019e7:	ff 75 08             	pushl  0x8(%ebp)
  8019ea:	6a 2c                	push   $0x2c
  8019ec:	e8 79 fa ff ff       	call   80146a <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f4:	90                   	nop
}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
  8019fa:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8019fd:	83 ec 04             	sub    $0x4,%esp
  801a00:	68 1c 24 80 00       	push   $0x80241c
  801a05:	68 25 01 00 00       	push   $0x125
  801a0a:	68 4f 24 80 00       	push   $0x80244f
  801a0f:	e8 3c 00 00 00       	call   801a50 <_panic>

00801a14 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1d:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801a20:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801a24:	83 ec 0c             	sub    $0xc,%esp
  801a27:	50                   	push   %eax
  801a28:	e8 f4 fb ff ff       	call   801621 <sys_cputc>
  801a2d:	83 c4 10             	add    $0x10,%esp
}
  801a30:	90                   	nop
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <getchar>:


int
getchar(void)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
  801a36:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801a39:	e8 82 fa ff ff       	call   8014c0 <sys_cgetc>
  801a3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <iscons>:

int iscons(int fdnum)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801a49:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a4e:	5d                   	pop    %ebp
  801a4f:	c3                   	ret    

00801a50 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801a56:	8d 45 10             	lea    0x10(%ebp),%eax
  801a59:	83 c0 04             	add    $0x4,%eax
  801a5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801a5f:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801a64:	85 c0                	test   %eax,%eax
  801a66:	74 16                	je     801a7e <_panic+0x2e>
		cprintf("%s: ", argv0);
  801a68:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801a6d:	83 ec 08             	sub    $0x8,%esp
  801a70:	50                   	push   %eax
  801a71:	68 60 24 80 00       	push   $0x802460
  801a76:	e8 02 e9 ff ff       	call   80037d <cprintf>
  801a7b:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801a7e:	a1 04 30 80 00       	mov    0x803004,%eax
  801a83:	83 ec 0c             	sub    $0xc,%esp
  801a86:	ff 75 0c             	pushl  0xc(%ebp)
  801a89:	ff 75 08             	pushl  0x8(%ebp)
  801a8c:	50                   	push   %eax
  801a8d:	68 68 24 80 00       	push   $0x802468
  801a92:	6a 74                	push   $0x74
  801a94:	e8 11 e9 ff ff       	call   8003aa <cprintf_colored>
  801a99:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801a9c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9f:	83 ec 08             	sub    $0x8,%esp
  801aa2:	ff 75 f4             	pushl  -0xc(%ebp)
  801aa5:	50                   	push   %eax
  801aa6:	e8 63 e8 ff ff       	call   80030e <vcprintf>
  801aab:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801aae:	83 ec 08             	sub    $0x8,%esp
  801ab1:	6a 00                	push   $0x0
  801ab3:	68 90 24 80 00       	push   $0x802490
  801ab8:	e8 51 e8 ff ff       	call   80030e <vcprintf>
  801abd:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801ac0:	e8 ca e7 ff ff       	call   80028f <exit>

	// should not return here
	while (1) ;
  801ac5:	eb fe                	jmp    801ac5 <_panic+0x75>

00801ac7 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
  801aca:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801acd:	a1 20 30 80 00       	mov    0x803020,%eax
  801ad2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801adb:	39 c2                	cmp    %eax,%edx
  801add:	74 14                	je     801af3 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801adf:	83 ec 04             	sub    $0x4,%esp
  801ae2:	68 94 24 80 00       	push   $0x802494
  801ae7:	6a 26                	push   $0x26
  801ae9:	68 e0 24 80 00       	push   $0x8024e0
  801aee:	e8 5d ff ff ff       	call   801a50 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801af3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801afa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801b01:	e9 c5 00 00 00       	jmp    801bcb <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b09:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	01 d0                	add    %edx,%eax
  801b15:	8b 00                	mov    (%eax),%eax
  801b17:	85 c0                	test   %eax,%eax
  801b19:	75 08                	jne    801b23 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801b1b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801b1e:	e9 a5 00 00 00       	jmp    801bc8 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801b23:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b2a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801b31:	eb 69                	jmp    801b9c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801b33:	a1 20 30 80 00       	mov    0x803020,%eax
  801b38:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801b3e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b41:	89 d0                	mov    %edx,%eax
  801b43:	01 c0                	add    %eax,%eax
  801b45:	01 d0                	add    %edx,%eax
  801b47:	c1 e0 03             	shl    $0x3,%eax
  801b4a:	01 c8                	add    %ecx,%eax
  801b4c:	8a 40 04             	mov    0x4(%eax),%al
  801b4f:	84 c0                	test   %al,%al
  801b51:	75 46                	jne    801b99 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801b53:	a1 20 30 80 00       	mov    0x803020,%eax
  801b58:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801b5e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b61:	89 d0                	mov    %edx,%eax
  801b63:	01 c0                	add    %eax,%eax
  801b65:	01 d0                	add    %edx,%eax
  801b67:	c1 e0 03             	shl    $0x3,%eax
  801b6a:	01 c8                	add    %ecx,%eax
  801b6c:	8b 00                	mov    (%eax),%eax
  801b6e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b71:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b74:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b79:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b7e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801b85:	8b 45 08             	mov    0x8(%ebp),%eax
  801b88:	01 c8                	add    %ecx,%eax
  801b8a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801b8c:	39 c2                	cmp    %eax,%edx
  801b8e:	75 09                	jne    801b99 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801b90:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801b97:	eb 15                	jmp    801bae <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b99:	ff 45 e8             	incl   -0x18(%ebp)
  801b9c:	a1 20 30 80 00       	mov    0x803020,%eax
  801ba1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801ba7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801baa:	39 c2                	cmp    %eax,%edx
  801bac:	77 85                	ja     801b33 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801bae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bb2:	75 14                	jne    801bc8 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801bb4:	83 ec 04             	sub    $0x4,%esp
  801bb7:	68 ec 24 80 00       	push   $0x8024ec
  801bbc:	6a 3a                	push   $0x3a
  801bbe:	68 e0 24 80 00       	push   $0x8024e0
  801bc3:	e8 88 fe ff ff       	call   801a50 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801bc8:	ff 45 f0             	incl   -0x10(%ebp)
  801bcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bce:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801bd1:	0f 8c 2f ff ff ff    	jl     801b06 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801bd7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801bde:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801be5:	eb 26                	jmp    801c0d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801be7:	a1 20 30 80 00       	mov    0x803020,%eax
  801bec:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801bf2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bf5:	89 d0                	mov    %edx,%eax
  801bf7:	01 c0                	add    %eax,%eax
  801bf9:	01 d0                	add    %edx,%eax
  801bfb:	c1 e0 03             	shl    $0x3,%eax
  801bfe:	01 c8                	add    %ecx,%eax
  801c00:	8a 40 04             	mov    0x4(%eax),%al
  801c03:	3c 01                	cmp    $0x1,%al
  801c05:	75 03                	jne    801c0a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801c07:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c0a:	ff 45 e0             	incl   -0x20(%ebp)
  801c0d:	a1 20 30 80 00       	mov    0x803020,%eax
  801c12:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801c18:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c1b:	39 c2                	cmp    %eax,%edx
  801c1d:	77 c8                	ja     801be7 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c22:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801c25:	74 14                	je     801c3b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801c27:	83 ec 04             	sub    $0x4,%esp
  801c2a:	68 40 25 80 00       	push   $0x802540
  801c2f:	6a 44                	push   $0x44
  801c31:	68 e0 24 80 00       	push   $0x8024e0
  801c36:	e8 15 fe ff ff       	call   801a50 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801c3b:	90                   	nop
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    
  801c3e:	66 90                	xchg   %ax,%ax

00801c40 <__udivdi3>:
  801c40:	55                   	push   %ebp
  801c41:	57                   	push   %edi
  801c42:	56                   	push   %esi
  801c43:	53                   	push   %ebx
  801c44:	83 ec 1c             	sub    $0x1c,%esp
  801c47:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c4b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c4f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c53:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c57:	89 ca                	mov    %ecx,%edx
  801c59:	89 f8                	mov    %edi,%eax
  801c5b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c5f:	85 f6                	test   %esi,%esi
  801c61:	75 2d                	jne    801c90 <__udivdi3+0x50>
  801c63:	39 cf                	cmp    %ecx,%edi
  801c65:	77 65                	ja     801ccc <__udivdi3+0x8c>
  801c67:	89 fd                	mov    %edi,%ebp
  801c69:	85 ff                	test   %edi,%edi
  801c6b:	75 0b                	jne    801c78 <__udivdi3+0x38>
  801c6d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c72:	31 d2                	xor    %edx,%edx
  801c74:	f7 f7                	div    %edi
  801c76:	89 c5                	mov    %eax,%ebp
  801c78:	31 d2                	xor    %edx,%edx
  801c7a:	89 c8                	mov    %ecx,%eax
  801c7c:	f7 f5                	div    %ebp
  801c7e:	89 c1                	mov    %eax,%ecx
  801c80:	89 d8                	mov    %ebx,%eax
  801c82:	f7 f5                	div    %ebp
  801c84:	89 cf                	mov    %ecx,%edi
  801c86:	89 fa                	mov    %edi,%edx
  801c88:	83 c4 1c             	add    $0x1c,%esp
  801c8b:	5b                   	pop    %ebx
  801c8c:	5e                   	pop    %esi
  801c8d:	5f                   	pop    %edi
  801c8e:	5d                   	pop    %ebp
  801c8f:	c3                   	ret    
  801c90:	39 ce                	cmp    %ecx,%esi
  801c92:	77 28                	ja     801cbc <__udivdi3+0x7c>
  801c94:	0f bd fe             	bsr    %esi,%edi
  801c97:	83 f7 1f             	xor    $0x1f,%edi
  801c9a:	75 40                	jne    801cdc <__udivdi3+0x9c>
  801c9c:	39 ce                	cmp    %ecx,%esi
  801c9e:	72 0a                	jb     801caa <__udivdi3+0x6a>
  801ca0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ca4:	0f 87 9e 00 00 00    	ja     801d48 <__udivdi3+0x108>
  801caa:	b8 01 00 00 00       	mov    $0x1,%eax
  801caf:	89 fa                	mov    %edi,%edx
  801cb1:	83 c4 1c             	add    $0x1c,%esp
  801cb4:	5b                   	pop    %ebx
  801cb5:	5e                   	pop    %esi
  801cb6:	5f                   	pop    %edi
  801cb7:	5d                   	pop    %ebp
  801cb8:	c3                   	ret    
  801cb9:	8d 76 00             	lea    0x0(%esi),%esi
  801cbc:	31 ff                	xor    %edi,%edi
  801cbe:	31 c0                	xor    %eax,%eax
  801cc0:	89 fa                	mov    %edi,%edx
  801cc2:	83 c4 1c             	add    $0x1c,%esp
  801cc5:	5b                   	pop    %ebx
  801cc6:	5e                   	pop    %esi
  801cc7:	5f                   	pop    %edi
  801cc8:	5d                   	pop    %ebp
  801cc9:	c3                   	ret    
  801cca:	66 90                	xchg   %ax,%ax
  801ccc:	89 d8                	mov    %ebx,%eax
  801cce:	f7 f7                	div    %edi
  801cd0:	31 ff                	xor    %edi,%edi
  801cd2:	89 fa                	mov    %edi,%edx
  801cd4:	83 c4 1c             	add    $0x1c,%esp
  801cd7:	5b                   	pop    %ebx
  801cd8:	5e                   	pop    %esi
  801cd9:	5f                   	pop    %edi
  801cda:	5d                   	pop    %ebp
  801cdb:	c3                   	ret    
  801cdc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ce1:	89 eb                	mov    %ebp,%ebx
  801ce3:	29 fb                	sub    %edi,%ebx
  801ce5:	89 f9                	mov    %edi,%ecx
  801ce7:	d3 e6                	shl    %cl,%esi
  801ce9:	89 c5                	mov    %eax,%ebp
  801ceb:	88 d9                	mov    %bl,%cl
  801ced:	d3 ed                	shr    %cl,%ebp
  801cef:	89 e9                	mov    %ebp,%ecx
  801cf1:	09 f1                	or     %esi,%ecx
  801cf3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801cf7:	89 f9                	mov    %edi,%ecx
  801cf9:	d3 e0                	shl    %cl,%eax
  801cfb:	89 c5                	mov    %eax,%ebp
  801cfd:	89 d6                	mov    %edx,%esi
  801cff:	88 d9                	mov    %bl,%cl
  801d01:	d3 ee                	shr    %cl,%esi
  801d03:	89 f9                	mov    %edi,%ecx
  801d05:	d3 e2                	shl    %cl,%edx
  801d07:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d0b:	88 d9                	mov    %bl,%cl
  801d0d:	d3 e8                	shr    %cl,%eax
  801d0f:	09 c2                	or     %eax,%edx
  801d11:	89 d0                	mov    %edx,%eax
  801d13:	89 f2                	mov    %esi,%edx
  801d15:	f7 74 24 0c          	divl   0xc(%esp)
  801d19:	89 d6                	mov    %edx,%esi
  801d1b:	89 c3                	mov    %eax,%ebx
  801d1d:	f7 e5                	mul    %ebp
  801d1f:	39 d6                	cmp    %edx,%esi
  801d21:	72 19                	jb     801d3c <__udivdi3+0xfc>
  801d23:	74 0b                	je     801d30 <__udivdi3+0xf0>
  801d25:	89 d8                	mov    %ebx,%eax
  801d27:	31 ff                	xor    %edi,%edi
  801d29:	e9 58 ff ff ff       	jmp    801c86 <__udivdi3+0x46>
  801d2e:	66 90                	xchg   %ax,%ax
  801d30:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d34:	89 f9                	mov    %edi,%ecx
  801d36:	d3 e2                	shl    %cl,%edx
  801d38:	39 c2                	cmp    %eax,%edx
  801d3a:	73 e9                	jae    801d25 <__udivdi3+0xe5>
  801d3c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d3f:	31 ff                	xor    %edi,%edi
  801d41:	e9 40 ff ff ff       	jmp    801c86 <__udivdi3+0x46>
  801d46:	66 90                	xchg   %ax,%ax
  801d48:	31 c0                	xor    %eax,%eax
  801d4a:	e9 37 ff ff ff       	jmp    801c86 <__udivdi3+0x46>
  801d4f:	90                   	nop

00801d50 <__umoddi3>:
  801d50:	55                   	push   %ebp
  801d51:	57                   	push   %edi
  801d52:	56                   	push   %esi
  801d53:	53                   	push   %ebx
  801d54:	83 ec 1c             	sub    $0x1c,%esp
  801d57:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d5b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d63:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d6b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d6f:	89 f3                	mov    %esi,%ebx
  801d71:	89 fa                	mov    %edi,%edx
  801d73:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d77:	89 34 24             	mov    %esi,(%esp)
  801d7a:	85 c0                	test   %eax,%eax
  801d7c:	75 1a                	jne    801d98 <__umoddi3+0x48>
  801d7e:	39 f7                	cmp    %esi,%edi
  801d80:	0f 86 a2 00 00 00    	jbe    801e28 <__umoddi3+0xd8>
  801d86:	89 c8                	mov    %ecx,%eax
  801d88:	89 f2                	mov    %esi,%edx
  801d8a:	f7 f7                	div    %edi
  801d8c:	89 d0                	mov    %edx,%eax
  801d8e:	31 d2                	xor    %edx,%edx
  801d90:	83 c4 1c             	add    $0x1c,%esp
  801d93:	5b                   	pop    %ebx
  801d94:	5e                   	pop    %esi
  801d95:	5f                   	pop    %edi
  801d96:	5d                   	pop    %ebp
  801d97:	c3                   	ret    
  801d98:	39 f0                	cmp    %esi,%eax
  801d9a:	0f 87 ac 00 00 00    	ja     801e4c <__umoddi3+0xfc>
  801da0:	0f bd e8             	bsr    %eax,%ebp
  801da3:	83 f5 1f             	xor    $0x1f,%ebp
  801da6:	0f 84 ac 00 00 00    	je     801e58 <__umoddi3+0x108>
  801dac:	bf 20 00 00 00       	mov    $0x20,%edi
  801db1:	29 ef                	sub    %ebp,%edi
  801db3:	89 fe                	mov    %edi,%esi
  801db5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801db9:	89 e9                	mov    %ebp,%ecx
  801dbb:	d3 e0                	shl    %cl,%eax
  801dbd:	89 d7                	mov    %edx,%edi
  801dbf:	89 f1                	mov    %esi,%ecx
  801dc1:	d3 ef                	shr    %cl,%edi
  801dc3:	09 c7                	or     %eax,%edi
  801dc5:	89 e9                	mov    %ebp,%ecx
  801dc7:	d3 e2                	shl    %cl,%edx
  801dc9:	89 14 24             	mov    %edx,(%esp)
  801dcc:	89 d8                	mov    %ebx,%eax
  801dce:	d3 e0                	shl    %cl,%eax
  801dd0:	89 c2                	mov    %eax,%edx
  801dd2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dd6:	d3 e0                	shl    %cl,%eax
  801dd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ddc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801de0:	89 f1                	mov    %esi,%ecx
  801de2:	d3 e8                	shr    %cl,%eax
  801de4:	09 d0                	or     %edx,%eax
  801de6:	d3 eb                	shr    %cl,%ebx
  801de8:	89 da                	mov    %ebx,%edx
  801dea:	f7 f7                	div    %edi
  801dec:	89 d3                	mov    %edx,%ebx
  801dee:	f7 24 24             	mull   (%esp)
  801df1:	89 c6                	mov    %eax,%esi
  801df3:	89 d1                	mov    %edx,%ecx
  801df5:	39 d3                	cmp    %edx,%ebx
  801df7:	0f 82 87 00 00 00    	jb     801e84 <__umoddi3+0x134>
  801dfd:	0f 84 91 00 00 00    	je     801e94 <__umoddi3+0x144>
  801e03:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e07:	29 f2                	sub    %esi,%edx
  801e09:	19 cb                	sbb    %ecx,%ebx
  801e0b:	89 d8                	mov    %ebx,%eax
  801e0d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e11:	d3 e0                	shl    %cl,%eax
  801e13:	89 e9                	mov    %ebp,%ecx
  801e15:	d3 ea                	shr    %cl,%edx
  801e17:	09 d0                	or     %edx,%eax
  801e19:	89 e9                	mov    %ebp,%ecx
  801e1b:	d3 eb                	shr    %cl,%ebx
  801e1d:	89 da                	mov    %ebx,%edx
  801e1f:	83 c4 1c             	add    $0x1c,%esp
  801e22:	5b                   	pop    %ebx
  801e23:	5e                   	pop    %esi
  801e24:	5f                   	pop    %edi
  801e25:	5d                   	pop    %ebp
  801e26:	c3                   	ret    
  801e27:	90                   	nop
  801e28:	89 fd                	mov    %edi,%ebp
  801e2a:	85 ff                	test   %edi,%edi
  801e2c:	75 0b                	jne    801e39 <__umoddi3+0xe9>
  801e2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e33:	31 d2                	xor    %edx,%edx
  801e35:	f7 f7                	div    %edi
  801e37:	89 c5                	mov    %eax,%ebp
  801e39:	89 f0                	mov    %esi,%eax
  801e3b:	31 d2                	xor    %edx,%edx
  801e3d:	f7 f5                	div    %ebp
  801e3f:	89 c8                	mov    %ecx,%eax
  801e41:	f7 f5                	div    %ebp
  801e43:	89 d0                	mov    %edx,%eax
  801e45:	e9 44 ff ff ff       	jmp    801d8e <__umoddi3+0x3e>
  801e4a:	66 90                	xchg   %ax,%ax
  801e4c:	89 c8                	mov    %ecx,%eax
  801e4e:	89 f2                	mov    %esi,%edx
  801e50:	83 c4 1c             	add    $0x1c,%esp
  801e53:	5b                   	pop    %ebx
  801e54:	5e                   	pop    %esi
  801e55:	5f                   	pop    %edi
  801e56:	5d                   	pop    %ebp
  801e57:	c3                   	ret    
  801e58:	3b 04 24             	cmp    (%esp),%eax
  801e5b:	72 06                	jb     801e63 <__umoddi3+0x113>
  801e5d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e61:	77 0f                	ja     801e72 <__umoddi3+0x122>
  801e63:	89 f2                	mov    %esi,%edx
  801e65:	29 f9                	sub    %edi,%ecx
  801e67:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e6b:	89 14 24             	mov    %edx,(%esp)
  801e6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e72:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e76:	8b 14 24             	mov    (%esp),%edx
  801e79:	83 c4 1c             	add    $0x1c,%esp
  801e7c:	5b                   	pop    %ebx
  801e7d:	5e                   	pop    %esi
  801e7e:	5f                   	pop    %edi
  801e7f:	5d                   	pop    %ebp
  801e80:	c3                   	ret    
  801e81:	8d 76 00             	lea    0x0(%esi),%esi
  801e84:	2b 04 24             	sub    (%esp),%eax
  801e87:	19 fa                	sbb    %edi,%edx
  801e89:	89 d1                	mov    %edx,%ecx
  801e8b:	89 c6                	mov    %eax,%esi
  801e8d:	e9 71 ff ff ff       	jmp    801e03 <__umoddi3+0xb3>
  801e92:	66 90                	xchg   %ax,%ax
  801e94:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e98:	72 ea                	jb     801e84 <__umoddi3+0x134>
  801e9a:	89 d9                	mov    %ebx,%ecx
  801e9c:	e9 62 ff ff ff       	jmp    801e03 <__umoddi3+0xb3>


obj/user/game:     file format elf32-i386


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
  800031:	e8 98 00 00 00       	call   8000ce <libmain>
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
	int i=28;
  80003e:	c7 45 f4 1c 00 00 00 	movl   $0x1c,-0xc(%ebp)
	int txtClr = TEXT_black;
  800045:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for(;i<128; i++)
  80004c:	eb 77                	jmp    8000c5 <_main+0x8d>
	{
		txtClr = (txtClr + 1) % 16;
  80004e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800051:	40                   	inc    %eax
  800052:	25 0f 00 00 80       	and    $0x8000000f,%eax
  800057:	85 c0                	test   %eax,%eax
  800059:	79 05                	jns    800060 <_main+0x28>
  80005b:	48                   	dec    %eax
  80005c:	83 c8 f0             	or     $0xfffffff0,%eax
  80005f:	40                   	inc    %eax
  800060:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int c=0;
  800063:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;c<10; c++)
  80006a:	eb 19                	jmp    800085 <_main+0x4d>
		{
			cprintf_colored(txtClr, "%~%c",i);
  80006c:	83 ec 04             	sub    $0x4,%esp
  80006f:	ff 75 f4             	pushl  -0xc(%ebp)
  800072:	68 40 1c 80 00       	push   $0x801c40
  800077:	ff 75 f0             	pushl  -0x10(%ebp)
  80007a:	e8 0c 03 00 00       	call   80038b <cprintf_colored>
  80007f:	83 c4 10             	add    $0x10,%esp
	int txtClr = TEXT_black;
	for(;i<128; i++)
	{
		txtClr = (txtClr + 1) % 16;
		int c=0;
		for(;c<10; c++)
  800082:	ff 45 ec             	incl   -0x14(%ebp)
  800085:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
  800089:	7e e1                	jle    80006c <_main+0x34>
		{
			cprintf_colored(txtClr, "%~%c",i);
		}
		int d=0;
  80008b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for(; d< 5000000; d++);
  800092:	eb 03                	jmp    800097 <_main+0x5f>
  800094:	ff 45 e8             	incl   -0x18(%ebp)
  800097:	81 7d e8 3f 4b 4c 00 	cmpl   $0x4c4b3f,-0x18(%ebp)
  80009e:	7e f4                	jle    800094 <_main+0x5c>
		c=0;
  8000a0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;c<10; c++)
  8000a7:	eb 13                	jmp    8000bc <_main+0x84>
		{
			cprintf("%~\b");
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	68 45 1c 80 00       	push   $0x801c45
  8000b1:	e8 a8 02 00 00       	call   80035e <cprintf>
  8000b6:	83 c4 10             	add    $0x10,%esp
			cprintf_colored(txtClr, "%~%c",i);
		}
		int d=0;
		for(; d< 5000000; d++);
		c=0;
		for(;c<10; c++)
  8000b9:	ff 45 ec             	incl   -0x14(%ebp)
  8000bc:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
  8000c0:	7e e7                	jle    8000a9 <_main+0x71>
void
_main(void)
{
	int i=28;
	int txtClr = TEXT_black;
	for(;i<128; i++)
  8000c2:	ff 45 f4             	incl   -0xc(%ebp)
  8000c5:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
  8000c9:	7e 83                	jle    80004e <_main+0x16>
		{
			cprintf("%~\b");
		}
	}

	return;
  8000cb:	90                   	nop
}
  8000cc:	c9                   	leave  
  8000cd:	c3                   	ret    

008000ce <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000ce:	55                   	push   %ebp
  8000cf:	89 e5                	mov    %esp,%ebp
  8000d1:	57                   	push   %edi
  8000d2:	56                   	push   %esi
  8000d3:	53                   	push   %ebx
  8000d4:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000d7:	e8 4f 14 00 00       	call   80152b <sys_getenvindex>
  8000dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000e2:	89 d0                	mov    %edx,%eax
  8000e4:	c1 e0 02             	shl    $0x2,%eax
  8000e7:	01 d0                	add    %edx,%eax
  8000e9:	c1 e0 03             	shl    $0x3,%eax
  8000ec:	01 d0                	add    %edx,%eax
  8000ee:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8000f5:	01 d0                	add    %edx,%eax
  8000f7:	c1 e0 02             	shl    $0x2,%eax
  8000fa:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000ff:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800104:	a1 20 30 80 00       	mov    0x803020,%eax
  800109:	8a 40 20             	mov    0x20(%eax),%al
  80010c:	84 c0                	test   %al,%al
  80010e:	74 0d                	je     80011d <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800110:	a1 20 30 80 00       	mov    0x803020,%eax
  800115:	83 c0 20             	add    $0x20,%eax
  800118:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80011d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800121:	7e 0a                	jle    80012d <libmain+0x5f>
		binaryname = argv[0];
  800123:	8b 45 0c             	mov    0xc(%ebp),%eax
  800126:	8b 00                	mov    (%eax),%eax
  800128:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80012d:	83 ec 08             	sub    $0x8,%esp
  800130:	ff 75 0c             	pushl  0xc(%ebp)
  800133:	ff 75 08             	pushl  0x8(%ebp)
  800136:	e8 fd fe ff ff       	call   800038 <_main>
  80013b:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80013e:	a1 00 30 80 00       	mov    0x803000,%eax
  800143:	85 c0                	test   %eax,%eax
  800145:	0f 84 01 01 00 00    	je     80024c <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80014b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800151:	bb 44 1d 80 00       	mov    $0x801d44,%ebx
  800156:	ba 0e 00 00 00       	mov    $0xe,%edx
  80015b:	89 c7                	mov    %eax,%edi
  80015d:	89 de                	mov    %ebx,%esi
  80015f:	89 d1                	mov    %edx,%ecx
  800161:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800163:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800166:	b9 56 00 00 00       	mov    $0x56,%ecx
  80016b:	b0 00                	mov    $0x0,%al
  80016d:	89 d7                	mov    %edx,%edi
  80016f:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800171:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800178:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80017b:	83 ec 08             	sub    $0x8,%esp
  80017e:	50                   	push   %eax
  80017f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800185:	50                   	push   %eax
  800186:	e8 d6 15 00 00       	call   801761 <sys_utilities>
  80018b:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80018e:	e8 1f 11 00 00       	call   8012b2 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800193:	83 ec 0c             	sub    $0xc,%esp
  800196:	68 64 1c 80 00       	push   $0x801c64
  80019b:	e8 be 01 00 00       	call   80035e <cprintf>
  8001a0:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a6:	85 c0                	test   %eax,%eax
  8001a8:	74 18                	je     8001c2 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001aa:	e8 d0 15 00 00       	call   80177f <sys_get_optimal_num_faults>
  8001af:	83 ec 08             	sub    $0x8,%esp
  8001b2:	50                   	push   %eax
  8001b3:	68 8c 1c 80 00       	push   $0x801c8c
  8001b8:	e8 a1 01 00 00       	call   80035e <cprintf>
  8001bd:	83 c4 10             	add    $0x10,%esp
  8001c0:	eb 59                	jmp    80021b <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c2:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c7:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8001cd:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d2:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	52                   	push   %edx
  8001dc:	50                   	push   %eax
  8001dd:	68 b0 1c 80 00       	push   $0x801cb0
  8001e2:	e8 77 01 00 00       	call   80035e <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ef:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8001f5:	a1 20 30 80 00       	mov    0x803020,%eax
  8001fa:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800200:	a1 20 30 80 00       	mov    0x803020,%eax
  800205:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80020b:	51                   	push   %ecx
  80020c:	52                   	push   %edx
  80020d:	50                   	push   %eax
  80020e:	68 d8 1c 80 00       	push   $0x801cd8
  800213:	e8 46 01 00 00       	call   80035e <cprintf>
  800218:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80021b:	a1 20 30 80 00       	mov    0x803020,%eax
  800220:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800226:	83 ec 08             	sub    $0x8,%esp
  800229:	50                   	push   %eax
  80022a:	68 30 1d 80 00       	push   $0x801d30
  80022f:	e8 2a 01 00 00       	call   80035e <cprintf>
  800234:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800237:	83 ec 0c             	sub    $0xc,%esp
  80023a:	68 64 1c 80 00       	push   $0x801c64
  80023f:	e8 1a 01 00 00       	call   80035e <cprintf>
  800244:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800247:	e8 80 10 00 00       	call   8012cc <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80024c:	e8 1f 00 00 00       	call   800270 <exit>
}
  800251:	90                   	nop
  800252:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800255:	5b                   	pop    %ebx
  800256:	5e                   	pop    %esi
  800257:	5f                   	pop    %edi
  800258:	5d                   	pop    %ebp
  800259:	c3                   	ret    

0080025a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80025a:	55                   	push   %ebp
  80025b:	89 e5                	mov    %esp,%ebp
  80025d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	6a 00                	push   $0x0
  800265:	e8 8d 12 00 00       	call   8014f7 <sys_destroy_env>
  80026a:	83 c4 10             	add    $0x10,%esp
}
  80026d:	90                   	nop
  80026e:	c9                   	leave  
  80026f:	c3                   	ret    

00800270 <exit>:

void
exit(void)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800276:	e8 e2 12 00 00       	call   80155d <sys_exit_env>
}
  80027b:	90                   	nop
  80027c:	c9                   	leave  
  80027d:	c3                   	ret    

0080027e <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	53                   	push   %ebx
  800282:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800285:	8b 45 0c             	mov    0xc(%ebp),%eax
  800288:	8b 00                	mov    (%eax),%eax
  80028a:	8d 48 01             	lea    0x1(%eax),%ecx
  80028d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800290:	89 0a                	mov    %ecx,(%edx)
  800292:	8b 55 08             	mov    0x8(%ebp),%edx
  800295:	88 d1                	mov    %dl,%cl
  800297:	8b 55 0c             	mov    0xc(%ebp),%edx
  80029a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80029e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a1:	8b 00                	mov    (%eax),%eax
  8002a3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002a8:	75 30                	jne    8002da <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8002aa:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8002b0:	a0 44 30 80 00       	mov    0x803044,%al
  8002b5:	0f b6 c0             	movzbl %al,%eax
  8002b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002bb:	8b 09                	mov    (%ecx),%ecx
  8002bd:	89 cb                	mov    %ecx,%ebx
  8002bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c2:	83 c1 08             	add    $0x8,%ecx
  8002c5:	52                   	push   %edx
  8002c6:	50                   	push   %eax
  8002c7:	53                   	push   %ebx
  8002c8:	51                   	push   %ecx
  8002c9:	e8 a0 0f 00 00       	call   80126e <sys_cputs>
  8002ce:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002dd:	8b 40 04             	mov    0x4(%eax),%eax
  8002e0:	8d 50 01             	lea    0x1(%eax),%edx
  8002e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e6:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002e9:	90                   	nop
  8002ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002ed:	c9                   	leave  
  8002ee:	c3                   	ret    

008002ef <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002f8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ff:	00 00 00 
	b.cnt = 0;
  800302:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800309:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80030c:	ff 75 0c             	pushl  0xc(%ebp)
  80030f:	ff 75 08             	pushl  0x8(%ebp)
  800312:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800318:	50                   	push   %eax
  800319:	68 7e 02 80 00       	push   $0x80027e
  80031e:	e8 5a 02 00 00       	call   80057d <vprintfmt>
  800323:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800326:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  80032c:	a0 44 30 80 00       	mov    0x803044,%al
  800331:	0f b6 c0             	movzbl %al,%eax
  800334:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80033a:	52                   	push   %edx
  80033b:	50                   	push   %eax
  80033c:	51                   	push   %ecx
  80033d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800343:	83 c0 08             	add    $0x8,%eax
  800346:	50                   	push   %eax
  800347:	e8 22 0f 00 00       	call   80126e <sys_cputs>
  80034c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80034f:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800356:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80035c:	c9                   	leave  
  80035d:	c3                   	ret    

0080035e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80035e:	55                   	push   %ebp
  80035f:	89 e5                	mov    %esp,%ebp
  800361:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800364:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80036b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80036e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800371:	8b 45 08             	mov    0x8(%ebp),%eax
  800374:	83 ec 08             	sub    $0x8,%esp
  800377:	ff 75 f4             	pushl  -0xc(%ebp)
  80037a:	50                   	push   %eax
  80037b:	e8 6f ff ff ff       	call   8002ef <vcprintf>
  800380:	83 c4 10             	add    $0x10,%esp
  800383:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800386:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800389:	c9                   	leave  
  80038a:	c3                   	ret    

0080038b <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80038b:	55                   	push   %ebp
  80038c:	89 e5                	mov    %esp,%ebp
  80038e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800391:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800398:	8b 45 08             	mov    0x8(%ebp),%eax
  80039b:	c1 e0 08             	shl    $0x8,%eax
  80039e:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  8003a3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003a6:	83 c0 04             	add    $0x4,%eax
  8003a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003af:	83 ec 08             	sub    $0x8,%esp
  8003b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8003b5:	50                   	push   %eax
  8003b6:	e8 34 ff ff ff       	call   8002ef <vcprintf>
  8003bb:	83 c4 10             	add    $0x10,%esp
  8003be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8003c1:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  8003c8:	07 00 00 

	return cnt;
  8003cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003ce:	c9                   	leave  
  8003cf:	c3                   	ret    

008003d0 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003d0:	55                   	push   %ebp
  8003d1:	89 e5                	mov    %esp,%ebp
  8003d3:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003d6:	e8 d7 0e 00 00       	call   8012b2 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8003db:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003de:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8003e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e4:	83 ec 08             	sub    $0x8,%esp
  8003e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ea:	50                   	push   %eax
  8003eb:	e8 ff fe ff ff       	call   8002ef <vcprintf>
  8003f0:	83 c4 10             	add    $0x10,%esp
  8003f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8003f6:	e8 d1 0e 00 00       	call   8012cc <sys_unlock_cons>
	return cnt;
  8003fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003fe:	c9                   	leave  
  8003ff:	c3                   	ret    

00800400 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800400:	55                   	push   %ebp
  800401:	89 e5                	mov    %esp,%ebp
  800403:	53                   	push   %ebx
  800404:	83 ec 14             	sub    $0x14,%esp
  800407:	8b 45 10             	mov    0x10(%ebp),%eax
  80040a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80040d:	8b 45 14             	mov    0x14(%ebp),%eax
  800410:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800413:	8b 45 18             	mov    0x18(%ebp),%eax
  800416:	ba 00 00 00 00       	mov    $0x0,%edx
  80041b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80041e:	77 55                	ja     800475 <printnum+0x75>
  800420:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800423:	72 05                	jb     80042a <printnum+0x2a>
  800425:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800428:	77 4b                	ja     800475 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80042a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80042d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800430:	8b 45 18             	mov    0x18(%ebp),%eax
  800433:	ba 00 00 00 00       	mov    $0x0,%edx
  800438:	52                   	push   %edx
  800439:	50                   	push   %eax
  80043a:	ff 75 f4             	pushl  -0xc(%ebp)
  80043d:	ff 75 f0             	pushl  -0x10(%ebp)
  800440:	e8 97 15 00 00       	call   8019dc <__udivdi3>
  800445:	83 c4 10             	add    $0x10,%esp
  800448:	83 ec 04             	sub    $0x4,%esp
  80044b:	ff 75 20             	pushl  0x20(%ebp)
  80044e:	53                   	push   %ebx
  80044f:	ff 75 18             	pushl  0x18(%ebp)
  800452:	52                   	push   %edx
  800453:	50                   	push   %eax
  800454:	ff 75 0c             	pushl  0xc(%ebp)
  800457:	ff 75 08             	pushl  0x8(%ebp)
  80045a:	e8 a1 ff ff ff       	call   800400 <printnum>
  80045f:	83 c4 20             	add    $0x20,%esp
  800462:	eb 1a                	jmp    80047e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	ff 75 0c             	pushl  0xc(%ebp)
  80046a:	ff 75 20             	pushl  0x20(%ebp)
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	ff d0                	call   *%eax
  800472:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800475:	ff 4d 1c             	decl   0x1c(%ebp)
  800478:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80047c:	7f e6                	jg     800464 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80047e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800481:	bb 00 00 00 00       	mov    $0x0,%ebx
  800486:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800489:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80048c:	53                   	push   %ebx
  80048d:	51                   	push   %ecx
  80048e:	52                   	push   %edx
  80048f:	50                   	push   %eax
  800490:	e8 57 16 00 00       	call   801aec <__umoddi3>
  800495:	83 c4 10             	add    $0x10,%esp
  800498:	05 d4 1f 80 00       	add    $0x801fd4,%eax
  80049d:	8a 00                	mov    (%eax),%al
  80049f:	0f be c0             	movsbl %al,%eax
  8004a2:	83 ec 08             	sub    $0x8,%esp
  8004a5:	ff 75 0c             	pushl  0xc(%ebp)
  8004a8:	50                   	push   %eax
  8004a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ac:	ff d0                	call   *%eax
  8004ae:	83 c4 10             	add    $0x10,%esp
}
  8004b1:	90                   	nop
  8004b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004b5:	c9                   	leave  
  8004b6:	c3                   	ret    

008004b7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004b7:	55                   	push   %ebp
  8004b8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004ba:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004be:	7e 1c                	jle    8004dc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c3:	8b 00                	mov    (%eax),%eax
  8004c5:	8d 50 08             	lea    0x8(%eax),%edx
  8004c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cb:	89 10                	mov    %edx,(%eax)
  8004cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d0:	8b 00                	mov    (%eax),%eax
  8004d2:	83 e8 08             	sub    $0x8,%eax
  8004d5:	8b 50 04             	mov    0x4(%eax),%edx
  8004d8:	8b 00                	mov    (%eax),%eax
  8004da:	eb 40                	jmp    80051c <getuint+0x65>
	else if (lflag)
  8004dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004e0:	74 1e                	je     800500 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e5:	8b 00                	mov    (%eax),%eax
  8004e7:	8d 50 04             	lea    0x4(%eax),%edx
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	89 10                	mov    %edx,(%eax)
  8004ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f2:	8b 00                	mov    (%eax),%eax
  8004f4:	83 e8 04             	sub    $0x4,%eax
  8004f7:	8b 00                	mov    (%eax),%eax
  8004f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8004fe:	eb 1c                	jmp    80051c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800500:	8b 45 08             	mov    0x8(%ebp),%eax
  800503:	8b 00                	mov    (%eax),%eax
  800505:	8d 50 04             	lea    0x4(%eax),%edx
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	89 10                	mov    %edx,(%eax)
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	83 e8 04             	sub    $0x4,%eax
  800515:	8b 00                	mov    (%eax),%eax
  800517:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80051c:	5d                   	pop    %ebp
  80051d:	c3                   	ret    

0080051e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80051e:	55                   	push   %ebp
  80051f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800521:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800525:	7e 1c                	jle    800543 <getint+0x25>
		return va_arg(*ap, long long);
  800527:	8b 45 08             	mov    0x8(%ebp),%eax
  80052a:	8b 00                	mov    (%eax),%eax
  80052c:	8d 50 08             	lea    0x8(%eax),%edx
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	89 10                	mov    %edx,(%eax)
  800534:	8b 45 08             	mov    0x8(%ebp),%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	83 e8 08             	sub    $0x8,%eax
  80053c:	8b 50 04             	mov    0x4(%eax),%edx
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	eb 38                	jmp    80057b <getint+0x5d>
	else if (lflag)
  800543:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800547:	74 1a                	je     800563 <getint+0x45>
		return va_arg(*ap, long);
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	8b 00                	mov    (%eax),%eax
  80054e:	8d 50 04             	lea    0x4(%eax),%edx
  800551:	8b 45 08             	mov    0x8(%ebp),%eax
  800554:	89 10                	mov    %edx,(%eax)
  800556:	8b 45 08             	mov    0x8(%ebp),%eax
  800559:	8b 00                	mov    (%eax),%eax
  80055b:	83 e8 04             	sub    $0x4,%eax
  80055e:	8b 00                	mov    (%eax),%eax
  800560:	99                   	cltd   
  800561:	eb 18                	jmp    80057b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800563:	8b 45 08             	mov    0x8(%ebp),%eax
  800566:	8b 00                	mov    (%eax),%eax
  800568:	8d 50 04             	lea    0x4(%eax),%edx
  80056b:	8b 45 08             	mov    0x8(%ebp),%eax
  80056e:	89 10                	mov    %edx,(%eax)
  800570:	8b 45 08             	mov    0x8(%ebp),%eax
  800573:	8b 00                	mov    (%eax),%eax
  800575:	83 e8 04             	sub    $0x4,%eax
  800578:	8b 00                	mov    (%eax),%eax
  80057a:	99                   	cltd   
}
  80057b:	5d                   	pop    %ebp
  80057c:	c3                   	ret    

0080057d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80057d:	55                   	push   %ebp
  80057e:	89 e5                	mov    %esp,%ebp
  800580:	56                   	push   %esi
  800581:	53                   	push   %ebx
  800582:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800585:	eb 17                	jmp    80059e <vprintfmt+0x21>
			if (ch == '\0')
  800587:	85 db                	test   %ebx,%ebx
  800589:	0f 84 c1 03 00 00    	je     800950 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80058f:	83 ec 08             	sub    $0x8,%esp
  800592:	ff 75 0c             	pushl  0xc(%ebp)
  800595:	53                   	push   %ebx
  800596:	8b 45 08             	mov    0x8(%ebp),%eax
  800599:	ff d0                	call   *%eax
  80059b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80059e:	8b 45 10             	mov    0x10(%ebp),%eax
  8005a1:	8d 50 01             	lea    0x1(%eax),%edx
  8005a4:	89 55 10             	mov    %edx,0x10(%ebp)
  8005a7:	8a 00                	mov    (%eax),%al
  8005a9:	0f b6 d8             	movzbl %al,%ebx
  8005ac:	83 fb 25             	cmp    $0x25,%ebx
  8005af:	75 d6                	jne    800587 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005b1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005b5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005bc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005c3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005ca:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d4:	8d 50 01             	lea    0x1(%eax),%edx
  8005d7:	89 55 10             	mov    %edx,0x10(%ebp)
  8005da:	8a 00                	mov    (%eax),%al
  8005dc:	0f b6 d8             	movzbl %al,%ebx
  8005df:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005e2:	83 f8 5b             	cmp    $0x5b,%eax
  8005e5:	0f 87 3d 03 00 00    	ja     800928 <vprintfmt+0x3ab>
  8005eb:	8b 04 85 f8 1f 80 00 	mov    0x801ff8(,%eax,4),%eax
  8005f2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005f4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005f8:	eb d7                	jmp    8005d1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005fa:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005fe:	eb d1                	jmp    8005d1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800600:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800607:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80060a:	89 d0                	mov    %edx,%eax
  80060c:	c1 e0 02             	shl    $0x2,%eax
  80060f:	01 d0                	add    %edx,%eax
  800611:	01 c0                	add    %eax,%eax
  800613:	01 d8                	add    %ebx,%eax
  800615:	83 e8 30             	sub    $0x30,%eax
  800618:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80061b:	8b 45 10             	mov    0x10(%ebp),%eax
  80061e:	8a 00                	mov    (%eax),%al
  800620:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800623:	83 fb 2f             	cmp    $0x2f,%ebx
  800626:	7e 3e                	jle    800666 <vprintfmt+0xe9>
  800628:	83 fb 39             	cmp    $0x39,%ebx
  80062b:	7f 39                	jg     800666 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80062d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800630:	eb d5                	jmp    800607 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	83 c0 04             	add    $0x4,%eax
  800638:	89 45 14             	mov    %eax,0x14(%ebp)
  80063b:	8b 45 14             	mov    0x14(%ebp),%eax
  80063e:	83 e8 04             	sub    $0x4,%eax
  800641:	8b 00                	mov    (%eax),%eax
  800643:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800646:	eb 1f                	jmp    800667 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800648:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80064c:	79 83                	jns    8005d1 <vprintfmt+0x54>
				width = 0;
  80064e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800655:	e9 77 ff ff ff       	jmp    8005d1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80065a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800661:	e9 6b ff ff ff       	jmp    8005d1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800666:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800667:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80066b:	0f 89 60 ff ff ff    	jns    8005d1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800671:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800674:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800677:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80067e:	e9 4e ff ff ff       	jmp    8005d1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800683:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800686:	e9 46 ff ff ff       	jmp    8005d1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80068b:	8b 45 14             	mov    0x14(%ebp),%eax
  80068e:	83 c0 04             	add    $0x4,%eax
  800691:	89 45 14             	mov    %eax,0x14(%ebp)
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	83 e8 04             	sub    $0x4,%eax
  80069a:	8b 00                	mov    (%eax),%eax
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	ff 75 0c             	pushl  0xc(%ebp)
  8006a2:	50                   	push   %eax
  8006a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a6:	ff d0                	call   *%eax
  8006a8:	83 c4 10             	add    $0x10,%esp
			break;
  8006ab:	e9 9b 02 00 00       	jmp    80094b <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b3:	83 c0 04             	add    $0x4,%eax
  8006b6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bc:	83 e8 04             	sub    $0x4,%eax
  8006bf:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006c1:	85 db                	test   %ebx,%ebx
  8006c3:	79 02                	jns    8006c7 <vprintfmt+0x14a>
				err = -err;
  8006c5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006c7:	83 fb 64             	cmp    $0x64,%ebx
  8006ca:	7f 0b                	jg     8006d7 <vprintfmt+0x15a>
  8006cc:	8b 34 9d 40 1e 80 00 	mov    0x801e40(,%ebx,4),%esi
  8006d3:	85 f6                	test   %esi,%esi
  8006d5:	75 19                	jne    8006f0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006d7:	53                   	push   %ebx
  8006d8:	68 e5 1f 80 00       	push   $0x801fe5
  8006dd:	ff 75 0c             	pushl  0xc(%ebp)
  8006e0:	ff 75 08             	pushl  0x8(%ebp)
  8006e3:	e8 70 02 00 00       	call   800958 <printfmt>
  8006e8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006eb:	e9 5b 02 00 00       	jmp    80094b <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006f0:	56                   	push   %esi
  8006f1:	68 ee 1f 80 00       	push   $0x801fee
  8006f6:	ff 75 0c             	pushl  0xc(%ebp)
  8006f9:	ff 75 08             	pushl  0x8(%ebp)
  8006fc:	e8 57 02 00 00       	call   800958 <printfmt>
  800701:	83 c4 10             	add    $0x10,%esp
			break;
  800704:	e9 42 02 00 00       	jmp    80094b <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800709:	8b 45 14             	mov    0x14(%ebp),%eax
  80070c:	83 c0 04             	add    $0x4,%eax
  80070f:	89 45 14             	mov    %eax,0x14(%ebp)
  800712:	8b 45 14             	mov    0x14(%ebp),%eax
  800715:	83 e8 04             	sub    $0x4,%eax
  800718:	8b 30                	mov    (%eax),%esi
  80071a:	85 f6                	test   %esi,%esi
  80071c:	75 05                	jne    800723 <vprintfmt+0x1a6>
				p = "(null)";
  80071e:	be f1 1f 80 00       	mov    $0x801ff1,%esi
			if (width > 0 && padc != '-')
  800723:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800727:	7e 6d                	jle    800796 <vprintfmt+0x219>
  800729:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80072d:	74 67                	je     800796 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80072f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800732:	83 ec 08             	sub    $0x8,%esp
  800735:	50                   	push   %eax
  800736:	56                   	push   %esi
  800737:	e8 1e 03 00 00       	call   800a5a <strnlen>
  80073c:	83 c4 10             	add    $0x10,%esp
  80073f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800742:	eb 16                	jmp    80075a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800744:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800748:	83 ec 08             	sub    $0x8,%esp
  80074b:	ff 75 0c             	pushl  0xc(%ebp)
  80074e:	50                   	push   %eax
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	ff d0                	call   *%eax
  800754:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800757:	ff 4d e4             	decl   -0x1c(%ebp)
  80075a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80075e:	7f e4                	jg     800744 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800760:	eb 34                	jmp    800796 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800762:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800766:	74 1c                	je     800784 <vprintfmt+0x207>
  800768:	83 fb 1f             	cmp    $0x1f,%ebx
  80076b:	7e 05                	jle    800772 <vprintfmt+0x1f5>
  80076d:	83 fb 7e             	cmp    $0x7e,%ebx
  800770:	7e 12                	jle    800784 <vprintfmt+0x207>
					putch('?', putdat);
  800772:	83 ec 08             	sub    $0x8,%esp
  800775:	ff 75 0c             	pushl  0xc(%ebp)
  800778:	6a 3f                	push   $0x3f
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	ff d0                	call   *%eax
  80077f:	83 c4 10             	add    $0x10,%esp
  800782:	eb 0f                	jmp    800793 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	ff 75 0c             	pushl  0xc(%ebp)
  80078a:	53                   	push   %ebx
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	ff d0                	call   *%eax
  800790:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800793:	ff 4d e4             	decl   -0x1c(%ebp)
  800796:	89 f0                	mov    %esi,%eax
  800798:	8d 70 01             	lea    0x1(%eax),%esi
  80079b:	8a 00                	mov    (%eax),%al
  80079d:	0f be d8             	movsbl %al,%ebx
  8007a0:	85 db                	test   %ebx,%ebx
  8007a2:	74 24                	je     8007c8 <vprintfmt+0x24b>
  8007a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007a8:	78 b8                	js     800762 <vprintfmt+0x1e5>
  8007aa:	ff 4d e0             	decl   -0x20(%ebp)
  8007ad:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007b1:	79 af                	jns    800762 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007b3:	eb 13                	jmp    8007c8 <vprintfmt+0x24b>
				putch(' ', putdat);
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	ff 75 0c             	pushl  0xc(%ebp)
  8007bb:	6a 20                	push   $0x20
  8007bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c0:	ff d0                	call   *%eax
  8007c2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007c5:	ff 4d e4             	decl   -0x1c(%ebp)
  8007c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007cc:	7f e7                	jg     8007b5 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007ce:	e9 78 01 00 00       	jmp    80094b <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007d3:	83 ec 08             	sub    $0x8,%esp
  8007d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8007d9:	8d 45 14             	lea    0x14(%ebp),%eax
  8007dc:	50                   	push   %eax
  8007dd:	e8 3c fd ff ff       	call   80051e <getint>
  8007e2:	83 c4 10             	add    $0x10,%esp
  8007e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007f1:	85 d2                	test   %edx,%edx
  8007f3:	79 23                	jns    800818 <vprintfmt+0x29b>
				putch('-', putdat);
  8007f5:	83 ec 08             	sub    $0x8,%esp
  8007f8:	ff 75 0c             	pushl  0xc(%ebp)
  8007fb:	6a 2d                	push   $0x2d
  8007fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800800:	ff d0                	call   *%eax
  800802:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800805:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800808:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80080b:	f7 d8                	neg    %eax
  80080d:	83 d2 00             	adc    $0x0,%edx
  800810:	f7 da                	neg    %edx
  800812:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800815:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800818:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80081f:	e9 bc 00 00 00       	jmp    8008e0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800824:	83 ec 08             	sub    $0x8,%esp
  800827:	ff 75 e8             	pushl  -0x18(%ebp)
  80082a:	8d 45 14             	lea    0x14(%ebp),%eax
  80082d:	50                   	push   %eax
  80082e:	e8 84 fc ff ff       	call   8004b7 <getuint>
  800833:	83 c4 10             	add    $0x10,%esp
  800836:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800839:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80083c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800843:	e9 98 00 00 00       	jmp    8008e0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800848:	83 ec 08             	sub    $0x8,%esp
  80084b:	ff 75 0c             	pushl  0xc(%ebp)
  80084e:	6a 58                	push   $0x58
  800850:	8b 45 08             	mov    0x8(%ebp),%eax
  800853:	ff d0                	call   *%eax
  800855:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800858:	83 ec 08             	sub    $0x8,%esp
  80085b:	ff 75 0c             	pushl  0xc(%ebp)
  80085e:	6a 58                	push   $0x58
  800860:	8b 45 08             	mov    0x8(%ebp),%eax
  800863:	ff d0                	call   *%eax
  800865:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800868:	83 ec 08             	sub    $0x8,%esp
  80086b:	ff 75 0c             	pushl  0xc(%ebp)
  80086e:	6a 58                	push   $0x58
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	ff d0                	call   *%eax
  800875:	83 c4 10             	add    $0x10,%esp
			break;
  800878:	e9 ce 00 00 00       	jmp    80094b <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80087d:	83 ec 08             	sub    $0x8,%esp
  800880:	ff 75 0c             	pushl  0xc(%ebp)
  800883:	6a 30                	push   $0x30
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	ff d0                	call   *%eax
  80088a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80088d:	83 ec 08             	sub    $0x8,%esp
  800890:	ff 75 0c             	pushl  0xc(%ebp)
  800893:	6a 78                	push   $0x78
  800895:	8b 45 08             	mov    0x8(%ebp),%eax
  800898:	ff d0                	call   *%eax
  80089a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80089d:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a0:	83 c0 04             	add    $0x4,%eax
  8008a3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a9:	83 e8 04             	sub    $0x4,%eax
  8008ac:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008b8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008bf:	eb 1f                	jmp    8008e0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008c1:	83 ec 08             	sub    $0x8,%esp
  8008c4:	ff 75 e8             	pushl  -0x18(%ebp)
  8008c7:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ca:	50                   	push   %eax
  8008cb:	e8 e7 fb ff ff       	call   8004b7 <getuint>
  8008d0:	83 c4 10             	add    $0x10,%esp
  8008d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008d9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008e0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e7:	83 ec 04             	sub    $0x4,%esp
  8008ea:	52                   	push   %edx
  8008eb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008ee:	50                   	push   %eax
  8008ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8008f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8008f5:	ff 75 0c             	pushl  0xc(%ebp)
  8008f8:	ff 75 08             	pushl  0x8(%ebp)
  8008fb:	e8 00 fb ff ff       	call   800400 <printnum>
  800900:	83 c4 20             	add    $0x20,%esp
			break;
  800903:	eb 46                	jmp    80094b <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800905:	83 ec 08             	sub    $0x8,%esp
  800908:	ff 75 0c             	pushl  0xc(%ebp)
  80090b:	53                   	push   %ebx
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	ff d0                	call   *%eax
  800911:	83 c4 10             	add    $0x10,%esp
			break;
  800914:	eb 35                	jmp    80094b <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800916:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  80091d:	eb 2c                	jmp    80094b <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80091f:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800926:	eb 23                	jmp    80094b <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800928:	83 ec 08             	sub    $0x8,%esp
  80092b:	ff 75 0c             	pushl  0xc(%ebp)
  80092e:	6a 25                	push   $0x25
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	ff d0                	call   *%eax
  800935:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800938:	ff 4d 10             	decl   0x10(%ebp)
  80093b:	eb 03                	jmp    800940 <vprintfmt+0x3c3>
  80093d:	ff 4d 10             	decl   0x10(%ebp)
  800940:	8b 45 10             	mov    0x10(%ebp),%eax
  800943:	48                   	dec    %eax
  800944:	8a 00                	mov    (%eax),%al
  800946:	3c 25                	cmp    $0x25,%al
  800948:	75 f3                	jne    80093d <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80094a:	90                   	nop
		}
	}
  80094b:	e9 35 fc ff ff       	jmp    800585 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800950:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800951:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800954:	5b                   	pop    %ebx
  800955:	5e                   	pop    %esi
  800956:	5d                   	pop    %ebp
  800957:	c3                   	ret    

00800958 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800958:	55                   	push   %ebp
  800959:	89 e5                	mov    %esp,%ebp
  80095b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80095e:	8d 45 10             	lea    0x10(%ebp),%eax
  800961:	83 c0 04             	add    $0x4,%eax
  800964:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800967:	8b 45 10             	mov    0x10(%ebp),%eax
  80096a:	ff 75 f4             	pushl  -0xc(%ebp)
  80096d:	50                   	push   %eax
  80096e:	ff 75 0c             	pushl  0xc(%ebp)
  800971:	ff 75 08             	pushl  0x8(%ebp)
  800974:	e8 04 fc ff ff       	call   80057d <vprintfmt>
  800979:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80097c:	90                   	nop
  80097d:	c9                   	leave  
  80097e:	c3                   	ret    

0080097f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800982:	8b 45 0c             	mov    0xc(%ebp),%eax
  800985:	8b 40 08             	mov    0x8(%eax),%eax
  800988:	8d 50 01             	lea    0x1(%eax),%edx
  80098b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800991:	8b 45 0c             	mov    0xc(%ebp),%eax
  800994:	8b 10                	mov    (%eax),%edx
  800996:	8b 45 0c             	mov    0xc(%ebp),%eax
  800999:	8b 40 04             	mov    0x4(%eax),%eax
  80099c:	39 c2                	cmp    %eax,%edx
  80099e:	73 12                	jae    8009b2 <sprintputch+0x33>
		*b->buf++ = ch;
  8009a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a3:	8b 00                	mov    (%eax),%eax
  8009a5:	8d 48 01             	lea    0x1(%eax),%ecx
  8009a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ab:	89 0a                	mov    %ecx,(%edx)
  8009ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8009b0:	88 10                	mov    %dl,(%eax)
}
  8009b2:	90                   	nop
  8009b3:	5d                   	pop    %ebp
  8009b4:	c3                   	ret    

008009b5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009b5:	55                   	push   %ebp
  8009b6:	89 e5                	mov    %esp,%ebp
  8009b8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ca:	01 d0                	add    %edx,%eax
  8009cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009da:	74 06                	je     8009e2 <vsnprintf+0x2d>
  8009dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009e0:	7f 07                	jg     8009e9 <vsnprintf+0x34>
		return -E_INVAL;
  8009e2:	b8 03 00 00 00       	mov    $0x3,%eax
  8009e7:	eb 20                	jmp    800a09 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009e9:	ff 75 14             	pushl  0x14(%ebp)
  8009ec:	ff 75 10             	pushl  0x10(%ebp)
  8009ef:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009f2:	50                   	push   %eax
  8009f3:	68 7f 09 80 00       	push   $0x80097f
  8009f8:	e8 80 fb ff ff       	call   80057d <vprintfmt>
  8009fd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a03:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a09:	c9                   	leave  
  800a0a:	c3                   	ret    

00800a0b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a11:	8d 45 10             	lea    0x10(%ebp),%eax
  800a14:	83 c0 04             	add    $0x4,%eax
  800a17:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a1d:	ff 75 f4             	pushl  -0xc(%ebp)
  800a20:	50                   	push   %eax
  800a21:	ff 75 0c             	pushl  0xc(%ebp)
  800a24:	ff 75 08             	pushl  0x8(%ebp)
  800a27:	e8 89 ff ff ff       	call   8009b5 <vsnprintf>
  800a2c:	83 c4 10             	add    $0x10,%esp
  800a2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a35:	c9                   	leave  
  800a36:	c3                   	ret    

00800a37 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a44:	eb 06                	jmp    800a4c <strlen+0x15>
		n++;
  800a46:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a49:	ff 45 08             	incl   0x8(%ebp)
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	8a 00                	mov    (%eax),%al
  800a51:	84 c0                	test   %al,%al
  800a53:	75 f1                	jne    800a46 <strlen+0xf>
		n++;
	return n;
  800a55:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a58:	c9                   	leave  
  800a59:	c3                   	ret    

00800a5a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a67:	eb 09                	jmp    800a72 <strnlen+0x18>
		n++;
  800a69:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a6c:	ff 45 08             	incl   0x8(%ebp)
  800a6f:	ff 4d 0c             	decl   0xc(%ebp)
  800a72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a76:	74 09                	je     800a81 <strnlen+0x27>
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	8a 00                	mov    (%eax),%al
  800a7d:	84 c0                	test   %al,%al
  800a7f:	75 e8                	jne    800a69 <strnlen+0xf>
		n++;
	return n;
  800a81:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a84:	c9                   	leave  
  800a85:	c3                   	ret    

00800a86 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a86:	55                   	push   %ebp
  800a87:	89 e5                	mov    %esp,%ebp
  800a89:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a92:	90                   	nop
  800a93:	8b 45 08             	mov    0x8(%ebp),%eax
  800a96:	8d 50 01             	lea    0x1(%eax),%edx
  800a99:	89 55 08             	mov    %edx,0x8(%ebp)
  800a9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800aa2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800aa5:	8a 12                	mov    (%edx),%dl
  800aa7:	88 10                	mov    %dl,(%eax)
  800aa9:	8a 00                	mov    (%eax),%al
  800aab:	84 c0                	test   %al,%al
  800aad:	75 e4                	jne    800a93 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800aaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ab2:	c9                   	leave  
  800ab3:	c3                   	ret    

00800ab4 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ab4:	55                   	push   %ebp
  800ab5:	89 e5                	mov    %esp,%ebp
  800ab7:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ac0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ac7:	eb 1f                	jmp    800ae8 <strncpy+0x34>
		*dst++ = *src;
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	8d 50 01             	lea    0x1(%eax),%edx
  800acf:	89 55 08             	mov    %edx,0x8(%ebp)
  800ad2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad5:	8a 12                	mov    (%edx),%dl
  800ad7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adc:	8a 00                	mov    (%eax),%al
  800ade:	84 c0                	test   %al,%al
  800ae0:	74 03                	je     800ae5 <strncpy+0x31>
			src++;
  800ae2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ae5:	ff 45 fc             	incl   -0x4(%ebp)
  800ae8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800aeb:	3b 45 10             	cmp    0x10(%ebp),%eax
  800aee:	72 d9                	jb     800ac9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800af0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800af3:	c9                   	leave  
  800af4:	c3                   	ret    

00800af5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
  800af8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800afb:	8b 45 08             	mov    0x8(%ebp),%eax
  800afe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b05:	74 30                	je     800b37 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b07:	eb 16                	jmp    800b1f <strlcpy+0x2a>
			*dst++ = *src++;
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	8d 50 01             	lea    0x1(%eax),%edx
  800b0f:	89 55 08             	mov    %edx,0x8(%ebp)
  800b12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b15:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b18:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b1b:	8a 12                	mov    (%edx),%dl
  800b1d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b1f:	ff 4d 10             	decl   0x10(%ebp)
  800b22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b26:	74 09                	je     800b31 <strlcpy+0x3c>
  800b28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2b:	8a 00                	mov    (%eax),%al
  800b2d:	84 c0                	test   %al,%al
  800b2f:	75 d8                	jne    800b09 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b37:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b3d:	29 c2                	sub    %eax,%edx
  800b3f:	89 d0                	mov    %edx,%eax
}
  800b41:	c9                   	leave  
  800b42:	c3                   	ret    

00800b43 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b46:	eb 06                	jmp    800b4e <strcmp+0xb>
		p++, q++;
  800b48:	ff 45 08             	incl   0x8(%ebp)
  800b4b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b51:	8a 00                	mov    (%eax),%al
  800b53:	84 c0                	test   %al,%al
  800b55:	74 0e                	je     800b65 <strcmp+0x22>
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	8a 10                	mov    (%eax),%dl
  800b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5f:	8a 00                	mov    (%eax),%al
  800b61:	38 c2                	cmp    %al,%dl
  800b63:	74 e3                	je     800b48 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	8a 00                	mov    (%eax),%al
  800b6a:	0f b6 d0             	movzbl %al,%edx
  800b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b70:	8a 00                	mov    (%eax),%al
  800b72:	0f b6 c0             	movzbl %al,%eax
  800b75:	29 c2                	sub    %eax,%edx
  800b77:	89 d0                	mov    %edx,%eax
}
  800b79:	5d                   	pop    %ebp
  800b7a:	c3                   	ret    

00800b7b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b7e:	eb 09                	jmp    800b89 <strncmp+0xe>
		n--, p++, q++;
  800b80:	ff 4d 10             	decl   0x10(%ebp)
  800b83:	ff 45 08             	incl   0x8(%ebp)
  800b86:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b8d:	74 17                	je     800ba6 <strncmp+0x2b>
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	8a 00                	mov    (%eax),%al
  800b94:	84 c0                	test   %al,%al
  800b96:	74 0e                	je     800ba6 <strncmp+0x2b>
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	8a 10                	mov    (%eax),%dl
  800b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba0:	8a 00                	mov    (%eax),%al
  800ba2:	38 c2                	cmp    %al,%dl
  800ba4:	74 da                	je     800b80 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ba6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800baa:	75 07                	jne    800bb3 <strncmp+0x38>
		return 0;
  800bac:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb1:	eb 14                	jmp    800bc7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	8a 00                	mov    (%eax),%al
  800bb8:	0f b6 d0             	movzbl %al,%edx
  800bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbe:	8a 00                	mov    (%eax),%al
  800bc0:	0f b6 c0             	movzbl %al,%eax
  800bc3:	29 c2                	sub    %eax,%edx
  800bc5:	89 d0                	mov    %edx,%eax
}
  800bc7:	5d                   	pop    %ebp
  800bc8:	c3                   	ret    

00800bc9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	83 ec 04             	sub    $0x4,%esp
  800bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bd5:	eb 12                	jmp    800be9 <strchr+0x20>
		if (*s == c)
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	8a 00                	mov    (%eax),%al
  800bdc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bdf:	75 05                	jne    800be6 <strchr+0x1d>
			return (char *) s;
  800be1:	8b 45 08             	mov    0x8(%ebp),%eax
  800be4:	eb 11                	jmp    800bf7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800be6:	ff 45 08             	incl   0x8(%ebp)
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	8a 00                	mov    (%eax),%al
  800bee:	84 c0                	test   %al,%al
  800bf0:	75 e5                	jne    800bd7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bf2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bf7:	c9                   	leave  
  800bf8:	c3                   	ret    

00800bf9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bf9:	55                   	push   %ebp
  800bfa:	89 e5                	mov    %esp,%ebp
  800bfc:	83 ec 04             	sub    $0x4,%esp
  800bff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c02:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c05:	eb 0d                	jmp    800c14 <strfind+0x1b>
		if (*s == c)
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	8a 00                	mov    (%eax),%al
  800c0c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c0f:	74 0e                	je     800c1f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c11:	ff 45 08             	incl   0x8(%ebp)
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	8a 00                	mov    (%eax),%al
  800c19:	84 c0                	test   %al,%al
  800c1b:	75 ea                	jne    800c07 <strfind+0xe>
  800c1d:	eb 01                	jmp    800c20 <strfind+0x27>
		if (*s == c)
			break;
  800c1f:	90                   	nop
	return (char *) s;
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c23:	c9                   	leave  
  800c24:	c3                   	ret    

00800c25 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800c31:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c35:	76 63                	jbe    800c9a <memset+0x75>
		uint64 data_block = c;
  800c37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3a:	99                   	cltd   
  800c3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3e:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800c41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c47:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800c4b:	c1 e0 08             	shl    $0x8,%eax
  800c4e:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c51:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c5a:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800c5e:	c1 e0 10             	shl    $0x10,%eax
  800c61:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c64:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c6d:	89 c2                	mov    %eax,%edx
  800c6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c74:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c77:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800c7a:	eb 18                	jmp    800c94 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800c7c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800c7f:	8d 41 08             	lea    0x8(%ecx),%eax
  800c82:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c8b:	89 01                	mov    %eax,(%ecx)
  800c8d:	89 51 04             	mov    %edx,0x4(%ecx)
  800c90:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800c94:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c98:	77 e2                	ja     800c7c <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800c9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c9e:	74 23                	je     800cc3 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ca0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ca6:	eb 0e                	jmp    800cb6 <memset+0x91>
			*p8++ = (uint8)c;
  800ca8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cab:	8d 50 01             	lea    0x1(%eax),%edx
  800cae:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb4:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800cb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cbc:	89 55 10             	mov    %edx,0x10(%ebp)
  800cbf:	85 c0                	test   %eax,%eax
  800cc1:	75 e5                	jne    800ca8 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc6:	c9                   	leave  
  800cc7:	c3                   	ret    

00800cc8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cc8:	55                   	push   %ebp
  800cc9:	89 e5                	mov    %esp,%ebp
  800ccb:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800cce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800cda:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800cde:	76 24                	jbe    800d04 <memcpy+0x3c>
		while(n >= 8){
  800ce0:	eb 1c                	jmp    800cfe <memcpy+0x36>
			*d64 = *s64;
  800ce2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce5:	8b 50 04             	mov    0x4(%eax),%edx
  800ce8:	8b 00                	mov    (%eax),%eax
  800cea:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800ced:	89 01                	mov    %eax,(%ecx)
  800cef:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800cf2:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800cf6:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800cfa:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800cfe:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d02:	77 de                	ja     800ce2 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800d04:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d08:	74 31                	je     800d3b <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800d0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800d10:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d13:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800d16:	eb 16                	jmp    800d2e <memcpy+0x66>
			*d8++ = *s8++;
  800d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d1b:	8d 50 01             	lea    0x1(%eax),%edx
  800d1e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800d21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d24:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d27:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800d2a:	8a 12                	mov    (%edx),%dl
  800d2c:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800d2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d34:	89 55 10             	mov    %edx,0x10(%ebp)
  800d37:	85 c0                	test   %eax,%eax
  800d39:	75 dd                	jne    800d18 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d3e:	c9                   	leave  
  800d3f:	c3                   	ret    

00800d40 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d55:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d58:	73 50                	jae    800daa <memmove+0x6a>
  800d5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d60:	01 d0                	add    %edx,%eax
  800d62:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d65:	76 43                	jbe    800daa <memmove+0x6a>
		s += n;
  800d67:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d70:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d73:	eb 10                	jmp    800d85 <memmove+0x45>
			*--d = *--s;
  800d75:	ff 4d f8             	decl   -0x8(%ebp)
  800d78:	ff 4d fc             	decl   -0x4(%ebp)
  800d7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d7e:	8a 10                	mov    (%eax),%dl
  800d80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d83:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d85:	8b 45 10             	mov    0x10(%ebp),%eax
  800d88:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d8b:	89 55 10             	mov    %edx,0x10(%ebp)
  800d8e:	85 c0                	test   %eax,%eax
  800d90:	75 e3                	jne    800d75 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d92:	eb 23                	jmp    800db7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d97:	8d 50 01             	lea    0x1(%eax),%edx
  800d9a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d9d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800da0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800da6:	8a 12                	mov    (%edx),%dl
  800da8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800daa:	8b 45 10             	mov    0x10(%ebp),%eax
  800dad:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db0:	89 55 10             	mov    %edx,0x10(%ebp)
  800db3:	85 c0                	test   %eax,%eax
  800db5:	75 dd                	jne    800d94 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dba:	c9                   	leave  
  800dbb:	c3                   	ret    

00800dbc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
  800dbf:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcb:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dce:	eb 2a                	jmp    800dfa <memcmp+0x3e>
		if (*s1 != *s2)
  800dd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd3:	8a 10                	mov    (%eax),%dl
  800dd5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd8:	8a 00                	mov    (%eax),%al
  800dda:	38 c2                	cmp    %al,%dl
  800ddc:	74 16                	je     800df4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dde:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de1:	8a 00                	mov    (%eax),%al
  800de3:	0f b6 d0             	movzbl %al,%edx
  800de6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de9:	8a 00                	mov    (%eax),%al
  800deb:	0f b6 c0             	movzbl %al,%eax
  800dee:	29 c2                	sub    %eax,%edx
  800df0:	89 d0                	mov    %edx,%eax
  800df2:	eb 18                	jmp    800e0c <memcmp+0x50>
		s1++, s2++;
  800df4:	ff 45 fc             	incl   -0x4(%ebp)
  800df7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800dfa:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e00:	89 55 10             	mov    %edx,0x10(%ebp)
  800e03:	85 c0                	test   %eax,%eax
  800e05:	75 c9                	jne    800dd0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e0c:	c9                   	leave  
  800e0d:	c3                   	ret    

00800e0e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e14:	8b 55 08             	mov    0x8(%ebp),%edx
  800e17:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1a:	01 d0                	add    %edx,%eax
  800e1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e1f:	eb 15                	jmp    800e36 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	8a 00                	mov    (%eax),%al
  800e26:	0f b6 d0             	movzbl %al,%edx
  800e29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2c:	0f b6 c0             	movzbl %al,%eax
  800e2f:	39 c2                	cmp    %eax,%edx
  800e31:	74 0d                	je     800e40 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e33:	ff 45 08             	incl   0x8(%ebp)
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
  800e39:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e3c:	72 e3                	jb     800e21 <memfind+0x13>
  800e3e:	eb 01                	jmp    800e41 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e40:	90                   	nop
	return (void *) s;
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e44:	c9                   	leave  
  800e45:	c3                   	ret    

00800e46 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e53:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e5a:	eb 03                	jmp    800e5f <strtol+0x19>
		s++;
  800e5c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	8a 00                	mov    (%eax),%al
  800e64:	3c 20                	cmp    $0x20,%al
  800e66:	74 f4                	je     800e5c <strtol+0x16>
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8a 00                	mov    (%eax),%al
  800e6d:	3c 09                	cmp    $0x9,%al
  800e6f:	74 eb                	je     800e5c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	3c 2b                	cmp    $0x2b,%al
  800e78:	75 05                	jne    800e7f <strtol+0x39>
		s++;
  800e7a:	ff 45 08             	incl   0x8(%ebp)
  800e7d:	eb 13                	jmp    800e92 <strtol+0x4c>
	else if (*s == '-')
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	8a 00                	mov    (%eax),%al
  800e84:	3c 2d                	cmp    $0x2d,%al
  800e86:	75 0a                	jne    800e92 <strtol+0x4c>
		s++, neg = 1;
  800e88:	ff 45 08             	incl   0x8(%ebp)
  800e8b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e96:	74 06                	je     800e9e <strtol+0x58>
  800e98:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e9c:	75 20                	jne    800ebe <strtol+0x78>
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	8a 00                	mov    (%eax),%al
  800ea3:	3c 30                	cmp    $0x30,%al
  800ea5:	75 17                	jne    800ebe <strtol+0x78>
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	40                   	inc    %eax
  800eab:	8a 00                	mov    (%eax),%al
  800ead:	3c 78                	cmp    $0x78,%al
  800eaf:	75 0d                	jne    800ebe <strtol+0x78>
		s += 2, base = 16;
  800eb1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800eb5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ebc:	eb 28                	jmp    800ee6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ebe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec2:	75 15                	jne    800ed9 <strtol+0x93>
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	8a 00                	mov    (%eax),%al
  800ec9:	3c 30                	cmp    $0x30,%al
  800ecb:	75 0c                	jne    800ed9 <strtol+0x93>
		s++, base = 8;
  800ecd:	ff 45 08             	incl   0x8(%ebp)
  800ed0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ed7:	eb 0d                	jmp    800ee6 <strtol+0xa0>
	else if (base == 0)
  800ed9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800edd:	75 07                	jne    800ee6 <strtol+0xa0>
		base = 10;
  800edf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	8a 00                	mov    (%eax),%al
  800eeb:	3c 2f                	cmp    $0x2f,%al
  800eed:	7e 19                	jle    800f08 <strtol+0xc2>
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	3c 39                	cmp    $0x39,%al
  800ef6:	7f 10                	jg     800f08 <strtol+0xc2>
			dig = *s - '0';
  800ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  800efb:	8a 00                	mov    (%eax),%al
  800efd:	0f be c0             	movsbl %al,%eax
  800f00:	83 e8 30             	sub    $0x30,%eax
  800f03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f06:	eb 42                	jmp    800f4a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	3c 60                	cmp    $0x60,%al
  800f0f:	7e 19                	jle    800f2a <strtol+0xe4>
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	3c 7a                	cmp    $0x7a,%al
  800f18:	7f 10                	jg     800f2a <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	8a 00                	mov    (%eax),%al
  800f1f:	0f be c0             	movsbl %al,%eax
  800f22:	83 e8 57             	sub    $0x57,%eax
  800f25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f28:	eb 20                	jmp    800f4a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	3c 40                	cmp    $0x40,%al
  800f31:	7e 39                	jle    800f6c <strtol+0x126>
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	8a 00                	mov    (%eax),%al
  800f38:	3c 5a                	cmp    $0x5a,%al
  800f3a:	7f 30                	jg     800f6c <strtol+0x126>
			dig = *s - 'A' + 10;
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	8a 00                	mov    (%eax),%al
  800f41:	0f be c0             	movsbl %al,%eax
  800f44:	83 e8 37             	sub    $0x37,%eax
  800f47:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f4d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f50:	7d 19                	jge    800f6b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f52:	ff 45 08             	incl   0x8(%ebp)
  800f55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f58:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f5c:	89 c2                	mov    %eax,%edx
  800f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f61:	01 d0                	add    %edx,%eax
  800f63:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f66:	e9 7b ff ff ff       	jmp    800ee6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f6b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f6c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f70:	74 08                	je     800f7a <strtol+0x134>
		*endptr = (char *) s;
  800f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f75:	8b 55 08             	mov    0x8(%ebp),%edx
  800f78:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f7e:	74 07                	je     800f87 <strtol+0x141>
  800f80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f83:	f7 d8                	neg    %eax
  800f85:	eb 03                	jmp    800f8a <strtol+0x144>
  800f87:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f8a:	c9                   	leave  
  800f8b:	c3                   	ret    

00800f8c <ltostr>:

void
ltostr(long value, char *str)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f99:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800fa0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fa4:	79 13                	jns    800fb9 <ltostr+0x2d>
	{
		neg = 1;
  800fa6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fb3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fb6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fc1:	99                   	cltd   
  800fc2:	f7 f9                	idiv   %ecx
  800fc4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fca:	8d 50 01             	lea    0x1(%eax),%edx
  800fcd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fd0:	89 c2                	mov    %eax,%edx
  800fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd5:	01 d0                	add    %edx,%eax
  800fd7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fda:	83 c2 30             	add    $0x30,%edx
  800fdd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fdf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fe2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fe7:	f7 e9                	imul   %ecx
  800fe9:	c1 fa 02             	sar    $0x2,%edx
  800fec:	89 c8                	mov    %ecx,%eax
  800fee:	c1 f8 1f             	sar    $0x1f,%eax
  800ff1:	29 c2                	sub    %eax,%edx
  800ff3:	89 d0                	mov    %edx,%eax
  800ff5:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800ff8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ffc:	75 bb                	jne    800fb9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800ffe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801005:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801008:	48                   	dec    %eax
  801009:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80100c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801010:	74 3d                	je     80104f <ltostr+0xc3>
		start = 1 ;
  801012:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801019:	eb 34                	jmp    80104f <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80101b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80101e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801021:	01 d0                	add    %edx,%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801028:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80102b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102e:	01 c2                	add    %eax,%edx
  801030:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	01 c8                	add    %ecx,%eax
  801038:	8a 00                	mov    (%eax),%al
  80103a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80103c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80103f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801042:	01 c2                	add    %eax,%edx
  801044:	8a 45 eb             	mov    -0x15(%ebp),%al
  801047:	88 02                	mov    %al,(%edx)
		start++ ;
  801049:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80104c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80104f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801052:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801055:	7c c4                	jl     80101b <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801057:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80105a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105d:	01 d0                	add    %edx,%eax
  80105f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801062:	90                   	nop
  801063:	c9                   	leave  
  801064:	c3                   	ret    

00801065 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801065:	55                   	push   %ebp
  801066:	89 e5                	mov    %esp,%ebp
  801068:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80106b:	ff 75 08             	pushl  0x8(%ebp)
  80106e:	e8 c4 f9 ff ff       	call   800a37 <strlen>
  801073:	83 c4 04             	add    $0x4,%esp
  801076:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801079:	ff 75 0c             	pushl  0xc(%ebp)
  80107c:	e8 b6 f9 ff ff       	call   800a37 <strlen>
  801081:	83 c4 04             	add    $0x4,%esp
  801084:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801087:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80108e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801095:	eb 17                	jmp    8010ae <strcconcat+0x49>
		final[s] = str1[s] ;
  801097:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80109a:	8b 45 10             	mov    0x10(%ebp),%eax
  80109d:	01 c2                	add    %eax,%edx
  80109f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	01 c8                	add    %ecx,%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010ab:	ff 45 fc             	incl   -0x4(%ebp)
  8010ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010b4:	7c e1                	jl     801097 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010b6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010bd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010c4:	eb 1f                	jmp    8010e5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c9:	8d 50 01             	lea    0x1(%eax),%edx
  8010cc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010cf:	89 c2                	mov    %eax,%edx
  8010d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d4:	01 c2                	add    %eax,%edx
  8010d6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dc:	01 c8                	add    %ecx,%eax
  8010de:	8a 00                	mov    (%eax),%al
  8010e0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010e2:	ff 45 f8             	incl   -0x8(%ebp)
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010eb:	7c d9                	jl     8010c6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	c6 00 00             	movb   $0x0,(%eax)
}
  8010f8:	90                   	nop
  8010f9:	c9                   	leave  
  8010fa:	c3                   	ret    

008010fb <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8010fb:	55                   	push   %ebp
  8010fc:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8010fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801101:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801107:	8b 45 14             	mov    0x14(%ebp),%eax
  80110a:	8b 00                	mov    (%eax),%eax
  80110c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801113:	8b 45 10             	mov    0x10(%ebp),%eax
  801116:	01 d0                	add    %edx,%eax
  801118:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80111e:	eb 0c                	jmp    80112c <strsplit+0x31>
			*string++ = 0;
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
  801123:	8d 50 01             	lea    0x1(%eax),%edx
  801126:	89 55 08             	mov    %edx,0x8(%ebp)
  801129:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	8a 00                	mov    (%eax),%al
  801131:	84 c0                	test   %al,%al
  801133:	74 18                	je     80114d <strsplit+0x52>
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8a 00                	mov    (%eax),%al
  80113a:	0f be c0             	movsbl %al,%eax
  80113d:	50                   	push   %eax
  80113e:	ff 75 0c             	pushl  0xc(%ebp)
  801141:	e8 83 fa ff ff       	call   800bc9 <strchr>
  801146:	83 c4 08             	add    $0x8,%esp
  801149:	85 c0                	test   %eax,%eax
  80114b:	75 d3                	jne    801120 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80114d:	8b 45 08             	mov    0x8(%ebp),%eax
  801150:	8a 00                	mov    (%eax),%al
  801152:	84 c0                	test   %al,%al
  801154:	74 5a                	je     8011b0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801156:	8b 45 14             	mov    0x14(%ebp),%eax
  801159:	8b 00                	mov    (%eax),%eax
  80115b:	83 f8 0f             	cmp    $0xf,%eax
  80115e:	75 07                	jne    801167 <strsplit+0x6c>
		{
			return 0;
  801160:	b8 00 00 00 00       	mov    $0x0,%eax
  801165:	eb 66                	jmp    8011cd <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801167:	8b 45 14             	mov    0x14(%ebp),%eax
  80116a:	8b 00                	mov    (%eax),%eax
  80116c:	8d 48 01             	lea    0x1(%eax),%ecx
  80116f:	8b 55 14             	mov    0x14(%ebp),%edx
  801172:	89 0a                	mov    %ecx,(%edx)
  801174:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80117b:	8b 45 10             	mov    0x10(%ebp),%eax
  80117e:	01 c2                	add    %eax,%edx
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801185:	eb 03                	jmp    80118a <strsplit+0x8f>
			string++;
  801187:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	84 c0                	test   %al,%al
  801191:	74 8b                	je     80111e <strsplit+0x23>
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	8a 00                	mov    (%eax),%al
  801198:	0f be c0             	movsbl %al,%eax
  80119b:	50                   	push   %eax
  80119c:	ff 75 0c             	pushl  0xc(%ebp)
  80119f:	e8 25 fa ff ff       	call   800bc9 <strchr>
  8011a4:	83 c4 08             	add    $0x8,%esp
  8011a7:	85 c0                	test   %eax,%eax
  8011a9:	74 dc                	je     801187 <strsplit+0x8c>
			string++;
	}
  8011ab:	e9 6e ff ff ff       	jmp    80111e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011b0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b4:	8b 00                	mov    (%eax),%eax
  8011b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c0:	01 d0                	add    %edx,%eax
  8011c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011c8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011cd:	c9                   	leave  
  8011ce:	c3                   	ret    

008011cf <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8011db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011e2:	eb 4a                	jmp    80122e <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8011e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	01 c2                	add    %eax,%edx
  8011ec:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f2:	01 c8                	add    %ecx,%eax
  8011f4:	8a 00                	mov    (%eax),%al
  8011f6:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8011f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fe:	01 d0                	add    %edx,%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	3c 40                	cmp    $0x40,%al
  801204:	7e 25                	jle    80122b <str2lower+0x5c>
  801206:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801209:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120c:	01 d0                	add    %edx,%eax
  80120e:	8a 00                	mov    (%eax),%al
  801210:	3c 5a                	cmp    $0x5a,%al
  801212:	7f 17                	jg     80122b <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801214:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	01 d0                	add    %edx,%eax
  80121c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80121f:	8b 55 08             	mov    0x8(%ebp),%edx
  801222:	01 ca                	add    %ecx,%edx
  801224:	8a 12                	mov    (%edx),%dl
  801226:	83 c2 20             	add    $0x20,%edx
  801229:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80122b:	ff 45 fc             	incl   -0x4(%ebp)
  80122e:	ff 75 0c             	pushl  0xc(%ebp)
  801231:	e8 01 f8 ff ff       	call   800a37 <strlen>
  801236:	83 c4 04             	add    $0x4,%esp
  801239:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80123c:	7f a6                	jg     8011e4 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80123e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801241:	c9                   	leave  
  801242:	c3                   	ret    

00801243 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	57                   	push   %edi
  801247:	56                   	push   %esi
  801248:	53                   	push   %ebx
  801249:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801252:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801255:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801258:	8b 7d 18             	mov    0x18(%ebp),%edi
  80125b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80125e:	cd 30                	int    $0x30
  801260:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801263:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801266:	83 c4 10             	add    $0x10,%esp
  801269:	5b                   	pop    %ebx
  80126a:	5e                   	pop    %esi
  80126b:	5f                   	pop    %edi
  80126c:	5d                   	pop    %ebp
  80126d:	c3                   	ret    

0080126e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
  801271:	83 ec 04             	sub    $0x4,%esp
  801274:	8b 45 10             	mov    0x10(%ebp),%eax
  801277:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80127a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80127d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	6a 00                	push   $0x0
  801286:	51                   	push   %ecx
  801287:	52                   	push   %edx
  801288:	ff 75 0c             	pushl  0xc(%ebp)
  80128b:	50                   	push   %eax
  80128c:	6a 00                	push   $0x0
  80128e:	e8 b0 ff ff ff       	call   801243 <syscall>
  801293:	83 c4 18             	add    $0x18,%esp
}
  801296:	90                   	nop
  801297:	c9                   	leave  
  801298:	c3                   	ret    

00801299 <sys_cgetc>:

int
sys_cgetc(void)
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80129c:	6a 00                	push   $0x0
  80129e:	6a 00                	push   $0x0
  8012a0:	6a 00                	push   $0x0
  8012a2:	6a 00                	push   $0x0
  8012a4:	6a 00                	push   $0x0
  8012a6:	6a 02                	push   $0x2
  8012a8:	e8 96 ff ff ff       	call   801243 <syscall>
  8012ad:	83 c4 18             	add    $0x18,%esp
}
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    

008012b2 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8012b5:	6a 00                	push   $0x0
  8012b7:	6a 00                	push   $0x0
  8012b9:	6a 00                	push   $0x0
  8012bb:	6a 00                	push   $0x0
  8012bd:	6a 00                	push   $0x0
  8012bf:	6a 03                	push   $0x3
  8012c1:	e8 7d ff ff ff       	call   801243 <syscall>
  8012c6:	83 c4 18             	add    $0x18,%esp
}
  8012c9:	90                   	nop
  8012ca:	c9                   	leave  
  8012cb:	c3                   	ret    

008012cc <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8012cf:	6a 00                	push   $0x0
  8012d1:	6a 00                	push   $0x0
  8012d3:	6a 00                	push   $0x0
  8012d5:	6a 00                	push   $0x0
  8012d7:	6a 00                	push   $0x0
  8012d9:	6a 04                	push   $0x4
  8012db:	e8 63 ff ff ff       	call   801243 <syscall>
  8012e0:	83 c4 18             	add    $0x18,%esp
}
  8012e3:	90                   	nop
  8012e4:	c9                   	leave  
  8012e5:	c3                   	ret    

008012e6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ef:	6a 00                	push   $0x0
  8012f1:	6a 00                	push   $0x0
  8012f3:	6a 00                	push   $0x0
  8012f5:	52                   	push   %edx
  8012f6:	50                   	push   %eax
  8012f7:	6a 08                	push   $0x8
  8012f9:	e8 45 ff ff ff       	call   801243 <syscall>
  8012fe:	83 c4 18             	add    $0x18,%esp
}
  801301:	c9                   	leave  
  801302:	c3                   	ret    

00801303 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
  801306:	56                   	push   %esi
  801307:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801308:	8b 75 18             	mov    0x18(%ebp),%esi
  80130b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80130e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801311:	8b 55 0c             	mov    0xc(%ebp),%edx
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	56                   	push   %esi
  801318:	53                   	push   %ebx
  801319:	51                   	push   %ecx
  80131a:	52                   	push   %edx
  80131b:	50                   	push   %eax
  80131c:	6a 09                	push   $0x9
  80131e:	e8 20 ff ff ff       	call   801243 <syscall>
  801323:	83 c4 18             	add    $0x18,%esp
}
  801326:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801329:	5b                   	pop    %ebx
  80132a:	5e                   	pop    %esi
  80132b:	5d                   	pop    %ebp
  80132c:	c3                   	ret    

0080132d <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801330:	6a 00                	push   $0x0
  801332:	6a 00                	push   $0x0
  801334:	6a 00                	push   $0x0
  801336:	6a 00                	push   $0x0
  801338:	ff 75 08             	pushl  0x8(%ebp)
  80133b:	6a 0a                	push   $0xa
  80133d:	e8 01 ff ff ff       	call   801243 <syscall>
  801342:	83 c4 18             	add    $0x18,%esp
}
  801345:	c9                   	leave  
  801346:	c3                   	ret    

00801347 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801347:	55                   	push   %ebp
  801348:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80134a:	6a 00                	push   $0x0
  80134c:	6a 00                	push   $0x0
  80134e:	6a 00                	push   $0x0
  801350:	ff 75 0c             	pushl  0xc(%ebp)
  801353:	ff 75 08             	pushl  0x8(%ebp)
  801356:	6a 0b                	push   $0xb
  801358:	e8 e6 fe ff ff       	call   801243 <syscall>
  80135d:	83 c4 18             	add    $0x18,%esp
}
  801360:	c9                   	leave  
  801361:	c3                   	ret    

00801362 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801362:	55                   	push   %ebp
  801363:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801365:	6a 00                	push   $0x0
  801367:	6a 00                	push   $0x0
  801369:	6a 00                	push   $0x0
  80136b:	6a 00                	push   $0x0
  80136d:	6a 00                	push   $0x0
  80136f:	6a 0c                	push   $0xc
  801371:	e8 cd fe ff ff       	call   801243 <syscall>
  801376:	83 c4 18             	add    $0x18,%esp
}
  801379:	c9                   	leave  
  80137a:	c3                   	ret    

0080137b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80137e:	6a 00                	push   $0x0
  801380:	6a 00                	push   $0x0
  801382:	6a 00                	push   $0x0
  801384:	6a 00                	push   $0x0
  801386:	6a 00                	push   $0x0
  801388:	6a 0d                	push   $0xd
  80138a:	e8 b4 fe ff ff       	call   801243 <syscall>
  80138f:	83 c4 18             	add    $0x18,%esp
}
  801392:	c9                   	leave  
  801393:	c3                   	ret    

00801394 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801397:	6a 00                	push   $0x0
  801399:	6a 00                	push   $0x0
  80139b:	6a 00                	push   $0x0
  80139d:	6a 00                	push   $0x0
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 0e                	push   $0xe
  8013a3:	e8 9b fe ff ff       	call   801243 <syscall>
  8013a8:	83 c4 18             	add    $0x18,%esp
}
  8013ab:	c9                   	leave  
  8013ac:	c3                   	ret    

008013ad <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8013ad:	55                   	push   %ebp
  8013ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013b0:	6a 00                	push   $0x0
  8013b2:	6a 00                	push   $0x0
  8013b4:	6a 00                	push   $0x0
  8013b6:	6a 00                	push   $0x0
  8013b8:	6a 00                	push   $0x0
  8013ba:	6a 0f                	push   $0xf
  8013bc:	e8 82 fe ff ff       	call   801243 <syscall>
  8013c1:	83 c4 18             	add    $0x18,%esp
}
  8013c4:	c9                   	leave  
  8013c5:	c3                   	ret    

008013c6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 00                	push   $0x0
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 00                	push   $0x0
  8013d1:	ff 75 08             	pushl  0x8(%ebp)
  8013d4:	6a 10                	push   $0x10
  8013d6:	e8 68 fe ff ff       	call   801243 <syscall>
  8013db:	83 c4 18             	add    $0x18,%esp
}
  8013de:	c9                   	leave  
  8013df:	c3                   	ret    

008013e0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 11                	push   $0x11
  8013ef:	e8 4f fe ff ff       	call   801243 <syscall>
  8013f4:	83 c4 18             	add    $0x18,%esp
}
  8013f7:	90                   	nop
  8013f8:	c9                   	leave  
  8013f9:	c3                   	ret    

008013fa <sys_cputc>:

void
sys_cputc(const char c)
{
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
  8013fd:	83 ec 04             	sub    $0x4,%esp
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801406:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80140a:	6a 00                	push   $0x0
  80140c:	6a 00                	push   $0x0
  80140e:	6a 00                	push   $0x0
  801410:	6a 00                	push   $0x0
  801412:	50                   	push   %eax
  801413:	6a 01                	push   $0x1
  801415:	e8 29 fe ff ff       	call   801243 <syscall>
  80141a:	83 c4 18             	add    $0x18,%esp
}
  80141d:	90                   	nop
  80141e:	c9                   	leave  
  80141f:	c3                   	ret    

00801420 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801423:	6a 00                	push   $0x0
  801425:	6a 00                	push   $0x0
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	6a 14                	push   $0x14
  80142f:	e8 0f fe ff ff       	call   801243 <syscall>
  801434:	83 c4 18             	add    $0x18,%esp
}
  801437:	90                   	nop
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 04             	sub    $0x4,%esp
  801440:	8b 45 10             	mov    0x10(%ebp),%eax
  801443:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801446:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801449:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
  801450:	6a 00                	push   $0x0
  801452:	51                   	push   %ecx
  801453:	52                   	push   %edx
  801454:	ff 75 0c             	pushl  0xc(%ebp)
  801457:	50                   	push   %eax
  801458:	6a 15                	push   $0x15
  80145a:	e8 e4 fd ff ff       	call   801243 <syscall>
  80145f:	83 c4 18             	add    $0x18,%esp
}
  801462:	c9                   	leave  
  801463:	c3                   	ret    

00801464 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801467:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	52                   	push   %edx
  801474:	50                   	push   %eax
  801475:	6a 16                	push   $0x16
  801477:	e8 c7 fd ff ff       	call   801243 <syscall>
  80147c:	83 c4 18             	add    $0x18,%esp
}
  80147f:	c9                   	leave  
  801480:	c3                   	ret    

00801481 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801484:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801487:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148a:	8b 45 08             	mov    0x8(%ebp),%eax
  80148d:	6a 00                	push   $0x0
  80148f:	6a 00                	push   $0x0
  801491:	51                   	push   %ecx
  801492:	52                   	push   %edx
  801493:	50                   	push   %eax
  801494:	6a 17                	push   $0x17
  801496:	e8 a8 fd ff ff       	call   801243 <syscall>
  80149b:	83 c4 18             	add    $0x18,%esp
}
  80149e:	c9                   	leave  
  80149f:	c3                   	ret    

008014a0 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8014a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	52                   	push   %edx
  8014b0:	50                   	push   %eax
  8014b1:	6a 18                	push   $0x18
  8014b3:	e8 8b fd ff ff       	call   801243 <syscall>
  8014b8:	83 c4 18             	add    $0x18,%esp
}
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    

008014bd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	6a 00                	push   $0x0
  8014c5:	ff 75 14             	pushl  0x14(%ebp)
  8014c8:	ff 75 10             	pushl  0x10(%ebp)
  8014cb:	ff 75 0c             	pushl  0xc(%ebp)
  8014ce:	50                   	push   %eax
  8014cf:	6a 19                	push   $0x19
  8014d1:	e8 6d fd ff ff       	call   801243 <syscall>
  8014d6:	83 c4 18             	add    $0x18,%esp
}
  8014d9:	c9                   	leave  
  8014da:	c3                   	ret    

008014db <sys_run_env>:

void sys_run_env(int32 envId)
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	6a 00                	push   $0x0
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	50                   	push   %eax
  8014ea:	6a 1a                	push   $0x1a
  8014ec:	e8 52 fd ff ff       	call   801243 <syscall>
  8014f1:	83 c4 18             	add    $0x18,%esp
}
  8014f4:	90                   	nop
  8014f5:	c9                   	leave  
  8014f6:	c3                   	ret    

008014f7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	50                   	push   %eax
  801506:	6a 1b                	push   $0x1b
  801508:	e8 36 fd ff ff       	call   801243 <syscall>
  80150d:	83 c4 18             	add    $0x18,%esp
}
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	6a 00                	push   $0x0
  80151f:	6a 05                	push   $0x5
  801521:	e8 1d fd ff ff       	call   801243 <syscall>
  801526:	83 c4 18             	add    $0x18,%esp
}
  801529:	c9                   	leave  
  80152a:	c3                   	ret    

0080152b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80152b:	55                   	push   %ebp
  80152c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	6a 00                	push   $0x0
  801534:	6a 00                	push   $0x0
  801536:	6a 00                	push   $0x0
  801538:	6a 06                	push   $0x6
  80153a:	e8 04 fd ff ff       	call   801243 <syscall>
  80153f:	83 c4 18             	add    $0x18,%esp
}
  801542:	c9                   	leave  
  801543:	c3                   	ret    

00801544 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801544:	55                   	push   %ebp
  801545:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	6a 00                	push   $0x0
  801551:	6a 07                	push   $0x7
  801553:	e8 eb fc ff ff       	call   801243 <syscall>
  801558:	83 c4 18             	add    $0x18,%esp
}
  80155b:	c9                   	leave  
  80155c:	c3                   	ret    

0080155d <sys_exit_env>:


void sys_exit_env(void)
{
  80155d:	55                   	push   %ebp
  80155e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	6a 00                	push   $0x0
  80156a:	6a 1c                	push   $0x1c
  80156c:	e8 d2 fc ff ff       	call   801243 <syscall>
  801571:	83 c4 18             	add    $0x18,%esp
}
  801574:	90                   	nop
  801575:	c9                   	leave  
  801576:	c3                   	ret    

00801577 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80157d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801580:	8d 50 04             	lea    0x4(%eax),%edx
  801583:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	52                   	push   %edx
  80158d:	50                   	push   %eax
  80158e:	6a 1d                	push   $0x1d
  801590:	e8 ae fc ff ff       	call   801243 <syscall>
  801595:	83 c4 18             	add    $0x18,%esp
	return result;
  801598:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80159b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80159e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015a1:	89 01                	mov    %eax,(%ecx)
  8015a3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	c9                   	leave  
  8015aa:	c2 04 00             	ret    $0x4

008015ad <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	ff 75 10             	pushl  0x10(%ebp)
  8015b7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ba:	ff 75 08             	pushl  0x8(%ebp)
  8015bd:	6a 13                	push   $0x13
  8015bf:	e8 7f fc ff ff       	call   801243 <syscall>
  8015c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8015c7:	90                   	nop
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <sys_rcr2>:
uint32 sys_rcr2()
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 1e                	push   $0x1e
  8015d9:	e8 65 fc ff ff       	call   801243 <syscall>
  8015de:	83 c4 18             	add    $0x18,%esp
}
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	83 ec 04             	sub    $0x4,%esp
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015ef:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	50                   	push   %eax
  8015fc:	6a 1f                	push   $0x1f
  8015fe:	e8 40 fc ff ff       	call   801243 <syscall>
  801603:	83 c4 18             	add    $0x18,%esp
	return ;
  801606:	90                   	nop
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <rsttst>:
void rsttst()
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 21                	push   $0x21
  801618:	e8 26 fc ff ff       	call   801243 <syscall>
  80161d:	83 c4 18             	add    $0x18,%esp
	return ;
  801620:	90                   	nop
}
  801621:	c9                   	leave  
  801622:	c3                   	ret    

00801623 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
  801626:	83 ec 04             	sub    $0x4,%esp
  801629:	8b 45 14             	mov    0x14(%ebp),%eax
  80162c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80162f:	8b 55 18             	mov    0x18(%ebp),%edx
  801632:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801636:	52                   	push   %edx
  801637:	50                   	push   %eax
  801638:	ff 75 10             	pushl  0x10(%ebp)
  80163b:	ff 75 0c             	pushl  0xc(%ebp)
  80163e:	ff 75 08             	pushl  0x8(%ebp)
  801641:	6a 20                	push   $0x20
  801643:	e8 fb fb ff ff       	call   801243 <syscall>
  801648:	83 c4 18             	add    $0x18,%esp
	return ;
  80164b:	90                   	nop
}
  80164c:	c9                   	leave  
  80164d:	c3                   	ret    

0080164e <chktst>:
void chktst(uint32 n)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	ff 75 08             	pushl  0x8(%ebp)
  80165c:	6a 22                	push   $0x22
  80165e:	e8 e0 fb ff ff       	call   801243 <syscall>
  801663:	83 c4 18             	add    $0x18,%esp
	return ;
  801666:	90                   	nop
}
  801667:	c9                   	leave  
  801668:	c3                   	ret    

00801669 <inctst>:

void inctst()
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 23                	push   $0x23
  801678:	e8 c6 fb ff ff       	call   801243 <syscall>
  80167d:	83 c4 18             	add    $0x18,%esp
	return ;
  801680:	90                   	nop
}
  801681:	c9                   	leave  
  801682:	c3                   	ret    

00801683 <gettst>:
uint32 gettst()
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 24                	push   $0x24
  801692:	e8 ac fb ff ff       	call   801243 <syscall>
  801697:	83 c4 18             	add    $0x18,%esp
}
  80169a:	c9                   	leave  
  80169b:	c3                   	ret    

0080169c <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 25                	push   $0x25
  8016ab:	e8 93 fb ff ff       	call   801243 <syscall>
  8016b0:	83 c4 18             	add    $0x18,%esp
  8016b3:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8016b8:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8016bd:	c9                   	leave  
  8016be:	c3                   	ret    

008016bf <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	ff 75 08             	pushl  0x8(%ebp)
  8016d5:	6a 26                	push   $0x26
  8016d7:	e8 67 fb ff ff       	call   801243 <syscall>
  8016dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8016df:	90                   	nop
}
  8016e0:	c9                   	leave  
  8016e1:	c3                   	ret    

008016e2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8016e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	6a 00                	push   $0x0
  8016f4:	53                   	push   %ebx
  8016f5:	51                   	push   %ecx
  8016f6:	52                   	push   %edx
  8016f7:	50                   	push   %eax
  8016f8:	6a 27                	push   $0x27
  8016fa:	e8 44 fb ff ff       	call   801243 <syscall>
  8016ff:	83 c4 18             	add    $0x18,%esp
}
  801702:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801705:	c9                   	leave  
  801706:	c3                   	ret    

00801707 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80170a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170d:	8b 45 08             	mov    0x8(%ebp),%eax
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	52                   	push   %edx
  801717:	50                   	push   %eax
  801718:	6a 28                	push   $0x28
  80171a:	e8 24 fb ff ff       	call   801243 <syscall>
  80171f:	83 c4 18             	add    $0x18,%esp
}
  801722:	c9                   	leave  
  801723:	c3                   	ret    

00801724 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801727:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80172a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172d:	8b 45 08             	mov    0x8(%ebp),%eax
  801730:	6a 00                	push   $0x0
  801732:	51                   	push   %ecx
  801733:	ff 75 10             	pushl  0x10(%ebp)
  801736:	52                   	push   %edx
  801737:	50                   	push   %eax
  801738:	6a 29                	push   $0x29
  80173a:	e8 04 fb ff ff       	call   801243 <syscall>
  80173f:	83 c4 18             	add    $0x18,%esp
}
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	ff 75 10             	pushl  0x10(%ebp)
  80174e:	ff 75 0c             	pushl  0xc(%ebp)
  801751:	ff 75 08             	pushl  0x8(%ebp)
  801754:	6a 12                	push   $0x12
  801756:	e8 e8 fa ff ff       	call   801243 <syscall>
  80175b:	83 c4 18             	add    $0x18,%esp
	return ;
  80175e:	90                   	nop
}
  80175f:	c9                   	leave  
  801760:	c3                   	ret    

00801761 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801764:	8b 55 0c             	mov    0xc(%ebp),%edx
  801767:	8b 45 08             	mov    0x8(%ebp),%eax
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	52                   	push   %edx
  801771:	50                   	push   %eax
  801772:	6a 2a                	push   $0x2a
  801774:	e8 ca fa ff ff       	call   801243 <syscall>
  801779:	83 c4 18             	add    $0x18,%esp
	return;
  80177c:	90                   	nop
}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 2b                	push   $0x2b
  80178e:	e8 b0 fa ff ff       	call   801243 <syscall>
  801793:	83 c4 18             	add    $0x18,%esp
}
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	ff 75 0c             	pushl  0xc(%ebp)
  8017a4:	ff 75 08             	pushl  0x8(%ebp)
  8017a7:	6a 2d                	push   $0x2d
  8017a9:	e8 95 fa ff ff       	call   801243 <syscall>
  8017ae:	83 c4 18             	add    $0x18,%esp
	return;
  8017b1:	90                   	nop
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	ff 75 0c             	pushl  0xc(%ebp)
  8017c0:	ff 75 08             	pushl  0x8(%ebp)
  8017c3:	6a 2c                	push   $0x2c
  8017c5:	e8 79 fa ff ff       	call   801243 <syscall>
  8017ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8017cd:	90                   	nop
}
  8017ce:	c9                   	leave  
  8017cf:	c3                   	ret    

008017d0 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
  8017d3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8017d6:	83 ec 04             	sub    $0x4,%esp
  8017d9:	68 68 21 80 00       	push   $0x802168
  8017de:	68 25 01 00 00       	push   $0x125
  8017e3:	68 9b 21 80 00       	push   $0x80219b
  8017e8:	e8 00 00 00 00       	call   8017ed <_panic>

008017ed <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
  8017f0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8017f3:	8d 45 10             	lea    0x10(%ebp),%eax
  8017f6:	83 c0 04             	add    $0x4,%eax
  8017f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8017fc:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801801:	85 c0                	test   %eax,%eax
  801803:	74 16                	je     80181b <_panic+0x2e>
		cprintf("%s: ", argv0);
  801805:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  80180a:	83 ec 08             	sub    $0x8,%esp
  80180d:	50                   	push   %eax
  80180e:	68 ac 21 80 00       	push   $0x8021ac
  801813:	e8 46 eb ff ff       	call   80035e <cprintf>
  801818:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80181b:	a1 04 30 80 00       	mov    0x803004,%eax
  801820:	83 ec 0c             	sub    $0xc,%esp
  801823:	ff 75 0c             	pushl  0xc(%ebp)
  801826:	ff 75 08             	pushl  0x8(%ebp)
  801829:	50                   	push   %eax
  80182a:	68 b4 21 80 00       	push   $0x8021b4
  80182f:	6a 74                	push   $0x74
  801831:	e8 55 eb ff ff       	call   80038b <cprintf_colored>
  801836:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801839:	8b 45 10             	mov    0x10(%ebp),%eax
  80183c:	83 ec 08             	sub    $0x8,%esp
  80183f:	ff 75 f4             	pushl  -0xc(%ebp)
  801842:	50                   	push   %eax
  801843:	e8 a7 ea ff ff       	call   8002ef <vcprintf>
  801848:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80184b:	83 ec 08             	sub    $0x8,%esp
  80184e:	6a 00                	push   $0x0
  801850:	68 dc 21 80 00       	push   $0x8021dc
  801855:	e8 95 ea ff ff       	call   8002ef <vcprintf>
  80185a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80185d:	e8 0e ea ff ff       	call   800270 <exit>

	// should not return here
	while (1) ;
  801862:	eb fe                	jmp    801862 <_panic+0x75>

00801864 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80186a:	a1 20 30 80 00       	mov    0x803020,%eax
  80186f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801875:	8b 45 0c             	mov    0xc(%ebp),%eax
  801878:	39 c2                	cmp    %eax,%edx
  80187a:	74 14                	je     801890 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80187c:	83 ec 04             	sub    $0x4,%esp
  80187f:	68 e0 21 80 00       	push   $0x8021e0
  801884:	6a 26                	push   $0x26
  801886:	68 2c 22 80 00       	push   $0x80222c
  80188b:	e8 5d ff ff ff       	call   8017ed <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801890:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801897:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80189e:	e9 c5 00 00 00       	jmp    801968 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8018a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b0:	01 d0                	add    %edx,%eax
  8018b2:	8b 00                	mov    (%eax),%eax
  8018b4:	85 c0                	test   %eax,%eax
  8018b6:	75 08                	jne    8018c0 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8018b8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8018bb:	e9 a5 00 00 00       	jmp    801965 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8018c0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018c7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8018ce:	eb 69                	jmp    801939 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8018d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8018d5:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8018db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018de:	89 d0                	mov    %edx,%eax
  8018e0:	01 c0                	add    %eax,%eax
  8018e2:	01 d0                	add    %edx,%eax
  8018e4:	c1 e0 03             	shl    $0x3,%eax
  8018e7:	01 c8                	add    %ecx,%eax
  8018e9:	8a 40 04             	mov    0x4(%eax),%al
  8018ec:	84 c0                	test   %al,%al
  8018ee:	75 46                	jne    801936 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018f0:	a1 20 30 80 00       	mov    0x803020,%eax
  8018f5:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8018fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018fe:	89 d0                	mov    %edx,%eax
  801900:	01 c0                	add    %eax,%eax
  801902:	01 d0                	add    %edx,%eax
  801904:	c1 e0 03             	shl    $0x3,%eax
  801907:	01 c8                	add    %ecx,%eax
  801909:	8b 00                	mov    (%eax),%eax
  80190b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80190e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801911:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801916:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801918:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	01 c8                	add    %ecx,%eax
  801927:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801929:	39 c2                	cmp    %eax,%edx
  80192b:	75 09                	jne    801936 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80192d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801934:	eb 15                	jmp    80194b <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801936:	ff 45 e8             	incl   -0x18(%ebp)
  801939:	a1 20 30 80 00       	mov    0x803020,%eax
  80193e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801944:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801947:	39 c2                	cmp    %eax,%edx
  801949:	77 85                	ja     8018d0 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80194b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80194f:	75 14                	jne    801965 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801951:	83 ec 04             	sub    $0x4,%esp
  801954:	68 38 22 80 00       	push   $0x802238
  801959:	6a 3a                	push   $0x3a
  80195b:	68 2c 22 80 00       	push   $0x80222c
  801960:	e8 88 fe ff ff       	call   8017ed <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801965:	ff 45 f0             	incl   -0x10(%ebp)
  801968:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80196b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80196e:	0f 8c 2f ff ff ff    	jl     8018a3 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801974:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80197b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801982:	eb 26                	jmp    8019aa <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801984:	a1 20 30 80 00       	mov    0x803020,%eax
  801989:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80198f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801992:	89 d0                	mov    %edx,%eax
  801994:	01 c0                	add    %eax,%eax
  801996:	01 d0                	add    %edx,%eax
  801998:	c1 e0 03             	shl    $0x3,%eax
  80199b:	01 c8                	add    %ecx,%eax
  80199d:	8a 40 04             	mov    0x4(%eax),%al
  8019a0:	3c 01                	cmp    $0x1,%al
  8019a2:	75 03                	jne    8019a7 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8019a4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019a7:	ff 45 e0             	incl   -0x20(%ebp)
  8019aa:	a1 20 30 80 00       	mov    0x803020,%eax
  8019af:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8019b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019b8:	39 c2                	cmp    %eax,%edx
  8019ba:	77 c8                	ja     801984 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8019bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019bf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8019c2:	74 14                	je     8019d8 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8019c4:	83 ec 04             	sub    $0x4,%esp
  8019c7:	68 8c 22 80 00       	push   $0x80228c
  8019cc:	6a 44                	push   $0x44
  8019ce:	68 2c 22 80 00       	push   $0x80222c
  8019d3:	e8 15 fe ff ff       	call   8017ed <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8019d8:	90                   	nop
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    
  8019db:	90                   	nop

008019dc <__udivdi3>:
  8019dc:	55                   	push   %ebp
  8019dd:	57                   	push   %edi
  8019de:	56                   	push   %esi
  8019df:	53                   	push   %ebx
  8019e0:	83 ec 1c             	sub    $0x1c,%esp
  8019e3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019e7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019f3:	89 ca                	mov    %ecx,%edx
  8019f5:	89 f8                	mov    %edi,%eax
  8019f7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019fb:	85 f6                	test   %esi,%esi
  8019fd:	75 2d                	jne    801a2c <__udivdi3+0x50>
  8019ff:	39 cf                	cmp    %ecx,%edi
  801a01:	77 65                	ja     801a68 <__udivdi3+0x8c>
  801a03:	89 fd                	mov    %edi,%ebp
  801a05:	85 ff                	test   %edi,%edi
  801a07:	75 0b                	jne    801a14 <__udivdi3+0x38>
  801a09:	b8 01 00 00 00       	mov    $0x1,%eax
  801a0e:	31 d2                	xor    %edx,%edx
  801a10:	f7 f7                	div    %edi
  801a12:	89 c5                	mov    %eax,%ebp
  801a14:	31 d2                	xor    %edx,%edx
  801a16:	89 c8                	mov    %ecx,%eax
  801a18:	f7 f5                	div    %ebp
  801a1a:	89 c1                	mov    %eax,%ecx
  801a1c:	89 d8                	mov    %ebx,%eax
  801a1e:	f7 f5                	div    %ebp
  801a20:	89 cf                	mov    %ecx,%edi
  801a22:	89 fa                	mov    %edi,%edx
  801a24:	83 c4 1c             	add    $0x1c,%esp
  801a27:	5b                   	pop    %ebx
  801a28:	5e                   	pop    %esi
  801a29:	5f                   	pop    %edi
  801a2a:	5d                   	pop    %ebp
  801a2b:	c3                   	ret    
  801a2c:	39 ce                	cmp    %ecx,%esi
  801a2e:	77 28                	ja     801a58 <__udivdi3+0x7c>
  801a30:	0f bd fe             	bsr    %esi,%edi
  801a33:	83 f7 1f             	xor    $0x1f,%edi
  801a36:	75 40                	jne    801a78 <__udivdi3+0x9c>
  801a38:	39 ce                	cmp    %ecx,%esi
  801a3a:	72 0a                	jb     801a46 <__udivdi3+0x6a>
  801a3c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a40:	0f 87 9e 00 00 00    	ja     801ae4 <__udivdi3+0x108>
  801a46:	b8 01 00 00 00       	mov    $0x1,%eax
  801a4b:	89 fa                	mov    %edi,%edx
  801a4d:	83 c4 1c             	add    $0x1c,%esp
  801a50:	5b                   	pop    %ebx
  801a51:	5e                   	pop    %esi
  801a52:	5f                   	pop    %edi
  801a53:	5d                   	pop    %ebp
  801a54:	c3                   	ret    
  801a55:	8d 76 00             	lea    0x0(%esi),%esi
  801a58:	31 ff                	xor    %edi,%edi
  801a5a:	31 c0                	xor    %eax,%eax
  801a5c:	89 fa                	mov    %edi,%edx
  801a5e:	83 c4 1c             	add    $0x1c,%esp
  801a61:	5b                   	pop    %ebx
  801a62:	5e                   	pop    %esi
  801a63:	5f                   	pop    %edi
  801a64:	5d                   	pop    %ebp
  801a65:	c3                   	ret    
  801a66:	66 90                	xchg   %ax,%ax
  801a68:	89 d8                	mov    %ebx,%eax
  801a6a:	f7 f7                	div    %edi
  801a6c:	31 ff                	xor    %edi,%edi
  801a6e:	89 fa                	mov    %edi,%edx
  801a70:	83 c4 1c             	add    $0x1c,%esp
  801a73:	5b                   	pop    %ebx
  801a74:	5e                   	pop    %esi
  801a75:	5f                   	pop    %edi
  801a76:	5d                   	pop    %ebp
  801a77:	c3                   	ret    
  801a78:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a7d:	89 eb                	mov    %ebp,%ebx
  801a7f:	29 fb                	sub    %edi,%ebx
  801a81:	89 f9                	mov    %edi,%ecx
  801a83:	d3 e6                	shl    %cl,%esi
  801a85:	89 c5                	mov    %eax,%ebp
  801a87:	88 d9                	mov    %bl,%cl
  801a89:	d3 ed                	shr    %cl,%ebp
  801a8b:	89 e9                	mov    %ebp,%ecx
  801a8d:	09 f1                	or     %esi,%ecx
  801a8f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a93:	89 f9                	mov    %edi,%ecx
  801a95:	d3 e0                	shl    %cl,%eax
  801a97:	89 c5                	mov    %eax,%ebp
  801a99:	89 d6                	mov    %edx,%esi
  801a9b:	88 d9                	mov    %bl,%cl
  801a9d:	d3 ee                	shr    %cl,%esi
  801a9f:	89 f9                	mov    %edi,%ecx
  801aa1:	d3 e2                	shl    %cl,%edx
  801aa3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801aa7:	88 d9                	mov    %bl,%cl
  801aa9:	d3 e8                	shr    %cl,%eax
  801aab:	09 c2                	or     %eax,%edx
  801aad:	89 d0                	mov    %edx,%eax
  801aaf:	89 f2                	mov    %esi,%edx
  801ab1:	f7 74 24 0c          	divl   0xc(%esp)
  801ab5:	89 d6                	mov    %edx,%esi
  801ab7:	89 c3                	mov    %eax,%ebx
  801ab9:	f7 e5                	mul    %ebp
  801abb:	39 d6                	cmp    %edx,%esi
  801abd:	72 19                	jb     801ad8 <__udivdi3+0xfc>
  801abf:	74 0b                	je     801acc <__udivdi3+0xf0>
  801ac1:	89 d8                	mov    %ebx,%eax
  801ac3:	31 ff                	xor    %edi,%edi
  801ac5:	e9 58 ff ff ff       	jmp    801a22 <__udivdi3+0x46>
  801aca:	66 90                	xchg   %ax,%ax
  801acc:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ad0:	89 f9                	mov    %edi,%ecx
  801ad2:	d3 e2                	shl    %cl,%edx
  801ad4:	39 c2                	cmp    %eax,%edx
  801ad6:	73 e9                	jae    801ac1 <__udivdi3+0xe5>
  801ad8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801adb:	31 ff                	xor    %edi,%edi
  801add:	e9 40 ff ff ff       	jmp    801a22 <__udivdi3+0x46>
  801ae2:	66 90                	xchg   %ax,%ax
  801ae4:	31 c0                	xor    %eax,%eax
  801ae6:	e9 37 ff ff ff       	jmp    801a22 <__udivdi3+0x46>
  801aeb:	90                   	nop

00801aec <__umoddi3>:
  801aec:	55                   	push   %ebp
  801aed:	57                   	push   %edi
  801aee:	56                   	push   %esi
  801aef:	53                   	push   %ebx
  801af0:	83 ec 1c             	sub    $0x1c,%esp
  801af3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801af7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801afb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801aff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b03:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b07:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b0b:	89 f3                	mov    %esi,%ebx
  801b0d:	89 fa                	mov    %edi,%edx
  801b0f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b13:	89 34 24             	mov    %esi,(%esp)
  801b16:	85 c0                	test   %eax,%eax
  801b18:	75 1a                	jne    801b34 <__umoddi3+0x48>
  801b1a:	39 f7                	cmp    %esi,%edi
  801b1c:	0f 86 a2 00 00 00    	jbe    801bc4 <__umoddi3+0xd8>
  801b22:	89 c8                	mov    %ecx,%eax
  801b24:	89 f2                	mov    %esi,%edx
  801b26:	f7 f7                	div    %edi
  801b28:	89 d0                	mov    %edx,%eax
  801b2a:	31 d2                	xor    %edx,%edx
  801b2c:	83 c4 1c             	add    $0x1c,%esp
  801b2f:	5b                   	pop    %ebx
  801b30:	5e                   	pop    %esi
  801b31:	5f                   	pop    %edi
  801b32:	5d                   	pop    %ebp
  801b33:	c3                   	ret    
  801b34:	39 f0                	cmp    %esi,%eax
  801b36:	0f 87 ac 00 00 00    	ja     801be8 <__umoddi3+0xfc>
  801b3c:	0f bd e8             	bsr    %eax,%ebp
  801b3f:	83 f5 1f             	xor    $0x1f,%ebp
  801b42:	0f 84 ac 00 00 00    	je     801bf4 <__umoddi3+0x108>
  801b48:	bf 20 00 00 00       	mov    $0x20,%edi
  801b4d:	29 ef                	sub    %ebp,%edi
  801b4f:	89 fe                	mov    %edi,%esi
  801b51:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b55:	89 e9                	mov    %ebp,%ecx
  801b57:	d3 e0                	shl    %cl,%eax
  801b59:	89 d7                	mov    %edx,%edi
  801b5b:	89 f1                	mov    %esi,%ecx
  801b5d:	d3 ef                	shr    %cl,%edi
  801b5f:	09 c7                	or     %eax,%edi
  801b61:	89 e9                	mov    %ebp,%ecx
  801b63:	d3 e2                	shl    %cl,%edx
  801b65:	89 14 24             	mov    %edx,(%esp)
  801b68:	89 d8                	mov    %ebx,%eax
  801b6a:	d3 e0                	shl    %cl,%eax
  801b6c:	89 c2                	mov    %eax,%edx
  801b6e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b72:	d3 e0                	shl    %cl,%eax
  801b74:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b78:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b7c:	89 f1                	mov    %esi,%ecx
  801b7e:	d3 e8                	shr    %cl,%eax
  801b80:	09 d0                	or     %edx,%eax
  801b82:	d3 eb                	shr    %cl,%ebx
  801b84:	89 da                	mov    %ebx,%edx
  801b86:	f7 f7                	div    %edi
  801b88:	89 d3                	mov    %edx,%ebx
  801b8a:	f7 24 24             	mull   (%esp)
  801b8d:	89 c6                	mov    %eax,%esi
  801b8f:	89 d1                	mov    %edx,%ecx
  801b91:	39 d3                	cmp    %edx,%ebx
  801b93:	0f 82 87 00 00 00    	jb     801c20 <__umoddi3+0x134>
  801b99:	0f 84 91 00 00 00    	je     801c30 <__umoddi3+0x144>
  801b9f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ba3:	29 f2                	sub    %esi,%edx
  801ba5:	19 cb                	sbb    %ecx,%ebx
  801ba7:	89 d8                	mov    %ebx,%eax
  801ba9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bad:	d3 e0                	shl    %cl,%eax
  801baf:	89 e9                	mov    %ebp,%ecx
  801bb1:	d3 ea                	shr    %cl,%edx
  801bb3:	09 d0                	or     %edx,%eax
  801bb5:	89 e9                	mov    %ebp,%ecx
  801bb7:	d3 eb                	shr    %cl,%ebx
  801bb9:	89 da                	mov    %ebx,%edx
  801bbb:	83 c4 1c             	add    $0x1c,%esp
  801bbe:	5b                   	pop    %ebx
  801bbf:	5e                   	pop    %esi
  801bc0:	5f                   	pop    %edi
  801bc1:	5d                   	pop    %ebp
  801bc2:	c3                   	ret    
  801bc3:	90                   	nop
  801bc4:	89 fd                	mov    %edi,%ebp
  801bc6:	85 ff                	test   %edi,%edi
  801bc8:	75 0b                	jne    801bd5 <__umoddi3+0xe9>
  801bca:	b8 01 00 00 00       	mov    $0x1,%eax
  801bcf:	31 d2                	xor    %edx,%edx
  801bd1:	f7 f7                	div    %edi
  801bd3:	89 c5                	mov    %eax,%ebp
  801bd5:	89 f0                	mov    %esi,%eax
  801bd7:	31 d2                	xor    %edx,%edx
  801bd9:	f7 f5                	div    %ebp
  801bdb:	89 c8                	mov    %ecx,%eax
  801bdd:	f7 f5                	div    %ebp
  801bdf:	89 d0                	mov    %edx,%eax
  801be1:	e9 44 ff ff ff       	jmp    801b2a <__umoddi3+0x3e>
  801be6:	66 90                	xchg   %ax,%ax
  801be8:	89 c8                	mov    %ecx,%eax
  801bea:	89 f2                	mov    %esi,%edx
  801bec:	83 c4 1c             	add    $0x1c,%esp
  801bef:	5b                   	pop    %ebx
  801bf0:	5e                   	pop    %esi
  801bf1:	5f                   	pop    %edi
  801bf2:	5d                   	pop    %ebp
  801bf3:	c3                   	ret    
  801bf4:	3b 04 24             	cmp    (%esp),%eax
  801bf7:	72 06                	jb     801bff <__umoddi3+0x113>
  801bf9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bfd:	77 0f                	ja     801c0e <__umoddi3+0x122>
  801bff:	89 f2                	mov    %esi,%edx
  801c01:	29 f9                	sub    %edi,%ecx
  801c03:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c07:	89 14 24             	mov    %edx,(%esp)
  801c0a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c0e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c12:	8b 14 24             	mov    (%esp),%edx
  801c15:	83 c4 1c             	add    $0x1c,%esp
  801c18:	5b                   	pop    %ebx
  801c19:	5e                   	pop    %esi
  801c1a:	5f                   	pop    %edi
  801c1b:	5d                   	pop    %ebp
  801c1c:	c3                   	ret    
  801c1d:	8d 76 00             	lea    0x0(%esi),%esi
  801c20:	2b 04 24             	sub    (%esp),%eax
  801c23:	19 fa                	sbb    %edi,%edx
  801c25:	89 d1                	mov    %edx,%ecx
  801c27:	89 c6                	mov    %eax,%esi
  801c29:	e9 71 ff ff ff       	jmp    801b9f <__umoddi3+0xb3>
  801c2e:	66 90                	xchg   %ax,%ax
  801c30:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c34:	72 ea                	jb     801c20 <__umoddi3+0x134>
  801c36:	89 d9                	mov    %ebx,%ecx
  801c38:	e9 62 ff ff ff       	jmp    801b9f <__umoddi3+0xb3>

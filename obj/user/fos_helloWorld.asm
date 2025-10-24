
obj/user/fos_helloWorld:     file format elf32-i386


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
  800031:	e8 31 00 00 00       	call   800067 <libmain>
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
  80003b:	83 ec 08             	sub    $0x8,%esp
	extern unsigned char * etext;
	//cprintf("HELLO WORLD , FOS IS SAYING HI :D:D:D %d\n",4);
	atomic_cprintf("HELLO WORLD , FOS IS SAYING HI :D:D:D \n");
  80003e:	83 ec 0c             	sub    $0xc,%esp
  800041:	68 e0 1b 80 00       	push   $0x801be0
  800046:	e8 1e 03 00 00       	call   800369 <atomic_cprintf>
  80004b:	83 c4 10             	add    $0x10,%esp
	atomic_cprintf("end of code = %x\n",etext);
  80004e:	a1 d5 1b 80 00       	mov    0x801bd5,%eax
  800053:	83 ec 08             	sub    $0x8,%esp
  800056:	50                   	push   %eax
  800057:	68 08 1c 80 00       	push   $0x801c08
  80005c:	e8 08 03 00 00       	call   800369 <atomic_cprintf>
  800061:	83 c4 10             	add    $0x10,%esp
}
  800064:	90                   	nop
  800065:	c9                   	leave  
  800066:	c3                   	ret    

00800067 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800067:	55                   	push   %ebp
  800068:	89 e5                	mov    %esp,%ebp
  80006a:	57                   	push   %edi
  80006b:	56                   	push   %esi
  80006c:	53                   	push   %ebx
  80006d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800070:	e8 4f 14 00 00       	call   8014c4 <sys_getenvindex>
  800075:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800078:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80007b:	89 d0                	mov    %edx,%eax
  80007d:	c1 e0 02             	shl    $0x2,%eax
  800080:	01 d0                	add    %edx,%eax
  800082:	c1 e0 03             	shl    $0x3,%eax
  800085:	01 d0                	add    %edx,%eax
  800087:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80008e:	01 d0                	add    %edx,%eax
  800090:	c1 e0 02             	shl    $0x2,%eax
  800093:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800098:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80009d:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a2:	8a 40 20             	mov    0x20(%eax),%al
  8000a5:	84 c0                	test   %al,%al
  8000a7:	74 0d                	je     8000b6 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8000a9:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ae:	83 c0 20             	add    $0x20,%eax
  8000b1:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000ba:	7e 0a                	jle    8000c6 <libmain+0x5f>
		binaryname = argv[0];
  8000bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000bf:	8b 00                	mov    (%eax),%eax
  8000c1:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000c6:	83 ec 08             	sub    $0x8,%esp
  8000c9:	ff 75 0c             	pushl  0xc(%ebp)
  8000cc:	ff 75 08             	pushl  0x8(%ebp)
  8000cf:	e8 64 ff ff ff       	call   800038 <_main>
  8000d4:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000d7:	a1 00 30 80 00       	mov    0x803000,%eax
  8000dc:	85 c0                	test   %eax,%eax
  8000de:	0f 84 01 01 00 00    	je     8001e5 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8000e4:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8000ea:	bb 14 1d 80 00       	mov    $0x801d14,%ebx
  8000ef:	ba 0e 00 00 00       	mov    $0xe,%edx
  8000f4:	89 c7                	mov    %eax,%edi
  8000f6:	89 de                	mov    %ebx,%esi
  8000f8:	89 d1                	mov    %edx,%ecx
  8000fa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000fc:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8000ff:	b9 56 00 00 00       	mov    $0x56,%ecx
  800104:	b0 00                	mov    $0x0,%al
  800106:	89 d7                	mov    %edx,%edi
  800108:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80010a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800111:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800114:	83 ec 08             	sub    $0x8,%esp
  800117:	50                   	push   %eax
  800118:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80011e:	50                   	push   %eax
  80011f:	e8 d6 15 00 00       	call   8016fa <sys_utilities>
  800124:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800127:	e8 1f 11 00 00       	call   80124b <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80012c:	83 ec 0c             	sub    $0xc,%esp
  80012f:	68 34 1c 80 00       	push   $0x801c34
  800134:	e8 be 01 00 00       	call   8002f7 <cprintf>
  800139:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80013c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80013f:	85 c0                	test   %eax,%eax
  800141:	74 18                	je     80015b <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800143:	e8 d0 15 00 00       	call   801718 <sys_get_optimal_num_faults>
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	50                   	push   %eax
  80014c:	68 5c 1c 80 00       	push   $0x801c5c
  800151:	e8 a1 01 00 00       	call   8002f7 <cprintf>
  800156:	83 c4 10             	add    $0x10,%esp
  800159:	eb 59                	jmp    8001b4 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80015b:	a1 20 30 80 00       	mov    0x803020,%eax
  800160:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800166:	a1 20 30 80 00       	mov    0x803020,%eax
  80016b:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	52                   	push   %edx
  800175:	50                   	push   %eax
  800176:	68 80 1c 80 00       	push   $0x801c80
  80017b:	e8 77 01 00 00       	call   8002f7 <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800183:	a1 20 30 80 00       	mov    0x803020,%eax
  800188:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80018e:	a1 20 30 80 00       	mov    0x803020,%eax
  800193:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800199:	a1 20 30 80 00       	mov    0x803020,%eax
  80019e:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8001a4:	51                   	push   %ecx
  8001a5:	52                   	push   %edx
  8001a6:	50                   	push   %eax
  8001a7:	68 a8 1c 80 00       	push   $0x801ca8
  8001ac:	e8 46 01 00 00       	call   8002f7 <cprintf>
  8001b1:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001b4:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b9:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8001bf:	83 ec 08             	sub    $0x8,%esp
  8001c2:	50                   	push   %eax
  8001c3:	68 00 1d 80 00       	push   $0x801d00
  8001c8:	e8 2a 01 00 00       	call   8002f7 <cprintf>
  8001cd:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	68 34 1c 80 00       	push   $0x801c34
  8001d8:	e8 1a 01 00 00       	call   8002f7 <cprintf>
  8001dd:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001e0:	e8 80 10 00 00       	call   801265 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001e5:	e8 1f 00 00 00       	call   800209 <exit>
}
  8001ea:	90                   	nop
  8001eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ee:	5b                   	pop    %ebx
  8001ef:	5e                   	pop    %esi
  8001f0:	5f                   	pop    %edi
  8001f1:	5d                   	pop    %ebp
  8001f2:	c3                   	ret    

008001f3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001f3:	55                   	push   %ebp
  8001f4:	89 e5                	mov    %esp,%ebp
  8001f6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001f9:	83 ec 0c             	sub    $0xc,%esp
  8001fc:	6a 00                	push   $0x0
  8001fe:	e8 8d 12 00 00       	call   801490 <sys_destroy_env>
  800203:	83 c4 10             	add    $0x10,%esp
}
  800206:	90                   	nop
  800207:	c9                   	leave  
  800208:	c3                   	ret    

00800209 <exit>:

void
exit(void)
{
  800209:	55                   	push   %ebp
  80020a:	89 e5                	mov    %esp,%ebp
  80020c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80020f:	e8 e2 12 00 00       	call   8014f6 <sys_exit_env>
}
  800214:	90                   	nop
  800215:	c9                   	leave  
  800216:	c3                   	ret    

00800217 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800217:	55                   	push   %ebp
  800218:	89 e5                	mov    %esp,%ebp
  80021a:	53                   	push   %ebx
  80021b:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80021e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800221:	8b 00                	mov    (%eax),%eax
  800223:	8d 48 01             	lea    0x1(%eax),%ecx
  800226:	8b 55 0c             	mov    0xc(%ebp),%edx
  800229:	89 0a                	mov    %ecx,(%edx)
  80022b:	8b 55 08             	mov    0x8(%ebp),%edx
  80022e:	88 d1                	mov    %dl,%cl
  800230:	8b 55 0c             	mov    0xc(%ebp),%edx
  800233:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023a:	8b 00                	mov    (%eax),%eax
  80023c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800241:	75 30                	jne    800273 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800243:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  800249:	a0 44 30 80 00       	mov    0x803044,%al
  80024e:	0f b6 c0             	movzbl %al,%eax
  800251:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800254:	8b 09                	mov    (%ecx),%ecx
  800256:	89 cb                	mov    %ecx,%ebx
  800258:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80025b:	83 c1 08             	add    $0x8,%ecx
  80025e:	52                   	push   %edx
  80025f:	50                   	push   %eax
  800260:	53                   	push   %ebx
  800261:	51                   	push   %ecx
  800262:	e8 a0 0f 00 00       	call   801207 <sys_cputs>
  800267:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80026a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80026d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800273:	8b 45 0c             	mov    0xc(%ebp),%eax
  800276:	8b 40 04             	mov    0x4(%eax),%eax
  800279:	8d 50 01             	lea    0x1(%eax),%edx
  80027c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800282:	90                   	nop
  800283:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800286:	c9                   	leave  
  800287:	c3                   	ret    

00800288 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800288:	55                   	push   %ebp
  800289:	89 e5                	mov    %esp,%ebp
  80028b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800291:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800298:	00 00 00 
	b.cnt = 0;
  80029b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002a2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002a5:	ff 75 0c             	pushl  0xc(%ebp)
  8002a8:	ff 75 08             	pushl  0x8(%ebp)
  8002ab:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b1:	50                   	push   %eax
  8002b2:	68 17 02 80 00       	push   $0x800217
  8002b7:	e8 5a 02 00 00       	call   800516 <vprintfmt>
  8002bc:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8002bf:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8002c5:	a0 44 30 80 00       	mov    0x803044,%al
  8002ca:	0f b6 c0             	movzbl %al,%eax
  8002cd:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8002d3:	52                   	push   %edx
  8002d4:	50                   	push   %eax
  8002d5:	51                   	push   %ecx
  8002d6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002dc:	83 c0 08             	add    $0x8,%eax
  8002df:	50                   	push   %eax
  8002e0:	e8 22 0f 00 00       	call   801207 <sys_cputs>
  8002e5:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002e8:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8002ef:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002f5:	c9                   	leave  
  8002f6:	c3                   	ret    

008002f7 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002fd:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800304:	8d 45 0c             	lea    0xc(%ebp),%eax
  800307:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80030a:	8b 45 08             	mov    0x8(%ebp),%eax
  80030d:	83 ec 08             	sub    $0x8,%esp
  800310:	ff 75 f4             	pushl  -0xc(%ebp)
  800313:	50                   	push   %eax
  800314:	e8 6f ff ff ff       	call   800288 <vcprintf>
  800319:	83 c4 10             	add    $0x10,%esp
  80031c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80031f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800322:	c9                   	leave  
  800323:	c3                   	ret    

00800324 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800324:	55                   	push   %ebp
  800325:	89 e5                	mov    %esp,%ebp
  800327:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80032a:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800331:	8b 45 08             	mov    0x8(%ebp),%eax
  800334:	c1 e0 08             	shl    $0x8,%eax
  800337:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  80033c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80033f:	83 c0 04             	add    $0x4,%eax
  800342:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800345:	8b 45 0c             	mov    0xc(%ebp),%eax
  800348:	83 ec 08             	sub    $0x8,%esp
  80034b:	ff 75 f4             	pushl  -0xc(%ebp)
  80034e:	50                   	push   %eax
  80034f:	e8 34 ff ff ff       	call   800288 <vcprintf>
  800354:	83 c4 10             	add    $0x10,%esp
  800357:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80035a:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  800361:	07 00 00 

	return cnt;
  800364:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800367:	c9                   	leave  
  800368:	c3                   	ret    

00800369 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800369:	55                   	push   %ebp
  80036a:	89 e5                	mov    %esp,%ebp
  80036c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80036f:	e8 d7 0e 00 00       	call   80124b <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800374:	8d 45 0c             	lea    0xc(%ebp),%eax
  800377:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80037a:	8b 45 08             	mov    0x8(%ebp),%eax
  80037d:	83 ec 08             	sub    $0x8,%esp
  800380:	ff 75 f4             	pushl  -0xc(%ebp)
  800383:	50                   	push   %eax
  800384:	e8 ff fe ff ff       	call   800288 <vcprintf>
  800389:	83 c4 10             	add    $0x10,%esp
  80038c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80038f:	e8 d1 0e 00 00       	call   801265 <sys_unlock_cons>
	return cnt;
  800394:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800397:	c9                   	leave  
  800398:	c3                   	ret    

00800399 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800399:	55                   	push   %ebp
  80039a:	89 e5                	mov    %esp,%ebp
  80039c:	53                   	push   %ebx
  80039d:	83 ec 14             	sub    $0x14,%esp
  8003a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8003a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003ac:	8b 45 18             	mov    0x18(%ebp),%eax
  8003af:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003b7:	77 55                	ja     80040e <printnum+0x75>
  8003b9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003bc:	72 05                	jb     8003c3 <printnum+0x2a>
  8003be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003c1:	77 4b                	ja     80040e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003c3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003c6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003c9:	8b 45 18             	mov    0x18(%ebp),%eax
  8003cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d1:	52                   	push   %edx
  8003d2:	50                   	push   %eax
  8003d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8003d6:	ff 75 f0             	pushl  -0x10(%ebp)
  8003d9:	e8 96 15 00 00       	call   801974 <__udivdi3>
  8003de:	83 c4 10             	add    $0x10,%esp
  8003e1:	83 ec 04             	sub    $0x4,%esp
  8003e4:	ff 75 20             	pushl  0x20(%ebp)
  8003e7:	53                   	push   %ebx
  8003e8:	ff 75 18             	pushl  0x18(%ebp)
  8003eb:	52                   	push   %edx
  8003ec:	50                   	push   %eax
  8003ed:	ff 75 0c             	pushl  0xc(%ebp)
  8003f0:	ff 75 08             	pushl  0x8(%ebp)
  8003f3:	e8 a1 ff ff ff       	call   800399 <printnum>
  8003f8:	83 c4 20             	add    $0x20,%esp
  8003fb:	eb 1a                	jmp    800417 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003fd:	83 ec 08             	sub    $0x8,%esp
  800400:	ff 75 0c             	pushl  0xc(%ebp)
  800403:	ff 75 20             	pushl  0x20(%ebp)
  800406:	8b 45 08             	mov    0x8(%ebp),%eax
  800409:	ff d0                	call   *%eax
  80040b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80040e:	ff 4d 1c             	decl   0x1c(%ebp)
  800411:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800415:	7f e6                	jg     8003fd <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800417:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80041a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800422:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800425:	53                   	push   %ebx
  800426:	51                   	push   %ecx
  800427:	52                   	push   %edx
  800428:	50                   	push   %eax
  800429:	e8 56 16 00 00       	call   801a84 <__umoddi3>
  80042e:	83 c4 10             	add    $0x10,%esp
  800431:	05 94 1f 80 00       	add    $0x801f94,%eax
  800436:	8a 00                	mov    (%eax),%al
  800438:	0f be c0             	movsbl %al,%eax
  80043b:	83 ec 08             	sub    $0x8,%esp
  80043e:	ff 75 0c             	pushl  0xc(%ebp)
  800441:	50                   	push   %eax
  800442:	8b 45 08             	mov    0x8(%ebp),%eax
  800445:	ff d0                	call   *%eax
  800447:	83 c4 10             	add    $0x10,%esp
}
  80044a:	90                   	nop
  80044b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80044e:	c9                   	leave  
  80044f:	c3                   	ret    

00800450 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800450:	55                   	push   %ebp
  800451:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800453:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800457:	7e 1c                	jle    800475 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800459:	8b 45 08             	mov    0x8(%ebp),%eax
  80045c:	8b 00                	mov    (%eax),%eax
  80045e:	8d 50 08             	lea    0x8(%eax),%edx
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
  800464:	89 10                	mov    %edx,(%eax)
  800466:	8b 45 08             	mov    0x8(%ebp),%eax
  800469:	8b 00                	mov    (%eax),%eax
  80046b:	83 e8 08             	sub    $0x8,%eax
  80046e:	8b 50 04             	mov    0x4(%eax),%edx
  800471:	8b 00                	mov    (%eax),%eax
  800473:	eb 40                	jmp    8004b5 <getuint+0x65>
	else if (lflag)
  800475:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800479:	74 1e                	je     800499 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	8b 00                	mov    (%eax),%eax
  800480:	8d 50 04             	lea    0x4(%eax),%edx
  800483:	8b 45 08             	mov    0x8(%ebp),%eax
  800486:	89 10                	mov    %edx,(%eax)
  800488:	8b 45 08             	mov    0x8(%ebp),%eax
  80048b:	8b 00                	mov    (%eax),%eax
  80048d:	83 e8 04             	sub    $0x4,%eax
  800490:	8b 00                	mov    (%eax),%eax
  800492:	ba 00 00 00 00       	mov    $0x0,%edx
  800497:	eb 1c                	jmp    8004b5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	8d 50 04             	lea    0x4(%eax),%edx
  8004a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a4:	89 10                	mov    %edx,(%eax)
  8004a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	83 e8 04             	sub    $0x4,%eax
  8004ae:	8b 00                	mov    (%eax),%eax
  8004b0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004b5:	5d                   	pop    %ebp
  8004b6:	c3                   	ret    

008004b7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004b7:	55                   	push   %ebp
  8004b8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004ba:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004be:	7e 1c                	jle    8004dc <getint+0x25>
		return va_arg(*ap, long long);
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
  8004da:	eb 38                	jmp    800514 <getint+0x5d>
	else if (lflag)
  8004dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004e0:	74 1a                	je     8004fc <getint+0x45>
		return va_arg(*ap, long);
  8004e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e5:	8b 00                	mov    (%eax),%eax
  8004e7:	8d 50 04             	lea    0x4(%eax),%edx
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	89 10                	mov    %edx,(%eax)
  8004ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f2:	8b 00                	mov    (%eax),%eax
  8004f4:	83 e8 04             	sub    $0x4,%eax
  8004f7:	8b 00                	mov    (%eax),%eax
  8004f9:	99                   	cltd   
  8004fa:	eb 18                	jmp    800514 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ff:	8b 00                	mov    (%eax),%eax
  800501:	8d 50 04             	lea    0x4(%eax),%edx
  800504:	8b 45 08             	mov    0x8(%ebp),%eax
  800507:	89 10                	mov    %edx,(%eax)
  800509:	8b 45 08             	mov    0x8(%ebp),%eax
  80050c:	8b 00                	mov    (%eax),%eax
  80050e:	83 e8 04             	sub    $0x4,%eax
  800511:	8b 00                	mov    (%eax),%eax
  800513:	99                   	cltd   
}
  800514:	5d                   	pop    %ebp
  800515:	c3                   	ret    

00800516 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800516:	55                   	push   %ebp
  800517:	89 e5                	mov    %esp,%ebp
  800519:	56                   	push   %esi
  80051a:	53                   	push   %ebx
  80051b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80051e:	eb 17                	jmp    800537 <vprintfmt+0x21>
			if (ch == '\0')
  800520:	85 db                	test   %ebx,%ebx
  800522:	0f 84 c1 03 00 00    	je     8008e9 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800528:	83 ec 08             	sub    $0x8,%esp
  80052b:	ff 75 0c             	pushl  0xc(%ebp)
  80052e:	53                   	push   %ebx
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	ff d0                	call   *%eax
  800534:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800537:	8b 45 10             	mov    0x10(%ebp),%eax
  80053a:	8d 50 01             	lea    0x1(%eax),%edx
  80053d:	89 55 10             	mov    %edx,0x10(%ebp)
  800540:	8a 00                	mov    (%eax),%al
  800542:	0f b6 d8             	movzbl %al,%ebx
  800545:	83 fb 25             	cmp    $0x25,%ebx
  800548:	75 d6                	jne    800520 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80054a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80054e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800555:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80055c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800563:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80056a:	8b 45 10             	mov    0x10(%ebp),%eax
  80056d:	8d 50 01             	lea    0x1(%eax),%edx
  800570:	89 55 10             	mov    %edx,0x10(%ebp)
  800573:	8a 00                	mov    (%eax),%al
  800575:	0f b6 d8             	movzbl %al,%ebx
  800578:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80057b:	83 f8 5b             	cmp    $0x5b,%eax
  80057e:	0f 87 3d 03 00 00    	ja     8008c1 <vprintfmt+0x3ab>
  800584:	8b 04 85 b8 1f 80 00 	mov    0x801fb8(,%eax,4),%eax
  80058b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80058d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800591:	eb d7                	jmp    80056a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800593:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800597:	eb d1                	jmp    80056a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800599:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005a3:	89 d0                	mov    %edx,%eax
  8005a5:	c1 e0 02             	shl    $0x2,%eax
  8005a8:	01 d0                	add    %edx,%eax
  8005aa:	01 c0                	add    %eax,%eax
  8005ac:	01 d8                	add    %ebx,%eax
  8005ae:	83 e8 30             	sub    $0x30,%eax
  8005b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8005b7:	8a 00                	mov    (%eax),%al
  8005b9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005bc:	83 fb 2f             	cmp    $0x2f,%ebx
  8005bf:	7e 3e                	jle    8005ff <vprintfmt+0xe9>
  8005c1:	83 fb 39             	cmp    $0x39,%ebx
  8005c4:	7f 39                	jg     8005ff <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005c6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005c9:	eb d5                	jmp    8005a0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ce:	83 c0 04             	add    $0x4,%eax
  8005d1:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	83 e8 04             	sub    $0x4,%eax
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005df:	eb 1f                	jmp    800600 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005e5:	79 83                	jns    80056a <vprintfmt+0x54>
				width = 0;
  8005e7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005ee:	e9 77 ff ff ff       	jmp    80056a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005f3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005fa:	e9 6b ff ff ff       	jmp    80056a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005ff:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800600:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800604:	0f 89 60 ff ff ff    	jns    80056a <vprintfmt+0x54>
				width = precision, precision = -1;
  80060a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80060d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800610:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800617:	e9 4e ff ff ff       	jmp    80056a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80061c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80061f:	e9 46 ff ff ff       	jmp    80056a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800624:	8b 45 14             	mov    0x14(%ebp),%eax
  800627:	83 c0 04             	add    $0x4,%eax
  80062a:	89 45 14             	mov    %eax,0x14(%ebp)
  80062d:	8b 45 14             	mov    0x14(%ebp),%eax
  800630:	83 e8 04             	sub    $0x4,%eax
  800633:	8b 00                	mov    (%eax),%eax
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	ff 75 0c             	pushl  0xc(%ebp)
  80063b:	50                   	push   %eax
  80063c:	8b 45 08             	mov    0x8(%ebp),%eax
  80063f:	ff d0                	call   *%eax
  800641:	83 c4 10             	add    $0x10,%esp
			break;
  800644:	e9 9b 02 00 00       	jmp    8008e4 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	83 c0 04             	add    $0x4,%eax
  80064f:	89 45 14             	mov    %eax,0x14(%ebp)
  800652:	8b 45 14             	mov    0x14(%ebp),%eax
  800655:	83 e8 04             	sub    $0x4,%eax
  800658:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80065a:	85 db                	test   %ebx,%ebx
  80065c:	79 02                	jns    800660 <vprintfmt+0x14a>
				err = -err;
  80065e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800660:	83 fb 64             	cmp    $0x64,%ebx
  800663:	7f 0b                	jg     800670 <vprintfmt+0x15a>
  800665:	8b 34 9d 00 1e 80 00 	mov    0x801e00(,%ebx,4),%esi
  80066c:	85 f6                	test   %esi,%esi
  80066e:	75 19                	jne    800689 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800670:	53                   	push   %ebx
  800671:	68 a5 1f 80 00       	push   $0x801fa5
  800676:	ff 75 0c             	pushl  0xc(%ebp)
  800679:	ff 75 08             	pushl  0x8(%ebp)
  80067c:	e8 70 02 00 00       	call   8008f1 <printfmt>
  800681:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800684:	e9 5b 02 00 00       	jmp    8008e4 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800689:	56                   	push   %esi
  80068a:	68 ae 1f 80 00       	push   $0x801fae
  80068f:	ff 75 0c             	pushl  0xc(%ebp)
  800692:	ff 75 08             	pushl  0x8(%ebp)
  800695:	e8 57 02 00 00       	call   8008f1 <printfmt>
  80069a:	83 c4 10             	add    $0x10,%esp
			break;
  80069d:	e9 42 02 00 00       	jmp    8008e4 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	83 c0 04             	add    $0x4,%eax
  8006a8:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ae:	83 e8 04             	sub    $0x4,%eax
  8006b1:	8b 30                	mov    (%eax),%esi
  8006b3:	85 f6                	test   %esi,%esi
  8006b5:	75 05                	jne    8006bc <vprintfmt+0x1a6>
				p = "(null)";
  8006b7:	be b1 1f 80 00       	mov    $0x801fb1,%esi
			if (width > 0 && padc != '-')
  8006bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006c0:	7e 6d                	jle    80072f <vprintfmt+0x219>
  8006c2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006c6:	74 67                	je     80072f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006cb:	83 ec 08             	sub    $0x8,%esp
  8006ce:	50                   	push   %eax
  8006cf:	56                   	push   %esi
  8006d0:	e8 1e 03 00 00       	call   8009f3 <strnlen>
  8006d5:	83 c4 10             	add    $0x10,%esp
  8006d8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006db:	eb 16                	jmp    8006f3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006dd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006e1:	83 ec 08             	sub    $0x8,%esp
  8006e4:	ff 75 0c             	pushl  0xc(%ebp)
  8006e7:	50                   	push   %eax
  8006e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006eb:	ff d0                	call   *%eax
  8006ed:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006f0:	ff 4d e4             	decl   -0x1c(%ebp)
  8006f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006f7:	7f e4                	jg     8006dd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006f9:	eb 34                	jmp    80072f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006fb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006ff:	74 1c                	je     80071d <vprintfmt+0x207>
  800701:	83 fb 1f             	cmp    $0x1f,%ebx
  800704:	7e 05                	jle    80070b <vprintfmt+0x1f5>
  800706:	83 fb 7e             	cmp    $0x7e,%ebx
  800709:	7e 12                	jle    80071d <vprintfmt+0x207>
					putch('?', putdat);
  80070b:	83 ec 08             	sub    $0x8,%esp
  80070e:	ff 75 0c             	pushl  0xc(%ebp)
  800711:	6a 3f                	push   $0x3f
  800713:	8b 45 08             	mov    0x8(%ebp),%eax
  800716:	ff d0                	call   *%eax
  800718:	83 c4 10             	add    $0x10,%esp
  80071b:	eb 0f                	jmp    80072c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	ff 75 0c             	pushl  0xc(%ebp)
  800723:	53                   	push   %ebx
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	ff d0                	call   *%eax
  800729:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80072c:	ff 4d e4             	decl   -0x1c(%ebp)
  80072f:	89 f0                	mov    %esi,%eax
  800731:	8d 70 01             	lea    0x1(%eax),%esi
  800734:	8a 00                	mov    (%eax),%al
  800736:	0f be d8             	movsbl %al,%ebx
  800739:	85 db                	test   %ebx,%ebx
  80073b:	74 24                	je     800761 <vprintfmt+0x24b>
  80073d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800741:	78 b8                	js     8006fb <vprintfmt+0x1e5>
  800743:	ff 4d e0             	decl   -0x20(%ebp)
  800746:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80074a:	79 af                	jns    8006fb <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80074c:	eb 13                	jmp    800761 <vprintfmt+0x24b>
				putch(' ', putdat);
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	ff 75 0c             	pushl  0xc(%ebp)
  800754:	6a 20                	push   $0x20
  800756:	8b 45 08             	mov    0x8(%ebp),%eax
  800759:	ff d0                	call   *%eax
  80075b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80075e:	ff 4d e4             	decl   -0x1c(%ebp)
  800761:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800765:	7f e7                	jg     80074e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800767:	e9 78 01 00 00       	jmp    8008e4 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80076c:	83 ec 08             	sub    $0x8,%esp
  80076f:	ff 75 e8             	pushl  -0x18(%ebp)
  800772:	8d 45 14             	lea    0x14(%ebp),%eax
  800775:	50                   	push   %eax
  800776:	e8 3c fd ff ff       	call   8004b7 <getint>
  80077b:	83 c4 10             	add    $0x10,%esp
  80077e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800781:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800784:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800787:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80078a:	85 d2                	test   %edx,%edx
  80078c:	79 23                	jns    8007b1 <vprintfmt+0x29b>
				putch('-', putdat);
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	ff 75 0c             	pushl  0xc(%ebp)
  800794:	6a 2d                	push   $0x2d
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	ff d0                	call   *%eax
  80079b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80079e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007a4:	f7 d8                	neg    %eax
  8007a6:	83 d2 00             	adc    $0x0,%edx
  8007a9:	f7 da                	neg    %edx
  8007ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007b1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007b8:	e9 bc 00 00 00       	jmp    800879 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007bd:	83 ec 08             	sub    $0x8,%esp
  8007c0:	ff 75 e8             	pushl  -0x18(%ebp)
  8007c3:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c6:	50                   	push   %eax
  8007c7:	e8 84 fc ff ff       	call   800450 <getuint>
  8007cc:	83 c4 10             	add    $0x10,%esp
  8007cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007d5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007dc:	e9 98 00 00 00       	jmp    800879 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	ff 75 0c             	pushl  0xc(%ebp)
  8007e7:	6a 58                	push   $0x58
  8007e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ec:	ff d0                	call   *%eax
  8007ee:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	ff 75 0c             	pushl  0xc(%ebp)
  8007f7:	6a 58                	push   $0x58
  8007f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fc:	ff d0                	call   *%eax
  8007fe:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800801:	83 ec 08             	sub    $0x8,%esp
  800804:	ff 75 0c             	pushl  0xc(%ebp)
  800807:	6a 58                	push   $0x58
  800809:	8b 45 08             	mov    0x8(%ebp),%eax
  80080c:	ff d0                	call   *%eax
  80080e:	83 c4 10             	add    $0x10,%esp
			break;
  800811:	e9 ce 00 00 00       	jmp    8008e4 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800816:	83 ec 08             	sub    $0x8,%esp
  800819:	ff 75 0c             	pushl  0xc(%ebp)
  80081c:	6a 30                	push   $0x30
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	ff d0                	call   *%eax
  800823:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800826:	83 ec 08             	sub    $0x8,%esp
  800829:	ff 75 0c             	pushl  0xc(%ebp)
  80082c:	6a 78                	push   $0x78
  80082e:	8b 45 08             	mov    0x8(%ebp),%eax
  800831:	ff d0                	call   *%eax
  800833:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800836:	8b 45 14             	mov    0x14(%ebp),%eax
  800839:	83 c0 04             	add    $0x4,%eax
  80083c:	89 45 14             	mov    %eax,0x14(%ebp)
  80083f:	8b 45 14             	mov    0x14(%ebp),%eax
  800842:	83 e8 04             	sub    $0x4,%eax
  800845:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800847:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80084a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800851:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800858:	eb 1f                	jmp    800879 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80085a:	83 ec 08             	sub    $0x8,%esp
  80085d:	ff 75 e8             	pushl  -0x18(%ebp)
  800860:	8d 45 14             	lea    0x14(%ebp),%eax
  800863:	50                   	push   %eax
  800864:	e8 e7 fb ff ff       	call   800450 <getuint>
  800869:	83 c4 10             	add    $0x10,%esp
  80086c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80086f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800872:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800879:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80087d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800880:	83 ec 04             	sub    $0x4,%esp
  800883:	52                   	push   %edx
  800884:	ff 75 e4             	pushl  -0x1c(%ebp)
  800887:	50                   	push   %eax
  800888:	ff 75 f4             	pushl  -0xc(%ebp)
  80088b:	ff 75 f0             	pushl  -0x10(%ebp)
  80088e:	ff 75 0c             	pushl  0xc(%ebp)
  800891:	ff 75 08             	pushl  0x8(%ebp)
  800894:	e8 00 fb ff ff       	call   800399 <printnum>
  800899:	83 c4 20             	add    $0x20,%esp
			break;
  80089c:	eb 46                	jmp    8008e4 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80089e:	83 ec 08             	sub    $0x8,%esp
  8008a1:	ff 75 0c             	pushl  0xc(%ebp)
  8008a4:	53                   	push   %ebx
  8008a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a8:	ff d0                	call   *%eax
  8008aa:	83 c4 10             	add    $0x10,%esp
			break;
  8008ad:	eb 35                	jmp    8008e4 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8008af:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  8008b6:	eb 2c                	jmp    8008e4 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8008b8:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  8008bf:	eb 23                	jmp    8008e4 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008c1:	83 ec 08             	sub    $0x8,%esp
  8008c4:	ff 75 0c             	pushl  0xc(%ebp)
  8008c7:	6a 25                	push   $0x25
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	ff d0                	call   *%eax
  8008ce:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008d1:	ff 4d 10             	decl   0x10(%ebp)
  8008d4:	eb 03                	jmp    8008d9 <vprintfmt+0x3c3>
  8008d6:	ff 4d 10             	decl   0x10(%ebp)
  8008d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008dc:	48                   	dec    %eax
  8008dd:	8a 00                	mov    (%eax),%al
  8008df:	3c 25                	cmp    $0x25,%al
  8008e1:	75 f3                	jne    8008d6 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008e3:	90                   	nop
		}
	}
  8008e4:	e9 35 fc ff ff       	jmp    80051e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008e9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008ed:	5b                   	pop    %ebx
  8008ee:	5e                   	pop    %esi
  8008ef:	5d                   	pop    %ebp
  8008f0:	c3                   	ret    

008008f1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008f7:	8d 45 10             	lea    0x10(%ebp),%eax
  8008fa:	83 c0 04             	add    $0x4,%eax
  8008fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800900:	8b 45 10             	mov    0x10(%ebp),%eax
  800903:	ff 75 f4             	pushl  -0xc(%ebp)
  800906:	50                   	push   %eax
  800907:	ff 75 0c             	pushl  0xc(%ebp)
  80090a:	ff 75 08             	pushl  0x8(%ebp)
  80090d:	e8 04 fc ff ff       	call   800516 <vprintfmt>
  800912:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800915:	90                   	nop
  800916:	c9                   	leave  
  800917:	c3                   	ret    

00800918 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80091b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091e:	8b 40 08             	mov    0x8(%eax),%eax
  800921:	8d 50 01             	lea    0x1(%eax),%edx
  800924:	8b 45 0c             	mov    0xc(%ebp),%eax
  800927:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80092a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092d:	8b 10                	mov    (%eax),%edx
  80092f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800932:	8b 40 04             	mov    0x4(%eax),%eax
  800935:	39 c2                	cmp    %eax,%edx
  800937:	73 12                	jae    80094b <sprintputch+0x33>
		*b->buf++ = ch;
  800939:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093c:	8b 00                	mov    (%eax),%eax
  80093e:	8d 48 01             	lea    0x1(%eax),%ecx
  800941:	8b 55 0c             	mov    0xc(%ebp),%edx
  800944:	89 0a                	mov    %ecx,(%edx)
  800946:	8b 55 08             	mov    0x8(%ebp),%edx
  800949:	88 10                	mov    %dl,(%eax)
}
  80094b:	90                   	nop
  80094c:	5d                   	pop    %ebp
  80094d:	c3                   	ret    

0080094e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80094e:	55                   	push   %ebp
  80094f:	89 e5                	mov    %esp,%ebp
  800951:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80095a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800960:	8b 45 08             	mov    0x8(%ebp),%eax
  800963:	01 d0                	add    %edx,%eax
  800965:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800968:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80096f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800973:	74 06                	je     80097b <vsnprintf+0x2d>
  800975:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800979:	7f 07                	jg     800982 <vsnprintf+0x34>
		return -E_INVAL;
  80097b:	b8 03 00 00 00       	mov    $0x3,%eax
  800980:	eb 20                	jmp    8009a2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800982:	ff 75 14             	pushl  0x14(%ebp)
  800985:	ff 75 10             	pushl  0x10(%ebp)
  800988:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80098b:	50                   	push   %eax
  80098c:	68 18 09 80 00       	push   $0x800918
  800991:	e8 80 fb ff ff       	call   800516 <vprintfmt>
  800996:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800999:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80099c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80099f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009a2:	c9                   	leave  
  8009a3:	c3                   	ret    

008009a4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
  8009a7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009aa:	8d 45 10             	lea    0x10(%ebp),%eax
  8009ad:	83 c0 04             	add    $0x4,%eax
  8009b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b9:	50                   	push   %eax
  8009ba:	ff 75 0c             	pushl  0xc(%ebp)
  8009bd:	ff 75 08             	pushl  0x8(%ebp)
  8009c0:	e8 89 ff ff ff       	call   80094e <vsnprintf>
  8009c5:	83 c4 10             	add    $0x10,%esp
  8009c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009ce:	c9                   	leave  
  8009cf:	c3                   	ret    

008009d0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009dd:	eb 06                	jmp    8009e5 <strlen+0x15>
		n++;
  8009df:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009e2:	ff 45 08             	incl   0x8(%ebp)
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	8a 00                	mov    (%eax),%al
  8009ea:	84 c0                	test   %al,%al
  8009ec:	75 f1                	jne    8009df <strlen+0xf>
		n++;
	return n;
  8009ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009f1:	c9                   	leave  
  8009f2:	c3                   	ret    

008009f3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009f3:	55                   	push   %ebp
  8009f4:	89 e5                	mov    %esp,%ebp
  8009f6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a00:	eb 09                	jmp    800a0b <strnlen+0x18>
		n++;
  800a02:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a05:	ff 45 08             	incl   0x8(%ebp)
  800a08:	ff 4d 0c             	decl   0xc(%ebp)
  800a0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a0f:	74 09                	je     800a1a <strnlen+0x27>
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	8a 00                	mov    (%eax),%al
  800a16:	84 c0                	test   %al,%al
  800a18:	75 e8                	jne    800a02 <strnlen+0xf>
		n++;
	return n;
  800a1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a1d:	c9                   	leave  
  800a1e:	c3                   	ret    

00800a1f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
  800a22:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a2b:	90                   	nop
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	8d 50 01             	lea    0x1(%eax),%edx
  800a32:	89 55 08             	mov    %edx,0x8(%ebp)
  800a35:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a38:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a3b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a3e:	8a 12                	mov    (%edx),%dl
  800a40:	88 10                	mov    %dl,(%eax)
  800a42:	8a 00                	mov    (%eax),%al
  800a44:	84 c0                	test   %al,%al
  800a46:	75 e4                	jne    800a2c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a48:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a4b:	c9                   	leave  
  800a4c:	c3                   	ret    

00800a4d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a60:	eb 1f                	jmp    800a81 <strncpy+0x34>
		*dst++ = *src;
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	8d 50 01             	lea    0x1(%eax),%edx
  800a68:	89 55 08             	mov    %edx,0x8(%ebp)
  800a6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6e:	8a 12                	mov    (%edx),%dl
  800a70:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a75:	8a 00                	mov    (%eax),%al
  800a77:	84 c0                	test   %al,%al
  800a79:	74 03                	je     800a7e <strncpy+0x31>
			src++;
  800a7b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a7e:	ff 45 fc             	incl   -0x4(%ebp)
  800a81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a84:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a87:	72 d9                	jb     800a62 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a89:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a8c:	c9                   	leave  
  800a8d:	c3                   	ret    

00800a8e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a8e:	55                   	push   %ebp
  800a8f:	89 e5                	mov    %esp,%ebp
  800a91:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a9e:	74 30                	je     800ad0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800aa0:	eb 16                	jmp    800ab8 <strlcpy+0x2a>
			*dst++ = *src++;
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	8d 50 01             	lea    0x1(%eax),%edx
  800aa8:	89 55 08             	mov    %edx,0x8(%ebp)
  800aab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aae:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ab1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ab4:	8a 12                	mov    (%edx),%dl
  800ab6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ab8:	ff 4d 10             	decl   0x10(%ebp)
  800abb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800abf:	74 09                	je     800aca <strlcpy+0x3c>
  800ac1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac4:	8a 00                	mov    (%eax),%al
  800ac6:	84 c0                	test   %al,%al
  800ac8:	75 d8                	jne    800aa2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ad0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ad3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ad6:	29 c2                	sub    %eax,%edx
  800ad8:	89 d0                	mov    %edx,%eax
}
  800ada:	c9                   	leave  
  800adb:	c3                   	ret    

00800adc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800adf:	eb 06                	jmp    800ae7 <strcmp+0xb>
		p++, q++;
  800ae1:	ff 45 08             	incl   0x8(%ebp)
  800ae4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aea:	8a 00                	mov    (%eax),%al
  800aec:	84 c0                	test   %al,%al
  800aee:	74 0e                	je     800afe <strcmp+0x22>
  800af0:	8b 45 08             	mov    0x8(%ebp),%eax
  800af3:	8a 10                	mov    (%eax),%dl
  800af5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af8:	8a 00                	mov    (%eax),%al
  800afa:	38 c2                	cmp    %al,%dl
  800afc:	74 e3                	je     800ae1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	8a 00                	mov    (%eax),%al
  800b03:	0f b6 d0             	movzbl %al,%edx
  800b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b09:	8a 00                	mov    (%eax),%al
  800b0b:	0f b6 c0             	movzbl %al,%eax
  800b0e:	29 c2                	sub    %eax,%edx
  800b10:	89 d0                	mov    %edx,%eax
}
  800b12:	5d                   	pop    %ebp
  800b13:	c3                   	ret    

00800b14 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b17:	eb 09                	jmp    800b22 <strncmp+0xe>
		n--, p++, q++;
  800b19:	ff 4d 10             	decl   0x10(%ebp)
  800b1c:	ff 45 08             	incl   0x8(%ebp)
  800b1f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b26:	74 17                	je     800b3f <strncmp+0x2b>
  800b28:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2b:	8a 00                	mov    (%eax),%al
  800b2d:	84 c0                	test   %al,%al
  800b2f:	74 0e                	je     800b3f <strncmp+0x2b>
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	8a 10                	mov    (%eax),%dl
  800b36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b39:	8a 00                	mov    (%eax),%al
  800b3b:	38 c2                	cmp    %al,%dl
  800b3d:	74 da                	je     800b19 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b3f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b43:	75 07                	jne    800b4c <strncmp+0x38>
		return 0;
  800b45:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4a:	eb 14                	jmp    800b60 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	8a 00                	mov    (%eax),%al
  800b51:	0f b6 d0             	movzbl %al,%edx
  800b54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b57:	8a 00                	mov    (%eax),%al
  800b59:	0f b6 c0             	movzbl %al,%eax
  800b5c:	29 c2                	sub    %eax,%edx
  800b5e:	89 d0                	mov    %edx,%eax
}
  800b60:	5d                   	pop    %ebp
  800b61:	c3                   	ret    

00800b62 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b62:	55                   	push   %ebp
  800b63:	89 e5                	mov    %esp,%ebp
  800b65:	83 ec 04             	sub    $0x4,%esp
  800b68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b6e:	eb 12                	jmp    800b82 <strchr+0x20>
		if (*s == c)
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	8a 00                	mov    (%eax),%al
  800b75:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b78:	75 05                	jne    800b7f <strchr+0x1d>
			return (char *) s;
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	eb 11                	jmp    800b90 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b7f:	ff 45 08             	incl   0x8(%ebp)
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	8a 00                	mov    (%eax),%al
  800b87:	84 c0                	test   %al,%al
  800b89:	75 e5                	jne    800b70 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b90:	c9                   	leave  
  800b91:	c3                   	ret    

00800b92 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
  800b95:	83 ec 04             	sub    $0x4,%esp
  800b98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b9e:	eb 0d                	jmp    800bad <strfind+0x1b>
		if (*s == c)
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	8a 00                	mov    (%eax),%al
  800ba5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba8:	74 0e                	je     800bb8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800baa:	ff 45 08             	incl   0x8(%ebp)
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	8a 00                	mov    (%eax),%al
  800bb2:	84 c0                	test   %al,%al
  800bb4:	75 ea                	jne    800ba0 <strfind+0xe>
  800bb6:	eb 01                	jmp    800bb9 <strfind+0x27>
		if (*s == c)
			break;
  800bb8:	90                   	nop
	return (char *) s;
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bbc:	c9                   	leave  
  800bbd:	c3                   	ret    

00800bbe <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800bca:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800bce:	76 63                	jbe    800c33 <memset+0x75>
		uint64 data_block = c;
  800bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd3:	99                   	cltd   
  800bd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd7:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800bda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be0:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800be4:	c1 e0 08             	shl    $0x8,%eax
  800be7:	09 45 f0             	or     %eax,-0x10(%ebp)
  800bea:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf3:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800bf7:	c1 e0 10             	shl    $0x10,%eax
  800bfa:	09 45 f0             	or     %eax,-0x10(%ebp)
  800bfd:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800c00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c06:	89 c2                	mov    %eax,%edx
  800c08:	b8 00 00 00 00       	mov    $0x0,%eax
  800c0d:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c10:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800c13:	eb 18                	jmp    800c2d <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800c15:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800c18:	8d 41 08             	lea    0x8(%ecx),%eax
  800c1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800c1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c24:	89 01                	mov    %eax,(%ecx)
  800c26:	89 51 04             	mov    %edx,0x4(%ecx)
  800c29:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800c2d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c31:	77 e2                	ja     800c15 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800c33:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c37:	74 23                	je     800c5c <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800c39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c3c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c3f:	eb 0e                	jmp    800c4f <memset+0x91>
			*p8++ = (uint8)c;
  800c41:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c44:	8d 50 01             	lea    0x1(%eax),%edx
  800c47:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4d:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800c4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c52:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c55:	89 55 10             	mov    %edx,0x10(%ebp)
  800c58:	85 c0                	test   %eax,%eax
  800c5a:	75 e5                	jne    800c41 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c5f:	c9                   	leave  
  800c60:	c3                   	ret    

00800c61 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c61:	55                   	push   %ebp
  800c62:	89 e5                	mov    %esp,%ebp
  800c64:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800c67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800c73:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c77:	76 24                	jbe    800c9d <memcpy+0x3c>
		while(n >= 8){
  800c79:	eb 1c                	jmp    800c97 <memcpy+0x36>
			*d64 = *s64;
  800c7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c7e:	8b 50 04             	mov    0x4(%eax),%edx
  800c81:	8b 00                	mov    (%eax),%eax
  800c83:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800c86:	89 01                	mov    %eax,(%ecx)
  800c88:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800c8b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800c8f:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800c93:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800c97:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c9b:	77 de                	ja     800c7b <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800c9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca1:	74 31                	je     800cd4 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800ca3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800ca9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cac:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800caf:	eb 16                	jmp    800cc7 <memcpy+0x66>
			*d8++ = *s8++;
  800cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cb4:	8d 50 01             	lea    0x1(%eax),%edx
  800cb7:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800cba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cbd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc0:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800cc3:	8a 12                	mov    (%edx),%dl
  800cc5:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800cc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cca:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ccd:	89 55 10             	mov    %edx,0x10(%ebp)
  800cd0:	85 c0                	test   %eax,%eax
  800cd2:	75 dd                	jne    800cb1 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd7:	c9                   	leave  
  800cd8:	c3                   	ret    

00800cd9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ceb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800cf1:	73 50                	jae    800d43 <memmove+0x6a>
  800cf3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cf6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf9:	01 d0                	add    %edx,%eax
  800cfb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800cfe:	76 43                	jbe    800d43 <memmove+0x6a>
		s += n;
  800d00:	8b 45 10             	mov    0x10(%ebp),%eax
  800d03:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d06:	8b 45 10             	mov    0x10(%ebp),%eax
  800d09:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d0c:	eb 10                	jmp    800d1e <memmove+0x45>
			*--d = *--s;
  800d0e:	ff 4d f8             	decl   -0x8(%ebp)
  800d11:	ff 4d fc             	decl   -0x4(%ebp)
  800d14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d17:	8a 10                	mov    (%eax),%dl
  800d19:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d1c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d21:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d24:	89 55 10             	mov    %edx,0x10(%ebp)
  800d27:	85 c0                	test   %eax,%eax
  800d29:	75 e3                	jne    800d0e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d2b:	eb 23                	jmp    800d50 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d30:	8d 50 01             	lea    0x1(%eax),%edx
  800d33:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d36:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d39:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d3f:	8a 12                	mov    (%edx),%dl
  800d41:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d43:	8b 45 10             	mov    0x10(%ebp),%eax
  800d46:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d49:	89 55 10             	mov    %edx,0x10(%ebp)
  800d4c:	85 c0                	test   %eax,%eax
  800d4e:	75 dd                	jne    800d2d <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d53:	c9                   	leave  
  800d54:	c3                   	ret    

00800d55 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d64:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d67:	eb 2a                	jmp    800d93 <memcmp+0x3e>
		if (*s1 != *s2)
  800d69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6c:	8a 10                	mov    (%eax),%dl
  800d6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d71:	8a 00                	mov    (%eax),%al
  800d73:	38 c2                	cmp    %al,%dl
  800d75:	74 16                	je     800d8d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	0f b6 d0             	movzbl %al,%edx
  800d7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d82:	8a 00                	mov    (%eax),%al
  800d84:	0f b6 c0             	movzbl %al,%eax
  800d87:	29 c2                	sub    %eax,%edx
  800d89:	89 d0                	mov    %edx,%eax
  800d8b:	eb 18                	jmp    800da5 <memcmp+0x50>
		s1++, s2++;
  800d8d:	ff 45 fc             	incl   -0x4(%ebp)
  800d90:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d93:	8b 45 10             	mov    0x10(%ebp),%eax
  800d96:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d99:	89 55 10             	mov    %edx,0x10(%ebp)
  800d9c:	85 c0                	test   %eax,%eax
  800d9e:	75 c9                	jne    800d69 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800da0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800da5:	c9                   	leave  
  800da6:	c3                   	ret    

00800da7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800dad:	8b 55 08             	mov    0x8(%ebp),%edx
  800db0:	8b 45 10             	mov    0x10(%ebp),%eax
  800db3:	01 d0                	add    %edx,%eax
  800db5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800db8:	eb 15                	jmp    800dcf <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	8a 00                	mov    (%eax),%al
  800dbf:	0f b6 d0             	movzbl %al,%edx
  800dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc5:	0f b6 c0             	movzbl %al,%eax
  800dc8:	39 c2                	cmp    %eax,%edx
  800dca:	74 0d                	je     800dd9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800dcc:	ff 45 08             	incl   0x8(%ebp)
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800dd5:	72 e3                	jb     800dba <memfind+0x13>
  800dd7:	eb 01                	jmp    800dda <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800dd9:	90                   	nop
	return (void *) s;
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ddd:	c9                   	leave  
  800dde:	c3                   	ret    

00800ddf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
  800de2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800de5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800dec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800df3:	eb 03                	jmp    800df8 <strtol+0x19>
		s++;
  800df5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	3c 20                	cmp    $0x20,%al
  800dff:	74 f4                	je     800df5 <strtol+0x16>
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8a 00                	mov    (%eax),%al
  800e06:	3c 09                	cmp    $0x9,%al
  800e08:	74 eb                	je     800df5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0d:	8a 00                	mov    (%eax),%al
  800e0f:	3c 2b                	cmp    $0x2b,%al
  800e11:	75 05                	jne    800e18 <strtol+0x39>
		s++;
  800e13:	ff 45 08             	incl   0x8(%ebp)
  800e16:	eb 13                	jmp    800e2b <strtol+0x4c>
	else if (*s == '-')
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1b:	8a 00                	mov    (%eax),%al
  800e1d:	3c 2d                	cmp    $0x2d,%al
  800e1f:	75 0a                	jne    800e2b <strtol+0x4c>
		s++, neg = 1;
  800e21:	ff 45 08             	incl   0x8(%ebp)
  800e24:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e2b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e2f:	74 06                	je     800e37 <strtol+0x58>
  800e31:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e35:	75 20                	jne    800e57 <strtol+0x78>
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3a:	8a 00                	mov    (%eax),%al
  800e3c:	3c 30                	cmp    $0x30,%al
  800e3e:	75 17                	jne    800e57 <strtol+0x78>
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	40                   	inc    %eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	3c 78                	cmp    $0x78,%al
  800e48:	75 0d                	jne    800e57 <strtol+0x78>
		s += 2, base = 16;
  800e4a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e4e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e55:	eb 28                	jmp    800e7f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e5b:	75 15                	jne    800e72 <strtol+0x93>
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	8a 00                	mov    (%eax),%al
  800e62:	3c 30                	cmp    $0x30,%al
  800e64:	75 0c                	jne    800e72 <strtol+0x93>
		s++, base = 8;
  800e66:	ff 45 08             	incl   0x8(%ebp)
  800e69:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e70:	eb 0d                	jmp    800e7f <strtol+0xa0>
	else if (base == 0)
  800e72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e76:	75 07                	jne    800e7f <strtol+0xa0>
		base = 10;
  800e78:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	8a 00                	mov    (%eax),%al
  800e84:	3c 2f                	cmp    $0x2f,%al
  800e86:	7e 19                	jle    800ea1 <strtol+0xc2>
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	8a 00                	mov    (%eax),%al
  800e8d:	3c 39                	cmp    $0x39,%al
  800e8f:	7f 10                	jg     800ea1 <strtol+0xc2>
			dig = *s - '0';
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	0f be c0             	movsbl %al,%eax
  800e99:	83 e8 30             	sub    $0x30,%eax
  800e9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e9f:	eb 42                	jmp    800ee3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	8a 00                	mov    (%eax),%al
  800ea6:	3c 60                	cmp    $0x60,%al
  800ea8:	7e 19                	jle    800ec3 <strtol+0xe4>
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	8a 00                	mov    (%eax),%al
  800eaf:	3c 7a                	cmp    $0x7a,%al
  800eb1:	7f 10                	jg     800ec3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb6:	8a 00                	mov    (%eax),%al
  800eb8:	0f be c0             	movsbl %al,%eax
  800ebb:	83 e8 57             	sub    $0x57,%eax
  800ebe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ec1:	eb 20                	jmp    800ee3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	8a 00                	mov    (%eax),%al
  800ec8:	3c 40                	cmp    $0x40,%al
  800eca:	7e 39                	jle    800f05 <strtol+0x126>
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	8a 00                	mov    (%eax),%al
  800ed1:	3c 5a                	cmp    $0x5a,%al
  800ed3:	7f 30                	jg     800f05 <strtol+0x126>
			dig = *s - 'A' + 10;
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	8a 00                	mov    (%eax),%al
  800eda:	0f be c0             	movsbl %al,%eax
  800edd:	83 e8 37             	sub    $0x37,%eax
  800ee0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ee9:	7d 19                	jge    800f04 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800eeb:	ff 45 08             	incl   0x8(%ebp)
  800eee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef1:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ef5:	89 c2                	mov    %eax,%edx
  800ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800efa:	01 d0                	add    %edx,%eax
  800efc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800eff:	e9 7b ff ff ff       	jmp    800e7f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f04:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f09:	74 08                	je     800f13 <strtol+0x134>
		*endptr = (char *) s;
  800f0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f11:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f13:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f17:	74 07                	je     800f20 <strtol+0x141>
  800f19:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1c:	f7 d8                	neg    %eax
  800f1e:	eb 03                	jmp    800f23 <strtol+0x144>
  800f20:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f23:	c9                   	leave  
  800f24:	c3                   	ret    

00800f25 <ltostr>:

void
ltostr(long value, char *str)
{
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f2b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f32:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f3d:	79 13                	jns    800f52 <ltostr+0x2d>
	{
		neg = 1;
  800f3f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f49:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f4c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f4f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f5a:	99                   	cltd   
  800f5b:	f7 f9                	idiv   %ecx
  800f5d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f60:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f63:	8d 50 01             	lea    0x1(%eax),%edx
  800f66:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f69:	89 c2                	mov    %eax,%edx
  800f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6e:	01 d0                	add    %edx,%eax
  800f70:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f73:	83 c2 30             	add    $0x30,%edx
  800f76:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f78:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f7b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f80:	f7 e9                	imul   %ecx
  800f82:	c1 fa 02             	sar    $0x2,%edx
  800f85:	89 c8                	mov    %ecx,%eax
  800f87:	c1 f8 1f             	sar    $0x1f,%eax
  800f8a:	29 c2                	sub    %eax,%edx
  800f8c:	89 d0                	mov    %edx,%eax
  800f8e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800f91:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f95:	75 bb                	jne    800f52 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa1:	48                   	dec    %eax
  800fa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800fa5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fa9:	74 3d                	je     800fe8 <ltostr+0xc3>
		start = 1 ;
  800fab:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800fb2:	eb 34                	jmp    800fe8 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800fb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fba:	01 d0                	add    %edx,%eax
  800fbc:	8a 00                	mov    (%eax),%al
  800fbe:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800fc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc7:	01 c2                	add    %eax,%edx
  800fc9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcf:	01 c8                	add    %ecx,%eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800fd5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800fd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdb:	01 c2                	add    %eax,%edx
  800fdd:	8a 45 eb             	mov    -0x15(%ebp),%al
  800fe0:	88 02                	mov    %al,(%edx)
		start++ ;
  800fe2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800fe5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800feb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fee:	7c c4                	jl     800fb4 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ff0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff6:	01 d0                	add    %edx,%eax
  800ff8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800ffb:	90                   	nop
  800ffc:	c9                   	leave  
  800ffd:	c3                   	ret    

00800ffe <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
  801001:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801004:	ff 75 08             	pushl  0x8(%ebp)
  801007:	e8 c4 f9 ff ff       	call   8009d0 <strlen>
  80100c:	83 c4 04             	add    $0x4,%esp
  80100f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801012:	ff 75 0c             	pushl  0xc(%ebp)
  801015:	e8 b6 f9 ff ff       	call   8009d0 <strlen>
  80101a:	83 c4 04             	add    $0x4,%esp
  80101d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801020:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801027:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80102e:	eb 17                	jmp    801047 <strcconcat+0x49>
		final[s] = str1[s] ;
  801030:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801033:	8b 45 10             	mov    0x10(%ebp),%eax
  801036:	01 c2                	add    %eax,%edx
  801038:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	01 c8                	add    %ecx,%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801044:	ff 45 fc             	incl   -0x4(%ebp)
  801047:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80104d:	7c e1                	jl     801030 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80104f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801056:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80105d:	eb 1f                	jmp    80107e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80105f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801062:	8d 50 01             	lea    0x1(%eax),%edx
  801065:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801068:	89 c2                	mov    %eax,%edx
  80106a:	8b 45 10             	mov    0x10(%ebp),%eax
  80106d:	01 c2                	add    %eax,%edx
  80106f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801072:	8b 45 0c             	mov    0xc(%ebp),%eax
  801075:	01 c8                	add    %ecx,%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80107b:	ff 45 f8             	incl   -0x8(%ebp)
  80107e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801081:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801084:	7c d9                	jl     80105f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801086:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801089:	8b 45 10             	mov    0x10(%ebp),%eax
  80108c:	01 d0                	add    %edx,%eax
  80108e:	c6 00 00             	movb   $0x0,(%eax)
}
  801091:	90                   	nop
  801092:	c9                   	leave  
  801093:	c3                   	ret    

00801094 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801097:	8b 45 14             	mov    0x14(%ebp),%eax
  80109a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8010a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a3:	8b 00                	mov    (%eax),%eax
  8010a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8010af:	01 d0                	add    %edx,%eax
  8010b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010b7:	eb 0c                	jmp    8010c5 <strsplit+0x31>
			*string++ = 0;
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	8d 50 01             	lea    0x1(%eax),%edx
  8010bf:	89 55 08             	mov    %edx,0x8(%ebp)
  8010c2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	8a 00                	mov    (%eax),%al
  8010ca:	84 c0                	test   %al,%al
  8010cc:	74 18                	je     8010e6 <strsplit+0x52>
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d1:	8a 00                	mov    (%eax),%al
  8010d3:	0f be c0             	movsbl %al,%eax
  8010d6:	50                   	push   %eax
  8010d7:	ff 75 0c             	pushl  0xc(%ebp)
  8010da:	e8 83 fa ff ff       	call   800b62 <strchr>
  8010df:	83 c4 08             	add    $0x8,%esp
  8010e2:	85 c0                	test   %eax,%eax
  8010e4:	75 d3                	jne    8010b9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	84 c0                	test   %al,%al
  8010ed:	74 5a                	je     801149 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8010ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f2:	8b 00                	mov    (%eax),%eax
  8010f4:	83 f8 0f             	cmp    $0xf,%eax
  8010f7:	75 07                	jne    801100 <strsplit+0x6c>
		{
			return 0;
  8010f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fe:	eb 66                	jmp    801166 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801100:	8b 45 14             	mov    0x14(%ebp),%eax
  801103:	8b 00                	mov    (%eax),%eax
  801105:	8d 48 01             	lea    0x1(%eax),%ecx
  801108:	8b 55 14             	mov    0x14(%ebp),%edx
  80110b:	89 0a                	mov    %ecx,(%edx)
  80110d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801114:	8b 45 10             	mov    0x10(%ebp),%eax
  801117:	01 c2                	add    %eax,%edx
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
  80111c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80111e:	eb 03                	jmp    801123 <strsplit+0x8f>
			string++;
  801120:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	8a 00                	mov    (%eax),%al
  801128:	84 c0                	test   %al,%al
  80112a:	74 8b                	je     8010b7 <strsplit+0x23>
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	8a 00                	mov    (%eax),%al
  801131:	0f be c0             	movsbl %al,%eax
  801134:	50                   	push   %eax
  801135:	ff 75 0c             	pushl  0xc(%ebp)
  801138:	e8 25 fa ff ff       	call   800b62 <strchr>
  80113d:	83 c4 08             	add    $0x8,%esp
  801140:	85 c0                	test   %eax,%eax
  801142:	74 dc                	je     801120 <strsplit+0x8c>
			string++;
	}
  801144:	e9 6e ff ff ff       	jmp    8010b7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801149:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80114a:	8b 45 14             	mov    0x14(%ebp),%eax
  80114d:	8b 00                	mov    (%eax),%eax
  80114f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801156:	8b 45 10             	mov    0x10(%ebp),%eax
  801159:	01 d0                	add    %edx,%eax
  80115b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801161:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801166:	c9                   	leave  
  801167:	c3                   	ret    

00801168 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801168:	55                   	push   %ebp
  801169:	89 e5                	mov    %esp,%ebp
  80116b:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801174:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80117b:	eb 4a                	jmp    8011c7 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80117d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	01 c2                	add    %eax,%edx
  801185:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118b:	01 c8                	add    %ecx,%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801191:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801194:	8b 45 0c             	mov    0xc(%ebp),%eax
  801197:	01 d0                	add    %edx,%eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	3c 40                	cmp    $0x40,%al
  80119d:	7e 25                	jle    8011c4 <str2lower+0x5c>
  80119f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	8a 00                	mov    (%eax),%al
  8011a9:	3c 5a                	cmp    $0x5a,%al
  8011ab:	7f 17                	jg     8011c4 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8011ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b3:	01 d0                	add    %edx,%eax
  8011b5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bb:	01 ca                	add    %ecx,%edx
  8011bd:	8a 12                	mov    (%edx),%dl
  8011bf:	83 c2 20             	add    $0x20,%edx
  8011c2:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8011c4:	ff 45 fc             	incl   -0x4(%ebp)
  8011c7:	ff 75 0c             	pushl  0xc(%ebp)
  8011ca:	e8 01 f8 ff ff       	call   8009d0 <strlen>
  8011cf:	83 c4 04             	add    $0x4,%esp
  8011d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011d5:	7f a6                	jg     80117d <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8011d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011da:	c9                   	leave  
  8011db:	c3                   	ret    

008011dc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
  8011df:	57                   	push   %edi
  8011e0:	56                   	push   %esi
  8011e1:	53                   	push   %ebx
  8011e2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011ee:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011f1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8011f4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8011f7:	cd 30                	int    $0x30
  8011f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8011fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011ff:	83 c4 10             	add    $0x10,%esp
  801202:	5b                   	pop    %ebx
  801203:	5e                   	pop    %esi
  801204:	5f                   	pop    %edi
  801205:	5d                   	pop    %ebp
  801206:	c3                   	ret    

00801207 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801207:	55                   	push   %ebp
  801208:	89 e5                	mov    %esp,%ebp
  80120a:	83 ec 04             	sub    $0x4,%esp
  80120d:	8b 45 10             	mov    0x10(%ebp),%eax
  801210:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801213:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801216:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	6a 00                	push   $0x0
  80121f:	51                   	push   %ecx
  801220:	52                   	push   %edx
  801221:	ff 75 0c             	pushl  0xc(%ebp)
  801224:	50                   	push   %eax
  801225:	6a 00                	push   $0x0
  801227:	e8 b0 ff ff ff       	call   8011dc <syscall>
  80122c:	83 c4 18             	add    $0x18,%esp
}
  80122f:	90                   	nop
  801230:	c9                   	leave  
  801231:	c3                   	ret    

00801232 <sys_cgetc>:

int
sys_cgetc(void)
{
  801232:	55                   	push   %ebp
  801233:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801235:	6a 00                	push   $0x0
  801237:	6a 00                	push   $0x0
  801239:	6a 00                	push   $0x0
  80123b:	6a 00                	push   $0x0
  80123d:	6a 00                	push   $0x0
  80123f:	6a 02                	push   $0x2
  801241:	e8 96 ff ff ff       	call   8011dc <syscall>
  801246:	83 c4 18             	add    $0x18,%esp
}
  801249:	c9                   	leave  
  80124a:	c3                   	ret    

0080124b <sys_lock_cons>:

void sys_lock_cons(void)
{
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80124e:	6a 00                	push   $0x0
  801250:	6a 00                	push   $0x0
  801252:	6a 00                	push   $0x0
  801254:	6a 00                	push   $0x0
  801256:	6a 00                	push   $0x0
  801258:	6a 03                	push   $0x3
  80125a:	e8 7d ff ff ff       	call   8011dc <syscall>
  80125f:	83 c4 18             	add    $0x18,%esp
}
  801262:	90                   	nop
  801263:	c9                   	leave  
  801264:	c3                   	ret    

00801265 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801268:	6a 00                	push   $0x0
  80126a:	6a 00                	push   $0x0
  80126c:	6a 00                	push   $0x0
  80126e:	6a 00                	push   $0x0
  801270:	6a 00                	push   $0x0
  801272:	6a 04                	push   $0x4
  801274:	e8 63 ff ff ff       	call   8011dc <syscall>
  801279:	83 c4 18             	add    $0x18,%esp
}
  80127c:	90                   	nop
  80127d:	c9                   	leave  
  80127e:	c3                   	ret    

0080127f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801282:	8b 55 0c             	mov    0xc(%ebp),%edx
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	6a 00                	push   $0x0
  80128a:	6a 00                	push   $0x0
  80128c:	6a 00                	push   $0x0
  80128e:	52                   	push   %edx
  80128f:	50                   	push   %eax
  801290:	6a 08                	push   $0x8
  801292:	e8 45 ff ff ff       	call   8011dc <syscall>
  801297:	83 c4 18             	add    $0x18,%esp
}
  80129a:	c9                   	leave  
  80129b:	c3                   	ret    

0080129c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	56                   	push   %esi
  8012a0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012a1:	8b 75 18             	mov    0x18(%ebp),%esi
  8012a4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b0:	56                   	push   %esi
  8012b1:	53                   	push   %ebx
  8012b2:	51                   	push   %ecx
  8012b3:	52                   	push   %edx
  8012b4:	50                   	push   %eax
  8012b5:	6a 09                	push   $0x9
  8012b7:	e8 20 ff ff ff       	call   8011dc <syscall>
  8012bc:	83 c4 18             	add    $0x18,%esp
}
  8012bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012c2:	5b                   	pop    %ebx
  8012c3:	5e                   	pop    %esi
  8012c4:	5d                   	pop    %ebp
  8012c5:	c3                   	ret    

008012c6 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8012c6:	55                   	push   %ebp
  8012c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8012c9:	6a 00                	push   $0x0
  8012cb:	6a 00                	push   $0x0
  8012cd:	6a 00                	push   $0x0
  8012cf:	6a 00                	push   $0x0
  8012d1:	ff 75 08             	pushl  0x8(%ebp)
  8012d4:	6a 0a                	push   $0xa
  8012d6:	e8 01 ff ff ff       	call   8011dc <syscall>
  8012db:	83 c4 18             	add    $0x18,%esp
}
  8012de:	c9                   	leave  
  8012df:	c3                   	ret    

008012e0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8012e3:	6a 00                	push   $0x0
  8012e5:	6a 00                	push   $0x0
  8012e7:	6a 00                	push   $0x0
  8012e9:	ff 75 0c             	pushl  0xc(%ebp)
  8012ec:	ff 75 08             	pushl  0x8(%ebp)
  8012ef:	6a 0b                	push   $0xb
  8012f1:	e8 e6 fe ff ff       	call   8011dc <syscall>
  8012f6:	83 c4 18             	add    $0x18,%esp
}
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    

008012fb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8012fe:	6a 00                	push   $0x0
  801300:	6a 00                	push   $0x0
  801302:	6a 00                	push   $0x0
  801304:	6a 00                	push   $0x0
  801306:	6a 00                	push   $0x0
  801308:	6a 0c                	push   $0xc
  80130a:	e8 cd fe ff ff       	call   8011dc <syscall>
  80130f:	83 c4 18             	add    $0x18,%esp
}
  801312:	c9                   	leave  
  801313:	c3                   	ret    

00801314 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801314:	55                   	push   %ebp
  801315:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801317:	6a 00                	push   $0x0
  801319:	6a 00                	push   $0x0
  80131b:	6a 00                	push   $0x0
  80131d:	6a 00                	push   $0x0
  80131f:	6a 00                	push   $0x0
  801321:	6a 0d                	push   $0xd
  801323:	e8 b4 fe ff ff       	call   8011dc <syscall>
  801328:	83 c4 18             	add    $0x18,%esp
}
  80132b:	c9                   	leave  
  80132c:	c3                   	ret    

0080132d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801330:	6a 00                	push   $0x0
  801332:	6a 00                	push   $0x0
  801334:	6a 00                	push   $0x0
  801336:	6a 00                	push   $0x0
  801338:	6a 00                	push   $0x0
  80133a:	6a 0e                	push   $0xe
  80133c:	e8 9b fe ff ff       	call   8011dc <syscall>
  801341:	83 c4 18             	add    $0x18,%esp
}
  801344:	c9                   	leave  
  801345:	c3                   	ret    

00801346 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801346:	55                   	push   %ebp
  801347:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 00                	push   $0x0
  80134f:	6a 00                	push   $0x0
  801351:	6a 00                	push   $0x0
  801353:	6a 0f                	push   $0xf
  801355:	e8 82 fe ff ff       	call   8011dc <syscall>
  80135a:	83 c4 18             	add    $0x18,%esp
}
  80135d:	c9                   	leave  
  80135e:	c3                   	ret    

0080135f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801362:	6a 00                	push   $0x0
  801364:	6a 00                	push   $0x0
  801366:	6a 00                	push   $0x0
  801368:	6a 00                	push   $0x0
  80136a:	ff 75 08             	pushl  0x8(%ebp)
  80136d:	6a 10                	push   $0x10
  80136f:	e8 68 fe ff ff       	call   8011dc <syscall>
  801374:	83 c4 18             	add    $0x18,%esp
}
  801377:	c9                   	leave  
  801378:	c3                   	ret    

00801379 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801379:	55                   	push   %ebp
  80137a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80137c:	6a 00                	push   $0x0
  80137e:	6a 00                	push   $0x0
  801380:	6a 00                	push   $0x0
  801382:	6a 00                	push   $0x0
  801384:	6a 00                	push   $0x0
  801386:	6a 11                	push   $0x11
  801388:	e8 4f fe ff ff       	call   8011dc <syscall>
  80138d:	83 c4 18             	add    $0x18,%esp
}
  801390:	90                   	nop
  801391:	c9                   	leave  
  801392:	c3                   	ret    

00801393 <sys_cputc>:

void
sys_cputc(const char c)
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
  801396:	83 ec 04             	sub    $0x4,%esp
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80139f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 00                	push   $0x0
  8013ab:	50                   	push   %eax
  8013ac:	6a 01                	push   $0x1
  8013ae:	e8 29 fe ff ff       	call   8011dc <syscall>
  8013b3:	83 c4 18             	add    $0x18,%esp
}
  8013b6:	90                   	nop
  8013b7:	c9                   	leave  
  8013b8:	c3                   	ret    

008013b9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013b9:	55                   	push   %ebp
  8013ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013bc:	6a 00                	push   $0x0
  8013be:	6a 00                	push   $0x0
  8013c0:	6a 00                	push   $0x0
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 14                	push   $0x14
  8013c8:	e8 0f fe ff ff       	call   8011dc <syscall>
  8013cd:	83 c4 18             	add    $0x18,%esp
}
  8013d0:	90                   	nop
  8013d1:	c9                   	leave  
  8013d2:	c3                   	ret    

008013d3 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
  8013d6:	83 ec 04             	sub    $0x4,%esp
  8013d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8013df:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013e2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e9:	6a 00                	push   $0x0
  8013eb:	51                   	push   %ecx
  8013ec:	52                   	push   %edx
  8013ed:	ff 75 0c             	pushl  0xc(%ebp)
  8013f0:	50                   	push   %eax
  8013f1:	6a 15                	push   $0x15
  8013f3:	e8 e4 fd ff ff       	call   8011dc <syscall>
  8013f8:	83 c4 18             	add    $0x18,%esp
}
  8013fb:	c9                   	leave  
  8013fc:	c3                   	ret    

008013fd <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801400:	8b 55 0c             	mov    0xc(%ebp),%edx
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	6a 00                	push   $0x0
  801408:	6a 00                	push   $0x0
  80140a:	6a 00                	push   $0x0
  80140c:	52                   	push   %edx
  80140d:	50                   	push   %eax
  80140e:	6a 16                	push   $0x16
  801410:	e8 c7 fd ff ff       	call   8011dc <syscall>
  801415:	83 c4 18             	add    $0x18,%esp
}
  801418:	c9                   	leave  
  801419:	c3                   	ret    

0080141a <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80141d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801420:	8b 55 0c             	mov    0xc(%ebp),%edx
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	51                   	push   %ecx
  80142b:	52                   	push   %edx
  80142c:	50                   	push   %eax
  80142d:	6a 17                	push   $0x17
  80142f:	e8 a8 fd ff ff       	call   8011dc <syscall>
  801434:	83 c4 18             	add    $0x18,%esp
}
  801437:	c9                   	leave  
  801438:	c3                   	ret    

00801439 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80143c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	52                   	push   %edx
  801449:	50                   	push   %eax
  80144a:	6a 18                	push   $0x18
  80144c:	e8 8b fd ff ff       	call   8011dc <syscall>
  801451:	83 c4 18             	add    $0x18,%esp
}
  801454:	c9                   	leave  
  801455:	c3                   	ret    

00801456 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801459:	8b 45 08             	mov    0x8(%ebp),%eax
  80145c:	6a 00                	push   $0x0
  80145e:	ff 75 14             	pushl  0x14(%ebp)
  801461:	ff 75 10             	pushl  0x10(%ebp)
  801464:	ff 75 0c             	pushl  0xc(%ebp)
  801467:	50                   	push   %eax
  801468:	6a 19                	push   $0x19
  80146a:	e8 6d fd ff ff       	call   8011dc <syscall>
  80146f:	83 c4 18             	add    $0x18,%esp
}
  801472:	c9                   	leave  
  801473:	c3                   	ret    

00801474 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	6a 00                	push   $0x0
  80147c:	6a 00                	push   $0x0
  80147e:	6a 00                	push   $0x0
  801480:	6a 00                	push   $0x0
  801482:	50                   	push   %eax
  801483:	6a 1a                	push   $0x1a
  801485:	e8 52 fd ff ff       	call   8011dc <syscall>
  80148a:	83 c4 18             	add    $0x18,%esp
}
  80148d:	90                   	nop
  80148e:	c9                   	leave  
  80148f:	c3                   	ret    

00801490 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801493:	8b 45 08             	mov    0x8(%ebp),%eax
  801496:	6a 00                	push   $0x0
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	50                   	push   %eax
  80149f:	6a 1b                	push   $0x1b
  8014a1:	e8 36 fd ff ff       	call   8011dc <syscall>
  8014a6:	83 c4 18             	add    $0x18,%esp
}
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    

008014ab <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014ae:	6a 00                	push   $0x0
  8014b0:	6a 00                	push   $0x0
  8014b2:	6a 00                	push   $0x0
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 05                	push   $0x5
  8014ba:	e8 1d fd ff ff       	call   8011dc <syscall>
  8014bf:	83 c4 18             	add    $0x18,%esp
}
  8014c2:	c9                   	leave  
  8014c3:	c3                   	ret    

008014c4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 00                	push   $0x0
  8014cd:	6a 00                	push   $0x0
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 06                	push   $0x6
  8014d3:	e8 04 fd ff ff       	call   8011dc <syscall>
  8014d8:	83 c4 18             	add    $0x18,%esp
}
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    

008014dd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 00                	push   $0x0
  8014ea:	6a 07                	push   $0x7
  8014ec:	e8 eb fc ff ff       	call   8011dc <syscall>
  8014f1:	83 c4 18             	add    $0x18,%esp
}
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <sys_exit_env>:


void sys_exit_env(void)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	6a 1c                	push   $0x1c
  801505:	e8 d2 fc ff ff       	call   8011dc <syscall>
  80150a:	83 c4 18             	add    $0x18,%esp
}
  80150d:	90                   	nop
  80150e:	c9                   	leave  
  80150f:	c3                   	ret    

00801510 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801516:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801519:	8d 50 04             	lea    0x4(%eax),%edx
  80151c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80151f:	6a 00                	push   $0x0
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	52                   	push   %edx
  801526:	50                   	push   %eax
  801527:	6a 1d                	push   $0x1d
  801529:	e8 ae fc ff ff       	call   8011dc <syscall>
  80152e:	83 c4 18             	add    $0x18,%esp
	return result;
  801531:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801534:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801537:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80153a:	89 01                	mov    %eax,(%ecx)
  80153c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	c9                   	leave  
  801543:	c2 04 00             	ret    $0x4

00801546 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	ff 75 10             	pushl  0x10(%ebp)
  801550:	ff 75 0c             	pushl  0xc(%ebp)
  801553:	ff 75 08             	pushl  0x8(%ebp)
  801556:	6a 13                	push   $0x13
  801558:	e8 7f fc ff ff       	call   8011dc <syscall>
  80155d:	83 c4 18             	add    $0x18,%esp
	return ;
  801560:	90                   	nop
}
  801561:	c9                   	leave  
  801562:	c3                   	ret    

00801563 <sys_rcr2>:
uint32 sys_rcr2()
{
  801563:	55                   	push   %ebp
  801564:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801566:	6a 00                	push   $0x0
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	6a 1e                	push   $0x1e
  801572:	e8 65 fc ff ff       	call   8011dc <syscall>
  801577:	83 c4 18             	add    $0x18,%esp
}
  80157a:	c9                   	leave  
  80157b:	c3                   	ret    

0080157c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
  80157f:	83 ec 04             	sub    $0x4,%esp
  801582:	8b 45 08             	mov    0x8(%ebp),%eax
  801585:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801588:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	50                   	push   %eax
  801595:	6a 1f                	push   $0x1f
  801597:	e8 40 fc ff ff       	call   8011dc <syscall>
  80159c:	83 c4 18             	add    $0x18,%esp
	return ;
  80159f:	90                   	nop
}
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

008015a2 <rsttst>:
void rsttst()
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 21                	push   $0x21
  8015b1:	e8 26 fc ff ff       	call   8011dc <syscall>
  8015b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8015b9:	90                   	nop
}
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    

008015bc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	83 ec 04             	sub    $0x4,%esp
  8015c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015c8:	8b 55 18             	mov    0x18(%ebp),%edx
  8015cb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015cf:	52                   	push   %edx
  8015d0:	50                   	push   %eax
  8015d1:	ff 75 10             	pushl  0x10(%ebp)
  8015d4:	ff 75 0c             	pushl  0xc(%ebp)
  8015d7:	ff 75 08             	pushl  0x8(%ebp)
  8015da:	6a 20                	push   $0x20
  8015dc:	e8 fb fb ff ff       	call   8011dc <syscall>
  8015e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8015e4:	90                   	nop
}
  8015e5:	c9                   	leave  
  8015e6:	c3                   	ret    

008015e7 <chktst>:
void chktst(uint32 n)
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	ff 75 08             	pushl  0x8(%ebp)
  8015f5:	6a 22                	push   $0x22
  8015f7:	e8 e0 fb ff ff       	call   8011dc <syscall>
  8015fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8015ff:	90                   	nop
}
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <inctst>:

void inctst()
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 23                	push   $0x23
  801611:	e8 c6 fb ff ff       	call   8011dc <syscall>
  801616:	83 c4 18             	add    $0x18,%esp
	return ;
  801619:	90                   	nop
}
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <gettst>:
uint32 gettst()
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 24                	push   $0x24
  80162b:	e8 ac fb ff ff       	call   8011dc <syscall>
  801630:	83 c4 18             	add    $0x18,%esp
}
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 25                	push   $0x25
  801644:	e8 93 fb ff ff       	call   8011dc <syscall>
  801649:	83 c4 18             	add    $0x18,%esp
  80164c:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801651:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801656:	c9                   	leave  
  801657:	c3                   	ret    

00801658 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80165b:	8b 45 08             	mov    0x8(%ebp),%eax
  80165e:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	ff 75 08             	pushl  0x8(%ebp)
  80166e:	6a 26                	push   $0x26
  801670:	e8 67 fb ff ff       	call   8011dc <syscall>
  801675:	83 c4 18             	add    $0x18,%esp
	return ;
  801678:	90                   	nop
}
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80167f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801682:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801685:	8b 55 0c             	mov    0xc(%ebp),%edx
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	6a 00                	push   $0x0
  80168d:	53                   	push   %ebx
  80168e:	51                   	push   %ecx
  80168f:	52                   	push   %edx
  801690:	50                   	push   %eax
  801691:	6a 27                	push   $0x27
  801693:	e8 44 fb ff ff       	call   8011dc <syscall>
  801698:	83 c4 18             	add    $0x18,%esp
}
  80169b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8016a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	52                   	push   %edx
  8016b0:	50                   	push   %eax
  8016b1:	6a 28                	push   $0x28
  8016b3:	e8 24 fb ff ff       	call   8011dc <syscall>
  8016b8:	83 c4 18             	add    $0x18,%esp
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8016c0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c9:	6a 00                	push   $0x0
  8016cb:	51                   	push   %ecx
  8016cc:	ff 75 10             	pushl  0x10(%ebp)
  8016cf:	52                   	push   %edx
  8016d0:	50                   	push   %eax
  8016d1:	6a 29                	push   $0x29
  8016d3:	e8 04 fb ff ff       	call   8011dc <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
}
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	ff 75 10             	pushl  0x10(%ebp)
  8016e7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ea:	ff 75 08             	pushl  0x8(%ebp)
  8016ed:	6a 12                	push   $0x12
  8016ef:	e8 e8 fa ff ff       	call   8011dc <syscall>
  8016f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f7:	90                   	nop
}
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8016fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	52                   	push   %edx
  80170a:	50                   	push   %eax
  80170b:	6a 2a                	push   $0x2a
  80170d:	e8 ca fa ff ff       	call   8011dc <syscall>
  801712:	83 c4 18             	add    $0x18,%esp
	return;
  801715:	90                   	nop
}
  801716:	c9                   	leave  
  801717:	c3                   	ret    

00801718 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 2b                	push   $0x2b
  801727:	e8 b0 fa ff ff       	call   8011dc <syscall>
  80172c:	83 c4 18             	add    $0x18,%esp
}
  80172f:	c9                   	leave  
  801730:	c3                   	ret    

00801731 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	ff 75 0c             	pushl  0xc(%ebp)
  80173d:	ff 75 08             	pushl  0x8(%ebp)
  801740:	6a 2d                	push   $0x2d
  801742:	e8 95 fa ff ff       	call   8011dc <syscall>
  801747:	83 c4 18             	add    $0x18,%esp
	return;
  80174a:	90                   	nop
}
  80174b:	c9                   	leave  
  80174c:	c3                   	ret    

0080174d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	ff 75 0c             	pushl  0xc(%ebp)
  801759:	ff 75 08             	pushl  0x8(%ebp)
  80175c:	6a 2c                	push   $0x2c
  80175e:	e8 79 fa ff ff       	call   8011dc <syscall>
  801763:	83 c4 18             	add    $0x18,%esp
	return ;
  801766:	90                   	nop
}
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
  80176c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  80176f:	83 ec 04             	sub    $0x4,%esp
  801772:	68 28 21 80 00       	push   $0x802128
  801777:	68 25 01 00 00       	push   $0x125
  80177c:	68 5b 21 80 00       	push   $0x80215b
  801781:	e8 00 00 00 00       	call   801786 <_panic>

00801786 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80178c:	8d 45 10             	lea    0x10(%ebp),%eax
  80178f:	83 c0 04             	add    $0x4,%eax
  801792:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801795:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  80179a:	85 c0                	test   %eax,%eax
  80179c:	74 16                	je     8017b4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80179e:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  8017a3:	83 ec 08             	sub    $0x8,%esp
  8017a6:	50                   	push   %eax
  8017a7:	68 6c 21 80 00       	push   $0x80216c
  8017ac:	e8 46 eb ff ff       	call   8002f7 <cprintf>
  8017b1:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8017b4:	a1 04 30 80 00       	mov    0x803004,%eax
  8017b9:	83 ec 0c             	sub    $0xc,%esp
  8017bc:	ff 75 0c             	pushl  0xc(%ebp)
  8017bf:	ff 75 08             	pushl  0x8(%ebp)
  8017c2:	50                   	push   %eax
  8017c3:	68 74 21 80 00       	push   $0x802174
  8017c8:	6a 74                	push   $0x74
  8017ca:	e8 55 eb ff ff       	call   800324 <cprintf_colored>
  8017cf:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8017d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d5:	83 ec 08             	sub    $0x8,%esp
  8017d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8017db:	50                   	push   %eax
  8017dc:	e8 a7 ea ff ff       	call   800288 <vcprintf>
  8017e1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8017e4:	83 ec 08             	sub    $0x8,%esp
  8017e7:	6a 00                	push   $0x0
  8017e9:	68 9c 21 80 00       	push   $0x80219c
  8017ee:	e8 95 ea ff ff       	call   800288 <vcprintf>
  8017f3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8017f6:	e8 0e ea ff ff       	call   800209 <exit>

	// should not return here
	while (1) ;
  8017fb:	eb fe                	jmp    8017fb <_panic+0x75>

008017fd <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801803:	a1 20 30 80 00       	mov    0x803020,%eax
  801808:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80180e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801811:	39 c2                	cmp    %eax,%edx
  801813:	74 14                	je     801829 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801815:	83 ec 04             	sub    $0x4,%esp
  801818:	68 a0 21 80 00       	push   $0x8021a0
  80181d:	6a 26                	push   $0x26
  80181f:	68 ec 21 80 00       	push   $0x8021ec
  801824:	e8 5d ff ff ff       	call   801786 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801829:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801830:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801837:	e9 c5 00 00 00       	jmp    801901 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80183c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80183f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	01 d0                	add    %edx,%eax
  80184b:	8b 00                	mov    (%eax),%eax
  80184d:	85 c0                	test   %eax,%eax
  80184f:	75 08                	jne    801859 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801851:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801854:	e9 a5 00 00 00       	jmp    8018fe <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801859:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801860:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801867:	eb 69                	jmp    8018d2 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801869:	a1 20 30 80 00       	mov    0x803020,%eax
  80186e:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801874:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801877:	89 d0                	mov    %edx,%eax
  801879:	01 c0                	add    %eax,%eax
  80187b:	01 d0                	add    %edx,%eax
  80187d:	c1 e0 03             	shl    $0x3,%eax
  801880:	01 c8                	add    %ecx,%eax
  801882:	8a 40 04             	mov    0x4(%eax),%al
  801885:	84 c0                	test   %al,%al
  801887:	75 46                	jne    8018cf <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801889:	a1 20 30 80 00       	mov    0x803020,%eax
  80188e:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801894:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801897:	89 d0                	mov    %edx,%eax
  801899:	01 c0                	add    %eax,%eax
  80189b:	01 d0                	add    %edx,%eax
  80189d:	c1 e0 03             	shl    $0x3,%eax
  8018a0:	01 c8                	add    %ecx,%eax
  8018a2:	8b 00                	mov    (%eax),%eax
  8018a4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8018a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018af:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8018b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	01 c8                	add    %ecx,%eax
  8018c0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018c2:	39 c2                	cmp    %eax,%edx
  8018c4:	75 09                	jne    8018cf <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8018c6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8018cd:	eb 15                	jmp    8018e4 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018cf:	ff 45 e8             	incl   -0x18(%ebp)
  8018d2:	a1 20 30 80 00       	mov    0x803020,%eax
  8018d7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8018dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018e0:	39 c2                	cmp    %eax,%edx
  8018e2:	77 85                	ja     801869 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8018e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018e8:	75 14                	jne    8018fe <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8018ea:	83 ec 04             	sub    $0x4,%esp
  8018ed:	68 f8 21 80 00       	push   $0x8021f8
  8018f2:	6a 3a                	push   $0x3a
  8018f4:	68 ec 21 80 00       	push   $0x8021ec
  8018f9:	e8 88 fe ff ff       	call   801786 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8018fe:	ff 45 f0             	incl   -0x10(%ebp)
  801901:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801904:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801907:	0f 8c 2f ff ff ff    	jl     80183c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80190d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801914:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80191b:	eb 26                	jmp    801943 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80191d:	a1 20 30 80 00       	mov    0x803020,%eax
  801922:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801928:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80192b:	89 d0                	mov    %edx,%eax
  80192d:	01 c0                	add    %eax,%eax
  80192f:	01 d0                	add    %edx,%eax
  801931:	c1 e0 03             	shl    $0x3,%eax
  801934:	01 c8                	add    %ecx,%eax
  801936:	8a 40 04             	mov    0x4(%eax),%al
  801939:	3c 01                	cmp    $0x1,%al
  80193b:	75 03                	jne    801940 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80193d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801940:	ff 45 e0             	incl   -0x20(%ebp)
  801943:	a1 20 30 80 00       	mov    0x803020,%eax
  801948:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80194e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801951:	39 c2                	cmp    %eax,%edx
  801953:	77 c8                	ja     80191d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801958:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80195b:	74 14                	je     801971 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80195d:	83 ec 04             	sub    $0x4,%esp
  801960:	68 4c 22 80 00       	push   $0x80224c
  801965:	6a 44                	push   $0x44
  801967:	68 ec 21 80 00       	push   $0x8021ec
  80196c:	e8 15 fe ff ff       	call   801786 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801971:	90                   	nop
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <__udivdi3>:
  801974:	55                   	push   %ebp
  801975:	57                   	push   %edi
  801976:	56                   	push   %esi
  801977:	53                   	push   %ebx
  801978:	83 ec 1c             	sub    $0x1c,%esp
  80197b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80197f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801983:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801987:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80198b:	89 ca                	mov    %ecx,%edx
  80198d:	89 f8                	mov    %edi,%eax
  80198f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801993:	85 f6                	test   %esi,%esi
  801995:	75 2d                	jne    8019c4 <__udivdi3+0x50>
  801997:	39 cf                	cmp    %ecx,%edi
  801999:	77 65                	ja     801a00 <__udivdi3+0x8c>
  80199b:	89 fd                	mov    %edi,%ebp
  80199d:	85 ff                	test   %edi,%edi
  80199f:	75 0b                	jne    8019ac <__udivdi3+0x38>
  8019a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8019a6:	31 d2                	xor    %edx,%edx
  8019a8:	f7 f7                	div    %edi
  8019aa:	89 c5                	mov    %eax,%ebp
  8019ac:	31 d2                	xor    %edx,%edx
  8019ae:	89 c8                	mov    %ecx,%eax
  8019b0:	f7 f5                	div    %ebp
  8019b2:	89 c1                	mov    %eax,%ecx
  8019b4:	89 d8                	mov    %ebx,%eax
  8019b6:	f7 f5                	div    %ebp
  8019b8:	89 cf                	mov    %ecx,%edi
  8019ba:	89 fa                	mov    %edi,%edx
  8019bc:	83 c4 1c             	add    $0x1c,%esp
  8019bf:	5b                   	pop    %ebx
  8019c0:	5e                   	pop    %esi
  8019c1:	5f                   	pop    %edi
  8019c2:	5d                   	pop    %ebp
  8019c3:	c3                   	ret    
  8019c4:	39 ce                	cmp    %ecx,%esi
  8019c6:	77 28                	ja     8019f0 <__udivdi3+0x7c>
  8019c8:	0f bd fe             	bsr    %esi,%edi
  8019cb:	83 f7 1f             	xor    $0x1f,%edi
  8019ce:	75 40                	jne    801a10 <__udivdi3+0x9c>
  8019d0:	39 ce                	cmp    %ecx,%esi
  8019d2:	72 0a                	jb     8019de <__udivdi3+0x6a>
  8019d4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019d8:	0f 87 9e 00 00 00    	ja     801a7c <__udivdi3+0x108>
  8019de:	b8 01 00 00 00       	mov    $0x1,%eax
  8019e3:	89 fa                	mov    %edi,%edx
  8019e5:	83 c4 1c             	add    $0x1c,%esp
  8019e8:	5b                   	pop    %ebx
  8019e9:	5e                   	pop    %esi
  8019ea:	5f                   	pop    %edi
  8019eb:	5d                   	pop    %ebp
  8019ec:	c3                   	ret    
  8019ed:	8d 76 00             	lea    0x0(%esi),%esi
  8019f0:	31 ff                	xor    %edi,%edi
  8019f2:	31 c0                	xor    %eax,%eax
  8019f4:	89 fa                	mov    %edi,%edx
  8019f6:	83 c4 1c             	add    $0x1c,%esp
  8019f9:	5b                   	pop    %ebx
  8019fa:	5e                   	pop    %esi
  8019fb:	5f                   	pop    %edi
  8019fc:	5d                   	pop    %ebp
  8019fd:	c3                   	ret    
  8019fe:	66 90                	xchg   %ax,%ax
  801a00:	89 d8                	mov    %ebx,%eax
  801a02:	f7 f7                	div    %edi
  801a04:	31 ff                	xor    %edi,%edi
  801a06:	89 fa                	mov    %edi,%edx
  801a08:	83 c4 1c             	add    $0x1c,%esp
  801a0b:	5b                   	pop    %ebx
  801a0c:	5e                   	pop    %esi
  801a0d:	5f                   	pop    %edi
  801a0e:	5d                   	pop    %ebp
  801a0f:	c3                   	ret    
  801a10:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a15:	89 eb                	mov    %ebp,%ebx
  801a17:	29 fb                	sub    %edi,%ebx
  801a19:	89 f9                	mov    %edi,%ecx
  801a1b:	d3 e6                	shl    %cl,%esi
  801a1d:	89 c5                	mov    %eax,%ebp
  801a1f:	88 d9                	mov    %bl,%cl
  801a21:	d3 ed                	shr    %cl,%ebp
  801a23:	89 e9                	mov    %ebp,%ecx
  801a25:	09 f1                	or     %esi,%ecx
  801a27:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a2b:	89 f9                	mov    %edi,%ecx
  801a2d:	d3 e0                	shl    %cl,%eax
  801a2f:	89 c5                	mov    %eax,%ebp
  801a31:	89 d6                	mov    %edx,%esi
  801a33:	88 d9                	mov    %bl,%cl
  801a35:	d3 ee                	shr    %cl,%esi
  801a37:	89 f9                	mov    %edi,%ecx
  801a39:	d3 e2                	shl    %cl,%edx
  801a3b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a3f:	88 d9                	mov    %bl,%cl
  801a41:	d3 e8                	shr    %cl,%eax
  801a43:	09 c2                	or     %eax,%edx
  801a45:	89 d0                	mov    %edx,%eax
  801a47:	89 f2                	mov    %esi,%edx
  801a49:	f7 74 24 0c          	divl   0xc(%esp)
  801a4d:	89 d6                	mov    %edx,%esi
  801a4f:	89 c3                	mov    %eax,%ebx
  801a51:	f7 e5                	mul    %ebp
  801a53:	39 d6                	cmp    %edx,%esi
  801a55:	72 19                	jb     801a70 <__udivdi3+0xfc>
  801a57:	74 0b                	je     801a64 <__udivdi3+0xf0>
  801a59:	89 d8                	mov    %ebx,%eax
  801a5b:	31 ff                	xor    %edi,%edi
  801a5d:	e9 58 ff ff ff       	jmp    8019ba <__udivdi3+0x46>
  801a62:	66 90                	xchg   %ax,%ax
  801a64:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a68:	89 f9                	mov    %edi,%ecx
  801a6a:	d3 e2                	shl    %cl,%edx
  801a6c:	39 c2                	cmp    %eax,%edx
  801a6e:	73 e9                	jae    801a59 <__udivdi3+0xe5>
  801a70:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a73:	31 ff                	xor    %edi,%edi
  801a75:	e9 40 ff ff ff       	jmp    8019ba <__udivdi3+0x46>
  801a7a:	66 90                	xchg   %ax,%ax
  801a7c:	31 c0                	xor    %eax,%eax
  801a7e:	e9 37 ff ff ff       	jmp    8019ba <__udivdi3+0x46>
  801a83:	90                   	nop

00801a84 <__umoddi3>:
  801a84:	55                   	push   %ebp
  801a85:	57                   	push   %edi
  801a86:	56                   	push   %esi
  801a87:	53                   	push   %ebx
  801a88:	83 ec 1c             	sub    $0x1c,%esp
  801a8b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a97:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a9f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801aa3:	89 f3                	mov    %esi,%ebx
  801aa5:	89 fa                	mov    %edi,%edx
  801aa7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801aab:	89 34 24             	mov    %esi,(%esp)
  801aae:	85 c0                	test   %eax,%eax
  801ab0:	75 1a                	jne    801acc <__umoddi3+0x48>
  801ab2:	39 f7                	cmp    %esi,%edi
  801ab4:	0f 86 a2 00 00 00    	jbe    801b5c <__umoddi3+0xd8>
  801aba:	89 c8                	mov    %ecx,%eax
  801abc:	89 f2                	mov    %esi,%edx
  801abe:	f7 f7                	div    %edi
  801ac0:	89 d0                	mov    %edx,%eax
  801ac2:	31 d2                	xor    %edx,%edx
  801ac4:	83 c4 1c             	add    $0x1c,%esp
  801ac7:	5b                   	pop    %ebx
  801ac8:	5e                   	pop    %esi
  801ac9:	5f                   	pop    %edi
  801aca:	5d                   	pop    %ebp
  801acb:	c3                   	ret    
  801acc:	39 f0                	cmp    %esi,%eax
  801ace:	0f 87 ac 00 00 00    	ja     801b80 <__umoddi3+0xfc>
  801ad4:	0f bd e8             	bsr    %eax,%ebp
  801ad7:	83 f5 1f             	xor    $0x1f,%ebp
  801ada:	0f 84 ac 00 00 00    	je     801b8c <__umoddi3+0x108>
  801ae0:	bf 20 00 00 00       	mov    $0x20,%edi
  801ae5:	29 ef                	sub    %ebp,%edi
  801ae7:	89 fe                	mov    %edi,%esi
  801ae9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801aed:	89 e9                	mov    %ebp,%ecx
  801aef:	d3 e0                	shl    %cl,%eax
  801af1:	89 d7                	mov    %edx,%edi
  801af3:	89 f1                	mov    %esi,%ecx
  801af5:	d3 ef                	shr    %cl,%edi
  801af7:	09 c7                	or     %eax,%edi
  801af9:	89 e9                	mov    %ebp,%ecx
  801afb:	d3 e2                	shl    %cl,%edx
  801afd:	89 14 24             	mov    %edx,(%esp)
  801b00:	89 d8                	mov    %ebx,%eax
  801b02:	d3 e0                	shl    %cl,%eax
  801b04:	89 c2                	mov    %eax,%edx
  801b06:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b0a:	d3 e0                	shl    %cl,%eax
  801b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b10:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b14:	89 f1                	mov    %esi,%ecx
  801b16:	d3 e8                	shr    %cl,%eax
  801b18:	09 d0                	or     %edx,%eax
  801b1a:	d3 eb                	shr    %cl,%ebx
  801b1c:	89 da                	mov    %ebx,%edx
  801b1e:	f7 f7                	div    %edi
  801b20:	89 d3                	mov    %edx,%ebx
  801b22:	f7 24 24             	mull   (%esp)
  801b25:	89 c6                	mov    %eax,%esi
  801b27:	89 d1                	mov    %edx,%ecx
  801b29:	39 d3                	cmp    %edx,%ebx
  801b2b:	0f 82 87 00 00 00    	jb     801bb8 <__umoddi3+0x134>
  801b31:	0f 84 91 00 00 00    	je     801bc8 <__umoddi3+0x144>
  801b37:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b3b:	29 f2                	sub    %esi,%edx
  801b3d:	19 cb                	sbb    %ecx,%ebx
  801b3f:	89 d8                	mov    %ebx,%eax
  801b41:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b45:	d3 e0                	shl    %cl,%eax
  801b47:	89 e9                	mov    %ebp,%ecx
  801b49:	d3 ea                	shr    %cl,%edx
  801b4b:	09 d0                	or     %edx,%eax
  801b4d:	89 e9                	mov    %ebp,%ecx
  801b4f:	d3 eb                	shr    %cl,%ebx
  801b51:	89 da                	mov    %ebx,%edx
  801b53:	83 c4 1c             	add    $0x1c,%esp
  801b56:	5b                   	pop    %ebx
  801b57:	5e                   	pop    %esi
  801b58:	5f                   	pop    %edi
  801b59:	5d                   	pop    %ebp
  801b5a:	c3                   	ret    
  801b5b:	90                   	nop
  801b5c:	89 fd                	mov    %edi,%ebp
  801b5e:	85 ff                	test   %edi,%edi
  801b60:	75 0b                	jne    801b6d <__umoddi3+0xe9>
  801b62:	b8 01 00 00 00       	mov    $0x1,%eax
  801b67:	31 d2                	xor    %edx,%edx
  801b69:	f7 f7                	div    %edi
  801b6b:	89 c5                	mov    %eax,%ebp
  801b6d:	89 f0                	mov    %esi,%eax
  801b6f:	31 d2                	xor    %edx,%edx
  801b71:	f7 f5                	div    %ebp
  801b73:	89 c8                	mov    %ecx,%eax
  801b75:	f7 f5                	div    %ebp
  801b77:	89 d0                	mov    %edx,%eax
  801b79:	e9 44 ff ff ff       	jmp    801ac2 <__umoddi3+0x3e>
  801b7e:	66 90                	xchg   %ax,%ax
  801b80:	89 c8                	mov    %ecx,%eax
  801b82:	89 f2                	mov    %esi,%edx
  801b84:	83 c4 1c             	add    $0x1c,%esp
  801b87:	5b                   	pop    %ebx
  801b88:	5e                   	pop    %esi
  801b89:	5f                   	pop    %edi
  801b8a:	5d                   	pop    %ebp
  801b8b:	c3                   	ret    
  801b8c:	3b 04 24             	cmp    (%esp),%eax
  801b8f:	72 06                	jb     801b97 <__umoddi3+0x113>
  801b91:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b95:	77 0f                	ja     801ba6 <__umoddi3+0x122>
  801b97:	89 f2                	mov    %esi,%edx
  801b99:	29 f9                	sub    %edi,%ecx
  801b9b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b9f:	89 14 24             	mov    %edx,(%esp)
  801ba2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ba6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801baa:	8b 14 24             	mov    (%esp),%edx
  801bad:	83 c4 1c             	add    $0x1c,%esp
  801bb0:	5b                   	pop    %ebx
  801bb1:	5e                   	pop    %esi
  801bb2:	5f                   	pop    %edi
  801bb3:	5d                   	pop    %ebp
  801bb4:	c3                   	ret    
  801bb5:	8d 76 00             	lea    0x0(%esi),%esi
  801bb8:	2b 04 24             	sub    (%esp),%eax
  801bbb:	19 fa                	sbb    %edi,%edx
  801bbd:	89 d1                	mov    %edx,%ecx
  801bbf:	89 c6                	mov    %eax,%esi
  801bc1:	e9 71 ff ff ff       	jmp    801b37 <__umoddi3+0xb3>
  801bc6:	66 90                	xchg   %ax,%ax
  801bc8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bcc:	72 ea                	jb     801bb8 <__umoddi3+0x134>
  801bce:	89 d9                	mov    %ebx,%ecx
  801bd0:	e9 62 ff ff ff       	jmp    801b37 <__umoddi3+0xb3>

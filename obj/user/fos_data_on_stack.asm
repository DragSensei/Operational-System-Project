
obj/user/fos_data_on_stack:     file format elf32-i386


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
  800031:	e8 1e 00 00 00       	call   800054 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 48 27 00 00    	sub    $0x2748,%esp
	/// Adding array of 512 integer on user stack
	int arr[2512];

	atomic_cprintf("user stack contains 512 integer\n");
  800041:	83 ec 0c             	sub    $0xc,%esp
  800044:	68 e0 1b 80 00       	push   $0x801be0
  800049:	e8 08 03 00 00       	call   800356 <atomic_cprintf>
  80004e:	83 c4 10             	add    $0x10,%esp

	return;	
  800051:	90                   	nop
}
  800052:	c9                   	leave  
  800053:	c3                   	ret    

00800054 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	57                   	push   %edi
  800058:	56                   	push   %esi
  800059:	53                   	push   %ebx
  80005a:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80005d:	e8 4f 14 00 00       	call   8014b1 <sys_getenvindex>
  800062:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800065:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800068:	89 d0                	mov    %edx,%eax
  80006a:	c1 e0 02             	shl    $0x2,%eax
  80006d:	01 d0                	add    %edx,%eax
  80006f:	c1 e0 03             	shl    $0x3,%eax
  800072:	01 d0                	add    %edx,%eax
  800074:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80007b:	01 d0                	add    %edx,%eax
  80007d:	c1 e0 02             	shl    $0x2,%eax
  800080:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800085:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80008a:	a1 20 30 80 00       	mov    0x803020,%eax
  80008f:	8a 40 20             	mov    0x20(%eax),%al
  800092:	84 c0                	test   %al,%al
  800094:	74 0d                	je     8000a3 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800096:	a1 20 30 80 00       	mov    0x803020,%eax
  80009b:	83 c0 20             	add    $0x20,%eax
  80009e:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a7:	7e 0a                	jle    8000b3 <libmain+0x5f>
		binaryname = argv[0];
  8000a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ac:	8b 00                	mov    (%eax),%eax
  8000ae:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	ff 75 0c             	pushl  0xc(%ebp)
  8000b9:	ff 75 08             	pushl  0x8(%ebp)
  8000bc:	e8 77 ff ff ff       	call   800038 <_main>
  8000c1:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000c4:	a1 00 30 80 00       	mov    0x803000,%eax
  8000c9:	85 c0                	test   %eax,%eax
  8000cb:	0f 84 01 01 00 00    	je     8001d2 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8000d1:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8000d7:	bb fc 1c 80 00       	mov    $0x801cfc,%ebx
  8000dc:	ba 0e 00 00 00       	mov    $0xe,%edx
  8000e1:	89 c7                	mov    %eax,%edi
  8000e3:	89 de                	mov    %ebx,%esi
  8000e5:	89 d1                	mov    %edx,%ecx
  8000e7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000e9:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8000ec:	b9 56 00 00 00       	mov    $0x56,%ecx
  8000f1:	b0 00                	mov    $0x0,%al
  8000f3:	89 d7                	mov    %edx,%edi
  8000f5:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8000f7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8000fe:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800101:	83 ec 08             	sub    $0x8,%esp
  800104:	50                   	push   %eax
  800105:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80010b:	50                   	push   %eax
  80010c:	e8 d6 15 00 00       	call   8016e7 <sys_utilities>
  800111:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800114:	e8 1f 11 00 00       	call   801238 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	68 1c 1c 80 00       	push   $0x801c1c
  800121:	e8 be 01 00 00       	call   8002e4 <cprintf>
  800126:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800129:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012c:	85 c0                	test   %eax,%eax
  80012e:	74 18                	je     800148 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800130:	e8 d0 15 00 00       	call   801705 <sys_get_optimal_num_faults>
  800135:	83 ec 08             	sub    $0x8,%esp
  800138:	50                   	push   %eax
  800139:	68 44 1c 80 00       	push   $0x801c44
  80013e:	e8 a1 01 00 00       	call   8002e4 <cprintf>
  800143:	83 c4 10             	add    $0x10,%esp
  800146:	eb 59                	jmp    8001a1 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800148:	a1 20 30 80 00       	mov    0x803020,%eax
  80014d:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800153:	a1 20 30 80 00       	mov    0x803020,%eax
  800158:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80015e:	83 ec 04             	sub    $0x4,%esp
  800161:	52                   	push   %edx
  800162:	50                   	push   %eax
  800163:	68 68 1c 80 00       	push   $0x801c68
  800168:	e8 77 01 00 00       	call   8002e4 <cprintf>
  80016d:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800170:	a1 20 30 80 00       	mov    0x803020,%eax
  800175:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80017b:	a1 20 30 80 00       	mov    0x803020,%eax
  800180:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800186:	a1 20 30 80 00       	mov    0x803020,%eax
  80018b:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800191:	51                   	push   %ecx
  800192:	52                   	push   %edx
  800193:	50                   	push   %eax
  800194:	68 90 1c 80 00       	push   $0x801c90
  800199:	e8 46 01 00 00       	call   8002e4 <cprintf>
  80019e:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001a1:	a1 20 30 80 00       	mov    0x803020,%eax
  8001a6:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8001ac:	83 ec 08             	sub    $0x8,%esp
  8001af:	50                   	push   %eax
  8001b0:	68 e8 1c 80 00       	push   $0x801ce8
  8001b5:	e8 2a 01 00 00       	call   8002e4 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	68 1c 1c 80 00       	push   $0x801c1c
  8001c5:	e8 1a 01 00 00       	call   8002e4 <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001cd:	e8 80 10 00 00       	call   801252 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001d2:	e8 1f 00 00 00       	call   8001f6 <exit>
}
  8001d7:	90                   	nop
  8001d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001db:	5b                   	pop    %ebx
  8001dc:	5e                   	pop    %esi
  8001dd:	5f                   	pop    %edi
  8001de:	5d                   	pop    %ebp
  8001df:	c3                   	ret    

008001e0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001e0:	55                   	push   %ebp
  8001e1:	89 e5                	mov    %esp,%ebp
  8001e3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001e6:	83 ec 0c             	sub    $0xc,%esp
  8001e9:	6a 00                	push   $0x0
  8001eb:	e8 8d 12 00 00       	call   80147d <sys_destroy_env>
  8001f0:	83 c4 10             	add    $0x10,%esp
}
  8001f3:	90                   	nop
  8001f4:	c9                   	leave  
  8001f5:	c3                   	ret    

008001f6 <exit>:

void
exit(void)
{
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
  8001f9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001fc:	e8 e2 12 00 00       	call   8014e3 <sys_exit_env>
}
  800201:	90                   	nop
  800202:	c9                   	leave  
  800203:	c3                   	ret    

00800204 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800204:	55                   	push   %ebp
  800205:	89 e5                	mov    %esp,%ebp
  800207:	53                   	push   %ebx
  800208:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80020b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020e:	8b 00                	mov    (%eax),%eax
  800210:	8d 48 01             	lea    0x1(%eax),%ecx
  800213:	8b 55 0c             	mov    0xc(%ebp),%edx
  800216:	89 0a                	mov    %ecx,(%edx)
  800218:	8b 55 08             	mov    0x8(%ebp),%edx
  80021b:	88 d1                	mov    %dl,%cl
  80021d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800220:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800224:	8b 45 0c             	mov    0xc(%ebp),%eax
  800227:	8b 00                	mov    (%eax),%eax
  800229:	3d ff 00 00 00       	cmp    $0xff,%eax
  80022e:	75 30                	jne    800260 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800230:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  800236:	a0 44 30 80 00       	mov    0x803044,%al
  80023b:	0f b6 c0             	movzbl %al,%eax
  80023e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800241:	8b 09                	mov    (%ecx),%ecx
  800243:	89 cb                	mov    %ecx,%ebx
  800245:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800248:	83 c1 08             	add    $0x8,%ecx
  80024b:	52                   	push   %edx
  80024c:	50                   	push   %eax
  80024d:	53                   	push   %ebx
  80024e:	51                   	push   %ecx
  80024f:	e8 a0 0f 00 00       	call   8011f4 <sys_cputs>
  800254:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80025a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800260:	8b 45 0c             	mov    0xc(%ebp),%eax
  800263:	8b 40 04             	mov    0x4(%eax),%eax
  800266:	8d 50 01             	lea    0x1(%eax),%edx
  800269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80026c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80026f:	90                   	nop
  800270:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800273:	c9                   	leave  
  800274:	c3                   	ret    

00800275 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800275:	55                   	push   %ebp
  800276:	89 e5                	mov    %esp,%ebp
  800278:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80027e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800285:	00 00 00 
	b.cnt = 0;
  800288:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80028f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800292:	ff 75 0c             	pushl  0xc(%ebp)
  800295:	ff 75 08             	pushl  0x8(%ebp)
  800298:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80029e:	50                   	push   %eax
  80029f:	68 04 02 80 00       	push   $0x800204
  8002a4:	e8 5a 02 00 00       	call   800503 <vprintfmt>
  8002a9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8002ac:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8002b2:	a0 44 30 80 00       	mov    0x803044,%al
  8002b7:	0f b6 c0             	movzbl %al,%eax
  8002ba:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8002c0:	52                   	push   %edx
  8002c1:	50                   	push   %eax
  8002c2:	51                   	push   %ecx
  8002c3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002c9:	83 c0 08             	add    $0x8,%eax
  8002cc:	50                   	push   %eax
  8002cd:	e8 22 0f 00 00       	call   8011f4 <sys_cputs>
  8002d2:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002d5:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8002dc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002e2:	c9                   	leave  
  8002e3:	c3                   	ret    

008002e4 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002e4:	55                   	push   %ebp
  8002e5:	89 e5                	mov    %esp,%ebp
  8002e7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002ea:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8002f1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fa:	83 ec 08             	sub    $0x8,%esp
  8002fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800300:	50                   	push   %eax
  800301:	e8 6f ff ff ff       	call   800275 <vcprintf>
  800306:	83 c4 10             	add    $0x10,%esp
  800309:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80030c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80030f:	c9                   	leave  
  800310:	c3                   	ret    

00800311 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800317:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80031e:	8b 45 08             	mov    0x8(%ebp),%eax
  800321:	c1 e0 08             	shl    $0x8,%eax
  800324:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  800329:	8d 45 0c             	lea    0xc(%ebp),%eax
  80032c:	83 c0 04             	add    $0x4,%eax
  80032f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800332:	8b 45 0c             	mov    0xc(%ebp),%eax
  800335:	83 ec 08             	sub    $0x8,%esp
  800338:	ff 75 f4             	pushl  -0xc(%ebp)
  80033b:	50                   	push   %eax
  80033c:	e8 34 ff ff ff       	call   800275 <vcprintf>
  800341:	83 c4 10             	add    $0x10,%esp
  800344:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800347:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  80034e:	07 00 00 

	return cnt;
  800351:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800354:	c9                   	leave  
  800355:	c3                   	ret    

00800356 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
  800359:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80035c:	e8 d7 0e 00 00       	call   801238 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800361:	8d 45 0c             	lea    0xc(%ebp),%eax
  800364:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800367:	8b 45 08             	mov    0x8(%ebp),%eax
  80036a:	83 ec 08             	sub    $0x8,%esp
  80036d:	ff 75 f4             	pushl  -0xc(%ebp)
  800370:	50                   	push   %eax
  800371:	e8 ff fe ff ff       	call   800275 <vcprintf>
  800376:	83 c4 10             	add    $0x10,%esp
  800379:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80037c:	e8 d1 0e 00 00       	call   801252 <sys_unlock_cons>
	return cnt;
  800381:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800384:	c9                   	leave  
  800385:	c3                   	ret    

00800386 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
  800389:	53                   	push   %ebx
  80038a:	83 ec 14             	sub    $0x14,%esp
  80038d:	8b 45 10             	mov    0x10(%ebp),%eax
  800390:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800393:	8b 45 14             	mov    0x14(%ebp),%eax
  800396:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800399:	8b 45 18             	mov    0x18(%ebp),%eax
  80039c:	ba 00 00 00 00       	mov    $0x0,%edx
  8003a1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003a4:	77 55                	ja     8003fb <printnum+0x75>
  8003a6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003a9:	72 05                	jb     8003b0 <printnum+0x2a>
  8003ab:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003ae:	77 4b                	ja     8003fb <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003b0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003b3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003b6:	8b 45 18             	mov    0x18(%ebp),%eax
  8003b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8003be:	52                   	push   %edx
  8003bf:	50                   	push   %eax
  8003c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c3:	ff 75 f0             	pushl  -0x10(%ebp)
  8003c6:	e8 99 15 00 00       	call   801964 <__udivdi3>
  8003cb:	83 c4 10             	add    $0x10,%esp
  8003ce:	83 ec 04             	sub    $0x4,%esp
  8003d1:	ff 75 20             	pushl  0x20(%ebp)
  8003d4:	53                   	push   %ebx
  8003d5:	ff 75 18             	pushl  0x18(%ebp)
  8003d8:	52                   	push   %edx
  8003d9:	50                   	push   %eax
  8003da:	ff 75 0c             	pushl  0xc(%ebp)
  8003dd:	ff 75 08             	pushl  0x8(%ebp)
  8003e0:	e8 a1 ff ff ff       	call   800386 <printnum>
  8003e5:	83 c4 20             	add    $0x20,%esp
  8003e8:	eb 1a                	jmp    800404 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003ea:	83 ec 08             	sub    $0x8,%esp
  8003ed:	ff 75 0c             	pushl  0xc(%ebp)
  8003f0:	ff 75 20             	pushl  0x20(%ebp)
  8003f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f6:	ff d0                	call   *%eax
  8003f8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003fb:	ff 4d 1c             	decl   0x1c(%ebp)
  8003fe:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800402:	7f e6                	jg     8003ea <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800404:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800407:	bb 00 00 00 00       	mov    $0x0,%ebx
  80040c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80040f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800412:	53                   	push   %ebx
  800413:	51                   	push   %ecx
  800414:	52                   	push   %edx
  800415:	50                   	push   %eax
  800416:	e8 59 16 00 00       	call   801a74 <__umoddi3>
  80041b:	83 c4 10             	add    $0x10,%esp
  80041e:	05 74 1f 80 00       	add    $0x801f74,%eax
  800423:	8a 00                	mov    (%eax),%al
  800425:	0f be c0             	movsbl %al,%eax
  800428:	83 ec 08             	sub    $0x8,%esp
  80042b:	ff 75 0c             	pushl  0xc(%ebp)
  80042e:	50                   	push   %eax
  80042f:	8b 45 08             	mov    0x8(%ebp),%eax
  800432:	ff d0                	call   *%eax
  800434:	83 c4 10             	add    $0x10,%esp
}
  800437:	90                   	nop
  800438:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80043b:	c9                   	leave  
  80043c:	c3                   	ret    

0080043d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80043d:	55                   	push   %ebp
  80043e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800440:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800444:	7e 1c                	jle    800462 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800446:	8b 45 08             	mov    0x8(%ebp),%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	8d 50 08             	lea    0x8(%eax),%edx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	89 10                	mov    %edx,(%eax)
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	8b 00                	mov    (%eax),%eax
  800458:	83 e8 08             	sub    $0x8,%eax
  80045b:	8b 50 04             	mov    0x4(%eax),%edx
  80045e:	8b 00                	mov    (%eax),%eax
  800460:	eb 40                	jmp    8004a2 <getuint+0x65>
	else if (lflag)
  800462:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800466:	74 1e                	je     800486 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800468:	8b 45 08             	mov    0x8(%ebp),%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	8d 50 04             	lea    0x4(%eax),%edx
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	89 10                	mov    %edx,(%eax)
  800475:	8b 45 08             	mov    0x8(%ebp),%eax
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	83 e8 04             	sub    $0x4,%eax
  80047d:	8b 00                	mov    (%eax),%eax
  80047f:	ba 00 00 00 00       	mov    $0x0,%edx
  800484:	eb 1c                	jmp    8004a2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800486:	8b 45 08             	mov    0x8(%ebp),%eax
  800489:	8b 00                	mov    (%eax),%eax
  80048b:	8d 50 04             	lea    0x4(%eax),%edx
  80048e:	8b 45 08             	mov    0x8(%ebp),%eax
  800491:	89 10                	mov    %edx,(%eax)
  800493:	8b 45 08             	mov    0x8(%ebp),%eax
  800496:	8b 00                	mov    (%eax),%eax
  800498:	83 e8 04             	sub    $0x4,%eax
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004a2:	5d                   	pop    %ebp
  8004a3:	c3                   	ret    

008004a4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004a4:	55                   	push   %ebp
  8004a5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004a7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004ab:	7e 1c                	jle    8004c9 <getint+0x25>
		return va_arg(*ap, long long);
  8004ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	8d 50 08             	lea    0x8(%eax),%edx
  8004b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b8:	89 10                	mov    %edx,(%eax)
  8004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bd:	8b 00                	mov    (%eax),%eax
  8004bf:	83 e8 08             	sub    $0x8,%eax
  8004c2:	8b 50 04             	mov    0x4(%eax),%edx
  8004c5:	8b 00                	mov    (%eax),%eax
  8004c7:	eb 38                	jmp    800501 <getint+0x5d>
	else if (lflag)
  8004c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004cd:	74 1a                	je     8004e9 <getint+0x45>
		return va_arg(*ap, long);
  8004cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d2:	8b 00                	mov    (%eax),%eax
  8004d4:	8d 50 04             	lea    0x4(%eax),%edx
  8004d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004da:	89 10                	mov    %edx,(%eax)
  8004dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004df:	8b 00                	mov    (%eax),%eax
  8004e1:	83 e8 04             	sub    $0x4,%eax
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	99                   	cltd   
  8004e7:	eb 18                	jmp    800501 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ec:	8b 00                	mov    (%eax),%eax
  8004ee:	8d 50 04             	lea    0x4(%eax),%edx
  8004f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f4:	89 10                	mov    %edx,(%eax)
  8004f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f9:	8b 00                	mov    (%eax),%eax
  8004fb:	83 e8 04             	sub    $0x4,%eax
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	99                   	cltd   
}
  800501:	5d                   	pop    %ebp
  800502:	c3                   	ret    

00800503 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800503:	55                   	push   %ebp
  800504:	89 e5                	mov    %esp,%ebp
  800506:	56                   	push   %esi
  800507:	53                   	push   %ebx
  800508:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80050b:	eb 17                	jmp    800524 <vprintfmt+0x21>
			if (ch == '\0')
  80050d:	85 db                	test   %ebx,%ebx
  80050f:	0f 84 c1 03 00 00    	je     8008d6 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800515:	83 ec 08             	sub    $0x8,%esp
  800518:	ff 75 0c             	pushl  0xc(%ebp)
  80051b:	53                   	push   %ebx
  80051c:	8b 45 08             	mov    0x8(%ebp),%eax
  80051f:	ff d0                	call   *%eax
  800521:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800524:	8b 45 10             	mov    0x10(%ebp),%eax
  800527:	8d 50 01             	lea    0x1(%eax),%edx
  80052a:	89 55 10             	mov    %edx,0x10(%ebp)
  80052d:	8a 00                	mov    (%eax),%al
  80052f:	0f b6 d8             	movzbl %al,%ebx
  800532:	83 fb 25             	cmp    $0x25,%ebx
  800535:	75 d6                	jne    80050d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800537:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80053b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800542:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800549:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800550:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800557:	8b 45 10             	mov    0x10(%ebp),%eax
  80055a:	8d 50 01             	lea    0x1(%eax),%edx
  80055d:	89 55 10             	mov    %edx,0x10(%ebp)
  800560:	8a 00                	mov    (%eax),%al
  800562:	0f b6 d8             	movzbl %al,%ebx
  800565:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800568:	83 f8 5b             	cmp    $0x5b,%eax
  80056b:	0f 87 3d 03 00 00    	ja     8008ae <vprintfmt+0x3ab>
  800571:	8b 04 85 98 1f 80 00 	mov    0x801f98(,%eax,4),%eax
  800578:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80057a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80057e:	eb d7                	jmp    800557 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800580:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800584:	eb d1                	jmp    800557 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800586:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80058d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800590:	89 d0                	mov    %edx,%eax
  800592:	c1 e0 02             	shl    $0x2,%eax
  800595:	01 d0                	add    %edx,%eax
  800597:	01 c0                	add    %eax,%eax
  800599:	01 d8                	add    %ebx,%eax
  80059b:	83 e8 30             	sub    $0x30,%eax
  80059e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8005a4:	8a 00                	mov    (%eax),%al
  8005a6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005a9:	83 fb 2f             	cmp    $0x2f,%ebx
  8005ac:	7e 3e                	jle    8005ec <vprintfmt+0xe9>
  8005ae:	83 fb 39             	cmp    $0x39,%ebx
  8005b1:	7f 39                	jg     8005ec <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005b3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005b6:	eb d5                	jmp    80058d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bb:	83 c0 04             	add    $0x4,%eax
  8005be:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c4:	83 e8 04             	sub    $0x4,%eax
  8005c7:	8b 00                	mov    (%eax),%eax
  8005c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005cc:	eb 1f                	jmp    8005ed <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005d2:	79 83                	jns    800557 <vprintfmt+0x54>
				width = 0;
  8005d4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005db:	e9 77 ff ff ff       	jmp    800557 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005e0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005e7:	e9 6b ff ff ff       	jmp    800557 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005ec:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005f1:	0f 89 60 ff ff ff    	jns    800557 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005fd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800604:	e9 4e ff ff ff       	jmp    800557 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800609:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80060c:	e9 46 ff ff ff       	jmp    800557 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800611:	8b 45 14             	mov    0x14(%ebp),%eax
  800614:	83 c0 04             	add    $0x4,%eax
  800617:	89 45 14             	mov    %eax,0x14(%ebp)
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	83 e8 04             	sub    $0x4,%eax
  800620:	8b 00                	mov    (%eax),%eax
  800622:	83 ec 08             	sub    $0x8,%esp
  800625:	ff 75 0c             	pushl  0xc(%ebp)
  800628:	50                   	push   %eax
  800629:	8b 45 08             	mov    0x8(%ebp),%eax
  80062c:	ff d0                	call   *%eax
  80062e:	83 c4 10             	add    $0x10,%esp
			break;
  800631:	e9 9b 02 00 00       	jmp    8008d1 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	83 c0 04             	add    $0x4,%eax
  80063c:	89 45 14             	mov    %eax,0x14(%ebp)
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	83 e8 04             	sub    $0x4,%eax
  800645:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800647:	85 db                	test   %ebx,%ebx
  800649:	79 02                	jns    80064d <vprintfmt+0x14a>
				err = -err;
  80064b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80064d:	83 fb 64             	cmp    $0x64,%ebx
  800650:	7f 0b                	jg     80065d <vprintfmt+0x15a>
  800652:	8b 34 9d e0 1d 80 00 	mov    0x801de0(,%ebx,4),%esi
  800659:	85 f6                	test   %esi,%esi
  80065b:	75 19                	jne    800676 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80065d:	53                   	push   %ebx
  80065e:	68 85 1f 80 00       	push   $0x801f85
  800663:	ff 75 0c             	pushl  0xc(%ebp)
  800666:	ff 75 08             	pushl  0x8(%ebp)
  800669:	e8 70 02 00 00       	call   8008de <printfmt>
  80066e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800671:	e9 5b 02 00 00       	jmp    8008d1 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800676:	56                   	push   %esi
  800677:	68 8e 1f 80 00       	push   $0x801f8e
  80067c:	ff 75 0c             	pushl  0xc(%ebp)
  80067f:	ff 75 08             	pushl  0x8(%ebp)
  800682:	e8 57 02 00 00       	call   8008de <printfmt>
  800687:	83 c4 10             	add    $0x10,%esp
			break;
  80068a:	e9 42 02 00 00       	jmp    8008d1 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	83 c0 04             	add    $0x4,%eax
  800695:	89 45 14             	mov    %eax,0x14(%ebp)
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	83 e8 04             	sub    $0x4,%eax
  80069e:	8b 30                	mov    (%eax),%esi
  8006a0:	85 f6                	test   %esi,%esi
  8006a2:	75 05                	jne    8006a9 <vprintfmt+0x1a6>
				p = "(null)";
  8006a4:	be 91 1f 80 00       	mov    $0x801f91,%esi
			if (width > 0 && padc != '-')
  8006a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ad:	7e 6d                	jle    80071c <vprintfmt+0x219>
  8006af:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006b3:	74 67                	je     80071c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006b8:	83 ec 08             	sub    $0x8,%esp
  8006bb:	50                   	push   %eax
  8006bc:	56                   	push   %esi
  8006bd:	e8 1e 03 00 00       	call   8009e0 <strnlen>
  8006c2:	83 c4 10             	add    $0x10,%esp
  8006c5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006c8:	eb 16                	jmp    8006e0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006ca:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006ce:	83 ec 08             	sub    $0x8,%esp
  8006d1:	ff 75 0c             	pushl  0xc(%ebp)
  8006d4:	50                   	push   %eax
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	ff d0                	call   *%eax
  8006da:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006dd:	ff 4d e4             	decl   -0x1c(%ebp)
  8006e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006e4:	7f e4                	jg     8006ca <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006e6:	eb 34                	jmp    80071c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006e8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006ec:	74 1c                	je     80070a <vprintfmt+0x207>
  8006ee:	83 fb 1f             	cmp    $0x1f,%ebx
  8006f1:	7e 05                	jle    8006f8 <vprintfmt+0x1f5>
  8006f3:	83 fb 7e             	cmp    $0x7e,%ebx
  8006f6:	7e 12                	jle    80070a <vprintfmt+0x207>
					putch('?', putdat);
  8006f8:	83 ec 08             	sub    $0x8,%esp
  8006fb:	ff 75 0c             	pushl  0xc(%ebp)
  8006fe:	6a 3f                	push   $0x3f
  800700:	8b 45 08             	mov    0x8(%ebp),%eax
  800703:	ff d0                	call   *%eax
  800705:	83 c4 10             	add    $0x10,%esp
  800708:	eb 0f                	jmp    800719 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80070a:	83 ec 08             	sub    $0x8,%esp
  80070d:	ff 75 0c             	pushl  0xc(%ebp)
  800710:	53                   	push   %ebx
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	ff d0                	call   *%eax
  800716:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800719:	ff 4d e4             	decl   -0x1c(%ebp)
  80071c:	89 f0                	mov    %esi,%eax
  80071e:	8d 70 01             	lea    0x1(%eax),%esi
  800721:	8a 00                	mov    (%eax),%al
  800723:	0f be d8             	movsbl %al,%ebx
  800726:	85 db                	test   %ebx,%ebx
  800728:	74 24                	je     80074e <vprintfmt+0x24b>
  80072a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80072e:	78 b8                	js     8006e8 <vprintfmt+0x1e5>
  800730:	ff 4d e0             	decl   -0x20(%ebp)
  800733:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800737:	79 af                	jns    8006e8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800739:	eb 13                	jmp    80074e <vprintfmt+0x24b>
				putch(' ', putdat);
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	ff 75 0c             	pushl  0xc(%ebp)
  800741:	6a 20                	push   $0x20
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	ff d0                	call   *%eax
  800748:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80074b:	ff 4d e4             	decl   -0x1c(%ebp)
  80074e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800752:	7f e7                	jg     80073b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800754:	e9 78 01 00 00       	jmp    8008d1 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800759:	83 ec 08             	sub    $0x8,%esp
  80075c:	ff 75 e8             	pushl  -0x18(%ebp)
  80075f:	8d 45 14             	lea    0x14(%ebp),%eax
  800762:	50                   	push   %eax
  800763:	e8 3c fd ff ff       	call   8004a4 <getint>
  800768:	83 c4 10             	add    $0x10,%esp
  80076b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80076e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800771:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800774:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800777:	85 d2                	test   %edx,%edx
  800779:	79 23                	jns    80079e <vprintfmt+0x29b>
				putch('-', putdat);
  80077b:	83 ec 08             	sub    $0x8,%esp
  80077e:	ff 75 0c             	pushl  0xc(%ebp)
  800781:	6a 2d                	push   $0x2d
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	ff d0                	call   *%eax
  800788:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80078b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800791:	f7 d8                	neg    %eax
  800793:	83 d2 00             	adc    $0x0,%edx
  800796:	f7 da                	neg    %edx
  800798:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80079b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80079e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007a5:	e9 bc 00 00 00       	jmp    800866 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007aa:	83 ec 08             	sub    $0x8,%esp
  8007ad:	ff 75 e8             	pushl  -0x18(%ebp)
  8007b0:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b3:	50                   	push   %eax
  8007b4:	e8 84 fc ff ff       	call   80043d <getuint>
  8007b9:	83 c4 10             	add    $0x10,%esp
  8007bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007bf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007c2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007c9:	e9 98 00 00 00       	jmp    800866 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007ce:	83 ec 08             	sub    $0x8,%esp
  8007d1:	ff 75 0c             	pushl  0xc(%ebp)
  8007d4:	6a 58                	push   $0x58
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	ff d0                	call   *%eax
  8007db:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007de:	83 ec 08             	sub    $0x8,%esp
  8007e1:	ff 75 0c             	pushl  0xc(%ebp)
  8007e4:	6a 58                	push   $0x58
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	ff d0                	call   *%eax
  8007eb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	ff 75 0c             	pushl  0xc(%ebp)
  8007f4:	6a 58                	push   $0x58
  8007f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f9:	ff d0                	call   *%eax
  8007fb:	83 c4 10             	add    $0x10,%esp
			break;
  8007fe:	e9 ce 00 00 00       	jmp    8008d1 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800803:	83 ec 08             	sub    $0x8,%esp
  800806:	ff 75 0c             	pushl  0xc(%ebp)
  800809:	6a 30                	push   $0x30
  80080b:	8b 45 08             	mov    0x8(%ebp),%eax
  80080e:	ff d0                	call   *%eax
  800810:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800813:	83 ec 08             	sub    $0x8,%esp
  800816:	ff 75 0c             	pushl  0xc(%ebp)
  800819:	6a 78                	push   $0x78
  80081b:	8b 45 08             	mov    0x8(%ebp),%eax
  80081e:	ff d0                	call   *%eax
  800820:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800823:	8b 45 14             	mov    0x14(%ebp),%eax
  800826:	83 c0 04             	add    $0x4,%eax
  800829:	89 45 14             	mov    %eax,0x14(%ebp)
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	83 e8 04             	sub    $0x4,%eax
  800832:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800834:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800837:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80083e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800845:	eb 1f                	jmp    800866 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800847:	83 ec 08             	sub    $0x8,%esp
  80084a:	ff 75 e8             	pushl  -0x18(%ebp)
  80084d:	8d 45 14             	lea    0x14(%ebp),%eax
  800850:	50                   	push   %eax
  800851:	e8 e7 fb ff ff       	call   80043d <getuint>
  800856:	83 c4 10             	add    $0x10,%esp
  800859:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80085c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80085f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800866:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80086a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80086d:	83 ec 04             	sub    $0x4,%esp
  800870:	52                   	push   %edx
  800871:	ff 75 e4             	pushl  -0x1c(%ebp)
  800874:	50                   	push   %eax
  800875:	ff 75 f4             	pushl  -0xc(%ebp)
  800878:	ff 75 f0             	pushl  -0x10(%ebp)
  80087b:	ff 75 0c             	pushl  0xc(%ebp)
  80087e:	ff 75 08             	pushl  0x8(%ebp)
  800881:	e8 00 fb ff ff       	call   800386 <printnum>
  800886:	83 c4 20             	add    $0x20,%esp
			break;
  800889:	eb 46                	jmp    8008d1 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80088b:	83 ec 08             	sub    $0x8,%esp
  80088e:	ff 75 0c             	pushl  0xc(%ebp)
  800891:	53                   	push   %ebx
  800892:	8b 45 08             	mov    0x8(%ebp),%eax
  800895:	ff d0                	call   *%eax
  800897:	83 c4 10             	add    $0x10,%esp
			break;
  80089a:	eb 35                	jmp    8008d1 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80089c:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  8008a3:	eb 2c                	jmp    8008d1 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8008a5:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  8008ac:	eb 23                	jmp    8008d1 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	ff 75 0c             	pushl  0xc(%ebp)
  8008b4:	6a 25                	push   $0x25
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	ff d0                	call   *%eax
  8008bb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008be:	ff 4d 10             	decl   0x10(%ebp)
  8008c1:	eb 03                	jmp    8008c6 <vprintfmt+0x3c3>
  8008c3:	ff 4d 10             	decl   0x10(%ebp)
  8008c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c9:	48                   	dec    %eax
  8008ca:	8a 00                	mov    (%eax),%al
  8008cc:	3c 25                	cmp    $0x25,%al
  8008ce:	75 f3                	jne    8008c3 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008d0:	90                   	nop
		}
	}
  8008d1:	e9 35 fc ff ff       	jmp    80050b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008d6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008da:	5b                   	pop    %ebx
  8008db:	5e                   	pop    %esi
  8008dc:	5d                   	pop    %ebp
  8008dd:	c3                   	ret    

008008de <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008de:	55                   	push   %ebp
  8008df:	89 e5                	mov    %esp,%ebp
  8008e1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008e4:	8d 45 10             	lea    0x10(%ebp),%eax
  8008e7:	83 c0 04             	add    $0x4,%eax
  8008ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8008f3:	50                   	push   %eax
  8008f4:	ff 75 0c             	pushl  0xc(%ebp)
  8008f7:	ff 75 08             	pushl  0x8(%ebp)
  8008fa:	e8 04 fc ff ff       	call   800503 <vprintfmt>
  8008ff:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800902:	90                   	nop
  800903:	c9                   	leave  
  800904:	c3                   	ret    

00800905 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800908:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090b:	8b 40 08             	mov    0x8(%eax),%eax
  80090e:	8d 50 01             	lea    0x1(%eax),%edx
  800911:	8b 45 0c             	mov    0xc(%ebp),%eax
  800914:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800917:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091a:	8b 10                	mov    (%eax),%edx
  80091c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091f:	8b 40 04             	mov    0x4(%eax),%eax
  800922:	39 c2                	cmp    %eax,%edx
  800924:	73 12                	jae    800938 <sprintputch+0x33>
		*b->buf++ = ch;
  800926:	8b 45 0c             	mov    0xc(%ebp),%eax
  800929:	8b 00                	mov    (%eax),%eax
  80092b:	8d 48 01             	lea    0x1(%eax),%ecx
  80092e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800931:	89 0a                	mov    %ecx,(%edx)
  800933:	8b 55 08             	mov    0x8(%ebp),%edx
  800936:	88 10                	mov    %dl,(%eax)
}
  800938:	90                   	nop
  800939:	5d                   	pop    %ebp
  80093a:	c3                   	ret    

0080093b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800947:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	01 d0                	add    %edx,%eax
  800952:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800955:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80095c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800960:	74 06                	je     800968 <vsnprintf+0x2d>
  800962:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800966:	7f 07                	jg     80096f <vsnprintf+0x34>
		return -E_INVAL;
  800968:	b8 03 00 00 00       	mov    $0x3,%eax
  80096d:	eb 20                	jmp    80098f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80096f:	ff 75 14             	pushl  0x14(%ebp)
  800972:	ff 75 10             	pushl  0x10(%ebp)
  800975:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800978:	50                   	push   %eax
  800979:	68 05 09 80 00       	push   $0x800905
  80097e:	e8 80 fb ff ff       	call   800503 <vprintfmt>
  800983:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800986:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800989:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80098c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80098f:	c9                   	leave  
  800990:	c3                   	ret    

00800991 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800997:	8d 45 10             	lea    0x10(%ebp),%eax
  80099a:	83 c0 04             	add    $0x4,%eax
  80099d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a6:	50                   	push   %eax
  8009a7:	ff 75 0c             	pushl  0xc(%ebp)
  8009aa:	ff 75 08             	pushl  0x8(%ebp)
  8009ad:	e8 89 ff ff ff       	call   80093b <vsnprintf>
  8009b2:	83 c4 10             	add    $0x10,%esp
  8009b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009bb:	c9                   	leave  
  8009bc:	c3                   	ret    

008009bd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009bd:	55                   	push   %ebp
  8009be:	89 e5                	mov    %esp,%ebp
  8009c0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009ca:	eb 06                	jmp    8009d2 <strlen+0x15>
		n++;
  8009cc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009cf:	ff 45 08             	incl   0x8(%ebp)
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	8a 00                	mov    (%eax),%al
  8009d7:	84 c0                	test   %al,%al
  8009d9:	75 f1                	jne    8009cc <strlen+0xf>
		n++;
	return n;
  8009db:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009de:	c9                   	leave  
  8009df:	c3                   	ret    

008009e0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009ed:	eb 09                	jmp    8009f8 <strnlen+0x18>
		n++;
  8009ef:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009f2:	ff 45 08             	incl   0x8(%ebp)
  8009f5:	ff 4d 0c             	decl   0xc(%ebp)
  8009f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009fc:	74 09                	je     800a07 <strnlen+0x27>
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	8a 00                	mov    (%eax),%al
  800a03:	84 c0                	test   %al,%al
  800a05:	75 e8                	jne    8009ef <strnlen+0xf>
		n++;
	return n;
  800a07:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a0a:	c9                   	leave  
  800a0b:	c3                   	ret    

00800a0c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a18:	90                   	nop
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	8d 50 01             	lea    0x1(%eax),%edx
  800a1f:	89 55 08             	mov    %edx,0x8(%ebp)
  800a22:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a25:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a28:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a2b:	8a 12                	mov    (%edx),%dl
  800a2d:	88 10                	mov    %dl,(%eax)
  800a2f:	8a 00                	mov    (%eax),%al
  800a31:	84 c0                	test   %al,%al
  800a33:	75 e4                	jne    800a19 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a35:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a38:	c9                   	leave  
  800a39:	c3                   	ret    

00800a3a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a40:	8b 45 08             	mov    0x8(%ebp),%eax
  800a43:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a4d:	eb 1f                	jmp    800a6e <strncpy+0x34>
		*dst++ = *src;
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	8d 50 01             	lea    0x1(%eax),%edx
  800a55:	89 55 08             	mov    %edx,0x8(%ebp)
  800a58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5b:	8a 12                	mov    (%edx),%dl
  800a5d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a62:	8a 00                	mov    (%eax),%al
  800a64:	84 c0                	test   %al,%al
  800a66:	74 03                	je     800a6b <strncpy+0x31>
			src++;
  800a68:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a6b:	ff 45 fc             	incl   -0x4(%ebp)
  800a6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a71:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a74:	72 d9                	jb     800a4f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a76:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a79:	c9                   	leave  
  800a7a:	c3                   	ret    

00800a7b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a8b:	74 30                	je     800abd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a8d:	eb 16                	jmp    800aa5 <strlcpy+0x2a>
			*dst++ = *src++;
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	8d 50 01             	lea    0x1(%eax),%edx
  800a95:	89 55 08             	mov    %edx,0x8(%ebp)
  800a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a9e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800aa1:	8a 12                	mov    (%edx),%dl
  800aa3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800aa5:	ff 4d 10             	decl   0x10(%ebp)
  800aa8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aac:	74 09                	je     800ab7 <strlcpy+0x3c>
  800aae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab1:	8a 00                	mov    (%eax),%al
  800ab3:	84 c0                	test   %al,%al
  800ab5:	75 d8                	jne    800a8f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800abd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ac0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ac3:	29 c2                	sub    %eax,%edx
  800ac5:	89 d0                	mov    %edx,%eax
}
  800ac7:	c9                   	leave  
  800ac8:	c3                   	ret    

00800ac9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ac9:	55                   	push   %ebp
  800aca:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800acc:	eb 06                	jmp    800ad4 <strcmp+0xb>
		p++, q++;
  800ace:	ff 45 08             	incl   0x8(%ebp)
  800ad1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	8a 00                	mov    (%eax),%al
  800ad9:	84 c0                	test   %al,%al
  800adb:	74 0e                	je     800aeb <strcmp+0x22>
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	8a 10                	mov    (%eax),%dl
  800ae2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae5:	8a 00                	mov    (%eax),%al
  800ae7:	38 c2                	cmp    %al,%dl
  800ae9:	74 e3                	je     800ace <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	8a 00                	mov    (%eax),%al
  800af0:	0f b6 d0             	movzbl %al,%edx
  800af3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af6:	8a 00                	mov    (%eax),%al
  800af8:	0f b6 c0             	movzbl %al,%eax
  800afb:	29 c2                	sub    %eax,%edx
  800afd:	89 d0                	mov    %edx,%eax
}
  800aff:	5d                   	pop    %ebp
  800b00:	c3                   	ret    

00800b01 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b01:	55                   	push   %ebp
  800b02:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b04:	eb 09                	jmp    800b0f <strncmp+0xe>
		n--, p++, q++;
  800b06:	ff 4d 10             	decl   0x10(%ebp)
  800b09:	ff 45 08             	incl   0x8(%ebp)
  800b0c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b0f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b13:	74 17                	je     800b2c <strncmp+0x2b>
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	8a 00                	mov    (%eax),%al
  800b1a:	84 c0                	test   %al,%al
  800b1c:	74 0e                	je     800b2c <strncmp+0x2b>
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8a 10                	mov    (%eax),%dl
  800b23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b26:	8a 00                	mov    (%eax),%al
  800b28:	38 c2                	cmp    %al,%dl
  800b2a:	74 da                	je     800b06 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b2c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b30:	75 07                	jne    800b39 <strncmp+0x38>
		return 0;
  800b32:	b8 00 00 00 00       	mov    $0x0,%eax
  800b37:	eb 14                	jmp    800b4d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	8a 00                	mov    (%eax),%al
  800b3e:	0f b6 d0             	movzbl %al,%edx
  800b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b44:	8a 00                	mov    (%eax),%al
  800b46:	0f b6 c0             	movzbl %al,%eax
  800b49:	29 c2                	sub    %eax,%edx
  800b4b:	89 d0                	mov    %edx,%eax
}
  800b4d:	5d                   	pop    %ebp
  800b4e:	c3                   	ret    

00800b4f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	83 ec 04             	sub    $0x4,%esp
  800b55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b58:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b5b:	eb 12                	jmp    800b6f <strchr+0x20>
		if (*s == c)
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	8a 00                	mov    (%eax),%al
  800b62:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b65:	75 05                	jne    800b6c <strchr+0x1d>
			return (char *) s;
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	eb 11                	jmp    800b7d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b6c:	ff 45 08             	incl   0x8(%ebp)
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	8a 00                	mov    (%eax),%al
  800b74:	84 c0                	test   %al,%al
  800b76:	75 e5                	jne    800b5d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b7d:	c9                   	leave  
  800b7e:	c3                   	ret    

00800b7f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b7f:	55                   	push   %ebp
  800b80:	89 e5                	mov    %esp,%ebp
  800b82:	83 ec 04             	sub    $0x4,%esp
  800b85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b88:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b8b:	eb 0d                	jmp    800b9a <strfind+0x1b>
		if (*s == c)
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	8a 00                	mov    (%eax),%al
  800b92:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b95:	74 0e                	je     800ba5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b97:	ff 45 08             	incl   0x8(%ebp)
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8a 00                	mov    (%eax),%al
  800b9f:	84 c0                	test   %al,%al
  800ba1:	75 ea                	jne    800b8d <strfind+0xe>
  800ba3:	eb 01                	jmp    800ba6 <strfind+0x27>
		if (*s == c)
			break;
  800ba5:	90                   	nop
	return (char *) s;
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ba9:	c9                   	leave  
  800baa:	c3                   	ret    

00800bab <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800bb7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800bbb:	76 63                	jbe    800c20 <memset+0x75>
		uint64 data_block = c;
  800bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc0:	99                   	cltd   
  800bc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc4:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800bc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bcd:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800bd1:	c1 e0 08             	shl    $0x8,%eax
  800bd4:	09 45 f0             	or     %eax,-0x10(%ebp)
  800bd7:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800bda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be0:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800be4:	c1 e0 10             	shl    $0x10,%eax
  800be7:	09 45 f0             	or     %eax,-0x10(%ebp)
  800bea:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf3:	89 c2                	mov    %eax,%edx
  800bf5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfa:	09 45 f0             	or     %eax,-0x10(%ebp)
  800bfd:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800c00:	eb 18                	jmp    800c1a <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800c02:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800c05:	8d 41 08             	lea    0x8(%ecx),%eax
  800c08:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c11:	89 01                	mov    %eax,(%ecx)
  800c13:	89 51 04             	mov    %edx,0x4(%ecx)
  800c16:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800c1a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c1e:	77 e2                	ja     800c02 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800c20:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c24:	74 23                	je     800c49 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800c26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c29:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c2c:	eb 0e                	jmp    800c3c <memset+0x91>
			*p8++ = (uint8)c;
  800c2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c31:	8d 50 01             	lea    0x1(%eax),%edx
  800c34:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3a:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800c3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c42:	89 55 10             	mov    %edx,0x10(%ebp)
  800c45:	85 c0                	test   %eax,%eax
  800c47:	75 e5                	jne    800c2e <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c4c:	c9                   	leave  
  800c4d:	c3                   	ret    

00800c4e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c4e:	55                   	push   %ebp
  800c4f:	89 e5                	mov    %esp,%ebp
  800c51:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800c54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800c60:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c64:	76 24                	jbe    800c8a <memcpy+0x3c>
		while(n >= 8){
  800c66:	eb 1c                	jmp    800c84 <memcpy+0x36>
			*d64 = *s64;
  800c68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6b:	8b 50 04             	mov    0x4(%eax),%edx
  800c6e:	8b 00                	mov    (%eax),%eax
  800c70:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800c73:	89 01                	mov    %eax,(%ecx)
  800c75:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800c78:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800c7c:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800c80:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800c84:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c88:	77 de                	ja     800c68 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800c8a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c8e:	74 31                	je     800cc1 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800c90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c93:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800c96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c99:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800c9c:	eb 16                	jmp    800cb4 <memcpy+0x66>
			*d8++ = *s8++;
  800c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ca1:	8d 50 01             	lea    0x1(%eax),%edx
  800ca4:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800ca7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800caa:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cad:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800cb0:	8a 12                	mov    (%edx),%dl
  800cb2:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800cb4:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cba:	89 55 10             	mov    %edx,0x10(%ebp)
  800cbd:	85 c0                	test   %eax,%eax
  800cbf:	75 dd                	jne    800c9e <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc4:	c9                   	leave  
  800cc5:	c3                   	ret    

00800cc6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800cd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cdb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800cde:	73 50                	jae    800d30 <memmove+0x6a>
  800ce0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ce3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce6:	01 d0                	add    %edx,%eax
  800ce8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ceb:	76 43                	jbe    800d30 <memmove+0x6a>
		s += n;
  800ced:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800cf3:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800cf9:	eb 10                	jmp    800d0b <memmove+0x45>
			*--d = *--s;
  800cfb:	ff 4d f8             	decl   -0x8(%ebp)
  800cfe:	ff 4d fc             	decl   -0x4(%ebp)
  800d01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d04:	8a 10                	mov    (%eax),%dl
  800d06:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d09:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d11:	89 55 10             	mov    %edx,0x10(%ebp)
  800d14:	85 c0                	test   %eax,%eax
  800d16:	75 e3                	jne    800cfb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d18:	eb 23                	jmp    800d3d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d1d:	8d 50 01             	lea    0x1(%eax),%edx
  800d20:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d23:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d26:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d29:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d2c:	8a 12                	mov    (%edx),%dl
  800d2e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d30:	8b 45 10             	mov    0x10(%ebp),%eax
  800d33:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d36:	89 55 10             	mov    %edx,0x10(%ebp)
  800d39:	85 c0                	test   %eax,%eax
  800d3b:	75 dd                	jne    800d1a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d40:	c9                   	leave  
  800d41:	c3                   	ret    

00800d42 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
  800d45:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d51:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d54:	eb 2a                	jmp    800d80 <memcmp+0x3e>
		if (*s1 != *s2)
  800d56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d59:	8a 10                	mov    (%eax),%dl
  800d5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d5e:	8a 00                	mov    (%eax),%al
  800d60:	38 c2                	cmp    %al,%dl
  800d62:	74 16                	je     800d7a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d67:	8a 00                	mov    (%eax),%al
  800d69:	0f b6 d0             	movzbl %al,%edx
  800d6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	0f b6 c0             	movzbl %al,%eax
  800d74:	29 c2                	sub    %eax,%edx
  800d76:	89 d0                	mov    %edx,%eax
  800d78:	eb 18                	jmp    800d92 <memcmp+0x50>
		s1++, s2++;
  800d7a:	ff 45 fc             	incl   -0x4(%ebp)
  800d7d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d80:	8b 45 10             	mov    0x10(%ebp),%eax
  800d83:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d86:	89 55 10             	mov    %edx,0x10(%ebp)
  800d89:	85 c0                	test   %eax,%eax
  800d8b:	75 c9                	jne    800d56 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d92:	c9                   	leave  
  800d93:	c3                   	ret    

00800d94 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
  800d97:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800da0:	01 d0                	add    %edx,%eax
  800da2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800da5:	eb 15                	jmp    800dbc <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	0f b6 d0             	movzbl %al,%edx
  800daf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db2:	0f b6 c0             	movzbl %al,%eax
  800db5:	39 c2                	cmp    %eax,%edx
  800db7:	74 0d                	je     800dc6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800db9:	ff 45 08             	incl   0x8(%ebp)
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800dc2:	72 e3                	jb     800da7 <memfind+0x13>
  800dc4:	eb 01                	jmp    800dc7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800dc6:	90                   	nop
	return (void *) s;
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dca:	c9                   	leave  
  800dcb:	c3                   	ret    

00800dcc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800dd2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800dd9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800de0:	eb 03                	jmp    800de5 <strtol+0x19>
		s++;
  800de2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	8a 00                	mov    (%eax),%al
  800dea:	3c 20                	cmp    $0x20,%al
  800dec:	74 f4                	je     800de2 <strtol+0x16>
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	8a 00                	mov    (%eax),%al
  800df3:	3c 09                	cmp    $0x9,%al
  800df5:	74 eb                	je     800de2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	8a 00                	mov    (%eax),%al
  800dfc:	3c 2b                	cmp    $0x2b,%al
  800dfe:	75 05                	jne    800e05 <strtol+0x39>
		s++;
  800e00:	ff 45 08             	incl   0x8(%ebp)
  800e03:	eb 13                	jmp    800e18 <strtol+0x4c>
	else if (*s == '-')
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8a 00                	mov    (%eax),%al
  800e0a:	3c 2d                	cmp    $0x2d,%al
  800e0c:	75 0a                	jne    800e18 <strtol+0x4c>
		s++, neg = 1;
  800e0e:	ff 45 08             	incl   0x8(%ebp)
  800e11:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1c:	74 06                	je     800e24 <strtol+0x58>
  800e1e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e22:	75 20                	jne    800e44 <strtol+0x78>
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	8a 00                	mov    (%eax),%al
  800e29:	3c 30                	cmp    $0x30,%al
  800e2b:	75 17                	jne    800e44 <strtol+0x78>
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	40                   	inc    %eax
  800e31:	8a 00                	mov    (%eax),%al
  800e33:	3c 78                	cmp    $0x78,%al
  800e35:	75 0d                	jne    800e44 <strtol+0x78>
		s += 2, base = 16;
  800e37:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e3b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e42:	eb 28                	jmp    800e6c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e44:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e48:	75 15                	jne    800e5f <strtol+0x93>
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	3c 30                	cmp    $0x30,%al
  800e51:	75 0c                	jne    800e5f <strtol+0x93>
		s++, base = 8;
  800e53:	ff 45 08             	incl   0x8(%ebp)
  800e56:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e5d:	eb 0d                	jmp    800e6c <strtol+0xa0>
	else if (base == 0)
  800e5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e63:	75 07                	jne    800e6c <strtol+0xa0>
		base = 10;
  800e65:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	8a 00                	mov    (%eax),%al
  800e71:	3c 2f                	cmp    $0x2f,%al
  800e73:	7e 19                	jle    800e8e <strtol+0xc2>
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	3c 39                	cmp    $0x39,%al
  800e7c:	7f 10                	jg     800e8e <strtol+0xc2>
			dig = *s - '0';
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	8a 00                	mov    (%eax),%al
  800e83:	0f be c0             	movsbl %al,%eax
  800e86:	83 e8 30             	sub    $0x30,%eax
  800e89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e8c:	eb 42                	jmp    800ed0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	8a 00                	mov    (%eax),%al
  800e93:	3c 60                	cmp    $0x60,%al
  800e95:	7e 19                	jle    800eb0 <strtol+0xe4>
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	8a 00                	mov    (%eax),%al
  800e9c:	3c 7a                	cmp    $0x7a,%al
  800e9e:	7f 10                	jg     800eb0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	8a 00                	mov    (%eax),%al
  800ea5:	0f be c0             	movsbl %al,%eax
  800ea8:	83 e8 57             	sub    $0x57,%eax
  800eab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800eae:	eb 20                	jmp    800ed0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	3c 40                	cmp    $0x40,%al
  800eb7:	7e 39                	jle    800ef2 <strtol+0x126>
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	8a 00                	mov    (%eax),%al
  800ebe:	3c 5a                	cmp    $0x5a,%al
  800ec0:	7f 30                	jg     800ef2 <strtol+0x126>
			dig = *s - 'A' + 10;
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	8a 00                	mov    (%eax),%al
  800ec7:	0f be c0             	movsbl %al,%eax
  800eca:	83 e8 37             	sub    $0x37,%eax
  800ecd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ed3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ed6:	7d 19                	jge    800ef1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ed8:	ff 45 08             	incl   0x8(%ebp)
  800edb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ede:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ee2:	89 c2                	mov    %eax,%edx
  800ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee7:	01 d0                	add    %edx,%eax
  800ee9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800eec:	e9 7b ff ff ff       	jmp    800e6c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800ef1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800ef2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ef6:	74 08                	je     800f00 <strtol+0x134>
		*endptr = (char *) s;
  800ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efb:	8b 55 08             	mov    0x8(%ebp),%edx
  800efe:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f00:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f04:	74 07                	je     800f0d <strtol+0x141>
  800f06:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f09:	f7 d8                	neg    %eax
  800f0b:	eb 03                	jmp    800f10 <strtol+0x144>
  800f0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f10:	c9                   	leave  
  800f11:	c3                   	ret    

00800f12 <ltostr>:

void
ltostr(long value, char *str)
{
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f1f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f26:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f2a:	79 13                	jns    800f3f <ltostr+0x2d>
	{
		neg = 1;
  800f2c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f36:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f39:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f3c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f47:	99                   	cltd   
  800f48:	f7 f9                	idiv   %ecx
  800f4a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f50:	8d 50 01             	lea    0x1(%eax),%edx
  800f53:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f56:	89 c2                	mov    %eax,%edx
  800f58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5b:	01 d0                	add    %edx,%eax
  800f5d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f60:	83 c2 30             	add    $0x30,%edx
  800f63:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f65:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f68:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f6d:	f7 e9                	imul   %ecx
  800f6f:	c1 fa 02             	sar    $0x2,%edx
  800f72:	89 c8                	mov    %ecx,%eax
  800f74:	c1 f8 1f             	sar    $0x1f,%eax
  800f77:	29 c2                	sub    %eax,%edx
  800f79:	89 d0                	mov    %edx,%eax
  800f7b:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800f7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f82:	75 bb                	jne    800f3f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f8e:	48                   	dec    %eax
  800f8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f92:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f96:	74 3d                	je     800fd5 <ltostr+0xc3>
		start = 1 ;
  800f98:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f9f:	eb 34                	jmp    800fd5 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800fa1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa7:	01 d0                	add    %edx,%eax
  800fa9:	8a 00                	mov    (%eax),%al
  800fab:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800fae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb4:	01 c2                	add    %eax,%edx
  800fb6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbc:	01 c8                	add    %ecx,%eax
  800fbe:	8a 00                	mov    (%eax),%al
  800fc0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800fc2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc8:	01 c2                	add    %eax,%edx
  800fca:	8a 45 eb             	mov    -0x15(%ebp),%al
  800fcd:	88 02                	mov    %al,(%edx)
		start++ ;
  800fcf:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800fd2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fdb:	7c c4                	jl     800fa1 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800fdd:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe3:	01 d0                	add    %edx,%eax
  800fe5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800fe8:	90                   	nop
  800fe9:	c9                   	leave  
  800fea:	c3                   	ret    

00800feb <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ff1:	ff 75 08             	pushl  0x8(%ebp)
  800ff4:	e8 c4 f9 ff ff       	call   8009bd <strlen>
  800ff9:	83 c4 04             	add    $0x4,%esp
  800ffc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800fff:	ff 75 0c             	pushl  0xc(%ebp)
  801002:	e8 b6 f9 ff ff       	call   8009bd <strlen>
  801007:	83 c4 04             	add    $0x4,%esp
  80100a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80100d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801014:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80101b:	eb 17                	jmp    801034 <strcconcat+0x49>
		final[s] = str1[s] ;
  80101d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801020:	8b 45 10             	mov    0x10(%ebp),%eax
  801023:	01 c2                	add    %eax,%edx
  801025:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	01 c8                	add    %ecx,%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801031:	ff 45 fc             	incl   -0x4(%ebp)
  801034:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801037:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80103a:	7c e1                	jl     80101d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80103c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801043:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80104a:	eb 1f                	jmp    80106b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80104c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104f:	8d 50 01             	lea    0x1(%eax),%edx
  801052:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801055:	89 c2                	mov    %eax,%edx
  801057:	8b 45 10             	mov    0x10(%ebp),%eax
  80105a:	01 c2                	add    %eax,%edx
  80105c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80105f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801062:	01 c8                	add    %ecx,%eax
  801064:	8a 00                	mov    (%eax),%al
  801066:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801068:	ff 45 f8             	incl   -0x8(%ebp)
  80106b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801071:	7c d9                	jl     80104c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801073:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801076:	8b 45 10             	mov    0x10(%ebp),%eax
  801079:	01 d0                	add    %edx,%eax
  80107b:	c6 00 00             	movb   $0x0,(%eax)
}
  80107e:	90                   	nop
  80107f:	c9                   	leave  
  801080:	c3                   	ret    

00801081 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801084:	8b 45 14             	mov    0x14(%ebp),%eax
  801087:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80108d:	8b 45 14             	mov    0x14(%ebp),%eax
  801090:	8b 00                	mov    (%eax),%eax
  801092:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801099:	8b 45 10             	mov    0x10(%ebp),%eax
  80109c:	01 d0                	add    %edx,%eax
  80109e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010a4:	eb 0c                	jmp    8010b2 <strsplit+0x31>
			*string++ = 0;
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	8d 50 01             	lea    0x1(%eax),%edx
  8010ac:	89 55 08             	mov    %edx,0x8(%ebp)
  8010af:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	8a 00                	mov    (%eax),%al
  8010b7:	84 c0                	test   %al,%al
  8010b9:	74 18                	je     8010d3 <strsplit+0x52>
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8a 00                	mov    (%eax),%al
  8010c0:	0f be c0             	movsbl %al,%eax
  8010c3:	50                   	push   %eax
  8010c4:	ff 75 0c             	pushl  0xc(%ebp)
  8010c7:	e8 83 fa ff ff       	call   800b4f <strchr>
  8010cc:	83 c4 08             	add    $0x8,%esp
  8010cf:	85 c0                	test   %eax,%eax
  8010d1:	75 d3                	jne    8010a6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	84 c0                	test   %al,%al
  8010da:	74 5a                	je     801136 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8010dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8010df:	8b 00                	mov    (%eax),%eax
  8010e1:	83 f8 0f             	cmp    $0xf,%eax
  8010e4:	75 07                	jne    8010ed <strsplit+0x6c>
		{
			return 0;
  8010e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010eb:	eb 66                	jmp    801153 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8010ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f0:	8b 00                	mov    (%eax),%eax
  8010f2:	8d 48 01             	lea    0x1(%eax),%ecx
  8010f5:	8b 55 14             	mov    0x14(%ebp),%edx
  8010f8:	89 0a                	mov    %ecx,(%edx)
  8010fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801101:	8b 45 10             	mov    0x10(%ebp),%eax
  801104:	01 c2                	add    %eax,%edx
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80110b:	eb 03                	jmp    801110 <strsplit+0x8f>
			string++;
  80110d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	8a 00                	mov    (%eax),%al
  801115:	84 c0                	test   %al,%al
  801117:	74 8b                	je     8010a4 <strsplit+0x23>
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
  80111c:	8a 00                	mov    (%eax),%al
  80111e:	0f be c0             	movsbl %al,%eax
  801121:	50                   	push   %eax
  801122:	ff 75 0c             	pushl  0xc(%ebp)
  801125:	e8 25 fa ff ff       	call   800b4f <strchr>
  80112a:	83 c4 08             	add    $0x8,%esp
  80112d:	85 c0                	test   %eax,%eax
  80112f:	74 dc                	je     80110d <strsplit+0x8c>
			string++;
	}
  801131:	e9 6e ff ff ff       	jmp    8010a4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801136:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801137:	8b 45 14             	mov    0x14(%ebp),%eax
  80113a:	8b 00                	mov    (%eax),%eax
  80113c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801143:	8b 45 10             	mov    0x10(%ebp),%eax
  801146:	01 d0                	add    %edx,%eax
  801148:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80114e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801153:	c9                   	leave  
  801154:	c3                   	ret    

00801155 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801155:	55                   	push   %ebp
  801156:	89 e5                	mov    %esp,%ebp
  801158:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801161:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801168:	eb 4a                	jmp    8011b4 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80116a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	01 c2                	add    %eax,%edx
  801172:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801175:	8b 45 0c             	mov    0xc(%ebp),%eax
  801178:	01 c8                	add    %ecx,%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80117e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801181:	8b 45 0c             	mov    0xc(%ebp),%eax
  801184:	01 d0                	add    %edx,%eax
  801186:	8a 00                	mov    (%eax),%al
  801188:	3c 40                	cmp    $0x40,%al
  80118a:	7e 25                	jle    8011b1 <str2lower+0x5c>
  80118c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80118f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801192:	01 d0                	add    %edx,%eax
  801194:	8a 00                	mov    (%eax),%al
  801196:	3c 5a                	cmp    $0x5a,%al
  801198:	7f 17                	jg     8011b1 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80119a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	01 d0                	add    %edx,%eax
  8011a2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a8:	01 ca                	add    %ecx,%edx
  8011aa:	8a 12                	mov    (%edx),%dl
  8011ac:	83 c2 20             	add    $0x20,%edx
  8011af:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8011b1:	ff 45 fc             	incl   -0x4(%ebp)
  8011b4:	ff 75 0c             	pushl  0xc(%ebp)
  8011b7:	e8 01 f8 ff ff       	call   8009bd <strlen>
  8011bc:	83 c4 04             	add    $0x4,%esp
  8011bf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011c2:	7f a6                	jg     80116a <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8011c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011c7:	c9                   	leave  
  8011c8:	c3                   	ret    

008011c9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011c9:	55                   	push   %ebp
  8011ca:	89 e5                	mov    %esp,%ebp
  8011cc:	57                   	push   %edi
  8011cd:	56                   	push   %esi
  8011ce:	53                   	push   %ebx
  8011cf:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011db:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011de:	8b 7d 18             	mov    0x18(%ebp),%edi
  8011e1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8011e4:	cd 30                	int    $0x30
  8011e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8011e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011ec:	83 c4 10             	add    $0x10,%esp
  8011ef:	5b                   	pop    %ebx
  8011f0:	5e                   	pop    %esi
  8011f1:	5f                   	pop    %edi
  8011f2:	5d                   	pop    %ebp
  8011f3:	c3                   	ret    

008011f4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8011f4:	55                   	push   %ebp
  8011f5:	89 e5                	mov    %esp,%ebp
  8011f7:	83 ec 04             	sub    $0x4,%esp
  8011fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801200:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801203:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801207:	8b 45 08             	mov    0x8(%ebp),%eax
  80120a:	6a 00                	push   $0x0
  80120c:	51                   	push   %ecx
  80120d:	52                   	push   %edx
  80120e:	ff 75 0c             	pushl  0xc(%ebp)
  801211:	50                   	push   %eax
  801212:	6a 00                	push   $0x0
  801214:	e8 b0 ff ff ff       	call   8011c9 <syscall>
  801219:	83 c4 18             	add    $0x18,%esp
}
  80121c:	90                   	nop
  80121d:	c9                   	leave  
  80121e:	c3                   	ret    

0080121f <sys_cgetc>:

int
sys_cgetc(void)
{
  80121f:	55                   	push   %ebp
  801220:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801222:	6a 00                	push   $0x0
  801224:	6a 00                	push   $0x0
  801226:	6a 00                	push   $0x0
  801228:	6a 00                	push   $0x0
  80122a:	6a 00                	push   $0x0
  80122c:	6a 02                	push   $0x2
  80122e:	e8 96 ff ff ff       	call   8011c9 <syscall>
  801233:	83 c4 18             	add    $0x18,%esp
}
  801236:	c9                   	leave  
  801237:	c3                   	ret    

00801238 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80123b:	6a 00                	push   $0x0
  80123d:	6a 00                	push   $0x0
  80123f:	6a 00                	push   $0x0
  801241:	6a 00                	push   $0x0
  801243:	6a 00                	push   $0x0
  801245:	6a 03                	push   $0x3
  801247:	e8 7d ff ff ff       	call   8011c9 <syscall>
  80124c:	83 c4 18             	add    $0x18,%esp
}
  80124f:	90                   	nop
  801250:	c9                   	leave  
  801251:	c3                   	ret    

00801252 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801252:	55                   	push   %ebp
  801253:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801255:	6a 00                	push   $0x0
  801257:	6a 00                	push   $0x0
  801259:	6a 00                	push   $0x0
  80125b:	6a 00                	push   $0x0
  80125d:	6a 00                	push   $0x0
  80125f:	6a 04                	push   $0x4
  801261:	e8 63 ff ff ff       	call   8011c9 <syscall>
  801266:	83 c4 18             	add    $0x18,%esp
}
  801269:	90                   	nop
  80126a:	c9                   	leave  
  80126b:	c3                   	ret    

0080126c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80126c:	55                   	push   %ebp
  80126d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80126f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	6a 00                	push   $0x0
  801277:	6a 00                	push   $0x0
  801279:	6a 00                	push   $0x0
  80127b:	52                   	push   %edx
  80127c:	50                   	push   %eax
  80127d:	6a 08                	push   $0x8
  80127f:	e8 45 ff ff ff       	call   8011c9 <syscall>
  801284:	83 c4 18             	add    $0x18,%esp
}
  801287:	c9                   	leave  
  801288:	c3                   	ret    

00801289 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801289:	55                   	push   %ebp
  80128a:	89 e5                	mov    %esp,%ebp
  80128c:	56                   	push   %esi
  80128d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80128e:	8b 75 18             	mov    0x18(%ebp),%esi
  801291:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801294:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801297:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129a:	8b 45 08             	mov    0x8(%ebp),%eax
  80129d:	56                   	push   %esi
  80129e:	53                   	push   %ebx
  80129f:	51                   	push   %ecx
  8012a0:	52                   	push   %edx
  8012a1:	50                   	push   %eax
  8012a2:	6a 09                	push   $0x9
  8012a4:	e8 20 ff ff ff       	call   8011c9 <syscall>
  8012a9:	83 c4 18             	add    $0x18,%esp
}
  8012ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012af:	5b                   	pop    %ebx
  8012b0:	5e                   	pop    %esi
  8012b1:	5d                   	pop    %ebp
  8012b2:	c3                   	ret    

008012b3 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8012b6:	6a 00                	push   $0x0
  8012b8:	6a 00                	push   $0x0
  8012ba:	6a 00                	push   $0x0
  8012bc:	6a 00                	push   $0x0
  8012be:	ff 75 08             	pushl  0x8(%ebp)
  8012c1:	6a 0a                	push   $0xa
  8012c3:	e8 01 ff ff ff       	call   8011c9 <syscall>
  8012c8:	83 c4 18             	add    $0x18,%esp
}
  8012cb:	c9                   	leave  
  8012cc:	c3                   	ret    

008012cd <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8012d0:	6a 00                	push   $0x0
  8012d2:	6a 00                	push   $0x0
  8012d4:	6a 00                	push   $0x0
  8012d6:	ff 75 0c             	pushl  0xc(%ebp)
  8012d9:	ff 75 08             	pushl  0x8(%ebp)
  8012dc:	6a 0b                	push   $0xb
  8012de:	e8 e6 fe ff ff       	call   8011c9 <syscall>
  8012e3:	83 c4 18             	add    $0x18,%esp
}
  8012e6:	c9                   	leave  
  8012e7:	c3                   	ret    

008012e8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8012eb:	6a 00                	push   $0x0
  8012ed:	6a 00                	push   $0x0
  8012ef:	6a 00                	push   $0x0
  8012f1:	6a 00                	push   $0x0
  8012f3:	6a 00                	push   $0x0
  8012f5:	6a 0c                	push   $0xc
  8012f7:	e8 cd fe ff ff       	call   8011c9 <syscall>
  8012fc:	83 c4 18             	add    $0x18,%esp
}
  8012ff:	c9                   	leave  
  801300:	c3                   	ret    

00801301 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801304:	6a 00                	push   $0x0
  801306:	6a 00                	push   $0x0
  801308:	6a 00                	push   $0x0
  80130a:	6a 00                	push   $0x0
  80130c:	6a 00                	push   $0x0
  80130e:	6a 0d                	push   $0xd
  801310:	e8 b4 fe ff ff       	call   8011c9 <syscall>
  801315:	83 c4 18             	add    $0x18,%esp
}
  801318:	c9                   	leave  
  801319:	c3                   	ret    

0080131a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80131d:	6a 00                	push   $0x0
  80131f:	6a 00                	push   $0x0
  801321:	6a 00                	push   $0x0
  801323:	6a 00                	push   $0x0
  801325:	6a 00                	push   $0x0
  801327:	6a 0e                	push   $0xe
  801329:	e8 9b fe ff ff       	call   8011c9 <syscall>
  80132e:	83 c4 18             	add    $0x18,%esp
}
  801331:	c9                   	leave  
  801332:	c3                   	ret    

00801333 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801336:	6a 00                	push   $0x0
  801338:	6a 00                	push   $0x0
  80133a:	6a 00                	push   $0x0
  80133c:	6a 00                	push   $0x0
  80133e:	6a 00                	push   $0x0
  801340:	6a 0f                	push   $0xf
  801342:	e8 82 fe ff ff       	call   8011c9 <syscall>
  801347:	83 c4 18             	add    $0x18,%esp
}
  80134a:	c9                   	leave  
  80134b:	c3                   	ret    

0080134c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80134f:	6a 00                	push   $0x0
  801351:	6a 00                	push   $0x0
  801353:	6a 00                	push   $0x0
  801355:	6a 00                	push   $0x0
  801357:	ff 75 08             	pushl  0x8(%ebp)
  80135a:	6a 10                	push   $0x10
  80135c:	e8 68 fe ff ff       	call   8011c9 <syscall>
  801361:	83 c4 18             	add    $0x18,%esp
}
  801364:	c9                   	leave  
  801365:	c3                   	ret    

00801366 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801369:	6a 00                	push   $0x0
  80136b:	6a 00                	push   $0x0
  80136d:	6a 00                	push   $0x0
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	6a 11                	push   $0x11
  801375:	e8 4f fe ff ff       	call   8011c9 <syscall>
  80137a:	83 c4 18             	add    $0x18,%esp
}
  80137d:	90                   	nop
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <sys_cputc>:

void
sys_cputc(const char c)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	83 ec 04             	sub    $0x4,%esp
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80138c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801390:	6a 00                	push   $0x0
  801392:	6a 00                	push   $0x0
  801394:	6a 00                	push   $0x0
  801396:	6a 00                	push   $0x0
  801398:	50                   	push   %eax
  801399:	6a 01                	push   $0x1
  80139b:	e8 29 fe ff ff       	call   8011c9 <syscall>
  8013a0:	83 c4 18             	add    $0x18,%esp
}
  8013a3:	90                   	nop
  8013a4:	c9                   	leave  
  8013a5:	c3                   	ret    

008013a6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013a9:	6a 00                	push   $0x0
  8013ab:	6a 00                	push   $0x0
  8013ad:	6a 00                	push   $0x0
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 14                	push   $0x14
  8013b5:	e8 0f fe ff ff       	call   8011c9 <syscall>
  8013ba:	83 c4 18             	add    $0x18,%esp
}
  8013bd:	90                   	nop
  8013be:	c9                   	leave  
  8013bf:	c3                   	ret    

008013c0 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013c0:	55                   	push   %ebp
  8013c1:	89 e5                	mov    %esp,%ebp
  8013c3:	83 ec 04             	sub    $0x4,%esp
  8013c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8013cc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013cf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	6a 00                	push   $0x0
  8013d8:	51                   	push   %ecx
  8013d9:	52                   	push   %edx
  8013da:	ff 75 0c             	pushl  0xc(%ebp)
  8013dd:	50                   	push   %eax
  8013de:	6a 15                	push   $0x15
  8013e0:	e8 e4 fd ff ff       	call   8011c9 <syscall>
  8013e5:	83 c4 18             	add    $0x18,%esp
}
  8013e8:	c9                   	leave  
  8013e9:	c3                   	ret    

008013ea <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8013ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	52                   	push   %edx
  8013fa:	50                   	push   %eax
  8013fb:	6a 16                	push   $0x16
  8013fd:	e8 c7 fd ff ff       	call   8011c9 <syscall>
  801402:	83 c4 18             	add    $0x18,%esp
}
  801405:	c9                   	leave  
  801406:	c3                   	ret    

00801407 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801407:	55                   	push   %ebp
  801408:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80140a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80140d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801410:	8b 45 08             	mov    0x8(%ebp),%eax
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	51                   	push   %ecx
  801418:	52                   	push   %edx
  801419:	50                   	push   %eax
  80141a:	6a 17                	push   $0x17
  80141c:	e8 a8 fd ff ff       	call   8011c9 <syscall>
  801421:	83 c4 18             	add    $0x18,%esp
}
  801424:	c9                   	leave  
  801425:	c3                   	ret    

00801426 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801429:	8b 55 0c             	mov    0xc(%ebp),%edx
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	6a 00                	push   $0x0
  801435:	52                   	push   %edx
  801436:	50                   	push   %eax
  801437:	6a 18                	push   $0x18
  801439:	e8 8b fd ff ff       	call   8011c9 <syscall>
  80143e:	83 c4 18             	add    $0x18,%esp
}
  801441:	c9                   	leave  
  801442:	c3                   	ret    

00801443 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801446:	8b 45 08             	mov    0x8(%ebp),%eax
  801449:	6a 00                	push   $0x0
  80144b:	ff 75 14             	pushl  0x14(%ebp)
  80144e:	ff 75 10             	pushl  0x10(%ebp)
  801451:	ff 75 0c             	pushl  0xc(%ebp)
  801454:	50                   	push   %eax
  801455:	6a 19                	push   $0x19
  801457:	e8 6d fd ff ff       	call   8011c9 <syscall>
  80145c:	83 c4 18             	add    $0x18,%esp
}
  80145f:	c9                   	leave  
  801460:	c3                   	ret    

00801461 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801464:	8b 45 08             	mov    0x8(%ebp),%eax
  801467:	6a 00                	push   $0x0
  801469:	6a 00                	push   $0x0
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	50                   	push   %eax
  801470:	6a 1a                	push   $0x1a
  801472:	e8 52 fd ff ff       	call   8011c9 <syscall>
  801477:	83 c4 18             	add    $0x18,%esp
}
  80147a:	90                   	nop
  80147b:	c9                   	leave  
  80147c:	c3                   	ret    

0080147d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801480:	8b 45 08             	mov    0x8(%ebp),%eax
  801483:	6a 00                	push   $0x0
  801485:	6a 00                	push   $0x0
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	50                   	push   %eax
  80148c:	6a 1b                	push   $0x1b
  80148e:	e8 36 fd ff ff       	call   8011c9 <syscall>
  801493:	83 c4 18             	add    $0x18,%esp
}
  801496:	c9                   	leave  
  801497:	c3                   	ret    

00801498 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80149b:	6a 00                	push   $0x0
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 05                	push   $0x5
  8014a7:	e8 1d fd ff ff       	call   8011c9 <syscall>
  8014ac:	83 c4 18             	add    $0x18,%esp
}
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    

008014b1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 06                	push   $0x6
  8014c0:	e8 04 fd ff ff       	call   8011c9 <syscall>
  8014c5:	83 c4 18             	add    $0x18,%esp
}
  8014c8:	c9                   	leave  
  8014c9:	c3                   	ret    

008014ca <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8014cd:	6a 00                	push   $0x0
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 07                	push   $0x7
  8014d9:	e8 eb fc ff ff       	call   8011c9 <syscall>
  8014de:	83 c4 18             	add    $0x18,%esp
}
  8014e1:	c9                   	leave  
  8014e2:	c3                   	ret    

008014e3 <sys_exit_env>:


void sys_exit_env(void)
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 00                	push   $0x0
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 1c                	push   $0x1c
  8014f2:	e8 d2 fc ff ff       	call   8011c9 <syscall>
  8014f7:	83 c4 18             	add    $0x18,%esp
}
  8014fa:	90                   	nop
  8014fb:	c9                   	leave  
  8014fc:	c3                   	ret    

008014fd <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8014fd:	55                   	push   %ebp
  8014fe:	89 e5                	mov    %esp,%ebp
  801500:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801503:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801506:	8d 50 04             	lea    0x4(%eax),%edx
  801509:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	52                   	push   %edx
  801513:	50                   	push   %eax
  801514:	6a 1d                	push   $0x1d
  801516:	e8 ae fc ff ff       	call   8011c9 <syscall>
  80151b:	83 c4 18             	add    $0x18,%esp
	return result;
  80151e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801521:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801524:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801527:	89 01                	mov    %eax,(%ecx)
  801529:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80152c:	8b 45 08             	mov    0x8(%ebp),%eax
  80152f:	c9                   	leave  
  801530:	c2 04 00             	ret    $0x4

00801533 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801533:	55                   	push   %ebp
  801534:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801536:	6a 00                	push   $0x0
  801538:	6a 00                	push   $0x0
  80153a:	ff 75 10             	pushl  0x10(%ebp)
  80153d:	ff 75 0c             	pushl  0xc(%ebp)
  801540:	ff 75 08             	pushl  0x8(%ebp)
  801543:	6a 13                	push   $0x13
  801545:	e8 7f fc ff ff       	call   8011c9 <syscall>
  80154a:	83 c4 18             	add    $0x18,%esp
	return ;
  80154d:	90                   	nop
}
  80154e:	c9                   	leave  
  80154f:	c3                   	ret    

00801550 <sys_rcr2>:
uint32 sys_rcr2()
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 1e                	push   $0x1e
  80155f:	e8 65 fc ff ff       	call   8011c9 <syscall>
  801564:	83 c4 18             	add    $0x18,%esp
}
  801567:	c9                   	leave  
  801568:	c3                   	ret    

00801569 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
  80156c:	83 ec 04             	sub    $0x4,%esp
  80156f:	8b 45 08             	mov    0x8(%ebp),%eax
  801572:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801575:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801579:	6a 00                	push   $0x0
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	50                   	push   %eax
  801582:	6a 1f                	push   $0x1f
  801584:	e8 40 fc ff ff       	call   8011c9 <syscall>
  801589:	83 c4 18             	add    $0x18,%esp
	return ;
  80158c:	90                   	nop
}
  80158d:	c9                   	leave  
  80158e:	c3                   	ret    

0080158f <rsttst>:
void rsttst()
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 21                	push   $0x21
  80159e:	e8 26 fc ff ff       	call   8011c9 <syscall>
  8015a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8015a6:	90                   	nop
}
  8015a7:	c9                   	leave  
  8015a8:	c3                   	ret    

008015a9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
  8015ac:	83 ec 04             	sub    $0x4,%esp
  8015af:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015b5:	8b 55 18             	mov    0x18(%ebp),%edx
  8015b8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015bc:	52                   	push   %edx
  8015bd:	50                   	push   %eax
  8015be:	ff 75 10             	pushl  0x10(%ebp)
  8015c1:	ff 75 0c             	pushl  0xc(%ebp)
  8015c4:	ff 75 08             	pushl  0x8(%ebp)
  8015c7:	6a 20                	push   $0x20
  8015c9:	e8 fb fb ff ff       	call   8011c9 <syscall>
  8015ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8015d1:	90                   	nop
}
  8015d2:	c9                   	leave  
  8015d3:	c3                   	ret    

008015d4 <chktst>:
void chktst(uint32 n)
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	ff 75 08             	pushl  0x8(%ebp)
  8015e2:	6a 22                	push   $0x22
  8015e4:	e8 e0 fb ff ff       	call   8011c9 <syscall>
  8015e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8015ec:	90                   	nop
}
  8015ed:	c9                   	leave  
  8015ee:	c3                   	ret    

008015ef <inctst>:

void inctst()
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 23                	push   $0x23
  8015fe:	e8 c6 fb ff ff       	call   8011c9 <syscall>
  801603:	83 c4 18             	add    $0x18,%esp
	return ;
  801606:	90                   	nop
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <gettst>:
uint32 gettst()
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 24                	push   $0x24
  801618:	e8 ac fb ff ff       	call   8011c9 <syscall>
  80161d:	83 c4 18             	add    $0x18,%esp
}
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 25                	push   $0x25
  801631:	e8 93 fb ff ff       	call   8011c9 <syscall>
  801636:	83 c4 18             	add    $0x18,%esp
  801639:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  80163e:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
  80164b:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	ff 75 08             	pushl  0x8(%ebp)
  80165b:	6a 26                	push   $0x26
  80165d:	e8 67 fb ff ff       	call   8011c9 <syscall>
  801662:	83 c4 18             	add    $0x18,%esp
	return ;
  801665:	90                   	nop
}
  801666:	c9                   	leave  
  801667:	c3                   	ret    

00801668 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
  80166b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80166c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80166f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801672:	8b 55 0c             	mov    0xc(%ebp),%edx
  801675:	8b 45 08             	mov    0x8(%ebp),%eax
  801678:	6a 00                	push   $0x0
  80167a:	53                   	push   %ebx
  80167b:	51                   	push   %ecx
  80167c:	52                   	push   %edx
  80167d:	50                   	push   %eax
  80167e:	6a 27                	push   $0x27
  801680:	e8 44 fb ff ff       	call   8011c9 <syscall>
  801685:	83 c4 18             	add    $0x18,%esp
}
  801688:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801690:	8b 55 0c             	mov    0xc(%ebp),%edx
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	52                   	push   %edx
  80169d:	50                   	push   %eax
  80169e:	6a 28                	push   $0x28
  8016a0:	e8 24 fb ff ff       	call   8011c9 <syscall>
  8016a5:	83 c4 18             	add    $0x18,%esp
}
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    

008016aa <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8016ad:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	6a 00                	push   $0x0
  8016b8:	51                   	push   %ecx
  8016b9:	ff 75 10             	pushl  0x10(%ebp)
  8016bc:	52                   	push   %edx
  8016bd:	50                   	push   %eax
  8016be:	6a 29                	push   $0x29
  8016c0:	e8 04 fb ff ff       	call   8011c9 <syscall>
  8016c5:	83 c4 18             	add    $0x18,%esp
}
  8016c8:	c9                   	leave  
  8016c9:	c3                   	ret    

008016ca <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	ff 75 10             	pushl  0x10(%ebp)
  8016d4:	ff 75 0c             	pushl  0xc(%ebp)
  8016d7:	ff 75 08             	pushl  0x8(%ebp)
  8016da:	6a 12                	push   $0x12
  8016dc:	e8 e8 fa ff ff       	call   8011c9 <syscall>
  8016e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e4:	90                   	nop
}
  8016e5:	c9                   	leave  
  8016e6:	c3                   	ret    

008016e7 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8016ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	52                   	push   %edx
  8016f7:	50                   	push   %eax
  8016f8:	6a 2a                	push   $0x2a
  8016fa:	e8 ca fa ff ff       	call   8011c9 <syscall>
  8016ff:	83 c4 18             	add    $0x18,%esp
	return;
  801702:	90                   	nop
}
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 2b                	push   $0x2b
  801714:	e8 b0 fa ff ff       	call   8011c9 <syscall>
  801719:	83 c4 18             	add    $0x18,%esp
}
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	ff 75 0c             	pushl  0xc(%ebp)
  80172a:	ff 75 08             	pushl  0x8(%ebp)
  80172d:	6a 2d                	push   $0x2d
  80172f:	e8 95 fa ff ff       	call   8011c9 <syscall>
  801734:	83 c4 18             	add    $0x18,%esp
	return;
  801737:	90                   	nop
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	ff 75 0c             	pushl  0xc(%ebp)
  801746:	ff 75 08             	pushl  0x8(%ebp)
  801749:	6a 2c                	push   $0x2c
  80174b:	e8 79 fa ff ff       	call   8011c9 <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
	return ;
  801753:	90                   	nop
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  80175c:	83 ec 04             	sub    $0x4,%esp
  80175f:	68 08 21 80 00       	push   $0x802108
  801764:	68 25 01 00 00       	push   $0x125
  801769:	68 3b 21 80 00       	push   $0x80213b
  80176e:	e8 00 00 00 00       	call   801773 <_panic>

00801773 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801779:	8d 45 10             	lea    0x10(%ebp),%eax
  80177c:	83 c0 04             	add    $0x4,%eax
  80177f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801782:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801787:	85 c0                	test   %eax,%eax
  801789:	74 16                	je     8017a1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80178b:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801790:	83 ec 08             	sub    $0x8,%esp
  801793:	50                   	push   %eax
  801794:	68 4c 21 80 00       	push   $0x80214c
  801799:	e8 46 eb ff ff       	call   8002e4 <cprintf>
  80179e:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8017a1:	a1 04 30 80 00       	mov    0x803004,%eax
  8017a6:	83 ec 0c             	sub    $0xc,%esp
  8017a9:	ff 75 0c             	pushl  0xc(%ebp)
  8017ac:	ff 75 08             	pushl  0x8(%ebp)
  8017af:	50                   	push   %eax
  8017b0:	68 54 21 80 00       	push   $0x802154
  8017b5:	6a 74                	push   $0x74
  8017b7:	e8 55 eb ff ff       	call   800311 <cprintf_colored>
  8017bc:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8017bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c2:	83 ec 08             	sub    $0x8,%esp
  8017c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8017c8:	50                   	push   %eax
  8017c9:	e8 a7 ea ff ff       	call   800275 <vcprintf>
  8017ce:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8017d1:	83 ec 08             	sub    $0x8,%esp
  8017d4:	6a 00                	push   $0x0
  8017d6:	68 7c 21 80 00       	push   $0x80217c
  8017db:	e8 95 ea ff ff       	call   800275 <vcprintf>
  8017e0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8017e3:	e8 0e ea ff ff       	call   8001f6 <exit>

	// should not return here
	while (1) ;
  8017e8:	eb fe                	jmp    8017e8 <_panic+0x75>

008017ea <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8017f0:	a1 20 30 80 00       	mov    0x803020,%eax
  8017f5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8017fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fe:	39 c2                	cmp    %eax,%edx
  801800:	74 14                	je     801816 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801802:	83 ec 04             	sub    $0x4,%esp
  801805:	68 80 21 80 00       	push   $0x802180
  80180a:	6a 26                	push   $0x26
  80180c:	68 cc 21 80 00       	push   $0x8021cc
  801811:	e8 5d ff ff ff       	call   801773 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801816:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80181d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801824:	e9 c5 00 00 00       	jmp    8018ee <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801829:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801833:	8b 45 08             	mov    0x8(%ebp),%eax
  801836:	01 d0                	add    %edx,%eax
  801838:	8b 00                	mov    (%eax),%eax
  80183a:	85 c0                	test   %eax,%eax
  80183c:	75 08                	jne    801846 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80183e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801841:	e9 a5 00 00 00       	jmp    8018eb <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801846:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80184d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801854:	eb 69                	jmp    8018bf <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801856:	a1 20 30 80 00       	mov    0x803020,%eax
  80185b:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801861:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801864:	89 d0                	mov    %edx,%eax
  801866:	01 c0                	add    %eax,%eax
  801868:	01 d0                	add    %edx,%eax
  80186a:	c1 e0 03             	shl    $0x3,%eax
  80186d:	01 c8                	add    %ecx,%eax
  80186f:	8a 40 04             	mov    0x4(%eax),%al
  801872:	84 c0                	test   %al,%al
  801874:	75 46                	jne    8018bc <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801876:	a1 20 30 80 00       	mov    0x803020,%eax
  80187b:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801881:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801884:	89 d0                	mov    %edx,%eax
  801886:	01 c0                	add    %eax,%eax
  801888:	01 d0                	add    %edx,%eax
  80188a:	c1 e0 03             	shl    $0x3,%eax
  80188d:	01 c8                	add    %ecx,%eax
  80188f:	8b 00                	mov    (%eax),%eax
  801891:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801894:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801897:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80189c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80189e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8018a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ab:	01 c8                	add    %ecx,%eax
  8018ad:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018af:	39 c2                	cmp    %eax,%edx
  8018b1:	75 09                	jne    8018bc <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8018b3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8018ba:	eb 15                	jmp    8018d1 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018bc:	ff 45 e8             	incl   -0x18(%ebp)
  8018bf:	a1 20 30 80 00       	mov    0x803020,%eax
  8018c4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8018ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018cd:	39 c2                	cmp    %eax,%edx
  8018cf:	77 85                	ja     801856 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8018d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018d5:	75 14                	jne    8018eb <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8018d7:	83 ec 04             	sub    $0x4,%esp
  8018da:	68 d8 21 80 00       	push   $0x8021d8
  8018df:	6a 3a                	push   $0x3a
  8018e1:	68 cc 21 80 00       	push   $0x8021cc
  8018e6:	e8 88 fe ff ff       	call   801773 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8018eb:	ff 45 f0             	incl   -0x10(%ebp)
  8018ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8018f4:	0f 8c 2f ff ff ff    	jl     801829 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8018fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801901:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801908:	eb 26                	jmp    801930 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80190a:	a1 20 30 80 00       	mov    0x803020,%eax
  80190f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801915:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801918:	89 d0                	mov    %edx,%eax
  80191a:	01 c0                	add    %eax,%eax
  80191c:	01 d0                	add    %edx,%eax
  80191e:	c1 e0 03             	shl    $0x3,%eax
  801921:	01 c8                	add    %ecx,%eax
  801923:	8a 40 04             	mov    0x4(%eax),%al
  801926:	3c 01                	cmp    $0x1,%al
  801928:	75 03                	jne    80192d <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80192a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80192d:	ff 45 e0             	incl   -0x20(%ebp)
  801930:	a1 20 30 80 00       	mov    0x803020,%eax
  801935:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80193b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80193e:	39 c2                	cmp    %eax,%edx
  801940:	77 c8                	ja     80190a <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801945:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801948:	74 14                	je     80195e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80194a:	83 ec 04             	sub    $0x4,%esp
  80194d:	68 2c 22 80 00       	push   $0x80222c
  801952:	6a 44                	push   $0x44
  801954:	68 cc 21 80 00       	push   $0x8021cc
  801959:	e8 15 fe ff ff       	call   801773 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80195e:	90                   	nop
  80195f:	c9                   	leave  
  801960:	c3                   	ret    
  801961:	66 90                	xchg   %ax,%ax
  801963:	90                   	nop

00801964 <__udivdi3>:
  801964:	55                   	push   %ebp
  801965:	57                   	push   %edi
  801966:	56                   	push   %esi
  801967:	53                   	push   %ebx
  801968:	83 ec 1c             	sub    $0x1c,%esp
  80196b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80196f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801973:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801977:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80197b:	89 ca                	mov    %ecx,%edx
  80197d:	89 f8                	mov    %edi,%eax
  80197f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801983:	85 f6                	test   %esi,%esi
  801985:	75 2d                	jne    8019b4 <__udivdi3+0x50>
  801987:	39 cf                	cmp    %ecx,%edi
  801989:	77 65                	ja     8019f0 <__udivdi3+0x8c>
  80198b:	89 fd                	mov    %edi,%ebp
  80198d:	85 ff                	test   %edi,%edi
  80198f:	75 0b                	jne    80199c <__udivdi3+0x38>
  801991:	b8 01 00 00 00       	mov    $0x1,%eax
  801996:	31 d2                	xor    %edx,%edx
  801998:	f7 f7                	div    %edi
  80199a:	89 c5                	mov    %eax,%ebp
  80199c:	31 d2                	xor    %edx,%edx
  80199e:	89 c8                	mov    %ecx,%eax
  8019a0:	f7 f5                	div    %ebp
  8019a2:	89 c1                	mov    %eax,%ecx
  8019a4:	89 d8                	mov    %ebx,%eax
  8019a6:	f7 f5                	div    %ebp
  8019a8:	89 cf                	mov    %ecx,%edi
  8019aa:	89 fa                	mov    %edi,%edx
  8019ac:	83 c4 1c             	add    $0x1c,%esp
  8019af:	5b                   	pop    %ebx
  8019b0:	5e                   	pop    %esi
  8019b1:	5f                   	pop    %edi
  8019b2:	5d                   	pop    %ebp
  8019b3:	c3                   	ret    
  8019b4:	39 ce                	cmp    %ecx,%esi
  8019b6:	77 28                	ja     8019e0 <__udivdi3+0x7c>
  8019b8:	0f bd fe             	bsr    %esi,%edi
  8019bb:	83 f7 1f             	xor    $0x1f,%edi
  8019be:	75 40                	jne    801a00 <__udivdi3+0x9c>
  8019c0:	39 ce                	cmp    %ecx,%esi
  8019c2:	72 0a                	jb     8019ce <__udivdi3+0x6a>
  8019c4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019c8:	0f 87 9e 00 00 00    	ja     801a6c <__udivdi3+0x108>
  8019ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8019d3:	89 fa                	mov    %edi,%edx
  8019d5:	83 c4 1c             	add    $0x1c,%esp
  8019d8:	5b                   	pop    %ebx
  8019d9:	5e                   	pop    %esi
  8019da:	5f                   	pop    %edi
  8019db:	5d                   	pop    %ebp
  8019dc:	c3                   	ret    
  8019dd:	8d 76 00             	lea    0x0(%esi),%esi
  8019e0:	31 ff                	xor    %edi,%edi
  8019e2:	31 c0                	xor    %eax,%eax
  8019e4:	89 fa                	mov    %edi,%edx
  8019e6:	83 c4 1c             	add    $0x1c,%esp
  8019e9:	5b                   	pop    %ebx
  8019ea:	5e                   	pop    %esi
  8019eb:	5f                   	pop    %edi
  8019ec:	5d                   	pop    %ebp
  8019ed:	c3                   	ret    
  8019ee:	66 90                	xchg   %ax,%ax
  8019f0:	89 d8                	mov    %ebx,%eax
  8019f2:	f7 f7                	div    %edi
  8019f4:	31 ff                	xor    %edi,%edi
  8019f6:	89 fa                	mov    %edi,%edx
  8019f8:	83 c4 1c             	add    $0x1c,%esp
  8019fb:	5b                   	pop    %ebx
  8019fc:	5e                   	pop    %esi
  8019fd:	5f                   	pop    %edi
  8019fe:	5d                   	pop    %ebp
  8019ff:	c3                   	ret    
  801a00:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a05:	89 eb                	mov    %ebp,%ebx
  801a07:	29 fb                	sub    %edi,%ebx
  801a09:	89 f9                	mov    %edi,%ecx
  801a0b:	d3 e6                	shl    %cl,%esi
  801a0d:	89 c5                	mov    %eax,%ebp
  801a0f:	88 d9                	mov    %bl,%cl
  801a11:	d3 ed                	shr    %cl,%ebp
  801a13:	89 e9                	mov    %ebp,%ecx
  801a15:	09 f1                	or     %esi,%ecx
  801a17:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a1b:	89 f9                	mov    %edi,%ecx
  801a1d:	d3 e0                	shl    %cl,%eax
  801a1f:	89 c5                	mov    %eax,%ebp
  801a21:	89 d6                	mov    %edx,%esi
  801a23:	88 d9                	mov    %bl,%cl
  801a25:	d3 ee                	shr    %cl,%esi
  801a27:	89 f9                	mov    %edi,%ecx
  801a29:	d3 e2                	shl    %cl,%edx
  801a2b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a2f:	88 d9                	mov    %bl,%cl
  801a31:	d3 e8                	shr    %cl,%eax
  801a33:	09 c2                	or     %eax,%edx
  801a35:	89 d0                	mov    %edx,%eax
  801a37:	89 f2                	mov    %esi,%edx
  801a39:	f7 74 24 0c          	divl   0xc(%esp)
  801a3d:	89 d6                	mov    %edx,%esi
  801a3f:	89 c3                	mov    %eax,%ebx
  801a41:	f7 e5                	mul    %ebp
  801a43:	39 d6                	cmp    %edx,%esi
  801a45:	72 19                	jb     801a60 <__udivdi3+0xfc>
  801a47:	74 0b                	je     801a54 <__udivdi3+0xf0>
  801a49:	89 d8                	mov    %ebx,%eax
  801a4b:	31 ff                	xor    %edi,%edi
  801a4d:	e9 58 ff ff ff       	jmp    8019aa <__udivdi3+0x46>
  801a52:	66 90                	xchg   %ax,%ax
  801a54:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a58:	89 f9                	mov    %edi,%ecx
  801a5a:	d3 e2                	shl    %cl,%edx
  801a5c:	39 c2                	cmp    %eax,%edx
  801a5e:	73 e9                	jae    801a49 <__udivdi3+0xe5>
  801a60:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a63:	31 ff                	xor    %edi,%edi
  801a65:	e9 40 ff ff ff       	jmp    8019aa <__udivdi3+0x46>
  801a6a:	66 90                	xchg   %ax,%ax
  801a6c:	31 c0                	xor    %eax,%eax
  801a6e:	e9 37 ff ff ff       	jmp    8019aa <__udivdi3+0x46>
  801a73:	90                   	nop

00801a74 <__umoddi3>:
  801a74:	55                   	push   %ebp
  801a75:	57                   	push   %edi
  801a76:	56                   	push   %esi
  801a77:	53                   	push   %ebx
  801a78:	83 ec 1c             	sub    $0x1c,%esp
  801a7b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a7f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a87:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a8b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a8f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a93:	89 f3                	mov    %esi,%ebx
  801a95:	89 fa                	mov    %edi,%edx
  801a97:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a9b:	89 34 24             	mov    %esi,(%esp)
  801a9e:	85 c0                	test   %eax,%eax
  801aa0:	75 1a                	jne    801abc <__umoddi3+0x48>
  801aa2:	39 f7                	cmp    %esi,%edi
  801aa4:	0f 86 a2 00 00 00    	jbe    801b4c <__umoddi3+0xd8>
  801aaa:	89 c8                	mov    %ecx,%eax
  801aac:	89 f2                	mov    %esi,%edx
  801aae:	f7 f7                	div    %edi
  801ab0:	89 d0                	mov    %edx,%eax
  801ab2:	31 d2                	xor    %edx,%edx
  801ab4:	83 c4 1c             	add    $0x1c,%esp
  801ab7:	5b                   	pop    %ebx
  801ab8:	5e                   	pop    %esi
  801ab9:	5f                   	pop    %edi
  801aba:	5d                   	pop    %ebp
  801abb:	c3                   	ret    
  801abc:	39 f0                	cmp    %esi,%eax
  801abe:	0f 87 ac 00 00 00    	ja     801b70 <__umoddi3+0xfc>
  801ac4:	0f bd e8             	bsr    %eax,%ebp
  801ac7:	83 f5 1f             	xor    $0x1f,%ebp
  801aca:	0f 84 ac 00 00 00    	je     801b7c <__umoddi3+0x108>
  801ad0:	bf 20 00 00 00       	mov    $0x20,%edi
  801ad5:	29 ef                	sub    %ebp,%edi
  801ad7:	89 fe                	mov    %edi,%esi
  801ad9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801add:	89 e9                	mov    %ebp,%ecx
  801adf:	d3 e0                	shl    %cl,%eax
  801ae1:	89 d7                	mov    %edx,%edi
  801ae3:	89 f1                	mov    %esi,%ecx
  801ae5:	d3 ef                	shr    %cl,%edi
  801ae7:	09 c7                	or     %eax,%edi
  801ae9:	89 e9                	mov    %ebp,%ecx
  801aeb:	d3 e2                	shl    %cl,%edx
  801aed:	89 14 24             	mov    %edx,(%esp)
  801af0:	89 d8                	mov    %ebx,%eax
  801af2:	d3 e0                	shl    %cl,%eax
  801af4:	89 c2                	mov    %eax,%edx
  801af6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801afa:	d3 e0                	shl    %cl,%eax
  801afc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b00:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b04:	89 f1                	mov    %esi,%ecx
  801b06:	d3 e8                	shr    %cl,%eax
  801b08:	09 d0                	or     %edx,%eax
  801b0a:	d3 eb                	shr    %cl,%ebx
  801b0c:	89 da                	mov    %ebx,%edx
  801b0e:	f7 f7                	div    %edi
  801b10:	89 d3                	mov    %edx,%ebx
  801b12:	f7 24 24             	mull   (%esp)
  801b15:	89 c6                	mov    %eax,%esi
  801b17:	89 d1                	mov    %edx,%ecx
  801b19:	39 d3                	cmp    %edx,%ebx
  801b1b:	0f 82 87 00 00 00    	jb     801ba8 <__umoddi3+0x134>
  801b21:	0f 84 91 00 00 00    	je     801bb8 <__umoddi3+0x144>
  801b27:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b2b:	29 f2                	sub    %esi,%edx
  801b2d:	19 cb                	sbb    %ecx,%ebx
  801b2f:	89 d8                	mov    %ebx,%eax
  801b31:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b35:	d3 e0                	shl    %cl,%eax
  801b37:	89 e9                	mov    %ebp,%ecx
  801b39:	d3 ea                	shr    %cl,%edx
  801b3b:	09 d0                	or     %edx,%eax
  801b3d:	89 e9                	mov    %ebp,%ecx
  801b3f:	d3 eb                	shr    %cl,%ebx
  801b41:	89 da                	mov    %ebx,%edx
  801b43:	83 c4 1c             	add    $0x1c,%esp
  801b46:	5b                   	pop    %ebx
  801b47:	5e                   	pop    %esi
  801b48:	5f                   	pop    %edi
  801b49:	5d                   	pop    %ebp
  801b4a:	c3                   	ret    
  801b4b:	90                   	nop
  801b4c:	89 fd                	mov    %edi,%ebp
  801b4e:	85 ff                	test   %edi,%edi
  801b50:	75 0b                	jne    801b5d <__umoddi3+0xe9>
  801b52:	b8 01 00 00 00       	mov    $0x1,%eax
  801b57:	31 d2                	xor    %edx,%edx
  801b59:	f7 f7                	div    %edi
  801b5b:	89 c5                	mov    %eax,%ebp
  801b5d:	89 f0                	mov    %esi,%eax
  801b5f:	31 d2                	xor    %edx,%edx
  801b61:	f7 f5                	div    %ebp
  801b63:	89 c8                	mov    %ecx,%eax
  801b65:	f7 f5                	div    %ebp
  801b67:	89 d0                	mov    %edx,%eax
  801b69:	e9 44 ff ff ff       	jmp    801ab2 <__umoddi3+0x3e>
  801b6e:	66 90                	xchg   %ax,%ax
  801b70:	89 c8                	mov    %ecx,%eax
  801b72:	89 f2                	mov    %esi,%edx
  801b74:	83 c4 1c             	add    $0x1c,%esp
  801b77:	5b                   	pop    %ebx
  801b78:	5e                   	pop    %esi
  801b79:	5f                   	pop    %edi
  801b7a:	5d                   	pop    %ebp
  801b7b:	c3                   	ret    
  801b7c:	3b 04 24             	cmp    (%esp),%eax
  801b7f:	72 06                	jb     801b87 <__umoddi3+0x113>
  801b81:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b85:	77 0f                	ja     801b96 <__umoddi3+0x122>
  801b87:	89 f2                	mov    %esi,%edx
  801b89:	29 f9                	sub    %edi,%ecx
  801b8b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b8f:	89 14 24             	mov    %edx,(%esp)
  801b92:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b96:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b9a:	8b 14 24             	mov    (%esp),%edx
  801b9d:	83 c4 1c             	add    $0x1c,%esp
  801ba0:	5b                   	pop    %ebx
  801ba1:	5e                   	pop    %esi
  801ba2:	5f                   	pop    %edi
  801ba3:	5d                   	pop    %ebp
  801ba4:	c3                   	ret    
  801ba5:	8d 76 00             	lea    0x0(%esi),%esi
  801ba8:	2b 04 24             	sub    (%esp),%eax
  801bab:	19 fa                	sbb    %edi,%edx
  801bad:	89 d1                	mov    %edx,%ecx
  801baf:	89 c6                	mov    %eax,%esi
  801bb1:	e9 71 ff ff ff       	jmp    801b27 <__umoddi3+0xb3>
  801bb6:	66 90                	xchg   %ax,%ax
  801bb8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bbc:	72 ea                	jb     801ba8 <__umoddi3+0x134>
  801bbe:	89 d9                	mov    %ebx,%ecx
  801bc0:	e9 62 ff ff ff       	jmp    801b27 <__umoddi3+0xb3>

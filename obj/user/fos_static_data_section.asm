
obj/user/fos_static_data_section:     file format elf32-i386


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
  800031:	e8 1b 00 00 00       	call   800051 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

/// Adding array of 20000 integer on user data section
int arr[20000];

void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 08             	sub    $0x8,%esp
	atomic_cprintf("user data section contains 20,000 integer\n");
  80003e:	83 ec 0c             	sub    $0xc,%esp
  800041:	68 e0 1b 80 00       	push   $0x801be0
  800046:	e8 08 03 00 00       	call   800353 <atomic_cprintf>
  80004b:	83 c4 10             	add    $0x10,%esp
	
	return;	
  80004e:	90                   	nop
}
  80004f:	c9                   	leave  
  800050:	c3                   	ret    

00800051 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800051:	55                   	push   %ebp
  800052:	89 e5                	mov    %esp,%ebp
  800054:	57                   	push   %edi
  800055:	56                   	push   %esi
  800056:	53                   	push   %ebx
  800057:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80005a:	e8 4f 14 00 00       	call   8014ae <sys_getenvindex>
  80005f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800062:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800065:	89 d0                	mov    %edx,%eax
  800067:	c1 e0 02             	shl    $0x2,%eax
  80006a:	01 d0                	add    %edx,%eax
  80006c:	c1 e0 03             	shl    $0x3,%eax
  80006f:	01 d0                	add    %edx,%eax
  800071:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800078:	01 d0                	add    %edx,%eax
  80007a:	c1 e0 02             	shl    $0x2,%eax
  80007d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800082:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800087:	a1 20 30 80 00       	mov    0x803020,%eax
  80008c:	8a 40 20             	mov    0x20(%eax),%al
  80008f:	84 c0                	test   %al,%al
  800091:	74 0d                	je     8000a0 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800093:	a1 20 30 80 00       	mov    0x803020,%eax
  800098:	83 c0 20             	add    $0x20,%eax
  80009b:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a4:	7e 0a                	jle    8000b0 <libmain+0x5f>
		binaryname = argv[0];
  8000a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000a9:	8b 00                	mov    (%eax),%eax
  8000ab:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000b0:	83 ec 08             	sub    $0x8,%esp
  8000b3:	ff 75 0c             	pushl  0xc(%ebp)
  8000b6:	ff 75 08             	pushl  0x8(%ebp)
  8000b9:	e8 7a ff ff ff       	call   800038 <_main>
  8000be:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000c1:	a1 00 30 80 00       	mov    0x803000,%eax
  8000c6:	85 c0                	test   %eax,%eax
  8000c8:	0f 84 01 01 00 00    	je     8001cf <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8000ce:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8000d4:	bb 04 1d 80 00       	mov    $0x801d04,%ebx
  8000d9:	ba 0e 00 00 00       	mov    $0xe,%edx
  8000de:	89 c7                	mov    %eax,%edi
  8000e0:	89 de                	mov    %ebx,%esi
  8000e2:	89 d1                	mov    %edx,%ecx
  8000e4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000e6:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8000e9:	b9 56 00 00 00       	mov    $0x56,%ecx
  8000ee:	b0 00                	mov    $0x0,%al
  8000f0:	89 d7                	mov    %edx,%edi
  8000f2:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8000f4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8000fb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8000fe:	83 ec 08             	sub    $0x8,%esp
  800101:	50                   	push   %eax
  800102:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800108:	50                   	push   %eax
  800109:	e8 d6 15 00 00       	call   8016e4 <sys_utilities>
  80010e:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800111:	e8 1f 11 00 00       	call   801235 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800116:	83 ec 0c             	sub    $0xc,%esp
  800119:	68 24 1c 80 00       	push   $0x801c24
  80011e:	e8 be 01 00 00       	call   8002e1 <cprintf>
  800123:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800126:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800129:	85 c0                	test   %eax,%eax
  80012b:	74 18                	je     800145 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80012d:	e8 d0 15 00 00       	call   801702 <sys_get_optimal_num_faults>
  800132:	83 ec 08             	sub    $0x8,%esp
  800135:	50                   	push   %eax
  800136:	68 4c 1c 80 00       	push   $0x801c4c
  80013b:	e8 a1 01 00 00       	call   8002e1 <cprintf>
  800140:	83 c4 10             	add    $0x10,%esp
  800143:	eb 59                	jmp    80019e <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800145:	a1 20 30 80 00       	mov    0x803020,%eax
  80014a:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800150:	a1 20 30 80 00       	mov    0x803020,%eax
  800155:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80015b:	83 ec 04             	sub    $0x4,%esp
  80015e:	52                   	push   %edx
  80015f:	50                   	push   %eax
  800160:	68 70 1c 80 00       	push   $0x801c70
  800165:	e8 77 01 00 00       	call   8002e1 <cprintf>
  80016a:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80016d:	a1 20 30 80 00       	mov    0x803020,%eax
  800172:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800178:	a1 20 30 80 00       	mov    0x803020,%eax
  80017d:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800183:	a1 20 30 80 00       	mov    0x803020,%eax
  800188:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80018e:	51                   	push   %ecx
  80018f:	52                   	push   %edx
  800190:	50                   	push   %eax
  800191:	68 98 1c 80 00       	push   $0x801c98
  800196:	e8 46 01 00 00       	call   8002e1 <cprintf>
  80019b:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80019e:	a1 20 30 80 00       	mov    0x803020,%eax
  8001a3:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8001a9:	83 ec 08             	sub    $0x8,%esp
  8001ac:	50                   	push   %eax
  8001ad:	68 f0 1c 80 00       	push   $0x801cf0
  8001b2:	e8 2a 01 00 00       	call   8002e1 <cprintf>
  8001b7:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 24 1c 80 00       	push   $0x801c24
  8001c2:	e8 1a 01 00 00       	call   8002e1 <cprintf>
  8001c7:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001ca:	e8 80 10 00 00       	call   80124f <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001cf:	e8 1f 00 00 00       	call   8001f3 <exit>
}
  8001d4:	90                   	nop
  8001d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d8:	5b                   	pop    %ebx
  8001d9:	5e                   	pop    %esi
  8001da:	5f                   	pop    %edi
  8001db:	5d                   	pop    %ebp
  8001dc:	c3                   	ret    

008001dd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001dd:	55                   	push   %ebp
  8001de:	89 e5                	mov    %esp,%ebp
  8001e0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001e3:	83 ec 0c             	sub    $0xc,%esp
  8001e6:	6a 00                	push   $0x0
  8001e8:	e8 8d 12 00 00       	call   80147a <sys_destroy_env>
  8001ed:	83 c4 10             	add    $0x10,%esp
}
  8001f0:	90                   	nop
  8001f1:	c9                   	leave  
  8001f2:	c3                   	ret    

008001f3 <exit>:

void
exit(void)
{
  8001f3:	55                   	push   %ebp
  8001f4:	89 e5                	mov    %esp,%ebp
  8001f6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001f9:	e8 e2 12 00 00       	call   8014e0 <sys_exit_env>
}
  8001fe:	90                   	nop
  8001ff:	c9                   	leave  
  800200:	c3                   	ret    

00800201 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800201:	55                   	push   %ebp
  800202:	89 e5                	mov    %esp,%ebp
  800204:	53                   	push   %ebx
  800205:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020b:	8b 00                	mov    (%eax),%eax
  80020d:	8d 48 01             	lea    0x1(%eax),%ecx
  800210:	8b 55 0c             	mov    0xc(%ebp),%edx
  800213:	89 0a                	mov    %ecx,(%edx)
  800215:	8b 55 08             	mov    0x8(%ebp),%edx
  800218:	88 d1                	mov    %dl,%cl
  80021a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800221:	8b 45 0c             	mov    0xc(%ebp),%eax
  800224:	8b 00                	mov    (%eax),%eax
  800226:	3d ff 00 00 00       	cmp    $0xff,%eax
  80022b:	75 30                	jne    80025d <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80022d:	8b 15 b8 e9 82 00    	mov    0x82e9b8,%edx
  800233:	a0 e0 68 81 00       	mov    0x8168e0,%al
  800238:	0f b6 c0             	movzbl %al,%eax
  80023b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80023e:	8b 09                	mov    (%ecx),%ecx
  800240:	89 cb                	mov    %ecx,%ebx
  800242:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800245:	83 c1 08             	add    $0x8,%ecx
  800248:	52                   	push   %edx
  800249:	50                   	push   %eax
  80024a:	53                   	push   %ebx
  80024b:	51                   	push   %ecx
  80024c:	e8 a0 0f 00 00       	call   8011f1 <sys_cputs>
  800251:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800254:	8b 45 0c             	mov    0xc(%ebp),%eax
  800257:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80025d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800260:	8b 40 04             	mov    0x4(%eax),%eax
  800263:	8d 50 01             	lea    0x1(%eax),%edx
  800266:	8b 45 0c             	mov    0xc(%ebp),%eax
  800269:	89 50 04             	mov    %edx,0x4(%eax)
}
  80026c:	90                   	nop
  80026d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800270:	c9                   	leave  
  800271:	c3                   	ret    

00800272 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800272:	55                   	push   %ebp
  800273:	89 e5                	mov    %esp,%ebp
  800275:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80027b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800282:	00 00 00 
	b.cnt = 0;
  800285:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80028c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80028f:	ff 75 0c             	pushl  0xc(%ebp)
  800292:	ff 75 08             	pushl  0x8(%ebp)
  800295:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80029b:	50                   	push   %eax
  80029c:	68 01 02 80 00       	push   $0x800201
  8002a1:	e8 5a 02 00 00       	call   800500 <vprintfmt>
  8002a6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8002a9:	8b 15 b8 e9 82 00    	mov    0x82e9b8,%edx
  8002af:	a0 e0 68 81 00       	mov    0x8168e0,%al
  8002b4:	0f b6 c0             	movzbl %al,%eax
  8002b7:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8002bd:	52                   	push   %edx
  8002be:	50                   	push   %eax
  8002bf:	51                   	push   %ecx
  8002c0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002c6:	83 c0 08             	add    $0x8,%eax
  8002c9:	50                   	push   %eax
  8002ca:	e8 22 0f 00 00       	call   8011f1 <sys_cputs>
  8002cf:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002d2:	c6 05 e0 68 81 00 00 	movb   $0x0,0x8168e0
	return b.cnt;
  8002d9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002df:	c9                   	leave  
  8002e0:	c3                   	ret    

008002e1 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002e1:	55                   	push   %ebp
  8002e2:	89 e5                	mov    %esp,%ebp
  8002e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002e7:	c6 05 e0 68 81 00 01 	movb   $0x1,0x8168e0
	va_start(ap, fmt);
  8002ee:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f7:	83 ec 08             	sub    $0x8,%esp
  8002fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8002fd:	50                   	push   %eax
  8002fe:	e8 6f ff ff ff       	call   800272 <vcprintf>
  800303:	83 c4 10             	add    $0x10,%esp
  800306:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800309:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80030c:	c9                   	leave  
  80030d:	c3                   	ret    

0080030e <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800314:	c6 05 e0 68 81 00 01 	movb   $0x1,0x8168e0
	curTextClr = (textClr << 8) ; //set text color by the given value
  80031b:	8b 45 08             	mov    0x8(%ebp),%eax
  80031e:	c1 e0 08             	shl    $0x8,%eax
  800321:	a3 b8 e9 82 00       	mov    %eax,0x82e9b8
	va_start(ap, fmt);
  800326:	8d 45 0c             	lea    0xc(%ebp),%eax
  800329:	83 c0 04             	add    $0x4,%eax
  80032c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80032f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800332:	83 ec 08             	sub    $0x8,%esp
  800335:	ff 75 f4             	pushl  -0xc(%ebp)
  800338:	50                   	push   %eax
  800339:	e8 34 ff ff ff       	call   800272 <vcprintf>
  80033e:	83 c4 10             	add    $0x10,%esp
  800341:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800344:	c7 05 b8 e9 82 00 00 	movl   $0x700,0x82e9b8
  80034b:	07 00 00 

	return cnt;
  80034e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800351:	c9                   	leave  
  800352:	c3                   	ret    

00800353 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800353:	55                   	push   %ebp
  800354:	89 e5                	mov    %esp,%ebp
  800356:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800359:	e8 d7 0e 00 00       	call   801235 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80035e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800361:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800364:	8b 45 08             	mov    0x8(%ebp),%eax
  800367:	83 ec 08             	sub    $0x8,%esp
  80036a:	ff 75 f4             	pushl  -0xc(%ebp)
  80036d:	50                   	push   %eax
  80036e:	e8 ff fe ff ff       	call   800272 <vcprintf>
  800373:	83 c4 10             	add    $0x10,%esp
  800376:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800379:	e8 d1 0e 00 00       	call   80124f <sys_unlock_cons>
	return cnt;
  80037e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800381:	c9                   	leave  
  800382:	c3                   	ret    

00800383 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800383:	55                   	push   %ebp
  800384:	89 e5                	mov    %esp,%ebp
  800386:	53                   	push   %ebx
  800387:	83 ec 14             	sub    $0x14,%esp
  80038a:	8b 45 10             	mov    0x10(%ebp),%eax
  80038d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800390:	8b 45 14             	mov    0x14(%ebp),%eax
  800393:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800396:	8b 45 18             	mov    0x18(%ebp),%eax
  800399:	ba 00 00 00 00       	mov    $0x0,%edx
  80039e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003a1:	77 55                	ja     8003f8 <printnum+0x75>
  8003a3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003a6:	72 05                	jb     8003ad <printnum+0x2a>
  8003a8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003ab:	77 4b                	ja     8003f8 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003ad:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003b0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003b3:	8b 45 18             	mov    0x18(%ebp),%eax
  8003b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8003bb:	52                   	push   %edx
  8003bc:	50                   	push   %eax
  8003bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8003c3:	e8 98 15 00 00       	call   801960 <__udivdi3>
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	83 ec 04             	sub    $0x4,%esp
  8003ce:	ff 75 20             	pushl  0x20(%ebp)
  8003d1:	53                   	push   %ebx
  8003d2:	ff 75 18             	pushl  0x18(%ebp)
  8003d5:	52                   	push   %edx
  8003d6:	50                   	push   %eax
  8003d7:	ff 75 0c             	pushl  0xc(%ebp)
  8003da:	ff 75 08             	pushl  0x8(%ebp)
  8003dd:	e8 a1 ff ff ff       	call   800383 <printnum>
  8003e2:	83 c4 20             	add    $0x20,%esp
  8003e5:	eb 1a                	jmp    800401 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003e7:	83 ec 08             	sub    $0x8,%esp
  8003ea:	ff 75 0c             	pushl  0xc(%ebp)
  8003ed:	ff 75 20             	pushl  0x20(%ebp)
  8003f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f3:	ff d0                	call   *%eax
  8003f5:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003f8:	ff 4d 1c             	decl   0x1c(%ebp)
  8003fb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003ff:	7f e6                	jg     8003e7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800401:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800404:	bb 00 00 00 00       	mov    $0x0,%ebx
  800409:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80040c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80040f:	53                   	push   %ebx
  800410:	51                   	push   %ecx
  800411:	52                   	push   %edx
  800412:	50                   	push   %eax
  800413:	e8 58 16 00 00       	call   801a70 <__umoddi3>
  800418:	83 c4 10             	add    $0x10,%esp
  80041b:	05 94 1f 80 00       	add    $0x801f94,%eax
  800420:	8a 00                	mov    (%eax),%al
  800422:	0f be c0             	movsbl %al,%eax
  800425:	83 ec 08             	sub    $0x8,%esp
  800428:	ff 75 0c             	pushl  0xc(%ebp)
  80042b:	50                   	push   %eax
  80042c:	8b 45 08             	mov    0x8(%ebp),%eax
  80042f:	ff d0                	call   *%eax
  800431:	83 c4 10             	add    $0x10,%esp
}
  800434:	90                   	nop
  800435:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800438:	c9                   	leave  
  800439:	c3                   	ret    

0080043a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80043a:	55                   	push   %ebp
  80043b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80043d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800441:	7e 1c                	jle    80045f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800443:	8b 45 08             	mov    0x8(%ebp),%eax
  800446:	8b 00                	mov    (%eax),%eax
  800448:	8d 50 08             	lea    0x8(%eax),%edx
  80044b:	8b 45 08             	mov    0x8(%ebp),%eax
  80044e:	89 10                	mov    %edx,(%eax)
  800450:	8b 45 08             	mov    0x8(%ebp),%eax
  800453:	8b 00                	mov    (%eax),%eax
  800455:	83 e8 08             	sub    $0x8,%eax
  800458:	8b 50 04             	mov    0x4(%eax),%edx
  80045b:	8b 00                	mov    (%eax),%eax
  80045d:	eb 40                	jmp    80049f <getuint+0x65>
	else if (lflag)
  80045f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800463:	74 1e                	je     800483 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800465:	8b 45 08             	mov    0x8(%ebp),%eax
  800468:	8b 00                	mov    (%eax),%eax
  80046a:	8d 50 04             	lea    0x4(%eax),%edx
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	89 10                	mov    %edx,(%eax)
  800472:	8b 45 08             	mov    0x8(%ebp),%eax
  800475:	8b 00                	mov    (%eax),%eax
  800477:	83 e8 04             	sub    $0x4,%eax
  80047a:	8b 00                	mov    (%eax),%eax
  80047c:	ba 00 00 00 00       	mov    $0x0,%edx
  800481:	eb 1c                	jmp    80049f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800483:	8b 45 08             	mov    0x8(%ebp),%eax
  800486:	8b 00                	mov    (%eax),%eax
  800488:	8d 50 04             	lea    0x4(%eax),%edx
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	89 10                	mov    %edx,(%eax)
  800490:	8b 45 08             	mov    0x8(%ebp),%eax
  800493:	8b 00                	mov    (%eax),%eax
  800495:	83 e8 04             	sub    $0x4,%eax
  800498:	8b 00                	mov    (%eax),%eax
  80049a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80049f:	5d                   	pop    %ebp
  8004a0:	c3                   	ret    

008004a1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004a1:	55                   	push   %ebp
  8004a2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004a4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004a8:	7e 1c                	jle    8004c6 <getint+0x25>
		return va_arg(*ap, long long);
  8004aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ad:	8b 00                	mov    (%eax),%eax
  8004af:	8d 50 08             	lea    0x8(%eax),%edx
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	89 10                	mov    %edx,(%eax)
  8004b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	83 e8 08             	sub    $0x8,%eax
  8004bf:	8b 50 04             	mov    0x4(%eax),%edx
  8004c2:	8b 00                	mov    (%eax),%eax
  8004c4:	eb 38                	jmp    8004fe <getint+0x5d>
	else if (lflag)
  8004c6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004ca:	74 1a                	je     8004e6 <getint+0x45>
		return va_arg(*ap, long);
  8004cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	8d 50 04             	lea    0x4(%eax),%edx
  8004d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d7:	89 10                	mov    %edx,(%eax)
  8004d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dc:	8b 00                	mov    (%eax),%eax
  8004de:	83 e8 04             	sub    $0x4,%eax
  8004e1:	8b 00                	mov    (%eax),%eax
  8004e3:	99                   	cltd   
  8004e4:	eb 18                	jmp    8004fe <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e9:	8b 00                	mov    (%eax),%eax
  8004eb:	8d 50 04             	lea    0x4(%eax),%edx
  8004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f1:	89 10                	mov    %edx,(%eax)
  8004f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f6:	8b 00                	mov    (%eax),%eax
  8004f8:	83 e8 04             	sub    $0x4,%eax
  8004fb:	8b 00                	mov    (%eax),%eax
  8004fd:	99                   	cltd   
}
  8004fe:	5d                   	pop    %ebp
  8004ff:	c3                   	ret    

00800500 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800500:	55                   	push   %ebp
  800501:	89 e5                	mov    %esp,%ebp
  800503:	56                   	push   %esi
  800504:	53                   	push   %ebx
  800505:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800508:	eb 17                	jmp    800521 <vprintfmt+0x21>
			if (ch == '\0')
  80050a:	85 db                	test   %ebx,%ebx
  80050c:	0f 84 c1 03 00 00    	je     8008d3 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800512:	83 ec 08             	sub    $0x8,%esp
  800515:	ff 75 0c             	pushl  0xc(%ebp)
  800518:	53                   	push   %ebx
  800519:	8b 45 08             	mov    0x8(%ebp),%eax
  80051c:	ff d0                	call   *%eax
  80051e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800521:	8b 45 10             	mov    0x10(%ebp),%eax
  800524:	8d 50 01             	lea    0x1(%eax),%edx
  800527:	89 55 10             	mov    %edx,0x10(%ebp)
  80052a:	8a 00                	mov    (%eax),%al
  80052c:	0f b6 d8             	movzbl %al,%ebx
  80052f:	83 fb 25             	cmp    $0x25,%ebx
  800532:	75 d6                	jne    80050a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800534:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800538:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80053f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800546:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80054d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800554:	8b 45 10             	mov    0x10(%ebp),%eax
  800557:	8d 50 01             	lea    0x1(%eax),%edx
  80055a:	89 55 10             	mov    %edx,0x10(%ebp)
  80055d:	8a 00                	mov    (%eax),%al
  80055f:	0f b6 d8             	movzbl %al,%ebx
  800562:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800565:	83 f8 5b             	cmp    $0x5b,%eax
  800568:	0f 87 3d 03 00 00    	ja     8008ab <vprintfmt+0x3ab>
  80056e:	8b 04 85 b8 1f 80 00 	mov    0x801fb8(,%eax,4),%eax
  800575:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800577:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80057b:	eb d7                	jmp    800554 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80057d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800581:	eb d1                	jmp    800554 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800583:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80058a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80058d:	89 d0                	mov    %edx,%eax
  80058f:	c1 e0 02             	shl    $0x2,%eax
  800592:	01 d0                	add    %edx,%eax
  800594:	01 c0                	add    %eax,%eax
  800596:	01 d8                	add    %ebx,%eax
  800598:	83 e8 30             	sub    $0x30,%eax
  80059b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80059e:	8b 45 10             	mov    0x10(%ebp),%eax
  8005a1:	8a 00                	mov    (%eax),%al
  8005a3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005a6:	83 fb 2f             	cmp    $0x2f,%ebx
  8005a9:	7e 3e                	jle    8005e9 <vprintfmt+0xe9>
  8005ab:	83 fb 39             	cmp    $0x39,%ebx
  8005ae:	7f 39                	jg     8005e9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005b0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005b3:	eb d5                	jmp    80058a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b8:	83 c0 04             	add    $0x4,%eax
  8005bb:	89 45 14             	mov    %eax,0x14(%ebp)
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	83 e8 04             	sub    $0x4,%eax
  8005c4:	8b 00                	mov    (%eax),%eax
  8005c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005c9:	eb 1f                	jmp    8005ea <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005cf:	79 83                	jns    800554 <vprintfmt+0x54>
				width = 0;
  8005d1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005d8:	e9 77 ff ff ff       	jmp    800554 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005dd:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005e4:	e9 6b ff ff ff       	jmp    800554 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005e9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005ee:	0f 89 60 ff ff ff    	jns    800554 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005fa:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800601:	e9 4e ff ff ff       	jmp    800554 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800606:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800609:	e9 46 ff ff ff       	jmp    800554 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	83 c0 04             	add    $0x4,%eax
  800614:	89 45 14             	mov    %eax,0x14(%ebp)
  800617:	8b 45 14             	mov    0x14(%ebp),%eax
  80061a:	83 e8 04             	sub    $0x4,%eax
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	83 ec 08             	sub    $0x8,%esp
  800622:	ff 75 0c             	pushl  0xc(%ebp)
  800625:	50                   	push   %eax
  800626:	8b 45 08             	mov    0x8(%ebp),%eax
  800629:	ff d0                	call   *%eax
  80062b:	83 c4 10             	add    $0x10,%esp
			break;
  80062e:	e9 9b 02 00 00       	jmp    8008ce <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	83 c0 04             	add    $0x4,%eax
  800639:	89 45 14             	mov    %eax,0x14(%ebp)
  80063c:	8b 45 14             	mov    0x14(%ebp),%eax
  80063f:	83 e8 04             	sub    $0x4,%eax
  800642:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800644:	85 db                	test   %ebx,%ebx
  800646:	79 02                	jns    80064a <vprintfmt+0x14a>
				err = -err;
  800648:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80064a:	83 fb 64             	cmp    $0x64,%ebx
  80064d:	7f 0b                	jg     80065a <vprintfmt+0x15a>
  80064f:	8b 34 9d 00 1e 80 00 	mov    0x801e00(,%ebx,4),%esi
  800656:	85 f6                	test   %esi,%esi
  800658:	75 19                	jne    800673 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80065a:	53                   	push   %ebx
  80065b:	68 a5 1f 80 00       	push   $0x801fa5
  800660:	ff 75 0c             	pushl  0xc(%ebp)
  800663:	ff 75 08             	pushl  0x8(%ebp)
  800666:	e8 70 02 00 00       	call   8008db <printfmt>
  80066b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80066e:	e9 5b 02 00 00       	jmp    8008ce <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800673:	56                   	push   %esi
  800674:	68 ae 1f 80 00       	push   $0x801fae
  800679:	ff 75 0c             	pushl  0xc(%ebp)
  80067c:	ff 75 08             	pushl  0x8(%ebp)
  80067f:	e8 57 02 00 00       	call   8008db <printfmt>
  800684:	83 c4 10             	add    $0x10,%esp
			break;
  800687:	e9 42 02 00 00       	jmp    8008ce <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	83 c0 04             	add    $0x4,%eax
  800692:	89 45 14             	mov    %eax,0x14(%ebp)
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	83 e8 04             	sub    $0x4,%eax
  80069b:	8b 30                	mov    (%eax),%esi
  80069d:	85 f6                	test   %esi,%esi
  80069f:	75 05                	jne    8006a6 <vprintfmt+0x1a6>
				p = "(null)";
  8006a1:	be b1 1f 80 00       	mov    $0x801fb1,%esi
			if (width > 0 && padc != '-')
  8006a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006aa:	7e 6d                	jle    800719 <vprintfmt+0x219>
  8006ac:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006b0:	74 67                	je     800719 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006b5:	83 ec 08             	sub    $0x8,%esp
  8006b8:	50                   	push   %eax
  8006b9:	56                   	push   %esi
  8006ba:	e8 1e 03 00 00       	call   8009dd <strnlen>
  8006bf:	83 c4 10             	add    $0x10,%esp
  8006c2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006c5:	eb 16                	jmp    8006dd <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006c7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006cb:	83 ec 08             	sub    $0x8,%esp
  8006ce:	ff 75 0c             	pushl  0xc(%ebp)
  8006d1:	50                   	push   %eax
  8006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d5:	ff d0                	call   *%eax
  8006d7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006da:	ff 4d e4             	decl   -0x1c(%ebp)
  8006dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006e1:	7f e4                	jg     8006c7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006e3:	eb 34                	jmp    800719 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006e5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006e9:	74 1c                	je     800707 <vprintfmt+0x207>
  8006eb:	83 fb 1f             	cmp    $0x1f,%ebx
  8006ee:	7e 05                	jle    8006f5 <vprintfmt+0x1f5>
  8006f0:	83 fb 7e             	cmp    $0x7e,%ebx
  8006f3:	7e 12                	jle    800707 <vprintfmt+0x207>
					putch('?', putdat);
  8006f5:	83 ec 08             	sub    $0x8,%esp
  8006f8:	ff 75 0c             	pushl  0xc(%ebp)
  8006fb:	6a 3f                	push   $0x3f
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	ff d0                	call   *%eax
  800702:	83 c4 10             	add    $0x10,%esp
  800705:	eb 0f                	jmp    800716 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	ff 75 0c             	pushl  0xc(%ebp)
  80070d:	53                   	push   %ebx
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	ff d0                	call   *%eax
  800713:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800716:	ff 4d e4             	decl   -0x1c(%ebp)
  800719:	89 f0                	mov    %esi,%eax
  80071b:	8d 70 01             	lea    0x1(%eax),%esi
  80071e:	8a 00                	mov    (%eax),%al
  800720:	0f be d8             	movsbl %al,%ebx
  800723:	85 db                	test   %ebx,%ebx
  800725:	74 24                	je     80074b <vprintfmt+0x24b>
  800727:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80072b:	78 b8                	js     8006e5 <vprintfmt+0x1e5>
  80072d:	ff 4d e0             	decl   -0x20(%ebp)
  800730:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800734:	79 af                	jns    8006e5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800736:	eb 13                	jmp    80074b <vprintfmt+0x24b>
				putch(' ', putdat);
  800738:	83 ec 08             	sub    $0x8,%esp
  80073b:	ff 75 0c             	pushl  0xc(%ebp)
  80073e:	6a 20                	push   $0x20
  800740:	8b 45 08             	mov    0x8(%ebp),%eax
  800743:	ff d0                	call   *%eax
  800745:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800748:	ff 4d e4             	decl   -0x1c(%ebp)
  80074b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80074f:	7f e7                	jg     800738 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800751:	e9 78 01 00 00       	jmp    8008ce <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	ff 75 e8             	pushl  -0x18(%ebp)
  80075c:	8d 45 14             	lea    0x14(%ebp),%eax
  80075f:	50                   	push   %eax
  800760:	e8 3c fd ff ff       	call   8004a1 <getint>
  800765:	83 c4 10             	add    $0x10,%esp
  800768:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80076b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80076e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800771:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800774:	85 d2                	test   %edx,%edx
  800776:	79 23                	jns    80079b <vprintfmt+0x29b>
				putch('-', putdat);
  800778:	83 ec 08             	sub    $0x8,%esp
  80077b:	ff 75 0c             	pushl  0xc(%ebp)
  80077e:	6a 2d                	push   $0x2d
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	ff d0                	call   *%eax
  800785:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800788:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80078e:	f7 d8                	neg    %eax
  800790:	83 d2 00             	adc    $0x0,%edx
  800793:	f7 da                	neg    %edx
  800795:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800798:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80079b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007a2:	e9 bc 00 00 00       	jmp    800863 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007a7:	83 ec 08             	sub    $0x8,%esp
  8007aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8007ad:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b0:	50                   	push   %eax
  8007b1:	e8 84 fc ff ff       	call   80043a <getuint>
  8007b6:	83 c4 10             	add    $0x10,%esp
  8007b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007bc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007bf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007c6:	e9 98 00 00 00       	jmp    800863 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	ff 75 0c             	pushl  0xc(%ebp)
  8007d1:	6a 58                	push   $0x58
  8007d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d6:	ff d0                	call   *%eax
  8007d8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	ff 75 0c             	pushl  0xc(%ebp)
  8007e1:	6a 58                	push   $0x58
  8007e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e6:	ff d0                	call   *%eax
  8007e8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007eb:	83 ec 08             	sub    $0x8,%esp
  8007ee:	ff 75 0c             	pushl  0xc(%ebp)
  8007f1:	6a 58                	push   $0x58
  8007f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f6:	ff d0                	call   *%eax
  8007f8:	83 c4 10             	add    $0x10,%esp
			break;
  8007fb:	e9 ce 00 00 00       	jmp    8008ce <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800800:	83 ec 08             	sub    $0x8,%esp
  800803:	ff 75 0c             	pushl  0xc(%ebp)
  800806:	6a 30                	push   $0x30
  800808:	8b 45 08             	mov    0x8(%ebp),%eax
  80080b:	ff d0                	call   *%eax
  80080d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800810:	83 ec 08             	sub    $0x8,%esp
  800813:	ff 75 0c             	pushl  0xc(%ebp)
  800816:	6a 78                	push   $0x78
  800818:	8b 45 08             	mov    0x8(%ebp),%eax
  80081b:	ff d0                	call   *%eax
  80081d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800820:	8b 45 14             	mov    0x14(%ebp),%eax
  800823:	83 c0 04             	add    $0x4,%eax
  800826:	89 45 14             	mov    %eax,0x14(%ebp)
  800829:	8b 45 14             	mov    0x14(%ebp),%eax
  80082c:	83 e8 04             	sub    $0x4,%eax
  80082f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800831:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800834:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80083b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800842:	eb 1f                	jmp    800863 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800844:	83 ec 08             	sub    $0x8,%esp
  800847:	ff 75 e8             	pushl  -0x18(%ebp)
  80084a:	8d 45 14             	lea    0x14(%ebp),%eax
  80084d:	50                   	push   %eax
  80084e:	e8 e7 fb ff ff       	call   80043a <getuint>
  800853:	83 c4 10             	add    $0x10,%esp
  800856:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800859:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80085c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800863:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800867:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80086a:	83 ec 04             	sub    $0x4,%esp
  80086d:	52                   	push   %edx
  80086e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800871:	50                   	push   %eax
  800872:	ff 75 f4             	pushl  -0xc(%ebp)
  800875:	ff 75 f0             	pushl  -0x10(%ebp)
  800878:	ff 75 0c             	pushl  0xc(%ebp)
  80087b:	ff 75 08             	pushl  0x8(%ebp)
  80087e:	e8 00 fb ff ff       	call   800383 <printnum>
  800883:	83 c4 20             	add    $0x20,%esp
			break;
  800886:	eb 46                	jmp    8008ce <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800888:	83 ec 08             	sub    $0x8,%esp
  80088b:	ff 75 0c             	pushl  0xc(%ebp)
  80088e:	53                   	push   %ebx
  80088f:	8b 45 08             	mov    0x8(%ebp),%eax
  800892:	ff d0                	call   *%eax
  800894:	83 c4 10             	add    $0x10,%esp
			break;
  800897:	eb 35                	jmp    8008ce <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800899:	c6 05 e0 68 81 00 00 	movb   $0x0,0x8168e0
			break;
  8008a0:	eb 2c                	jmp    8008ce <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8008a2:	c6 05 e0 68 81 00 01 	movb   $0x1,0x8168e0
			break;
  8008a9:	eb 23                	jmp    8008ce <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ab:	83 ec 08             	sub    $0x8,%esp
  8008ae:	ff 75 0c             	pushl  0xc(%ebp)
  8008b1:	6a 25                	push   $0x25
  8008b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b6:	ff d0                	call   *%eax
  8008b8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008bb:	ff 4d 10             	decl   0x10(%ebp)
  8008be:	eb 03                	jmp    8008c3 <vprintfmt+0x3c3>
  8008c0:	ff 4d 10             	decl   0x10(%ebp)
  8008c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c6:	48                   	dec    %eax
  8008c7:	8a 00                	mov    (%eax),%al
  8008c9:	3c 25                	cmp    $0x25,%al
  8008cb:	75 f3                	jne    8008c0 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008cd:	90                   	nop
		}
	}
  8008ce:	e9 35 fc ff ff       	jmp    800508 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008d3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008d7:	5b                   	pop    %ebx
  8008d8:	5e                   	pop    %esi
  8008d9:	5d                   	pop    %ebp
  8008da:	c3                   	ret    

008008db <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008e1:	8d 45 10             	lea    0x10(%ebp),%eax
  8008e4:	83 c0 04             	add    $0x4,%eax
  8008e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8008f0:	50                   	push   %eax
  8008f1:	ff 75 0c             	pushl  0xc(%ebp)
  8008f4:	ff 75 08             	pushl  0x8(%ebp)
  8008f7:	e8 04 fc ff ff       	call   800500 <vprintfmt>
  8008fc:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008ff:	90                   	nop
  800900:	c9                   	leave  
  800901:	c3                   	ret    

00800902 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800902:	55                   	push   %ebp
  800903:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800905:	8b 45 0c             	mov    0xc(%ebp),%eax
  800908:	8b 40 08             	mov    0x8(%eax),%eax
  80090b:	8d 50 01             	lea    0x1(%eax),%edx
  80090e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800911:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800914:	8b 45 0c             	mov    0xc(%ebp),%eax
  800917:	8b 10                	mov    (%eax),%edx
  800919:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091c:	8b 40 04             	mov    0x4(%eax),%eax
  80091f:	39 c2                	cmp    %eax,%edx
  800921:	73 12                	jae    800935 <sprintputch+0x33>
		*b->buf++ = ch;
  800923:	8b 45 0c             	mov    0xc(%ebp),%eax
  800926:	8b 00                	mov    (%eax),%eax
  800928:	8d 48 01             	lea    0x1(%eax),%ecx
  80092b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80092e:	89 0a                	mov    %ecx,(%edx)
  800930:	8b 55 08             	mov    0x8(%ebp),%edx
  800933:	88 10                	mov    %dl,(%eax)
}
  800935:	90                   	nop
  800936:	5d                   	pop    %ebp
  800937:	c3                   	ret    

00800938 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800938:	55                   	push   %ebp
  800939:	89 e5                	mov    %esp,%ebp
  80093b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800944:	8b 45 0c             	mov    0xc(%ebp),%eax
  800947:	8d 50 ff             	lea    -0x1(%eax),%edx
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	01 d0                	add    %edx,%eax
  80094f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800952:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800959:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80095d:	74 06                	je     800965 <vsnprintf+0x2d>
  80095f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800963:	7f 07                	jg     80096c <vsnprintf+0x34>
		return -E_INVAL;
  800965:	b8 03 00 00 00       	mov    $0x3,%eax
  80096a:	eb 20                	jmp    80098c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80096c:	ff 75 14             	pushl  0x14(%ebp)
  80096f:	ff 75 10             	pushl  0x10(%ebp)
  800972:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800975:	50                   	push   %eax
  800976:	68 02 09 80 00       	push   $0x800902
  80097b:	e8 80 fb ff ff       	call   800500 <vprintfmt>
  800980:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800983:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800986:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800989:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80098c:	c9                   	leave  
  80098d:	c3                   	ret    

0080098e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800994:	8d 45 10             	lea    0x10(%ebp),%eax
  800997:	83 c0 04             	add    $0x4,%eax
  80099a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80099d:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a3:	50                   	push   %eax
  8009a4:	ff 75 0c             	pushl  0xc(%ebp)
  8009a7:	ff 75 08             	pushl  0x8(%ebp)
  8009aa:	e8 89 ff ff ff       	call   800938 <vsnprintf>
  8009af:	83 c4 10             	add    $0x10,%esp
  8009b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009b8:	c9                   	leave  
  8009b9:	c3                   	ret    

008009ba <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009c7:	eb 06                	jmp    8009cf <strlen+0x15>
		n++;
  8009c9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009cc:	ff 45 08             	incl   0x8(%ebp)
  8009cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d2:	8a 00                	mov    (%eax),%al
  8009d4:	84 c0                	test   %al,%al
  8009d6:	75 f1                	jne    8009c9 <strlen+0xf>
		n++;
	return n;
  8009d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009db:	c9                   	leave  
  8009dc:	c3                   	ret    

008009dd <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009dd:	55                   	push   %ebp
  8009de:	89 e5                	mov    %esp,%ebp
  8009e0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009ea:	eb 09                	jmp    8009f5 <strnlen+0x18>
		n++;
  8009ec:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009ef:	ff 45 08             	incl   0x8(%ebp)
  8009f2:	ff 4d 0c             	decl   0xc(%ebp)
  8009f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009f9:	74 09                	je     800a04 <strnlen+0x27>
  8009fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fe:	8a 00                	mov    (%eax),%al
  800a00:	84 c0                	test   %al,%al
  800a02:	75 e8                	jne    8009ec <strnlen+0xf>
		n++;
	return n;
  800a04:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a07:	c9                   	leave  
  800a08:	c3                   	ret    

00800a09 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a09:	55                   	push   %ebp
  800a0a:	89 e5                	mov    %esp,%ebp
  800a0c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a15:	90                   	nop
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	8d 50 01             	lea    0x1(%eax),%edx
  800a1c:	89 55 08             	mov    %edx,0x8(%ebp)
  800a1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a22:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a25:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a28:	8a 12                	mov    (%edx),%dl
  800a2a:	88 10                	mov    %dl,(%eax)
  800a2c:	8a 00                	mov    (%eax),%al
  800a2e:	84 c0                	test   %al,%al
  800a30:	75 e4                	jne    800a16 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a32:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a35:	c9                   	leave  
  800a36:	c3                   	ret    

00800a37 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a43:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a4a:	eb 1f                	jmp    800a6b <strncpy+0x34>
		*dst++ = *src;
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	8d 50 01             	lea    0x1(%eax),%edx
  800a52:	89 55 08             	mov    %edx,0x8(%ebp)
  800a55:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a58:	8a 12                	mov    (%edx),%dl
  800a5a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5f:	8a 00                	mov    (%eax),%al
  800a61:	84 c0                	test   %al,%al
  800a63:	74 03                	je     800a68 <strncpy+0x31>
			src++;
  800a65:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a68:	ff 45 fc             	incl   -0x4(%ebp)
  800a6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a6e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a71:	72 d9                	jb     800a4c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a73:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a76:	c9                   	leave  
  800a77:	c3                   	ret    

00800a78 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
  800a7b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a88:	74 30                	je     800aba <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a8a:	eb 16                	jmp    800aa2 <strlcpy+0x2a>
			*dst++ = *src++;
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	8d 50 01             	lea    0x1(%eax),%edx
  800a92:	89 55 08             	mov    %edx,0x8(%ebp)
  800a95:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a98:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a9b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a9e:	8a 12                	mov    (%edx),%dl
  800aa0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800aa2:	ff 4d 10             	decl   0x10(%ebp)
  800aa5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aa9:	74 09                	je     800ab4 <strlcpy+0x3c>
  800aab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aae:	8a 00                	mov    (%eax),%al
  800ab0:	84 c0                	test   %al,%al
  800ab2:	75 d8                	jne    800a8c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800aba:	8b 55 08             	mov    0x8(%ebp),%edx
  800abd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ac0:	29 c2                	sub    %eax,%edx
  800ac2:	89 d0                	mov    %edx,%eax
}
  800ac4:	c9                   	leave  
  800ac5:	c3                   	ret    

00800ac6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ac9:	eb 06                	jmp    800ad1 <strcmp+0xb>
		p++, q++;
  800acb:	ff 45 08             	incl   0x8(%ebp)
  800ace:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	8a 00                	mov    (%eax),%al
  800ad6:	84 c0                	test   %al,%al
  800ad8:	74 0e                	je     800ae8 <strcmp+0x22>
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	8a 10                	mov    (%eax),%dl
  800adf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae2:	8a 00                	mov    (%eax),%al
  800ae4:	38 c2                	cmp    %al,%dl
  800ae6:	74 e3                	je     800acb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	8a 00                	mov    (%eax),%al
  800aed:	0f b6 d0             	movzbl %al,%edx
  800af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af3:	8a 00                	mov    (%eax),%al
  800af5:	0f b6 c0             	movzbl %al,%eax
  800af8:	29 c2                	sub    %eax,%edx
  800afa:	89 d0                	mov    %edx,%eax
}
  800afc:	5d                   	pop    %ebp
  800afd:	c3                   	ret    

00800afe <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b01:	eb 09                	jmp    800b0c <strncmp+0xe>
		n--, p++, q++;
  800b03:	ff 4d 10             	decl   0x10(%ebp)
  800b06:	ff 45 08             	incl   0x8(%ebp)
  800b09:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b0c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b10:	74 17                	je     800b29 <strncmp+0x2b>
  800b12:	8b 45 08             	mov    0x8(%ebp),%eax
  800b15:	8a 00                	mov    (%eax),%al
  800b17:	84 c0                	test   %al,%al
  800b19:	74 0e                	je     800b29 <strncmp+0x2b>
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	8a 10                	mov    (%eax),%dl
  800b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b23:	8a 00                	mov    (%eax),%al
  800b25:	38 c2                	cmp    %al,%dl
  800b27:	74 da                	je     800b03 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b2d:	75 07                	jne    800b36 <strncmp+0x38>
		return 0;
  800b2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b34:	eb 14                	jmp    800b4a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	8a 00                	mov    (%eax),%al
  800b3b:	0f b6 d0             	movzbl %al,%edx
  800b3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b41:	8a 00                	mov    (%eax),%al
  800b43:	0f b6 c0             	movzbl %al,%eax
  800b46:	29 c2                	sub    %eax,%edx
  800b48:	89 d0                	mov    %edx,%eax
}
  800b4a:	5d                   	pop    %ebp
  800b4b:	c3                   	ret    

00800b4c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	83 ec 04             	sub    $0x4,%esp
  800b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b55:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b58:	eb 12                	jmp    800b6c <strchr+0x20>
		if (*s == c)
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	8a 00                	mov    (%eax),%al
  800b5f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b62:	75 05                	jne    800b69 <strchr+0x1d>
			return (char *) s;
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	eb 11                	jmp    800b7a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b69:	ff 45 08             	incl   0x8(%ebp)
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	8a 00                	mov    (%eax),%al
  800b71:	84 c0                	test   %al,%al
  800b73:	75 e5                	jne    800b5a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b7a:	c9                   	leave  
  800b7b:	c3                   	ret    

00800b7c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	83 ec 04             	sub    $0x4,%esp
  800b82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b85:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b88:	eb 0d                	jmp    800b97 <strfind+0x1b>
		if (*s == c)
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	8a 00                	mov    (%eax),%al
  800b8f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b92:	74 0e                	je     800ba2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b94:	ff 45 08             	incl   0x8(%ebp)
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	8a 00                	mov    (%eax),%al
  800b9c:	84 c0                	test   %al,%al
  800b9e:	75 ea                	jne    800b8a <strfind+0xe>
  800ba0:	eb 01                	jmp    800ba3 <strfind+0x27>
		if (*s == c)
			break;
  800ba2:	90                   	nop
	return (char *) s;
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ba6:	c9                   	leave  
  800ba7:	c3                   	ret    

00800ba8 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800ba8:	55                   	push   %ebp
  800ba9:	89 e5                	mov    %esp,%ebp
  800bab:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800bb4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800bb8:	76 63                	jbe    800c1d <memset+0x75>
		uint64 data_block = c;
  800bba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbd:	99                   	cltd   
  800bbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc1:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bca:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800bce:	c1 e0 08             	shl    $0x8,%eax
  800bd1:	09 45 f0             	or     %eax,-0x10(%ebp)
  800bd4:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bdd:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800be1:	c1 e0 10             	shl    $0x10,%eax
  800be4:	09 45 f0             	or     %eax,-0x10(%ebp)
  800be7:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf0:	89 c2                	mov    %eax,%edx
  800bf2:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf7:	09 45 f0             	or     %eax,-0x10(%ebp)
  800bfa:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800bfd:	eb 18                	jmp    800c17 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800bff:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800c02:	8d 41 08             	lea    0x8(%ecx),%eax
  800c05:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0e:	89 01                	mov    %eax,(%ecx)
  800c10:	89 51 04             	mov    %edx,0x4(%ecx)
  800c13:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800c17:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c1b:	77 e2                	ja     800bff <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800c1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c21:	74 23                	je     800c46 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800c23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c26:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c29:	eb 0e                	jmp    800c39 <memset+0x91>
			*p8++ = (uint8)c;
  800c2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c2e:	8d 50 01             	lea    0x1(%eax),%edx
  800c31:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c37:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800c39:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c3f:	89 55 10             	mov    %edx,0x10(%ebp)
  800c42:	85 c0                	test   %eax,%eax
  800c44:	75 e5                	jne    800c2b <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c49:	c9                   	leave  
  800c4a:	c3                   	ret    

00800c4b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800c51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800c5d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c61:	76 24                	jbe    800c87 <memcpy+0x3c>
		while(n >= 8){
  800c63:	eb 1c                	jmp    800c81 <memcpy+0x36>
			*d64 = *s64;
  800c65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c68:	8b 50 04             	mov    0x4(%eax),%edx
  800c6b:	8b 00                	mov    (%eax),%eax
  800c6d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800c70:	89 01                	mov    %eax,(%ecx)
  800c72:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800c75:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800c79:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800c7d:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800c81:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c85:	77 de                	ja     800c65 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800c87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c8b:	74 31                	je     800cbe <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800c8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c90:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800c93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c96:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800c99:	eb 16                	jmp    800cb1 <memcpy+0x66>
			*d8++ = *s8++;
  800c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c9e:	8d 50 01             	lea    0x1(%eax),%edx
  800ca1:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800ca4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ca7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800caa:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800cad:	8a 12                	mov    (%edx),%dl
  800caf:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800cb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cb7:	89 55 10             	mov    %edx,0x10(%ebp)
  800cba:	85 c0                	test   %eax,%eax
  800cbc:	75 dd                	jne    800c9b <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc1:	c9                   	leave  
  800cc2:	c3                   	ret    

00800cc3 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800cd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800cdb:	73 50                	jae    800d2d <memmove+0x6a>
  800cdd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ce0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce3:	01 d0                	add    %edx,%eax
  800ce5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ce8:	76 43                	jbe    800d2d <memmove+0x6a>
		s += n;
  800cea:	8b 45 10             	mov    0x10(%ebp),%eax
  800ced:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800cf0:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800cf6:	eb 10                	jmp    800d08 <memmove+0x45>
			*--d = *--s;
  800cf8:	ff 4d f8             	decl   -0x8(%ebp)
  800cfb:	ff 4d fc             	decl   -0x4(%ebp)
  800cfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d01:	8a 10                	mov    (%eax),%dl
  800d03:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d06:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d08:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800d11:	85 c0                	test   %eax,%eax
  800d13:	75 e3                	jne    800cf8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d15:	eb 23                	jmp    800d3a <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d17:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d1a:	8d 50 01             	lea    0x1(%eax),%edx
  800d1d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d20:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d23:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d26:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d29:	8a 12                	mov    (%edx),%dl
  800d2b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d30:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d33:	89 55 10             	mov    %edx,0x10(%ebp)
  800d36:	85 c0                	test   %eax,%eax
  800d38:	75 dd                	jne    800d17 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d3d:	c9                   	leave  
  800d3e:	c3                   	ret    

00800d3f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d51:	eb 2a                	jmp    800d7d <memcmp+0x3e>
		if (*s1 != *s2)
  800d53:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d56:	8a 10                	mov    (%eax),%dl
  800d58:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d5b:	8a 00                	mov    (%eax),%al
  800d5d:	38 c2                	cmp    %al,%dl
  800d5f:	74 16                	je     800d77 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d64:	8a 00                	mov    (%eax),%al
  800d66:	0f b6 d0             	movzbl %al,%edx
  800d69:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d6c:	8a 00                	mov    (%eax),%al
  800d6e:	0f b6 c0             	movzbl %al,%eax
  800d71:	29 c2                	sub    %eax,%edx
  800d73:	89 d0                	mov    %edx,%eax
  800d75:	eb 18                	jmp    800d8f <memcmp+0x50>
		s1++, s2++;
  800d77:	ff 45 fc             	incl   -0x4(%ebp)
  800d7a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d80:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d83:	89 55 10             	mov    %edx,0x10(%ebp)
  800d86:	85 c0                	test   %eax,%eax
  800d88:	75 c9                	jne    800d53 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d8f:	c9                   	leave  
  800d90:	c3                   	ret    

00800d91 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d97:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9d:	01 d0                	add    %edx,%eax
  800d9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800da2:	eb 15                	jmp    800db9 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	8a 00                	mov    (%eax),%al
  800da9:	0f b6 d0             	movzbl %al,%edx
  800dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800daf:	0f b6 c0             	movzbl %al,%eax
  800db2:	39 c2                	cmp    %eax,%edx
  800db4:	74 0d                	je     800dc3 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800db6:	ff 45 08             	incl   0x8(%ebp)
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800dbf:	72 e3                	jb     800da4 <memfind+0x13>
  800dc1:	eb 01                	jmp    800dc4 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800dc3:	90                   	nop
	return (void *) s;
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc7:	c9                   	leave  
  800dc8:	c3                   	ret    

00800dc9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800dcf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800dd6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ddd:	eb 03                	jmp    800de2 <strtol+0x19>
		s++;
  800ddf:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	3c 20                	cmp    $0x20,%al
  800de9:	74 f4                	je     800ddf <strtol+0x16>
  800deb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dee:	8a 00                	mov    (%eax),%al
  800df0:	3c 09                	cmp    $0x9,%al
  800df2:	74 eb                	je     800ddf <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	3c 2b                	cmp    $0x2b,%al
  800dfb:	75 05                	jne    800e02 <strtol+0x39>
		s++;
  800dfd:	ff 45 08             	incl   0x8(%ebp)
  800e00:	eb 13                	jmp    800e15 <strtol+0x4c>
	else if (*s == '-')
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	8a 00                	mov    (%eax),%al
  800e07:	3c 2d                	cmp    $0x2d,%al
  800e09:	75 0a                	jne    800e15 <strtol+0x4c>
		s++, neg = 1;
  800e0b:	ff 45 08             	incl   0x8(%ebp)
  800e0e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e19:	74 06                	je     800e21 <strtol+0x58>
  800e1b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e1f:	75 20                	jne    800e41 <strtol+0x78>
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	8a 00                	mov    (%eax),%al
  800e26:	3c 30                	cmp    $0x30,%al
  800e28:	75 17                	jne    800e41 <strtol+0x78>
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	40                   	inc    %eax
  800e2e:	8a 00                	mov    (%eax),%al
  800e30:	3c 78                	cmp    $0x78,%al
  800e32:	75 0d                	jne    800e41 <strtol+0x78>
		s += 2, base = 16;
  800e34:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e38:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e3f:	eb 28                	jmp    800e69 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e41:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e45:	75 15                	jne    800e5c <strtol+0x93>
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	8a 00                	mov    (%eax),%al
  800e4c:	3c 30                	cmp    $0x30,%al
  800e4e:	75 0c                	jne    800e5c <strtol+0x93>
		s++, base = 8;
  800e50:	ff 45 08             	incl   0x8(%ebp)
  800e53:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e5a:	eb 0d                	jmp    800e69 <strtol+0xa0>
	else if (base == 0)
  800e5c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e60:	75 07                	jne    800e69 <strtol+0xa0>
		base = 10;
  800e62:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	3c 2f                	cmp    $0x2f,%al
  800e70:	7e 19                	jle    800e8b <strtol+0xc2>
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
  800e75:	8a 00                	mov    (%eax),%al
  800e77:	3c 39                	cmp    $0x39,%al
  800e79:	7f 10                	jg     800e8b <strtol+0xc2>
			dig = *s - '0';
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	8a 00                	mov    (%eax),%al
  800e80:	0f be c0             	movsbl %al,%eax
  800e83:	83 e8 30             	sub    $0x30,%eax
  800e86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e89:	eb 42                	jmp    800ecd <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	8a 00                	mov    (%eax),%al
  800e90:	3c 60                	cmp    $0x60,%al
  800e92:	7e 19                	jle    800ead <strtol+0xe4>
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	3c 7a                	cmp    $0x7a,%al
  800e9b:	7f 10                	jg     800ead <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	8a 00                	mov    (%eax),%al
  800ea2:	0f be c0             	movsbl %al,%eax
  800ea5:	83 e8 57             	sub    $0x57,%eax
  800ea8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800eab:	eb 20                	jmp    800ecd <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb0:	8a 00                	mov    (%eax),%al
  800eb2:	3c 40                	cmp    $0x40,%al
  800eb4:	7e 39                	jle    800eef <strtol+0x126>
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	3c 5a                	cmp    $0x5a,%al
  800ebd:	7f 30                	jg     800eef <strtol+0x126>
			dig = *s - 'A' + 10;
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec2:	8a 00                	mov    (%eax),%al
  800ec4:	0f be c0             	movsbl %al,%eax
  800ec7:	83 e8 37             	sub    $0x37,%eax
  800eca:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ed0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ed3:	7d 19                	jge    800eee <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ed5:	ff 45 08             	incl   0x8(%ebp)
  800ed8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800edb:	0f af 45 10          	imul   0x10(%ebp),%eax
  800edf:	89 c2                	mov    %eax,%edx
  800ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee4:	01 d0                	add    %edx,%eax
  800ee6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800ee9:	e9 7b ff ff ff       	jmp    800e69 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800eee:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800eef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ef3:	74 08                	je     800efd <strtol+0x134>
		*endptr = (char *) s;
  800ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef8:	8b 55 08             	mov    0x8(%ebp),%edx
  800efb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800efd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f01:	74 07                	je     800f0a <strtol+0x141>
  800f03:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f06:	f7 d8                	neg    %eax
  800f08:	eb 03                	jmp    800f0d <strtol+0x144>
  800f0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f0d:	c9                   	leave  
  800f0e:	c3                   	ret    

00800f0f <ltostr>:

void
ltostr(long value, char *str)
{
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
  800f12:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f1c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f23:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f27:	79 13                	jns    800f3c <ltostr+0x2d>
	{
		neg = 1;
  800f29:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f33:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f36:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f39:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f44:	99                   	cltd   
  800f45:	f7 f9                	idiv   %ecx
  800f47:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4d:	8d 50 01             	lea    0x1(%eax),%edx
  800f50:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f53:	89 c2                	mov    %eax,%edx
  800f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f58:	01 d0                	add    %edx,%eax
  800f5a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f5d:	83 c2 30             	add    $0x30,%edx
  800f60:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f62:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f65:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f6a:	f7 e9                	imul   %ecx
  800f6c:	c1 fa 02             	sar    $0x2,%edx
  800f6f:	89 c8                	mov    %ecx,%eax
  800f71:	c1 f8 1f             	sar    $0x1f,%eax
  800f74:	29 c2                	sub    %eax,%edx
  800f76:	89 d0                	mov    %edx,%eax
  800f78:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800f7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f7f:	75 bb                	jne    800f3c <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f88:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f8b:	48                   	dec    %eax
  800f8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f8f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f93:	74 3d                	je     800fd2 <ltostr+0xc3>
		start = 1 ;
  800f95:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f9c:	eb 34                	jmp    800fd2 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800f9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa4:	01 d0                	add    %edx,%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800fab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb1:	01 c2                	add    %eax,%edx
  800fb3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb9:	01 c8                	add    %ecx,%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800fbf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc5:	01 c2                	add    %eax,%edx
  800fc7:	8a 45 eb             	mov    -0x15(%ebp),%al
  800fca:	88 02                	mov    %al,(%edx)
		start++ ;
  800fcc:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800fcf:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fd8:	7c c4                	jl     800f9e <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800fda:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe0:	01 d0                	add    %edx,%eax
  800fe2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800fe5:	90                   	nop
  800fe6:	c9                   	leave  
  800fe7:	c3                   	ret    

00800fe8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800fee:	ff 75 08             	pushl  0x8(%ebp)
  800ff1:	e8 c4 f9 ff ff       	call   8009ba <strlen>
  800ff6:	83 c4 04             	add    $0x4,%esp
  800ff9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800ffc:	ff 75 0c             	pushl  0xc(%ebp)
  800fff:	e8 b6 f9 ff ff       	call   8009ba <strlen>
  801004:	83 c4 04             	add    $0x4,%esp
  801007:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80100a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801011:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801018:	eb 17                	jmp    801031 <strcconcat+0x49>
		final[s] = str1[s] ;
  80101a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80101d:	8b 45 10             	mov    0x10(%ebp),%eax
  801020:	01 c2                	add    %eax,%edx
  801022:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	01 c8                	add    %ecx,%eax
  80102a:	8a 00                	mov    (%eax),%al
  80102c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80102e:	ff 45 fc             	incl   -0x4(%ebp)
  801031:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801034:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801037:	7c e1                	jl     80101a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801039:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801040:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801047:	eb 1f                	jmp    801068 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801049:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104c:	8d 50 01             	lea    0x1(%eax),%edx
  80104f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801052:	89 c2                	mov    %eax,%edx
  801054:	8b 45 10             	mov    0x10(%ebp),%eax
  801057:	01 c2                	add    %eax,%edx
  801059:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80105c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105f:	01 c8                	add    %ecx,%eax
  801061:	8a 00                	mov    (%eax),%al
  801063:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801065:	ff 45 f8             	incl   -0x8(%ebp)
  801068:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80106e:	7c d9                	jl     801049 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801070:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801073:	8b 45 10             	mov    0x10(%ebp),%eax
  801076:	01 d0                	add    %edx,%eax
  801078:	c6 00 00             	movb   $0x0,(%eax)
}
  80107b:	90                   	nop
  80107c:	c9                   	leave  
  80107d:	c3                   	ret    

0080107e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801081:	8b 45 14             	mov    0x14(%ebp),%eax
  801084:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80108a:	8b 45 14             	mov    0x14(%ebp),%eax
  80108d:	8b 00                	mov    (%eax),%eax
  80108f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801096:	8b 45 10             	mov    0x10(%ebp),%eax
  801099:	01 d0                	add    %edx,%eax
  80109b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010a1:	eb 0c                	jmp    8010af <strsplit+0x31>
			*string++ = 0;
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	8d 50 01             	lea    0x1(%eax),%edx
  8010a9:	89 55 08             	mov    %edx,0x8(%ebp)
  8010ac:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	8a 00                	mov    (%eax),%al
  8010b4:	84 c0                	test   %al,%al
  8010b6:	74 18                	je     8010d0 <strsplit+0x52>
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8a 00                	mov    (%eax),%al
  8010bd:	0f be c0             	movsbl %al,%eax
  8010c0:	50                   	push   %eax
  8010c1:	ff 75 0c             	pushl  0xc(%ebp)
  8010c4:	e8 83 fa ff ff       	call   800b4c <strchr>
  8010c9:	83 c4 08             	add    $0x8,%esp
  8010cc:	85 c0                	test   %eax,%eax
  8010ce:	75 d3                	jne    8010a3 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	84 c0                	test   %al,%al
  8010d7:	74 5a                	je     801133 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8010d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8010dc:	8b 00                	mov    (%eax),%eax
  8010de:	83 f8 0f             	cmp    $0xf,%eax
  8010e1:	75 07                	jne    8010ea <strsplit+0x6c>
		{
			return 0;
  8010e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e8:	eb 66                	jmp    801150 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8010ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ed:	8b 00                	mov    (%eax),%eax
  8010ef:	8d 48 01             	lea    0x1(%eax),%ecx
  8010f2:	8b 55 14             	mov    0x14(%ebp),%edx
  8010f5:	89 0a                	mov    %ecx,(%edx)
  8010f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801101:	01 c2                	add    %eax,%edx
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801108:	eb 03                	jmp    80110d <strsplit+0x8f>
			string++;
  80110a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
  801110:	8a 00                	mov    (%eax),%al
  801112:	84 c0                	test   %al,%al
  801114:	74 8b                	je     8010a1 <strsplit+0x23>
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	8a 00                	mov    (%eax),%al
  80111b:	0f be c0             	movsbl %al,%eax
  80111e:	50                   	push   %eax
  80111f:	ff 75 0c             	pushl  0xc(%ebp)
  801122:	e8 25 fa ff ff       	call   800b4c <strchr>
  801127:	83 c4 08             	add    $0x8,%esp
  80112a:	85 c0                	test   %eax,%eax
  80112c:	74 dc                	je     80110a <strsplit+0x8c>
			string++;
	}
  80112e:	e9 6e ff ff ff       	jmp    8010a1 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801133:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801134:	8b 45 14             	mov    0x14(%ebp),%eax
  801137:	8b 00                	mov    (%eax),%eax
  801139:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801140:	8b 45 10             	mov    0x10(%ebp),%eax
  801143:	01 d0                	add    %edx,%eax
  801145:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80114b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801150:	c9                   	leave  
  801151:	c3                   	ret    

00801152 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80115e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801165:	eb 4a                	jmp    8011b1 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801167:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
  80116d:	01 c2                	add    %eax,%edx
  80116f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801172:	8b 45 0c             	mov    0xc(%ebp),%eax
  801175:	01 c8                	add    %ecx,%eax
  801177:	8a 00                	mov    (%eax),%al
  801179:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80117b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80117e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801181:	01 d0                	add    %edx,%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	3c 40                	cmp    $0x40,%al
  801187:	7e 25                	jle    8011ae <str2lower+0x5c>
  801189:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80118c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118f:	01 d0                	add    %edx,%eax
  801191:	8a 00                	mov    (%eax),%al
  801193:	3c 5a                	cmp    $0x5a,%al
  801195:	7f 17                	jg     8011ae <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801197:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
  80119d:	01 d0                	add    %edx,%eax
  80119f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a5:	01 ca                	add    %ecx,%edx
  8011a7:	8a 12                	mov    (%edx),%dl
  8011a9:	83 c2 20             	add    $0x20,%edx
  8011ac:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8011ae:	ff 45 fc             	incl   -0x4(%ebp)
  8011b1:	ff 75 0c             	pushl  0xc(%ebp)
  8011b4:	e8 01 f8 ff ff       	call   8009ba <strlen>
  8011b9:	83 c4 04             	add    $0x4,%esp
  8011bc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011bf:	7f a6                	jg     801167 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8011c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011c4:	c9                   	leave  
  8011c5:	c3                   	ret    

008011c6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8011c6:	55                   	push   %ebp
  8011c7:	89 e5                	mov    %esp,%ebp
  8011c9:	57                   	push   %edi
  8011ca:	56                   	push   %esi
  8011cb:	53                   	push   %ebx
  8011cc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011d8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011db:	8b 7d 18             	mov    0x18(%ebp),%edi
  8011de:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8011e1:	cd 30                	int    $0x30
  8011e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8011e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011e9:	83 c4 10             	add    $0x10,%esp
  8011ec:	5b                   	pop    %ebx
  8011ed:	5e                   	pop    %esi
  8011ee:	5f                   	pop    %edi
  8011ef:	5d                   	pop    %ebp
  8011f0:	c3                   	ret    

008011f1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	83 ec 04             	sub    $0x4,%esp
  8011f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8011fd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801200:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
  801207:	6a 00                	push   $0x0
  801209:	51                   	push   %ecx
  80120a:	52                   	push   %edx
  80120b:	ff 75 0c             	pushl  0xc(%ebp)
  80120e:	50                   	push   %eax
  80120f:	6a 00                	push   $0x0
  801211:	e8 b0 ff ff ff       	call   8011c6 <syscall>
  801216:	83 c4 18             	add    $0x18,%esp
}
  801219:	90                   	nop
  80121a:	c9                   	leave  
  80121b:	c3                   	ret    

0080121c <sys_cgetc>:

int
sys_cgetc(void)
{
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80121f:	6a 00                	push   $0x0
  801221:	6a 00                	push   $0x0
  801223:	6a 00                	push   $0x0
  801225:	6a 00                	push   $0x0
  801227:	6a 00                	push   $0x0
  801229:	6a 02                	push   $0x2
  80122b:	e8 96 ff ff ff       	call   8011c6 <syscall>
  801230:	83 c4 18             	add    $0x18,%esp
}
  801233:	c9                   	leave  
  801234:	c3                   	ret    

00801235 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801238:	6a 00                	push   $0x0
  80123a:	6a 00                	push   $0x0
  80123c:	6a 00                	push   $0x0
  80123e:	6a 00                	push   $0x0
  801240:	6a 00                	push   $0x0
  801242:	6a 03                	push   $0x3
  801244:	e8 7d ff ff ff       	call   8011c6 <syscall>
  801249:	83 c4 18             	add    $0x18,%esp
}
  80124c:	90                   	nop
  80124d:	c9                   	leave  
  80124e:	c3                   	ret    

0080124f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80124f:	55                   	push   %ebp
  801250:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801252:	6a 00                	push   $0x0
  801254:	6a 00                	push   $0x0
  801256:	6a 00                	push   $0x0
  801258:	6a 00                	push   $0x0
  80125a:	6a 00                	push   $0x0
  80125c:	6a 04                	push   $0x4
  80125e:	e8 63 ff ff ff       	call   8011c6 <syscall>
  801263:	83 c4 18             	add    $0x18,%esp
}
  801266:	90                   	nop
  801267:	c9                   	leave  
  801268:	c3                   	ret    

00801269 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801269:	55                   	push   %ebp
  80126a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80126c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	6a 00                	push   $0x0
  801274:	6a 00                	push   $0x0
  801276:	6a 00                	push   $0x0
  801278:	52                   	push   %edx
  801279:	50                   	push   %eax
  80127a:	6a 08                	push   $0x8
  80127c:	e8 45 ff ff ff       	call   8011c6 <syscall>
  801281:	83 c4 18             	add    $0x18,%esp
}
  801284:	c9                   	leave  
  801285:	c3                   	ret    

00801286 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
  801289:	56                   	push   %esi
  80128a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80128b:	8b 75 18             	mov    0x18(%ebp),%esi
  80128e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801291:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801294:	8b 55 0c             	mov    0xc(%ebp),%edx
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	56                   	push   %esi
  80129b:	53                   	push   %ebx
  80129c:	51                   	push   %ecx
  80129d:	52                   	push   %edx
  80129e:	50                   	push   %eax
  80129f:	6a 09                	push   $0x9
  8012a1:	e8 20 ff ff ff       	call   8011c6 <syscall>
  8012a6:	83 c4 18             	add    $0x18,%esp
}
  8012a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012ac:	5b                   	pop    %ebx
  8012ad:	5e                   	pop    %esi
  8012ae:	5d                   	pop    %ebp
  8012af:	c3                   	ret    

008012b0 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8012b3:	6a 00                	push   $0x0
  8012b5:	6a 00                	push   $0x0
  8012b7:	6a 00                	push   $0x0
  8012b9:	6a 00                	push   $0x0
  8012bb:	ff 75 08             	pushl  0x8(%ebp)
  8012be:	6a 0a                	push   $0xa
  8012c0:	e8 01 ff ff ff       	call   8011c6 <syscall>
  8012c5:	83 c4 18             	add    $0x18,%esp
}
  8012c8:	c9                   	leave  
  8012c9:	c3                   	ret    

008012ca <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8012cd:	6a 00                	push   $0x0
  8012cf:	6a 00                	push   $0x0
  8012d1:	6a 00                	push   $0x0
  8012d3:	ff 75 0c             	pushl  0xc(%ebp)
  8012d6:	ff 75 08             	pushl  0x8(%ebp)
  8012d9:	6a 0b                	push   $0xb
  8012db:	e8 e6 fe ff ff       	call   8011c6 <syscall>
  8012e0:	83 c4 18             	add    $0x18,%esp
}
  8012e3:	c9                   	leave  
  8012e4:	c3                   	ret    

008012e5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8012e8:	6a 00                	push   $0x0
  8012ea:	6a 00                	push   $0x0
  8012ec:	6a 00                	push   $0x0
  8012ee:	6a 00                	push   $0x0
  8012f0:	6a 00                	push   $0x0
  8012f2:	6a 0c                	push   $0xc
  8012f4:	e8 cd fe ff ff       	call   8011c6 <syscall>
  8012f9:	83 c4 18             	add    $0x18,%esp
}
  8012fc:	c9                   	leave  
  8012fd:	c3                   	ret    

008012fe <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801301:	6a 00                	push   $0x0
  801303:	6a 00                	push   $0x0
  801305:	6a 00                	push   $0x0
  801307:	6a 00                	push   $0x0
  801309:	6a 00                	push   $0x0
  80130b:	6a 0d                	push   $0xd
  80130d:	e8 b4 fe ff ff       	call   8011c6 <syscall>
  801312:	83 c4 18             	add    $0x18,%esp
}
  801315:	c9                   	leave  
  801316:	c3                   	ret    

00801317 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80131a:	6a 00                	push   $0x0
  80131c:	6a 00                	push   $0x0
  80131e:	6a 00                	push   $0x0
  801320:	6a 00                	push   $0x0
  801322:	6a 00                	push   $0x0
  801324:	6a 0e                	push   $0xe
  801326:	e8 9b fe ff ff       	call   8011c6 <syscall>
  80132b:	83 c4 18             	add    $0x18,%esp
}
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    

00801330 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801333:	6a 00                	push   $0x0
  801335:	6a 00                	push   $0x0
  801337:	6a 00                	push   $0x0
  801339:	6a 00                	push   $0x0
  80133b:	6a 00                	push   $0x0
  80133d:	6a 0f                	push   $0xf
  80133f:	e8 82 fe ff ff       	call   8011c6 <syscall>
  801344:	83 c4 18             	add    $0x18,%esp
}
  801347:	c9                   	leave  
  801348:	c3                   	ret    

00801349 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80134c:	6a 00                	push   $0x0
  80134e:	6a 00                	push   $0x0
  801350:	6a 00                	push   $0x0
  801352:	6a 00                	push   $0x0
  801354:	ff 75 08             	pushl  0x8(%ebp)
  801357:	6a 10                	push   $0x10
  801359:	e8 68 fe ff ff       	call   8011c6 <syscall>
  80135e:	83 c4 18             	add    $0x18,%esp
}
  801361:	c9                   	leave  
  801362:	c3                   	ret    

00801363 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801363:	55                   	push   %ebp
  801364:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801366:	6a 00                	push   $0x0
  801368:	6a 00                	push   $0x0
  80136a:	6a 00                	push   $0x0
  80136c:	6a 00                	push   $0x0
  80136e:	6a 00                	push   $0x0
  801370:	6a 11                	push   $0x11
  801372:	e8 4f fe ff ff       	call   8011c6 <syscall>
  801377:	83 c4 18             	add    $0x18,%esp
}
  80137a:	90                   	nop
  80137b:	c9                   	leave  
  80137c:	c3                   	ret    

0080137d <sys_cputc>:

void
sys_cputc(const char c)
{
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
  801380:	83 ec 04             	sub    $0x4,%esp
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
  801386:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801389:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	6a 00                	push   $0x0
  801393:	6a 00                	push   $0x0
  801395:	50                   	push   %eax
  801396:	6a 01                	push   $0x1
  801398:	e8 29 fe ff ff       	call   8011c6 <syscall>
  80139d:	83 c4 18             	add    $0x18,%esp
}
  8013a0:	90                   	nop
  8013a1:	c9                   	leave  
  8013a2:	c3                   	ret    

008013a3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013a3:	55                   	push   %ebp
  8013a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 14                	push   $0x14
  8013b2:	e8 0f fe ff ff       	call   8011c6 <syscall>
  8013b7:	83 c4 18             	add    $0x18,%esp
}
  8013ba:	90                   	nop
  8013bb:	c9                   	leave  
  8013bc:	c3                   	ret    

008013bd <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013bd:	55                   	push   %ebp
  8013be:	89 e5                	mov    %esp,%ebp
  8013c0:	83 ec 04             	sub    $0x4,%esp
  8013c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8013c9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013cc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d3:	6a 00                	push   $0x0
  8013d5:	51                   	push   %ecx
  8013d6:	52                   	push   %edx
  8013d7:	ff 75 0c             	pushl  0xc(%ebp)
  8013da:	50                   	push   %eax
  8013db:	6a 15                	push   $0x15
  8013dd:	e8 e4 fd ff ff       	call   8011c6 <syscall>
  8013e2:	83 c4 18             	add    $0x18,%esp
}
  8013e5:	c9                   	leave  
  8013e6:	c3                   	ret    

008013e7 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8013ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	52                   	push   %edx
  8013f7:	50                   	push   %eax
  8013f8:	6a 16                	push   $0x16
  8013fa:	e8 c7 fd ff ff       	call   8011c6 <syscall>
  8013ff:	83 c4 18             	add    $0x18,%esp
}
  801402:	c9                   	leave  
  801403:	c3                   	ret    

00801404 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801407:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80140a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80140d:	8b 45 08             	mov    0x8(%ebp),%eax
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	51                   	push   %ecx
  801415:	52                   	push   %edx
  801416:	50                   	push   %eax
  801417:	6a 17                	push   $0x17
  801419:	e8 a8 fd ff ff       	call   8011c6 <syscall>
  80141e:	83 c4 18             	add    $0x18,%esp
}
  801421:	c9                   	leave  
  801422:	c3                   	ret    

00801423 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801426:	8b 55 0c             	mov    0xc(%ebp),%edx
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	52                   	push   %edx
  801433:	50                   	push   %eax
  801434:	6a 18                	push   $0x18
  801436:	e8 8b fd ff ff       	call   8011c6 <syscall>
  80143b:	83 c4 18             	add    $0x18,%esp
}
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    

00801440 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801443:	8b 45 08             	mov    0x8(%ebp),%eax
  801446:	6a 00                	push   $0x0
  801448:	ff 75 14             	pushl  0x14(%ebp)
  80144b:	ff 75 10             	pushl  0x10(%ebp)
  80144e:	ff 75 0c             	pushl  0xc(%ebp)
  801451:	50                   	push   %eax
  801452:	6a 19                	push   $0x19
  801454:	e8 6d fd ff ff       	call   8011c6 <syscall>
  801459:	83 c4 18             	add    $0x18,%esp
}
  80145c:	c9                   	leave  
  80145d:	c3                   	ret    

0080145e <sys_run_env>:

void sys_run_env(int32 envId)
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	6a 00                	push   $0x0
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	6a 00                	push   $0x0
  80146c:	50                   	push   %eax
  80146d:	6a 1a                	push   $0x1a
  80146f:	e8 52 fd ff ff       	call   8011c6 <syscall>
  801474:	83 c4 18             	add    $0x18,%esp
}
  801477:	90                   	nop
  801478:	c9                   	leave  
  801479:	c3                   	ret    

0080147a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80147a:	55                   	push   %ebp
  80147b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	6a 00                	push   $0x0
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	50                   	push   %eax
  801489:	6a 1b                	push   $0x1b
  80148b:	e8 36 fd ff ff       	call   8011c6 <syscall>
  801490:	83 c4 18             	add    $0x18,%esp
}
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 05                	push   $0x5
  8014a4:	e8 1d fd ff ff       	call   8011c6 <syscall>
  8014a9:	83 c4 18             	add    $0x18,%esp
}
  8014ac:	c9                   	leave  
  8014ad:	c3                   	ret    

008014ae <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 06                	push   $0x6
  8014bd:	e8 04 fd ff ff       	call   8011c6 <syscall>
  8014c2:	83 c4 18             	add    $0x18,%esp
}
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 07                	push   $0x7
  8014d6:	e8 eb fc ff ff       	call   8011c6 <syscall>
  8014db:	83 c4 18             	add    $0x18,%esp
}
  8014de:	c9                   	leave  
  8014df:	c3                   	ret    

008014e0 <sys_exit_env>:


void sys_exit_env(void)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 1c                	push   $0x1c
  8014ef:	e8 d2 fc ff ff       	call   8011c6 <syscall>
  8014f4:	83 c4 18             	add    $0x18,%esp
}
  8014f7:	90                   	nop
  8014f8:	c9                   	leave  
  8014f9:	c3                   	ret    

008014fa <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801500:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801503:	8d 50 04             	lea    0x4(%eax),%edx
  801506:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	52                   	push   %edx
  801510:	50                   	push   %eax
  801511:	6a 1d                	push   $0x1d
  801513:	e8 ae fc ff ff       	call   8011c6 <syscall>
  801518:	83 c4 18             	add    $0x18,%esp
	return result;
  80151b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80151e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801521:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801524:	89 01                	mov    %eax,(%ecx)
  801526:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801529:	8b 45 08             	mov    0x8(%ebp),%eax
  80152c:	c9                   	leave  
  80152d:	c2 04 00             	ret    $0x4

00801530 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	ff 75 10             	pushl  0x10(%ebp)
  80153a:	ff 75 0c             	pushl  0xc(%ebp)
  80153d:	ff 75 08             	pushl  0x8(%ebp)
  801540:	6a 13                	push   $0x13
  801542:	e8 7f fc ff ff       	call   8011c6 <syscall>
  801547:	83 c4 18             	add    $0x18,%esp
	return ;
  80154a:	90                   	nop
}
  80154b:	c9                   	leave  
  80154c:	c3                   	ret    

0080154d <sys_rcr2>:
uint32 sys_rcr2()
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	6a 1e                	push   $0x1e
  80155c:	e8 65 fc ff ff       	call   8011c6 <syscall>
  801561:	83 c4 18             	add    $0x18,%esp
}
  801564:	c9                   	leave  
  801565:	c3                   	ret    

00801566 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	83 ec 04             	sub    $0x4,%esp
  80156c:	8b 45 08             	mov    0x8(%ebp),%eax
  80156f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801572:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	50                   	push   %eax
  80157f:	6a 1f                	push   $0x1f
  801581:	e8 40 fc ff ff       	call   8011c6 <syscall>
  801586:	83 c4 18             	add    $0x18,%esp
	return ;
  801589:	90                   	nop
}
  80158a:	c9                   	leave  
  80158b:	c3                   	ret    

0080158c <rsttst>:
void rsttst()
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 21                	push   $0x21
  80159b:	e8 26 fc ff ff       	call   8011c6 <syscall>
  8015a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8015a3:	90                   	nop
}
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
  8015a9:	83 ec 04             	sub    $0x4,%esp
  8015ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8015af:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015b2:	8b 55 18             	mov    0x18(%ebp),%edx
  8015b5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015b9:	52                   	push   %edx
  8015ba:	50                   	push   %eax
  8015bb:	ff 75 10             	pushl  0x10(%ebp)
  8015be:	ff 75 0c             	pushl  0xc(%ebp)
  8015c1:	ff 75 08             	pushl  0x8(%ebp)
  8015c4:	6a 20                	push   $0x20
  8015c6:	e8 fb fb ff ff       	call   8011c6 <syscall>
  8015cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8015ce:	90                   	nop
}
  8015cf:	c9                   	leave  
  8015d0:	c3                   	ret    

008015d1 <chktst>:
void chktst(uint32 n)
{
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	ff 75 08             	pushl  0x8(%ebp)
  8015df:	6a 22                	push   $0x22
  8015e1:	e8 e0 fb ff ff       	call   8011c6 <syscall>
  8015e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8015e9:	90                   	nop
}
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <inctst>:

void inctst()
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 23                	push   $0x23
  8015fb:	e8 c6 fb ff ff       	call   8011c6 <syscall>
  801600:	83 c4 18             	add    $0x18,%esp
	return ;
  801603:	90                   	nop
}
  801604:	c9                   	leave  
  801605:	c3                   	ret    

00801606 <gettst>:
uint32 gettst()
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 24                	push   $0x24
  801615:	e8 ac fb ff ff       	call   8011c6 <syscall>
  80161a:	83 c4 18             	add    $0x18,%esp
}
  80161d:	c9                   	leave  
  80161e:	c3                   	ret    

0080161f <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 25                	push   $0x25
  80162e:	e8 93 fb ff ff       	call   8011c6 <syscall>
  801633:	83 c4 18             	add    $0x18,%esp
  801636:	a3 00 e9 82 00       	mov    %eax,0x82e900
	return uheapPlaceStrategy ;
  80163b:	a1 00 e9 82 00       	mov    0x82e900,%eax
}
  801640:	c9                   	leave  
  801641:	c3                   	ret    

00801642 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801642:	55                   	push   %ebp
  801643:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801645:	8b 45 08             	mov    0x8(%ebp),%eax
  801648:	a3 00 e9 82 00       	mov    %eax,0x82e900
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	ff 75 08             	pushl  0x8(%ebp)
  801658:	6a 26                	push   $0x26
  80165a:	e8 67 fb ff ff       	call   8011c6 <syscall>
  80165f:	83 c4 18             	add    $0x18,%esp
	return ;
  801662:	90                   	nop
}
  801663:	c9                   	leave  
  801664:	c3                   	ret    

00801665 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801665:	55                   	push   %ebp
  801666:	89 e5                	mov    %esp,%ebp
  801668:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801669:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80166c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80166f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	6a 00                	push   $0x0
  801677:	53                   	push   %ebx
  801678:	51                   	push   %ecx
  801679:	52                   	push   %edx
  80167a:	50                   	push   %eax
  80167b:	6a 27                	push   $0x27
  80167d:	e8 44 fb ff ff       	call   8011c6 <syscall>
  801682:	83 c4 18             	add    $0x18,%esp
}
  801685:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801688:	c9                   	leave  
  801689:	c3                   	ret    

0080168a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80168d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	52                   	push   %edx
  80169a:	50                   	push   %eax
  80169b:	6a 28                	push   $0x28
  80169d:	e8 24 fb ff ff       	call   8011c6 <syscall>
  8016a2:	83 c4 18             	add    $0x18,%esp
}
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    

008016a7 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8016aa:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b3:	6a 00                	push   $0x0
  8016b5:	51                   	push   %ecx
  8016b6:	ff 75 10             	pushl  0x10(%ebp)
  8016b9:	52                   	push   %edx
  8016ba:	50                   	push   %eax
  8016bb:	6a 29                	push   $0x29
  8016bd:	e8 04 fb ff ff       	call   8011c6 <syscall>
  8016c2:	83 c4 18             	add    $0x18,%esp
}
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    

008016c7 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	ff 75 10             	pushl  0x10(%ebp)
  8016d1:	ff 75 0c             	pushl  0xc(%ebp)
  8016d4:	ff 75 08             	pushl  0x8(%ebp)
  8016d7:	6a 12                	push   $0x12
  8016d9:	e8 e8 fa ff ff       	call   8011c6 <syscall>
  8016de:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e1:	90                   	nop
}
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8016e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	52                   	push   %edx
  8016f4:	50                   	push   %eax
  8016f5:	6a 2a                	push   $0x2a
  8016f7:	e8 ca fa ff ff       	call   8011c6 <syscall>
  8016fc:	83 c4 18             	add    $0x18,%esp
	return;
  8016ff:	90                   	nop
}
  801700:	c9                   	leave  
  801701:	c3                   	ret    

00801702 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 2b                	push   $0x2b
  801711:	e8 b0 fa ff ff       	call   8011c6 <syscall>
  801716:	83 c4 18             	add    $0x18,%esp
}
  801719:	c9                   	leave  
  80171a:	c3                   	ret    

0080171b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	ff 75 0c             	pushl  0xc(%ebp)
  801727:	ff 75 08             	pushl  0x8(%ebp)
  80172a:	6a 2d                	push   $0x2d
  80172c:	e8 95 fa ff ff       	call   8011c6 <syscall>
  801731:	83 c4 18             	add    $0x18,%esp
	return;
  801734:	90                   	nop
}
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	ff 75 0c             	pushl  0xc(%ebp)
  801743:	ff 75 08             	pushl  0x8(%ebp)
  801746:	6a 2c                	push   $0x2c
  801748:	e8 79 fa ff ff       	call   8011c6 <syscall>
  80174d:	83 c4 18             	add    $0x18,%esp
	return ;
  801750:	90                   	nop
}
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801759:	83 ec 04             	sub    $0x4,%esp
  80175c:	68 28 21 80 00       	push   $0x802128
  801761:	68 25 01 00 00       	push   $0x125
  801766:	68 5b 21 80 00       	push   $0x80215b
  80176b:	e8 00 00 00 00       	call   801770 <_panic>

00801770 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801776:	8d 45 10             	lea    0x10(%ebp),%eax
  801779:	83 c0 04             	add    $0x4,%eax
  80177c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80177f:	a1 bc e9 82 00       	mov    0x82e9bc,%eax
  801784:	85 c0                	test   %eax,%eax
  801786:	74 16                	je     80179e <_panic+0x2e>
		cprintf("%s: ", argv0);
  801788:	a1 bc e9 82 00       	mov    0x82e9bc,%eax
  80178d:	83 ec 08             	sub    $0x8,%esp
  801790:	50                   	push   %eax
  801791:	68 6c 21 80 00       	push   $0x80216c
  801796:	e8 46 eb ff ff       	call   8002e1 <cprintf>
  80179b:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80179e:	a1 04 30 80 00       	mov    0x803004,%eax
  8017a3:	83 ec 0c             	sub    $0xc,%esp
  8017a6:	ff 75 0c             	pushl  0xc(%ebp)
  8017a9:	ff 75 08             	pushl  0x8(%ebp)
  8017ac:	50                   	push   %eax
  8017ad:	68 74 21 80 00       	push   $0x802174
  8017b2:	6a 74                	push   $0x74
  8017b4:	e8 55 eb ff ff       	call   80030e <cprintf_colored>
  8017b9:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8017bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017bf:	83 ec 08             	sub    $0x8,%esp
  8017c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8017c5:	50                   	push   %eax
  8017c6:	e8 a7 ea ff ff       	call   800272 <vcprintf>
  8017cb:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8017ce:	83 ec 08             	sub    $0x8,%esp
  8017d1:	6a 00                	push   $0x0
  8017d3:	68 9c 21 80 00       	push   $0x80219c
  8017d8:	e8 95 ea ff ff       	call   800272 <vcprintf>
  8017dd:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8017e0:	e8 0e ea ff ff       	call   8001f3 <exit>

	// should not return here
	while (1) ;
  8017e5:	eb fe                	jmp    8017e5 <_panic+0x75>

008017e7 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
  8017ea:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8017ed:	a1 20 30 80 00       	mov    0x803020,%eax
  8017f2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8017f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fb:	39 c2                	cmp    %eax,%edx
  8017fd:	74 14                	je     801813 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8017ff:	83 ec 04             	sub    $0x4,%esp
  801802:	68 a0 21 80 00       	push   $0x8021a0
  801807:	6a 26                	push   $0x26
  801809:	68 ec 21 80 00       	push   $0x8021ec
  80180e:	e8 5d ff ff ff       	call   801770 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801813:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80181a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801821:	e9 c5 00 00 00       	jmp    8018eb <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801829:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	01 d0                	add    %edx,%eax
  801835:	8b 00                	mov    (%eax),%eax
  801837:	85 c0                	test   %eax,%eax
  801839:	75 08                	jne    801843 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80183b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80183e:	e9 a5 00 00 00       	jmp    8018e8 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801843:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80184a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801851:	eb 69                	jmp    8018bc <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801853:	a1 20 30 80 00       	mov    0x803020,%eax
  801858:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80185e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801861:	89 d0                	mov    %edx,%eax
  801863:	01 c0                	add    %eax,%eax
  801865:	01 d0                	add    %edx,%eax
  801867:	c1 e0 03             	shl    $0x3,%eax
  80186a:	01 c8                	add    %ecx,%eax
  80186c:	8a 40 04             	mov    0x4(%eax),%al
  80186f:	84 c0                	test   %al,%al
  801871:	75 46                	jne    8018b9 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801873:	a1 20 30 80 00       	mov    0x803020,%eax
  801878:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80187e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801881:	89 d0                	mov    %edx,%eax
  801883:	01 c0                	add    %eax,%eax
  801885:	01 d0                	add    %edx,%eax
  801887:	c1 e0 03             	shl    $0x3,%eax
  80188a:	01 c8                	add    %ecx,%eax
  80188c:	8b 00                	mov    (%eax),%eax
  80188e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801891:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801894:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801899:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80189b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	01 c8                	add    %ecx,%eax
  8018aa:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018ac:	39 c2                	cmp    %eax,%edx
  8018ae:	75 09                	jne    8018b9 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8018b0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8018b7:	eb 15                	jmp    8018ce <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018b9:	ff 45 e8             	incl   -0x18(%ebp)
  8018bc:	a1 20 30 80 00       	mov    0x803020,%eax
  8018c1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8018c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018ca:	39 c2                	cmp    %eax,%edx
  8018cc:	77 85                	ja     801853 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8018ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018d2:	75 14                	jne    8018e8 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8018d4:	83 ec 04             	sub    $0x4,%esp
  8018d7:	68 f8 21 80 00       	push   $0x8021f8
  8018dc:	6a 3a                	push   $0x3a
  8018de:	68 ec 21 80 00       	push   $0x8021ec
  8018e3:	e8 88 fe ff ff       	call   801770 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8018e8:	ff 45 f0             	incl   -0x10(%ebp)
  8018eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8018f1:	0f 8c 2f ff ff ff    	jl     801826 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8018f7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018fe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801905:	eb 26                	jmp    80192d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801907:	a1 20 30 80 00       	mov    0x803020,%eax
  80190c:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801912:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801915:	89 d0                	mov    %edx,%eax
  801917:	01 c0                	add    %eax,%eax
  801919:	01 d0                	add    %edx,%eax
  80191b:	c1 e0 03             	shl    $0x3,%eax
  80191e:	01 c8                	add    %ecx,%eax
  801920:	8a 40 04             	mov    0x4(%eax),%al
  801923:	3c 01                	cmp    $0x1,%al
  801925:	75 03                	jne    80192a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801927:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80192a:	ff 45 e0             	incl   -0x20(%ebp)
  80192d:	a1 20 30 80 00       	mov    0x803020,%eax
  801932:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801938:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80193b:	39 c2                	cmp    %eax,%edx
  80193d:	77 c8                	ja     801907 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80193f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801942:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801945:	74 14                	je     80195b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801947:	83 ec 04             	sub    $0x4,%esp
  80194a:	68 4c 22 80 00       	push   $0x80224c
  80194f:	6a 44                	push   $0x44
  801951:	68 ec 21 80 00       	push   $0x8021ec
  801956:	e8 15 fe ff ff       	call   801770 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80195b:	90                   	nop
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    
  80195e:	66 90                	xchg   %ax,%ax

00801960 <__udivdi3>:
  801960:	55                   	push   %ebp
  801961:	57                   	push   %edi
  801962:	56                   	push   %esi
  801963:	53                   	push   %ebx
  801964:	83 ec 1c             	sub    $0x1c,%esp
  801967:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80196b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80196f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801973:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801977:	89 ca                	mov    %ecx,%edx
  801979:	89 f8                	mov    %edi,%eax
  80197b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80197f:	85 f6                	test   %esi,%esi
  801981:	75 2d                	jne    8019b0 <__udivdi3+0x50>
  801983:	39 cf                	cmp    %ecx,%edi
  801985:	77 65                	ja     8019ec <__udivdi3+0x8c>
  801987:	89 fd                	mov    %edi,%ebp
  801989:	85 ff                	test   %edi,%edi
  80198b:	75 0b                	jne    801998 <__udivdi3+0x38>
  80198d:	b8 01 00 00 00       	mov    $0x1,%eax
  801992:	31 d2                	xor    %edx,%edx
  801994:	f7 f7                	div    %edi
  801996:	89 c5                	mov    %eax,%ebp
  801998:	31 d2                	xor    %edx,%edx
  80199a:	89 c8                	mov    %ecx,%eax
  80199c:	f7 f5                	div    %ebp
  80199e:	89 c1                	mov    %eax,%ecx
  8019a0:	89 d8                	mov    %ebx,%eax
  8019a2:	f7 f5                	div    %ebp
  8019a4:	89 cf                	mov    %ecx,%edi
  8019a6:	89 fa                	mov    %edi,%edx
  8019a8:	83 c4 1c             	add    $0x1c,%esp
  8019ab:	5b                   	pop    %ebx
  8019ac:	5e                   	pop    %esi
  8019ad:	5f                   	pop    %edi
  8019ae:	5d                   	pop    %ebp
  8019af:	c3                   	ret    
  8019b0:	39 ce                	cmp    %ecx,%esi
  8019b2:	77 28                	ja     8019dc <__udivdi3+0x7c>
  8019b4:	0f bd fe             	bsr    %esi,%edi
  8019b7:	83 f7 1f             	xor    $0x1f,%edi
  8019ba:	75 40                	jne    8019fc <__udivdi3+0x9c>
  8019bc:	39 ce                	cmp    %ecx,%esi
  8019be:	72 0a                	jb     8019ca <__udivdi3+0x6a>
  8019c0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019c4:	0f 87 9e 00 00 00    	ja     801a68 <__udivdi3+0x108>
  8019ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8019cf:	89 fa                	mov    %edi,%edx
  8019d1:	83 c4 1c             	add    $0x1c,%esp
  8019d4:	5b                   	pop    %ebx
  8019d5:	5e                   	pop    %esi
  8019d6:	5f                   	pop    %edi
  8019d7:	5d                   	pop    %ebp
  8019d8:	c3                   	ret    
  8019d9:	8d 76 00             	lea    0x0(%esi),%esi
  8019dc:	31 ff                	xor    %edi,%edi
  8019de:	31 c0                	xor    %eax,%eax
  8019e0:	89 fa                	mov    %edi,%edx
  8019e2:	83 c4 1c             	add    $0x1c,%esp
  8019e5:	5b                   	pop    %ebx
  8019e6:	5e                   	pop    %esi
  8019e7:	5f                   	pop    %edi
  8019e8:	5d                   	pop    %ebp
  8019e9:	c3                   	ret    
  8019ea:	66 90                	xchg   %ax,%ax
  8019ec:	89 d8                	mov    %ebx,%eax
  8019ee:	f7 f7                	div    %edi
  8019f0:	31 ff                	xor    %edi,%edi
  8019f2:	89 fa                	mov    %edi,%edx
  8019f4:	83 c4 1c             	add    $0x1c,%esp
  8019f7:	5b                   	pop    %ebx
  8019f8:	5e                   	pop    %esi
  8019f9:	5f                   	pop    %edi
  8019fa:	5d                   	pop    %ebp
  8019fb:	c3                   	ret    
  8019fc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a01:	89 eb                	mov    %ebp,%ebx
  801a03:	29 fb                	sub    %edi,%ebx
  801a05:	89 f9                	mov    %edi,%ecx
  801a07:	d3 e6                	shl    %cl,%esi
  801a09:	89 c5                	mov    %eax,%ebp
  801a0b:	88 d9                	mov    %bl,%cl
  801a0d:	d3 ed                	shr    %cl,%ebp
  801a0f:	89 e9                	mov    %ebp,%ecx
  801a11:	09 f1                	or     %esi,%ecx
  801a13:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a17:	89 f9                	mov    %edi,%ecx
  801a19:	d3 e0                	shl    %cl,%eax
  801a1b:	89 c5                	mov    %eax,%ebp
  801a1d:	89 d6                	mov    %edx,%esi
  801a1f:	88 d9                	mov    %bl,%cl
  801a21:	d3 ee                	shr    %cl,%esi
  801a23:	89 f9                	mov    %edi,%ecx
  801a25:	d3 e2                	shl    %cl,%edx
  801a27:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a2b:	88 d9                	mov    %bl,%cl
  801a2d:	d3 e8                	shr    %cl,%eax
  801a2f:	09 c2                	or     %eax,%edx
  801a31:	89 d0                	mov    %edx,%eax
  801a33:	89 f2                	mov    %esi,%edx
  801a35:	f7 74 24 0c          	divl   0xc(%esp)
  801a39:	89 d6                	mov    %edx,%esi
  801a3b:	89 c3                	mov    %eax,%ebx
  801a3d:	f7 e5                	mul    %ebp
  801a3f:	39 d6                	cmp    %edx,%esi
  801a41:	72 19                	jb     801a5c <__udivdi3+0xfc>
  801a43:	74 0b                	je     801a50 <__udivdi3+0xf0>
  801a45:	89 d8                	mov    %ebx,%eax
  801a47:	31 ff                	xor    %edi,%edi
  801a49:	e9 58 ff ff ff       	jmp    8019a6 <__udivdi3+0x46>
  801a4e:	66 90                	xchg   %ax,%ax
  801a50:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a54:	89 f9                	mov    %edi,%ecx
  801a56:	d3 e2                	shl    %cl,%edx
  801a58:	39 c2                	cmp    %eax,%edx
  801a5a:	73 e9                	jae    801a45 <__udivdi3+0xe5>
  801a5c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a5f:	31 ff                	xor    %edi,%edi
  801a61:	e9 40 ff ff ff       	jmp    8019a6 <__udivdi3+0x46>
  801a66:	66 90                	xchg   %ax,%ax
  801a68:	31 c0                	xor    %eax,%eax
  801a6a:	e9 37 ff ff ff       	jmp    8019a6 <__udivdi3+0x46>
  801a6f:	90                   	nop

00801a70 <__umoddi3>:
  801a70:	55                   	push   %ebp
  801a71:	57                   	push   %edi
  801a72:	56                   	push   %esi
  801a73:	53                   	push   %ebx
  801a74:	83 ec 1c             	sub    $0x1c,%esp
  801a77:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a7b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a83:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a8b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a8f:	89 f3                	mov    %esi,%ebx
  801a91:	89 fa                	mov    %edi,%edx
  801a93:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a97:	89 34 24             	mov    %esi,(%esp)
  801a9a:	85 c0                	test   %eax,%eax
  801a9c:	75 1a                	jne    801ab8 <__umoddi3+0x48>
  801a9e:	39 f7                	cmp    %esi,%edi
  801aa0:	0f 86 a2 00 00 00    	jbe    801b48 <__umoddi3+0xd8>
  801aa6:	89 c8                	mov    %ecx,%eax
  801aa8:	89 f2                	mov    %esi,%edx
  801aaa:	f7 f7                	div    %edi
  801aac:	89 d0                	mov    %edx,%eax
  801aae:	31 d2                	xor    %edx,%edx
  801ab0:	83 c4 1c             	add    $0x1c,%esp
  801ab3:	5b                   	pop    %ebx
  801ab4:	5e                   	pop    %esi
  801ab5:	5f                   	pop    %edi
  801ab6:	5d                   	pop    %ebp
  801ab7:	c3                   	ret    
  801ab8:	39 f0                	cmp    %esi,%eax
  801aba:	0f 87 ac 00 00 00    	ja     801b6c <__umoddi3+0xfc>
  801ac0:	0f bd e8             	bsr    %eax,%ebp
  801ac3:	83 f5 1f             	xor    $0x1f,%ebp
  801ac6:	0f 84 ac 00 00 00    	je     801b78 <__umoddi3+0x108>
  801acc:	bf 20 00 00 00       	mov    $0x20,%edi
  801ad1:	29 ef                	sub    %ebp,%edi
  801ad3:	89 fe                	mov    %edi,%esi
  801ad5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ad9:	89 e9                	mov    %ebp,%ecx
  801adb:	d3 e0                	shl    %cl,%eax
  801add:	89 d7                	mov    %edx,%edi
  801adf:	89 f1                	mov    %esi,%ecx
  801ae1:	d3 ef                	shr    %cl,%edi
  801ae3:	09 c7                	or     %eax,%edi
  801ae5:	89 e9                	mov    %ebp,%ecx
  801ae7:	d3 e2                	shl    %cl,%edx
  801ae9:	89 14 24             	mov    %edx,(%esp)
  801aec:	89 d8                	mov    %ebx,%eax
  801aee:	d3 e0                	shl    %cl,%eax
  801af0:	89 c2                	mov    %eax,%edx
  801af2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801af6:	d3 e0                	shl    %cl,%eax
  801af8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801afc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b00:	89 f1                	mov    %esi,%ecx
  801b02:	d3 e8                	shr    %cl,%eax
  801b04:	09 d0                	or     %edx,%eax
  801b06:	d3 eb                	shr    %cl,%ebx
  801b08:	89 da                	mov    %ebx,%edx
  801b0a:	f7 f7                	div    %edi
  801b0c:	89 d3                	mov    %edx,%ebx
  801b0e:	f7 24 24             	mull   (%esp)
  801b11:	89 c6                	mov    %eax,%esi
  801b13:	89 d1                	mov    %edx,%ecx
  801b15:	39 d3                	cmp    %edx,%ebx
  801b17:	0f 82 87 00 00 00    	jb     801ba4 <__umoddi3+0x134>
  801b1d:	0f 84 91 00 00 00    	je     801bb4 <__umoddi3+0x144>
  801b23:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b27:	29 f2                	sub    %esi,%edx
  801b29:	19 cb                	sbb    %ecx,%ebx
  801b2b:	89 d8                	mov    %ebx,%eax
  801b2d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b31:	d3 e0                	shl    %cl,%eax
  801b33:	89 e9                	mov    %ebp,%ecx
  801b35:	d3 ea                	shr    %cl,%edx
  801b37:	09 d0                	or     %edx,%eax
  801b39:	89 e9                	mov    %ebp,%ecx
  801b3b:	d3 eb                	shr    %cl,%ebx
  801b3d:	89 da                	mov    %ebx,%edx
  801b3f:	83 c4 1c             	add    $0x1c,%esp
  801b42:	5b                   	pop    %ebx
  801b43:	5e                   	pop    %esi
  801b44:	5f                   	pop    %edi
  801b45:	5d                   	pop    %ebp
  801b46:	c3                   	ret    
  801b47:	90                   	nop
  801b48:	89 fd                	mov    %edi,%ebp
  801b4a:	85 ff                	test   %edi,%edi
  801b4c:	75 0b                	jne    801b59 <__umoddi3+0xe9>
  801b4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b53:	31 d2                	xor    %edx,%edx
  801b55:	f7 f7                	div    %edi
  801b57:	89 c5                	mov    %eax,%ebp
  801b59:	89 f0                	mov    %esi,%eax
  801b5b:	31 d2                	xor    %edx,%edx
  801b5d:	f7 f5                	div    %ebp
  801b5f:	89 c8                	mov    %ecx,%eax
  801b61:	f7 f5                	div    %ebp
  801b63:	89 d0                	mov    %edx,%eax
  801b65:	e9 44 ff ff ff       	jmp    801aae <__umoddi3+0x3e>
  801b6a:	66 90                	xchg   %ax,%ax
  801b6c:	89 c8                	mov    %ecx,%eax
  801b6e:	89 f2                	mov    %esi,%edx
  801b70:	83 c4 1c             	add    $0x1c,%esp
  801b73:	5b                   	pop    %ebx
  801b74:	5e                   	pop    %esi
  801b75:	5f                   	pop    %edi
  801b76:	5d                   	pop    %ebp
  801b77:	c3                   	ret    
  801b78:	3b 04 24             	cmp    (%esp),%eax
  801b7b:	72 06                	jb     801b83 <__umoddi3+0x113>
  801b7d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b81:	77 0f                	ja     801b92 <__umoddi3+0x122>
  801b83:	89 f2                	mov    %esi,%edx
  801b85:	29 f9                	sub    %edi,%ecx
  801b87:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b8b:	89 14 24             	mov    %edx,(%esp)
  801b8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b92:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b96:	8b 14 24             	mov    (%esp),%edx
  801b99:	83 c4 1c             	add    $0x1c,%esp
  801b9c:	5b                   	pop    %ebx
  801b9d:	5e                   	pop    %esi
  801b9e:	5f                   	pop    %edi
  801b9f:	5d                   	pop    %ebp
  801ba0:	c3                   	ret    
  801ba1:	8d 76 00             	lea    0x0(%esi),%esi
  801ba4:	2b 04 24             	sub    (%esp),%eax
  801ba7:	19 fa                	sbb    %edi,%edx
  801ba9:	89 d1                	mov    %edx,%ecx
  801bab:	89 c6                	mov    %eax,%esi
  801bad:	e9 71 ff ff ff       	jmp    801b23 <__umoddi3+0xb3>
  801bb2:	66 90                	xchg   %ax,%ax
  801bb4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bb8:	72 ea                	jb     801ba4 <__umoddi3+0x134>
  801bba:	89 d9                	mov    %ebx,%ecx
  801bbc:	e9 62 ff ff ff       	jmp    801b23 <__umoddi3+0xb3>

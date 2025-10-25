
obj/user/fos_input:     file format elf32-i386


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
  800031:	e8 a5 00 00 00       	call   8000db <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void
_main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 04 00 00    	sub    $0x418,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int i2=0;
  800048:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	char buff1[512];
	char buff2[512];


	atomic_readline("Please enter first number :", buff1);
  80004f:	83 ec 08             	sub    $0x8,%esp
  800052:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800058:	50                   	push   %eax
  800059:	68 60 1f 80 00       	push   $0x801f60
  80005e:	e8 e0 0a 00 00       	call   800b43 <atomic_readline>
  800063:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  800066:	83 ec 04             	sub    $0x4,%esp
  800069:	6a 0a                	push   $0xa
  80006b:	6a 00                	push   $0x0
  80006d:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800073:	50                   	push   %eax
  800074:	e8 e2 0f 00 00       	call   80105b <strtol>
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	//sleep
	env_sleep(2800);
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	68 f0 0a 00 00       	push   $0xaf0
  800087:	e8 76 19 00 00       	call   801a02 <env_sleep>
  80008c:	83 c4 10             	add    $0x10,%esp

	atomic_readline("Please enter second number :", buff2);
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  800098:	50                   	push   %eax
  800099:	68 7c 1f 80 00       	push   $0x801f7c
  80009e:	e8 a0 0a 00 00       	call   800b43 <atomic_readline>
  8000a3:	83 c4 10             	add    $0x10,%esp
	
	i2 = strtol(buff2, NULL, 10);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 0a                	push   $0xa
  8000ab:	6a 00                	push   $0x0
  8000ad:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  8000b3:	50                   	push   %eax
  8000b4:	e8 a2 0f 00 00       	call   80105b <strtol>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
  8000bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c5:	01 d0                	add    %edx,%eax
  8000c7:	83 ec 08             	sub    $0x8,%esp
  8000ca:	50                   	push   %eax
  8000cb:	68 99 1f 80 00       	push   $0x801f99
  8000d0:	e8 08 03 00 00       	call   8003dd <atomic_cprintf>
  8000d5:	83 c4 10             	add    $0x10,%esp
	return;	
  8000d8:	90                   	nop
}
  8000d9:	c9                   	leave  
  8000da:	c3                   	ret    

008000db <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	57                   	push   %edi
  8000df:	56                   	push   %esi
  8000e0:	53                   	push   %ebx
  8000e1:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000e4:	e8 57 16 00 00       	call   801740 <sys_getenvindex>
  8000e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000ef:	89 d0                	mov    %edx,%eax
  8000f1:	c1 e0 02             	shl    $0x2,%eax
  8000f4:	01 d0                	add    %edx,%eax
  8000f6:	c1 e0 03             	shl    $0x3,%eax
  8000f9:	01 d0                	add    %edx,%eax
  8000fb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800102:	01 d0                	add    %edx,%eax
  800104:	c1 e0 02             	shl    $0x2,%eax
  800107:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80010c:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800111:	a1 20 30 80 00       	mov    0x803020,%eax
  800116:	8a 40 20             	mov    0x20(%eax),%al
  800119:	84 c0                	test   %al,%al
  80011b:	74 0d                	je     80012a <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80011d:	a1 20 30 80 00       	mov    0x803020,%eax
  800122:	83 c0 20             	add    $0x20,%eax
  800125:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80012e:	7e 0a                	jle    80013a <libmain+0x5f>
		binaryname = argv[0];
  800130:	8b 45 0c             	mov    0xc(%ebp),%eax
  800133:	8b 00                	mov    (%eax),%eax
  800135:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80013a:	83 ec 08             	sub    $0x8,%esp
  80013d:	ff 75 0c             	pushl  0xc(%ebp)
  800140:	ff 75 08             	pushl  0x8(%ebp)
  800143:	e8 f0 fe ff ff       	call   800038 <_main>
  800148:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80014b:	a1 00 30 80 00       	mov    0x803000,%eax
  800150:	85 c0                	test   %eax,%eax
  800152:	0f 84 01 01 00 00    	je     800259 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800158:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80015e:	bb ac 20 80 00       	mov    $0x8020ac,%ebx
  800163:	ba 0e 00 00 00       	mov    $0xe,%edx
  800168:	89 c7                	mov    %eax,%edi
  80016a:	89 de                	mov    %ebx,%esi
  80016c:	89 d1                	mov    %edx,%ecx
  80016e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800170:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800173:	b9 56 00 00 00       	mov    $0x56,%ecx
  800178:	b0 00                	mov    $0x0,%al
  80017a:	89 d7                	mov    %edx,%edi
  80017c:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80017e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800185:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800188:	83 ec 08             	sub    $0x8,%esp
  80018b:	50                   	push   %eax
  80018c:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800192:	50                   	push   %eax
  800193:	e8 de 17 00 00       	call   801976 <sys_utilities>
  800198:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80019b:	e8 27 13 00 00       	call   8014c7 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001a0:	83 ec 0c             	sub    $0xc,%esp
  8001a3:	68 cc 1f 80 00       	push   $0x801fcc
  8001a8:	e8 be 01 00 00       	call   80036b <cprintf>
  8001ad:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001b3:	85 c0                	test   %eax,%eax
  8001b5:	74 18                	je     8001cf <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001b7:	e8 d8 17 00 00       	call   801994 <sys_get_optimal_num_faults>
  8001bc:	83 ec 08             	sub    $0x8,%esp
  8001bf:	50                   	push   %eax
  8001c0:	68 f4 1f 80 00       	push   $0x801ff4
  8001c5:	e8 a1 01 00 00       	call   80036b <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
  8001cd:	eb 59                	jmp    800228 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001cf:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d4:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8001da:	a1 20 30 80 00       	mov    0x803020,%eax
  8001df:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8001e5:	83 ec 04             	sub    $0x4,%esp
  8001e8:	52                   	push   %edx
  8001e9:	50                   	push   %eax
  8001ea:	68 18 20 80 00       	push   $0x802018
  8001ef:	e8 77 01 00 00       	call   80036b <cprintf>
  8001f4:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f7:	a1 20 30 80 00       	mov    0x803020,%eax
  8001fc:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800202:	a1 20 30 80 00       	mov    0x803020,%eax
  800207:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80020d:	a1 20 30 80 00       	mov    0x803020,%eax
  800212:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800218:	51                   	push   %ecx
  800219:	52                   	push   %edx
  80021a:	50                   	push   %eax
  80021b:	68 40 20 80 00       	push   $0x802040
  800220:	e8 46 01 00 00       	call   80036b <cprintf>
  800225:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800228:	a1 20 30 80 00       	mov    0x803020,%eax
  80022d:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800233:	83 ec 08             	sub    $0x8,%esp
  800236:	50                   	push   %eax
  800237:	68 98 20 80 00       	push   $0x802098
  80023c:	e8 2a 01 00 00       	call   80036b <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 cc 1f 80 00       	push   $0x801fcc
  80024c:	e8 1a 01 00 00       	call   80036b <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800254:	e8 88 12 00 00       	call   8014e1 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800259:	e8 1f 00 00 00       	call   80027d <exit>
}
  80025e:	90                   	nop
  80025f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800262:	5b                   	pop    %ebx
  800263:	5e                   	pop    %esi
  800264:	5f                   	pop    %edi
  800265:	5d                   	pop    %ebp
  800266:	c3                   	ret    

00800267 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80026d:	83 ec 0c             	sub    $0xc,%esp
  800270:	6a 00                	push   $0x0
  800272:	e8 95 14 00 00       	call   80170c <sys_destroy_env>
  800277:	83 c4 10             	add    $0x10,%esp
}
  80027a:	90                   	nop
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <exit>:

void
exit(void)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800283:	e8 ea 14 00 00       	call   801772 <sys_exit_env>
}
  800288:	90                   	nop
  800289:	c9                   	leave  
  80028a:	c3                   	ret    

0080028b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80028b:	55                   	push   %ebp
  80028c:	89 e5                	mov    %esp,%ebp
  80028e:	53                   	push   %ebx
  80028f:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800292:	8b 45 0c             	mov    0xc(%ebp),%eax
  800295:	8b 00                	mov    (%eax),%eax
  800297:	8d 48 01             	lea    0x1(%eax),%ecx
  80029a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80029d:	89 0a                	mov    %ecx,(%edx)
  80029f:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a2:	88 d1                	mov    %dl,%cl
  8002a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ae:	8b 00                	mov    (%eax),%eax
  8002b0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002b5:	75 30                	jne    8002e7 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8002b7:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8002bd:	a0 44 30 80 00       	mov    0x803044,%al
  8002c2:	0f b6 c0             	movzbl %al,%eax
  8002c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c8:	8b 09                	mov    (%ecx),%ecx
  8002ca:	89 cb                	mov    %ecx,%ebx
  8002cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002cf:	83 c1 08             	add    $0x8,%ecx
  8002d2:	52                   	push   %edx
  8002d3:	50                   	push   %eax
  8002d4:	53                   	push   %ebx
  8002d5:	51                   	push   %ecx
  8002d6:	e8 a8 11 00 00       	call   801483 <sys_cputs>
  8002db:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ea:	8b 40 04             	mov    0x4(%eax),%eax
  8002ed:	8d 50 01             	lea    0x1(%eax),%edx
  8002f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002f6:	90                   	nop
  8002f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002fa:	c9                   	leave  
  8002fb:	c3                   	ret    

008002fc <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002fc:	55                   	push   %ebp
  8002fd:	89 e5                	mov    %esp,%ebp
  8002ff:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800305:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80030c:	00 00 00 
	b.cnt = 0;
  80030f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800316:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800319:	ff 75 0c             	pushl  0xc(%ebp)
  80031c:	ff 75 08             	pushl  0x8(%ebp)
  80031f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800325:	50                   	push   %eax
  800326:	68 8b 02 80 00       	push   $0x80028b
  80032b:	e8 5a 02 00 00       	call   80058a <vprintfmt>
  800330:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800333:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  800339:	a0 44 30 80 00       	mov    0x803044,%al
  80033e:	0f b6 c0             	movzbl %al,%eax
  800341:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800347:	52                   	push   %edx
  800348:	50                   	push   %eax
  800349:	51                   	push   %ecx
  80034a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800350:	83 c0 08             	add    $0x8,%eax
  800353:	50                   	push   %eax
  800354:	e8 2a 11 00 00       	call   801483 <sys_cputs>
  800359:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80035c:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800363:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800369:	c9                   	leave  
  80036a:	c3                   	ret    

0080036b <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80036b:	55                   	push   %ebp
  80036c:	89 e5                	mov    %esp,%ebp
  80036e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800371:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800378:	8d 45 0c             	lea    0xc(%ebp),%eax
  80037b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80037e:	8b 45 08             	mov    0x8(%ebp),%eax
  800381:	83 ec 08             	sub    $0x8,%esp
  800384:	ff 75 f4             	pushl  -0xc(%ebp)
  800387:	50                   	push   %eax
  800388:	e8 6f ff ff ff       	call   8002fc <vcprintf>
  80038d:	83 c4 10             	add    $0x10,%esp
  800390:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800393:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800396:	c9                   	leave  
  800397:	c3                   	ret    

00800398 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800398:	55                   	push   %ebp
  800399:	89 e5                	mov    %esp,%ebp
  80039b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80039e:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8003a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a8:	c1 e0 08             	shl    $0x8,%eax
  8003ab:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  8003b0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003b3:	83 c0 04             	add    $0x4,%eax
  8003b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003bc:	83 ec 08             	sub    $0x8,%esp
  8003bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c2:	50                   	push   %eax
  8003c3:	e8 34 ff ff ff       	call   8002fc <vcprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8003ce:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  8003d5:	07 00 00 

	return cnt;
  8003d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003db:	c9                   	leave  
  8003dc:	c3                   	ret    

008003dd <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003dd:	55                   	push   %ebp
  8003de:	89 e5                	mov    %esp,%ebp
  8003e0:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003e3:	e8 df 10 00 00       	call   8014c7 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8003e8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8003ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f1:	83 ec 08             	sub    $0x8,%esp
  8003f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8003f7:	50                   	push   %eax
  8003f8:	e8 ff fe ff ff       	call   8002fc <vcprintf>
  8003fd:	83 c4 10             	add    $0x10,%esp
  800400:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800403:	e8 d9 10 00 00       	call   8014e1 <sys_unlock_cons>
	return cnt;
  800408:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80040b:	c9                   	leave  
  80040c:	c3                   	ret    

0080040d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80040d:	55                   	push   %ebp
  80040e:	89 e5                	mov    %esp,%ebp
  800410:	53                   	push   %ebx
  800411:	83 ec 14             	sub    $0x14,%esp
  800414:	8b 45 10             	mov    0x10(%ebp),%eax
  800417:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80041a:	8b 45 14             	mov    0x14(%ebp),%eax
  80041d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800420:	8b 45 18             	mov    0x18(%ebp),%eax
  800423:	ba 00 00 00 00       	mov    $0x0,%edx
  800428:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80042b:	77 55                	ja     800482 <printnum+0x75>
  80042d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800430:	72 05                	jb     800437 <printnum+0x2a>
  800432:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800435:	77 4b                	ja     800482 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800437:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80043a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80043d:	8b 45 18             	mov    0x18(%ebp),%eax
  800440:	ba 00 00 00 00       	mov    $0x0,%edx
  800445:	52                   	push   %edx
  800446:	50                   	push   %eax
  800447:	ff 75 f4             	pushl  -0xc(%ebp)
  80044a:	ff 75 f0             	pushl  -0x10(%ebp)
  80044d:	e8 9a 18 00 00       	call   801cec <__udivdi3>
  800452:	83 c4 10             	add    $0x10,%esp
  800455:	83 ec 04             	sub    $0x4,%esp
  800458:	ff 75 20             	pushl  0x20(%ebp)
  80045b:	53                   	push   %ebx
  80045c:	ff 75 18             	pushl  0x18(%ebp)
  80045f:	52                   	push   %edx
  800460:	50                   	push   %eax
  800461:	ff 75 0c             	pushl  0xc(%ebp)
  800464:	ff 75 08             	pushl  0x8(%ebp)
  800467:	e8 a1 ff ff ff       	call   80040d <printnum>
  80046c:	83 c4 20             	add    $0x20,%esp
  80046f:	eb 1a                	jmp    80048b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800471:	83 ec 08             	sub    $0x8,%esp
  800474:	ff 75 0c             	pushl  0xc(%ebp)
  800477:	ff 75 20             	pushl  0x20(%ebp)
  80047a:	8b 45 08             	mov    0x8(%ebp),%eax
  80047d:	ff d0                	call   *%eax
  80047f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800482:	ff 4d 1c             	decl   0x1c(%ebp)
  800485:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800489:	7f e6                	jg     800471 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80048b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80048e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800493:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800496:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800499:	53                   	push   %ebx
  80049a:	51                   	push   %ecx
  80049b:	52                   	push   %edx
  80049c:	50                   	push   %eax
  80049d:	e8 5a 19 00 00       	call   801dfc <__umoddi3>
  8004a2:	83 c4 10             	add    $0x10,%esp
  8004a5:	05 34 23 80 00       	add    $0x802334,%eax
  8004aa:	8a 00                	mov    (%eax),%al
  8004ac:	0f be c0             	movsbl %al,%eax
  8004af:	83 ec 08             	sub    $0x8,%esp
  8004b2:	ff 75 0c             	pushl  0xc(%ebp)
  8004b5:	50                   	push   %eax
  8004b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b9:	ff d0                	call   *%eax
  8004bb:	83 c4 10             	add    $0x10,%esp
}
  8004be:	90                   	nop
  8004bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004c2:	c9                   	leave  
  8004c3:	c3                   	ret    

008004c4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004c4:	55                   	push   %ebp
  8004c5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004c7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004cb:	7e 1c                	jle    8004e9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d0:	8b 00                	mov    (%eax),%eax
  8004d2:	8d 50 08             	lea    0x8(%eax),%edx
  8004d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d8:	89 10                	mov    %edx,(%eax)
  8004da:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dd:	8b 00                	mov    (%eax),%eax
  8004df:	83 e8 08             	sub    $0x8,%eax
  8004e2:	8b 50 04             	mov    0x4(%eax),%edx
  8004e5:	8b 00                	mov    (%eax),%eax
  8004e7:	eb 40                	jmp    800529 <getuint+0x65>
	else if (lflag)
  8004e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004ed:	74 1e                	je     80050d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f2:	8b 00                	mov    (%eax),%eax
  8004f4:	8d 50 04             	lea    0x4(%eax),%edx
  8004f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fa:	89 10                	mov    %edx,(%eax)
  8004fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ff:	8b 00                	mov    (%eax),%eax
  800501:	83 e8 04             	sub    $0x4,%eax
  800504:	8b 00                	mov    (%eax),%eax
  800506:	ba 00 00 00 00       	mov    $0x0,%edx
  80050b:	eb 1c                	jmp    800529 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	8d 50 04             	lea    0x4(%eax),%edx
  800515:	8b 45 08             	mov    0x8(%ebp),%eax
  800518:	89 10                	mov    %edx,(%eax)
  80051a:	8b 45 08             	mov    0x8(%ebp),%eax
  80051d:	8b 00                	mov    (%eax),%eax
  80051f:	83 e8 04             	sub    $0x4,%eax
  800522:	8b 00                	mov    (%eax),%eax
  800524:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800529:	5d                   	pop    %ebp
  80052a:	c3                   	ret    

0080052b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80052b:	55                   	push   %ebp
  80052c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80052e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800532:	7e 1c                	jle    800550 <getint+0x25>
		return va_arg(*ap, long long);
  800534:	8b 45 08             	mov    0x8(%ebp),%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	8d 50 08             	lea    0x8(%eax),%edx
  80053c:	8b 45 08             	mov    0x8(%ebp),%eax
  80053f:	89 10                	mov    %edx,(%eax)
  800541:	8b 45 08             	mov    0x8(%ebp),%eax
  800544:	8b 00                	mov    (%eax),%eax
  800546:	83 e8 08             	sub    $0x8,%eax
  800549:	8b 50 04             	mov    0x4(%eax),%edx
  80054c:	8b 00                	mov    (%eax),%eax
  80054e:	eb 38                	jmp    800588 <getint+0x5d>
	else if (lflag)
  800550:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800554:	74 1a                	je     800570 <getint+0x45>
		return va_arg(*ap, long);
  800556:	8b 45 08             	mov    0x8(%ebp),%eax
  800559:	8b 00                	mov    (%eax),%eax
  80055b:	8d 50 04             	lea    0x4(%eax),%edx
  80055e:	8b 45 08             	mov    0x8(%ebp),%eax
  800561:	89 10                	mov    %edx,(%eax)
  800563:	8b 45 08             	mov    0x8(%ebp),%eax
  800566:	8b 00                	mov    (%eax),%eax
  800568:	83 e8 04             	sub    $0x4,%eax
  80056b:	8b 00                	mov    (%eax),%eax
  80056d:	99                   	cltd   
  80056e:	eb 18                	jmp    800588 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800570:	8b 45 08             	mov    0x8(%ebp),%eax
  800573:	8b 00                	mov    (%eax),%eax
  800575:	8d 50 04             	lea    0x4(%eax),%edx
  800578:	8b 45 08             	mov    0x8(%ebp),%eax
  80057b:	89 10                	mov    %edx,(%eax)
  80057d:	8b 45 08             	mov    0x8(%ebp),%eax
  800580:	8b 00                	mov    (%eax),%eax
  800582:	83 e8 04             	sub    $0x4,%eax
  800585:	8b 00                	mov    (%eax),%eax
  800587:	99                   	cltd   
}
  800588:	5d                   	pop    %ebp
  800589:	c3                   	ret    

0080058a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80058a:	55                   	push   %ebp
  80058b:	89 e5                	mov    %esp,%ebp
  80058d:	56                   	push   %esi
  80058e:	53                   	push   %ebx
  80058f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800592:	eb 17                	jmp    8005ab <vprintfmt+0x21>
			if (ch == '\0')
  800594:	85 db                	test   %ebx,%ebx
  800596:	0f 84 c1 03 00 00    	je     80095d <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80059c:	83 ec 08             	sub    $0x8,%esp
  80059f:	ff 75 0c             	pushl  0xc(%ebp)
  8005a2:	53                   	push   %ebx
  8005a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a6:	ff d0                	call   *%eax
  8005a8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ae:	8d 50 01             	lea    0x1(%eax),%edx
  8005b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8005b4:	8a 00                	mov    (%eax),%al
  8005b6:	0f b6 d8             	movzbl %al,%ebx
  8005b9:	83 fb 25             	cmp    $0x25,%ebx
  8005bc:	75 d6                	jne    800594 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005be:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005c2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005c9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005d0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005d7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005de:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e1:	8d 50 01             	lea    0x1(%eax),%edx
  8005e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8005e7:	8a 00                	mov    (%eax),%al
  8005e9:	0f b6 d8             	movzbl %al,%ebx
  8005ec:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005ef:	83 f8 5b             	cmp    $0x5b,%eax
  8005f2:	0f 87 3d 03 00 00    	ja     800935 <vprintfmt+0x3ab>
  8005f8:	8b 04 85 58 23 80 00 	mov    0x802358(,%eax,4),%eax
  8005ff:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800601:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800605:	eb d7                	jmp    8005de <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800607:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80060b:	eb d1                	jmp    8005de <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80060d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800614:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800617:	89 d0                	mov    %edx,%eax
  800619:	c1 e0 02             	shl    $0x2,%eax
  80061c:	01 d0                	add    %edx,%eax
  80061e:	01 c0                	add    %eax,%eax
  800620:	01 d8                	add    %ebx,%eax
  800622:	83 e8 30             	sub    $0x30,%eax
  800625:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800628:	8b 45 10             	mov    0x10(%ebp),%eax
  80062b:	8a 00                	mov    (%eax),%al
  80062d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800630:	83 fb 2f             	cmp    $0x2f,%ebx
  800633:	7e 3e                	jle    800673 <vprintfmt+0xe9>
  800635:	83 fb 39             	cmp    $0x39,%ebx
  800638:	7f 39                	jg     800673 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80063a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80063d:	eb d5                	jmp    800614 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	83 c0 04             	add    $0x4,%eax
  800645:	89 45 14             	mov    %eax,0x14(%ebp)
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	83 e8 04             	sub    $0x4,%eax
  80064e:	8b 00                	mov    (%eax),%eax
  800650:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800653:	eb 1f                	jmp    800674 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800655:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800659:	79 83                	jns    8005de <vprintfmt+0x54>
				width = 0;
  80065b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800662:	e9 77 ff ff ff       	jmp    8005de <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800667:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80066e:	e9 6b ff ff ff       	jmp    8005de <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800673:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800674:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800678:	0f 89 60 ff ff ff    	jns    8005de <vprintfmt+0x54>
				width = precision, precision = -1;
  80067e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800681:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800684:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80068b:	e9 4e ff ff ff       	jmp    8005de <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800690:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800693:	e9 46 ff ff ff       	jmp    8005de <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	83 c0 04             	add    $0x4,%eax
  80069e:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	83 e8 04             	sub    $0x4,%eax
  8006a7:	8b 00                	mov    (%eax),%eax
  8006a9:	83 ec 08             	sub    $0x8,%esp
  8006ac:	ff 75 0c             	pushl  0xc(%ebp)
  8006af:	50                   	push   %eax
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	ff d0                	call   *%eax
  8006b5:	83 c4 10             	add    $0x10,%esp
			break;
  8006b8:	e9 9b 02 00 00       	jmp    800958 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c0:	83 c0 04             	add    $0x4,%eax
  8006c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c9:	83 e8 04             	sub    $0x4,%eax
  8006cc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006ce:	85 db                	test   %ebx,%ebx
  8006d0:	79 02                	jns    8006d4 <vprintfmt+0x14a>
				err = -err;
  8006d2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006d4:	83 fb 64             	cmp    $0x64,%ebx
  8006d7:	7f 0b                	jg     8006e4 <vprintfmt+0x15a>
  8006d9:	8b 34 9d a0 21 80 00 	mov    0x8021a0(,%ebx,4),%esi
  8006e0:	85 f6                	test   %esi,%esi
  8006e2:	75 19                	jne    8006fd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006e4:	53                   	push   %ebx
  8006e5:	68 45 23 80 00       	push   $0x802345
  8006ea:	ff 75 0c             	pushl  0xc(%ebp)
  8006ed:	ff 75 08             	pushl  0x8(%ebp)
  8006f0:	e8 70 02 00 00       	call   800965 <printfmt>
  8006f5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006f8:	e9 5b 02 00 00       	jmp    800958 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006fd:	56                   	push   %esi
  8006fe:	68 4e 23 80 00       	push   $0x80234e
  800703:	ff 75 0c             	pushl  0xc(%ebp)
  800706:	ff 75 08             	pushl  0x8(%ebp)
  800709:	e8 57 02 00 00       	call   800965 <printfmt>
  80070e:	83 c4 10             	add    $0x10,%esp
			break;
  800711:	e9 42 02 00 00       	jmp    800958 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800716:	8b 45 14             	mov    0x14(%ebp),%eax
  800719:	83 c0 04             	add    $0x4,%eax
  80071c:	89 45 14             	mov    %eax,0x14(%ebp)
  80071f:	8b 45 14             	mov    0x14(%ebp),%eax
  800722:	83 e8 04             	sub    $0x4,%eax
  800725:	8b 30                	mov    (%eax),%esi
  800727:	85 f6                	test   %esi,%esi
  800729:	75 05                	jne    800730 <vprintfmt+0x1a6>
				p = "(null)";
  80072b:	be 51 23 80 00       	mov    $0x802351,%esi
			if (width > 0 && padc != '-')
  800730:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800734:	7e 6d                	jle    8007a3 <vprintfmt+0x219>
  800736:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80073a:	74 67                	je     8007a3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80073c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80073f:	83 ec 08             	sub    $0x8,%esp
  800742:	50                   	push   %eax
  800743:	56                   	push   %esi
  800744:	e8 26 05 00 00       	call   800c6f <strnlen>
  800749:	83 c4 10             	add    $0x10,%esp
  80074c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80074f:	eb 16                	jmp    800767 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800751:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800755:	83 ec 08             	sub    $0x8,%esp
  800758:	ff 75 0c             	pushl  0xc(%ebp)
  80075b:	50                   	push   %eax
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	ff d0                	call   *%eax
  800761:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800764:	ff 4d e4             	decl   -0x1c(%ebp)
  800767:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80076b:	7f e4                	jg     800751 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80076d:	eb 34                	jmp    8007a3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80076f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800773:	74 1c                	je     800791 <vprintfmt+0x207>
  800775:	83 fb 1f             	cmp    $0x1f,%ebx
  800778:	7e 05                	jle    80077f <vprintfmt+0x1f5>
  80077a:	83 fb 7e             	cmp    $0x7e,%ebx
  80077d:	7e 12                	jle    800791 <vprintfmt+0x207>
					putch('?', putdat);
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	ff 75 0c             	pushl  0xc(%ebp)
  800785:	6a 3f                	push   $0x3f
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	ff d0                	call   *%eax
  80078c:	83 c4 10             	add    $0x10,%esp
  80078f:	eb 0f                	jmp    8007a0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800791:	83 ec 08             	sub    $0x8,%esp
  800794:	ff 75 0c             	pushl  0xc(%ebp)
  800797:	53                   	push   %ebx
  800798:	8b 45 08             	mov    0x8(%ebp),%eax
  80079b:	ff d0                	call   *%eax
  80079d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007a0:	ff 4d e4             	decl   -0x1c(%ebp)
  8007a3:	89 f0                	mov    %esi,%eax
  8007a5:	8d 70 01             	lea    0x1(%eax),%esi
  8007a8:	8a 00                	mov    (%eax),%al
  8007aa:	0f be d8             	movsbl %al,%ebx
  8007ad:	85 db                	test   %ebx,%ebx
  8007af:	74 24                	je     8007d5 <vprintfmt+0x24b>
  8007b1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007b5:	78 b8                	js     80076f <vprintfmt+0x1e5>
  8007b7:	ff 4d e0             	decl   -0x20(%ebp)
  8007ba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007be:	79 af                	jns    80076f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007c0:	eb 13                	jmp    8007d5 <vprintfmt+0x24b>
				putch(' ', putdat);
  8007c2:	83 ec 08             	sub    $0x8,%esp
  8007c5:	ff 75 0c             	pushl  0xc(%ebp)
  8007c8:	6a 20                	push   $0x20
  8007ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cd:	ff d0                	call   *%eax
  8007cf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007d2:	ff 4d e4             	decl   -0x1c(%ebp)
  8007d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d9:	7f e7                	jg     8007c2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007db:	e9 78 01 00 00       	jmp    800958 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007e0:	83 ec 08             	sub    $0x8,%esp
  8007e3:	ff 75 e8             	pushl  -0x18(%ebp)
  8007e6:	8d 45 14             	lea    0x14(%ebp),%eax
  8007e9:	50                   	push   %eax
  8007ea:	e8 3c fd ff ff       	call   80052b <getint>
  8007ef:	83 c4 10             	add    $0x10,%esp
  8007f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007fe:	85 d2                	test   %edx,%edx
  800800:	79 23                	jns    800825 <vprintfmt+0x29b>
				putch('-', putdat);
  800802:	83 ec 08             	sub    $0x8,%esp
  800805:	ff 75 0c             	pushl  0xc(%ebp)
  800808:	6a 2d                	push   $0x2d
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	ff d0                	call   *%eax
  80080f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800812:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800815:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800818:	f7 d8                	neg    %eax
  80081a:	83 d2 00             	adc    $0x0,%edx
  80081d:	f7 da                	neg    %edx
  80081f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800822:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800825:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80082c:	e9 bc 00 00 00       	jmp    8008ed <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800831:	83 ec 08             	sub    $0x8,%esp
  800834:	ff 75 e8             	pushl  -0x18(%ebp)
  800837:	8d 45 14             	lea    0x14(%ebp),%eax
  80083a:	50                   	push   %eax
  80083b:	e8 84 fc ff ff       	call   8004c4 <getuint>
  800840:	83 c4 10             	add    $0x10,%esp
  800843:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800846:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800849:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800850:	e9 98 00 00 00       	jmp    8008ed <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800855:	83 ec 08             	sub    $0x8,%esp
  800858:	ff 75 0c             	pushl  0xc(%ebp)
  80085b:	6a 58                	push   $0x58
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	ff d0                	call   *%eax
  800862:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800865:	83 ec 08             	sub    $0x8,%esp
  800868:	ff 75 0c             	pushl  0xc(%ebp)
  80086b:	6a 58                	push   $0x58
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	ff d0                	call   *%eax
  800872:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800875:	83 ec 08             	sub    $0x8,%esp
  800878:	ff 75 0c             	pushl  0xc(%ebp)
  80087b:	6a 58                	push   $0x58
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	ff d0                	call   *%eax
  800882:	83 c4 10             	add    $0x10,%esp
			break;
  800885:	e9 ce 00 00 00       	jmp    800958 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80088a:	83 ec 08             	sub    $0x8,%esp
  80088d:	ff 75 0c             	pushl  0xc(%ebp)
  800890:	6a 30                	push   $0x30
  800892:	8b 45 08             	mov    0x8(%ebp),%eax
  800895:	ff d0                	call   *%eax
  800897:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80089a:	83 ec 08             	sub    $0x8,%esp
  80089d:	ff 75 0c             	pushl  0xc(%ebp)
  8008a0:	6a 78                	push   $0x78
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	ff d0                	call   *%eax
  8008a7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	83 c0 04             	add    $0x4,%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	83 e8 04             	sub    $0x4,%eax
  8008b9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008c5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008cc:	eb 1f                	jmp    8008ed <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008ce:	83 ec 08             	sub    $0x8,%esp
  8008d1:	ff 75 e8             	pushl  -0x18(%ebp)
  8008d4:	8d 45 14             	lea    0x14(%ebp),%eax
  8008d7:	50                   	push   %eax
  8008d8:	e8 e7 fb ff ff       	call   8004c4 <getuint>
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008e6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008ed:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	52                   	push   %edx
  8008f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008fb:	50                   	push   %eax
  8008fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ff:	ff 75 f0             	pushl  -0x10(%ebp)
  800902:	ff 75 0c             	pushl  0xc(%ebp)
  800905:	ff 75 08             	pushl  0x8(%ebp)
  800908:	e8 00 fb ff ff       	call   80040d <printnum>
  80090d:	83 c4 20             	add    $0x20,%esp
			break;
  800910:	eb 46                	jmp    800958 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800912:	83 ec 08             	sub    $0x8,%esp
  800915:	ff 75 0c             	pushl  0xc(%ebp)
  800918:	53                   	push   %ebx
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	ff d0                	call   *%eax
  80091e:	83 c4 10             	add    $0x10,%esp
			break;
  800921:	eb 35                	jmp    800958 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800923:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  80092a:	eb 2c                	jmp    800958 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80092c:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800933:	eb 23                	jmp    800958 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800935:	83 ec 08             	sub    $0x8,%esp
  800938:	ff 75 0c             	pushl  0xc(%ebp)
  80093b:	6a 25                	push   $0x25
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	ff d0                	call   *%eax
  800942:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800945:	ff 4d 10             	decl   0x10(%ebp)
  800948:	eb 03                	jmp    80094d <vprintfmt+0x3c3>
  80094a:	ff 4d 10             	decl   0x10(%ebp)
  80094d:	8b 45 10             	mov    0x10(%ebp),%eax
  800950:	48                   	dec    %eax
  800951:	8a 00                	mov    (%eax),%al
  800953:	3c 25                	cmp    $0x25,%al
  800955:	75 f3                	jne    80094a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800957:	90                   	nop
		}
	}
  800958:	e9 35 fc ff ff       	jmp    800592 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80095d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80095e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800961:	5b                   	pop    %ebx
  800962:	5e                   	pop    %esi
  800963:	5d                   	pop    %ebp
  800964:	c3                   	ret    

00800965 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
  800968:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80096b:	8d 45 10             	lea    0x10(%ebp),%eax
  80096e:	83 c0 04             	add    $0x4,%eax
  800971:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800974:	8b 45 10             	mov    0x10(%ebp),%eax
  800977:	ff 75 f4             	pushl  -0xc(%ebp)
  80097a:	50                   	push   %eax
  80097b:	ff 75 0c             	pushl  0xc(%ebp)
  80097e:	ff 75 08             	pushl  0x8(%ebp)
  800981:	e8 04 fc ff ff       	call   80058a <vprintfmt>
  800986:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800989:	90                   	nop
  80098a:	c9                   	leave  
  80098b:	c3                   	ret    

0080098c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80098f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800992:	8b 40 08             	mov    0x8(%eax),%eax
  800995:	8d 50 01             	lea    0x1(%eax),%edx
  800998:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80099e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a1:	8b 10                	mov    (%eax),%edx
  8009a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a6:	8b 40 04             	mov    0x4(%eax),%eax
  8009a9:	39 c2                	cmp    %eax,%edx
  8009ab:	73 12                	jae    8009bf <sprintputch+0x33>
		*b->buf++ = ch;
  8009ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b0:	8b 00                	mov    (%eax),%eax
  8009b2:	8d 48 01             	lea    0x1(%eax),%ecx
  8009b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b8:	89 0a                	mov    %ecx,(%edx)
  8009ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8009bd:	88 10                	mov    %dl,(%eax)
}
  8009bf:	90                   	nop
  8009c0:	5d                   	pop    %ebp
  8009c1:	c3                   	ret    

008009c2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d7:	01 d0                	add    %edx,%eax
  8009d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009e7:	74 06                	je     8009ef <vsnprintf+0x2d>
  8009e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009ed:	7f 07                	jg     8009f6 <vsnprintf+0x34>
		return -E_INVAL;
  8009ef:	b8 03 00 00 00       	mov    $0x3,%eax
  8009f4:	eb 20                	jmp    800a16 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009f6:	ff 75 14             	pushl  0x14(%ebp)
  8009f9:	ff 75 10             	pushl  0x10(%ebp)
  8009fc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009ff:	50                   	push   %eax
  800a00:	68 8c 09 80 00       	push   $0x80098c
  800a05:	e8 80 fb ff ff       	call   80058a <vprintfmt>
  800a0a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a10:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a16:	c9                   	leave  
  800a17:	c3                   	ret    

00800a18 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a18:	55                   	push   %ebp
  800a19:	89 e5                	mov    %esp,%ebp
  800a1b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a1e:	8d 45 10             	lea    0x10(%ebp),%eax
  800a21:	83 c0 04             	add    $0x4,%eax
  800a24:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a27:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a2d:	50                   	push   %eax
  800a2e:	ff 75 0c             	pushl  0xc(%ebp)
  800a31:	ff 75 08             	pushl  0x8(%ebp)
  800a34:	e8 89 ff ff ff       	call   8009c2 <vsnprintf>
  800a39:	83 c4 10             	add    $0x10,%esp
  800a3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a42:	c9                   	leave  
  800a43:	c3                   	ret    

00800a44 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800a4a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a4e:	74 13                	je     800a63 <readline+0x1f>
		cprintf("%s", prompt);
  800a50:	83 ec 08             	sub    $0x8,%esp
  800a53:	ff 75 08             	pushl  0x8(%ebp)
  800a56:	68 c8 24 80 00       	push   $0x8024c8
  800a5b:	e8 0b f9 ff ff       	call   80036b <cprintf>
  800a60:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a6a:	83 ec 0c             	sub    $0xc,%esp
  800a6d:	6a 00                	push   $0x0
  800a6f:	e8 7e 10 00 00       	call   801af2 <iscons>
  800a74:	83 c4 10             	add    $0x10,%esp
  800a77:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a7a:	e8 60 10 00 00       	call   801adf <getchar>
  800a7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800a82:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a86:	79 22                	jns    800aaa <readline+0x66>
			if (c != -E_EOF)
  800a88:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800a8c:	0f 84 ad 00 00 00    	je     800b3f <readline+0xfb>
				cprintf("read error: %e\n", c);
  800a92:	83 ec 08             	sub    $0x8,%esp
  800a95:	ff 75 ec             	pushl  -0x14(%ebp)
  800a98:	68 cb 24 80 00       	push   $0x8024cb
  800a9d:	e8 c9 f8 ff ff       	call   80036b <cprintf>
  800aa2:	83 c4 10             	add    $0x10,%esp
			break;
  800aa5:	e9 95 00 00 00       	jmp    800b3f <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800aaa:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800aae:	7e 34                	jle    800ae4 <readline+0xa0>
  800ab0:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ab7:	7f 2b                	jg     800ae4 <readline+0xa0>
			if (echoing)
  800ab9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800abd:	74 0e                	je     800acd <readline+0x89>
				cputchar(c);
  800abf:	83 ec 0c             	sub    $0xc,%esp
  800ac2:	ff 75 ec             	pushl  -0x14(%ebp)
  800ac5:	e8 f6 0f 00 00       	call   801ac0 <cputchar>
  800aca:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ad0:	8d 50 01             	lea    0x1(%eax),%edx
  800ad3:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800ad6:	89 c2                	mov    %eax,%edx
  800ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adb:	01 d0                	add    %edx,%eax
  800add:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ae0:	88 10                	mov    %dl,(%eax)
  800ae2:	eb 56                	jmp    800b3a <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800ae4:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800ae8:	75 1f                	jne    800b09 <readline+0xc5>
  800aea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800aee:	7e 19                	jle    800b09 <readline+0xc5>
			if (echoing)
  800af0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800af4:	74 0e                	je     800b04 <readline+0xc0>
				cputchar(c);
  800af6:	83 ec 0c             	sub    $0xc,%esp
  800af9:	ff 75 ec             	pushl  -0x14(%ebp)
  800afc:	e8 bf 0f 00 00       	call   801ac0 <cputchar>
  800b01:	83 c4 10             	add    $0x10,%esp

			i--;
  800b04:	ff 4d f4             	decl   -0xc(%ebp)
  800b07:	eb 31                	jmp    800b3a <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800b09:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b0d:	74 0a                	je     800b19 <readline+0xd5>
  800b0f:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b13:	0f 85 61 ff ff ff    	jne    800a7a <readline+0x36>
			if (echoing)
  800b19:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b1d:	74 0e                	je     800b2d <readline+0xe9>
				cputchar(c);
  800b1f:	83 ec 0c             	sub    $0xc,%esp
  800b22:	ff 75 ec             	pushl  -0x14(%ebp)
  800b25:	e8 96 0f 00 00       	call   801ac0 <cputchar>
  800b2a:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800b2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b33:	01 d0                	add    %edx,%eax
  800b35:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800b38:	eb 06                	jmp    800b40 <readline+0xfc>
		}
	}
  800b3a:	e9 3b ff ff ff       	jmp    800a7a <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800b3f:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800b40:	90                   	nop
  800b41:	c9                   	leave  
  800b42:	c3                   	ret    

00800b43 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800b49:	e8 79 09 00 00       	call   8014c7 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b52:	74 13                	je     800b67 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b54:	83 ec 08             	sub    $0x8,%esp
  800b57:	ff 75 08             	pushl  0x8(%ebp)
  800b5a:	68 c8 24 80 00       	push   $0x8024c8
  800b5f:	e8 07 f8 ff ff       	call   80036b <cprintf>
  800b64:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b6e:	83 ec 0c             	sub    $0xc,%esp
  800b71:	6a 00                	push   $0x0
  800b73:	e8 7a 0f 00 00       	call   801af2 <iscons>
  800b78:	83 c4 10             	add    $0x10,%esp
  800b7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800b7e:	e8 5c 0f 00 00       	call   801adf <getchar>
  800b83:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800b86:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b8a:	79 22                	jns    800bae <atomic_readline+0x6b>
				if (c != -E_EOF)
  800b8c:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800b90:	0f 84 ad 00 00 00    	je     800c43 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800b96:	83 ec 08             	sub    $0x8,%esp
  800b99:	ff 75 ec             	pushl  -0x14(%ebp)
  800b9c:	68 cb 24 80 00       	push   $0x8024cb
  800ba1:	e8 c5 f7 ff ff       	call   80036b <cprintf>
  800ba6:	83 c4 10             	add    $0x10,%esp
				break;
  800ba9:	e9 95 00 00 00       	jmp    800c43 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800bae:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800bb2:	7e 34                	jle    800be8 <atomic_readline+0xa5>
  800bb4:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800bbb:	7f 2b                	jg     800be8 <atomic_readline+0xa5>
				if (echoing)
  800bbd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bc1:	74 0e                	je     800bd1 <atomic_readline+0x8e>
					cputchar(c);
  800bc3:	83 ec 0c             	sub    $0xc,%esp
  800bc6:	ff 75 ec             	pushl  -0x14(%ebp)
  800bc9:	e8 f2 0e 00 00       	call   801ac0 <cputchar>
  800bce:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bd4:	8d 50 01             	lea    0x1(%eax),%edx
  800bd7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800bda:	89 c2                	mov    %eax,%edx
  800bdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdf:	01 d0                	add    %edx,%eax
  800be1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800be4:	88 10                	mov    %dl,(%eax)
  800be6:	eb 56                	jmp    800c3e <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800be8:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800bec:	75 1f                	jne    800c0d <atomic_readline+0xca>
  800bee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800bf2:	7e 19                	jle    800c0d <atomic_readline+0xca>
				if (echoing)
  800bf4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bf8:	74 0e                	je     800c08 <atomic_readline+0xc5>
					cputchar(c);
  800bfa:	83 ec 0c             	sub    $0xc,%esp
  800bfd:	ff 75 ec             	pushl  -0x14(%ebp)
  800c00:	e8 bb 0e 00 00       	call   801ac0 <cputchar>
  800c05:	83 c4 10             	add    $0x10,%esp
				i--;
  800c08:	ff 4d f4             	decl   -0xc(%ebp)
  800c0b:	eb 31                	jmp    800c3e <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800c0d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800c11:	74 0a                	je     800c1d <atomic_readline+0xda>
  800c13:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800c17:	0f 85 61 ff ff ff    	jne    800b7e <atomic_readline+0x3b>
				if (echoing)
  800c1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c21:	74 0e                	je     800c31 <atomic_readline+0xee>
					cputchar(c);
  800c23:	83 ec 0c             	sub    $0xc,%esp
  800c26:	ff 75 ec             	pushl  -0x14(%ebp)
  800c29:	e8 92 0e 00 00       	call   801ac0 <cputchar>
  800c2e:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800c31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c37:	01 d0                	add    %edx,%eax
  800c39:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800c3c:	eb 06                	jmp    800c44 <atomic_readline+0x101>
			}
		}
  800c3e:	e9 3b ff ff ff       	jmp    800b7e <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800c43:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800c44:	e8 98 08 00 00       	call   8014e1 <sys_unlock_cons>
}
  800c49:	90                   	nop
  800c4a:	c9                   	leave  
  800c4b:	c3                   	ret    

00800c4c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c59:	eb 06                	jmp    800c61 <strlen+0x15>
		n++;
  800c5b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c5e:	ff 45 08             	incl   0x8(%ebp)
  800c61:	8b 45 08             	mov    0x8(%ebp),%eax
  800c64:	8a 00                	mov    (%eax),%al
  800c66:	84 c0                	test   %al,%al
  800c68:	75 f1                	jne    800c5b <strlen+0xf>
		n++;
	return n;
  800c6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6d:	c9                   	leave  
  800c6e:	c3                   	ret    

00800c6f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7c:	eb 09                	jmp    800c87 <strnlen+0x18>
		n++;
  800c7e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c81:	ff 45 08             	incl   0x8(%ebp)
  800c84:	ff 4d 0c             	decl   0xc(%ebp)
  800c87:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8b:	74 09                	je     800c96 <strnlen+0x27>
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c90:	8a 00                	mov    (%eax),%al
  800c92:	84 c0                	test   %al,%al
  800c94:	75 e8                	jne    800c7e <strnlen+0xf>
		n++;
	return n;
  800c96:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c99:	c9                   	leave  
  800c9a:	c3                   	ret    

00800c9b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ca7:	90                   	nop
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8d 50 01             	lea    0x1(%eax),%edx
  800cae:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cb7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cba:	8a 12                	mov    (%edx),%dl
  800cbc:	88 10                	mov    %dl,(%eax)
  800cbe:	8a 00                	mov    (%eax),%al
  800cc0:	84 c0                	test   %al,%al
  800cc2:	75 e4                	jne    800ca8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc7:	c9                   	leave  
  800cc8:	c3                   	ret    

00800cc9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cdc:	eb 1f                	jmp    800cfd <strncpy+0x34>
		*dst++ = *src;
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	8d 50 01             	lea    0x1(%eax),%edx
  800ce4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cea:	8a 12                	mov    (%edx),%dl
  800cec:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	84 c0                	test   %al,%al
  800cf5:	74 03                	je     800cfa <strncpy+0x31>
			src++;
  800cf7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cfa:	ff 45 fc             	incl   -0x4(%ebp)
  800cfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d00:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d03:	72 d9                	jb     800cde <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d05:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d08:	c9                   	leave  
  800d09:	c3                   	ret    

00800d0a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
  800d0d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d16:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1a:	74 30                	je     800d4c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d1c:	eb 16                	jmp    800d34 <strlcpy+0x2a>
			*dst++ = *src++;
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8d 50 01             	lea    0x1(%eax),%edx
  800d24:	89 55 08             	mov    %edx,0x8(%ebp)
  800d27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d2d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d30:	8a 12                	mov    (%edx),%dl
  800d32:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d34:	ff 4d 10             	decl   0x10(%ebp)
  800d37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3b:	74 09                	je     800d46 <strlcpy+0x3c>
  800d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	84 c0                	test   %al,%al
  800d44:	75 d8                	jne    800d1e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d52:	29 c2                	sub    %eax,%edx
  800d54:	89 d0                	mov    %edx,%eax
}
  800d56:	c9                   	leave  
  800d57:	c3                   	ret    

00800d58 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d5b:	eb 06                	jmp    800d63 <strcmp+0xb>
		p++, q++;
  800d5d:	ff 45 08             	incl   0x8(%ebp)
  800d60:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	84 c0                	test   %al,%al
  800d6a:	74 0e                	je     800d7a <strcmp+0x22>
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	8a 10                	mov    (%eax),%dl
  800d71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d74:	8a 00                	mov    (%eax),%al
  800d76:	38 c2                	cmp    %al,%dl
  800d78:	74 e3                	je     800d5d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7d:	8a 00                	mov    (%eax),%al
  800d7f:	0f b6 d0             	movzbl %al,%edx
  800d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d85:	8a 00                	mov    (%eax),%al
  800d87:	0f b6 c0             	movzbl %al,%eax
  800d8a:	29 c2                	sub    %eax,%edx
  800d8c:	89 d0                	mov    %edx,%eax
}
  800d8e:	5d                   	pop    %ebp
  800d8f:	c3                   	ret    

00800d90 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d93:	eb 09                	jmp    800d9e <strncmp+0xe>
		n--, p++, q++;
  800d95:	ff 4d 10             	decl   0x10(%ebp)
  800d98:	ff 45 08             	incl   0x8(%ebp)
  800d9b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da2:	74 17                	je     800dbb <strncmp+0x2b>
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	8a 00                	mov    (%eax),%al
  800da9:	84 c0                	test   %al,%al
  800dab:	74 0e                	je     800dbb <strncmp+0x2b>
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	8a 10                	mov    (%eax),%dl
  800db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db5:	8a 00                	mov    (%eax),%al
  800db7:	38 c2                	cmp    %al,%dl
  800db9:	74 da                	je     800d95 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dbb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbf:	75 07                	jne    800dc8 <strncmp+0x38>
		return 0;
  800dc1:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc6:	eb 14                	jmp    800ddc <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	8a 00                	mov    (%eax),%al
  800dcd:	0f b6 d0             	movzbl %al,%edx
  800dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd3:	8a 00                	mov    (%eax),%al
  800dd5:	0f b6 c0             	movzbl %al,%eax
  800dd8:	29 c2                	sub    %eax,%edx
  800dda:	89 d0                	mov    %edx,%eax
}
  800ddc:	5d                   	pop    %ebp
  800ddd:	c3                   	ret    

00800dde <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dde:	55                   	push   %ebp
  800ddf:	89 e5                	mov    %esp,%ebp
  800de1:	83 ec 04             	sub    $0x4,%esp
  800de4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dea:	eb 12                	jmp    800dfe <strchr+0x20>
		if (*s == c)
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	8a 00                	mov    (%eax),%al
  800df1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df4:	75 05                	jne    800dfb <strchr+0x1d>
			return (char *) s;
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	eb 11                	jmp    800e0c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dfb:	ff 45 08             	incl   0x8(%ebp)
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	84 c0                	test   %al,%al
  800e05:	75 e5                	jne    800dec <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e0c:	c9                   	leave  
  800e0d:	c3                   	ret    

00800e0e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	83 ec 04             	sub    $0x4,%esp
  800e14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e17:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e1a:	eb 0d                	jmp    800e29 <strfind+0x1b>
		if (*s == c)
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e24:	74 0e                	je     800e34 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e26:	ff 45 08             	incl   0x8(%ebp)
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	84 c0                	test   %al,%al
  800e30:	75 ea                	jne    800e1c <strfind+0xe>
  800e32:	eb 01                	jmp    800e35 <strfind+0x27>
		if (*s == c)
			break;
  800e34:	90                   	nop
	return (char *) s;
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e38:	c9                   	leave  
  800e39:	c3                   	ret    

00800e3a <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e46:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e4a:	76 63                	jbe    800eaf <memset+0x75>
		uint64 data_block = c;
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	99                   	cltd   
  800e50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e53:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e5c:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e60:	c1 e0 08             	shl    $0x8,%eax
  800e63:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e66:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e6f:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e73:	c1 e0 10             	shl    $0x10,%eax
  800e76:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e79:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e82:	89 c2                	mov    %eax,%edx
  800e84:	b8 00 00 00 00       	mov    $0x0,%eax
  800e89:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e8c:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e8f:	eb 18                	jmp    800ea9 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e91:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e94:	8d 41 08             	lea    0x8(%ecx),%eax
  800e97:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea0:	89 01                	mov    %eax,(%ecx)
  800ea2:	89 51 04             	mov    %edx,0x4(%ecx)
  800ea5:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ea9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ead:	77 e2                	ja     800e91 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800eaf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb3:	74 23                	je     800ed8 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800eb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ebb:	eb 0e                	jmp    800ecb <memset+0x91>
			*p8++ = (uint8)c;
  800ebd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec0:	8d 50 01             	lea    0x1(%eax),%edx
  800ec3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ec6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec9:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800ecb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ece:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed4:	85 c0                	test   %eax,%eax
  800ed6:	75 e5                	jne    800ebd <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800edb:	c9                   	leave  
  800edc:	c3                   	ret    

00800edd <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800eef:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ef3:	76 24                	jbe    800f19 <memcpy+0x3c>
		while(n >= 8){
  800ef5:	eb 1c                	jmp    800f13 <memcpy+0x36>
			*d64 = *s64;
  800ef7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800efa:	8b 50 04             	mov    0x4(%eax),%edx
  800efd:	8b 00                	mov    (%eax),%eax
  800eff:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f02:	89 01                	mov    %eax,(%ecx)
  800f04:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f07:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f0b:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f0f:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f13:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f17:	77 de                	ja     800ef7 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1d:	74 31                	je     800f50 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f22:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f28:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f2b:	eb 16                	jmp    800f43 <memcpy+0x66>
			*d8++ = *s8++;
  800f2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f30:	8d 50 01             	lea    0x1(%eax),%edx
  800f33:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f39:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f3c:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f3f:	8a 12                	mov    (%edx),%dl
  800f41:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f43:	8b 45 10             	mov    0x10(%ebp),%eax
  800f46:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f49:	89 55 10             	mov    %edx,0x10(%ebp)
  800f4c:	85 c0                	test   %eax,%eax
  800f4e:	75 dd                	jne    800f2d <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f53:	c9                   	leave  
  800f54:	c3                   	ret    

00800f55 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f6a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f6d:	73 50                	jae    800fbf <memmove+0x6a>
  800f6f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f72:	8b 45 10             	mov    0x10(%ebp),%eax
  800f75:	01 d0                	add    %edx,%eax
  800f77:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f7a:	76 43                	jbe    800fbf <memmove+0x6a>
		s += n;
  800f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f82:	8b 45 10             	mov    0x10(%ebp),%eax
  800f85:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f88:	eb 10                	jmp    800f9a <memmove+0x45>
			*--d = *--s;
  800f8a:	ff 4d f8             	decl   -0x8(%ebp)
  800f8d:	ff 4d fc             	decl   -0x4(%ebp)
  800f90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f93:	8a 10                	mov    (%eax),%dl
  800f95:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f98:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa0:	89 55 10             	mov    %edx,0x10(%ebp)
  800fa3:	85 c0                	test   %eax,%eax
  800fa5:	75 e3                	jne    800f8a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fa7:	eb 23                	jmp    800fcc <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fa9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fac:	8d 50 01             	lea    0x1(%eax),%edx
  800faf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fb2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fb8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fbb:	8a 12                	mov    (%edx),%dl
  800fbd:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc5:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc8:	85 c0                	test   %eax,%eax
  800fca:	75 dd                	jne    800fa9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fcf:	c9                   	leave  
  800fd0:	c3                   	ret    

00800fd1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
  800fd4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fe3:	eb 2a                	jmp    80100f <memcmp+0x3e>
		if (*s1 != *s2)
  800fe5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe8:	8a 10                	mov    (%eax),%dl
  800fea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fed:	8a 00                	mov    (%eax),%al
  800fef:	38 c2                	cmp    %al,%dl
  800ff1:	74 16                	je     801009 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ff3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff6:	8a 00                	mov    (%eax),%al
  800ff8:	0f b6 d0             	movzbl %al,%edx
  800ffb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ffe:	8a 00                	mov    (%eax),%al
  801000:	0f b6 c0             	movzbl %al,%eax
  801003:	29 c2                	sub    %eax,%edx
  801005:	89 d0                	mov    %edx,%eax
  801007:	eb 18                	jmp    801021 <memcmp+0x50>
		s1++, s2++;
  801009:	ff 45 fc             	incl   -0x4(%ebp)
  80100c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80100f:	8b 45 10             	mov    0x10(%ebp),%eax
  801012:	8d 50 ff             	lea    -0x1(%eax),%edx
  801015:	89 55 10             	mov    %edx,0x10(%ebp)
  801018:	85 c0                	test   %eax,%eax
  80101a:	75 c9                	jne    800fe5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80101c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801021:	c9                   	leave  
  801022:	c3                   	ret    

00801023 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801023:	55                   	push   %ebp
  801024:	89 e5                	mov    %esp,%ebp
  801026:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801029:	8b 55 08             	mov    0x8(%ebp),%edx
  80102c:	8b 45 10             	mov    0x10(%ebp),%eax
  80102f:	01 d0                	add    %edx,%eax
  801031:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801034:	eb 15                	jmp    80104b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	0f b6 d0             	movzbl %al,%edx
  80103e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801041:	0f b6 c0             	movzbl %al,%eax
  801044:	39 c2                	cmp    %eax,%edx
  801046:	74 0d                	je     801055 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801048:	ff 45 08             	incl   0x8(%ebp)
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801051:	72 e3                	jb     801036 <memfind+0x13>
  801053:	eb 01                	jmp    801056 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801055:	90                   	nop
	return (void *) s;
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801059:	c9                   	leave  
  80105a:	c3                   	ret    

0080105b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801068:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80106f:	eb 03                	jmp    801074 <strtol+0x19>
		s++;
  801071:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	3c 20                	cmp    $0x20,%al
  80107b:	74 f4                	je     801071 <strtol+0x16>
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	8a 00                	mov    (%eax),%al
  801082:	3c 09                	cmp    $0x9,%al
  801084:	74 eb                	je     801071 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
  801089:	8a 00                	mov    (%eax),%al
  80108b:	3c 2b                	cmp    $0x2b,%al
  80108d:	75 05                	jne    801094 <strtol+0x39>
		s++;
  80108f:	ff 45 08             	incl   0x8(%ebp)
  801092:	eb 13                	jmp    8010a7 <strtol+0x4c>
	else if (*s == '-')
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	8a 00                	mov    (%eax),%al
  801099:	3c 2d                	cmp    $0x2d,%al
  80109b:	75 0a                	jne    8010a7 <strtol+0x4c>
		s++, neg = 1;
  80109d:	ff 45 08             	incl   0x8(%ebp)
  8010a0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ab:	74 06                	je     8010b3 <strtol+0x58>
  8010ad:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010b1:	75 20                	jne    8010d3 <strtol+0x78>
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	8a 00                	mov    (%eax),%al
  8010b8:	3c 30                	cmp    $0x30,%al
  8010ba:	75 17                	jne    8010d3 <strtol+0x78>
  8010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bf:	40                   	inc    %eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	3c 78                	cmp    $0x78,%al
  8010c4:	75 0d                	jne    8010d3 <strtol+0x78>
		s += 2, base = 16;
  8010c6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010ca:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010d1:	eb 28                	jmp    8010fb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d7:	75 15                	jne    8010ee <strtol+0x93>
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	8a 00                	mov    (%eax),%al
  8010de:	3c 30                	cmp    $0x30,%al
  8010e0:	75 0c                	jne    8010ee <strtol+0x93>
		s++, base = 8;
  8010e2:	ff 45 08             	incl   0x8(%ebp)
  8010e5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010ec:	eb 0d                	jmp    8010fb <strtol+0xa0>
	else if (base == 0)
  8010ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f2:	75 07                	jne    8010fb <strtol+0xa0>
		base = 10;
  8010f4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	3c 2f                	cmp    $0x2f,%al
  801102:	7e 19                	jle    80111d <strtol+0xc2>
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	3c 39                	cmp    $0x39,%al
  80110b:	7f 10                	jg     80111d <strtol+0xc2>
			dig = *s - '0';
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
  801110:	8a 00                	mov    (%eax),%al
  801112:	0f be c0             	movsbl %al,%eax
  801115:	83 e8 30             	sub    $0x30,%eax
  801118:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80111b:	eb 42                	jmp    80115f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	8a 00                	mov    (%eax),%al
  801122:	3c 60                	cmp    $0x60,%al
  801124:	7e 19                	jle    80113f <strtol+0xe4>
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	3c 7a                	cmp    $0x7a,%al
  80112d:	7f 10                	jg     80113f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	8a 00                	mov    (%eax),%al
  801134:	0f be c0             	movsbl %al,%eax
  801137:	83 e8 57             	sub    $0x57,%eax
  80113a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80113d:	eb 20                	jmp    80115f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	3c 40                	cmp    $0x40,%al
  801146:	7e 39                	jle    801181 <strtol+0x126>
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	3c 5a                	cmp    $0x5a,%al
  80114f:	7f 30                	jg     801181 <strtol+0x126>
			dig = *s - 'A' + 10;
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	8a 00                	mov    (%eax),%al
  801156:	0f be c0             	movsbl %al,%eax
  801159:	83 e8 37             	sub    $0x37,%eax
  80115c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80115f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801162:	3b 45 10             	cmp    0x10(%ebp),%eax
  801165:	7d 19                	jge    801180 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801167:	ff 45 08             	incl   0x8(%ebp)
  80116a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80116d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801171:	89 c2                	mov    %eax,%edx
  801173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801176:	01 d0                	add    %edx,%eax
  801178:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80117b:	e9 7b ff ff ff       	jmp    8010fb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801180:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801181:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801185:	74 08                	je     80118f <strtol+0x134>
		*endptr = (char *) s;
  801187:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118a:	8b 55 08             	mov    0x8(%ebp),%edx
  80118d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80118f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801193:	74 07                	je     80119c <strtol+0x141>
  801195:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801198:	f7 d8                	neg    %eax
  80119a:	eb 03                	jmp    80119f <strtol+0x144>
  80119c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80119f:	c9                   	leave  
  8011a0:	c3                   	ret    

008011a1 <ltostr>:

void
ltostr(long value, char *str)
{
  8011a1:	55                   	push   %ebp
  8011a2:	89 e5                	mov    %esp,%ebp
  8011a4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011b9:	79 13                	jns    8011ce <ltostr+0x2d>
	{
		neg = 1;
  8011bb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011c8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011cb:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011d6:	99                   	cltd   
  8011d7:	f7 f9                	idiv   %ecx
  8011d9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011df:	8d 50 01             	lea    0x1(%eax),%edx
  8011e2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011e5:	89 c2                	mov    %eax,%edx
  8011e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ea:	01 d0                	add    %edx,%eax
  8011ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011ef:	83 c2 30             	add    $0x30,%edx
  8011f2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011f7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011fc:	f7 e9                	imul   %ecx
  8011fe:	c1 fa 02             	sar    $0x2,%edx
  801201:	89 c8                	mov    %ecx,%eax
  801203:	c1 f8 1f             	sar    $0x1f,%eax
  801206:	29 c2                	sub    %eax,%edx
  801208:	89 d0                	mov    %edx,%eax
  80120a:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80120d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801211:	75 bb                	jne    8011ce <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801213:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80121a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121d:	48                   	dec    %eax
  80121e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801221:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801225:	74 3d                	je     801264 <ltostr+0xc3>
		start = 1 ;
  801227:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80122e:	eb 34                	jmp    801264 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801230:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801233:	8b 45 0c             	mov    0xc(%ebp),%eax
  801236:	01 d0                	add    %edx,%eax
  801238:	8a 00                	mov    (%eax),%al
  80123a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80123d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801240:	8b 45 0c             	mov    0xc(%ebp),%eax
  801243:	01 c2                	add    %eax,%edx
  801245:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124b:	01 c8                	add    %ecx,%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801251:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801254:	8b 45 0c             	mov    0xc(%ebp),%eax
  801257:	01 c2                	add    %eax,%edx
  801259:	8a 45 eb             	mov    -0x15(%ebp),%al
  80125c:	88 02                	mov    %al,(%edx)
		start++ ;
  80125e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801261:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801264:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801267:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80126a:	7c c4                	jl     801230 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80126c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80126f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801272:	01 d0                	add    %edx,%eax
  801274:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801277:	90                   	nop
  801278:	c9                   	leave  
  801279:	c3                   	ret    

0080127a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80127a:	55                   	push   %ebp
  80127b:	89 e5                	mov    %esp,%ebp
  80127d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801280:	ff 75 08             	pushl  0x8(%ebp)
  801283:	e8 c4 f9 ff ff       	call   800c4c <strlen>
  801288:	83 c4 04             	add    $0x4,%esp
  80128b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80128e:	ff 75 0c             	pushl  0xc(%ebp)
  801291:	e8 b6 f9 ff ff       	call   800c4c <strlen>
  801296:	83 c4 04             	add    $0x4,%esp
  801299:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80129c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012aa:	eb 17                	jmp    8012c3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012af:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b2:	01 c2                	add    %eax,%edx
  8012b4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	01 c8                	add    %ecx,%eax
  8012bc:	8a 00                	mov    (%eax),%al
  8012be:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012c0:	ff 45 fc             	incl   -0x4(%ebp)
  8012c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012c9:	7c e1                	jl     8012ac <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012d9:	eb 1f                	jmp    8012fa <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012de:	8d 50 01             	lea    0x1(%eax),%edx
  8012e1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012e4:	89 c2                	mov    %eax,%edx
  8012e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e9:	01 c2                	add    %eax,%edx
  8012eb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f1:	01 c8                	add    %ecx,%eax
  8012f3:	8a 00                	mov    (%eax),%al
  8012f5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012f7:	ff 45 f8             	incl   -0x8(%ebp)
  8012fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801300:	7c d9                	jl     8012db <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801302:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801305:	8b 45 10             	mov    0x10(%ebp),%eax
  801308:	01 d0                	add    %edx,%eax
  80130a:	c6 00 00             	movb   $0x0,(%eax)
}
  80130d:	90                   	nop
  80130e:	c9                   	leave  
  80130f:	c3                   	ret    

00801310 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801313:	8b 45 14             	mov    0x14(%ebp),%eax
  801316:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80131c:	8b 45 14             	mov    0x14(%ebp),%eax
  80131f:	8b 00                	mov    (%eax),%eax
  801321:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801328:	8b 45 10             	mov    0x10(%ebp),%eax
  80132b:	01 d0                	add    %edx,%eax
  80132d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801333:	eb 0c                	jmp    801341 <strsplit+0x31>
			*string++ = 0;
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	8d 50 01             	lea    0x1(%eax),%edx
  80133b:	89 55 08             	mov    %edx,0x8(%ebp)
  80133e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	8a 00                	mov    (%eax),%al
  801346:	84 c0                	test   %al,%al
  801348:	74 18                	je     801362 <strsplit+0x52>
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	8a 00                	mov    (%eax),%al
  80134f:	0f be c0             	movsbl %al,%eax
  801352:	50                   	push   %eax
  801353:	ff 75 0c             	pushl  0xc(%ebp)
  801356:	e8 83 fa ff ff       	call   800dde <strchr>
  80135b:	83 c4 08             	add    $0x8,%esp
  80135e:	85 c0                	test   %eax,%eax
  801360:	75 d3                	jne    801335 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	8a 00                	mov    (%eax),%al
  801367:	84 c0                	test   %al,%al
  801369:	74 5a                	je     8013c5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80136b:	8b 45 14             	mov    0x14(%ebp),%eax
  80136e:	8b 00                	mov    (%eax),%eax
  801370:	83 f8 0f             	cmp    $0xf,%eax
  801373:	75 07                	jne    80137c <strsplit+0x6c>
		{
			return 0;
  801375:	b8 00 00 00 00       	mov    $0x0,%eax
  80137a:	eb 66                	jmp    8013e2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80137c:	8b 45 14             	mov    0x14(%ebp),%eax
  80137f:	8b 00                	mov    (%eax),%eax
  801381:	8d 48 01             	lea    0x1(%eax),%ecx
  801384:	8b 55 14             	mov    0x14(%ebp),%edx
  801387:	89 0a                	mov    %ecx,(%edx)
  801389:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801390:	8b 45 10             	mov    0x10(%ebp),%eax
  801393:	01 c2                	add    %eax,%edx
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80139a:	eb 03                	jmp    80139f <strsplit+0x8f>
			string++;
  80139c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	8a 00                	mov    (%eax),%al
  8013a4:	84 c0                	test   %al,%al
  8013a6:	74 8b                	je     801333 <strsplit+0x23>
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	8a 00                	mov    (%eax),%al
  8013ad:	0f be c0             	movsbl %al,%eax
  8013b0:	50                   	push   %eax
  8013b1:	ff 75 0c             	pushl  0xc(%ebp)
  8013b4:	e8 25 fa ff ff       	call   800dde <strchr>
  8013b9:	83 c4 08             	add    $0x8,%esp
  8013bc:	85 c0                	test   %eax,%eax
  8013be:	74 dc                	je     80139c <strsplit+0x8c>
			string++;
	}
  8013c0:	e9 6e ff ff ff       	jmp    801333 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013c5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c9:	8b 00                	mov    (%eax),%eax
  8013cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d5:	01 d0                	add    %edx,%eax
  8013d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013dd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013e2:	c9                   	leave  
  8013e3:	c3                   	ret    

008013e4 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013e4:	55                   	push   %ebp
  8013e5:	89 e5                	mov    %esp,%ebp
  8013e7:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f7:	eb 4a                	jmp    801443 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8013f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ff:	01 c2                	add    %eax,%edx
  801401:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801404:	8b 45 0c             	mov    0xc(%ebp),%eax
  801407:	01 c8                	add    %ecx,%eax
  801409:	8a 00                	mov    (%eax),%al
  80140b:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80140d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801410:	8b 45 0c             	mov    0xc(%ebp),%eax
  801413:	01 d0                	add    %edx,%eax
  801415:	8a 00                	mov    (%eax),%al
  801417:	3c 40                	cmp    $0x40,%al
  801419:	7e 25                	jle    801440 <str2lower+0x5c>
  80141b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80141e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801421:	01 d0                	add    %edx,%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	3c 5a                	cmp    $0x5a,%al
  801427:	7f 17                	jg     801440 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801429:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
  80142f:	01 d0                	add    %edx,%eax
  801431:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801434:	8b 55 08             	mov    0x8(%ebp),%edx
  801437:	01 ca                	add    %ecx,%edx
  801439:	8a 12                	mov    (%edx),%dl
  80143b:	83 c2 20             	add    $0x20,%edx
  80143e:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801440:	ff 45 fc             	incl   -0x4(%ebp)
  801443:	ff 75 0c             	pushl  0xc(%ebp)
  801446:	e8 01 f8 ff ff       	call   800c4c <strlen>
  80144b:	83 c4 04             	add    $0x4,%esp
  80144e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801451:	7f a6                	jg     8013f9 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801453:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801456:	c9                   	leave  
  801457:	c3                   	ret    

00801458 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
  80145b:	57                   	push   %edi
  80145c:	56                   	push   %esi
  80145d:	53                   	push   %ebx
  80145e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	8b 55 0c             	mov    0xc(%ebp),%edx
  801467:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80146a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80146d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801470:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801473:	cd 30                	int    $0x30
  801475:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801478:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80147b:	83 c4 10             	add    $0x10,%esp
  80147e:	5b                   	pop    %ebx
  80147f:	5e                   	pop    %esi
  801480:	5f                   	pop    %edi
  801481:	5d                   	pop    %ebp
  801482:	c3                   	ret    

00801483 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	83 ec 04             	sub    $0x4,%esp
  801489:	8b 45 10             	mov    0x10(%ebp),%eax
  80148c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80148f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801492:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	6a 00                	push   $0x0
  80149b:	51                   	push   %ecx
  80149c:	52                   	push   %edx
  80149d:	ff 75 0c             	pushl  0xc(%ebp)
  8014a0:	50                   	push   %eax
  8014a1:	6a 00                	push   $0x0
  8014a3:	e8 b0 ff ff ff       	call   801458 <syscall>
  8014a8:	83 c4 18             	add    $0x18,%esp
}
  8014ab:	90                   	nop
  8014ac:	c9                   	leave  
  8014ad:	c3                   	ret    

008014ae <sys_cgetc>:

int
sys_cgetc(void)
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 02                	push   $0x2
  8014bd:	e8 96 ff ff ff       	call   801458 <syscall>
  8014c2:	83 c4 18             	add    $0x18,%esp
}
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 03                	push   $0x3
  8014d6:	e8 7d ff ff ff       	call   801458 <syscall>
  8014db:	83 c4 18             	add    $0x18,%esp
}
  8014de:	90                   	nop
  8014df:	c9                   	leave  
  8014e0:	c3                   	ret    

008014e1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 00                	push   $0x0
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 04                	push   $0x4
  8014f0:	e8 63 ff ff ff       	call   801458 <syscall>
  8014f5:	83 c4 18             	add    $0x18,%esp
}
  8014f8:	90                   	nop
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	6a 00                	push   $0x0
  80150a:	52                   	push   %edx
  80150b:	50                   	push   %eax
  80150c:	6a 08                	push   $0x8
  80150e:	e8 45 ff ff ff       	call   801458 <syscall>
  801513:	83 c4 18             	add    $0x18,%esp
}
  801516:	c9                   	leave  
  801517:	c3                   	ret    

00801518 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
  80151b:	56                   	push   %esi
  80151c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80151d:	8b 75 18             	mov    0x18(%ebp),%esi
  801520:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801523:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801526:	8b 55 0c             	mov    0xc(%ebp),%edx
  801529:	8b 45 08             	mov    0x8(%ebp),%eax
  80152c:	56                   	push   %esi
  80152d:	53                   	push   %ebx
  80152e:	51                   	push   %ecx
  80152f:	52                   	push   %edx
  801530:	50                   	push   %eax
  801531:	6a 09                	push   $0x9
  801533:	e8 20 ff ff ff       	call   801458 <syscall>
  801538:	83 c4 18             	add    $0x18,%esp
}
  80153b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80153e:	5b                   	pop    %ebx
  80153f:	5e                   	pop    %esi
  801540:	5d                   	pop    %ebp
  801541:	c3                   	ret    

00801542 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	ff 75 08             	pushl  0x8(%ebp)
  801550:	6a 0a                	push   $0xa
  801552:	e8 01 ff ff ff       	call   801458 <syscall>
  801557:	83 c4 18             	add    $0x18,%esp
}
  80155a:	c9                   	leave  
  80155b:	c3                   	ret    

0080155c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	6a 00                	push   $0x0
  801565:	ff 75 0c             	pushl  0xc(%ebp)
  801568:	ff 75 08             	pushl  0x8(%ebp)
  80156b:	6a 0b                	push   $0xb
  80156d:	e8 e6 fe ff ff       	call   801458 <syscall>
  801572:	83 c4 18             	add    $0x18,%esp
}
  801575:	c9                   	leave  
  801576:	c3                   	ret    

00801577 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 0c                	push   $0xc
  801586:	e8 cd fe ff ff       	call   801458 <syscall>
  80158b:	83 c4 18             	add    $0x18,%esp
}
  80158e:	c9                   	leave  
  80158f:	c3                   	ret    

00801590 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 0d                	push   $0xd
  80159f:	e8 b4 fe ff ff       	call   801458 <syscall>
  8015a4:	83 c4 18             	add    $0x18,%esp
}
  8015a7:	c9                   	leave  
  8015a8:	c3                   	ret    

008015a9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 0e                	push   $0xe
  8015b8:	e8 9b fe ff ff       	call   801458 <syscall>
  8015bd:	83 c4 18             	add    $0x18,%esp
}
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    

008015c2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 0f                	push   $0xf
  8015d1:	e8 82 fe ff ff       	call   801458 <syscall>
  8015d6:	83 c4 18             	add    $0x18,%esp
}
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    

008015db <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	ff 75 08             	pushl  0x8(%ebp)
  8015e9:	6a 10                	push   $0x10
  8015eb:	e8 68 fe ff ff       	call   801458 <syscall>
  8015f0:	83 c4 18             	add    $0x18,%esp
}
  8015f3:	c9                   	leave  
  8015f4:	c3                   	ret    

008015f5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 11                	push   $0x11
  801604:	e8 4f fe ff ff       	call   801458 <syscall>
  801609:	83 c4 18             	add    $0x18,%esp
}
  80160c:	90                   	nop
  80160d:	c9                   	leave  
  80160e:	c3                   	ret    

0080160f <sys_cputc>:

void
sys_cputc(const char c)
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
  801612:	83 ec 04             	sub    $0x4,%esp
  801615:	8b 45 08             	mov    0x8(%ebp),%eax
  801618:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80161b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	50                   	push   %eax
  801628:	6a 01                	push   $0x1
  80162a:	e8 29 fe ff ff       	call   801458 <syscall>
  80162f:	83 c4 18             	add    $0x18,%esp
}
  801632:	90                   	nop
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 14                	push   $0x14
  801644:	e8 0f fe ff ff       	call   801458 <syscall>
  801649:	83 c4 18             	add    $0x18,%esp
}
  80164c:	90                   	nop
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	83 ec 04             	sub    $0x4,%esp
  801655:	8b 45 10             	mov    0x10(%ebp),%eax
  801658:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80165b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80165e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801662:	8b 45 08             	mov    0x8(%ebp),%eax
  801665:	6a 00                	push   $0x0
  801667:	51                   	push   %ecx
  801668:	52                   	push   %edx
  801669:	ff 75 0c             	pushl  0xc(%ebp)
  80166c:	50                   	push   %eax
  80166d:	6a 15                	push   $0x15
  80166f:	e8 e4 fd ff ff       	call   801458 <syscall>
  801674:	83 c4 18             	add    $0x18,%esp
}
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80167c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	52                   	push   %edx
  801689:	50                   	push   %eax
  80168a:	6a 16                	push   $0x16
  80168c:	e8 c7 fd ff ff       	call   801458 <syscall>
  801691:	83 c4 18             	add    $0x18,%esp
}
  801694:	c9                   	leave  
  801695:	c3                   	ret    

00801696 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801699:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80169c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	51                   	push   %ecx
  8016a7:	52                   	push   %edx
  8016a8:	50                   	push   %eax
  8016a9:	6a 17                	push   $0x17
  8016ab:	e8 a8 fd ff ff       	call   801458 <syscall>
  8016b0:	83 c4 18             	add    $0x18,%esp
}
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	52                   	push   %edx
  8016c5:	50                   	push   %eax
  8016c6:	6a 18                	push   $0x18
  8016c8:	e8 8b fd ff ff       	call   801458 <syscall>
  8016cd:	83 c4 18             	add    $0x18,%esp
}
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    

008016d2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d8:	6a 00                	push   $0x0
  8016da:	ff 75 14             	pushl  0x14(%ebp)
  8016dd:	ff 75 10             	pushl  0x10(%ebp)
  8016e0:	ff 75 0c             	pushl  0xc(%ebp)
  8016e3:	50                   	push   %eax
  8016e4:	6a 19                	push   $0x19
  8016e6:	e8 6d fd ff ff       	call   801458 <syscall>
  8016eb:	83 c4 18             	add    $0x18,%esp
}
  8016ee:	c9                   	leave  
  8016ef:	c3                   	ret    

008016f0 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	50                   	push   %eax
  8016ff:	6a 1a                	push   $0x1a
  801701:	e8 52 fd ff ff       	call   801458 <syscall>
  801706:	83 c4 18             	add    $0x18,%esp
}
  801709:	90                   	nop
  80170a:	c9                   	leave  
  80170b:	c3                   	ret    

0080170c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80170f:	8b 45 08             	mov    0x8(%ebp),%eax
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	50                   	push   %eax
  80171b:	6a 1b                	push   $0x1b
  80171d:	e8 36 fd ff ff       	call   801458 <syscall>
  801722:	83 c4 18             	add    $0x18,%esp
}
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 05                	push   $0x5
  801736:	e8 1d fd ff ff       	call   801458 <syscall>
  80173b:	83 c4 18             	add    $0x18,%esp
}
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 06                	push   $0x6
  80174f:	e8 04 fd ff ff       	call   801458 <syscall>
  801754:	83 c4 18             	add    $0x18,%esp
}
  801757:	c9                   	leave  
  801758:	c3                   	ret    

00801759 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 07                	push   $0x7
  801768:	e8 eb fc ff ff       	call   801458 <syscall>
  80176d:	83 c4 18             	add    $0x18,%esp
}
  801770:	c9                   	leave  
  801771:	c3                   	ret    

00801772 <sys_exit_env>:


void sys_exit_env(void)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 1c                	push   $0x1c
  801781:	e8 d2 fc ff ff       	call   801458 <syscall>
  801786:	83 c4 18             	add    $0x18,%esp
}
  801789:	90                   	nop
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
  80178f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801792:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801795:	8d 50 04             	lea    0x4(%eax),%edx
  801798:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	52                   	push   %edx
  8017a2:	50                   	push   %eax
  8017a3:	6a 1d                	push   $0x1d
  8017a5:	e8 ae fc ff ff       	call   801458 <syscall>
  8017aa:	83 c4 18             	add    $0x18,%esp
	return result;
  8017ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b6:	89 01                	mov    %eax,(%ecx)
  8017b8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017be:	c9                   	leave  
  8017bf:	c2 04 00             	ret    $0x4

008017c2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	ff 75 10             	pushl  0x10(%ebp)
  8017cc:	ff 75 0c             	pushl  0xc(%ebp)
  8017cf:	ff 75 08             	pushl  0x8(%ebp)
  8017d2:	6a 13                	push   $0x13
  8017d4:	e8 7f fc ff ff       	call   801458 <syscall>
  8017d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8017dc:	90                   	nop
}
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <sys_rcr2>:
uint32 sys_rcr2()
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 1e                	push   $0x1e
  8017ee:	e8 65 fc ff ff       	call   801458 <syscall>
  8017f3:	83 c4 18             	add    $0x18,%esp
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	83 ec 04             	sub    $0x4,%esp
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801804:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	50                   	push   %eax
  801811:	6a 1f                	push   $0x1f
  801813:	e8 40 fc ff ff       	call   801458 <syscall>
  801818:	83 c4 18             	add    $0x18,%esp
	return ;
  80181b:	90                   	nop
}
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <rsttst>:
void rsttst()
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 21                	push   $0x21
  80182d:	e8 26 fc ff ff       	call   801458 <syscall>
  801832:	83 c4 18             	add    $0x18,%esp
	return ;
  801835:	90                   	nop
}
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
  80183b:	83 ec 04             	sub    $0x4,%esp
  80183e:	8b 45 14             	mov    0x14(%ebp),%eax
  801841:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801844:	8b 55 18             	mov    0x18(%ebp),%edx
  801847:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80184b:	52                   	push   %edx
  80184c:	50                   	push   %eax
  80184d:	ff 75 10             	pushl  0x10(%ebp)
  801850:	ff 75 0c             	pushl  0xc(%ebp)
  801853:	ff 75 08             	pushl  0x8(%ebp)
  801856:	6a 20                	push   $0x20
  801858:	e8 fb fb ff ff       	call   801458 <syscall>
  80185d:	83 c4 18             	add    $0x18,%esp
	return ;
  801860:	90                   	nop
}
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <chktst>:
void chktst(uint32 n)
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	ff 75 08             	pushl  0x8(%ebp)
  801871:	6a 22                	push   $0x22
  801873:	e8 e0 fb ff ff       	call   801458 <syscall>
  801878:	83 c4 18             	add    $0x18,%esp
	return ;
  80187b:	90                   	nop
}
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    

0080187e <inctst>:

void inctst()
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 23                	push   $0x23
  80188d:	e8 c6 fb ff ff       	call   801458 <syscall>
  801892:	83 c4 18             	add    $0x18,%esp
	return ;
  801895:	90                   	nop
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    

00801898 <gettst>:
uint32 gettst()
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 24                	push   $0x24
  8018a7:	e8 ac fb ff ff       	call   801458 <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp
}
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 25                	push   $0x25
  8018c0:	e8 93 fb ff ff       	call   801458 <syscall>
  8018c5:	83 c4 18             	add    $0x18,%esp
  8018c8:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8018cd:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8018d2:	c9                   	leave  
  8018d3:	c3                   	ret    

008018d4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018da:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	ff 75 08             	pushl  0x8(%ebp)
  8018ea:	6a 26                	push   $0x26
  8018ec:	e8 67 fb ff ff       	call   801458 <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f4:	90                   	nop
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801901:	8b 55 0c             	mov    0xc(%ebp),%edx
  801904:	8b 45 08             	mov    0x8(%ebp),%eax
  801907:	6a 00                	push   $0x0
  801909:	53                   	push   %ebx
  80190a:	51                   	push   %ecx
  80190b:	52                   	push   %edx
  80190c:	50                   	push   %eax
  80190d:	6a 27                	push   $0x27
  80190f:	e8 44 fb ff ff       	call   801458 <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
}
  801917:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80191f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	52                   	push   %edx
  80192c:	50                   	push   %eax
  80192d:	6a 28                	push   $0x28
  80192f:	e8 24 fb ff ff       	call   801458 <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80193c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80193f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	6a 00                	push   $0x0
  801947:	51                   	push   %ecx
  801948:	ff 75 10             	pushl  0x10(%ebp)
  80194b:	52                   	push   %edx
  80194c:	50                   	push   %eax
  80194d:	6a 29                	push   $0x29
  80194f:	e8 04 fb ff ff       	call   801458 <syscall>
  801954:	83 c4 18             	add    $0x18,%esp
}
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	ff 75 10             	pushl  0x10(%ebp)
  801963:	ff 75 0c             	pushl  0xc(%ebp)
  801966:	ff 75 08             	pushl  0x8(%ebp)
  801969:	6a 12                	push   $0x12
  80196b:	e8 e8 fa ff ff       	call   801458 <syscall>
  801970:	83 c4 18             	add    $0x18,%esp
	return ;
  801973:	90                   	nop
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	52                   	push   %edx
  801986:	50                   	push   %eax
  801987:	6a 2a                	push   $0x2a
  801989:	e8 ca fa ff ff       	call   801458 <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
	return;
  801991:	90                   	nop
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 2b                	push   $0x2b
  8019a3:	e8 b0 fa ff ff       	call   801458 <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	ff 75 0c             	pushl  0xc(%ebp)
  8019b9:	ff 75 08             	pushl  0x8(%ebp)
  8019bc:	6a 2d                	push   $0x2d
  8019be:	e8 95 fa ff ff       	call   801458 <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
	return;
  8019c6:	90                   	nop
}
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	ff 75 0c             	pushl  0xc(%ebp)
  8019d5:	ff 75 08             	pushl  0x8(%ebp)
  8019d8:	6a 2c                	push   $0x2c
  8019da:	e8 79 fa ff ff       	call   801458 <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e2:	90                   	nop
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8019eb:	83 ec 04             	sub    $0x4,%esp
  8019ee:	68 dc 24 80 00       	push   $0x8024dc
  8019f3:	68 25 01 00 00       	push   $0x125
  8019f8:	68 0f 25 80 00       	push   $0x80250f
  8019fd:	e8 fa 00 00 00       	call   801afc <_panic>

00801a02 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
  801a05:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801a08:	8b 55 08             	mov    0x8(%ebp),%edx
  801a0b:	89 d0                	mov    %edx,%eax
  801a0d:	c1 e0 02             	shl    $0x2,%eax
  801a10:	01 d0                	add    %edx,%eax
  801a12:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a19:	01 d0                	add    %edx,%eax
  801a1b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a22:	01 d0                	add    %edx,%eax
  801a24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a2b:	01 d0                	add    %edx,%eax
  801a2d:	c1 e0 04             	shl    $0x4,%eax
  801a30:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801a33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801a3a:	0f 31                	rdtsc  
  801a3c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801a3f:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801a42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a45:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a4b:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801a4e:	eb 46                	jmp    801a96 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801a50:	0f 31                	rdtsc  
  801a52:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801a55:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801a58:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801a5b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801a5e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801a61:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801a64:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a6a:	29 c2                	sub    %eax,%edx
  801a6c:	89 d0                	mov    %edx,%eax
  801a6e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801a71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a77:	89 d1                	mov    %edx,%ecx
  801a79:	29 c1                	sub    %eax,%ecx
  801a7b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a81:	39 c2                	cmp    %eax,%edx
  801a83:	0f 97 c0             	seta   %al
  801a86:	0f b6 c0             	movzbl %al,%eax
  801a89:	29 c1                	sub    %eax,%ecx
  801a8b:	89 c8                	mov    %ecx,%eax
  801a8d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801a90:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801a96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a99:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801a9c:	72 b2                	jb     801a50 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801a9e:	90                   	nop
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
  801aa4:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801aa7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801aae:	eb 03                	jmp    801ab3 <busy_wait+0x12>
  801ab0:	ff 45 fc             	incl   -0x4(%ebp)
  801ab3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ab6:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ab9:	72 f5                	jb     801ab0 <busy_wait+0xf>
	return i;
  801abb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801acc:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801ad0:	83 ec 0c             	sub    $0xc,%esp
  801ad3:	50                   	push   %eax
  801ad4:	e8 36 fb ff ff       	call   80160f <sys_cputc>
  801ad9:	83 c4 10             	add    $0x10,%esp
}
  801adc:	90                   	nop
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <getchar>:


int
getchar(void)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
  801ae2:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801ae5:	e8 c4 f9 ff ff       	call   8014ae <sys_cgetc>
  801aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <iscons>:

int iscons(int fdnum)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801af5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801afa:	5d                   	pop    %ebp
  801afb:	c3                   	ret    

00801afc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
  801aff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801b02:	8d 45 10             	lea    0x10(%ebp),%eax
  801b05:	83 c0 04             	add    $0x4,%eax
  801b08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801b0b:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801b10:	85 c0                	test   %eax,%eax
  801b12:	74 16                	je     801b2a <_panic+0x2e>
		cprintf("%s: ", argv0);
  801b14:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801b19:	83 ec 08             	sub    $0x8,%esp
  801b1c:	50                   	push   %eax
  801b1d:	68 20 25 80 00       	push   $0x802520
  801b22:	e8 44 e8 ff ff       	call   80036b <cprintf>
  801b27:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801b2a:	a1 04 30 80 00       	mov    0x803004,%eax
  801b2f:	83 ec 0c             	sub    $0xc,%esp
  801b32:	ff 75 0c             	pushl  0xc(%ebp)
  801b35:	ff 75 08             	pushl  0x8(%ebp)
  801b38:	50                   	push   %eax
  801b39:	68 28 25 80 00       	push   $0x802528
  801b3e:	6a 74                	push   $0x74
  801b40:	e8 53 e8 ff ff       	call   800398 <cprintf_colored>
  801b45:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801b48:	8b 45 10             	mov    0x10(%ebp),%eax
  801b4b:	83 ec 08             	sub    $0x8,%esp
  801b4e:	ff 75 f4             	pushl  -0xc(%ebp)
  801b51:	50                   	push   %eax
  801b52:	e8 a5 e7 ff ff       	call   8002fc <vcprintf>
  801b57:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801b5a:	83 ec 08             	sub    $0x8,%esp
  801b5d:	6a 00                	push   $0x0
  801b5f:	68 50 25 80 00       	push   $0x802550
  801b64:	e8 93 e7 ff ff       	call   8002fc <vcprintf>
  801b69:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801b6c:	e8 0c e7 ff ff       	call   80027d <exit>

	// should not return here
	while (1) ;
  801b71:	eb fe                	jmp    801b71 <_panic+0x75>

00801b73 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
  801b76:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801b79:	a1 20 30 80 00       	mov    0x803020,%eax
  801b7e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801b84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b87:	39 c2                	cmp    %eax,%edx
  801b89:	74 14                	je     801b9f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801b8b:	83 ec 04             	sub    $0x4,%esp
  801b8e:	68 54 25 80 00       	push   $0x802554
  801b93:	6a 26                	push   $0x26
  801b95:	68 a0 25 80 00       	push   $0x8025a0
  801b9a:	e8 5d ff ff ff       	call   801afc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801b9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801ba6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801bad:	e9 c5 00 00 00       	jmp    801c77 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbf:	01 d0                	add    %edx,%eax
  801bc1:	8b 00                	mov    (%eax),%eax
  801bc3:	85 c0                	test   %eax,%eax
  801bc5:	75 08                	jne    801bcf <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801bc7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801bca:	e9 a5 00 00 00       	jmp    801c74 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801bcf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801bd6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801bdd:	eb 69                	jmp    801c48 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801bdf:	a1 20 30 80 00       	mov    0x803020,%eax
  801be4:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801bea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bed:	89 d0                	mov    %edx,%eax
  801bef:	01 c0                	add    %eax,%eax
  801bf1:	01 d0                	add    %edx,%eax
  801bf3:	c1 e0 03             	shl    $0x3,%eax
  801bf6:	01 c8                	add    %ecx,%eax
  801bf8:	8a 40 04             	mov    0x4(%eax),%al
  801bfb:	84 c0                	test   %al,%al
  801bfd:	75 46                	jne    801c45 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801bff:	a1 20 30 80 00       	mov    0x803020,%eax
  801c04:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801c0a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c0d:	89 d0                	mov    %edx,%eax
  801c0f:	01 c0                	add    %eax,%eax
  801c11:	01 d0                	add    %edx,%eax
  801c13:	c1 e0 03             	shl    $0x3,%eax
  801c16:	01 c8                	add    %ecx,%eax
  801c18:	8b 00                	mov    (%eax),%eax
  801c1a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801c1d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c20:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c25:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c2a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801c31:	8b 45 08             	mov    0x8(%ebp),%eax
  801c34:	01 c8                	add    %ecx,%eax
  801c36:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801c38:	39 c2                	cmp    %eax,%edx
  801c3a:	75 09                	jne    801c45 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801c3c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801c43:	eb 15                	jmp    801c5a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c45:	ff 45 e8             	incl   -0x18(%ebp)
  801c48:	a1 20 30 80 00       	mov    0x803020,%eax
  801c4d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801c53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c56:	39 c2                	cmp    %eax,%edx
  801c58:	77 85                	ja     801bdf <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801c5a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c5e:	75 14                	jne    801c74 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801c60:	83 ec 04             	sub    $0x4,%esp
  801c63:	68 ac 25 80 00       	push   $0x8025ac
  801c68:	6a 3a                	push   $0x3a
  801c6a:	68 a0 25 80 00       	push   $0x8025a0
  801c6f:	e8 88 fe ff ff       	call   801afc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801c74:	ff 45 f0             	incl   -0x10(%ebp)
  801c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c7a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801c7d:	0f 8c 2f ff ff ff    	jl     801bb2 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801c83:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c8a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801c91:	eb 26                	jmp    801cb9 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801c93:	a1 20 30 80 00       	mov    0x803020,%eax
  801c98:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801c9e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ca1:	89 d0                	mov    %edx,%eax
  801ca3:	01 c0                	add    %eax,%eax
  801ca5:	01 d0                	add    %edx,%eax
  801ca7:	c1 e0 03             	shl    $0x3,%eax
  801caa:	01 c8                	add    %ecx,%eax
  801cac:	8a 40 04             	mov    0x4(%eax),%al
  801caf:	3c 01                	cmp    $0x1,%al
  801cb1:	75 03                	jne    801cb6 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801cb3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801cb6:	ff 45 e0             	incl   -0x20(%ebp)
  801cb9:	a1 20 30 80 00       	mov    0x803020,%eax
  801cbe:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801cc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cc7:	39 c2                	cmp    %eax,%edx
  801cc9:	77 c8                	ja     801c93 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cce:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801cd1:	74 14                	je     801ce7 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801cd3:	83 ec 04             	sub    $0x4,%esp
  801cd6:	68 00 26 80 00       	push   $0x802600
  801cdb:	6a 44                	push   $0x44
  801cdd:	68 a0 25 80 00       	push   $0x8025a0
  801ce2:	e8 15 fe ff ff       	call   801afc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801ce7:	90                   	nop
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    
  801cea:	66 90                	xchg   %ax,%ax

00801cec <__udivdi3>:
  801cec:	55                   	push   %ebp
  801ced:	57                   	push   %edi
  801cee:	56                   	push   %esi
  801cef:	53                   	push   %ebx
  801cf0:	83 ec 1c             	sub    $0x1c,%esp
  801cf3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801cf7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801cfb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d03:	89 ca                	mov    %ecx,%edx
  801d05:	89 f8                	mov    %edi,%eax
  801d07:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d0b:	85 f6                	test   %esi,%esi
  801d0d:	75 2d                	jne    801d3c <__udivdi3+0x50>
  801d0f:	39 cf                	cmp    %ecx,%edi
  801d11:	77 65                	ja     801d78 <__udivdi3+0x8c>
  801d13:	89 fd                	mov    %edi,%ebp
  801d15:	85 ff                	test   %edi,%edi
  801d17:	75 0b                	jne    801d24 <__udivdi3+0x38>
  801d19:	b8 01 00 00 00       	mov    $0x1,%eax
  801d1e:	31 d2                	xor    %edx,%edx
  801d20:	f7 f7                	div    %edi
  801d22:	89 c5                	mov    %eax,%ebp
  801d24:	31 d2                	xor    %edx,%edx
  801d26:	89 c8                	mov    %ecx,%eax
  801d28:	f7 f5                	div    %ebp
  801d2a:	89 c1                	mov    %eax,%ecx
  801d2c:	89 d8                	mov    %ebx,%eax
  801d2e:	f7 f5                	div    %ebp
  801d30:	89 cf                	mov    %ecx,%edi
  801d32:	89 fa                	mov    %edi,%edx
  801d34:	83 c4 1c             	add    $0x1c,%esp
  801d37:	5b                   	pop    %ebx
  801d38:	5e                   	pop    %esi
  801d39:	5f                   	pop    %edi
  801d3a:	5d                   	pop    %ebp
  801d3b:	c3                   	ret    
  801d3c:	39 ce                	cmp    %ecx,%esi
  801d3e:	77 28                	ja     801d68 <__udivdi3+0x7c>
  801d40:	0f bd fe             	bsr    %esi,%edi
  801d43:	83 f7 1f             	xor    $0x1f,%edi
  801d46:	75 40                	jne    801d88 <__udivdi3+0x9c>
  801d48:	39 ce                	cmp    %ecx,%esi
  801d4a:	72 0a                	jb     801d56 <__udivdi3+0x6a>
  801d4c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801d50:	0f 87 9e 00 00 00    	ja     801df4 <__udivdi3+0x108>
  801d56:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5b:	89 fa                	mov    %edi,%edx
  801d5d:	83 c4 1c             	add    $0x1c,%esp
  801d60:	5b                   	pop    %ebx
  801d61:	5e                   	pop    %esi
  801d62:	5f                   	pop    %edi
  801d63:	5d                   	pop    %ebp
  801d64:	c3                   	ret    
  801d65:	8d 76 00             	lea    0x0(%esi),%esi
  801d68:	31 ff                	xor    %edi,%edi
  801d6a:	31 c0                	xor    %eax,%eax
  801d6c:	89 fa                	mov    %edi,%edx
  801d6e:	83 c4 1c             	add    $0x1c,%esp
  801d71:	5b                   	pop    %ebx
  801d72:	5e                   	pop    %esi
  801d73:	5f                   	pop    %edi
  801d74:	5d                   	pop    %ebp
  801d75:	c3                   	ret    
  801d76:	66 90                	xchg   %ax,%ax
  801d78:	89 d8                	mov    %ebx,%eax
  801d7a:	f7 f7                	div    %edi
  801d7c:	31 ff                	xor    %edi,%edi
  801d7e:	89 fa                	mov    %edi,%edx
  801d80:	83 c4 1c             	add    $0x1c,%esp
  801d83:	5b                   	pop    %ebx
  801d84:	5e                   	pop    %esi
  801d85:	5f                   	pop    %edi
  801d86:	5d                   	pop    %ebp
  801d87:	c3                   	ret    
  801d88:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d8d:	89 eb                	mov    %ebp,%ebx
  801d8f:	29 fb                	sub    %edi,%ebx
  801d91:	89 f9                	mov    %edi,%ecx
  801d93:	d3 e6                	shl    %cl,%esi
  801d95:	89 c5                	mov    %eax,%ebp
  801d97:	88 d9                	mov    %bl,%cl
  801d99:	d3 ed                	shr    %cl,%ebp
  801d9b:	89 e9                	mov    %ebp,%ecx
  801d9d:	09 f1                	or     %esi,%ecx
  801d9f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801da3:	89 f9                	mov    %edi,%ecx
  801da5:	d3 e0                	shl    %cl,%eax
  801da7:	89 c5                	mov    %eax,%ebp
  801da9:	89 d6                	mov    %edx,%esi
  801dab:	88 d9                	mov    %bl,%cl
  801dad:	d3 ee                	shr    %cl,%esi
  801daf:	89 f9                	mov    %edi,%ecx
  801db1:	d3 e2                	shl    %cl,%edx
  801db3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801db7:	88 d9                	mov    %bl,%cl
  801db9:	d3 e8                	shr    %cl,%eax
  801dbb:	09 c2                	or     %eax,%edx
  801dbd:	89 d0                	mov    %edx,%eax
  801dbf:	89 f2                	mov    %esi,%edx
  801dc1:	f7 74 24 0c          	divl   0xc(%esp)
  801dc5:	89 d6                	mov    %edx,%esi
  801dc7:	89 c3                	mov    %eax,%ebx
  801dc9:	f7 e5                	mul    %ebp
  801dcb:	39 d6                	cmp    %edx,%esi
  801dcd:	72 19                	jb     801de8 <__udivdi3+0xfc>
  801dcf:	74 0b                	je     801ddc <__udivdi3+0xf0>
  801dd1:	89 d8                	mov    %ebx,%eax
  801dd3:	31 ff                	xor    %edi,%edi
  801dd5:	e9 58 ff ff ff       	jmp    801d32 <__udivdi3+0x46>
  801dda:	66 90                	xchg   %ax,%ax
  801ddc:	8b 54 24 08          	mov    0x8(%esp),%edx
  801de0:	89 f9                	mov    %edi,%ecx
  801de2:	d3 e2                	shl    %cl,%edx
  801de4:	39 c2                	cmp    %eax,%edx
  801de6:	73 e9                	jae    801dd1 <__udivdi3+0xe5>
  801de8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801deb:	31 ff                	xor    %edi,%edi
  801ded:	e9 40 ff ff ff       	jmp    801d32 <__udivdi3+0x46>
  801df2:	66 90                	xchg   %ax,%ax
  801df4:	31 c0                	xor    %eax,%eax
  801df6:	e9 37 ff ff ff       	jmp    801d32 <__udivdi3+0x46>
  801dfb:	90                   	nop

00801dfc <__umoddi3>:
  801dfc:	55                   	push   %ebp
  801dfd:	57                   	push   %edi
  801dfe:	56                   	push   %esi
  801dff:	53                   	push   %ebx
  801e00:	83 ec 1c             	sub    $0x1c,%esp
  801e03:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e07:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e0b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e0f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e13:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e17:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e1b:	89 f3                	mov    %esi,%ebx
  801e1d:	89 fa                	mov    %edi,%edx
  801e1f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e23:	89 34 24             	mov    %esi,(%esp)
  801e26:	85 c0                	test   %eax,%eax
  801e28:	75 1a                	jne    801e44 <__umoddi3+0x48>
  801e2a:	39 f7                	cmp    %esi,%edi
  801e2c:	0f 86 a2 00 00 00    	jbe    801ed4 <__umoddi3+0xd8>
  801e32:	89 c8                	mov    %ecx,%eax
  801e34:	89 f2                	mov    %esi,%edx
  801e36:	f7 f7                	div    %edi
  801e38:	89 d0                	mov    %edx,%eax
  801e3a:	31 d2                	xor    %edx,%edx
  801e3c:	83 c4 1c             	add    $0x1c,%esp
  801e3f:	5b                   	pop    %ebx
  801e40:	5e                   	pop    %esi
  801e41:	5f                   	pop    %edi
  801e42:	5d                   	pop    %ebp
  801e43:	c3                   	ret    
  801e44:	39 f0                	cmp    %esi,%eax
  801e46:	0f 87 ac 00 00 00    	ja     801ef8 <__umoddi3+0xfc>
  801e4c:	0f bd e8             	bsr    %eax,%ebp
  801e4f:	83 f5 1f             	xor    $0x1f,%ebp
  801e52:	0f 84 ac 00 00 00    	je     801f04 <__umoddi3+0x108>
  801e58:	bf 20 00 00 00       	mov    $0x20,%edi
  801e5d:	29 ef                	sub    %ebp,%edi
  801e5f:	89 fe                	mov    %edi,%esi
  801e61:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e65:	89 e9                	mov    %ebp,%ecx
  801e67:	d3 e0                	shl    %cl,%eax
  801e69:	89 d7                	mov    %edx,%edi
  801e6b:	89 f1                	mov    %esi,%ecx
  801e6d:	d3 ef                	shr    %cl,%edi
  801e6f:	09 c7                	or     %eax,%edi
  801e71:	89 e9                	mov    %ebp,%ecx
  801e73:	d3 e2                	shl    %cl,%edx
  801e75:	89 14 24             	mov    %edx,(%esp)
  801e78:	89 d8                	mov    %ebx,%eax
  801e7a:	d3 e0                	shl    %cl,%eax
  801e7c:	89 c2                	mov    %eax,%edx
  801e7e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e82:	d3 e0                	shl    %cl,%eax
  801e84:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e88:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e8c:	89 f1                	mov    %esi,%ecx
  801e8e:	d3 e8                	shr    %cl,%eax
  801e90:	09 d0                	or     %edx,%eax
  801e92:	d3 eb                	shr    %cl,%ebx
  801e94:	89 da                	mov    %ebx,%edx
  801e96:	f7 f7                	div    %edi
  801e98:	89 d3                	mov    %edx,%ebx
  801e9a:	f7 24 24             	mull   (%esp)
  801e9d:	89 c6                	mov    %eax,%esi
  801e9f:	89 d1                	mov    %edx,%ecx
  801ea1:	39 d3                	cmp    %edx,%ebx
  801ea3:	0f 82 87 00 00 00    	jb     801f30 <__umoddi3+0x134>
  801ea9:	0f 84 91 00 00 00    	je     801f40 <__umoddi3+0x144>
  801eaf:	8b 54 24 04          	mov    0x4(%esp),%edx
  801eb3:	29 f2                	sub    %esi,%edx
  801eb5:	19 cb                	sbb    %ecx,%ebx
  801eb7:	89 d8                	mov    %ebx,%eax
  801eb9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ebd:	d3 e0                	shl    %cl,%eax
  801ebf:	89 e9                	mov    %ebp,%ecx
  801ec1:	d3 ea                	shr    %cl,%edx
  801ec3:	09 d0                	or     %edx,%eax
  801ec5:	89 e9                	mov    %ebp,%ecx
  801ec7:	d3 eb                	shr    %cl,%ebx
  801ec9:	89 da                	mov    %ebx,%edx
  801ecb:	83 c4 1c             	add    $0x1c,%esp
  801ece:	5b                   	pop    %ebx
  801ecf:	5e                   	pop    %esi
  801ed0:	5f                   	pop    %edi
  801ed1:	5d                   	pop    %ebp
  801ed2:	c3                   	ret    
  801ed3:	90                   	nop
  801ed4:	89 fd                	mov    %edi,%ebp
  801ed6:	85 ff                	test   %edi,%edi
  801ed8:	75 0b                	jne    801ee5 <__umoddi3+0xe9>
  801eda:	b8 01 00 00 00       	mov    $0x1,%eax
  801edf:	31 d2                	xor    %edx,%edx
  801ee1:	f7 f7                	div    %edi
  801ee3:	89 c5                	mov    %eax,%ebp
  801ee5:	89 f0                	mov    %esi,%eax
  801ee7:	31 d2                	xor    %edx,%edx
  801ee9:	f7 f5                	div    %ebp
  801eeb:	89 c8                	mov    %ecx,%eax
  801eed:	f7 f5                	div    %ebp
  801eef:	89 d0                	mov    %edx,%eax
  801ef1:	e9 44 ff ff ff       	jmp    801e3a <__umoddi3+0x3e>
  801ef6:	66 90                	xchg   %ax,%ax
  801ef8:	89 c8                	mov    %ecx,%eax
  801efa:	89 f2                	mov    %esi,%edx
  801efc:	83 c4 1c             	add    $0x1c,%esp
  801eff:	5b                   	pop    %ebx
  801f00:	5e                   	pop    %esi
  801f01:	5f                   	pop    %edi
  801f02:	5d                   	pop    %ebp
  801f03:	c3                   	ret    
  801f04:	3b 04 24             	cmp    (%esp),%eax
  801f07:	72 06                	jb     801f0f <__umoddi3+0x113>
  801f09:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801f0d:	77 0f                	ja     801f1e <__umoddi3+0x122>
  801f0f:	89 f2                	mov    %esi,%edx
  801f11:	29 f9                	sub    %edi,%ecx
  801f13:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f17:	89 14 24             	mov    %edx,(%esp)
  801f1a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f1e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f22:	8b 14 24             	mov    (%esp),%edx
  801f25:	83 c4 1c             	add    $0x1c,%esp
  801f28:	5b                   	pop    %ebx
  801f29:	5e                   	pop    %esi
  801f2a:	5f                   	pop    %edi
  801f2b:	5d                   	pop    %ebp
  801f2c:	c3                   	ret    
  801f2d:	8d 76 00             	lea    0x0(%esi),%esi
  801f30:	2b 04 24             	sub    (%esp),%eax
  801f33:	19 fa                	sbb    %edi,%edx
  801f35:	89 d1                	mov    %edx,%ecx
  801f37:	89 c6                	mov    %eax,%esi
  801f39:	e9 71 ff ff ff       	jmp    801eaf <__umoddi3+0xb3>
  801f3e:	66 90                	xchg   %ax,%ax
  801f40:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801f44:	72 ea                	jb     801f30 <__umoddi3+0x134>
  801f46:	89 d9                	mov    %ebx,%ecx
  801f48:	e9 62 ff ff ff       	jmp    801eaf <__umoddi3+0xb3>

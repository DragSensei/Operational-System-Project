
obj/user/dummy_process:     file format elf32-i386


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
  800031:	e8 97 00 00 00       	call   8000cd <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void high_complexity_function();

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 08             	sub    $0x8,%esp
	high_complexity_function() ;
  80003e:	e8 03 00 00 00       	call   800046 <high_complexity_function>
	return;
  800043:	90                   	nop
}
  800044:	c9                   	leave  
  800045:	c3                   	ret    

00800046 <high_complexity_function>:

void high_complexity_function()
{
  800046:	55                   	push   %ebp
  800047:	89 e5                	mov    %esp,%ebp
  800049:	83 ec 40             	sub    $0x40,%esp

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  80004c:	0f 31                	rdtsc  
  80004e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800051:	89 55 d8             	mov    %edx,-0x28(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  800054:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800057:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80005a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80005d:	89 55 e0             	mov    %edx,-0x20(%ebp)
	uint32 end1 = RANDU(0, 5000);
  800060:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800063:	b9 88 13 00 00       	mov    $0x1388,%ecx
  800068:	ba 00 00 00 00       	mov    $0x0,%edx
  80006d:	f7 f1                	div    %ecx
  80006f:	89 55 f0             	mov    %edx,-0x10(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  800072:	0f 31                	rdtsc  
  800074:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800077:	89 55 d0             	mov    %edx,-0x30(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  80007a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80007d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800080:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800083:	89 55 e8             	mov    %edx,-0x18(%ebp)
	uint32 end2 = RANDU(0, 5000);
  800086:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800089:	b9 88 13 00 00       	mov    $0x1388,%ecx
  80008e:	ba 00 00 00 00       	mov    $0x0,%edx
  800093:	f7 f1                	div    %ecx
  800095:	89 55 ec             	mov    %edx,-0x14(%ebp)
	int x = 10;
  800098:	c7 45 fc 0a 00 00 00 	movl   $0xa,-0x4(%ebp)
	for(int i = 0; i <= end1; i++)
  80009f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8000a6:	eb 1a                	jmp    8000c2 <high_complexity_function+0x7c>
	{
		for(int i = 0; i <= end2; i++)
  8000a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000af:	eb 06                	jmp    8000b7 <high_complexity_function+0x71>
		{
			{
				 x++;
  8000b1:	ff 45 fc             	incl   -0x4(%ebp)
	uint32 end1 = RANDU(0, 5000);
	uint32 end2 = RANDU(0, 5000);
	int x = 10;
	for(int i = 0; i <= end1; i++)
	{
		for(int i = 0; i <= end2; i++)
  8000b4:	ff 45 f4             	incl   -0xc(%ebp)
  8000b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000ba:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8000bd:	76 f2                	jbe    8000b1 <high_complexity_function+0x6b>
void high_complexity_function()
{
	uint32 end1 = RANDU(0, 5000);
	uint32 end2 = RANDU(0, 5000);
	int x = 10;
	for(int i = 0; i <= end1; i++)
  8000bf:	ff 45 f8             	incl   -0x8(%ebp)
  8000c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8000c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000c8:	76 de                	jbe    8000a8 <high_complexity_function+0x62>
			{
				 x++;
			}
		}
	}
}
  8000ca:	90                   	nop
  8000cb:	c9                   	leave  
  8000cc:	c3                   	ret    

008000cd <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000cd:	55                   	push   %ebp
  8000ce:	89 e5                	mov    %esp,%ebp
  8000d0:	57                   	push   %edi
  8000d1:	56                   	push   %esi
  8000d2:	53                   	push   %ebx
  8000d3:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000d6:	e8 4f 14 00 00       	call   80152a <sys_getenvindex>
  8000db:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000e1:	89 d0                	mov    %edx,%eax
  8000e3:	c1 e0 02             	shl    $0x2,%eax
  8000e6:	01 d0                	add    %edx,%eax
  8000e8:	c1 e0 03             	shl    $0x3,%eax
  8000eb:	01 d0                	add    %edx,%eax
  8000ed:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8000f4:	01 d0                	add    %edx,%eax
  8000f6:	c1 e0 02             	shl    $0x2,%eax
  8000f9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000fe:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800103:	a1 20 30 80 00       	mov    0x803020,%eax
  800108:	8a 40 20             	mov    0x20(%eax),%al
  80010b:	84 c0                	test   %al,%al
  80010d:	74 0d                	je     80011c <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80010f:	a1 20 30 80 00       	mov    0x803020,%eax
  800114:	83 c0 20             	add    $0x20,%eax
  800117:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80011c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800120:	7e 0a                	jle    80012c <libmain+0x5f>
		binaryname = argv[0];
  800122:	8b 45 0c             	mov    0xc(%ebp),%eax
  800125:	8b 00                	mov    (%eax),%eax
  800127:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80012c:	83 ec 08             	sub    $0x8,%esp
  80012f:	ff 75 0c             	pushl  0xc(%ebp)
  800132:	ff 75 08             	pushl  0x8(%ebp)
  800135:	e8 fe fe ff ff       	call   800038 <_main>
  80013a:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80013d:	a1 00 30 80 00       	mov    0x803000,%eax
  800142:	85 c0                	test   %eax,%eax
  800144:	0f 84 01 01 00 00    	je     80024b <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80014a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800150:	bb 38 1d 80 00       	mov    $0x801d38,%ebx
  800155:	ba 0e 00 00 00       	mov    $0xe,%edx
  80015a:	89 c7                	mov    %eax,%edi
  80015c:	89 de                	mov    %ebx,%esi
  80015e:	89 d1                	mov    %edx,%ecx
  800160:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800162:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800165:	b9 56 00 00 00       	mov    $0x56,%ecx
  80016a:	b0 00                	mov    $0x0,%al
  80016c:	89 d7                	mov    %edx,%edi
  80016e:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800170:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800177:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80017a:	83 ec 08             	sub    $0x8,%esp
  80017d:	50                   	push   %eax
  80017e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800184:	50                   	push   %eax
  800185:	e8 d6 15 00 00       	call   801760 <sys_utilities>
  80018a:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80018d:	e8 1f 11 00 00       	call   8012b1 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800192:	83 ec 0c             	sub    $0xc,%esp
  800195:	68 58 1c 80 00       	push   $0x801c58
  80019a:	e8 be 01 00 00       	call   80035d <cprintf>
  80019f:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a5:	85 c0                	test   %eax,%eax
  8001a7:	74 18                	je     8001c1 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001a9:	e8 d0 15 00 00       	call   80177e <sys_get_optimal_num_faults>
  8001ae:	83 ec 08             	sub    $0x8,%esp
  8001b1:	50                   	push   %eax
  8001b2:	68 80 1c 80 00       	push   $0x801c80
  8001b7:	e8 a1 01 00 00       	call   80035d <cprintf>
  8001bc:	83 c4 10             	add    $0x10,%esp
  8001bf:	eb 59                	jmp    80021a <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c1:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c6:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8001cc:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d1:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8001d7:	83 ec 04             	sub    $0x4,%esp
  8001da:	52                   	push   %edx
  8001db:	50                   	push   %eax
  8001dc:	68 a4 1c 80 00       	push   $0x801ca4
  8001e1:	e8 77 01 00 00       	call   80035d <cprintf>
  8001e6:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e9:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ee:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8001f4:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f9:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8001ff:	a1 20 30 80 00       	mov    0x803020,%eax
  800204:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80020a:	51                   	push   %ecx
  80020b:	52                   	push   %edx
  80020c:	50                   	push   %eax
  80020d:	68 cc 1c 80 00       	push   $0x801ccc
  800212:	e8 46 01 00 00       	call   80035d <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80021a:	a1 20 30 80 00       	mov    0x803020,%eax
  80021f:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	50                   	push   %eax
  800229:	68 24 1d 80 00       	push   $0x801d24
  80022e:	e8 2a 01 00 00       	call   80035d <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 58 1c 80 00       	push   $0x801c58
  80023e:	e8 1a 01 00 00       	call   80035d <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800246:	e8 80 10 00 00       	call   8012cb <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80024b:	e8 1f 00 00 00       	call   80026f <exit>
}
  800250:	90                   	nop
  800251:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800254:	5b                   	pop    %ebx
  800255:	5e                   	pop    %esi
  800256:	5f                   	pop    %edi
  800257:	5d                   	pop    %ebp
  800258:	c3                   	ret    

00800259 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
  80025c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80025f:	83 ec 0c             	sub    $0xc,%esp
  800262:	6a 00                	push   $0x0
  800264:	e8 8d 12 00 00       	call   8014f6 <sys_destroy_env>
  800269:	83 c4 10             	add    $0x10,%esp
}
  80026c:	90                   	nop
  80026d:	c9                   	leave  
  80026e:	c3                   	ret    

0080026f <exit>:

void
exit(void)
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800275:	e8 e2 12 00 00       	call   80155c <sys_exit_env>
}
  80027a:	90                   	nop
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	53                   	push   %ebx
  800281:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800284:	8b 45 0c             	mov    0xc(%ebp),%eax
  800287:	8b 00                	mov    (%eax),%eax
  800289:	8d 48 01             	lea    0x1(%eax),%ecx
  80028c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028f:	89 0a                	mov    %ecx,(%edx)
  800291:	8b 55 08             	mov    0x8(%ebp),%edx
  800294:	88 d1                	mov    %dl,%cl
  800296:	8b 55 0c             	mov    0xc(%ebp),%edx
  800299:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80029d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a0:	8b 00                	mov    (%eax),%eax
  8002a2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002a7:	75 30                	jne    8002d9 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8002a9:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8002af:	a0 44 30 80 00       	mov    0x803044,%al
  8002b4:	0f b6 c0             	movzbl %al,%eax
  8002b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ba:	8b 09                	mov    (%ecx),%ecx
  8002bc:	89 cb                	mov    %ecx,%ebx
  8002be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c1:	83 c1 08             	add    $0x8,%ecx
  8002c4:	52                   	push   %edx
  8002c5:	50                   	push   %eax
  8002c6:	53                   	push   %ebx
  8002c7:	51                   	push   %ecx
  8002c8:	e8 a0 0f 00 00       	call   80126d <sys_cputs>
  8002cd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002dc:	8b 40 04             	mov    0x4(%eax),%eax
  8002df:	8d 50 01             	lea    0x1(%eax),%edx
  8002e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002e8:	90                   	nop
  8002e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002ec:	c9                   	leave  
  8002ed:	c3                   	ret    

008002ee <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002f7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002fe:	00 00 00 
	b.cnt = 0;
  800301:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800308:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80030b:	ff 75 0c             	pushl  0xc(%ebp)
  80030e:	ff 75 08             	pushl  0x8(%ebp)
  800311:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800317:	50                   	push   %eax
  800318:	68 7d 02 80 00       	push   $0x80027d
  80031d:	e8 5a 02 00 00       	call   80057c <vprintfmt>
  800322:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800325:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  80032b:	a0 44 30 80 00       	mov    0x803044,%al
  800330:	0f b6 c0             	movzbl %al,%eax
  800333:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800339:	52                   	push   %edx
  80033a:	50                   	push   %eax
  80033b:	51                   	push   %ecx
  80033c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800342:	83 c0 08             	add    $0x8,%eax
  800345:	50                   	push   %eax
  800346:	e8 22 0f 00 00       	call   80126d <sys_cputs>
  80034b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80034e:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800355:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80035b:	c9                   	leave  
  80035c:	c3                   	ret    

0080035d <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80035d:	55                   	push   %ebp
  80035e:	89 e5                	mov    %esp,%ebp
  800360:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800363:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80036a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80036d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800370:	8b 45 08             	mov    0x8(%ebp),%eax
  800373:	83 ec 08             	sub    $0x8,%esp
  800376:	ff 75 f4             	pushl  -0xc(%ebp)
  800379:	50                   	push   %eax
  80037a:	e8 6f ff ff ff       	call   8002ee <vcprintf>
  80037f:	83 c4 10             	add    $0x10,%esp
  800382:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800385:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800388:	c9                   	leave  
  800389:	c3                   	ret    

0080038a <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80038a:	55                   	push   %ebp
  80038b:	89 e5                	mov    %esp,%ebp
  80038d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800390:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800397:	8b 45 08             	mov    0x8(%ebp),%eax
  80039a:	c1 e0 08             	shl    $0x8,%eax
  80039d:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  8003a2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003a5:	83 c0 04             	add    $0x4,%eax
  8003a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ae:	83 ec 08             	sub    $0x8,%esp
  8003b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8003b4:	50                   	push   %eax
  8003b5:	e8 34 ff ff ff       	call   8002ee <vcprintf>
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8003c0:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  8003c7:	07 00 00 

	return cnt;
  8003ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003cd:	c9                   	leave  
  8003ce:	c3                   	ret    

008003cf <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003cf:	55                   	push   %ebp
  8003d0:	89 e5                	mov    %esp,%ebp
  8003d2:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003d5:	e8 d7 0e 00 00       	call   8012b1 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8003da:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8003e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e3:	83 ec 08             	sub    $0x8,%esp
  8003e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e9:	50                   	push   %eax
  8003ea:	e8 ff fe ff ff       	call   8002ee <vcprintf>
  8003ef:	83 c4 10             	add    $0x10,%esp
  8003f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8003f5:	e8 d1 0e 00 00       	call   8012cb <sys_unlock_cons>
	return cnt;
  8003fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003fd:	c9                   	leave  
  8003fe:	c3                   	ret    

008003ff <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003ff:	55                   	push   %ebp
  800400:	89 e5                	mov    %esp,%ebp
  800402:	53                   	push   %ebx
  800403:	83 ec 14             	sub    $0x14,%esp
  800406:	8b 45 10             	mov    0x10(%ebp),%eax
  800409:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80040c:	8b 45 14             	mov    0x14(%ebp),%eax
  80040f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800412:	8b 45 18             	mov    0x18(%ebp),%eax
  800415:	ba 00 00 00 00       	mov    $0x0,%edx
  80041a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80041d:	77 55                	ja     800474 <printnum+0x75>
  80041f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800422:	72 05                	jb     800429 <printnum+0x2a>
  800424:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800427:	77 4b                	ja     800474 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800429:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80042c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80042f:	8b 45 18             	mov    0x18(%ebp),%eax
  800432:	ba 00 00 00 00       	mov    $0x0,%edx
  800437:	52                   	push   %edx
  800438:	50                   	push   %eax
  800439:	ff 75 f4             	pushl  -0xc(%ebp)
  80043c:	ff 75 f0             	pushl  -0x10(%ebp)
  80043f:	e8 98 15 00 00       	call   8019dc <__udivdi3>
  800444:	83 c4 10             	add    $0x10,%esp
  800447:	83 ec 04             	sub    $0x4,%esp
  80044a:	ff 75 20             	pushl  0x20(%ebp)
  80044d:	53                   	push   %ebx
  80044e:	ff 75 18             	pushl  0x18(%ebp)
  800451:	52                   	push   %edx
  800452:	50                   	push   %eax
  800453:	ff 75 0c             	pushl  0xc(%ebp)
  800456:	ff 75 08             	pushl  0x8(%ebp)
  800459:	e8 a1 ff ff ff       	call   8003ff <printnum>
  80045e:	83 c4 20             	add    $0x20,%esp
  800461:	eb 1a                	jmp    80047d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800463:	83 ec 08             	sub    $0x8,%esp
  800466:	ff 75 0c             	pushl  0xc(%ebp)
  800469:	ff 75 20             	pushl  0x20(%ebp)
  80046c:	8b 45 08             	mov    0x8(%ebp),%eax
  80046f:	ff d0                	call   *%eax
  800471:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800474:	ff 4d 1c             	decl   0x1c(%ebp)
  800477:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80047b:	7f e6                	jg     800463 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80047d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800480:	bb 00 00 00 00       	mov    $0x0,%ebx
  800485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800488:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80048b:	53                   	push   %ebx
  80048c:	51                   	push   %ecx
  80048d:	52                   	push   %edx
  80048e:	50                   	push   %eax
  80048f:	e8 58 16 00 00       	call   801aec <__umoddi3>
  800494:	83 c4 10             	add    $0x10,%esp
  800497:	05 b4 1f 80 00       	add    $0x801fb4,%eax
  80049c:	8a 00                	mov    (%eax),%al
  80049e:	0f be c0             	movsbl %al,%eax
  8004a1:	83 ec 08             	sub    $0x8,%esp
  8004a4:	ff 75 0c             	pushl  0xc(%ebp)
  8004a7:	50                   	push   %eax
  8004a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ab:	ff d0                	call   *%eax
  8004ad:	83 c4 10             	add    $0x10,%esp
}
  8004b0:	90                   	nop
  8004b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004b4:	c9                   	leave  
  8004b5:	c3                   	ret    

008004b6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004b6:	55                   	push   %ebp
  8004b7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004b9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004bd:	7e 1c                	jle    8004db <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c2:	8b 00                	mov    (%eax),%eax
  8004c4:	8d 50 08             	lea    0x8(%eax),%edx
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	89 10                	mov    %edx,(%eax)
  8004cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	83 e8 08             	sub    $0x8,%eax
  8004d4:	8b 50 04             	mov    0x4(%eax),%edx
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	eb 40                	jmp    80051b <getuint+0x65>
	else if (lflag)
  8004db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004df:	74 1e                	je     8004ff <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	8d 50 04             	lea    0x4(%eax),%edx
  8004e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ec:	89 10                	mov    %edx,(%eax)
  8004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f1:	8b 00                	mov    (%eax),%eax
  8004f3:	83 e8 04             	sub    $0x4,%eax
  8004f6:	8b 00                	mov    (%eax),%eax
  8004f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8004fd:	eb 1c                	jmp    80051b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	8d 50 04             	lea    0x4(%eax),%edx
  800507:	8b 45 08             	mov    0x8(%ebp),%eax
  80050a:	89 10                	mov    %edx,(%eax)
  80050c:	8b 45 08             	mov    0x8(%ebp),%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	83 e8 04             	sub    $0x4,%eax
  800514:	8b 00                	mov    (%eax),%eax
  800516:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80051b:	5d                   	pop    %ebp
  80051c:	c3                   	ret    

0080051d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80051d:	55                   	push   %ebp
  80051e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800520:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800524:	7e 1c                	jle    800542 <getint+0x25>
		return va_arg(*ap, long long);
  800526:	8b 45 08             	mov    0x8(%ebp),%eax
  800529:	8b 00                	mov    (%eax),%eax
  80052b:	8d 50 08             	lea    0x8(%eax),%edx
  80052e:	8b 45 08             	mov    0x8(%ebp),%eax
  800531:	89 10                	mov    %edx,(%eax)
  800533:	8b 45 08             	mov    0x8(%ebp),%eax
  800536:	8b 00                	mov    (%eax),%eax
  800538:	83 e8 08             	sub    $0x8,%eax
  80053b:	8b 50 04             	mov    0x4(%eax),%edx
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	eb 38                	jmp    80057a <getint+0x5d>
	else if (lflag)
  800542:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800546:	74 1a                	je     800562 <getint+0x45>
		return va_arg(*ap, long);
  800548:	8b 45 08             	mov    0x8(%ebp),%eax
  80054b:	8b 00                	mov    (%eax),%eax
  80054d:	8d 50 04             	lea    0x4(%eax),%edx
  800550:	8b 45 08             	mov    0x8(%ebp),%eax
  800553:	89 10                	mov    %edx,(%eax)
  800555:	8b 45 08             	mov    0x8(%ebp),%eax
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	83 e8 04             	sub    $0x4,%eax
  80055d:	8b 00                	mov    (%eax),%eax
  80055f:	99                   	cltd   
  800560:	eb 18                	jmp    80057a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800562:	8b 45 08             	mov    0x8(%ebp),%eax
  800565:	8b 00                	mov    (%eax),%eax
  800567:	8d 50 04             	lea    0x4(%eax),%edx
  80056a:	8b 45 08             	mov    0x8(%ebp),%eax
  80056d:	89 10                	mov    %edx,(%eax)
  80056f:	8b 45 08             	mov    0x8(%ebp),%eax
  800572:	8b 00                	mov    (%eax),%eax
  800574:	83 e8 04             	sub    $0x4,%eax
  800577:	8b 00                	mov    (%eax),%eax
  800579:	99                   	cltd   
}
  80057a:	5d                   	pop    %ebp
  80057b:	c3                   	ret    

0080057c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80057c:	55                   	push   %ebp
  80057d:	89 e5                	mov    %esp,%ebp
  80057f:	56                   	push   %esi
  800580:	53                   	push   %ebx
  800581:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800584:	eb 17                	jmp    80059d <vprintfmt+0x21>
			if (ch == '\0')
  800586:	85 db                	test   %ebx,%ebx
  800588:	0f 84 c1 03 00 00    	je     80094f <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80058e:	83 ec 08             	sub    $0x8,%esp
  800591:	ff 75 0c             	pushl  0xc(%ebp)
  800594:	53                   	push   %ebx
  800595:	8b 45 08             	mov    0x8(%ebp),%eax
  800598:	ff d0                	call   *%eax
  80059a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80059d:	8b 45 10             	mov    0x10(%ebp),%eax
  8005a0:	8d 50 01             	lea    0x1(%eax),%edx
  8005a3:	89 55 10             	mov    %edx,0x10(%ebp)
  8005a6:	8a 00                	mov    (%eax),%al
  8005a8:	0f b6 d8             	movzbl %al,%ebx
  8005ab:	83 fb 25             	cmp    $0x25,%ebx
  8005ae:	75 d6                	jne    800586 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005b0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005b4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005bb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005c2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005c9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d3:	8d 50 01             	lea    0x1(%eax),%edx
  8005d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8005d9:	8a 00                	mov    (%eax),%al
  8005db:	0f b6 d8             	movzbl %al,%ebx
  8005de:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005e1:	83 f8 5b             	cmp    $0x5b,%eax
  8005e4:	0f 87 3d 03 00 00    	ja     800927 <vprintfmt+0x3ab>
  8005ea:	8b 04 85 d8 1f 80 00 	mov    0x801fd8(,%eax,4),%eax
  8005f1:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005f3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005f7:	eb d7                	jmp    8005d0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005f9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005fd:	eb d1                	jmp    8005d0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005ff:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800606:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800609:	89 d0                	mov    %edx,%eax
  80060b:	c1 e0 02             	shl    $0x2,%eax
  80060e:	01 d0                	add    %edx,%eax
  800610:	01 c0                	add    %eax,%eax
  800612:	01 d8                	add    %ebx,%eax
  800614:	83 e8 30             	sub    $0x30,%eax
  800617:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80061a:	8b 45 10             	mov    0x10(%ebp),%eax
  80061d:	8a 00                	mov    (%eax),%al
  80061f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800622:	83 fb 2f             	cmp    $0x2f,%ebx
  800625:	7e 3e                	jle    800665 <vprintfmt+0xe9>
  800627:	83 fb 39             	cmp    $0x39,%ebx
  80062a:	7f 39                	jg     800665 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80062c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80062f:	eb d5                	jmp    800606 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	83 c0 04             	add    $0x4,%eax
  800637:	89 45 14             	mov    %eax,0x14(%ebp)
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	83 e8 04             	sub    $0x4,%eax
  800640:	8b 00                	mov    (%eax),%eax
  800642:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800645:	eb 1f                	jmp    800666 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800647:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80064b:	79 83                	jns    8005d0 <vprintfmt+0x54>
				width = 0;
  80064d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800654:	e9 77 ff ff ff       	jmp    8005d0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800659:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800660:	e9 6b ff ff ff       	jmp    8005d0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800665:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800666:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80066a:	0f 89 60 ff ff ff    	jns    8005d0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800670:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800673:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800676:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80067d:	e9 4e ff ff ff       	jmp    8005d0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800682:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800685:	e9 46 ff ff ff       	jmp    8005d0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80068a:	8b 45 14             	mov    0x14(%ebp),%eax
  80068d:	83 c0 04             	add    $0x4,%eax
  800690:	89 45 14             	mov    %eax,0x14(%ebp)
  800693:	8b 45 14             	mov    0x14(%ebp),%eax
  800696:	83 e8 04             	sub    $0x4,%eax
  800699:	8b 00                	mov    (%eax),%eax
  80069b:	83 ec 08             	sub    $0x8,%esp
  80069e:	ff 75 0c             	pushl  0xc(%ebp)
  8006a1:	50                   	push   %eax
  8006a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a5:	ff d0                	call   *%eax
  8006a7:	83 c4 10             	add    $0x10,%esp
			break;
  8006aa:	e9 9b 02 00 00       	jmp    80094a <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	83 c0 04             	add    $0x4,%eax
  8006b5:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bb:	83 e8 04             	sub    $0x4,%eax
  8006be:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006c0:	85 db                	test   %ebx,%ebx
  8006c2:	79 02                	jns    8006c6 <vprintfmt+0x14a>
				err = -err;
  8006c4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006c6:	83 fb 64             	cmp    $0x64,%ebx
  8006c9:	7f 0b                	jg     8006d6 <vprintfmt+0x15a>
  8006cb:	8b 34 9d 20 1e 80 00 	mov    0x801e20(,%ebx,4),%esi
  8006d2:	85 f6                	test   %esi,%esi
  8006d4:	75 19                	jne    8006ef <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006d6:	53                   	push   %ebx
  8006d7:	68 c5 1f 80 00       	push   $0x801fc5
  8006dc:	ff 75 0c             	pushl  0xc(%ebp)
  8006df:	ff 75 08             	pushl  0x8(%ebp)
  8006e2:	e8 70 02 00 00       	call   800957 <printfmt>
  8006e7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006ea:	e9 5b 02 00 00       	jmp    80094a <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006ef:	56                   	push   %esi
  8006f0:	68 ce 1f 80 00       	push   $0x801fce
  8006f5:	ff 75 0c             	pushl  0xc(%ebp)
  8006f8:	ff 75 08             	pushl  0x8(%ebp)
  8006fb:	e8 57 02 00 00       	call   800957 <printfmt>
  800700:	83 c4 10             	add    $0x10,%esp
			break;
  800703:	e9 42 02 00 00       	jmp    80094a <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	83 c0 04             	add    $0x4,%eax
  80070e:	89 45 14             	mov    %eax,0x14(%ebp)
  800711:	8b 45 14             	mov    0x14(%ebp),%eax
  800714:	83 e8 04             	sub    $0x4,%eax
  800717:	8b 30                	mov    (%eax),%esi
  800719:	85 f6                	test   %esi,%esi
  80071b:	75 05                	jne    800722 <vprintfmt+0x1a6>
				p = "(null)";
  80071d:	be d1 1f 80 00       	mov    $0x801fd1,%esi
			if (width > 0 && padc != '-')
  800722:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800726:	7e 6d                	jle    800795 <vprintfmt+0x219>
  800728:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80072c:	74 67                	je     800795 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80072e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800731:	83 ec 08             	sub    $0x8,%esp
  800734:	50                   	push   %eax
  800735:	56                   	push   %esi
  800736:	e8 1e 03 00 00       	call   800a59 <strnlen>
  80073b:	83 c4 10             	add    $0x10,%esp
  80073e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800741:	eb 16                	jmp    800759 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800743:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800747:	83 ec 08             	sub    $0x8,%esp
  80074a:	ff 75 0c             	pushl  0xc(%ebp)
  80074d:	50                   	push   %eax
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	ff d0                	call   *%eax
  800753:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800756:	ff 4d e4             	decl   -0x1c(%ebp)
  800759:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80075d:	7f e4                	jg     800743 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80075f:	eb 34                	jmp    800795 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800761:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800765:	74 1c                	je     800783 <vprintfmt+0x207>
  800767:	83 fb 1f             	cmp    $0x1f,%ebx
  80076a:	7e 05                	jle    800771 <vprintfmt+0x1f5>
  80076c:	83 fb 7e             	cmp    $0x7e,%ebx
  80076f:	7e 12                	jle    800783 <vprintfmt+0x207>
					putch('?', putdat);
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 0c             	pushl  0xc(%ebp)
  800777:	6a 3f                	push   $0x3f
  800779:	8b 45 08             	mov    0x8(%ebp),%eax
  80077c:	ff d0                	call   *%eax
  80077e:	83 c4 10             	add    $0x10,%esp
  800781:	eb 0f                	jmp    800792 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800783:	83 ec 08             	sub    $0x8,%esp
  800786:	ff 75 0c             	pushl  0xc(%ebp)
  800789:	53                   	push   %ebx
  80078a:	8b 45 08             	mov    0x8(%ebp),%eax
  80078d:	ff d0                	call   *%eax
  80078f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800792:	ff 4d e4             	decl   -0x1c(%ebp)
  800795:	89 f0                	mov    %esi,%eax
  800797:	8d 70 01             	lea    0x1(%eax),%esi
  80079a:	8a 00                	mov    (%eax),%al
  80079c:	0f be d8             	movsbl %al,%ebx
  80079f:	85 db                	test   %ebx,%ebx
  8007a1:	74 24                	je     8007c7 <vprintfmt+0x24b>
  8007a3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007a7:	78 b8                	js     800761 <vprintfmt+0x1e5>
  8007a9:	ff 4d e0             	decl   -0x20(%ebp)
  8007ac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007b0:	79 af                	jns    800761 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007b2:	eb 13                	jmp    8007c7 <vprintfmt+0x24b>
				putch(' ', putdat);
  8007b4:	83 ec 08             	sub    $0x8,%esp
  8007b7:	ff 75 0c             	pushl  0xc(%ebp)
  8007ba:	6a 20                	push   $0x20
  8007bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bf:	ff d0                	call   *%eax
  8007c1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007c4:	ff 4d e4             	decl   -0x1c(%ebp)
  8007c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007cb:	7f e7                	jg     8007b4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007cd:	e9 78 01 00 00       	jmp    80094a <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007d2:	83 ec 08             	sub    $0x8,%esp
  8007d5:	ff 75 e8             	pushl  -0x18(%ebp)
  8007d8:	8d 45 14             	lea    0x14(%ebp),%eax
  8007db:	50                   	push   %eax
  8007dc:	e8 3c fd ff ff       	call   80051d <getint>
  8007e1:	83 c4 10             	add    $0x10,%esp
  8007e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007f0:	85 d2                	test   %edx,%edx
  8007f2:	79 23                	jns    800817 <vprintfmt+0x29b>
				putch('-', putdat);
  8007f4:	83 ec 08             	sub    $0x8,%esp
  8007f7:	ff 75 0c             	pushl  0xc(%ebp)
  8007fa:	6a 2d                	push   $0x2d
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	ff d0                	call   *%eax
  800801:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800804:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800807:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80080a:	f7 d8                	neg    %eax
  80080c:	83 d2 00             	adc    $0x0,%edx
  80080f:	f7 da                	neg    %edx
  800811:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800814:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800817:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80081e:	e9 bc 00 00 00       	jmp    8008df <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800823:	83 ec 08             	sub    $0x8,%esp
  800826:	ff 75 e8             	pushl  -0x18(%ebp)
  800829:	8d 45 14             	lea    0x14(%ebp),%eax
  80082c:	50                   	push   %eax
  80082d:	e8 84 fc ff ff       	call   8004b6 <getuint>
  800832:	83 c4 10             	add    $0x10,%esp
  800835:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800838:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80083b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800842:	e9 98 00 00 00       	jmp    8008df <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800847:	83 ec 08             	sub    $0x8,%esp
  80084a:	ff 75 0c             	pushl  0xc(%ebp)
  80084d:	6a 58                	push   $0x58
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	ff d0                	call   *%eax
  800854:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800857:	83 ec 08             	sub    $0x8,%esp
  80085a:	ff 75 0c             	pushl  0xc(%ebp)
  80085d:	6a 58                	push   $0x58
  80085f:	8b 45 08             	mov    0x8(%ebp),%eax
  800862:	ff d0                	call   *%eax
  800864:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800867:	83 ec 08             	sub    $0x8,%esp
  80086a:	ff 75 0c             	pushl  0xc(%ebp)
  80086d:	6a 58                	push   $0x58
  80086f:	8b 45 08             	mov    0x8(%ebp),%eax
  800872:	ff d0                	call   *%eax
  800874:	83 c4 10             	add    $0x10,%esp
			break;
  800877:	e9 ce 00 00 00       	jmp    80094a <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80087c:	83 ec 08             	sub    $0x8,%esp
  80087f:	ff 75 0c             	pushl  0xc(%ebp)
  800882:	6a 30                	push   $0x30
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	ff d0                	call   *%eax
  800889:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80088c:	83 ec 08             	sub    $0x8,%esp
  80088f:	ff 75 0c             	pushl  0xc(%ebp)
  800892:	6a 78                	push   $0x78
  800894:	8b 45 08             	mov    0x8(%ebp),%eax
  800897:	ff d0                	call   *%eax
  800899:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	83 c0 04             	add    $0x4,%eax
  8008a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	83 e8 04             	sub    $0x4,%eax
  8008ab:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008b7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008be:	eb 1f                	jmp    8008df <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008c0:	83 ec 08             	sub    $0x8,%esp
  8008c3:	ff 75 e8             	pushl  -0x18(%ebp)
  8008c6:	8d 45 14             	lea    0x14(%ebp),%eax
  8008c9:	50                   	push   %eax
  8008ca:	e8 e7 fb ff ff       	call   8004b6 <getuint>
  8008cf:	83 c4 10             	add    $0x10,%esp
  8008d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008d8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008df:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e6:	83 ec 04             	sub    $0x4,%esp
  8008e9:	52                   	push   %edx
  8008ea:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008ed:	50                   	push   %eax
  8008ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8008f1:	ff 75 f0             	pushl  -0x10(%ebp)
  8008f4:	ff 75 0c             	pushl  0xc(%ebp)
  8008f7:	ff 75 08             	pushl  0x8(%ebp)
  8008fa:	e8 00 fb ff ff       	call   8003ff <printnum>
  8008ff:	83 c4 20             	add    $0x20,%esp
			break;
  800902:	eb 46                	jmp    80094a <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800904:	83 ec 08             	sub    $0x8,%esp
  800907:	ff 75 0c             	pushl  0xc(%ebp)
  80090a:	53                   	push   %ebx
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	ff d0                	call   *%eax
  800910:	83 c4 10             	add    $0x10,%esp
			break;
  800913:	eb 35                	jmp    80094a <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800915:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  80091c:	eb 2c                	jmp    80094a <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80091e:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800925:	eb 23                	jmp    80094a <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800927:	83 ec 08             	sub    $0x8,%esp
  80092a:	ff 75 0c             	pushl  0xc(%ebp)
  80092d:	6a 25                	push   $0x25
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	ff d0                	call   *%eax
  800934:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800937:	ff 4d 10             	decl   0x10(%ebp)
  80093a:	eb 03                	jmp    80093f <vprintfmt+0x3c3>
  80093c:	ff 4d 10             	decl   0x10(%ebp)
  80093f:	8b 45 10             	mov    0x10(%ebp),%eax
  800942:	48                   	dec    %eax
  800943:	8a 00                	mov    (%eax),%al
  800945:	3c 25                	cmp    $0x25,%al
  800947:	75 f3                	jne    80093c <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800949:	90                   	nop
		}
	}
  80094a:	e9 35 fc ff ff       	jmp    800584 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80094f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800950:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800953:	5b                   	pop    %ebx
  800954:	5e                   	pop    %esi
  800955:	5d                   	pop    %ebp
  800956:	c3                   	ret    

00800957 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80095d:	8d 45 10             	lea    0x10(%ebp),%eax
  800960:	83 c0 04             	add    $0x4,%eax
  800963:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800966:	8b 45 10             	mov    0x10(%ebp),%eax
  800969:	ff 75 f4             	pushl  -0xc(%ebp)
  80096c:	50                   	push   %eax
  80096d:	ff 75 0c             	pushl  0xc(%ebp)
  800970:	ff 75 08             	pushl  0x8(%ebp)
  800973:	e8 04 fc ff ff       	call   80057c <vprintfmt>
  800978:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80097b:	90                   	nop
  80097c:	c9                   	leave  
  80097d:	c3                   	ret    

0080097e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800981:	8b 45 0c             	mov    0xc(%ebp),%eax
  800984:	8b 40 08             	mov    0x8(%eax),%eax
  800987:	8d 50 01             	lea    0x1(%eax),%edx
  80098a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800990:	8b 45 0c             	mov    0xc(%ebp),%eax
  800993:	8b 10                	mov    (%eax),%edx
  800995:	8b 45 0c             	mov    0xc(%ebp),%eax
  800998:	8b 40 04             	mov    0x4(%eax),%eax
  80099b:	39 c2                	cmp    %eax,%edx
  80099d:	73 12                	jae    8009b1 <sprintputch+0x33>
		*b->buf++ = ch;
  80099f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a2:	8b 00                	mov    (%eax),%eax
  8009a4:	8d 48 01             	lea    0x1(%eax),%ecx
  8009a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009aa:	89 0a                	mov    %ecx,(%edx)
  8009ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8009af:	88 10                	mov    %dl,(%eax)
}
  8009b1:	90                   	nop
  8009b2:	5d                   	pop    %ebp
  8009b3:	c3                   	ret    

008009b4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	01 d0                	add    %edx,%eax
  8009cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009d9:	74 06                	je     8009e1 <vsnprintf+0x2d>
  8009db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009df:	7f 07                	jg     8009e8 <vsnprintf+0x34>
		return -E_INVAL;
  8009e1:	b8 03 00 00 00       	mov    $0x3,%eax
  8009e6:	eb 20                	jmp    800a08 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009e8:	ff 75 14             	pushl  0x14(%ebp)
  8009eb:	ff 75 10             	pushl  0x10(%ebp)
  8009ee:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009f1:	50                   	push   %eax
  8009f2:	68 7e 09 80 00       	push   $0x80097e
  8009f7:	e8 80 fb ff ff       	call   80057c <vprintfmt>
  8009fc:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a02:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a08:	c9                   	leave  
  800a09:	c3                   	ret    

00800a0a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a10:	8d 45 10             	lea    0x10(%ebp),%eax
  800a13:	83 c0 04             	add    $0x4,%eax
  800a16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a19:	8b 45 10             	mov    0x10(%ebp),%eax
  800a1c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a1f:	50                   	push   %eax
  800a20:	ff 75 0c             	pushl  0xc(%ebp)
  800a23:	ff 75 08             	pushl  0x8(%ebp)
  800a26:	e8 89 ff ff ff       	call   8009b4 <vsnprintf>
  800a2b:	83 c4 10             	add    $0x10,%esp
  800a2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a34:	c9                   	leave  
  800a35:	c3                   	ret    

00800a36 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800a36:	55                   	push   %ebp
  800a37:	89 e5                	mov    %esp,%ebp
  800a39:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a3c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a43:	eb 06                	jmp    800a4b <strlen+0x15>
		n++;
  800a45:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a48:	ff 45 08             	incl   0x8(%ebp)
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	8a 00                	mov    (%eax),%al
  800a50:	84 c0                	test   %al,%al
  800a52:	75 f1                	jne    800a45 <strlen+0xf>
		n++;
	return n;
  800a54:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a57:	c9                   	leave  
  800a58:	c3                   	ret    

00800a59 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a5f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a66:	eb 09                	jmp    800a71 <strnlen+0x18>
		n++;
  800a68:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a6b:	ff 45 08             	incl   0x8(%ebp)
  800a6e:	ff 4d 0c             	decl   0xc(%ebp)
  800a71:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a75:	74 09                	je     800a80 <strnlen+0x27>
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	8a 00                	mov    (%eax),%al
  800a7c:	84 c0                	test   %al,%al
  800a7e:	75 e8                	jne    800a68 <strnlen+0xf>
		n++;
	return n;
  800a80:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a83:	c9                   	leave  
  800a84:	c3                   	ret    

00800a85 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a91:	90                   	nop
  800a92:	8b 45 08             	mov    0x8(%ebp),%eax
  800a95:	8d 50 01             	lea    0x1(%eax),%edx
  800a98:	89 55 08             	mov    %edx,0x8(%ebp)
  800a9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800aa1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800aa4:	8a 12                	mov    (%edx),%dl
  800aa6:	88 10                	mov    %dl,(%eax)
  800aa8:	8a 00                	mov    (%eax),%al
  800aaa:	84 c0                	test   %al,%al
  800aac:	75 e4                	jne    800a92 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800aae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ab1:	c9                   	leave  
  800ab2:	c3                   	ret    

00800ab3 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ab3:	55                   	push   %ebp
  800ab4:	89 e5                	mov    %esp,%ebp
  800ab6:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800abf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ac6:	eb 1f                	jmp    800ae7 <strncpy+0x34>
		*dst++ = *src;
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	8d 50 01             	lea    0x1(%eax),%edx
  800ace:	89 55 08             	mov    %edx,0x8(%ebp)
  800ad1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad4:	8a 12                	mov    (%edx),%dl
  800ad6:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adb:	8a 00                	mov    (%eax),%al
  800add:	84 c0                	test   %al,%al
  800adf:	74 03                	je     800ae4 <strncpy+0x31>
			src++;
  800ae1:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ae4:	ff 45 fc             	incl   -0x4(%ebp)
  800ae7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800aea:	3b 45 10             	cmp    0x10(%ebp),%eax
  800aed:	72 d9                	jb     800ac8 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800aef:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800af2:	c9                   	leave  
  800af3:	c3                   	ret    

00800af4 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b04:	74 30                	je     800b36 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b06:	eb 16                	jmp    800b1e <strlcpy+0x2a>
			*dst++ = *src++;
  800b08:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0b:	8d 50 01             	lea    0x1(%eax),%edx
  800b0e:	89 55 08             	mov    %edx,0x8(%ebp)
  800b11:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b14:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b17:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b1a:	8a 12                	mov    (%edx),%dl
  800b1c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b1e:	ff 4d 10             	decl   0x10(%ebp)
  800b21:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b25:	74 09                	je     800b30 <strlcpy+0x3c>
  800b27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2a:	8a 00                	mov    (%eax),%al
  800b2c:	84 c0                	test   %al,%al
  800b2e:	75 d8                	jne    800b08 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b36:	8b 55 08             	mov    0x8(%ebp),%edx
  800b39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b3c:	29 c2                	sub    %eax,%edx
  800b3e:	89 d0                	mov    %edx,%eax
}
  800b40:	c9                   	leave  
  800b41:	c3                   	ret    

00800b42 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b45:	eb 06                	jmp    800b4d <strcmp+0xb>
		p++, q++;
  800b47:	ff 45 08             	incl   0x8(%ebp)
  800b4a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	8a 00                	mov    (%eax),%al
  800b52:	84 c0                	test   %al,%al
  800b54:	74 0e                	je     800b64 <strcmp+0x22>
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8a 10                	mov    (%eax),%dl
  800b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5e:	8a 00                	mov    (%eax),%al
  800b60:	38 c2                	cmp    %al,%dl
  800b62:	74 e3                	je     800b47 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	8a 00                	mov    (%eax),%al
  800b69:	0f b6 d0             	movzbl %al,%edx
  800b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6f:	8a 00                	mov    (%eax),%al
  800b71:	0f b6 c0             	movzbl %al,%eax
  800b74:	29 c2                	sub    %eax,%edx
  800b76:	89 d0                	mov    %edx,%eax
}
  800b78:	5d                   	pop    %ebp
  800b79:	c3                   	ret    

00800b7a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b7d:	eb 09                	jmp    800b88 <strncmp+0xe>
		n--, p++, q++;
  800b7f:	ff 4d 10             	decl   0x10(%ebp)
  800b82:	ff 45 08             	incl   0x8(%ebp)
  800b85:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b88:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b8c:	74 17                	je     800ba5 <strncmp+0x2b>
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	8a 00                	mov    (%eax),%al
  800b93:	84 c0                	test   %al,%al
  800b95:	74 0e                	je     800ba5 <strncmp+0x2b>
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	8a 10                	mov    (%eax),%dl
  800b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9f:	8a 00                	mov    (%eax),%al
  800ba1:	38 c2                	cmp    %al,%dl
  800ba3:	74 da                	je     800b7f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ba5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ba9:	75 07                	jne    800bb2 <strncmp+0x38>
		return 0;
  800bab:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb0:	eb 14                	jmp    800bc6 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb5:	8a 00                	mov    (%eax),%al
  800bb7:	0f b6 d0             	movzbl %al,%edx
  800bba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbd:	8a 00                	mov    (%eax),%al
  800bbf:	0f b6 c0             	movzbl %al,%eax
  800bc2:	29 c2                	sub    %eax,%edx
  800bc4:	89 d0                	mov    %edx,%eax
}
  800bc6:	5d                   	pop    %ebp
  800bc7:	c3                   	ret    

00800bc8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	83 ec 04             	sub    $0x4,%esp
  800bce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bd4:	eb 12                	jmp    800be8 <strchr+0x20>
		if (*s == c)
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	8a 00                	mov    (%eax),%al
  800bdb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bde:	75 05                	jne    800be5 <strchr+0x1d>
			return (char *) s;
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	eb 11                	jmp    800bf6 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800be5:	ff 45 08             	incl   0x8(%ebp)
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	8a 00                	mov    (%eax),%al
  800bed:	84 c0                	test   %al,%al
  800bef:	75 e5                	jne    800bd6 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bf6:	c9                   	leave  
  800bf7:	c3                   	ret    

00800bf8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	83 ec 04             	sub    $0x4,%esp
  800bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c01:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c04:	eb 0d                	jmp    800c13 <strfind+0x1b>
		if (*s == c)
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	8a 00                	mov    (%eax),%al
  800c0b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c0e:	74 0e                	je     800c1e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c10:	ff 45 08             	incl   0x8(%ebp)
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	8a 00                	mov    (%eax),%al
  800c18:	84 c0                	test   %al,%al
  800c1a:	75 ea                	jne    800c06 <strfind+0xe>
  800c1c:	eb 01                	jmp    800c1f <strfind+0x27>
		if (*s == c)
			break;
  800c1e:	90                   	nop
	return (char *) s;
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800c30:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c34:	76 63                	jbe    800c99 <memset+0x75>
		uint64 data_block = c;
  800c36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c39:	99                   	cltd   
  800c3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3d:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c46:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800c4a:	c1 e0 08             	shl    $0x8,%eax
  800c4d:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c50:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c59:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800c5d:	c1 e0 10             	shl    $0x10,%eax
  800c60:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c63:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800c66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c6c:	89 c2                	mov    %eax,%edx
  800c6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c73:	09 45 f0             	or     %eax,-0x10(%ebp)
  800c76:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800c79:	eb 18                	jmp    800c93 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800c7b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800c7e:	8d 41 08             	lea    0x8(%ecx),%eax
  800c81:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800c84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c8a:	89 01                	mov    %eax,(%ecx)
  800c8c:	89 51 04             	mov    %edx,0x4(%ecx)
  800c8f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800c93:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800c97:	77 e2                	ja     800c7b <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800c99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c9d:	74 23                	je     800cc2 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800c9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ca5:	eb 0e                	jmp    800cb5 <memset+0x91>
			*p8++ = (uint8)c;
  800ca7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800caa:	8d 50 01             	lea    0x1(%eax),%edx
  800cad:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb3:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800cb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cbb:	89 55 10             	mov    %edx,0x10(%ebp)
  800cbe:	85 c0                	test   %eax,%eax
  800cc0:	75 e5                	jne    800ca7 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc5:	c9                   	leave  
  800cc6:	c3                   	ret    

00800cc7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800cd9:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800cdd:	76 24                	jbe    800d03 <memcpy+0x3c>
		while(n >= 8){
  800cdf:	eb 1c                	jmp    800cfd <memcpy+0x36>
			*d64 = *s64;
  800ce1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce4:	8b 50 04             	mov    0x4(%eax),%edx
  800ce7:	8b 00                	mov    (%eax),%eax
  800ce9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800cec:	89 01                	mov    %eax,(%ecx)
  800cee:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800cf1:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800cf5:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800cf9:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800cfd:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d01:	77 de                	ja     800ce1 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800d03:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d07:	74 31                	je     800d3a <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800d09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800d0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d12:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800d15:	eb 16                	jmp    800d2d <memcpy+0x66>
			*d8++ = *s8++;
  800d17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d1a:	8d 50 01             	lea    0x1(%eax),%edx
  800d1d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800d20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d23:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d26:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800d29:	8a 12                	mov    (%edx),%dl
  800d2b:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800d2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d30:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d33:	89 55 10             	mov    %edx,0x10(%ebp)
  800d36:	85 c0                	test   %eax,%eax
  800d38:	75 dd                	jne    800d17 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d3d:	c9                   	leave  
  800d3e:	c3                   	ret    

00800d3f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d48:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d54:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d57:	73 50                	jae    800da9 <memmove+0x6a>
  800d59:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5f:	01 d0                	add    %edx,%eax
  800d61:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d64:	76 43                	jbe    800da9 <memmove+0x6a>
		s += n;
  800d66:	8b 45 10             	mov    0x10(%ebp),%eax
  800d69:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d72:	eb 10                	jmp    800d84 <memmove+0x45>
			*--d = *--s;
  800d74:	ff 4d f8             	decl   -0x8(%ebp)
  800d77:	ff 4d fc             	decl   -0x4(%ebp)
  800d7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d7d:	8a 10                	mov    (%eax),%dl
  800d7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d82:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d84:	8b 45 10             	mov    0x10(%ebp),%eax
  800d87:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d8a:	89 55 10             	mov    %edx,0x10(%ebp)
  800d8d:	85 c0                	test   %eax,%eax
  800d8f:	75 e3                	jne    800d74 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d91:	eb 23                	jmp    800db6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d96:	8d 50 01             	lea    0x1(%eax),%edx
  800d99:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d9c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d9f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800da5:	8a 12                	mov    (%edx),%dl
  800da7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800da9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dac:	8d 50 ff             	lea    -0x1(%eax),%edx
  800daf:	89 55 10             	mov    %edx,0x10(%ebp)
  800db2:	85 c0                	test   %eax,%eax
  800db4:	75 dd                	jne    800d93 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db9:	c9                   	leave  
  800dba:	c3                   	ret    

00800dbb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
  800dbe:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dca:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dcd:	eb 2a                	jmp    800df9 <memcmp+0x3e>
		if (*s1 != *s2)
  800dcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd2:	8a 10                	mov    (%eax),%dl
  800dd4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	38 c2                	cmp    %al,%dl
  800ddb:	74 16                	je     800df3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ddd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de0:	8a 00                	mov    (%eax),%al
  800de2:	0f b6 d0             	movzbl %al,%edx
  800de5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de8:	8a 00                	mov    (%eax),%al
  800dea:	0f b6 c0             	movzbl %al,%eax
  800ded:	29 c2                	sub    %eax,%edx
  800def:	89 d0                	mov    %edx,%eax
  800df1:	eb 18                	jmp    800e0b <memcmp+0x50>
		s1++, s2++;
  800df3:	ff 45 fc             	incl   -0x4(%ebp)
  800df6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800df9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dff:	89 55 10             	mov    %edx,0x10(%ebp)
  800e02:	85 c0                	test   %eax,%eax
  800e04:	75 c9                	jne    800dcf <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e13:	8b 55 08             	mov    0x8(%ebp),%edx
  800e16:	8b 45 10             	mov    0x10(%ebp),%eax
  800e19:	01 d0                	add    %edx,%eax
  800e1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e1e:	eb 15                	jmp    800e35 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	0f b6 d0             	movzbl %al,%edx
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	0f b6 c0             	movzbl %al,%eax
  800e2e:	39 c2                	cmp    %eax,%edx
  800e30:	74 0d                	je     800e3f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e32:	ff 45 08             	incl   0x8(%ebp)
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
  800e38:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e3b:	72 e3                	jb     800e20 <memfind+0x13>
  800e3d:	eb 01                	jmp    800e40 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e3f:	90                   	nop
	return (void *) s;
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e43:	c9                   	leave  
  800e44:	c3                   	ret    

00800e45 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e4b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e52:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e59:	eb 03                	jmp    800e5e <strtol+0x19>
		s++;
  800e5b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	8a 00                	mov    (%eax),%al
  800e63:	3c 20                	cmp    $0x20,%al
  800e65:	74 f4                	je     800e5b <strtol+0x16>
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	8a 00                	mov    (%eax),%al
  800e6c:	3c 09                	cmp    $0x9,%al
  800e6e:	74 eb                	je     800e5b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	8a 00                	mov    (%eax),%al
  800e75:	3c 2b                	cmp    $0x2b,%al
  800e77:	75 05                	jne    800e7e <strtol+0x39>
		s++;
  800e79:	ff 45 08             	incl   0x8(%ebp)
  800e7c:	eb 13                	jmp    800e91 <strtol+0x4c>
	else if (*s == '-')
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	8a 00                	mov    (%eax),%al
  800e83:	3c 2d                	cmp    $0x2d,%al
  800e85:	75 0a                	jne    800e91 <strtol+0x4c>
		s++, neg = 1;
  800e87:	ff 45 08             	incl   0x8(%ebp)
  800e8a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e95:	74 06                	je     800e9d <strtol+0x58>
  800e97:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e9b:	75 20                	jne    800ebd <strtol+0x78>
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	8a 00                	mov    (%eax),%al
  800ea2:	3c 30                	cmp    $0x30,%al
  800ea4:	75 17                	jne    800ebd <strtol+0x78>
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	40                   	inc    %eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	3c 78                	cmp    $0x78,%al
  800eae:	75 0d                	jne    800ebd <strtol+0x78>
		s += 2, base = 16;
  800eb0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800eb4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ebb:	eb 28                	jmp    800ee5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ebd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec1:	75 15                	jne    800ed8 <strtol+0x93>
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	8a 00                	mov    (%eax),%al
  800ec8:	3c 30                	cmp    $0x30,%al
  800eca:	75 0c                	jne    800ed8 <strtol+0x93>
		s++, base = 8;
  800ecc:	ff 45 08             	incl   0x8(%ebp)
  800ecf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ed6:	eb 0d                	jmp    800ee5 <strtol+0xa0>
	else if (base == 0)
  800ed8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800edc:	75 07                	jne    800ee5 <strtol+0xa0>
		base = 10;
  800ede:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	8a 00                	mov    (%eax),%al
  800eea:	3c 2f                	cmp    $0x2f,%al
  800eec:	7e 19                	jle    800f07 <strtol+0xc2>
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	8a 00                	mov    (%eax),%al
  800ef3:	3c 39                	cmp    $0x39,%al
  800ef5:	7f 10                	jg     800f07 <strtol+0xc2>
			dig = *s - '0';
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	8a 00                	mov    (%eax),%al
  800efc:	0f be c0             	movsbl %al,%eax
  800eff:	83 e8 30             	sub    $0x30,%eax
  800f02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f05:	eb 42                	jmp    800f49 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	3c 60                	cmp    $0x60,%al
  800f0e:	7e 19                	jle    800f29 <strtol+0xe4>
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	8a 00                	mov    (%eax),%al
  800f15:	3c 7a                	cmp    $0x7a,%al
  800f17:	7f 10                	jg     800f29 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f19:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	0f be c0             	movsbl %al,%eax
  800f21:	83 e8 57             	sub    $0x57,%eax
  800f24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f27:	eb 20                	jmp    800f49 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	3c 40                	cmp    $0x40,%al
  800f30:	7e 39                	jle    800f6b <strtol+0x126>
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	3c 5a                	cmp    $0x5a,%al
  800f39:	7f 30                	jg     800f6b <strtol+0x126>
			dig = *s - 'A' + 10;
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	8a 00                	mov    (%eax),%al
  800f40:	0f be c0             	movsbl %al,%eax
  800f43:	83 e8 37             	sub    $0x37,%eax
  800f46:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f4c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f4f:	7d 19                	jge    800f6a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f51:	ff 45 08             	incl   0x8(%ebp)
  800f54:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f57:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f5b:	89 c2                	mov    %eax,%edx
  800f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f60:	01 d0                	add    %edx,%eax
  800f62:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f65:	e9 7b ff ff ff       	jmp    800ee5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f6a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f6f:	74 08                	je     800f79 <strtol+0x134>
		*endptr = (char *) s;
  800f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f74:	8b 55 08             	mov    0x8(%ebp),%edx
  800f77:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f79:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f7d:	74 07                	je     800f86 <strtol+0x141>
  800f7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f82:	f7 d8                	neg    %eax
  800f84:	eb 03                	jmp    800f89 <strtol+0x144>
  800f86:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f89:	c9                   	leave  
  800f8a:	c3                   	ret    

00800f8b <ltostr>:

void
ltostr(long value, char *str)
{
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f98:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fa3:	79 13                	jns    800fb8 <ltostr+0x2d>
	{
		neg = 1;
  800fa5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faf:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fb2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fb5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fc0:	99                   	cltd   
  800fc1:	f7 f9                	idiv   %ecx
  800fc3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc9:	8d 50 01             	lea    0x1(%eax),%edx
  800fcc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fcf:	89 c2                	mov    %eax,%edx
  800fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd4:	01 d0                	add    %edx,%eax
  800fd6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fd9:	83 c2 30             	add    $0x30,%edx
  800fdc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fde:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fe1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fe6:	f7 e9                	imul   %ecx
  800fe8:	c1 fa 02             	sar    $0x2,%edx
  800feb:	89 c8                	mov    %ecx,%eax
  800fed:	c1 f8 1f             	sar    $0x1f,%eax
  800ff0:	29 c2                	sub    %eax,%edx
  800ff2:	89 d0                	mov    %edx,%eax
  800ff4:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800ff7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ffb:	75 bb                	jne    800fb8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800ffd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801004:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801007:	48                   	dec    %eax
  801008:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80100b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80100f:	74 3d                	je     80104e <ltostr+0xc3>
		start = 1 ;
  801011:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801018:	eb 34                	jmp    80104e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80101a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80101d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801020:	01 d0                	add    %edx,%eax
  801022:	8a 00                	mov    (%eax),%al
  801024:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801027:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80102a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102d:	01 c2                	add    %eax,%edx
  80102f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801032:	8b 45 0c             	mov    0xc(%ebp),%eax
  801035:	01 c8                	add    %ecx,%eax
  801037:	8a 00                	mov    (%eax),%al
  801039:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80103b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80103e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801041:	01 c2                	add    %eax,%edx
  801043:	8a 45 eb             	mov    -0x15(%ebp),%al
  801046:	88 02                	mov    %al,(%edx)
		start++ ;
  801048:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80104b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80104e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801051:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801054:	7c c4                	jl     80101a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801056:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801059:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105c:	01 d0                	add    %edx,%eax
  80105e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801061:	90                   	nop
  801062:	c9                   	leave  
  801063:	c3                   	ret    

00801064 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
  801067:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80106a:	ff 75 08             	pushl  0x8(%ebp)
  80106d:	e8 c4 f9 ff ff       	call   800a36 <strlen>
  801072:	83 c4 04             	add    $0x4,%esp
  801075:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801078:	ff 75 0c             	pushl  0xc(%ebp)
  80107b:	e8 b6 f9 ff ff       	call   800a36 <strlen>
  801080:	83 c4 04             	add    $0x4,%esp
  801083:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801086:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80108d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801094:	eb 17                	jmp    8010ad <strcconcat+0x49>
		final[s] = str1[s] ;
  801096:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801099:	8b 45 10             	mov    0x10(%ebp),%eax
  80109c:	01 c2                	add    %eax,%edx
  80109e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	01 c8                	add    %ecx,%eax
  8010a6:	8a 00                	mov    (%eax),%al
  8010a8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010aa:	ff 45 fc             	incl   -0x4(%ebp)
  8010ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010b3:	7c e1                	jl     801096 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010c3:	eb 1f                	jmp    8010e4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c8:	8d 50 01             	lea    0x1(%eax),%edx
  8010cb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010ce:	89 c2                	mov    %eax,%edx
  8010d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d3:	01 c2                	add    %eax,%edx
  8010d5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010db:	01 c8                	add    %ecx,%eax
  8010dd:	8a 00                	mov    (%eax),%al
  8010df:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010e1:	ff 45 f8             	incl   -0x8(%ebp)
  8010e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010ea:	7c d9                	jl     8010c5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f2:	01 d0                	add    %edx,%eax
  8010f4:	c6 00 00             	movb   $0x0,(%eax)
}
  8010f7:	90                   	nop
  8010f8:	c9                   	leave  
  8010f9:	c3                   	ret    

008010fa <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8010fa:	55                   	push   %ebp
  8010fb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8010fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801100:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801106:	8b 45 14             	mov    0x14(%ebp),%eax
  801109:	8b 00                	mov    (%eax),%eax
  80110b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801112:	8b 45 10             	mov    0x10(%ebp),%eax
  801115:	01 d0                	add    %edx,%eax
  801117:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80111d:	eb 0c                	jmp    80112b <strsplit+0x31>
			*string++ = 0;
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
  801122:	8d 50 01             	lea    0x1(%eax),%edx
  801125:	89 55 08             	mov    %edx,0x8(%ebp)
  801128:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	8a 00                	mov    (%eax),%al
  801130:	84 c0                	test   %al,%al
  801132:	74 18                	je     80114c <strsplit+0x52>
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	0f be c0             	movsbl %al,%eax
  80113c:	50                   	push   %eax
  80113d:	ff 75 0c             	pushl  0xc(%ebp)
  801140:	e8 83 fa ff ff       	call   800bc8 <strchr>
  801145:	83 c4 08             	add    $0x8,%esp
  801148:	85 c0                	test   %eax,%eax
  80114a:	75 d3                	jne    80111f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	84 c0                	test   %al,%al
  801153:	74 5a                	je     8011af <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801155:	8b 45 14             	mov    0x14(%ebp),%eax
  801158:	8b 00                	mov    (%eax),%eax
  80115a:	83 f8 0f             	cmp    $0xf,%eax
  80115d:	75 07                	jne    801166 <strsplit+0x6c>
		{
			return 0;
  80115f:	b8 00 00 00 00       	mov    $0x0,%eax
  801164:	eb 66                	jmp    8011cc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801166:	8b 45 14             	mov    0x14(%ebp),%eax
  801169:	8b 00                	mov    (%eax),%eax
  80116b:	8d 48 01             	lea    0x1(%eax),%ecx
  80116e:	8b 55 14             	mov    0x14(%ebp),%edx
  801171:	89 0a                	mov    %ecx,(%edx)
  801173:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80117a:	8b 45 10             	mov    0x10(%ebp),%eax
  80117d:	01 c2                	add    %eax,%edx
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801184:	eb 03                	jmp    801189 <strsplit+0x8f>
			string++;
  801186:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	84 c0                	test   %al,%al
  801190:	74 8b                	je     80111d <strsplit+0x23>
  801192:	8b 45 08             	mov    0x8(%ebp),%eax
  801195:	8a 00                	mov    (%eax),%al
  801197:	0f be c0             	movsbl %al,%eax
  80119a:	50                   	push   %eax
  80119b:	ff 75 0c             	pushl  0xc(%ebp)
  80119e:	e8 25 fa ff ff       	call   800bc8 <strchr>
  8011a3:	83 c4 08             	add    $0x8,%esp
  8011a6:	85 c0                	test   %eax,%eax
  8011a8:	74 dc                	je     801186 <strsplit+0x8c>
			string++;
	}
  8011aa:	e9 6e ff ff ff       	jmp    80111d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011af:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b3:	8b 00                	mov    (%eax),%eax
  8011b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bf:	01 d0                	add    %edx,%eax
  8011c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011c7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011cc:	c9                   	leave  
  8011cd:	c3                   	ret    

008011ce <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8011ce:	55                   	push   %ebp
  8011cf:	89 e5                	mov    %esp,%ebp
  8011d1:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8011d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8011da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011e1:	eb 4a                	jmp    80122d <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8011e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	01 c2                	add    %eax,%edx
  8011eb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f1:	01 c8                	add    %ecx,%eax
  8011f3:	8a 00                	mov    (%eax),%al
  8011f5:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8011f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fd:	01 d0                	add    %edx,%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	3c 40                	cmp    $0x40,%al
  801203:	7e 25                	jle    80122a <str2lower+0x5c>
  801205:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120b:	01 d0                	add    %edx,%eax
  80120d:	8a 00                	mov    (%eax),%al
  80120f:	3c 5a                	cmp    $0x5a,%al
  801211:	7f 17                	jg     80122a <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801213:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	01 d0                	add    %edx,%eax
  80121b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80121e:	8b 55 08             	mov    0x8(%ebp),%edx
  801221:	01 ca                	add    %ecx,%edx
  801223:	8a 12                	mov    (%edx),%dl
  801225:	83 c2 20             	add    $0x20,%edx
  801228:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80122a:	ff 45 fc             	incl   -0x4(%ebp)
  80122d:	ff 75 0c             	pushl  0xc(%ebp)
  801230:	e8 01 f8 ff ff       	call   800a36 <strlen>
  801235:	83 c4 04             	add    $0x4,%esp
  801238:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80123b:	7f a6                	jg     8011e3 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80123d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	57                   	push   %edi
  801246:	56                   	push   %esi
  801247:	53                   	push   %ebx
  801248:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
  80124e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801251:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801254:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801257:	8b 7d 18             	mov    0x18(%ebp),%edi
  80125a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80125d:	cd 30                	int    $0x30
  80125f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801262:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801265:	83 c4 10             	add    $0x10,%esp
  801268:	5b                   	pop    %ebx
  801269:	5e                   	pop    %esi
  80126a:	5f                   	pop    %edi
  80126b:	5d                   	pop    %ebp
  80126c:	c3                   	ret    

0080126d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80126d:	55                   	push   %ebp
  80126e:	89 e5                	mov    %esp,%ebp
  801270:	83 ec 04             	sub    $0x4,%esp
  801273:	8b 45 10             	mov    0x10(%ebp),%eax
  801276:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801279:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80127c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
  801283:	6a 00                	push   $0x0
  801285:	51                   	push   %ecx
  801286:	52                   	push   %edx
  801287:	ff 75 0c             	pushl  0xc(%ebp)
  80128a:	50                   	push   %eax
  80128b:	6a 00                	push   $0x0
  80128d:	e8 b0 ff ff ff       	call   801242 <syscall>
  801292:	83 c4 18             	add    $0x18,%esp
}
  801295:	90                   	nop
  801296:	c9                   	leave  
  801297:	c3                   	ret    

00801298 <sys_cgetc>:

int
sys_cgetc(void)
{
  801298:	55                   	push   %ebp
  801299:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80129b:	6a 00                	push   $0x0
  80129d:	6a 00                	push   $0x0
  80129f:	6a 00                	push   $0x0
  8012a1:	6a 00                	push   $0x0
  8012a3:	6a 00                	push   $0x0
  8012a5:	6a 02                	push   $0x2
  8012a7:	e8 96 ff ff ff       	call   801242 <syscall>
  8012ac:	83 c4 18             	add    $0x18,%esp
}
  8012af:	c9                   	leave  
  8012b0:	c3                   	ret    

008012b1 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8012b1:	55                   	push   %ebp
  8012b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8012b4:	6a 00                	push   $0x0
  8012b6:	6a 00                	push   $0x0
  8012b8:	6a 00                	push   $0x0
  8012ba:	6a 00                	push   $0x0
  8012bc:	6a 00                	push   $0x0
  8012be:	6a 03                	push   $0x3
  8012c0:	e8 7d ff ff ff       	call   801242 <syscall>
  8012c5:	83 c4 18             	add    $0x18,%esp
}
  8012c8:	90                   	nop
  8012c9:	c9                   	leave  
  8012ca:	c3                   	ret    

008012cb <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8012cb:	55                   	push   %ebp
  8012cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8012ce:	6a 00                	push   $0x0
  8012d0:	6a 00                	push   $0x0
  8012d2:	6a 00                	push   $0x0
  8012d4:	6a 00                	push   $0x0
  8012d6:	6a 00                	push   $0x0
  8012d8:	6a 04                	push   $0x4
  8012da:	e8 63 ff ff ff       	call   801242 <syscall>
  8012df:	83 c4 18             	add    $0x18,%esp
}
  8012e2:	90                   	nop
  8012e3:	c9                   	leave  
  8012e4:	c3                   	ret    

008012e5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	6a 00                	push   $0x0
  8012f0:	6a 00                	push   $0x0
  8012f2:	6a 00                	push   $0x0
  8012f4:	52                   	push   %edx
  8012f5:	50                   	push   %eax
  8012f6:	6a 08                	push   $0x8
  8012f8:	e8 45 ff ff ff       	call   801242 <syscall>
  8012fd:	83 c4 18             	add    $0x18,%esp
}
  801300:	c9                   	leave  
  801301:	c3                   	ret    

00801302 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801302:	55                   	push   %ebp
  801303:	89 e5                	mov    %esp,%ebp
  801305:	56                   	push   %esi
  801306:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801307:	8b 75 18             	mov    0x18(%ebp),%esi
  80130a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80130d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801310:	8b 55 0c             	mov    0xc(%ebp),%edx
  801313:	8b 45 08             	mov    0x8(%ebp),%eax
  801316:	56                   	push   %esi
  801317:	53                   	push   %ebx
  801318:	51                   	push   %ecx
  801319:	52                   	push   %edx
  80131a:	50                   	push   %eax
  80131b:	6a 09                	push   $0x9
  80131d:	e8 20 ff ff ff       	call   801242 <syscall>
  801322:	83 c4 18             	add    $0x18,%esp
}
  801325:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801328:	5b                   	pop    %ebx
  801329:	5e                   	pop    %esi
  80132a:	5d                   	pop    %ebp
  80132b:	c3                   	ret    

0080132c <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80132f:	6a 00                	push   $0x0
  801331:	6a 00                	push   $0x0
  801333:	6a 00                	push   $0x0
  801335:	6a 00                	push   $0x0
  801337:	ff 75 08             	pushl  0x8(%ebp)
  80133a:	6a 0a                	push   $0xa
  80133c:	e8 01 ff ff ff       	call   801242 <syscall>
  801341:	83 c4 18             	add    $0x18,%esp
}
  801344:	c9                   	leave  
  801345:	c3                   	ret    

00801346 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801346:	55                   	push   %ebp
  801347:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 00                	push   $0x0
  80134f:	ff 75 0c             	pushl  0xc(%ebp)
  801352:	ff 75 08             	pushl  0x8(%ebp)
  801355:	6a 0b                	push   $0xb
  801357:	e8 e6 fe ff ff       	call   801242 <syscall>
  80135c:	83 c4 18             	add    $0x18,%esp
}
  80135f:	c9                   	leave  
  801360:	c3                   	ret    

00801361 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801364:	6a 00                	push   $0x0
  801366:	6a 00                	push   $0x0
  801368:	6a 00                	push   $0x0
  80136a:	6a 00                	push   $0x0
  80136c:	6a 00                	push   $0x0
  80136e:	6a 0c                	push   $0xc
  801370:	e8 cd fe ff ff       	call   801242 <syscall>
  801375:	83 c4 18             	add    $0x18,%esp
}
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80137d:	6a 00                	push   $0x0
  80137f:	6a 00                	push   $0x0
  801381:	6a 00                	push   $0x0
  801383:	6a 00                	push   $0x0
  801385:	6a 00                	push   $0x0
  801387:	6a 0d                	push   $0xd
  801389:	e8 b4 fe ff ff       	call   801242 <syscall>
  80138e:	83 c4 18             	add    $0x18,%esp
}
  801391:	c9                   	leave  
  801392:	c3                   	ret    

00801393 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801396:	6a 00                	push   $0x0
  801398:	6a 00                	push   $0x0
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 0e                	push   $0xe
  8013a2:	e8 9b fe ff ff       	call   801242 <syscall>
  8013a7:	83 c4 18             	add    $0x18,%esp
}
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 0f                	push   $0xf
  8013bb:	e8 82 fe ff ff       	call   801242 <syscall>
  8013c0:	83 c4 18             	add    $0x18,%esp
}
  8013c3:	c9                   	leave  
  8013c4:	c3                   	ret    

008013c5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013c5:	55                   	push   %ebp
  8013c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013c8:	6a 00                	push   $0x0
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 00                	push   $0x0
  8013d0:	ff 75 08             	pushl  0x8(%ebp)
  8013d3:	6a 10                	push   $0x10
  8013d5:	e8 68 fe ff ff       	call   801242 <syscall>
  8013da:	83 c4 18             	add    $0x18,%esp
}
  8013dd:	c9                   	leave  
  8013de:	c3                   	ret    

008013df <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013df:	55                   	push   %ebp
  8013e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 00                	push   $0x0
  8013ec:	6a 11                	push   $0x11
  8013ee:	e8 4f fe ff ff       	call   801242 <syscall>
  8013f3:	83 c4 18             	add    $0x18,%esp
}
  8013f6:	90                   	nop
  8013f7:	c9                   	leave  
  8013f8:	c3                   	ret    

008013f9 <sys_cputc>:

void
sys_cputc(const char c)
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	83 ec 04             	sub    $0x4,%esp
  8013ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801402:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801405:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801409:	6a 00                	push   $0x0
  80140b:	6a 00                	push   $0x0
  80140d:	6a 00                	push   $0x0
  80140f:	6a 00                	push   $0x0
  801411:	50                   	push   %eax
  801412:	6a 01                	push   $0x1
  801414:	e8 29 fe ff ff       	call   801242 <syscall>
  801419:	83 c4 18             	add    $0x18,%esp
}
  80141c:	90                   	nop
  80141d:	c9                   	leave  
  80141e:	c3                   	ret    

0080141f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801422:	6a 00                	push   $0x0
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 14                	push   $0x14
  80142e:	e8 0f fe ff ff       	call   801242 <syscall>
  801433:	83 c4 18             	add    $0x18,%esp
}
  801436:	90                   	nop
  801437:	c9                   	leave  
  801438:	c3                   	ret    

00801439 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
  80143c:	83 ec 04             	sub    $0x4,%esp
  80143f:	8b 45 10             	mov    0x10(%ebp),%eax
  801442:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801445:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801448:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80144c:	8b 45 08             	mov    0x8(%ebp),%eax
  80144f:	6a 00                	push   $0x0
  801451:	51                   	push   %ecx
  801452:	52                   	push   %edx
  801453:	ff 75 0c             	pushl  0xc(%ebp)
  801456:	50                   	push   %eax
  801457:	6a 15                	push   $0x15
  801459:	e8 e4 fd ff ff       	call   801242 <syscall>
  80145e:	83 c4 18             	add    $0x18,%esp
}
  801461:	c9                   	leave  
  801462:	c3                   	ret    

00801463 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801466:	8b 55 0c             	mov    0xc(%ebp),%edx
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	6a 00                	push   $0x0
  801472:	52                   	push   %edx
  801473:	50                   	push   %eax
  801474:	6a 16                	push   $0x16
  801476:	e8 c7 fd ff ff       	call   801242 <syscall>
  80147b:	83 c4 18             	add    $0x18,%esp
}
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801483:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801486:	8b 55 0c             	mov    0xc(%ebp),%edx
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	51                   	push   %ecx
  801491:	52                   	push   %edx
  801492:	50                   	push   %eax
  801493:	6a 17                	push   $0x17
  801495:	e8 a8 fd ff ff       	call   801242 <syscall>
  80149a:	83 c4 18             	add    $0x18,%esp
}
  80149d:	c9                   	leave  
  80149e:	c3                   	ret    

0080149f <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8014a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 00                	push   $0x0
  8014ac:	6a 00                	push   $0x0
  8014ae:	52                   	push   %edx
  8014af:	50                   	push   %eax
  8014b0:	6a 18                	push   $0x18
  8014b2:	e8 8b fd ff ff       	call   801242 <syscall>
  8014b7:	83 c4 18             	add    $0x18,%esp
}
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8014bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c2:	6a 00                	push   $0x0
  8014c4:	ff 75 14             	pushl  0x14(%ebp)
  8014c7:	ff 75 10             	pushl  0x10(%ebp)
  8014ca:	ff 75 0c             	pushl  0xc(%ebp)
  8014cd:	50                   	push   %eax
  8014ce:	6a 19                	push   $0x19
  8014d0:	e8 6d fd ff ff       	call   801242 <syscall>
  8014d5:	83 c4 18             	add    $0x18,%esp
}
  8014d8:	c9                   	leave  
  8014d9:	c3                   	ret    

008014da <sys_run_env>:

void sys_run_env(int32 envId)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8014dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	50                   	push   %eax
  8014e9:	6a 1a                	push   $0x1a
  8014eb:	e8 52 fd ff ff       	call   801242 <syscall>
  8014f0:	83 c4 18             	add    $0x18,%esp
}
  8014f3:	90                   	nop
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	50                   	push   %eax
  801505:	6a 1b                	push   $0x1b
  801507:	e8 36 fd ff ff       	call   801242 <syscall>
  80150c:	83 c4 18             	add    $0x18,%esp
}
  80150f:	c9                   	leave  
  801510:	c3                   	ret    

00801511 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	6a 05                	push   $0x5
  801520:	e8 1d fd ff ff       	call   801242 <syscall>
  801525:	83 c4 18             	add    $0x18,%esp
}
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	6a 06                	push   $0x6
  801539:	e8 04 fd ff ff       	call   801242 <syscall>
  80153e:	83 c4 18             	add    $0x18,%esp
}
  801541:	c9                   	leave  
  801542:	c3                   	ret    

00801543 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	6a 07                	push   $0x7
  801552:	e8 eb fc ff ff       	call   801242 <syscall>
  801557:	83 c4 18             	add    $0x18,%esp
}
  80155a:	c9                   	leave  
  80155b:	c3                   	ret    

0080155c <sys_exit_env>:


void sys_exit_env(void)
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	6a 00                	push   $0x0
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 1c                	push   $0x1c
  80156b:	e8 d2 fc ff ff       	call   801242 <syscall>
  801570:	83 c4 18             	add    $0x18,%esp
}
  801573:	90                   	nop
  801574:	c9                   	leave  
  801575:	c3                   	ret    

00801576 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
  801579:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80157c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80157f:	8d 50 04             	lea    0x4(%eax),%edx
  801582:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	52                   	push   %edx
  80158c:	50                   	push   %eax
  80158d:	6a 1d                	push   $0x1d
  80158f:	e8 ae fc ff ff       	call   801242 <syscall>
  801594:	83 c4 18             	add    $0x18,%esp
	return result;
  801597:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80159a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80159d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015a0:	89 01                	mov    %eax,(%ecx)
  8015a2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8015a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a8:	c9                   	leave  
  8015a9:	c2 04 00             	ret    $0x4

008015ac <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	ff 75 10             	pushl  0x10(%ebp)
  8015b6:	ff 75 0c             	pushl  0xc(%ebp)
  8015b9:	ff 75 08             	pushl  0x8(%ebp)
  8015bc:	6a 13                	push   $0x13
  8015be:	e8 7f fc ff ff       	call   801242 <syscall>
  8015c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8015c6:	90                   	nop
}
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 1e                	push   $0x1e
  8015d8:	e8 65 fc ff ff       	call   801242 <syscall>
  8015dd:	83 c4 18             	add    $0x18,%esp
}
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
  8015e5:	83 ec 04             	sub    $0x4,%esp
  8015e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015eb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015ee:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	50                   	push   %eax
  8015fb:	6a 1f                	push   $0x1f
  8015fd:	e8 40 fc ff ff       	call   801242 <syscall>
  801602:	83 c4 18             	add    $0x18,%esp
	return ;
  801605:	90                   	nop
}
  801606:	c9                   	leave  
  801607:	c3                   	ret    

00801608 <rsttst>:
void rsttst()
{
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	6a 21                	push   $0x21
  801617:	e8 26 fc ff ff       	call   801242 <syscall>
  80161c:	83 c4 18             	add    $0x18,%esp
	return ;
  80161f:	90                   	nop
}
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
  801625:	83 ec 04             	sub    $0x4,%esp
  801628:	8b 45 14             	mov    0x14(%ebp),%eax
  80162b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80162e:	8b 55 18             	mov    0x18(%ebp),%edx
  801631:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801635:	52                   	push   %edx
  801636:	50                   	push   %eax
  801637:	ff 75 10             	pushl  0x10(%ebp)
  80163a:	ff 75 0c             	pushl  0xc(%ebp)
  80163d:	ff 75 08             	pushl  0x8(%ebp)
  801640:	6a 20                	push   $0x20
  801642:	e8 fb fb ff ff       	call   801242 <syscall>
  801647:	83 c4 18             	add    $0x18,%esp
	return ;
  80164a:	90                   	nop
}
  80164b:	c9                   	leave  
  80164c:	c3                   	ret    

0080164d <chktst>:
void chktst(uint32 n)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	ff 75 08             	pushl  0x8(%ebp)
  80165b:	6a 22                	push   $0x22
  80165d:	e8 e0 fb ff ff       	call   801242 <syscall>
  801662:	83 c4 18             	add    $0x18,%esp
	return ;
  801665:	90                   	nop
}
  801666:	c9                   	leave  
  801667:	c3                   	ret    

00801668 <inctst>:

void inctst()
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 23                	push   $0x23
  801677:	e8 c6 fb ff ff       	call   801242 <syscall>
  80167c:	83 c4 18             	add    $0x18,%esp
	return ;
  80167f:	90                   	nop
}
  801680:	c9                   	leave  
  801681:	c3                   	ret    

00801682 <gettst>:
uint32 gettst()
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 24                	push   $0x24
  801691:	e8 ac fb ff ff       	call   801242 <syscall>
  801696:	83 c4 18             	add    $0x18,%esp
}
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 25                	push   $0x25
  8016aa:	e8 93 fb ff ff       	call   801242 <syscall>
  8016af:	83 c4 18             	add    $0x18,%esp
  8016b2:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8016b7:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8016bc:	c9                   	leave  
  8016bd:	c3                   	ret    

008016be <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8016c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c4:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	ff 75 08             	pushl  0x8(%ebp)
  8016d4:	6a 26                	push   $0x26
  8016d6:	e8 67 fb ff ff       	call   801242 <syscall>
  8016db:	83 c4 18             	add    $0x18,%esp
	return ;
  8016de:	90                   	nop
}
  8016df:	c9                   	leave  
  8016e0:	c3                   	ret    

008016e1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
  8016e4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8016e5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f1:	6a 00                	push   $0x0
  8016f3:	53                   	push   %ebx
  8016f4:	51                   	push   %ecx
  8016f5:	52                   	push   %edx
  8016f6:	50                   	push   %eax
  8016f7:	6a 27                	push   $0x27
  8016f9:	e8 44 fb ff ff       	call   801242 <syscall>
  8016fe:	83 c4 18             	add    $0x18,%esp
}
  801701:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801704:	c9                   	leave  
  801705:	c3                   	ret    

00801706 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801709:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170c:	8b 45 08             	mov    0x8(%ebp),%eax
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	52                   	push   %edx
  801716:	50                   	push   %eax
  801717:	6a 28                	push   $0x28
  801719:	e8 24 fb ff ff       	call   801242 <syscall>
  80171e:	83 c4 18             	add    $0x18,%esp
}
  801721:	c9                   	leave  
  801722:	c3                   	ret    

00801723 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801726:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801729:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	6a 00                	push   $0x0
  801731:	51                   	push   %ecx
  801732:	ff 75 10             	pushl  0x10(%ebp)
  801735:	52                   	push   %edx
  801736:	50                   	push   %eax
  801737:	6a 29                	push   $0x29
  801739:	e8 04 fb ff ff       	call   801242 <syscall>
  80173e:	83 c4 18             	add    $0x18,%esp
}
  801741:	c9                   	leave  
  801742:	c3                   	ret    

00801743 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	ff 75 10             	pushl  0x10(%ebp)
  80174d:	ff 75 0c             	pushl  0xc(%ebp)
  801750:	ff 75 08             	pushl  0x8(%ebp)
  801753:	6a 12                	push   $0x12
  801755:	e8 e8 fa ff ff       	call   801242 <syscall>
  80175a:	83 c4 18             	add    $0x18,%esp
	return ;
  80175d:	90                   	nop
}
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801763:	8b 55 0c             	mov    0xc(%ebp),%edx
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	52                   	push   %edx
  801770:	50                   	push   %eax
  801771:	6a 2a                	push   $0x2a
  801773:	e8 ca fa ff ff       	call   801242 <syscall>
  801778:	83 c4 18             	add    $0x18,%esp
	return;
  80177b:	90                   	nop
}
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    

0080177e <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 2b                	push   $0x2b
  80178d:	e8 b0 fa ff ff       	call   801242 <syscall>
  801792:	83 c4 18             	add    $0x18,%esp
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	ff 75 0c             	pushl  0xc(%ebp)
  8017a3:	ff 75 08             	pushl  0x8(%ebp)
  8017a6:	6a 2d                	push   $0x2d
  8017a8:	e8 95 fa ff ff       	call   801242 <syscall>
  8017ad:	83 c4 18             	add    $0x18,%esp
	return;
  8017b0:	90                   	nop
}
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	ff 75 0c             	pushl  0xc(%ebp)
  8017bf:	ff 75 08             	pushl  0x8(%ebp)
  8017c2:	6a 2c                	push   $0x2c
  8017c4:	e8 79 fa ff ff       	call   801242 <syscall>
  8017c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8017cc:	90                   	nop
}
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
  8017d2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8017d5:	83 ec 04             	sub    $0x4,%esp
  8017d8:	68 48 21 80 00       	push   $0x802148
  8017dd:	68 25 01 00 00       	push   $0x125
  8017e2:	68 7b 21 80 00       	push   $0x80217b
  8017e7:	e8 00 00 00 00       	call   8017ec <_panic>

008017ec <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8017f2:	8d 45 10             	lea    0x10(%ebp),%eax
  8017f5:	83 c0 04             	add    $0x4,%eax
  8017f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8017fb:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801800:	85 c0                	test   %eax,%eax
  801802:	74 16                	je     80181a <_panic+0x2e>
		cprintf("%s: ", argv0);
  801804:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801809:	83 ec 08             	sub    $0x8,%esp
  80180c:	50                   	push   %eax
  80180d:	68 8c 21 80 00       	push   $0x80218c
  801812:	e8 46 eb ff ff       	call   80035d <cprintf>
  801817:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80181a:	a1 04 30 80 00       	mov    0x803004,%eax
  80181f:	83 ec 0c             	sub    $0xc,%esp
  801822:	ff 75 0c             	pushl  0xc(%ebp)
  801825:	ff 75 08             	pushl  0x8(%ebp)
  801828:	50                   	push   %eax
  801829:	68 94 21 80 00       	push   $0x802194
  80182e:	6a 74                	push   $0x74
  801830:	e8 55 eb ff ff       	call   80038a <cprintf_colored>
  801835:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801838:	8b 45 10             	mov    0x10(%ebp),%eax
  80183b:	83 ec 08             	sub    $0x8,%esp
  80183e:	ff 75 f4             	pushl  -0xc(%ebp)
  801841:	50                   	push   %eax
  801842:	e8 a7 ea ff ff       	call   8002ee <vcprintf>
  801847:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80184a:	83 ec 08             	sub    $0x8,%esp
  80184d:	6a 00                	push   $0x0
  80184f:	68 bc 21 80 00       	push   $0x8021bc
  801854:	e8 95 ea ff ff       	call   8002ee <vcprintf>
  801859:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80185c:	e8 0e ea ff ff       	call   80026f <exit>

	// should not return here
	while (1) ;
  801861:	eb fe                	jmp    801861 <_panic+0x75>

00801863 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
  801866:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801869:	a1 20 30 80 00       	mov    0x803020,%eax
  80186e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801874:	8b 45 0c             	mov    0xc(%ebp),%eax
  801877:	39 c2                	cmp    %eax,%edx
  801879:	74 14                	je     80188f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80187b:	83 ec 04             	sub    $0x4,%esp
  80187e:	68 c0 21 80 00       	push   $0x8021c0
  801883:	6a 26                	push   $0x26
  801885:	68 0c 22 80 00       	push   $0x80220c
  80188a:	e8 5d ff ff ff       	call   8017ec <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80188f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801896:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80189d:	e9 c5 00 00 00       	jmp    801967 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8018a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	01 d0                	add    %edx,%eax
  8018b1:	8b 00                	mov    (%eax),%eax
  8018b3:	85 c0                	test   %eax,%eax
  8018b5:	75 08                	jne    8018bf <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8018b7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8018ba:	e9 a5 00 00 00       	jmp    801964 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8018bf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8018cd:	eb 69                	jmp    801938 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8018cf:	a1 20 30 80 00       	mov    0x803020,%eax
  8018d4:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8018da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018dd:	89 d0                	mov    %edx,%eax
  8018df:	01 c0                	add    %eax,%eax
  8018e1:	01 d0                	add    %edx,%eax
  8018e3:	c1 e0 03             	shl    $0x3,%eax
  8018e6:	01 c8                	add    %ecx,%eax
  8018e8:	8a 40 04             	mov    0x4(%eax),%al
  8018eb:	84 c0                	test   %al,%al
  8018ed:	75 46                	jne    801935 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8018f4:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8018fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018fd:	89 d0                	mov    %edx,%eax
  8018ff:	01 c0                	add    %eax,%eax
  801901:	01 d0                	add    %edx,%eax
  801903:	c1 e0 03             	shl    $0x3,%eax
  801906:	01 c8                	add    %ecx,%eax
  801908:	8b 00                	mov    (%eax),%eax
  80190a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80190d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801910:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801915:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801917:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	01 c8                	add    %ecx,%eax
  801926:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801928:	39 c2                	cmp    %eax,%edx
  80192a:	75 09                	jne    801935 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80192c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801933:	eb 15                	jmp    80194a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801935:	ff 45 e8             	incl   -0x18(%ebp)
  801938:	a1 20 30 80 00       	mov    0x803020,%eax
  80193d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801943:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801946:	39 c2                	cmp    %eax,%edx
  801948:	77 85                	ja     8018cf <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80194a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80194e:	75 14                	jne    801964 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801950:	83 ec 04             	sub    $0x4,%esp
  801953:	68 18 22 80 00       	push   $0x802218
  801958:	6a 3a                	push   $0x3a
  80195a:	68 0c 22 80 00       	push   $0x80220c
  80195f:	e8 88 fe ff ff       	call   8017ec <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801964:	ff 45 f0             	incl   -0x10(%ebp)
  801967:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80196a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80196d:	0f 8c 2f ff ff ff    	jl     8018a2 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801973:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80197a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801981:	eb 26                	jmp    8019a9 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801983:	a1 20 30 80 00       	mov    0x803020,%eax
  801988:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80198e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801991:	89 d0                	mov    %edx,%eax
  801993:	01 c0                	add    %eax,%eax
  801995:	01 d0                	add    %edx,%eax
  801997:	c1 e0 03             	shl    $0x3,%eax
  80199a:	01 c8                	add    %ecx,%eax
  80199c:	8a 40 04             	mov    0x4(%eax),%al
  80199f:	3c 01                	cmp    $0x1,%al
  8019a1:	75 03                	jne    8019a6 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8019a3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019a6:	ff 45 e0             	incl   -0x20(%ebp)
  8019a9:	a1 20 30 80 00       	mov    0x803020,%eax
  8019ae:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8019b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019b7:	39 c2                	cmp    %eax,%edx
  8019b9:	77 c8                	ja     801983 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8019bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019be:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8019c1:	74 14                	je     8019d7 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8019c3:	83 ec 04             	sub    $0x4,%esp
  8019c6:	68 6c 22 80 00       	push   $0x80226c
  8019cb:	6a 44                	push   $0x44
  8019cd:	68 0c 22 80 00       	push   $0x80220c
  8019d2:	e8 15 fe ff ff       	call   8017ec <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8019d7:	90                   	nop
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    
  8019da:	66 90                	xchg   %ax,%ax

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

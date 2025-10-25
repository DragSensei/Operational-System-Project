
obj/user/fib_loop:     file format elf32-i386


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
  800031:	e8 41 01 00 00       	call   800177 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int64 fibonacci(int n, int64 *memo);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int index=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	atomic_readline("Please enter Fibonacci index:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 40 22 80 00       	push   $0x802240
  800057:	e8 83 0b 00 00       	call   800bdf <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	index = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 85 10 00 00       	call   8010f7 <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int64 *memo = malloc((index+1) * sizeof(int64));
  800078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007b:	40                   	inc    %eax
  80007c:	c1 e0 03             	shl    $0x3,%eax
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	e8 49 15 00 00       	call   8015d1 <malloc>
  800088:	83 c4 10             	add    $0x10,%esp
  80008b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int64 res = fibonacci(index, memo) ;
  80008e:	83 ec 08             	sub    $0x8,%esp
  800091:	ff 75 f0             	pushl  -0x10(%ebp)
  800094:	ff 75 f4             	pushl  -0xc(%ebp)
  800097:	e8 35 00 00 00       	call   8000d1 <fibonacci>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8000a2:	89 55 ec             	mov    %edx,-0x14(%ebp)

	free(memo);
  8000a5:	83 ec 0c             	sub    $0xc,%esp
  8000a8:	ff 75 f0             	pushl  -0x10(%ebp)
  8000ab:	e8 4f 15 00 00       	call   8015ff <free>
  8000b0:	83 c4 10             	add    $0x10,%esp

	atomic_cprintf("Fibonacci #%d = %lld\n",index, res);
  8000b3:	ff 75 ec             	pushl  -0x14(%ebp)
  8000b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8000bc:	68 5e 22 80 00       	push   $0x80225e
  8000c1:	e8 b3 03 00 00       	call   800479 <atomic_cprintf>
  8000c6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000c9:	e8 03 1a 00 00       	call   801ad1 <inctst>
	return;
  8000ce:	90                   	nop
}
  8000cf:	c9                   	leave  
  8000d0:	c3                   	ret    

008000d1 <fibonacci>:


int64 fibonacci(int n, int64 *memo)
{
  8000d1:	55                   	push   %ebp
  8000d2:	89 e5                	mov    %esp,%ebp
  8000d4:	56                   	push   %esi
  8000d5:	53                   	push   %ebx
  8000d6:	83 ec 10             	sub    $0x10,%esp
	for (int i = 0; i <= n; ++i)
  8000d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000e0:	eb 72                	jmp    800154 <fibonacci+0x83>
	{
		if (i <= 1)
  8000e2:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8000e6:	7f 1e                	jg     800106 <fibonacci+0x35>
			memo[i] = 1;
  8000e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000eb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8000f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000f5:	01 d0                	add    %edx,%eax
  8000f7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  8000fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  800104:	eb 4b                	jmp    800151 <fibonacci+0x80>
		else
			memo[i] = memo[i-1] + memo[i-2] ;
  800106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800109:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800110:	8b 45 0c             	mov    0xc(%ebp),%eax
  800113:	8d 34 02             	lea    (%edx,%eax,1),%esi
  800116:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800119:	05 ff ff ff 1f       	add    $0x1fffffff,%eax
  80011e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800125:	8b 45 0c             	mov    0xc(%ebp),%eax
  800128:	01 d0                	add    %edx,%eax
  80012a:	8b 08                	mov    (%eax),%ecx
  80012c:	8b 58 04             	mov    0x4(%eax),%ebx
  80012f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800132:	05 fe ff ff 1f       	add    $0x1ffffffe,%eax
  800137:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80013e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800141:	01 d0                	add    %edx,%eax
  800143:	8b 50 04             	mov    0x4(%eax),%edx
  800146:	8b 00                	mov    (%eax),%eax
  800148:	01 c8                	add    %ecx,%eax
  80014a:	11 da                	adc    %ebx,%edx
  80014c:	89 06                	mov    %eax,(%esi)
  80014e:	89 56 04             	mov    %edx,0x4(%esi)
}


int64 fibonacci(int n, int64 *memo)
{
	for (int i = 0; i <= n; ++i)
  800151:	ff 45 f4             	incl   -0xc(%ebp)
  800154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800157:	3b 45 08             	cmp    0x8(%ebp),%eax
  80015a:	7e 86                	jle    8000e2 <fibonacci+0x11>
		if (i <= 1)
			memo[i] = 1;
		else
			memo[i] = memo[i-1] + memo[i-2] ;
	}
	return memo[n];
  80015c:	8b 45 08             	mov    0x8(%ebp),%eax
  80015f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800166:	8b 45 0c             	mov    0xc(%ebp),%eax
  800169:	01 d0                	add    %edx,%eax
  80016b:	8b 50 04             	mov    0x4(%eax),%edx
  80016e:	8b 00                	mov    (%eax),%eax
}
  800170:	83 c4 10             	add    $0x10,%esp
  800173:	5b                   	pop    %ebx
  800174:	5e                   	pop    %esi
  800175:	5d                   	pop    %ebp
  800176:	c3                   	ret    

00800177 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800177:	55                   	push   %ebp
  800178:	89 e5                	mov    %esp,%ebp
  80017a:	57                   	push   %edi
  80017b:	56                   	push   %esi
  80017c:	53                   	push   %ebx
  80017d:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800180:	e8 0e 18 00 00       	call   801993 <sys_getenvindex>
  800185:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800188:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80018b:	89 d0                	mov    %edx,%eax
  80018d:	c1 e0 02             	shl    $0x2,%eax
  800190:	01 d0                	add    %edx,%eax
  800192:	c1 e0 03             	shl    $0x3,%eax
  800195:	01 d0                	add    %edx,%eax
  800197:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80019e:	01 d0                	add    %edx,%eax
  8001a0:	c1 e0 02             	shl    $0x2,%eax
  8001a3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001a8:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001ad:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b2:	8a 40 20             	mov    0x20(%eax),%al
  8001b5:	84 c0                	test   %al,%al
  8001b7:	74 0d                	je     8001c6 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  8001b9:	a1 20 30 80 00       	mov    0x803020,%eax
  8001be:	83 c0 20             	add    $0x20,%eax
  8001c1:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001ca:	7e 0a                	jle    8001d6 <libmain+0x5f>
		binaryname = argv[0];
  8001cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001cf:	8b 00                	mov    (%eax),%eax
  8001d1:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8001d6:	83 ec 08             	sub    $0x8,%esp
  8001d9:	ff 75 0c             	pushl  0xc(%ebp)
  8001dc:	ff 75 08             	pushl  0x8(%ebp)
  8001df:	e8 54 fe ff ff       	call   800038 <_main>
  8001e4:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001e7:	a1 00 30 80 00       	mov    0x803000,%eax
  8001ec:	85 c0                	test   %eax,%eax
  8001ee:	0f 84 01 01 00 00    	je     8002f5 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001f4:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001fa:	bb 6c 23 80 00       	mov    $0x80236c,%ebx
  8001ff:	ba 0e 00 00 00       	mov    $0xe,%edx
  800204:	89 c7                	mov    %eax,%edi
  800206:	89 de                	mov    %ebx,%esi
  800208:	89 d1                	mov    %edx,%ecx
  80020a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80020c:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80020f:	b9 56 00 00 00       	mov    $0x56,%ecx
  800214:	b0 00                	mov    $0x0,%al
  800216:	89 d7                	mov    %edx,%edi
  800218:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80021a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800221:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800224:	83 ec 08             	sub    $0x8,%esp
  800227:	50                   	push   %eax
  800228:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80022e:	50                   	push   %eax
  80022f:	e8 95 19 00 00       	call   801bc9 <sys_utilities>
  800234:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800237:	e8 de 14 00 00       	call   80171a <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80023c:	83 ec 0c             	sub    $0xc,%esp
  80023f:	68 8c 22 80 00       	push   $0x80228c
  800244:	e8 be 01 00 00       	call   800407 <cprintf>
  800249:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80024c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80024f:	85 c0                	test   %eax,%eax
  800251:	74 18                	je     80026b <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800253:	e8 8f 19 00 00       	call   801be7 <sys_get_optimal_num_faults>
  800258:	83 ec 08             	sub    $0x8,%esp
  80025b:	50                   	push   %eax
  80025c:	68 b4 22 80 00       	push   $0x8022b4
  800261:	e8 a1 01 00 00       	call   800407 <cprintf>
  800266:	83 c4 10             	add    $0x10,%esp
  800269:	eb 59                	jmp    8002c4 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80026b:	a1 20 30 80 00       	mov    0x803020,%eax
  800270:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800276:	a1 20 30 80 00       	mov    0x803020,%eax
  80027b:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800281:	83 ec 04             	sub    $0x4,%esp
  800284:	52                   	push   %edx
  800285:	50                   	push   %eax
  800286:	68 d8 22 80 00       	push   $0x8022d8
  80028b:	e8 77 01 00 00       	call   800407 <cprintf>
  800290:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800293:	a1 20 30 80 00       	mov    0x803020,%eax
  800298:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80029e:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a3:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8002a9:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ae:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8002b4:	51                   	push   %ecx
  8002b5:	52                   	push   %edx
  8002b6:	50                   	push   %eax
  8002b7:	68 00 23 80 00       	push   $0x802300
  8002bc:	e8 46 01 00 00       	call   800407 <cprintf>
  8002c1:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002c4:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c9:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8002cf:	83 ec 08             	sub    $0x8,%esp
  8002d2:	50                   	push   %eax
  8002d3:	68 58 23 80 00       	push   $0x802358
  8002d8:	e8 2a 01 00 00       	call   800407 <cprintf>
  8002dd:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	68 8c 22 80 00       	push   $0x80228c
  8002e8:	e8 1a 01 00 00       	call   800407 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002f0:	e8 3f 14 00 00       	call   801734 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002f5:	e8 1f 00 00 00       	call   800319 <exit>
}
  8002fa:	90                   	nop
  8002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002fe:	5b                   	pop    %ebx
  8002ff:	5e                   	pop    %esi
  800300:	5f                   	pop    %edi
  800301:	5d                   	pop    %ebp
  800302:	c3                   	ret    

00800303 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800303:	55                   	push   %ebp
  800304:	89 e5                	mov    %esp,%ebp
  800306:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800309:	83 ec 0c             	sub    $0xc,%esp
  80030c:	6a 00                	push   $0x0
  80030e:	e8 4c 16 00 00       	call   80195f <sys_destroy_env>
  800313:	83 c4 10             	add    $0x10,%esp
}
  800316:	90                   	nop
  800317:	c9                   	leave  
  800318:	c3                   	ret    

00800319 <exit>:

void
exit(void)
{
  800319:	55                   	push   %ebp
  80031a:	89 e5                	mov    %esp,%ebp
  80031c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80031f:	e8 a1 16 00 00       	call   8019c5 <sys_exit_env>
}
  800324:	90                   	nop
  800325:	c9                   	leave  
  800326:	c3                   	ret    

00800327 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800327:	55                   	push   %ebp
  800328:	89 e5                	mov    %esp,%ebp
  80032a:	53                   	push   %ebx
  80032b:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80032e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800331:	8b 00                	mov    (%eax),%eax
  800333:	8d 48 01             	lea    0x1(%eax),%ecx
  800336:	8b 55 0c             	mov    0xc(%ebp),%edx
  800339:	89 0a                	mov    %ecx,(%edx)
  80033b:	8b 55 08             	mov    0x8(%ebp),%edx
  80033e:	88 d1                	mov    %dl,%cl
  800340:	8b 55 0c             	mov    0xc(%ebp),%edx
  800343:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034a:	8b 00                	mov    (%eax),%eax
  80034c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800351:	75 30                	jne    800383 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800353:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  800359:	a0 44 30 80 00       	mov    0x803044,%al
  80035e:	0f b6 c0             	movzbl %al,%eax
  800361:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800364:	8b 09                	mov    (%ecx),%ecx
  800366:	89 cb                	mov    %ecx,%ebx
  800368:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80036b:	83 c1 08             	add    $0x8,%ecx
  80036e:	52                   	push   %edx
  80036f:	50                   	push   %eax
  800370:	53                   	push   %ebx
  800371:	51                   	push   %ecx
  800372:	e8 5f 13 00 00       	call   8016d6 <sys_cputs>
  800377:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80037a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80037d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800383:	8b 45 0c             	mov    0xc(%ebp),%eax
  800386:	8b 40 04             	mov    0x4(%eax),%eax
  800389:	8d 50 01             	lea    0x1(%eax),%edx
  80038c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800392:	90                   	nop
  800393:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800396:	c9                   	leave  
  800397:	c3                   	ret    

00800398 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800398:	55                   	push   %ebp
  800399:	89 e5                	mov    %esp,%ebp
  80039b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003a1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003a8:	00 00 00 
	b.cnt = 0;
  8003ab:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003b2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8003b5:	ff 75 0c             	pushl  0xc(%ebp)
  8003b8:	ff 75 08             	pushl  0x8(%ebp)
  8003bb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003c1:	50                   	push   %eax
  8003c2:	68 27 03 80 00       	push   $0x800327
  8003c7:	e8 5a 02 00 00       	call   800626 <vprintfmt>
  8003cc:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8003cf:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8003d5:	a0 44 30 80 00       	mov    0x803044,%al
  8003da:	0f b6 c0             	movzbl %al,%eax
  8003dd:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8003e3:	52                   	push   %edx
  8003e4:	50                   	push   %eax
  8003e5:	51                   	push   %ecx
  8003e6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003ec:	83 c0 08             	add    $0x8,%eax
  8003ef:	50                   	push   %eax
  8003f0:	e8 e1 12 00 00       	call   8016d6 <sys_cputs>
  8003f5:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8003f8:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8003ff:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800405:	c9                   	leave  
  800406:	c3                   	ret    

00800407 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800407:	55                   	push   %ebp
  800408:	89 e5                	mov    %esp,%ebp
  80040a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80040d:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800414:	8d 45 0c             	lea    0xc(%ebp),%eax
  800417:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80041a:	8b 45 08             	mov    0x8(%ebp),%eax
  80041d:	83 ec 08             	sub    $0x8,%esp
  800420:	ff 75 f4             	pushl  -0xc(%ebp)
  800423:	50                   	push   %eax
  800424:	e8 6f ff ff ff       	call   800398 <vcprintf>
  800429:	83 c4 10             	add    $0x10,%esp
  80042c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80042f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800432:	c9                   	leave  
  800433:	c3                   	ret    

00800434 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800434:	55                   	push   %ebp
  800435:	89 e5                	mov    %esp,%ebp
  800437:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80043a:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800441:	8b 45 08             	mov    0x8(%ebp),%eax
  800444:	c1 e0 08             	shl    $0x8,%eax
  800447:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  80044c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80044f:	83 c0 04             	add    $0x4,%eax
  800452:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800455:	8b 45 0c             	mov    0xc(%ebp),%eax
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	ff 75 f4             	pushl  -0xc(%ebp)
  80045e:	50                   	push   %eax
  80045f:	e8 34 ff ff ff       	call   800398 <vcprintf>
  800464:	83 c4 10             	add    $0x10,%esp
  800467:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80046a:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  800471:	07 00 00 

	return cnt;
  800474:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800477:	c9                   	leave  
  800478:	c3                   	ret    

00800479 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800479:	55                   	push   %ebp
  80047a:	89 e5                	mov    %esp,%ebp
  80047c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80047f:	e8 96 12 00 00       	call   80171a <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800484:	8d 45 0c             	lea    0xc(%ebp),%eax
  800487:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80048a:	8b 45 08             	mov    0x8(%ebp),%eax
  80048d:	83 ec 08             	sub    $0x8,%esp
  800490:	ff 75 f4             	pushl  -0xc(%ebp)
  800493:	50                   	push   %eax
  800494:	e8 ff fe ff ff       	call   800398 <vcprintf>
  800499:	83 c4 10             	add    $0x10,%esp
  80049c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80049f:	e8 90 12 00 00       	call   801734 <sys_unlock_cons>
	return cnt;
  8004a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004a7:	c9                   	leave  
  8004a8:	c3                   	ret    

008004a9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004a9:	55                   	push   %ebp
  8004aa:	89 e5                	mov    %esp,%ebp
  8004ac:	53                   	push   %ebx
  8004ad:	83 ec 14             	sub    $0x14,%esp
  8004b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004bc:	8b 45 18             	mov    0x18(%ebp),%eax
  8004bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004c7:	77 55                	ja     80051e <printnum+0x75>
  8004c9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004cc:	72 05                	jb     8004d3 <printnum+0x2a>
  8004ce:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004d1:	77 4b                	ja     80051e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004d3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004d6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004d9:	8b 45 18             	mov    0x18(%ebp),%eax
  8004dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e1:	52                   	push   %edx
  8004e2:	50                   	push   %eax
  8004e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e6:	ff 75 f0             	pushl  -0x10(%ebp)
  8004e9:	e8 da 1a 00 00       	call   801fc8 <__udivdi3>
  8004ee:	83 c4 10             	add    $0x10,%esp
  8004f1:	83 ec 04             	sub    $0x4,%esp
  8004f4:	ff 75 20             	pushl  0x20(%ebp)
  8004f7:	53                   	push   %ebx
  8004f8:	ff 75 18             	pushl  0x18(%ebp)
  8004fb:	52                   	push   %edx
  8004fc:	50                   	push   %eax
  8004fd:	ff 75 0c             	pushl  0xc(%ebp)
  800500:	ff 75 08             	pushl  0x8(%ebp)
  800503:	e8 a1 ff ff ff       	call   8004a9 <printnum>
  800508:	83 c4 20             	add    $0x20,%esp
  80050b:	eb 1a                	jmp    800527 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80050d:	83 ec 08             	sub    $0x8,%esp
  800510:	ff 75 0c             	pushl  0xc(%ebp)
  800513:	ff 75 20             	pushl  0x20(%ebp)
  800516:	8b 45 08             	mov    0x8(%ebp),%eax
  800519:	ff d0                	call   *%eax
  80051b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80051e:	ff 4d 1c             	decl   0x1c(%ebp)
  800521:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800525:	7f e6                	jg     80050d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800527:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80052a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80052f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800532:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800535:	53                   	push   %ebx
  800536:	51                   	push   %ecx
  800537:	52                   	push   %edx
  800538:	50                   	push   %eax
  800539:	e8 9a 1b 00 00       	call   8020d8 <__umoddi3>
  80053e:	83 c4 10             	add    $0x10,%esp
  800541:	05 f4 25 80 00       	add    $0x8025f4,%eax
  800546:	8a 00                	mov    (%eax),%al
  800548:	0f be c0             	movsbl %al,%eax
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	ff 75 0c             	pushl  0xc(%ebp)
  800551:	50                   	push   %eax
  800552:	8b 45 08             	mov    0x8(%ebp),%eax
  800555:	ff d0                	call   *%eax
  800557:	83 c4 10             	add    $0x10,%esp
}
  80055a:	90                   	nop
  80055b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80055e:	c9                   	leave  
  80055f:	c3                   	ret    

00800560 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800560:	55                   	push   %ebp
  800561:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800563:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800567:	7e 1c                	jle    800585 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	8b 00                	mov    (%eax),%eax
  80056e:	8d 50 08             	lea    0x8(%eax),%edx
  800571:	8b 45 08             	mov    0x8(%ebp),%eax
  800574:	89 10                	mov    %edx,(%eax)
  800576:	8b 45 08             	mov    0x8(%ebp),%eax
  800579:	8b 00                	mov    (%eax),%eax
  80057b:	83 e8 08             	sub    $0x8,%eax
  80057e:	8b 50 04             	mov    0x4(%eax),%edx
  800581:	8b 00                	mov    (%eax),%eax
  800583:	eb 40                	jmp    8005c5 <getuint+0x65>
	else if (lflag)
  800585:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800589:	74 1e                	je     8005a9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80058b:	8b 45 08             	mov    0x8(%ebp),%eax
  80058e:	8b 00                	mov    (%eax),%eax
  800590:	8d 50 04             	lea    0x4(%eax),%edx
  800593:	8b 45 08             	mov    0x8(%ebp),%eax
  800596:	89 10                	mov    %edx,(%eax)
  800598:	8b 45 08             	mov    0x8(%ebp),%eax
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	83 e8 04             	sub    $0x4,%eax
  8005a0:	8b 00                	mov    (%eax),%eax
  8005a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a7:	eb 1c                	jmp    8005c5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	8d 50 04             	lea    0x4(%eax),%edx
  8005b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b4:	89 10                	mov    %edx,(%eax)
  8005b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b9:	8b 00                	mov    (%eax),%eax
  8005bb:	83 e8 04             	sub    $0x4,%eax
  8005be:	8b 00                	mov    (%eax),%eax
  8005c0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005c5:	5d                   	pop    %ebp
  8005c6:	c3                   	ret    

008005c7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005c7:	55                   	push   %ebp
  8005c8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005ca:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005ce:	7e 1c                	jle    8005ec <getint+0x25>
		return va_arg(*ap, long long);
  8005d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d3:	8b 00                	mov    (%eax),%eax
  8005d5:	8d 50 08             	lea    0x8(%eax),%edx
  8005d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005db:	89 10                	mov    %edx,(%eax)
  8005dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e0:	8b 00                	mov    (%eax),%eax
  8005e2:	83 e8 08             	sub    $0x8,%eax
  8005e5:	8b 50 04             	mov    0x4(%eax),%edx
  8005e8:	8b 00                	mov    (%eax),%eax
  8005ea:	eb 38                	jmp    800624 <getint+0x5d>
	else if (lflag)
  8005ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005f0:	74 1a                	je     80060c <getint+0x45>
		return va_arg(*ap, long);
  8005f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f5:	8b 00                	mov    (%eax),%eax
  8005f7:	8d 50 04             	lea    0x4(%eax),%edx
  8005fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fd:	89 10                	mov    %edx,(%eax)
  8005ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800602:	8b 00                	mov    (%eax),%eax
  800604:	83 e8 04             	sub    $0x4,%eax
  800607:	8b 00                	mov    (%eax),%eax
  800609:	99                   	cltd   
  80060a:	eb 18                	jmp    800624 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80060c:	8b 45 08             	mov    0x8(%ebp),%eax
  80060f:	8b 00                	mov    (%eax),%eax
  800611:	8d 50 04             	lea    0x4(%eax),%edx
  800614:	8b 45 08             	mov    0x8(%ebp),%eax
  800617:	89 10                	mov    %edx,(%eax)
  800619:	8b 45 08             	mov    0x8(%ebp),%eax
  80061c:	8b 00                	mov    (%eax),%eax
  80061e:	83 e8 04             	sub    $0x4,%eax
  800621:	8b 00                	mov    (%eax),%eax
  800623:	99                   	cltd   
}
  800624:	5d                   	pop    %ebp
  800625:	c3                   	ret    

00800626 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800626:	55                   	push   %ebp
  800627:	89 e5                	mov    %esp,%ebp
  800629:	56                   	push   %esi
  80062a:	53                   	push   %ebx
  80062b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80062e:	eb 17                	jmp    800647 <vprintfmt+0x21>
			if (ch == '\0')
  800630:	85 db                	test   %ebx,%ebx
  800632:	0f 84 c1 03 00 00    	je     8009f9 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	ff 75 0c             	pushl  0xc(%ebp)
  80063e:	53                   	push   %ebx
  80063f:	8b 45 08             	mov    0x8(%ebp),%eax
  800642:	ff d0                	call   *%eax
  800644:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800647:	8b 45 10             	mov    0x10(%ebp),%eax
  80064a:	8d 50 01             	lea    0x1(%eax),%edx
  80064d:	89 55 10             	mov    %edx,0x10(%ebp)
  800650:	8a 00                	mov    (%eax),%al
  800652:	0f b6 d8             	movzbl %al,%ebx
  800655:	83 fb 25             	cmp    $0x25,%ebx
  800658:	75 d6                	jne    800630 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80065a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80065e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800665:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80066c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800673:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80067a:	8b 45 10             	mov    0x10(%ebp),%eax
  80067d:	8d 50 01             	lea    0x1(%eax),%edx
  800680:	89 55 10             	mov    %edx,0x10(%ebp)
  800683:	8a 00                	mov    (%eax),%al
  800685:	0f b6 d8             	movzbl %al,%ebx
  800688:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80068b:	83 f8 5b             	cmp    $0x5b,%eax
  80068e:	0f 87 3d 03 00 00    	ja     8009d1 <vprintfmt+0x3ab>
  800694:	8b 04 85 18 26 80 00 	mov    0x802618(,%eax,4),%eax
  80069b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80069d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006a1:	eb d7                	jmp    80067a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006a3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006a7:	eb d1                	jmp    80067a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006a9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006b3:	89 d0                	mov    %edx,%eax
  8006b5:	c1 e0 02             	shl    $0x2,%eax
  8006b8:	01 d0                	add    %edx,%eax
  8006ba:	01 c0                	add    %eax,%eax
  8006bc:	01 d8                	add    %ebx,%eax
  8006be:	83 e8 30             	sub    $0x30,%eax
  8006c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8006c7:	8a 00                	mov    (%eax),%al
  8006c9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006cc:	83 fb 2f             	cmp    $0x2f,%ebx
  8006cf:	7e 3e                	jle    80070f <vprintfmt+0xe9>
  8006d1:	83 fb 39             	cmp    $0x39,%ebx
  8006d4:	7f 39                	jg     80070f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006d6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006d9:	eb d5                	jmp    8006b0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	83 c0 04             	add    $0x4,%eax
  8006e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	83 e8 04             	sub    $0x4,%eax
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006ef:	eb 1f                	jmp    800710 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006f5:	79 83                	jns    80067a <vprintfmt+0x54>
				width = 0;
  8006f7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8006fe:	e9 77 ff ff ff       	jmp    80067a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800703:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80070a:	e9 6b ff ff ff       	jmp    80067a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80070f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800710:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800714:	0f 89 60 ff ff ff    	jns    80067a <vprintfmt+0x54>
				width = precision, precision = -1;
  80071a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80071d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800720:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800727:	e9 4e ff ff ff       	jmp    80067a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80072c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80072f:	e9 46 ff ff ff       	jmp    80067a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	83 c0 04             	add    $0x4,%eax
  80073a:	89 45 14             	mov    %eax,0x14(%ebp)
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	83 e8 04             	sub    $0x4,%eax
  800743:	8b 00                	mov    (%eax),%eax
  800745:	83 ec 08             	sub    $0x8,%esp
  800748:	ff 75 0c             	pushl  0xc(%ebp)
  80074b:	50                   	push   %eax
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	ff d0                	call   *%eax
  800751:	83 c4 10             	add    $0x10,%esp
			break;
  800754:	e9 9b 02 00 00       	jmp    8009f4 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	83 c0 04             	add    $0x4,%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
  800762:	8b 45 14             	mov    0x14(%ebp),%eax
  800765:	83 e8 04             	sub    $0x4,%eax
  800768:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80076a:	85 db                	test   %ebx,%ebx
  80076c:	79 02                	jns    800770 <vprintfmt+0x14a>
				err = -err;
  80076e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800770:	83 fb 64             	cmp    $0x64,%ebx
  800773:	7f 0b                	jg     800780 <vprintfmt+0x15a>
  800775:	8b 34 9d 60 24 80 00 	mov    0x802460(,%ebx,4),%esi
  80077c:	85 f6                	test   %esi,%esi
  80077e:	75 19                	jne    800799 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800780:	53                   	push   %ebx
  800781:	68 05 26 80 00       	push   $0x802605
  800786:	ff 75 0c             	pushl  0xc(%ebp)
  800789:	ff 75 08             	pushl  0x8(%ebp)
  80078c:	e8 70 02 00 00       	call   800a01 <printfmt>
  800791:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800794:	e9 5b 02 00 00       	jmp    8009f4 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800799:	56                   	push   %esi
  80079a:	68 0e 26 80 00       	push   $0x80260e
  80079f:	ff 75 0c             	pushl  0xc(%ebp)
  8007a2:	ff 75 08             	pushl  0x8(%ebp)
  8007a5:	e8 57 02 00 00       	call   800a01 <printfmt>
  8007aa:	83 c4 10             	add    $0x10,%esp
			break;
  8007ad:	e9 42 02 00 00       	jmp    8009f4 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	83 c0 04             	add    $0x4,%eax
  8007b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007be:	83 e8 04             	sub    $0x4,%eax
  8007c1:	8b 30                	mov    (%eax),%esi
  8007c3:	85 f6                	test   %esi,%esi
  8007c5:	75 05                	jne    8007cc <vprintfmt+0x1a6>
				p = "(null)";
  8007c7:	be 11 26 80 00       	mov    $0x802611,%esi
			if (width > 0 && padc != '-')
  8007cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d0:	7e 6d                	jle    80083f <vprintfmt+0x219>
  8007d2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007d6:	74 67                	je     80083f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	50                   	push   %eax
  8007df:	56                   	push   %esi
  8007e0:	e8 26 05 00 00       	call   800d0b <strnlen>
  8007e5:	83 c4 10             	add    $0x10,%esp
  8007e8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007eb:	eb 16                	jmp    800803 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007ed:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	ff 75 0c             	pushl  0xc(%ebp)
  8007f7:	50                   	push   %eax
  8007f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fb:	ff d0                	call   *%eax
  8007fd:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800800:	ff 4d e4             	decl   -0x1c(%ebp)
  800803:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800807:	7f e4                	jg     8007ed <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800809:	eb 34                	jmp    80083f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80080b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80080f:	74 1c                	je     80082d <vprintfmt+0x207>
  800811:	83 fb 1f             	cmp    $0x1f,%ebx
  800814:	7e 05                	jle    80081b <vprintfmt+0x1f5>
  800816:	83 fb 7e             	cmp    $0x7e,%ebx
  800819:	7e 12                	jle    80082d <vprintfmt+0x207>
					putch('?', putdat);
  80081b:	83 ec 08             	sub    $0x8,%esp
  80081e:	ff 75 0c             	pushl  0xc(%ebp)
  800821:	6a 3f                	push   $0x3f
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	ff d0                	call   *%eax
  800828:	83 c4 10             	add    $0x10,%esp
  80082b:	eb 0f                	jmp    80083c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80082d:	83 ec 08             	sub    $0x8,%esp
  800830:	ff 75 0c             	pushl  0xc(%ebp)
  800833:	53                   	push   %ebx
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	ff d0                	call   *%eax
  800839:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80083c:	ff 4d e4             	decl   -0x1c(%ebp)
  80083f:	89 f0                	mov    %esi,%eax
  800841:	8d 70 01             	lea    0x1(%eax),%esi
  800844:	8a 00                	mov    (%eax),%al
  800846:	0f be d8             	movsbl %al,%ebx
  800849:	85 db                	test   %ebx,%ebx
  80084b:	74 24                	je     800871 <vprintfmt+0x24b>
  80084d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800851:	78 b8                	js     80080b <vprintfmt+0x1e5>
  800853:	ff 4d e0             	decl   -0x20(%ebp)
  800856:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80085a:	79 af                	jns    80080b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80085c:	eb 13                	jmp    800871 <vprintfmt+0x24b>
				putch(' ', putdat);
  80085e:	83 ec 08             	sub    $0x8,%esp
  800861:	ff 75 0c             	pushl  0xc(%ebp)
  800864:	6a 20                	push   $0x20
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	ff d0                	call   *%eax
  80086b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80086e:	ff 4d e4             	decl   -0x1c(%ebp)
  800871:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800875:	7f e7                	jg     80085e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800877:	e9 78 01 00 00       	jmp    8009f4 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80087c:	83 ec 08             	sub    $0x8,%esp
  80087f:	ff 75 e8             	pushl  -0x18(%ebp)
  800882:	8d 45 14             	lea    0x14(%ebp),%eax
  800885:	50                   	push   %eax
  800886:	e8 3c fd ff ff       	call   8005c7 <getint>
  80088b:	83 c4 10             	add    $0x10,%esp
  80088e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800891:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800897:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80089a:	85 d2                	test   %edx,%edx
  80089c:	79 23                	jns    8008c1 <vprintfmt+0x29b>
				putch('-', putdat);
  80089e:	83 ec 08             	sub    $0x8,%esp
  8008a1:	ff 75 0c             	pushl  0xc(%ebp)
  8008a4:	6a 2d                	push   $0x2d
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	ff d0                	call   *%eax
  8008ab:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b4:	f7 d8                	neg    %eax
  8008b6:	83 d2 00             	adc    $0x0,%edx
  8008b9:	f7 da                	neg    %edx
  8008bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008be:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008c1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008c8:	e9 bc 00 00 00       	jmp    800989 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008cd:	83 ec 08             	sub    $0x8,%esp
  8008d0:	ff 75 e8             	pushl  -0x18(%ebp)
  8008d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8008d6:	50                   	push   %eax
  8008d7:	e8 84 fc ff ff       	call   800560 <getuint>
  8008dc:	83 c4 10             	add    $0x10,%esp
  8008df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008e5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008ec:	e9 98 00 00 00       	jmp    800989 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008f1:	83 ec 08             	sub    $0x8,%esp
  8008f4:	ff 75 0c             	pushl  0xc(%ebp)
  8008f7:	6a 58                	push   $0x58
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	ff d0                	call   *%eax
  8008fe:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800901:	83 ec 08             	sub    $0x8,%esp
  800904:	ff 75 0c             	pushl  0xc(%ebp)
  800907:	6a 58                	push   $0x58
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	ff d0                	call   *%eax
  80090e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800911:	83 ec 08             	sub    $0x8,%esp
  800914:	ff 75 0c             	pushl  0xc(%ebp)
  800917:	6a 58                	push   $0x58
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	ff d0                	call   *%eax
  80091e:	83 c4 10             	add    $0x10,%esp
			break;
  800921:	e9 ce 00 00 00       	jmp    8009f4 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800926:	83 ec 08             	sub    $0x8,%esp
  800929:	ff 75 0c             	pushl  0xc(%ebp)
  80092c:	6a 30                	push   $0x30
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	ff d0                	call   *%eax
  800933:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800936:	83 ec 08             	sub    $0x8,%esp
  800939:	ff 75 0c             	pushl  0xc(%ebp)
  80093c:	6a 78                	push   $0x78
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	ff d0                	call   *%eax
  800943:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800946:	8b 45 14             	mov    0x14(%ebp),%eax
  800949:	83 c0 04             	add    $0x4,%eax
  80094c:	89 45 14             	mov    %eax,0x14(%ebp)
  80094f:	8b 45 14             	mov    0x14(%ebp),%eax
  800952:	83 e8 04             	sub    $0x4,%eax
  800955:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800957:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80095a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800961:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800968:	eb 1f                	jmp    800989 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80096a:	83 ec 08             	sub    $0x8,%esp
  80096d:	ff 75 e8             	pushl  -0x18(%ebp)
  800970:	8d 45 14             	lea    0x14(%ebp),%eax
  800973:	50                   	push   %eax
  800974:	e8 e7 fb ff ff       	call   800560 <getuint>
  800979:	83 c4 10             	add    $0x10,%esp
  80097c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800982:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800989:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80098d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800990:	83 ec 04             	sub    $0x4,%esp
  800993:	52                   	push   %edx
  800994:	ff 75 e4             	pushl  -0x1c(%ebp)
  800997:	50                   	push   %eax
  800998:	ff 75 f4             	pushl  -0xc(%ebp)
  80099b:	ff 75 f0             	pushl  -0x10(%ebp)
  80099e:	ff 75 0c             	pushl  0xc(%ebp)
  8009a1:	ff 75 08             	pushl  0x8(%ebp)
  8009a4:	e8 00 fb ff ff       	call   8004a9 <printnum>
  8009a9:	83 c4 20             	add    $0x20,%esp
			break;
  8009ac:	eb 46                	jmp    8009f4 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009ae:	83 ec 08             	sub    $0x8,%esp
  8009b1:	ff 75 0c             	pushl  0xc(%ebp)
  8009b4:	53                   	push   %ebx
  8009b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b8:	ff d0                	call   *%eax
  8009ba:	83 c4 10             	add    $0x10,%esp
			break;
  8009bd:	eb 35                	jmp    8009f4 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009bf:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  8009c6:	eb 2c                	jmp    8009f4 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009c8:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  8009cf:	eb 23                	jmp    8009f4 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009d1:	83 ec 08             	sub    $0x8,%esp
  8009d4:	ff 75 0c             	pushl  0xc(%ebp)
  8009d7:	6a 25                	push   $0x25
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	ff d0                	call   *%eax
  8009de:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009e1:	ff 4d 10             	decl   0x10(%ebp)
  8009e4:	eb 03                	jmp    8009e9 <vprintfmt+0x3c3>
  8009e6:	ff 4d 10             	decl   0x10(%ebp)
  8009e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ec:	48                   	dec    %eax
  8009ed:	8a 00                	mov    (%eax),%al
  8009ef:	3c 25                	cmp    $0x25,%al
  8009f1:	75 f3                	jne    8009e6 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8009f3:	90                   	nop
		}
	}
  8009f4:	e9 35 fc ff ff       	jmp    80062e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009f9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009fd:	5b                   	pop    %ebx
  8009fe:	5e                   	pop    %esi
  8009ff:	5d                   	pop    %ebp
  800a00:	c3                   	ret    

00800a01 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a01:	55                   	push   %ebp
  800a02:	89 e5                	mov    %esp,%ebp
  800a04:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a07:	8d 45 10             	lea    0x10(%ebp),%eax
  800a0a:	83 c0 04             	add    $0x4,%eax
  800a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a10:	8b 45 10             	mov    0x10(%ebp),%eax
  800a13:	ff 75 f4             	pushl  -0xc(%ebp)
  800a16:	50                   	push   %eax
  800a17:	ff 75 0c             	pushl  0xc(%ebp)
  800a1a:	ff 75 08             	pushl  0x8(%ebp)
  800a1d:	e8 04 fc ff ff       	call   800626 <vprintfmt>
  800a22:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a25:	90                   	nop
  800a26:	c9                   	leave  
  800a27:	c3                   	ret    

00800a28 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2e:	8b 40 08             	mov    0x8(%eax),%eax
  800a31:	8d 50 01             	lea    0x1(%eax),%edx
  800a34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a37:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3d:	8b 10                	mov    (%eax),%edx
  800a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a42:	8b 40 04             	mov    0x4(%eax),%eax
  800a45:	39 c2                	cmp    %eax,%edx
  800a47:	73 12                	jae    800a5b <sprintputch+0x33>
		*b->buf++ = ch;
  800a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4c:	8b 00                	mov    (%eax),%eax
  800a4e:	8d 48 01             	lea    0x1(%eax),%ecx
  800a51:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a54:	89 0a                	mov    %ecx,(%edx)
  800a56:	8b 55 08             	mov    0x8(%ebp),%edx
  800a59:	88 10                	mov    %dl,(%eax)
}
  800a5b:	90                   	nop
  800a5c:	5d                   	pop    %ebp
  800a5d:	c3                   	ret    

00800a5e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a5e:	55                   	push   %ebp
  800a5f:	89 e5                	mov    %esp,%ebp
  800a61:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	01 d0                	add    %edx,%eax
  800a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a83:	74 06                	je     800a8b <vsnprintf+0x2d>
  800a85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a89:	7f 07                	jg     800a92 <vsnprintf+0x34>
		return -E_INVAL;
  800a8b:	b8 03 00 00 00       	mov    $0x3,%eax
  800a90:	eb 20                	jmp    800ab2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a92:	ff 75 14             	pushl  0x14(%ebp)
  800a95:	ff 75 10             	pushl  0x10(%ebp)
  800a98:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a9b:	50                   	push   %eax
  800a9c:	68 28 0a 80 00       	push   $0x800a28
  800aa1:	e8 80 fb ff ff       	call   800626 <vprintfmt>
  800aa6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aac:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ab2:	c9                   	leave  
  800ab3:	c3                   	ret    

00800ab4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ab4:	55                   	push   %ebp
  800ab5:	89 e5                	mov    %esp,%ebp
  800ab7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800aba:	8d 45 10             	lea    0x10(%ebp),%eax
  800abd:	83 c0 04             	add    $0x4,%eax
  800ac0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ac3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac9:	50                   	push   %eax
  800aca:	ff 75 0c             	pushl  0xc(%ebp)
  800acd:	ff 75 08             	pushl  0x8(%ebp)
  800ad0:	e8 89 ff ff ff       	call   800a5e <vsnprintf>
  800ad5:	83 c4 10             	add    $0x10,%esp
  800ad8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800adb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ade:	c9                   	leave  
  800adf:	c3                   	ret    

00800ae0 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800ae6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800aea:	74 13                	je     800aff <readline+0x1f>
		cprintf("%s", prompt);
  800aec:	83 ec 08             	sub    $0x8,%esp
  800aef:	ff 75 08             	pushl  0x8(%ebp)
  800af2:	68 88 27 80 00       	push   $0x802788
  800af7:	e8 0b f9 ff ff       	call   800407 <cprintf>
  800afc:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800aff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800b06:	83 ec 0c             	sub    $0xc,%esp
  800b09:	6a 00                	push   $0x0
  800b0b:	e8 bf 12 00 00       	call   801dcf <iscons>
  800b10:	83 c4 10             	add    $0x10,%esp
  800b13:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800b16:	e8 a1 12 00 00       	call   801dbc <getchar>
  800b1b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800b1e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b22:	79 22                	jns    800b46 <readline+0x66>
			if (c != -E_EOF)
  800b24:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800b28:	0f 84 ad 00 00 00    	je     800bdb <readline+0xfb>
				cprintf("read error: %e\n", c);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 ec             	pushl  -0x14(%ebp)
  800b34:	68 8b 27 80 00       	push   $0x80278b
  800b39:	e8 c9 f8 ff ff       	call   800407 <cprintf>
  800b3e:	83 c4 10             	add    $0x10,%esp
			break;
  800b41:	e9 95 00 00 00       	jmp    800bdb <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800b46:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800b4a:	7e 34                	jle    800b80 <readline+0xa0>
  800b4c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800b53:	7f 2b                	jg     800b80 <readline+0xa0>
			if (echoing)
  800b55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b59:	74 0e                	je     800b69 <readline+0x89>
				cputchar(c);
  800b5b:	83 ec 0c             	sub    $0xc,%esp
  800b5e:	ff 75 ec             	pushl  -0x14(%ebp)
  800b61:	e8 37 12 00 00       	call   801d9d <cputchar>
  800b66:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b6c:	8d 50 01             	lea    0x1(%eax),%edx
  800b6f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800b72:	89 c2                	mov    %eax,%edx
  800b74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b77:	01 d0                	add    %edx,%eax
  800b79:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b7c:	88 10                	mov    %dl,(%eax)
  800b7e:	eb 56                	jmp    800bd6 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800b80:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b84:	75 1f                	jne    800ba5 <readline+0xc5>
  800b86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b8a:	7e 19                	jle    800ba5 <readline+0xc5>
			if (echoing)
  800b8c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b90:	74 0e                	je     800ba0 <readline+0xc0>
				cputchar(c);
  800b92:	83 ec 0c             	sub    $0xc,%esp
  800b95:	ff 75 ec             	pushl  -0x14(%ebp)
  800b98:	e8 00 12 00 00       	call   801d9d <cputchar>
  800b9d:	83 c4 10             	add    $0x10,%esp

			i--;
  800ba0:	ff 4d f4             	decl   -0xc(%ebp)
  800ba3:	eb 31                	jmp    800bd6 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800ba5:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800ba9:	74 0a                	je     800bb5 <readline+0xd5>
  800bab:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800baf:	0f 85 61 ff ff ff    	jne    800b16 <readline+0x36>
			if (echoing)
  800bb5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bb9:	74 0e                	je     800bc9 <readline+0xe9>
				cputchar(c);
  800bbb:	83 ec 0c             	sub    $0xc,%esp
  800bbe:	ff 75 ec             	pushl  -0x14(%ebp)
  800bc1:	e8 d7 11 00 00       	call   801d9d <cputchar>
  800bc6:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800bc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcf:	01 d0                	add    %edx,%eax
  800bd1:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800bd4:	eb 06                	jmp    800bdc <readline+0xfc>
		}
	}
  800bd6:	e9 3b ff ff ff       	jmp    800b16 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800bdb:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800bdc:	90                   	nop
  800bdd:	c9                   	leave  
  800bde:	c3                   	ret    

00800bdf <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800bdf:	55                   	push   %ebp
  800be0:	89 e5                	mov    %esp,%ebp
  800be2:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800be5:	e8 30 0b 00 00       	call   80171a <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800bea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bee:	74 13                	je     800c03 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800bf0:	83 ec 08             	sub    $0x8,%esp
  800bf3:	ff 75 08             	pushl  0x8(%ebp)
  800bf6:	68 88 27 80 00       	push   $0x802788
  800bfb:	e8 07 f8 ff ff       	call   800407 <cprintf>
  800c00:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800c03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800c0a:	83 ec 0c             	sub    $0xc,%esp
  800c0d:	6a 00                	push   $0x0
  800c0f:	e8 bb 11 00 00       	call   801dcf <iscons>
  800c14:	83 c4 10             	add    $0x10,%esp
  800c17:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800c1a:	e8 9d 11 00 00       	call   801dbc <getchar>
  800c1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800c22:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800c26:	79 22                	jns    800c4a <atomic_readline+0x6b>
				if (c != -E_EOF)
  800c28:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800c2c:	0f 84 ad 00 00 00    	je     800cdf <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800c32:	83 ec 08             	sub    $0x8,%esp
  800c35:	ff 75 ec             	pushl  -0x14(%ebp)
  800c38:	68 8b 27 80 00       	push   $0x80278b
  800c3d:	e8 c5 f7 ff ff       	call   800407 <cprintf>
  800c42:	83 c4 10             	add    $0x10,%esp
				break;
  800c45:	e9 95 00 00 00       	jmp    800cdf <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800c4a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800c4e:	7e 34                	jle    800c84 <atomic_readline+0xa5>
  800c50:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800c57:	7f 2b                	jg     800c84 <atomic_readline+0xa5>
				if (echoing)
  800c59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c5d:	74 0e                	je     800c6d <atomic_readline+0x8e>
					cputchar(c);
  800c5f:	83 ec 0c             	sub    $0xc,%esp
  800c62:	ff 75 ec             	pushl  -0x14(%ebp)
  800c65:	e8 33 11 00 00       	call   801d9d <cputchar>
  800c6a:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c70:	8d 50 01             	lea    0x1(%eax),%edx
  800c73:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800c76:	89 c2                	mov    %eax,%edx
  800c78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7b:	01 d0                	add    %edx,%eax
  800c7d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800c80:	88 10                	mov    %dl,(%eax)
  800c82:	eb 56                	jmp    800cda <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800c84:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800c88:	75 1f                	jne    800ca9 <atomic_readline+0xca>
  800c8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800c8e:	7e 19                	jle    800ca9 <atomic_readline+0xca>
				if (echoing)
  800c90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c94:	74 0e                	je     800ca4 <atomic_readline+0xc5>
					cputchar(c);
  800c96:	83 ec 0c             	sub    $0xc,%esp
  800c99:	ff 75 ec             	pushl  -0x14(%ebp)
  800c9c:	e8 fc 10 00 00       	call   801d9d <cputchar>
  800ca1:	83 c4 10             	add    $0x10,%esp
				i--;
  800ca4:	ff 4d f4             	decl   -0xc(%ebp)
  800ca7:	eb 31                	jmp    800cda <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800ca9:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800cad:	74 0a                	je     800cb9 <atomic_readline+0xda>
  800caf:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800cb3:	0f 85 61 ff ff ff    	jne    800c1a <atomic_readline+0x3b>
				if (echoing)
  800cb9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800cbd:	74 0e                	je     800ccd <atomic_readline+0xee>
					cputchar(c);
  800cbf:	83 ec 0c             	sub    $0xc,%esp
  800cc2:	ff 75 ec             	pushl  -0x14(%ebp)
  800cc5:	e8 d3 10 00 00       	call   801d9d <cputchar>
  800cca:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800ccd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd3:	01 d0                	add    %edx,%eax
  800cd5:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800cd8:	eb 06                	jmp    800ce0 <atomic_readline+0x101>
			}
		}
  800cda:	e9 3b ff ff ff       	jmp    800c1a <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800cdf:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800ce0:	e8 4f 0a 00 00       	call   801734 <sys_unlock_cons>
}
  800ce5:	90                   	nop
  800ce6:	c9                   	leave  
  800ce7:	c3                   	ret    

00800ce8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf5:	eb 06                	jmp    800cfd <strlen+0x15>
		n++;
  800cf7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cfa:	ff 45 08             	incl   0x8(%ebp)
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	8a 00                	mov    (%eax),%al
  800d02:	84 c0                	test   %al,%al
  800d04:	75 f1                	jne    800cf7 <strlen+0xf>
		n++;
	return n;
  800d06:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d09:	c9                   	leave  
  800d0a:	c3                   	ret    

00800d0b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d18:	eb 09                	jmp    800d23 <strnlen+0x18>
		n++;
  800d1a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d1d:	ff 45 08             	incl   0x8(%ebp)
  800d20:	ff 4d 0c             	decl   0xc(%ebp)
  800d23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d27:	74 09                	je     800d32 <strnlen+0x27>
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	84 c0                	test   %al,%al
  800d30:	75 e8                	jne    800d1a <strnlen+0xf>
		n++;
	return n;
  800d32:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d35:	c9                   	leave  
  800d36:	c3                   	ret    

00800d37 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d43:	90                   	nop
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8d 50 01             	lea    0x1(%eax),%edx
  800d4a:	89 55 08             	mov    %edx,0x8(%ebp)
  800d4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d50:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d53:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d56:	8a 12                	mov    (%edx),%dl
  800d58:	88 10                	mov    %dl,(%eax)
  800d5a:	8a 00                	mov    (%eax),%al
  800d5c:	84 c0                	test   %al,%al
  800d5e:	75 e4                	jne    800d44 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d60:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d63:	c9                   	leave  
  800d64:	c3                   	ret    

00800d65 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d78:	eb 1f                	jmp    800d99 <strncpy+0x34>
		*dst++ = *src;
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7d:	8d 50 01             	lea    0x1(%eax),%edx
  800d80:	89 55 08             	mov    %edx,0x8(%ebp)
  800d83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d86:	8a 12                	mov    (%edx),%dl
  800d88:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	84 c0                	test   %al,%al
  800d91:	74 03                	je     800d96 <strncpy+0x31>
			src++;
  800d93:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d96:	ff 45 fc             	incl   -0x4(%ebp)
  800d99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d9c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d9f:	72 d9                	jb     800d7a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800da1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800da4:	c9                   	leave  
  800da5:	c3                   	ret    

00800da6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800db2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db6:	74 30                	je     800de8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800db8:	eb 16                	jmp    800dd0 <strlcpy+0x2a>
			*dst++ = *src++;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	8d 50 01             	lea    0x1(%eax),%edx
  800dc0:	89 55 08             	mov    %edx,0x8(%ebp)
  800dc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dc9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dcc:	8a 12                	mov    (%edx),%dl
  800dce:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dd0:	ff 4d 10             	decl   0x10(%ebp)
  800dd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd7:	74 09                	je     800de2 <strlcpy+0x3c>
  800dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddc:	8a 00                	mov    (%eax),%al
  800dde:	84 c0                	test   %al,%al
  800de0:	75 d8                	jne    800dba <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800de8:	8b 55 08             	mov    0x8(%ebp),%edx
  800deb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dee:	29 c2                	sub    %eax,%edx
  800df0:	89 d0                	mov    %edx,%eax
}
  800df2:	c9                   	leave  
  800df3:	c3                   	ret    

00800df4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800df7:	eb 06                	jmp    800dff <strcmp+0xb>
		p++, q++;
  800df9:	ff 45 08             	incl   0x8(%ebp)
  800dfc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	8a 00                	mov    (%eax),%al
  800e04:	84 c0                	test   %al,%al
  800e06:	74 0e                	je     800e16 <strcmp+0x22>
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	8a 10                	mov    (%eax),%dl
  800e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e10:	8a 00                	mov    (%eax),%al
  800e12:	38 c2                	cmp    %al,%dl
  800e14:	74 e3                	je     800df9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	8a 00                	mov    (%eax),%al
  800e1b:	0f b6 d0             	movzbl %al,%edx
  800e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e21:	8a 00                	mov    (%eax),%al
  800e23:	0f b6 c0             	movzbl %al,%eax
  800e26:	29 c2                	sub    %eax,%edx
  800e28:	89 d0                	mov    %edx,%eax
}
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    

00800e2c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e2f:	eb 09                	jmp    800e3a <strncmp+0xe>
		n--, p++, q++;
  800e31:	ff 4d 10             	decl   0x10(%ebp)
  800e34:	ff 45 08             	incl   0x8(%ebp)
  800e37:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e3e:	74 17                	je     800e57 <strncmp+0x2b>
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	8a 00                	mov    (%eax),%al
  800e45:	84 c0                	test   %al,%al
  800e47:	74 0e                	je     800e57 <strncmp+0x2b>
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	8a 10                	mov    (%eax),%dl
  800e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e51:	8a 00                	mov    (%eax),%al
  800e53:	38 c2                	cmp    %al,%dl
  800e55:	74 da                	je     800e31 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e5b:	75 07                	jne    800e64 <strncmp+0x38>
		return 0;
  800e5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800e62:	eb 14                	jmp    800e78 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	8a 00                	mov    (%eax),%al
  800e69:	0f b6 d0             	movzbl %al,%edx
  800e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6f:	8a 00                	mov    (%eax),%al
  800e71:	0f b6 c0             	movzbl %al,%eax
  800e74:	29 c2                	sub    %eax,%edx
  800e76:	89 d0                	mov    %edx,%eax
}
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    

00800e7a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	83 ec 04             	sub    $0x4,%esp
  800e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e83:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e86:	eb 12                	jmp    800e9a <strchr+0x20>
		if (*s == c)
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	8a 00                	mov    (%eax),%al
  800e8d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e90:	75 05                	jne    800e97 <strchr+0x1d>
			return (char *) s;
  800e92:	8b 45 08             	mov    0x8(%ebp),%eax
  800e95:	eb 11                	jmp    800ea8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e97:	ff 45 08             	incl   0x8(%ebp)
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	8a 00                	mov    (%eax),%al
  800e9f:	84 c0                	test   %al,%al
  800ea1:	75 e5                	jne    800e88 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ea3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea8:	c9                   	leave  
  800ea9:	c3                   	ret    

00800eaa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	83 ec 04             	sub    $0x4,%esp
  800eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800eb6:	eb 0d                	jmp    800ec5 <strfind+0x1b>
		if (*s == c)
  800eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ec0:	74 0e                	je     800ed0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ec2:	ff 45 08             	incl   0x8(%ebp)
  800ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec8:	8a 00                	mov    (%eax),%al
  800eca:	84 c0                	test   %al,%al
  800ecc:	75 ea                	jne    800eb8 <strfind+0xe>
  800ece:	eb 01                	jmp    800ed1 <strfind+0x27>
		if (*s == c)
			break;
  800ed0:	90                   	nop
	return (char *) s;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed4:	c9                   	leave  
  800ed5:	c3                   	ret    

00800ed6 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800ee2:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ee6:	76 63                	jbe    800f4b <memset+0x75>
		uint64 data_block = c;
  800ee8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eeb:	99                   	cltd   
  800eec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eef:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ef5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ef8:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800efc:	c1 e0 08             	shl    $0x8,%eax
  800eff:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f02:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800f05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f0b:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800f0f:	c1 e0 10             	shl    $0x10,%eax
  800f12:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f15:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f1e:	89 c2                	mov    %eax,%edx
  800f20:	b8 00 00 00 00       	mov    $0x0,%eax
  800f25:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f28:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800f2b:	eb 18                	jmp    800f45 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800f2d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f30:	8d 41 08             	lea    0x8(%ecx),%eax
  800f33:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800f36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f3c:	89 01                	mov    %eax,(%ecx)
  800f3e:	89 51 04             	mov    %edx,0x4(%ecx)
  800f41:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f45:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f49:	77 e2                	ja     800f2d <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4f:	74 23                	je     800f74 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f54:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f57:	eb 0e                	jmp    800f67 <memset+0x91>
			*p8++ = (uint8)c;
  800f59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5c:	8d 50 01             	lea    0x1(%eax),%edx
  800f5f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f65:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f67:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f70:	85 c0                	test   %eax,%eax
  800f72:	75 e5                	jne    800f59 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f77:	c9                   	leave  
  800f78:	c3                   	ret    

00800f79 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f8b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f8f:	76 24                	jbe    800fb5 <memcpy+0x3c>
		while(n >= 8){
  800f91:	eb 1c                	jmp    800faf <memcpy+0x36>
			*d64 = *s64;
  800f93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f96:	8b 50 04             	mov    0x4(%eax),%edx
  800f99:	8b 00                	mov    (%eax),%eax
  800f9b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f9e:	89 01                	mov    %eax,(%ecx)
  800fa0:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800fa3:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800fa7:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800fab:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800faf:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fb3:	77 de                	ja     800f93 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800fb5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb9:	74 31                	je     800fec <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800fbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800fc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800fc7:	eb 16                	jmp    800fdf <memcpy+0x66>
			*d8++ = *s8++;
  800fc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fcc:	8d 50 01             	lea    0x1(%eax),%edx
  800fcf:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800fd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fd8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800fdb:	8a 12                	mov    (%edx),%dl
  800fdd:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800fdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe5:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe8:	85 c0                	test   %eax,%eax
  800fea:	75 dd                	jne    800fc9 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fef:	c9                   	leave  
  800ff0:	c3                   	ret    

00800ff1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
  800ff4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801003:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801006:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801009:	73 50                	jae    80105b <memmove+0x6a>
  80100b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80100e:	8b 45 10             	mov    0x10(%ebp),%eax
  801011:	01 d0                	add    %edx,%eax
  801013:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801016:	76 43                	jbe    80105b <memmove+0x6a>
		s += n;
  801018:	8b 45 10             	mov    0x10(%ebp),%eax
  80101b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80101e:	8b 45 10             	mov    0x10(%ebp),%eax
  801021:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801024:	eb 10                	jmp    801036 <memmove+0x45>
			*--d = *--s;
  801026:	ff 4d f8             	decl   -0x8(%ebp)
  801029:	ff 4d fc             	decl   -0x4(%ebp)
  80102c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102f:	8a 10                	mov    (%eax),%dl
  801031:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801034:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801036:	8b 45 10             	mov    0x10(%ebp),%eax
  801039:	8d 50 ff             	lea    -0x1(%eax),%edx
  80103c:	89 55 10             	mov    %edx,0x10(%ebp)
  80103f:	85 c0                	test   %eax,%eax
  801041:	75 e3                	jne    801026 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801043:	eb 23                	jmp    801068 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801045:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801048:	8d 50 01             	lea    0x1(%eax),%edx
  80104b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80104e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801051:	8d 4a 01             	lea    0x1(%edx),%ecx
  801054:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801057:	8a 12                	mov    (%edx),%dl
  801059:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80105b:	8b 45 10             	mov    0x10(%ebp),%eax
  80105e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801061:	89 55 10             	mov    %edx,0x10(%ebp)
  801064:	85 c0                	test   %eax,%eax
  801066:	75 dd                	jne    801045 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80106b:	c9                   	leave  
  80106c:	c3                   	ret    

0080106d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80106d:	55                   	push   %ebp
  80106e:	89 e5                	mov    %esp,%ebp
  801070:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801079:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80107f:	eb 2a                	jmp    8010ab <memcmp+0x3e>
		if (*s1 != *s2)
  801081:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801084:	8a 10                	mov    (%eax),%dl
  801086:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801089:	8a 00                	mov    (%eax),%al
  80108b:	38 c2                	cmp    %al,%dl
  80108d:	74 16                	je     8010a5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80108f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801092:	8a 00                	mov    (%eax),%al
  801094:	0f b6 d0             	movzbl %al,%edx
  801097:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109a:	8a 00                	mov    (%eax),%al
  80109c:	0f b6 c0             	movzbl %al,%eax
  80109f:	29 c2                	sub    %eax,%edx
  8010a1:	89 d0                	mov    %edx,%eax
  8010a3:	eb 18                	jmp    8010bd <memcmp+0x50>
		s1++, s2++;
  8010a5:	ff 45 fc             	incl   -0x4(%ebp)
  8010a8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b4:	85 c0                	test   %eax,%eax
  8010b6:	75 c9                	jne    801081 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010bd:	c9                   	leave  
  8010be:	c3                   	ret    

008010bf <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
  8010c2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cb:	01 d0                	add    %edx,%eax
  8010cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010d0:	eb 15                	jmp    8010e7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	0f b6 d0             	movzbl %al,%edx
  8010da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dd:	0f b6 c0             	movzbl %al,%eax
  8010e0:	39 c2                	cmp    %eax,%edx
  8010e2:	74 0d                	je     8010f1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010e4:	ff 45 08             	incl   0x8(%ebp)
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010ed:	72 e3                	jb     8010d2 <memfind+0x13>
  8010ef:	eb 01                	jmp    8010f2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010f1:	90                   	nop
	return (void *) s;
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010f5:	c9                   	leave  
  8010f6:	c3                   	ret    

008010f7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010f7:	55                   	push   %ebp
  8010f8:	89 e5                	mov    %esp,%ebp
  8010fa:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801104:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80110b:	eb 03                	jmp    801110 <strtol+0x19>
		s++;
  80110d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	8a 00                	mov    (%eax),%al
  801115:	3c 20                	cmp    $0x20,%al
  801117:	74 f4                	je     80110d <strtol+0x16>
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
  80111c:	8a 00                	mov    (%eax),%al
  80111e:	3c 09                	cmp    $0x9,%al
  801120:	74 eb                	je     80110d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	8a 00                	mov    (%eax),%al
  801127:	3c 2b                	cmp    $0x2b,%al
  801129:	75 05                	jne    801130 <strtol+0x39>
		s++;
  80112b:	ff 45 08             	incl   0x8(%ebp)
  80112e:	eb 13                	jmp    801143 <strtol+0x4c>
	else if (*s == '-')
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	8a 00                	mov    (%eax),%al
  801135:	3c 2d                	cmp    $0x2d,%al
  801137:	75 0a                	jne    801143 <strtol+0x4c>
		s++, neg = 1;
  801139:	ff 45 08             	incl   0x8(%ebp)
  80113c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801143:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801147:	74 06                	je     80114f <strtol+0x58>
  801149:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80114d:	75 20                	jne    80116f <strtol+0x78>
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	8a 00                	mov    (%eax),%al
  801154:	3c 30                	cmp    $0x30,%al
  801156:	75 17                	jne    80116f <strtol+0x78>
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	40                   	inc    %eax
  80115c:	8a 00                	mov    (%eax),%al
  80115e:	3c 78                	cmp    $0x78,%al
  801160:	75 0d                	jne    80116f <strtol+0x78>
		s += 2, base = 16;
  801162:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801166:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80116d:	eb 28                	jmp    801197 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80116f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801173:	75 15                	jne    80118a <strtol+0x93>
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	3c 30                	cmp    $0x30,%al
  80117c:	75 0c                	jne    80118a <strtol+0x93>
		s++, base = 8;
  80117e:	ff 45 08             	incl   0x8(%ebp)
  801181:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801188:	eb 0d                	jmp    801197 <strtol+0xa0>
	else if (base == 0)
  80118a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118e:	75 07                	jne    801197 <strtol+0xa0>
		base = 10;
  801190:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	3c 2f                	cmp    $0x2f,%al
  80119e:	7e 19                	jle    8011b9 <strtol+0xc2>
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	3c 39                	cmp    $0x39,%al
  8011a7:	7f 10                	jg     8011b9 <strtol+0xc2>
			dig = *s - '0';
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	0f be c0             	movsbl %al,%eax
  8011b1:	83 e8 30             	sub    $0x30,%eax
  8011b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011b7:	eb 42                	jmp    8011fb <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	3c 60                	cmp    $0x60,%al
  8011c0:	7e 19                	jle    8011db <strtol+0xe4>
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	8a 00                	mov    (%eax),%al
  8011c7:	3c 7a                	cmp    $0x7a,%al
  8011c9:	7f 10                	jg     8011db <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	8a 00                	mov    (%eax),%al
  8011d0:	0f be c0             	movsbl %al,%eax
  8011d3:	83 e8 57             	sub    $0x57,%eax
  8011d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011d9:	eb 20                	jmp    8011fb <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
  8011de:	8a 00                	mov    (%eax),%al
  8011e0:	3c 40                	cmp    $0x40,%al
  8011e2:	7e 39                	jle    80121d <strtol+0x126>
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	8a 00                	mov    (%eax),%al
  8011e9:	3c 5a                	cmp    $0x5a,%al
  8011eb:	7f 30                	jg     80121d <strtol+0x126>
			dig = *s - 'A' + 10;
  8011ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f0:	8a 00                	mov    (%eax),%al
  8011f2:	0f be c0             	movsbl %al,%eax
  8011f5:	83 e8 37             	sub    $0x37,%eax
  8011f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011fe:	3b 45 10             	cmp    0x10(%ebp),%eax
  801201:	7d 19                	jge    80121c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801203:	ff 45 08             	incl   0x8(%ebp)
  801206:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801209:	0f af 45 10          	imul   0x10(%ebp),%eax
  80120d:	89 c2                	mov    %eax,%edx
  80120f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801212:	01 d0                	add    %edx,%eax
  801214:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801217:	e9 7b ff ff ff       	jmp    801197 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80121c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80121d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801221:	74 08                	je     80122b <strtol+0x134>
		*endptr = (char *) s;
  801223:	8b 45 0c             	mov    0xc(%ebp),%eax
  801226:	8b 55 08             	mov    0x8(%ebp),%edx
  801229:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80122b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80122f:	74 07                	je     801238 <strtol+0x141>
  801231:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801234:	f7 d8                	neg    %eax
  801236:	eb 03                	jmp    80123b <strtol+0x144>
  801238:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80123b:	c9                   	leave  
  80123c:	c3                   	ret    

0080123d <ltostr>:

void
ltostr(long value, char *str)
{
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
  801240:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801243:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80124a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801251:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801255:	79 13                	jns    80126a <ltostr+0x2d>
	{
		neg = 1;
  801257:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80125e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801261:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801264:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801267:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801272:	99                   	cltd   
  801273:	f7 f9                	idiv   %ecx
  801275:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801278:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127b:	8d 50 01             	lea    0x1(%eax),%edx
  80127e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801281:	89 c2                	mov    %eax,%edx
  801283:	8b 45 0c             	mov    0xc(%ebp),%eax
  801286:	01 d0                	add    %edx,%eax
  801288:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80128b:	83 c2 30             	add    $0x30,%edx
  80128e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801290:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801293:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801298:	f7 e9                	imul   %ecx
  80129a:	c1 fa 02             	sar    $0x2,%edx
  80129d:	89 c8                	mov    %ecx,%eax
  80129f:	c1 f8 1f             	sar    $0x1f,%eax
  8012a2:	29 c2                	sub    %eax,%edx
  8012a4:	89 d0                	mov    %edx,%eax
  8012a6:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8012a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012ad:	75 bb                	jne    80126a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b9:	48                   	dec    %eax
  8012ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8012bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012c1:	74 3d                	je     801300 <ltostr+0xc3>
		start = 1 ;
  8012c3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8012ca:	eb 34                	jmp    801300 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8012cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d2:	01 d0                	add    %edx,%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012df:	01 c2                	add    %eax,%edx
  8012e1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e7:	01 c8                	add    %ecx,%eax
  8012e9:	8a 00                	mov    (%eax),%al
  8012eb:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f3:	01 c2                	add    %eax,%edx
  8012f5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012f8:	88 02                	mov    %al,(%edx)
		start++ ;
  8012fa:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012fd:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801303:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801306:	7c c4                	jl     8012cc <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801308:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80130b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130e:	01 d0                	add    %edx,%eax
  801310:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801313:	90                   	nop
  801314:	c9                   	leave  
  801315:	c3                   	ret    

00801316 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
  801319:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80131c:	ff 75 08             	pushl  0x8(%ebp)
  80131f:	e8 c4 f9 ff ff       	call   800ce8 <strlen>
  801324:	83 c4 04             	add    $0x4,%esp
  801327:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80132a:	ff 75 0c             	pushl  0xc(%ebp)
  80132d:	e8 b6 f9 ff ff       	call   800ce8 <strlen>
  801332:	83 c4 04             	add    $0x4,%esp
  801335:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801338:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80133f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801346:	eb 17                	jmp    80135f <strcconcat+0x49>
		final[s] = str1[s] ;
  801348:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80134b:	8b 45 10             	mov    0x10(%ebp),%eax
  80134e:	01 c2                	add    %eax,%edx
  801350:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	01 c8                	add    %ecx,%eax
  801358:	8a 00                	mov    (%eax),%al
  80135a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80135c:	ff 45 fc             	incl   -0x4(%ebp)
  80135f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801362:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801365:	7c e1                	jl     801348 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801367:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80136e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801375:	eb 1f                	jmp    801396 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801377:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137a:	8d 50 01             	lea    0x1(%eax),%edx
  80137d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801380:	89 c2                	mov    %eax,%edx
  801382:	8b 45 10             	mov    0x10(%ebp),%eax
  801385:	01 c2                	add    %eax,%edx
  801387:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80138a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138d:	01 c8                	add    %ecx,%eax
  80138f:	8a 00                	mov    (%eax),%al
  801391:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801393:	ff 45 f8             	incl   -0x8(%ebp)
  801396:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801399:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80139c:	7c d9                	jl     801377 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80139e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a4:	01 d0                	add    %edx,%eax
  8013a6:	c6 00 00             	movb   $0x0,(%eax)
}
  8013a9:	90                   	nop
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013af:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bb:	8b 00                	mov    (%eax),%eax
  8013bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c7:	01 d0                	add    %edx,%eax
  8013c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013cf:	eb 0c                	jmp    8013dd <strsplit+0x31>
			*string++ = 0;
  8013d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d4:	8d 50 01             	lea    0x1(%eax),%edx
  8013d7:	89 55 08             	mov    %edx,0x8(%ebp)
  8013da:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e0:	8a 00                	mov    (%eax),%al
  8013e2:	84 c0                	test   %al,%al
  8013e4:	74 18                	je     8013fe <strsplit+0x52>
  8013e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e9:	8a 00                	mov    (%eax),%al
  8013eb:	0f be c0             	movsbl %al,%eax
  8013ee:	50                   	push   %eax
  8013ef:	ff 75 0c             	pushl  0xc(%ebp)
  8013f2:	e8 83 fa ff ff       	call   800e7a <strchr>
  8013f7:	83 c4 08             	add    $0x8,%esp
  8013fa:	85 c0                	test   %eax,%eax
  8013fc:	75 d3                	jne    8013d1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	8a 00                	mov    (%eax),%al
  801403:	84 c0                	test   %al,%al
  801405:	74 5a                	je     801461 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801407:	8b 45 14             	mov    0x14(%ebp),%eax
  80140a:	8b 00                	mov    (%eax),%eax
  80140c:	83 f8 0f             	cmp    $0xf,%eax
  80140f:	75 07                	jne    801418 <strsplit+0x6c>
		{
			return 0;
  801411:	b8 00 00 00 00       	mov    $0x0,%eax
  801416:	eb 66                	jmp    80147e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801418:	8b 45 14             	mov    0x14(%ebp),%eax
  80141b:	8b 00                	mov    (%eax),%eax
  80141d:	8d 48 01             	lea    0x1(%eax),%ecx
  801420:	8b 55 14             	mov    0x14(%ebp),%edx
  801423:	89 0a                	mov    %ecx,(%edx)
  801425:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80142c:	8b 45 10             	mov    0x10(%ebp),%eax
  80142f:	01 c2                	add    %eax,%edx
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801436:	eb 03                	jmp    80143b <strsplit+0x8f>
			string++;
  801438:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80143b:	8b 45 08             	mov    0x8(%ebp),%eax
  80143e:	8a 00                	mov    (%eax),%al
  801440:	84 c0                	test   %al,%al
  801442:	74 8b                	je     8013cf <strsplit+0x23>
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	8a 00                	mov    (%eax),%al
  801449:	0f be c0             	movsbl %al,%eax
  80144c:	50                   	push   %eax
  80144d:	ff 75 0c             	pushl  0xc(%ebp)
  801450:	e8 25 fa ff ff       	call   800e7a <strchr>
  801455:	83 c4 08             	add    $0x8,%esp
  801458:	85 c0                	test   %eax,%eax
  80145a:	74 dc                	je     801438 <strsplit+0x8c>
			string++;
	}
  80145c:	e9 6e ff ff ff       	jmp    8013cf <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801461:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801462:	8b 45 14             	mov    0x14(%ebp),%eax
  801465:	8b 00                	mov    (%eax),%eax
  801467:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80146e:	8b 45 10             	mov    0x10(%ebp),%eax
  801471:	01 d0                	add    %edx,%eax
  801473:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801479:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
  801489:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80148c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801493:	eb 4a                	jmp    8014df <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801495:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	01 c2                	add    %eax,%edx
  80149d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a3:	01 c8                	add    %ecx,%eax
  8014a5:	8a 00                	mov    (%eax),%al
  8014a7:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8014a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014af:	01 d0                	add    %edx,%eax
  8014b1:	8a 00                	mov    (%eax),%al
  8014b3:	3c 40                	cmp    $0x40,%al
  8014b5:	7e 25                	jle    8014dc <str2lower+0x5c>
  8014b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bd:	01 d0                	add    %edx,%eax
  8014bf:	8a 00                	mov    (%eax),%al
  8014c1:	3c 5a                	cmp    $0x5a,%al
  8014c3:	7f 17                	jg     8014dc <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8014c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	01 d0                	add    %edx,%eax
  8014cd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d3:	01 ca                	add    %ecx,%edx
  8014d5:	8a 12                	mov    (%edx),%dl
  8014d7:	83 c2 20             	add    $0x20,%edx
  8014da:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8014dc:	ff 45 fc             	incl   -0x4(%ebp)
  8014df:	ff 75 0c             	pushl  0xc(%ebp)
  8014e2:	e8 01 f8 ff ff       	call   800ce8 <strlen>
  8014e7:	83 c4 04             	add    $0x4,%esp
  8014ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014ed:	7f a6                	jg     801495 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
  8014f7:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8014fa:	a1 08 30 80 00       	mov    0x803008,%eax
  8014ff:	85 c0                	test   %eax,%eax
  801501:	74 42                	je     801545 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801503:	83 ec 08             	sub    $0x8,%esp
  801506:	68 00 00 00 82       	push   $0x82000000
  80150b:	68 00 00 00 80       	push   $0x80000000
  801510:	e8 8c 07 00 00       	call   801ca1 <initialize_dynamic_allocator>
  801515:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801518:	e8 e7 05 00 00       	call   801b04 <sys_get_uheap_strategy>
  80151d:	a3 60 b0 81 00       	mov    %eax,0x81b060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801522:	a1 40 30 80 00       	mov    0x803040,%eax
  801527:	05 00 10 00 00       	add    $0x1000,%eax
  80152c:	a3 10 b1 81 00       	mov    %eax,0x81b110
		uheapPageAllocBreak = uheapPageAllocStart;
  801531:	a1 10 b1 81 00       	mov    0x81b110,%eax
  801536:	a3 68 b0 81 00       	mov    %eax,0x81b068

		__firstTimeFlag = 0;
  80153b:	c7 05 08 30 80 00 00 	movl   $0x0,0x803008
  801542:	00 00 00 
	}
}
  801545:	90                   	nop
  801546:	c9                   	leave  
  801547:	c3                   	ret    

00801548 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
  80154b:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80154e:	8b 45 08             	mov    0x8(%ebp),%eax
  801551:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801557:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80155c:	83 ec 08             	sub    $0x8,%esp
  80155f:	68 06 04 00 00       	push   $0x406
  801564:	50                   	push   %eax
  801565:	e8 e4 01 00 00       	call   80174e <__sys_allocate_page>
  80156a:	83 c4 10             	add    $0x10,%esp
  80156d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801570:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801574:	79 14                	jns    80158a <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801576:	83 ec 04             	sub    $0x4,%esp
  801579:	68 9c 27 80 00       	push   $0x80279c
  80157e:	6a 1f                	push   $0x1f
  801580:	68 d8 27 80 00       	push   $0x8027d8
  801585:	e8 4f 08 00 00       	call   801dd9 <_panic>
	return 0;
  80158a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80158f:	c9                   	leave  
  801590:	c3                   	ret    

00801591 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
  801594:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801597:	8b 45 08             	mov    0x8(%ebp),%eax
  80159a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80159d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015a5:	83 ec 0c             	sub    $0xc,%esp
  8015a8:	50                   	push   %eax
  8015a9:	e8 e7 01 00 00       	call   801795 <__sys_unmap_frame>
  8015ae:	83 c4 10             	add    $0x10,%esp
  8015b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8015b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015b8:	79 14                	jns    8015ce <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8015ba:	83 ec 04             	sub    $0x4,%esp
  8015bd:	68 e4 27 80 00       	push   $0x8027e4
  8015c2:	6a 2a                	push   $0x2a
  8015c4:	68 d8 27 80 00       	push   $0x8027d8
  8015c9:	e8 0b 08 00 00       	call   801dd9 <_panic>
}
  8015ce:	90                   	nop
  8015cf:	c9                   	leave  
  8015d0:	c3                   	ret    

008015d1 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
  8015d4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8015d7:	e8 18 ff ff ff       	call   8014f4 <uheap_init>
	if (size == 0) return NULL ;
  8015dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015e0:	75 07                	jne    8015e9 <malloc+0x18>
  8015e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e7:	eb 14                	jmp    8015fd <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  8015e9:	83 ec 04             	sub    $0x4,%esp
  8015ec:	68 24 28 80 00       	push   $0x802824
  8015f1:	6a 3e                	push   $0x3e
  8015f3:	68 d8 27 80 00       	push   $0x8027d8
  8015f8:	e8 dc 07 00 00       	call   801dd9 <_panic>
}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801605:	83 ec 04             	sub    $0x4,%esp
  801608:	68 4c 28 80 00       	push   $0x80284c
  80160d:	6a 49                	push   $0x49
  80160f:	68 d8 27 80 00       	push   $0x8027d8
  801614:	e8 c0 07 00 00       	call   801dd9 <_panic>

00801619 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
  80161c:	83 ec 18             	sub    $0x18,%esp
  80161f:	8b 45 10             	mov    0x10(%ebp),%eax
  801622:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801625:	e8 ca fe ff ff       	call   8014f4 <uheap_init>
	if (size == 0) return NULL ;
  80162a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80162e:	75 07                	jne    801637 <smalloc+0x1e>
  801630:	b8 00 00 00 00       	mov    $0x0,%eax
  801635:	eb 14                	jmp    80164b <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801637:	83 ec 04             	sub    $0x4,%esp
  80163a:	68 70 28 80 00       	push   $0x802870
  80163f:	6a 5a                	push   $0x5a
  801641:	68 d8 27 80 00       	push   $0x8027d8
  801646:	e8 8e 07 00 00       	call   801dd9 <_panic>
}
  80164b:	c9                   	leave  
  80164c:	c3                   	ret    

0080164d <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
  801650:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801653:	e8 9c fe ff ff       	call   8014f4 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801658:	83 ec 04             	sub    $0x4,%esp
  80165b:	68 98 28 80 00       	push   $0x802898
  801660:	6a 6a                	push   $0x6a
  801662:	68 d8 27 80 00       	push   $0x8027d8
  801667:	e8 6d 07 00 00       	call   801dd9 <_panic>

0080166c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801672:	e8 7d fe ff ff       	call   8014f4 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801677:	83 ec 04             	sub    $0x4,%esp
  80167a:	68 bc 28 80 00       	push   $0x8028bc
  80167f:	68 88 00 00 00       	push   $0x88
  801684:	68 d8 27 80 00       	push   $0x8027d8
  801689:	e8 4b 07 00 00       	call   801dd9 <_panic>

0080168e <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801694:	83 ec 04             	sub    $0x4,%esp
  801697:	68 e4 28 80 00       	push   $0x8028e4
  80169c:	68 9b 00 00 00       	push   $0x9b
  8016a1:	68 d8 27 80 00       	push   $0x8027d8
  8016a6:	e8 2e 07 00 00       	call   801dd9 <_panic>

008016ab <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	57                   	push   %edi
  8016af:	56                   	push   %esi
  8016b0:	53                   	push   %ebx
  8016b1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016bd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016c0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016c3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016c6:	cd 30                	int    $0x30
  8016c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8016cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016ce:	83 c4 10             	add    $0x10,%esp
  8016d1:	5b                   	pop    %ebx
  8016d2:	5e                   	pop    %esi
  8016d3:	5f                   	pop    %edi
  8016d4:	5d                   	pop    %ebp
  8016d5:	c3                   	ret    

008016d6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
  8016d9:	83 ec 04             	sub    $0x4,%esp
  8016dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016df:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8016e2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016e5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	6a 00                	push   $0x0
  8016ee:	51                   	push   %ecx
  8016ef:	52                   	push   %edx
  8016f0:	ff 75 0c             	pushl  0xc(%ebp)
  8016f3:	50                   	push   %eax
  8016f4:	6a 00                	push   $0x0
  8016f6:	e8 b0 ff ff ff       	call   8016ab <syscall>
  8016fb:	83 c4 18             	add    $0x18,%esp
}
  8016fe:	90                   	nop
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <sys_cgetc>:

int
sys_cgetc(void)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 02                	push   $0x2
  801710:	e8 96 ff ff ff       	call   8016ab <syscall>
  801715:	83 c4 18             	add    $0x18,%esp
}
  801718:	c9                   	leave  
  801719:	c3                   	ret    

0080171a <sys_lock_cons>:

void sys_lock_cons(void)
{
  80171a:	55                   	push   %ebp
  80171b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 03                	push   $0x3
  801729:	e8 7d ff ff ff       	call   8016ab <syscall>
  80172e:	83 c4 18             	add    $0x18,%esp
}
  801731:	90                   	nop
  801732:	c9                   	leave  
  801733:	c3                   	ret    

00801734 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 04                	push   $0x4
  801743:	e8 63 ff ff ff       	call   8016ab <syscall>
  801748:	83 c4 18             	add    $0x18,%esp
}
  80174b:	90                   	nop
  80174c:	c9                   	leave  
  80174d:	c3                   	ret    

0080174e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801751:	8b 55 0c             	mov    0xc(%ebp),%edx
  801754:	8b 45 08             	mov    0x8(%ebp),%eax
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	52                   	push   %edx
  80175e:	50                   	push   %eax
  80175f:	6a 08                	push   $0x8
  801761:	e8 45 ff ff ff       	call   8016ab <syscall>
  801766:	83 c4 18             	add    $0x18,%esp
}
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
  80176e:	56                   	push   %esi
  80176f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801770:	8b 75 18             	mov    0x18(%ebp),%esi
  801773:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801776:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801779:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	56                   	push   %esi
  801780:	53                   	push   %ebx
  801781:	51                   	push   %ecx
  801782:	52                   	push   %edx
  801783:	50                   	push   %eax
  801784:	6a 09                	push   $0x9
  801786:	e8 20 ff ff ff       	call   8016ab <syscall>
  80178b:	83 c4 18             	add    $0x18,%esp
}
  80178e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801791:	5b                   	pop    %ebx
  801792:	5e                   	pop    %esi
  801793:	5d                   	pop    %ebp
  801794:	c3                   	ret    

00801795 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	ff 75 08             	pushl  0x8(%ebp)
  8017a3:	6a 0a                	push   $0xa
  8017a5:	e8 01 ff ff ff       	call   8016ab <syscall>
  8017aa:	83 c4 18             	add    $0x18,%esp
}
  8017ad:	c9                   	leave  
  8017ae:	c3                   	ret    

008017af <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	ff 75 0c             	pushl  0xc(%ebp)
  8017bb:	ff 75 08             	pushl  0x8(%ebp)
  8017be:	6a 0b                	push   $0xb
  8017c0:	e8 e6 fe ff ff       	call   8016ab <syscall>
  8017c5:	83 c4 18             	add    $0x18,%esp
}
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    

008017ca <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 0c                	push   $0xc
  8017d9:	e8 cd fe ff ff       	call   8016ab <syscall>
  8017de:	83 c4 18             	add    $0x18,%esp
}
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    

008017e3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 0d                	push   $0xd
  8017f2:	e8 b4 fe ff ff       	call   8016ab <syscall>
  8017f7:	83 c4 18             	add    $0x18,%esp
}
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 0e                	push   $0xe
  80180b:	e8 9b fe ff ff       	call   8016ab <syscall>
  801810:	83 c4 18             	add    $0x18,%esp
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 0f                	push   $0xf
  801824:	e8 82 fe ff ff       	call   8016ab <syscall>
  801829:	83 c4 18             	add    $0x18,%esp
}
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	ff 75 08             	pushl  0x8(%ebp)
  80183c:	6a 10                	push   $0x10
  80183e:	e8 68 fe ff ff       	call   8016ab <syscall>
  801843:	83 c4 18             	add    $0x18,%esp
}
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 11                	push   $0x11
  801857:	e8 4f fe ff ff       	call   8016ab <syscall>
  80185c:	83 c4 18             	add    $0x18,%esp
}
  80185f:	90                   	nop
  801860:	c9                   	leave  
  801861:	c3                   	ret    

00801862 <sys_cputc>:

void
sys_cputc(const char c)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
  801865:	83 ec 04             	sub    $0x4,%esp
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
  80186b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80186e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	50                   	push   %eax
  80187b:	6a 01                	push   $0x1
  80187d:	e8 29 fe ff ff       	call   8016ab <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
}
  801885:	90                   	nop
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 14                	push   $0x14
  801897:	e8 0f fe ff ff       	call   8016ab <syscall>
  80189c:	83 c4 18             	add    $0x18,%esp
}
  80189f:	90                   	nop
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	83 ec 04             	sub    $0x4,%esp
  8018a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018ae:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018b1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	6a 00                	push   $0x0
  8018ba:	51                   	push   %ecx
  8018bb:	52                   	push   %edx
  8018bc:	ff 75 0c             	pushl  0xc(%ebp)
  8018bf:	50                   	push   %eax
  8018c0:	6a 15                	push   $0x15
  8018c2:	e8 e4 fd ff ff       	call   8016ab <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
}
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	52                   	push   %edx
  8018dc:	50                   	push   %eax
  8018dd:	6a 16                	push   $0x16
  8018df:	e8 c7 fd ff ff       	call   8016ab <syscall>
  8018e4:	83 c4 18             	add    $0x18,%esp
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	51                   	push   %ecx
  8018fa:	52                   	push   %edx
  8018fb:	50                   	push   %eax
  8018fc:	6a 17                	push   $0x17
  8018fe:	e8 a8 fd ff ff       	call   8016ab <syscall>
  801903:	83 c4 18             	add    $0x18,%esp
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80190b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190e:	8b 45 08             	mov    0x8(%ebp),%eax
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	52                   	push   %edx
  801918:	50                   	push   %eax
  801919:	6a 18                	push   $0x18
  80191b:	e8 8b fd ff ff       	call   8016ab <syscall>
  801920:	83 c4 18             	add    $0x18,%esp
}
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801928:	8b 45 08             	mov    0x8(%ebp),%eax
  80192b:	6a 00                	push   $0x0
  80192d:	ff 75 14             	pushl  0x14(%ebp)
  801930:	ff 75 10             	pushl  0x10(%ebp)
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	50                   	push   %eax
  801937:	6a 19                	push   $0x19
  801939:	e8 6d fd ff ff       	call   8016ab <syscall>
  80193e:	83 c4 18             	add    $0x18,%esp
}
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	50                   	push   %eax
  801952:	6a 1a                	push   $0x1a
  801954:	e8 52 fd ff ff       	call   8016ab <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
}
  80195c:	90                   	nop
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	50                   	push   %eax
  80196e:	6a 1b                	push   $0x1b
  801970:	e8 36 fd ff ff       	call   8016ab <syscall>
  801975:	83 c4 18             	add    $0x18,%esp
}
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 05                	push   $0x5
  801989:	e8 1d fd ff ff       	call   8016ab <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 06                	push   $0x6
  8019a2:	e8 04 fd ff ff       	call   8016ab <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
}
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 07                	push   $0x7
  8019bb:	e8 eb fc ff ff       	call   8016ab <syscall>
  8019c0:	83 c4 18             	add    $0x18,%esp
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <sys_exit_env>:


void sys_exit_env(void)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 1c                	push   $0x1c
  8019d4:	e8 d2 fc ff ff       	call   8016ab <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
}
  8019dc:	90                   	nop
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
  8019e2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019e5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019e8:	8d 50 04             	lea    0x4(%eax),%edx
  8019eb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	52                   	push   %edx
  8019f5:	50                   	push   %eax
  8019f6:	6a 1d                	push   $0x1d
  8019f8:	e8 ae fc ff ff       	call   8016ab <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
	return result;
  801a00:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a03:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a06:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a09:	89 01                	mov    %eax,(%ecx)
  801a0b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a11:	c9                   	leave  
  801a12:	c2 04 00             	ret    $0x4

00801a15 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	ff 75 10             	pushl  0x10(%ebp)
  801a1f:	ff 75 0c             	pushl  0xc(%ebp)
  801a22:	ff 75 08             	pushl  0x8(%ebp)
  801a25:	6a 13                	push   $0x13
  801a27:	e8 7f fc ff ff       	call   8016ab <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a2f:	90                   	nop
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 1e                	push   $0x1e
  801a41:	e8 65 fc ff ff       	call   8016ab <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
  801a4e:	83 ec 04             	sub    $0x4,%esp
  801a51:	8b 45 08             	mov    0x8(%ebp),%eax
  801a54:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a57:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	50                   	push   %eax
  801a64:	6a 1f                	push   $0x1f
  801a66:	e8 40 fc ff ff       	call   8016ab <syscall>
  801a6b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a6e:	90                   	nop
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <rsttst>:
void rsttst()
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 21                	push   $0x21
  801a80:	e8 26 fc ff ff       	call   8016ab <syscall>
  801a85:	83 c4 18             	add    $0x18,%esp
	return ;
  801a88:	90                   	nop
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	83 ec 04             	sub    $0x4,%esp
  801a91:	8b 45 14             	mov    0x14(%ebp),%eax
  801a94:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a97:	8b 55 18             	mov    0x18(%ebp),%edx
  801a9a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a9e:	52                   	push   %edx
  801a9f:	50                   	push   %eax
  801aa0:	ff 75 10             	pushl  0x10(%ebp)
  801aa3:	ff 75 0c             	pushl  0xc(%ebp)
  801aa6:	ff 75 08             	pushl  0x8(%ebp)
  801aa9:	6a 20                	push   $0x20
  801aab:	e8 fb fb ff ff       	call   8016ab <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab3:	90                   	nop
}
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <chktst>:
void chktst(uint32 n)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	ff 75 08             	pushl  0x8(%ebp)
  801ac4:	6a 22                	push   $0x22
  801ac6:	e8 e0 fb ff ff       	call   8016ab <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
	return ;
  801ace:	90                   	nop
}
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <inctst>:

void inctst()
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 23                	push   $0x23
  801ae0:	e8 c6 fb ff ff       	call   8016ab <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae8:	90                   	nop
}
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <gettst>:
uint32 gettst()
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 24                	push   $0x24
  801afa:	e8 ac fb ff ff       	call   8016ab <syscall>
  801aff:	83 c4 18             	add    $0x18,%esp
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 25                	push   $0x25
  801b13:	e8 93 fb ff ff       	call   8016ab <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
  801b1b:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801b20:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2d:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	ff 75 08             	pushl  0x8(%ebp)
  801b3d:	6a 26                	push   $0x26
  801b3f:	e8 67 fb ff ff       	call   8016ab <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
	return ;
  801b47:	90                   	nop
}
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
  801b4d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b4e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b51:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b57:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5a:	6a 00                	push   $0x0
  801b5c:	53                   	push   %ebx
  801b5d:	51                   	push   %ecx
  801b5e:	52                   	push   %edx
  801b5f:	50                   	push   %eax
  801b60:	6a 27                	push   $0x27
  801b62:	e8 44 fb ff ff       	call   8016ab <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
}
  801b6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b75:	8b 45 08             	mov    0x8(%ebp),%eax
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	52                   	push   %edx
  801b7f:	50                   	push   %eax
  801b80:	6a 28                	push   $0x28
  801b82:	e8 24 fb ff ff       	call   8016ab <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b8f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b95:	8b 45 08             	mov    0x8(%ebp),%eax
  801b98:	6a 00                	push   $0x0
  801b9a:	51                   	push   %ecx
  801b9b:	ff 75 10             	pushl  0x10(%ebp)
  801b9e:	52                   	push   %edx
  801b9f:	50                   	push   %eax
  801ba0:	6a 29                	push   $0x29
  801ba2:	e8 04 fb ff ff       	call   8016ab <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	ff 75 10             	pushl  0x10(%ebp)
  801bb6:	ff 75 0c             	pushl  0xc(%ebp)
  801bb9:	ff 75 08             	pushl  0x8(%ebp)
  801bbc:	6a 12                	push   $0x12
  801bbe:	e8 e8 fa ff ff       	call   8016ab <syscall>
  801bc3:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc6:	90                   	nop
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801bcc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	52                   	push   %edx
  801bd9:	50                   	push   %eax
  801bda:	6a 2a                	push   $0x2a
  801bdc:	e8 ca fa ff ff       	call   8016ab <syscall>
  801be1:	83 c4 18             	add    $0x18,%esp
	return;
  801be4:	90                   	nop
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 2b                	push   $0x2b
  801bf6:	e8 b0 fa ff ff       	call   8016ab <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	ff 75 0c             	pushl  0xc(%ebp)
  801c0c:	ff 75 08             	pushl  0x8(%ebp)
  801c0f:	6a 2d                	push   $0x2d
  801c11:	e8 95 fa ff ff       	call   8016ab <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
	return;
  801c19:	90                   	nop
}
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	ff 75 0c             	pushl  0xc(%ebp)
  801c28:	ff 75 08             	pushl  0x8(%ebp)
  801c2b:	6a 2c                	push   $0x2c
  801c2d:	e8 79 fa ff ff       	call   8016ab <syscall>
  801c32:	83 c4 18             	add    $0x18,%esp
	return ;
  801c35:	90                   	nop
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801c3e:	83 ec 04             	sub    $0x4,%esp
  801c41:	68 08 29 80 00       	push   $0x802908
  801c46:	68 25 01 00 00       	push   $0x125
  801c4b:	68 3b 29 80 00       	push   $0x80293b
  801c50:	e8 84 01 00 00       	call   801dd9 <_panic>

00801c55 <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5e:	ba 60 30 80 00       	mov    $0x803060,%edx
  801c63:	29 d0                	sub    %edx,%eax
  801c65:	c1 f8 02             	sar    $0x2,%eax
  801c68:	89 c2                	mov    %eax,%edx
  801c6a:	89 d0                	mov    %edx,%eax
  801c6c:	c1 e0 02             	shl    $0x2,%eax
  801c6f:	01 d0                	add    %edx,%eax
  801c71:	c1 e0 02             	shl    $0x2,%eax
  801c74:	01 d0                	add    %edx,%eax
  801c76:	c1 e0 02             	shl    $0x2,%eax
  801c79:	01 d0                	add    %edx,%eax
  801c7b:	89 c1                	mov    %eax,%ecx
  801c7d:	c1 e1 08             	shl    $0x8,%ecx
  801c80:	01 c8                	add    %ecx,%eax
  801c82:	89 c1                	mov    %eax,%ecx
  801c84:	c1 e1 10             	shl    $0x10,%ecx
  801c87:	01 c8                	add    %ecx,%eax
  801c89:	01 c0                	add    %eax,%eax
  801c8b:	01 d0                	add    %edx,%eax
  801c8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801c90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c93:	c1 e0 0c             	shl    $0xc,%eax
  801c96:	89 c2                	mov    %eax,%edx
  801c98:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801c9d:	01 d0                	add    %edx,%eax
}
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
  801ca4:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	05 00 00 00 02       	add    $0x2000000,%eax
  801caf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801cb2:	73 16                	jae    801cca <initialize_dynamic_allocator+0x29>
  801cb4:	68 4c 29 80 00       	push   $0x80294c
  801cb9:	68 72 29 80 00       	push   $0x802972
  801cbe:	6a 26                	push   $0x26
  801cc0:	68 87 29 80 00       	push   $0x802987
  801cc5:	e8 0f 01 00 00       	call   801dd9 <_panic>
		is_initialized = 1;
  801cca:	c7 05 24 30 80 00 01 	movl   $0x1,0x803024
  801cd1:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	//Comment the following line
	panic("initialize_dynamic_allocator() Not implemented yet");
  801cd4:	83 ec 04             	sub    $0x4,%esp
  801cd7:	68 a0 29 80 00       	push   $0x8029a0
  801cdc:	6a 2e                	push   $0x2e
  801cde:	68 87 29 80 00       	push   $0x802987
  801ce3:	e8 f1 00 00 00       	call   801dd9 <_panic>

00801ce8 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	//Comment the following line
	panic("get_block_size() Not implemented yet");
  801cee:	83 ec 04             	sub    $0x4,%esp
  801cf1:	68 d4 29 80 00       	push   $0x8029d4
  801cf6:	6a 3a                	push   $0x3a
  801cf8:	68 87 29 80 00       	push   $0x802987
  801cfd:	e8 d7 00 00 00       	call   801dd9 <_panic>

00801d02 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
  801d05:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  801d08:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801d0f:	76 16                	jbe    801d27 <alloc_block+0x25>
  801d11:	68 fc 29 80 00       	push   $0x8029fc
  801d16:	68 72 29 80 00       	push   $0x802972
  801d1b:	6a 46                	push   $0x46
  801d1d:	68 87 29 80 00       	push   $0x802987
  801d22:	e8 b2 00 00 00       	call   801dd9 <_panic>
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	panic("alloc_block() Not implemented yet");
  801d27:	83 ec 04             	sub    $0x4,%esp
  801d2a:	68 20 2a 80 00       	push   $0x802a20
  801d2f:	6a 4d                	push   $0x4d
  801d31:	68 87 29 80 00       	push   $0x802987
  801d36:	e8 9e 00 00 00       	call   801dd9 <_panic>

00801d3b <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	83 ec 08             	sub    $0x8,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  801d41:	8b 55 08             	mov    0x8(%ebp),%edx
  801d44:	a1 64 b0 81 00       	mov    0x81b064,%eax
  801d49:	39 c2                	cmp    %eax,%edx
  801d4b:	72 0c                	jb     801d59 <free_block+0x1e>
  801d4d:	8b 55 08             	mov    0x8(%ebp),%edx
  801d50:	a1 40 30 80 00       	mov    0x803040,%eax
  801d55:	39 c2                	cmp    %eax,%edx
  801d57:	72 16                	jb     801d6f <free_block+0x34>
  801d59:	68 44 2a 80 00       	push   $0x802a44
  801d5e:	68 72 29 80 00       	push   $0x802972
  801d63:	6a 5b                	push   $0x5b
  801d65:	68 87 29 80 00       	push   $0x802987
  801d6a:	e8 6a 00 00 00       	call   801dd9 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	panic("free_block() Not implemented yet");
  801d6f:	83 ec 04             	sub    $0x4,%esp
  801d72:	68 7c 2a 80 00       	push   $0x802a7c
  801d77:	6a 63                	push   $0x63
  801d79:	68 87 29 80 00       	push   $0x802987
  801d7e:	e8 56 00 00 00       	call   801dd9 <_panic>

00801d83 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
  801d86:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  801d89:	83 ec 04             	sub    $0x4,%esp
  801d8c:	68 a0 2a 80 00       	push   $0x802aa0
  801d91:	6a 72                	push   $0x72
  801d93:	68 87 29 80 00       	push   $0x802987
  801d98:	e8 3c 00 00 00       	call   801dd9 <_panic>

00801d9d <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801da3:	8b 45 08             	mov    0x8(%ebp),%eax
  801da6:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801da9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801dad:	83 ec 0c             	sub    $0xc,%esp
  801db0:	50                   	push   %eax
  801db1:	e8 ac fa ff ff       	call   801862 <sys_cputc>
  801db6:	83 c4 10             	add    $0x10,%esp
}
  801db9:	90                   	nop
  801dba:	c9                   	leave  
  801dbb:	c3                   	ret    

00801dbc <getchar>:


int
getchar(void)
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
  801dbf:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801dc2:	e8 3a f9 ff ff       	call   801701 <sys_cgetc>
  801dc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <iscons>:

int iscons(int fdnum)
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801dd2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801dd7:	5d                   	pop    %ebp
  801dd8:	c3                   	ret    

00801dd9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
  801ddc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801ddf:	8d 45 10             	lea    0x10(%ebp),%eax
  801de2:	83 c0 04             	add    $0x4,%eax
  801de5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801de8:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801ded:	85 c0                	test   %eax,%eax
  801def:	74 16                	je     801e07 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801df1:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  801df6:	83 ec 08             	sub    $0x8,%esp
  801df9:	50                   	push   %eax
  801dfa:	68 c4 2a 80 00       	push   $0x802ac4
  801dff:	e8 03 e6 ff ff       	call   800407 <cprintf>
  801e04:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801e07:	a1 04 30 80 00       	mov    0x803004,%eax
  801e0c:	83 ec 0c             	sub    $0xc,%esp
  801e0f:	ff 75 0c             	pushl  0xc(%ebp)
  801e12:	ff 75 08             	pushl  0x8(%ebp)
  801e15:	50                   	push   %eax
  801e16:	68 cc 2a 80 00       	push   $0x802acc
  801e1b:	6a 74                	push   $0x74
  801e1d:	e8 12 e6 ff ff       	call   800434 <cprintf_colored>
  801e22:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801e25:	8b 45 10             	mov    0x10(%ebp),%eax
  801e28:	83 ec 08             	sub    $0x8,%esp
  801e2b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e2e:	50                   	push   %eax
  801e2f:	e8 64 e5 ff ff       	call   800398 <vcprintf>
  801e34:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801e37:	83 ec 08             	sub    $0x8,%esp
  801e3a:	6a 00                	push   $0x0
  801e3c:	68 f4 2a 80 00       	push   $0x802af4
  801e41:	e8 52 e5 ff ff       	call   800398 <vcprintf>
  801e46:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801e49:	e8 cb e4 ff ff       	call   800319 <exit>

	// should not return here
	while (1) ;
  801e4e:	eb fe                	jmp    801e4e <_panic+0x75>

00801e50 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801e56:	a1 20 30 80 00       	mov    0x803020,%eax
  801e5b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e64:	39 c2                	cmp    %eax,%edx
  801e66:	74 14                	je     801e7c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801e68:	83 ec 04             	sub    $0x4,%esp
  801e6b:	68 f8 2a 80 00       	push   $0x802af8
  801e70:	6a 26                	push   $0x26
  801e72:	68 44 2b 80 00       	push   $0x802b44
  801e77:	e8 5d ff ff ff       	call   801dd9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801e7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801e83:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801e8a:	e9 c5 00 00 00       	jmp    801f54 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e92:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e99:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9c:	01 d0                	add    %edx,%eax
  801e9e:	8b 00                	mov    (%eax),%eax
  801ea0:	85 c0                	test   %eax,%eax
  801ea2:	75 08                	jne    801eac <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801ea4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801ea7:	e9 a5 00 00 00       	jmp    801f51 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801eac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801eb3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801eba:	eb 69                	jmp    801f25 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801ebc:	a1 20 30 80 00       	mov    0x803020,%eax
  801ec1:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801ec7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801eca:	89 d0                	mov    %edx,%eax
  801ecc:	01 c0                	add    %eax,%eax
  801ece:	01 d0                	add    %edx,%eax
  801ed0:	c1 e0 03             	shl    $0x3,%eax
  801ed3:	01 c8                	add    %ecx,%eax
  801ed5:	8a 40 04             	mov    0x4(%eax),%al
  801ed8:	84 c0                	test   %al,%al
  801eda:	75 46                	jne    801f22 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801edc:	a1 20 30 80 00       	mov    0x803020,%eax
  801ee1:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801ee7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801eea:	89 d0                	mov    %edx,%eax
  801eec:	01 c0                	add    %eax,%eax
  801eee:	01 d0                	add    %edx,%eax
  801ef0:	c1 e0 03             	shl    $0x3,%eax
  801ef3:	01 c8                	add    %ecx,%eax
  801ef5:	8b 00                	mov    (%eax),%eax
  801ef7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801efa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801efd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f02:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f07:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f11:	01 c8                	add    %ecx,%eax
  801f13:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801f15:	39 c2                	cmp    %eax,%edx
  801f17:	75 09                	jne    801f22 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801f19:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801f20:	eb 15                	jmp    801f37 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801f22:	ff 45 e8             	incl   -0x18(%ebp)
  801f25:	a1 20 30 80 00       	mov    0x803020,%eax
  801f2a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801f30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f33:	39 c2                	cmp    %eax,%edx
  801f35:	77 85                	ja     801ebc <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801f37:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f3b:	75 14                	jne    801f51 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801f3d:	83 ec 04             	sub    $0x4,%esp
  801f40:	68 50 2b 80 00       	push   $0x802b50
  801f45:	6a 3a                	push   $0x3a
  801f47:	68 44 2b 80 00       	push   $0x802b44
  801f4c:	e8 88 fe ff ff       	call   801dd9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801f51:	ff 45 f0             	incl   -0x10(%ebp)
  801f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f57:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f5a:	0f 8c 2f ff ff ff    	jl     801e8f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801f60:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801f67:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801f6e:	eb 26                	jmp    801f96 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801f70:	a1 20 30 80 00       	mov    0x803020,%eax
  801f75:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801f7b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f7e:	89 d0                	mov    %edx,%eax
  801f80:	01 c0                	add    %eax,%eax
  801f82:	01 d0                	add    %edx,%eax
  801f84:	c1 e0 03             	shl    $0x3,%eax
  801f87:	01 c8                	add    %ecx,%eax
  801f89:	8a 40 04             	mov    0x4(%eax),%al
  801f8c:	3c 01                	cmp    $0x1,%al
  801f8e:	75 03                	jne    801f93 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801f90:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801f93:	ff 45 e0             	incl   -0x20(%ebp)
  801f96:	a1 20 30 80 00       	mov    0x803020,%eax
  801f9b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801fa1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fa4:	39 c2                	cmp    %eax,%edx
  801fa6:	77 c8                	ja     801f70 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fab:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801fae:	74 14                	je     801fc4 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801fb0:	83 ec 04             	sub    $0x4,%esp
  801fb3:	68 a4 2b 80 00       	push   $0x802ba4
  801fb8:	6a 44                	push   $0x44
  801fba:	68 44 2b 80 00       	push   $0x802b44
  801fbf:	e8 15 fe ff ff       	call   801dd9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801fc4:	90                   	nop
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    
  801fc7:	90                   	nop

00801fc8 <__udivdi3>:
  801fc8:	55                   	push   %ebp
  801fc9:	57                   	push   %edi
  801fca:	56                   	push   %esi
  801fcb:	53                   	push   %ebx
  801fcc:	83 ec 1c             	sub    $0x1c,%esp
  801fcf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801fd3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801fd7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801fdb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fdf:	89 ca                	mov    %ecx,%edx
  801fe1:	89 f8                	mov    %edi,%eax
  801fe3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801fe7:	85 f6                	test   %esi,%esi
  801fe9:	75 2d                	jne    802018 <__udivdi3+0x50>
  801feb:	39 cf                	cmp    %ecx,%edi
  801fed:	77 65                	ja     802054 <__udivdi3+0x8c>
  801fef:	89 fd                	mov    %edi,%ebp
  801ff1:	85 ff                	test   %edi,%edi
  801ff3:	75 0b                	jne    802000 <__udivdi3+0x38>
  801ff5:	b8 01 00 00 00       	mov    $0x1,%eax
  801ffa:	31 d2                	xor    %edx,%edx
  801ffc:	f7 f7                	div    %edi
  801ffe:	89 c5                	mov    %eax,%ebp
  802000:	31 d2                	xor    %edx,%edx
  802002:	89 c8                	mov    %ecx,%eax
  802004:	f7 f5                	div    %ebp
  802006:	89 c1                	mov    %eax,%ecx
  802008:	89 d8                	mov    %ebx,%eax
  80200a:	f7 f5                	div    %ebp
  80200c:	89 cf                	mov    %ecx,%edi
  80200e:	89 fa                	mov    %edi,%edx
  802010:	83 c4 1c             	add    $0x1c,%esp
  802013:	5b                   	pop    %ebx
  802014:	5e                   	pop    %esi
  802015:	5f                   	pop    %edi
  802016:	5d                   	pop    %ebp
  802017:	c3                   	ret    
  802018:	39 ce                	cmp    %ecx,%esi
  80201a:	77 28                	ja     802044 <__udivdi3+0x7c>
  80201c:	0f bd fe             	bsr    %esi,%edi
  80201f:	83 f7 1f             	xor    $0x1f,%edi
  802022:	75 40                	jne    802064 <__udivdi3+0x9c>
  802024:	39 ce                	cmp    %ecx,%esi
  802026:	72 0a                	jb     802032 <__udivdi3+0x6a>
  802028:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80202c:	0f 87 9e 00 00 00    	ja     8020d0 <__udivdi3+0x108>
  802032:	b8 01 00 00 00       	mov    $0x1,%eax
  802037:	89 fa                	mov    %edi,%edx
  802039:	83 c4 1c             	add    $0x1c,%esp
  80203c:	5b                   	pop    %ebx
  80203d:	5e                   	pop    %esi
  80203e:	5f                   	pop    %edi
  80203f:	5d                   	pop    %ebp
  802040:	c3                   	ret    
  802041:	8d 76 00             	lea    0x0(%esi),%esi
  802044:	31 ff                	xor    %edi,%edi
  802046:	31 c0                	xor    %eax,%eax
  802048:	89 fa                	mov    %edi,%edx
  80204a:	83 c4 1c             	add    $0x1c,%esp
  80204d:	5b                   	pop    %ebx
  80204e:	5e                   	pop    %esi
  80204f:	5f                   	pop    %edi
  802050:	5d                   	pop    %ebp
  802051:	c3                   	ret    
  802052:	66 90                	xchg   %ax,%ax
  802054:	89 d8                	mov    %ebx,%eax
  802056:	f7 f7                	div    %edi
  802058:	31 ff                	xor    %edi,%edi
  80205a:	89 fa                	mov    %edi,%edx
  80205c:	83 c4 1c             	add    $0x1c,%esp
  80205f:	5b                   	pop    %ebx
  802060:	5e                   	pop    %esi
  802061:	5f                   	pop    %edi
  802062:	5d                   	pop    %ebp
  802063:	c3                   	ret    
  802064:	bd 20 00 00 00       	mov    $0x20,%ebp
  802069:	89 eb                	mov    %ebp,%ebx
  80206b:	29 fb                	sub    %edi,%ebx
  80206d:	89 f9                	mov    %edi,%ecx
  80206f:	d3 e6                	shl    %cl,%esi
  802071:	89 c5                	mov    %eax,%ebp
  802073:	88 d9                	mov    %bl,%cl
  802075:	d3 ed                	shr    %cl,%ebp
  802077:	89 e9                	mov    %ebp,%ecx
  802079:	09 f1                	or     %esi,%ecx
  80207b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80207f:	89 f9                	mov    %edi,%ecx
  802081:	d3 e0                	shl    %cl,%eax
  802083:	89 c5                	mov    %eax,%ebp
  802085:	89 d6                	mov    %edx,%esi
  802087:	88 d9                	mov    %bl,%cl
  802089:	d3 ee                	shr    %cl,%esi
  80208b:	89 f9                	mov    %edi,%ecx
  80208d:	d3 e2                	shl    %cl,%edx
  80208f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802093:	88 d9                	mov    %bl,%cl
  802095:	d3 e8                	shr    %cl,%eax
  802097:	09 c2                	or     %eax,%edx
  802099:	89 d0                	mov    %edx,%eax
  80209b:	89 f2                	mov    %esi,%edx
  80209d:	f7 74 24 0c          	divl   0xc(%esp)
  8020a1:	89 d6                	mov    %edx,%esi
  8020a3:	89 c3                	mov    %eax,%ebx
  8020a5:	f7 e5                	mul    %ebp
  8020a7:	39 d6                	cmp    %edx,%esi
  8020a9:	72 19                	jb     8020c4 <__udivdi3+0xfc>
  8020ab:	74 0b                	je     8020b8 <__udivdi3+0xf0>
  8020ad:	89 d8                	mov    %ebx,%eax
  8020af:	31 ff                	xor    %edi,%edi
  8020b1:	e9 58 ff ff ff       	jmp    80200e <__udivdi3+0x46>
  8020b6:	66 90                	xchg   %ax,%ax
  8020b8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8020bc:	89 f9                	mov    %edi,%ecx
  8020be:	d3 e2                	shl    %cl,%edx
  8020c0:	39 c2                	cmp    %eax,%edx
  8020c2:	73 e9                	jae    8020ad <__udivdi3+0xe5>
  8020c4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8020c7:	31 ff                	xor    %edi,%edi
  8020c9:	e9 40 ff ff ff       	jmp    80200e <__udivdi3+0x46>
  8020ce:	66 90                	xchg   %ax,%ax
  8020d0:	31 c0                	xor    %eax,%eax
  8020d2:	e9 37 ff ff ff       	jmp    80200e <__udivdi3+0x46>
  8020d7:	90                   	nop

008020d8 <__umoddi3>:
  8020d8:	55                   	push   %ebp
  8020d9:	57                   	push   %edi
  8020da:	56                   	push   %esi
  8020db:	53                   	push   %ebx
  8020dc:	83 ec 1c             	sub    $0x1c,%esp
  8020df:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8020e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8020ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020f7:	89 f3                	mov    %esi,%ebx
  8020f9:	89 fa                	mov    %edi,%edx
  8020fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020ff:	89 34 24             	mov    %esi,(%esp)
  802102:	85 c0                	test   %eax,%eax
  802104:	75 1a                	jne    802120 <__umoddi3+0x48>
  802106:	39 f7                	cmp    %esi,%edi
  802108:	0f 86 a2 00 00 00    	jbe    8021b0 <__umoddi3+0xd8>
  80210e:	89 c8                	mov    %ecx,%eax
  802110:	89 f2                	mov    %esi,%edx
  802112:	f7 f7                	div    %edi
  802114:	89 d0                	mov    %edx,%eax
  802116:	31 d2                	xor    %edx,%edx
  802118:	83 c4 1c             	add    $0x1c,%esp
  80211b:	5b                   	pop    %ebx
  80211c:	5e                   	pop    %esi
  80211d:	5f                   	pop    %edi
  80211e:	5d                   	pop    %ebp
  80211f:	c3                   	ret    
  802120:	39 f0                	cmp    %esi,%eax
  802122:	0f 87 ac 00 00 00    	ja     8021d4 <__umoddi3+0xfc>
  802128:	0f bd e8             	bsr    %eax,%ebp
  80212b:	83 f5 1f             	xor    $0x1f,%ebp
  80212e:	0f 84 ac 00 00 00    	je     8021e0 <__umoddi3+0x108>
  802134:	bf 20 00 00 00       	mov    $0x20,%edi
  802139:	29 ef                	sub    %ebp,%edi
  80213b:	89 fe                	mov    %edi,%esi
  80213d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802141:	89 e9                	mov    %ebp,%ecx
  802143:	d3 e0                	shl    %cl,%eax
  802145:	89 d7                	mov    %edx,%edi
  802147:	89 f1                	mov    %esi,%ecx
  802149:	d3 ef                	shr    %cl,%edi
  80214b:	09 c7                	or     %eax,%edi
  80214d:	89 e9                	mov    %ebp,%ecx
  80214f:	d3 e2                	shl    %cl,%edx
  802151:	89 14 24             	mov    %edx,(%esp)
  802154:	89 d8                	mov    %ebx,%eax
  802156:	d3 e0                	shl    %cl,%eax
  802158:	89 c2                	mov    %eax,%edx
  80215a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80215e:	d3 e0                	shl    %cl,%eax
  802160:	89 44 24 04          	mov    %eax,0x4(%esp)
  802164:	8b 44 24 08          	mov    0x8(%esp),%eax
  802168:	89 f1                	mov    %esi,%ecx
  80216a:	d3 e8                	shr    %cl,%eax
  80216c:	09 d0                	or     %edx,%eax
  80216e:	d3 eb                	shr    %cl,%ebx
  802170:	89 da                	mov    %ebx,%edx
  802172:	f7 f7                	div    %edi
  802174:	89 d3                	mov    %edx,%ebx
  802176:	f7 24 24             	mull   (%esp)
  802179:	89 c6                	mov    %eax,%esi
  80217b:	89 d1                	mov    %edx,%ecx
  80217d:	39 d3                	cmp    %edx,%ebx
  80217f:	0f 82 87 00 00 00    	jb     80220c <__umoddi3+0x134>
  802185:	0f 84 91 00 00 00    	je     80221c <__umoddi3+0x144>
  80218b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80218f:	29 f2                	sub    %esi,%edx
  802191:	19 cb                	sbb    %ecx,%ebx
  802193:	89 d8                	mov    %ebx,%eax
  802195:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802199:	d3 e0                	shl    %cl,%eax
  80219b:	89 e9                	mov    %ebp,%ecx
  80219d:	d3 ea                	shr    %cl,%edx
  80219f:	09 d0                	or     %edx,%eax
  8021a1:	89 e9                	mov    %ebp,%ecx
  8021a3:	d3 eb                	shr    %cl,%ebx
  8021a5:	89 da                	mov    %ebx,%edx
  8021a7:	83 c4 1c             	add    $0x1c,%esp
  8021aa:	5b                   	pop    %ebx
  8021ab:	5e                   	pop    %esi
  8021ac:	5f                   	pop    %edi
  8021ad:	5d                   	pop    %ebp
  8021ae:	c3                   	ret    
  8021af:	90                   	nop
  8021b0:	89 fd                	mov    %edi,%ebp
  8021b2:	85 ff                	test   %edi,%edi
  8021b4:	75 0b                	jne    8021c1 <__umoddi3+0xe9>
  8021b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8021bb:	31 d2                	xor    %edx,%edx
  8021bd:	f7 f7                	div    %edi
  8021bf:	89 c5                	mov    %eax,%ebp
  8021c1:	89 f0                	mov    %esi,%eax
  8021c3:	31 d2                	xor    %edx,%edx
  8021c5:	f7 f5                	div    %ebp
  8021c7:	89 c8                	mov    %ecx,%eax
  8021c9:	f7 f5                	div    %ebp
  8021cb:	89 d0                	mov    %edx,%eax
  8021cd:	e9 44 ff ff ff       	jmp    802116 <__umoddi3+0x3e>
  8021d2:	66 90                	xchg   %ax,%ax
  8021d4:	89 c8                	mov    %ecx,%eax
  8021d6:	89 f2                	mov    %esi,%edx
  8021d8:	83 c4 1c             	add    $0x1c,%esp
  8021db:	5b                   	pop    %ebx
  8021dc:	5e                   	pop    %esi
  8021dd:	5f                   	pop    %edi
  8021de:	5d                   	pop    %ebp
  8021df:	c3                   	ret    
  8021e0:	3b 04 24             	cmp    (%esp),%eax
  8021e3:	72 06                	jb     8021eb <__umoddi3+0x113>
  8021e5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8021e9:	77 0f                	ja     8021fa <__umoddi3+0x122>
  8021eb:	89 f2                	mov    %esi,%edx
  8021ed:	29 f9                	sub    %edi,%ecx
  8021ef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8021f3:	89 14 24             	mov    %edx,(%esp)
  8021f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021fa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8021fe:	8b 14 24             	mov    (%esp),%edx
  802201:	83 c4 1c             	add    $0x1c,%esp
  802204:	5b                   	pop    %ebx
  802205:	5e                   	pop    %esi
  802206:	5f                   	pop    %edi
  802207:	5d                   	pop    %ebp
  802208:	c3                   	ret    
  802209:	8d 76 00             	lea    0x0(%esi),%esi
  80220c:	2b 04 24             	sub    (%esp),%eax
  80220f:	19 fa                	sbb    %edi,%edx
  802211:	89 d1                	mov    %edx,%ecx
  802213:	89 c6                	mov    %eax,%esi
  802215:	e9 71 ff ff ff       	jmp    80218b <__umoddi3+0xb3>
  80221a:	66 90                	xchg   %ax,%ax
  80221c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802220:	72 ea                	jb     80220c <__umoddi3+0x134>
  802222:	89 d9                	mov    %ebx,%ecx
  802224:	e9 62 ff ff ff       	jmp    80218b <__umoddi3+0xb3>

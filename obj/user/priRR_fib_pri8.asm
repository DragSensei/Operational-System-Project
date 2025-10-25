
obj/user/priRR_fib_pri8:     file format elf32-i386


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
  800031:	e8 c0 00 00 00       	call   8000f6 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
int fibonacci(int n);
extern void sys_env_set_priority(int , int );

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	sys_env_set_priority(myEnv->env_id, 8);
  800041:	a1 20 30 80 00       	mov    0x803020,%eax
  800046:	8b 40 10             	mov    0x10(%eax),%eax
  800049:	83 ec 08             	sub    $0x8,%esp
  80004c:	6a 08                	push   $0x8
  80004e:	50                   	push   %eax
  80004f:	e8 92 19 00 00       	call   8019e6 <sys_env_set_priority>
  800054:	83 c4 10             	add    $0x10,%esp

	int i1=0;
  800057:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	i1 = 38;
  80005e:	c7 45 f4 26 00 00 00 	movl   $0x26,-0xc(%ebp)

	int res = fibonacci(i1) ;
  800065:	83 ec 0c             	sub    $0xc,%esp
  800068:	ff 75 f4             	pushl  -0xc(%ebp)
  80006b:	e8 47 00 00 00       	call   8000b7 <fibonacci>
  800070:	83 c4 10             	add    $0x10,%esp
  800073:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("Fibonacci #%d = %d\n",i1, res);
  800076:	83 ec 04             	sub    $0x4,%esp
  800079:	ff 75 f0             	pushl  -0x10(%ebp)
  80007c:	ff 75 f4             	pushl  -0xc(%ebp)
  80007f:	68 80 1c 80 00       	push   $0x801c80
  800084:	e8 5d 05 00 00       	call   8005e6 <atomic_cprintf>
  800089:	83 c4 10             	add    $0x10,%esp

	if (res != 63245986)
  80008c:	81 7d f0 a2 0e c5 03 	cmpl   $0x3c50ea2,-0x10(%ebp)
  800093:	74 1a                	je     8000af <_main+0x77>
		panic("[envID %d] wrong result!", myEnv->env_id);
  800095:	a1 20 30 80 00       	mov    0x803020,%eax
  80009a:	8b 40 10             	mov    0x10(%eax),%eax
  80009d:	50                   	push   %eax
  80009e:	68 94 1c 80 00       	push   $0x801c94
  8000a3:	6a 16                	push   $0x16
  8000a5:	68 ad 1c 80 00       	push   $0x801cad
  8000aa:	e8 f7 01 00 00       	call   8002a6 <_panic>

	//To indicate that it's completed successfully
	inctst();
  8000af:	e8 cb 17 00 00       	call   80187f <inctst>

	return;
  8000b4:	90                   	nop
}
  8000b5:	c9                   	leave  
  8000b6:	c3                   	ret    

008000b7 <fibonacci>:


int fibonacci(int n)
{
  8000b7:	55                   	push   %ebp
  8000b8:	89 e5                	mov    %esp,%ebp
  8000ba:	53                   	push   %ebx
  8000bb:	83 ec 04             	sub    $0x4,%esp
	if (n <= 1)
  8000be:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000c2:	7f 07                	jg     8000cb <fibonacci+0x14>
		return 1 ;
  8000c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c9:	eb 26                	jmp    8000f1 <fibonacci+0x3a>
	return fibonacci(n-1) + fibonacci(n-2) ;
  8000cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8000ce:	48                   	dec    %eax
  8000cf:	83 ec 0c             	sub    $0xc,%esp
  8000d2:	50                   	push   %eax
  8000d3:	e8 df ff ff ff       	call   8000b7 <fibonacci>
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	89 c3                	mov    %eax,%ebx
  8000dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8000e0:	83 e8 02             	sub    $0x2,%eax
  8000e3:	83 ec 0c             	sub    $0xc,%esp
  8000e6:	50                   	push   %eax
  8000e7:	e8 cb ff ff ff       	call   8000b7 <fibonacci>
  8000ec:	83 c4 10             	add    $0x10,%esp
  8000ef:	01 d8                	add    %ebx,%eax
}
  8000f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000f4:	c9                   	leave  
  8000f5:	c3                   	ret    

008000f6 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000f6:	55                   	push   %ebp
  8000f7:	89 e5                	mov    %esp,%ebp
  8000f9:	57                   	push   %edi
  8000fa:	56                   	push   %esi
  8000fb:	53                   	push   %ebx
  8000fc:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000ff:	e8 3d 16 00 00       	call   801741 <sys_getenvindex>
  800104:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800107:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80010a:	89 d0                	mov    %edx,%eax
  80010c:	c1 e0 02             	shl    $0x2,%eax
  80010f:	01 d0                	add    %edx,%eax
  800111:	c1 e0 03             	shl    $0x3,%eax
  800114:	01 d0                	add    %edx,%eax
  800116:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80011d:	01 d0                	add    %edx,%eax
  80011f:	c1 e0 02             	shl    $0x2,%eax
  800122:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800127:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80012c:	a1 20 30 80 00       	mov    0x803020,%eax
  800131:	8a 40 20             	mov    0x20(%eax),%al
  800134:	84 c0                	test   %al,%al
  800136:	74 0d                	je     800145 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800138:	a1 20 30 80 00       	mov    0x803020,%eax
  80013d:	83 c0 20             	add    $0x20,%eax
  800140:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800145:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800149:	7e 0a                	jle    800155 <libmain+0x5f>
		binaryname = argv[0];
  80014b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80014e:	8b 00                	mov    (%eax),%eax
  800150:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800155:	83 ec 08             	sub    $0x8,%esp
  800158:	ff 75 0c             	pushl  0xc(%ebp)
  80015b:	ff 75 08             	pushl  0x8(%ebp)
  80015e:	e8 d5 fe ff ff       	call   800038 <_main>
  800163:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800166:	a1 00 30 80 00       	mov    0x803000,%eax
  80016b:	85 c0                	test   %eax,%eax
  80016d:	0f 84 01 01 00 00    	je     800274 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800173:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800179:	bb bc 1d 80 00       	mov    $0x801dbc,%ebx
  80017e:	ba 0e 00 00 00       	mov    $0xe,%edx
  800183:	89 c7                	mov    %eax,%edi
  800185:	89 de                	mov    %ebx,%esi
  800187:	89 d1                	mov    %edx,%ecx
  800189:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80018b:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80018e:	b9 56 00 00 00       	mov    $0x56,%ecx
  800193:	b0 00                	mov    $0x0,%al
  800195:	89 d7                	mov    %edx,%edi
  800197:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800199:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8001a0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8001a3:	83 ec 08             	sub    $0x8,%esp
  8001a6:	50                   	push   %eax
  8001a7:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001ad:	50                   	push   %eax
  8001ae:	e8 c4 17 00 00       	call   801977 <sys_utilities>
  8001b3:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001b6:	e8 0d 13 00 00       	call   8014c8 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001bb:	83 ec 0c             	sub    $0xc,%esp
  8001be:	68 dc 1c 80 00       	push   $0x801cdc
  8001c3:	e8 ac 03 00 00       	call   800574 <cprintf>
  8001c8:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ce:	85 c0                	test   %eax,%eax
  8001d0:	74 18                	je     8001ea <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001d2:	e8 be 17 00 00       	call   801995 <sys_get_optimal_num_faults>
  8001d7:	83 ec 08             	sub    $0x8,%esp
  8001da:	50                   	push   %eax
  8001db:	68 04 1d 80 00       	push   $0x801d04
  8001e0:	e8 8f 03 00 00       	call   800574 <cprintf>
  8001e5:	83 c4 10             	add    $0x10,%esp
  8001e8:	eb 59                	jmp    800243 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ef:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8001f5:	a1 20 30 80 00       	mov    0x803020,%eax
  8001fa:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800200:	83 ec 04             	sub    $0x4,%esp
  800203:	52                   	push   %edx
  800204:	50                   	push   %eax
  800205:	68 28 1d 80 00       	push   $0x801d28
  80020a:	e8 65 03 00 00       	call   800574 <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800212:	a1 20 30 80 00       	mov    0x803020,%eax
  800217:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80021d:	a1 20 30 80 00       	mov    0x803020,%eax
  800222:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800228:	a1 20 30 80 00       	mov    0x803020,%eax
  80022d:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800233:	51                   	push   %ecx
  800234:	52                   	push   %edx
  800235:	50                   	push   %eax
  800236:	68 50 1d 80 00       	push   $0x801d50
  80023b:	e8 34 03 00 00       	call   800574 <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800243:	a1 20 30 80 00       	mov    0x803020,%eax
  800248:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80024e:	83 ec 08             	sub    $0x8,%esp
  800251:	50                   	push   %eax
  800252:	68 a8 1d 80 00       	push   $0x801da8
  800257:	e8 18 03 00 00       	call   800574 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80025f:	83 ec 0c             	sub    $0xc,%esp
  800262:	68 dc 1c 80 00       	push   $0x801cdc
  800267:	e8 08 03 00 00       	call   800574 <cprintf>
  80026c:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80026f:	e8 6e 12 00 00       	call   8014e2 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800274:	e8 1f 00 00 00       	call   800298 <exit>
}
  800279:	90                   	nop
  80027a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80027d:	5b                   	pop    %ebx
  80027e:	5e                   	pop    %esi
  80027f:	5f                   	pop    %edi
  800280:	5d                   	pop    %ebp
  800281:	c3                   	ret    

00800282 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800288:	83 ec 0c             	sub    $0xc,%esp
  80028b:	6a 00                	push   $0x0
  80028d:	e8 7b 14 00 00       	call   80170d <sys_destroy_env>
  800292:	83 c4 10             	add    $0x10,%esp
}
  800295:	90                   	nop
  800296:	c9                   	leave  
  800297:	c3                   	ret    

00800298 <exit>:

void
exit(void)
{
  800298:	55                   	push   %ebp
  800299:	89 e5                	mov    %esp,%ebp
  80029b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80029e:	e8 d0 14 00 00       	call   801773 <sys_exit_env>
}
  8002a3:	90                   	nop
  8002a4:	c9                   	leave  
  8002a5:	c3                   	ret    

008002a6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002a6:	55                   	push   %ebp
  8002a7:	89 e5                	mov    %esp,%ebp
  8002a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002ac:	8d 45 10             	lea    0x10(%ebp),%eax
  8002af:	83 c0 04             	add    $0x4,%eax
  8002b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002b5:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002ba:	85 c0                	test   %eax,%eax
  8002bc:	74 16                	je     8002d4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002be:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	50                   	push   %eax
  8002c7:	68 20 1e 80 00       	push   $0x801e20
  8002cc:	e8 a3 02 00 00       	call   800574 <cprintf>
  8002d1:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8002d4:	a1 04 30 80 00       	mov    0x803004,%eax
  8002d9:	83 ec 0c             	sub    $0xc,%esp
  8002dc:	ff 75 0c             	pushl  0xc(%ebp)
  8002df:	ff 75 08             	pushl  0x8(%ebp)
  8002e2:	50                   	push   %eax
  8002e3:	68 28 1e 80 00       	push   $0x801e28
  8002e8:	6a 74                	push   $0x74
  8002ea:	e8 b2 02 00 00       	call   8005a1 <cprintf_colored>
  8002ef:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8002f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f5:	83 ec 08             	sub    $0x8,%esp
  8002f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8002fb:	50                   	push   %eax
  8002fc:	e8 04 02 00 00       	call   800505 <vcprintf>
  800301:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800304:	83 ec 08             	sub    $0x8,%esp
  800307:	6a 00                	push   $0x0
  800309:	68 50 1e 80 00       	push   $0x801e50
  80030e:	e8 f2 01 00 00       	call   800505 <vcprintf>
  800313:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800316:	e8 7d ff ff ff       	call   800298 <exit>

	// should not return here
	while (1) ;
  80031b:	eb fe                	jmp    80031b <_panic+0x75>

0080031d <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80031d:	55                   	push   %ebp
  80031e:	89 e5                	mov    %esp,%ebp
  800320:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800323:	a1 20 30 80 00       	mov    0x803020,%eax
  800328:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80032e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800331:	39 c2                	cmp    %eax,%edx
  800333:	74 14                	je     800349 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800335:	83 ec 04             	sub    $0x4,%esp
  800338:	68 54 1e 80 00       	push   $0x801e54
  80033d:	6a 26                	push   $0x26
  80033f:	68 a0 1e 80 00       	push   $0x801ea0
  800344:	e8 5d ff ff ff       	call   8002a6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800349:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800350:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800357:	e9 c5 00 00 00       	jmp    800421 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80035c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80035f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800366:	8b 45 08             	mov    0x8(%ebp),%eax
  800369:	01 d0                	add    %edx,%eax
  80036b:	8b 00                	mov    (%eax),%eax
  80036d:	85 c0                	test   %eax,%eax
  80036f:	75 08                	jne    800379 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800371:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800374:	e9 a5 00 00 00       	jmp    80041e <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800379:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800380:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800387:	eb 69                	jmp    8003f2 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800389:	a1 20 30 80 00       	mov    0x803020,%eax
  80038e:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800394:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800397:	89 d0                	mov    %edx,%eax
  800399:	01 c0                	add    %eax,%eax
  80039b:	01 d0                	add    %edx,%eax
  80039d:	c1 e0 03             	shl    $0x3,%eax
  8003a0:	01 c8                	add    %ecx,%eax
  8003a2:	8a 40 04             	mov    0x4(%eax),%al
  8003a5:	84 c0                	test   %al,%al
  8003a7:	75 46                	jne    8003ef <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003a9:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ae:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003b7:	89 d0                	mov    %edx,%eax
  8003b9:	01 c0                	add    %eax,%eax
  8003bb:	01 d0                	add    %edx,%eax
  8003bd:	c1 e0 03             	shl    $0x3,%eax
  8003c0:	01 c8                	add    %ecx,%eax
  8003c2:	8b 00                	mov    (%eax),%eax
  8003c4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003cf:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003db:	8b 45 08             	mov    0x8(%ebp),%eax
  8003de:	01 c8                	add    %ecx,%eax
  8003e0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003e2:	39 c2                	cmp    %eax,%edx
  8003e4:	75 09                	jne    8003ef <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003e6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003ed:	eb 15                	jmp    800404 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ef:	ff 45 e8             	incl   -0x18(%ebp)
  8003f2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800400:	39 c2                	cmp    %eax,%edx
  800402:	77 85                	ja     800389 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800404:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800408:	75 14                	jne    80041e <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 ac 1e 80 00       	push   $0x801eac
  800412:	6a 3a                	push   $0x3a
  800414:	68 a0 1e 80 00       	push   $0x801ea0
  800419:	e8 88 fe ff ff       	call   8002a6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80041e:	ff 45 f0             	incl   -0x10(%ebp)
  800421:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800424:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800427:	0f 8c 2f ff ff ff    	jl     80035c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80042d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800434:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80043b:	eb 26                	jmp    800463 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80043d:	a1 20 30 80 00       	mov    0x803020,%eax
  800442:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800448:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80044b:	89 d0                	mov    %edx,%eax
  80044d:	01 c0                	add    %eax,%eax
  80044f:	01 d0                	add    %edx,%eax
  800451:	c1 e0 03             	shl    $0x3,%eax
  800454:	01 c8                	add    %ecx,%eax
  800456:	8a 40 04             	mov    0x4(%eax),%al
  800459:	3c 01                	cmp    $0x1,%al
  80045b:	75 03                	jne    800460 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80045d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800460:	ff 45 e0             	incl   -0x20(%ebp)
  800463:	a1 20 30 80 00       	mov    0x803020,%eax
  800468:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80046e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800471:	39 c2                	cmp    %eax,%edx
  800473:	77 c8                	ja     80043d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800478:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80047b:	74 14                	je     800491 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80047d:	83 ec 04             	sub    $0x4,%esp
  800480:	68 00 1f 80 00       	push   $0x801f00
  800485:	6a 44                	push   $0x44
  800487:	68 a0 1e 80 00       	push   $0x801ea0
  80048c:	e8 15 fe ff ff       	call   8002a6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800491:	90                   	nop
  800492:	c9                   	leave  
  800493:	c3                   	ret    

00800494 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800494:	55                   	push   %ebp
  800495:	89 e5                	mov    %esp,%ebp
  800497:	53                   	push   %ebx
  800498:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80049b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049e:	8b 00                	mov    (%eax),%eax
  8004a0:	8d 48 01             	lea    0x1(%eax),%ecx
  8004a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a6:	89 0a                	mov    %ecx,(%edx)
  8004a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8004ab:	88 d1                	mov    %dl,%cl
  8004ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004be:	75 30                	jne    8004f0 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004c0:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004c6:	a0 44 30 80 00       	mov    0x803044,%al
  8004cb:	0f b6 c0             	movzbl %al,%eax
  8004ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004d1:	8b 09                	mov    (%ecx),%ecx
  8004d3:	89 cb                	mov    %ecx,%ebx
  8004d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004d8:	83 c1 08             	add    $0x8,%ecx
  8004db:	52                   	push   %edx
  8004dc:	50                   	push   %eax
  8004dd:	53                   	push   %ebx
  8004de:	51                   	push   %ecx
  8004df:	e8 a0 0f 00 00       	call   801484 <sys_cputs>
  8004e4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f3:	8b 40 04             	mov    0x4(%eax),%eax
  8004f6:	8d 50 01             	lea    0x1(%eax),%edx
  8004f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004ff:	90                   	nop
  800500:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800503:	c9                   	leave  
  800504:	c3                   	ret    

00800505 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800505:	55                   	push   %ebp
  800506:	89 e5                	mov    %esp,%ebp
  800508:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80050e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800515:	00 00 00 
	b.cnt = 0;
  800518:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80051f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800522:	ff 75 0c             	pushl  0xc(%ebp)
  800525:	ff 75 08             	pushl  0x8(%ebp)
  800528:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80052e:	50                   	push   %eax
  80052f:	68 94 04 80 00       	push   $0x800494
  800534:	e8 5a 02 00 00       	call   800793 <vprintfmt>
  800539:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80053c:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800542:	a0 44 30 80 00       	mov    0x803044,%al
  800547:	0f b6 c0             	movzbl %al,%eax
  80054a:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800550:	52                   	push   %edx
  800551:	50                   	push   %eax
  800552:	51                   	push   %ecx
  800553:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800559:	83 c0 08             	add    $0x8,%eax
  80055c:	50                   	push   %eax
  80055d:	e8 22 0f 00 00       	call   801484 <sys_cputs>
  800562:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800565:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  80056c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800572:	c9                   	leave  
  800573:	c3                   	ret    

00800574 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800574:	55                   	push   %ebp
  800575:	89 e5                	mov    %esp,%ebp
  800577:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80057a:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800581:	8d 45 0c             	lea    0xc(%ebp),%eax
  800584:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800587:	8b 45 08             	mov    0x8(%ebp),%eax
  80058a:	83 ec 08             	sub    $0x8,%esp
  80058d:	ff 75 f4             	pushl  -0xc(%ebp)
  800590:	50                   	push   %eax
  800591:	e8 6f ff ff ff       	call   800505 <vcprintf>
  800596:	83 c4 10             	add    $0x10,%esp
  800599:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80059c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80059f:	c9                   	leave  
  8005a0:	c3                   	ret    

008005a1 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8005a1:	55                   	push   %ebp
  8005a2:	89 e5                	mov    %esp,%ebp
  8005a4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005a7:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8005ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b1:	c1 e0 08             	shl    $0x8,%eax
  8005b4:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8005b9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005bc:	83 c0 04             	add    $0x4,%eax
  8005bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c5:	83 ec 08             	sub    $0x8,%esp
  8005c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cb:	50                   	push   %eax
  8005cc:	e8 34 ff ff ff       	call   800505 <vcprintf>
  8005d1:	83 c4 10             	add    $0x10,%esp
  8005d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8005d7:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8005de:	07 00 00 

	return cnt;
  8005e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005e4:	c9                   	leave  
  8005e5:	c3                   	ret    

008005e6 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8005e6:	55                   	push   %ebp
  8005e7:	89 e5                	mov    %esp,%ebp
  8005e9:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8005ec:	e8 d7 0e 00 00       	call   8014c8 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005f1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fa:	83 ec 08             	sub    $0x8,%esp
  8005fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800600:	50                   	push   %eax
  800601:	e8 ff fe ff ff       	call   800505 <vcprintf>
  800606:	83 c4 10             	add    $0x10,%esp
  800609:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80060c:	e8 d1 0e 00 00       	call   8014e2 <sys_unlock_cons>
	return cnt;
  800611:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800614:	c9                   	leave  
  800615:	c3                   	ret    

00800616 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800616:	55                   	push   %ebp
  800617:	89 e5                	mov    %esp,%ebp
  800619:	53                   	push   %ebx
  80061a:	83 ec 14             	sub    $0x14,%esp
  80061d:	8b 45 10             	mov    0x10(%ebp),%eax
  800620:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800623:	8b 45 14             	mov    0x14(%ebp),%eax
  800626:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800629:	8b 45 18             	mov    0x18(%ebp),%eax
  80062c:	ba 00 00 00 00       	mov    $0x0,%edx
  800631:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800634:	77 55                	ja     80068b <printnum+0x75>
  800636:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800639:	72 05                	jb     800640 <printnum+0x2a>
  80063b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80063e:	77 4b                	ja     80068b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800640:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800643:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800646:	8b 45 18             	mov    0x18(%ebp),%eax
  800649:	ba 00 00 00 00       	mov    $0x0,%edx
  80064e:	52                   	push   %edx
  80064f:	50                   	push   %eax
  800650:	ff 75 f4             	pushl  -0xc(%ebp)
  800653:	ff 75 f0             	pushl  -0x10(%ebp)
  800656:	e8 a9 13 00 00       	call   801a04 <__udivdi3>
  80065b:	83 c4 10             	add    $0x10,%esp
  80065e:	83 ec 04             	sub    $0x4,%esp
  800661:	ff 75 20             	pushl  0x20(%ebp)
  800664:	53                   	push   %ebx
  800665:	ff 75 18             	pushl  0x18(%ebp)
  800668:	52                   	push   %edx
  800669:	50                   	push   %eax
  80066a:	ff 75 0c             	pushl  0xc(%ebp)
  80066d:	ff 75 08             	pushl  0x8(%ebp)
  800670:	e8 a1 ff ff ff       	call   800616 <printnum>
  800675:	83 c4 20             	add    $0x20,%esp
  800678:	eb 1a                	jmp    800694 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80067a:	83 ec 08             	sub    $0x8,%esp
  80067d:	ff 75 0c             	pushl  0xc(%ebp)
  800680:	ff 75 20             	pushl  0x20(%ebp)
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	ff d0                	call   *%eax
  800688:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80068b:	ff 4d 1c             	decl   0x1c(%ebp)
  80068e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800692:	7f e6                	jg     80067a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800694:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800697:	bb 00 00 00 00       	mov    $0x0,%ebx
  80069c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80069f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006a2:	53                   	push   %ebx
  8006a3:	51                   	push   %ecx
  8006a4:	52                   	push   %edx
  8006a5:	50                   	push   %eax
  8006a6:	e8 69 14 00 00       	call   801b14 <__umoddi3>
  8006ab:	83 c4 10             	add    $0x10,%esp
  8006ae:	05 74 21 80 00       	add    $0x802174,%eax
  8006b3:	8a 00                	mov    (%eax),%al
  8006b5:	0f be c0             	movsbl %al,%eax
  8006b8:	83 ec 08             	sub    $0x8,%esp
  8006bb:	ff 75 0c             	pushl  0xc(%ebp)
  8006be:	50                   	push   %eax
  8006bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c2:	ff d0                	call   *%eax
  8006c4:	83 c4 10             	add    $0x10,%esp
}
  8006c7:	90                   	nop
  8006c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006cb:	c9                   	leave  
  8006cc:	c3                   	ret    

008006cd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006cd:	55                   	push   %ebp
  8006ce:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006d0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006d4:	7e 1c                	jle    8006f2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	8d 50 08             	lea    0x8(%eax),%edx
  8006de:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e1:	89 10                	mov    %edx,(%eax)
  8006e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e6:	8b 00                	mov    (%eax),%eax
  8006e8:	83 e8 08             	sub    $0x8,%eax
  8006eb:	8b 50 04             	mov    0x4(%eax),%edx
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	eb 40                	jmp    800732 <getuint+0x65>
	else if (lflag)
  8006f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006f6:	74 1e                	je     800716 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	8d 50 04             	lea    0x4(%eax),%edx
  800700:	8b 45 08             	mov    0x8(%ebp),%eax
  800703:	89 10                	mov    %edx,(%eax)
  800705:	8b 45 08             	mov    0x8(%ebp),%eax
  800708:	8b 00                	mov    (%eax),%eax
  80070a:	83 e8 04             	sub    $0x4,%eax
  80070d:	8b 00                	mov    (%eax),%eax
  80070f:	ba 00 00 00 00       	mov    $0x0,%edx
  800714:	eb 1c                	jmp    800732 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800716:	8b 45 08             	mov    0x8(%ebp),%eax
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	8d 50 04             	lea    0x4(%eax),%edx
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	89 10                	mov    %edx,(%eax)
  800723:	8b 45 08             	mov    0x8(%ebp),%eax
  800726:	8b 00                	mov    (%eax),%eax
  800728:	83 e8 04             	sub    $0x4,%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800732:	5d                   	pop    %ebp
  800733:	c3                   	ret    

00800734 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800734:	55                   	push   %ebp
  800735:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800737:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80073b:	7e 1c                	jle    800759 <getint+0x25>
		return va_arg(*ap, long long);
  80073d:	8b 45 08             	mov    0x8(%ebp),%eax
  800740:	8b 00                	mov    (%eax),%eax
  800742:	8d 50 08             	lea    0x8(%eax),%edx
  800745:	8b 45 08             	mov    0x8(%ebp),%eax
  800748:	89 10                	mov    %edx,(%eax)
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	8b 00                	mov    (%eax),%eax
  80074f:	83 e8 08             	sub    $0x8,%eax
  800752:	8b 50 04             	mov    0x4(%eax),%edx
  800755:	8b 00                	mov    (%eax),%eax
  800757:	eb 38                	jmp    800791 <getint+0x5d>
	else if (lflag)
  800759:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80075d:	74 1a                	je     800779 <getint+0x45>
		return va_arg(*ap, long);
  80075f:	8b 45 08             	mov    0x8(%ebp),%eax
  800762:	8b 00                	mov    (%eax),%eax
  800764:	8d 50 04             	lea    0x4(%eax),%edx
  800767:	8b 45 08             	mov    0x8(%ebp),%eax
  80076a:	89 10                	mov    %edx,(%eax)
  80076c:	8b 45 08             	mov    0x8(%ebp),%eax
  80076f:	8b 00                	mov    (%eax),%eax
  800771:	83 e8 04             	sub    $0x4,%eax
  800774:	8b 00                	mov    (%eax),%eax
  800776:	99                   	cltd   
  800777:	eb 18                	jmp    800791 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800779:	8b 45 08             	mov    0x8(%ebp),%eax
  80077c:	8b 00                	mov    (%eax),%eax
  80077e:	8d 50 04             	lea    0x4(%eax),%edx
  800781:	8b 45 08             	mov    0x8(%ebp),%eax
  800784:	89 10                	mov    %edx,(%eax)
  800786:	8b 45 08             	mov    0x8(%ebp),%eax
  800789:	8b 00                	mov    (%eax),%eax
  80078b:	83 e8 04             	sub    $0x4,%eax
  80078e:	8b 00                	mov    (%eax),%eax
  800790:	99                   	cltd   
}
  800791:	5d                   	pop    %ebp
  800792:	c3                   	ret    

00800793 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800793:	55                   	push   %ebp
  800794:	89 e5                	mov    %esp,%ebp
  800796:	56                   	push   %esi
  800797:	53                   	push   %ebx
  800798:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80079b:	eb 17                	jmp    8007b4 <vprintfmt+0x21>
			if (ch == '\0')
  80079d:	85 db                	test   %ebx,%ebx
  80079f:	0f 84 c1 03 00 00    	je     800b66 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007a5:	83 ec 08             	sub    $0x8,%esp
  8007a8:	ff 75 0c             	pushl  0xc(%ebp)
  8007ab:	53                   	push   %ebx
  8007ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8007af:	ff d0                	call   *%eax
  8007b1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b7:	8d 50 01             	lea    0x1(%eax),%edx
  8007ba:	89 55 10             	mov    %edx,0x10(%ebp)
  8007bd:	8a 00                	mov    (%eax),%al
  8007bf:	0f b6 d8             	movzbl %al,%ebx
  8007c2:	83 fb 25             	cmp    $0x25,%ebx
  8007c5:	75 d6                	jne    80079d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007c7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007cb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007d2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007d9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007e0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ea:	8d 50 01             	lea    0x1(%eax),%edx
  8007ed:	89 55 10             	mov    %edx,0x10(%ebp)
  8007f0:	8a 00                	mov    (%eax),%al
  8007f2:	0f b6 d8             	movzbl %al,%ebx
  8007f5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007f8:	83 f8 5b             	cmp    $0x5b,%eax
  8007fb:	0f 87 3d 03 00 00    	ja     800b3e <vprintfmt+0x3ab>
  800801:	8b 04 85 98 21 80 00 	mov    0x802198(,%eax,4),%eax
  800808:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80080a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80080e:	eb d7                	jmp    8007e7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800810:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800814:	eb d1                	jmp    8007e7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800816:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80081d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800820:	89 d0                	mov    %edx,%eax
  800822:	c1 e0 02             	shl    $0x2,%eax
  800825:	01 d0                	add    %edx,%eax
  800827:	01 c0                	add    %eax,%eax
  800829:	01 d8                	add    %ebx,%eax
  80082b:	83 e8 30             	sub    $0x30,%eax
  80082e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800831:	8b 45 10             	mov    0x10(%ebp),%eax
  800834:	8a 00                	mov    (%eax),%al
  800836:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800839:	83 fb 2f             	cmp    $0x2f,%ebx
  80083c:	7e 3e                	jle    80087c <vprintfmt+0xe9>
  80083e:	83 fb 39             	cmp    $0x39,%ebx
  800841:	7f 39                	jg     80087c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800843:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800846:	eb d5                	jmp    80081d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800848:	8b 45 14             	mov    0x14(%ebp),%eax
  80084b:	83 c0 04             	add    $0x4,%eax
  80084e:	89 45 14             	mov    %eax,0x14(%ebp)
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	83 e8 04             	sub    $0x4,%eax
  800857:	8b 00                	mov    (%eax),%eax
  800859:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80085c:	eb 1f                	jmp    80087d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80085e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800862:	79 83                	jns    8007e7 <vprintfmt+0x54>
				width = 0;
  800864:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80086b:	e9 77 ff ff ff       	jmp    8007e7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800870:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800877:	e9 6b ff ff ff       	jmp    8007e7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80087c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80087d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800881:	0f 89 60 ff ff ff    	jns    8007e7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800887:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80088a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80088d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800894:	e9 4e ff ff ff       	jmp    8007e7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800899:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80089c:	e9 46 ff ff ff       	jmp    8007e7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a4:	83 c0 04             	add    $0x4,%eax
  8008a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	83 e8 04             	sub    $0x4,%eax
  8008b0:	8b 00                	mov    (%eax),%eax
  8008b2:	83 ec 08             	sub    $0x8,%esp
  8008b5:	ff 75 0c             	pushl  0xc(%ebp)
  8008b8:	50                   	push   %eax
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	ff d0                	call   *%eax
  8008be:	83 c4 10             	add    $0x10,%esp
			break;
  8008c1:	e9 9b 02 00 00       	jmp    800b61 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c9:	83 c0 04             	add    $0x4,%eax
  8008cc:	89 45 14             	mov    %eax,0x14(%ebp)
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	83 e8 04             	sub    $0x4,%eax
  8008d5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008d7:	85 db                	test   %ebx,%ebx
  8008d9:	79 02                	jns    8008dd <vprintfmt+0x14a>
				err = -err;
  8008db:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008dd:	83 fb 64             	cmp    $0x64,%ebx
  8008e0:	7f 0b                	jg     8008ed <vprintfmt+0x15a>
  8008e2:	8b 34 9d e0 1f 80 00 	mov    0x801fe0(,%ebx,4),%esi
  8008e9:	85 f6                	test   %esi,%esi
  8008eb:	75 19                	jne    800906 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008ed:	53                   	push   %ebx
  8008ee:	68 85 21 80 00       	push   $0x802185
  8008f3:	ff 75 0c             	pushl  0xc(%ebp)
  8008f6:	ff 75 08             	pushl  0x8(%ebp)
  8008f9:	e8 70 02 00 00       	call   800b6e <printfmt>
  8008fe:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800901:	e9 5b 02 00 00       	jmp    800b61 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800906:	56                   	push   %esi
  800907:	68 8e 21 80 00       	push   $0x80218e
  80090c:	ff 75 0c             	pushl  0xc(%ebp)
  80090f:	ff 75 08             	pushl  0x8(%ebp)
  800912:	e8 57 02 00 00       	call   800b6e <printfmt>
  800917:	83 c4 10             	add    $0x10,%esp
			break;
  80091a:	e9 42 02 00 00       	jmp    800b61 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80091f:	8b 45 14             	mov    0x14(%ebp),%eax
  800922:	83 c0 04             	add    $0x4,%eax
  800925:	89 45 14             	mov    %eax,0x14(%ebp)
  800928:	8b 45 14             	mov    0x14(%ebp),%eax
  80092b:	83 e8 04             	sub    $0x4,%eax
  80092e:	8b 30                	mov    (%eax),%esi
  800930:	85 f6                	test   %esi,%esi
  800932:	75 05                	jne    800939 <vprintfmt+0x1a6>
				p = "(null)";
  800934:	be 91 21 80 00       	mov    $0x802191,%esi
			if (width > 0 && padc != '-')
  800939:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80093d:	7e 6d                	jle    8009ac <vprintfmt+0x219>
  80093f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800943:	74 67                	je     8009ac <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800945:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800948:	83 ec 08             	sub    $0x8,%esp
  80094b:	50                   	push   %eax
  80094c:	56                   	push   %esi
  80094d:	e8 1e 03 00 00       	call   800c70 <strnlen>
  800952:	83 c4 10             	add    $0x10,%esp
  800955:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800958:	eb 16                	jmp    800970 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80095a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80095e:	83 ec 08             	sub    $0x8,%esp
  800961:	ff 75 0c             	pushl  0xc(%ebp)
  800964:	50                   	push   %eax
  800965:	8b 45 08             	mov    0x8(%ebp),%eax
  800968:	ff d0                	call   *%eax
  80096a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80096d:	ff 4d e4             	decl   -0x1c(%ebp)
  800970:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800974:	7f e4                	jg     80095a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800976:	eb 34                	jmp    8009ac <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800978:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80097c:	74 1c                	je     80099a <vprintfmt+0x207>
  80097e:	83 fb 1f             	cmp    $0x1f,%ebx
  800981:	7e 05                	jle    800988 <vprintfmt+0x1f5>
  800983:	83 fb 7e             	cmp    $0x7e,%ebx
  800986:	7e 12                	jle    80099a <vprintfmt+0x207>
					putch('?', putdat);
  800988:	83 ec 08             	sub    $0x8,%esp
  80098b:	ff 75 0c             	pushl  0xc(%ebp)
  80098e:	6a 3f                	push   $0x3f
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	ff d0                	call   *%eax
  800995:	83 c4 10             	add    $0x10,%esp
  800998:	eb 0f                	jmp    8009a9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80099a:	83 ec 08             	sub    $0x8,%esp
  80099d:	ff 75 0c             	pushl  0xc(%ebp)
  8009a0:	53                   	push   %ebx
  8009a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a4:	ff d0                	call   *%eax
  8009a6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a9:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ac:	89 f0                	mov    %esi,%eax
  8009ae:	8d 70 01             	lea    0x1(%eax),%esi
  8009b1:	8a 00                	mov    (%eax),%al
  8009b3:	0f be d8             	movsbl %al,%ebx
  8009b6:	85 db                	test   %ebx,%ebx
  8009b8:	74 24                	je     8009de <vprintfmt+0x24b>
  8009ba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009be:	78 b8                	js     800978 <vprintfmt+0x1e5>
  8009c0:	ff 4d e0             	decl   -0x20(%ebp)
  8009c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009c7:	79 af                	jns    800978 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009c9:	eb 13                	jmp    8009de <vprintfmt+0x24b>
				putch(' ', putdat);
  8009cb:	83 ec 08             	sub    $0x8,%esp
  8009ce:	ff 75 0c             	pushl  0xc(%ebp)
  8009d1:	6a 20                	push   $0x20
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	ff d0                	call   *%eax
  8009d8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009db:	ff 4d e4             	decl   -0x1c(%ebp)
  8009de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e2:	7f e7                	jg     8009cb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009e4:	e9 78 01 00 00       	jmp    800b61 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ef:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f2:	50                   	push   %eax
  8009f3:	e8 3c fd ff ff       	call   800734 <getint>
  8009f8:	83 c4 10             	add    $0x10,%esp
  8009fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a07:	85 d2                	test   %edx,%edx
  800a09:	79 23                	jns    800a2e <vprintfmt+0x29b>
				putch('-', putdat);
  800a0b:	83 ec 08             	sub    $0x8,%esp
  800a0e:	ff 75 0c             	pushl  0xc(%ebp)
  800a11:	6a 2d                	push   $0x2d
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	ff d0                	call   *%eax
  800a18:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a21:	f7 d8                	neg    %eax
  800a23:	83 d2 00             	adc    $0x0,%edx
  800a26:	f7 da                	neg    %edx
  800a28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a2e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a35:	e9 bc 00 00 00       	jmp    800af6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a3a:	83 ec 08             	sub    $0x8,%esp
  800a3d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a40:	8d 45 14             	lea    0x14(%ebp),%eax
  800a43:	50                   	push   %eax
  800a44:	e8 84 fc ff ff       	call   8006cd <getuint>
  800a49:	83 c4 10             	add    $0x10,%esp
  800a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a52:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a59:	e9 98 00 00 00       	jmp    800af6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a5e:	83 ec 08             	sub    $0x8,%esp
  800a61:	ff 75 0c             	pushl  0xc(%ebp)
  800a64:	6a 58                	push   $0x58
  800a66:	8b 45 08             	mov    0x8(%ebp),%eax
  800a69:	ff d0                	call   *%eax
  800a6b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a6e:	83 ec 08             	sub    $0x8,%esp
  800a71:	ff 75 0c             	pushl  0xc(%ebp)
  800a74:	6a 58                	push   $0x58
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	ff d0                	call   *%eax
  800a7b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a7e:	83 ec 08             	sub    $0x8,%esp
  800a81:	ff 75 0c             	pushl  0xc(%ebp)
  800a84:	6a 58                	push   $0x58
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	ff d0                	call   *%eax
  800a8b:	83 c4 10             	add    $0x10,%esp
			break;
  800a8e:	e9 ce 00 00 00       	jmp    800b61 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a93:	83 ec 08             	sub    $0x8,%esp
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	6a 30                	push   $0x30
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	ff d0                	call   *%eax
  800aa0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 0c             	pushl  0xc(%ebp)
  800aa9:	6a 78                	push   $0x78
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	ff d0                	call   *%eax
  800ab0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab6:	83 c0 04             	add    $0x4,%eax
  800ab9:	89 45 14             	mov    %eax,0x14(%ebp)
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	83 e8 04             	sub    $0x4,%eax
  800ac2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ac4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ace:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ad5:	eb 1f                	jmp    800af6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ad7:	83 ec 08             	sub    $0x8,%esp
  800ada:	ff 75 e8             	pushl  -0x18(%ebp)
  800add:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae0:	50                   	push   %eax
  800ae1:	e8 e7 fb ff ff       	call   8006cd <getuint>
  800ae6:	83 c4 10             	add    $0x10,%esp
  800ae9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800af6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800afa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800afd:	83 ec 04             	sub    $0x4,%esp
  800b00:	52                   	push   %edx
  800b01:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b04:	50                   	push   %eax
  800b05:	ff 75 f4             	pushl  -0xc(%ebp)
  800b08:	ff 75 f0             	pushl  -0x10(%ebp)
  800b0b:	ff 75 0c             	pushl  0xc(%ebp)
  800b0e:	ff 75 08             	pushl  0x8(%ebp)
  800b11:	e8 00 fb ff ff       	call   800616 <printnum>
  800b16:	83 c4 20             	add    $0x20,%esp
			break;
  800b19:	eb 46                	jmp    800b61 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b1b:	83 ec 08             	sub    $0x8,%esp
  800b1e:	ff 75 0c             	pushl  0xc(%ebp)
  800b21:	53                   	push   %ebx
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	ff d0                	call   *%eax
  800b27:	83 c4 10             	add    $0x10,%esp
			break;
  800b2a:	eb 35                	jmp    800b61 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b2c:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b33:	eb 2c                	jmp    800b61 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b35:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b3c:	eb 23                	jmp    800b61 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b3e:	83 ec 08             	sub    $0x8,%esp
  800b41:	ff 75 0c             	pushl  0xc(%ebp)
  800b44:	6a 25                	push   $0x25
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	ff d0                	call   *%eax
  800b4b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b4e:	ff 4d 10             	decl   0x10(%ebp)
  800b51:	eb 03                	jmp    800b56 <vprintfmt+0x3c3>
  800b53:	ff 4d 10             	decl   0x10(%ebp)
  800b56:	8b 45 10             	mov    0x10(%ebp),%eax
  800b59:	48                   	dec    %eax
  800b5a:	8a 00                	mov    (%eax),%al
  800b5c:	3c 25                	cmp    $0x25,%al
  800b5e:	75 f3                	jne    800b53 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b60:	90                   	nop
		}
	}
  800b61:	e9 35 fc ff ff       	jmp    80079b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b66:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b67:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b6a:	5b                   	pop    %ebx
  800b6b:	5e                   	pop    %esi
  800b6c:	5d                   	pop    %ebp
  800b6d:	c3                   	ret    

00800b6e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b74:	8d 45 10             	lea    0x10(%ebp),%eax
  800b77:	83 c0 04             	add    $0x4,%eax
  800b7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b80:	ff 75 f4             	pushl  -0xc(%ebp)
  800b83:	50                   	push   %eax
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	ff 75 08             	pushl  0x8(%ebp)
  800b8a:	e8 04 fc ff ff       	call   800793 <vprintfmt>
  800b8f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b92:	90                   	nop
  800b93:	c9                   	leave  
  800b94:	c3                   	ret    

00800b95 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9b:	8b 40 08             	mov    0x8(%eax),%eax
  800b9e:	8d 50 01             	lea    0x1(%eax),%edx
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800baa:	8b 10                	mov    (%eax),%edx
  800bac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800baf:	8b 40 04             	mov    0x4(%eax),%eax
  800bb2:	39 c2                	cmp    %eax,%edx
  800bb4:	73 12                	jae    800bc8 <sprintputch+0x33>
		*b->buf++ = ch;
  800bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb9:	8b 00                	mov    (%eax),%eax
  800bbb:	8d 48 01             	lea    0x1(%eax),%ecx
  800bbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc1:	89 0a                	mov    %ecx,(%edx)
  800bc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc6:	88 10                	mov    %dl,(%eax)
}
  800bc8:	90                   	nop
  800bc9:	5d                   	pop    %ebp
  800bca:	c3                   	ret    

00800bcb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bda:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	01 d0                	add    %edx,%eax
  800be2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bf0:	74 06                	je     800bf8 <vsnprintf+0x2d>
  800bf2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf6:	7f 07                	jg     800bff <vsnprintf+0x34>
		return -E_INVAL;
  800bf8:	b8 03 00 00 00       	mov    $0x3,%eax
  800bfd:	eb 20                	jmp    800c1f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bff:	ff 75 14             	pushl  0x14(%ebp)
  800c02:	ff 75 10             	pushl  0x10(%ebp)
  800c05:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c08:	50                   	push   %eax
  800c09:	68 95 0b 80 00       	push   $0x800b95
  800c0e:	e8 80 fb ff ff       	call   800793 <vprintfmt>
  800c13:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c19:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c1f:	c9                   	leave  
  800c20:	c3                   	ret    

00800c21 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
  800c24:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c27:	8d 45 10             	lea    0x10(%ebp),%eax
  800c2a:	83 c0 04             	add    $0x4,%eax
  800c2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c30:	8b 45 10             	mov    0x10(%ebp),%eax
  800c33:	ff 75 f4             	pushl  -0xc(%ebp)
  800c36:	50                   	push   %eax
  800c37:	ff 75 0c             	pushl  0xc(%ebp)
  800c3a:	ff 75 08             	pushl  0x8(%ebp)
  800c3d:	e8 89 ff ff ff       	call   800bcb <vsnprintf>
  800c42:	83 c4 10             	add    $0x10,%esp
  800c45:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c4b:	c9                   	leave  
  800c4c:	c3                   	ret    

00800c4d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
  800c50:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c5a:	eb 06                	jmp    800c62 <strlen+0x15>
		n++;
  800c5c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c5f:	ff 45 08             	incl   0x8(%ebp)
  800c62:	8b 45 08             	mov    0x8(%ebp),%eax
  800c65:	8a 00                	mov    (%eax),%al
  800c67:	84 c0                	test   %al,%al
  800c69:	75 f1                	jne    800c5c <strlen+0xf>
		n++;
	return n;
  800c6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    

00800c70 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7d:	eb 09                	jmp    800c88 <strnlen+0x18>
		n++;
  800c7f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c82:	ff 45 08             	incl   0x8(%ebp)
  800c85:	ff 4d 0c             	decl   0xc(%ebp)
  800c88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8c:	74 09                	je     800c97 <strnlen+0x27>
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	84 c0                	test   %al,%al
  800c95:	75 e8                	jne    800c7f <strnlen+0xf>
		n++;
	return n;
  800c97:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ca8:	90                   	nop
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8d 50 01             	lea    0x1(%eax),%edx
  800caf:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cb8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cbb:	8a 12                	mov    (%edx),%dl
  800cbd:	88 10                	mov    %dl,(%eax)
  800cbf:	8a 00                	mov    (%eax),%al
  800cc1:	84 c0                	test   %al,%al
  800cc3:	75 e4                	jne    800ca9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc8:	c9                   	leave  
  800cc9:	c3                   	ret    

00800cca <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cd6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cdd:	eb 1f                	jmp    800cfe <strncpy+0x34>
		*dst++ = *src;
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	8d 50 01             	lea    0x1(%eax),%edx
  800ce5:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ceb:	8a 12                	mov    (%edx),%dl
  800ced:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf2:	8a 00                	mov    (%eax),%al
  800cf4:	84 c0                	test   %al,%al
  800cf6:	74 03                	je     800cfb <strncpy+0x31>
			src++;
  800cf8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cfb:	ff 45 fc             	incl   -0x4(%ebp)
  800cfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d01:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d04:	72 d9                	jb     800cdf <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d06:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d09:	c9                   	leave  
  800d0a:	c3                   	ret    

00800d0b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d17:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1b:	74 30                	je     800d4d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d1d:	eb 16                	jmp    800d35 <strlcpy+0x2a>
			*dst++ = *src++;
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8d 50 01             	lea    0x1(%eax),%edx
  800d25:	89 55 08             	mov    %edx,0x8(%ebp)
  800d28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d2e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d31:	8a 12                	mov    (%edx),%dl
  800d33:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d35:	ff 4d 10             	decl   0x10(%ebp)
  800d38:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3c:	74 09                	je     800d47 <strlcpy+0x3c>
  800d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d41:	8a 00                	mov    (%eax),%al
  800d43:	84 c0                	test   %al,%al
  800d45:	75 d8                	jne    800d1f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d53:	29 c2                	sub    %eax,%edx
  800d55:	89 d0                	mov    %edx,%eax
}
  800d57:	c9                   	leave  
  800d58:	c3                   	ret    

00800d59 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d5c:	eb 06                	jmp    800d64 <strcmp+0xb>
		p++, q++;
  800d5e:	ff 45 08             	incl   0x8(%ebp)
  800d61:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	8a 00                	mov    (%eax),%al
  800d69:	84 c0                	test   %al,%al
  800d6b:	74 0e                	je     800d7b <strcmp+0x22>
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	8a 10                	mov    (%eax),%dl
  800d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d75:	8a 00                	mov    (%eax),%al
  800d77:	38 c2                	cmp    %al,%dl
  800d79:	74 e3                	je     800d5e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	8a 00                	mov    (%eax),%al
  800d80:	0f b6 d0             	movzbl %al,%edx
  800d83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d86:	8a 00                	mov    (%eax),%al
  800d88:	0f b6 c0             	movzbl %al,%eax
  800d8b:	29 c2                	sub    %eax,%edx
  800d8d:	89 d0                	mov    %edx,%eax
}
  800d8f:	5d                   	pop    %ebp
  800d90:	c3                   	ret    

00800d91 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d94:	eb 09                	jmp    800d9f <strncmp+0xe>
		n--, p++, q++;
  800d96:	ff 4d 10             	decl   0x10(%ebp)
  800d99:	ff 45 08             	incl   0x8(%ebp)
  800d9c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da3:	74 17                	je     800dbc <strncmp+0x2b>
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	8a 00                	mov    (%eax),%al
  800daa:	84 c0                	test   %al,%al
  800dac:	74 0e                	je     800dbc <strncmp+0x2b>
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	8a 10                	mov    (%eax),%dl
  800db3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db6:	8a 00                	mov    (%eax),%al
  800db8:	38 c2                	cmp    %al,%dl
  800dba:	74 da                	je     800d96 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dbc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc0:	75 07                	jne    800dc9 <strncmp+0x38>
		return 0;
  800dc2:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc7:	eb 14                	jmp    800ddd <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	0f b6 d0             	movzbl %al,%edx
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	0f b6 c0             	movzbl %al,%eax
  800dd9:	29 c2                	sub    %eax,%edx
  800ddb:	89 d0                	mov    %edx,%eax
}
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    

00800ddf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
  800de2:	83 ec 04             	sub    $0x4,%esp
  800de5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800deb:	eb 12                	jmp    800dff <strchr+0x20>
		if (*s == c)
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	8a 00                	mov    (%eax),%al
  800df2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df5:	75 05                	jne    800dfc <strchr+0x1d>
			return (char *) s;
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	eb 11                	jmp    800e0d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dfc:	ff 45 08             	incl   0x8(%ebp)
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	8a 00                	mov    (%eax),%al
  800e04:	84 c0                	test   %al,%al
  800e06:	75 e5                	jne    800ded <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e0d:	c9                   	leave  
  800e0e:	c3                   	ret    

00800e0f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
  800e12:	83 ec 04             	sub    $0x4,%esp
  800e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e18:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e1b:	eb 0d                	jmp    800e2a <strfind+0x1b>
		if (*s == c)
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	8a 00                	mov    (%eax),%al
  800e22:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e25:	74 0e                	je     800e35 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e27:	ff 45 08             	incl   0x8(%ebp)
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	8a 00                	mov    (%eax),%al
  800e2f:	84 c0                	test   %al,%al
  800e31:	75 ea                	jne    800e1d <strfind+0xe>
  800e33:	eb 01                	jmp    800e36 <strfind+0x27>
		if (*s == c)
			break;
  800e35:	90                   	nop
	return (char *) s;
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e39:	c9                   	leave  
  800e3a:	c3                   	ret    

00800e3b <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
  800e3e:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e47:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e4b:	76 63                	jbe    800eb0 <memset+0x75>
		uint64 data_block = c;
  800e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e50:	99                   	cltd   
  800e51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e54:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e5d:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e61:	c1 e0 08             	shl    $0x8,%eax
  800e64:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e67:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e70:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e74:	c1 e0 10             	shl    $0x10,%eax
  800e77:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e7a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e83:	89 c2                	mov    %eax,%edx
  800e85:	b8 00 00 00 00       	mov    $0x0,%eax
  800e8a:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e8d:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e90:	eb 18                	jmp    800eaa <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e92:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e95:	8d 41 08             	lea    0x8(%ecx),%eax
  800e98:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea1:	89 01                	mov    %eax,(%ecx)
  800ea3:	89 51 04             	mov    %edx,0x4(%ecx)
  800ea6:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800eaa:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800eae:	77 e2                	ja     800e92 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800eb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb4:	74 23                	je     800ed9 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800eb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ebc:	eb 0e                	jmp    800ecc <memset+0x91>
			*p8++ = (uint8)c;
  800ebe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec1:	8d 50 01             	lea    0x1(%eax),%edx
  800ec4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ec7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eca:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed5:	85 c0                	test   %eax,%eax
  800ed7:	75 e5                	jne    800ebe <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800edc:	c9                   	leave  
  800edd:	c3                   	ret    

00800ede <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ede:	55                   	push   %ebp
  800edf:	89 e5                	mov    %esp,%ebp
  800ee1:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800eea:	8b 45 08             	mov    0x8(%ebp),%eax
  800eed:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800ef0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ef4:	76 24                	jbe    800f1a <memcpy+0x3c>
		while(n >= 8){
  800ef6:	eb 1c                	jmp    800f14 <memcpy+0x36>
			*d64 = *s64;
  800ef8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800efb:	8b 50 04             	mov    0x4(%eax),%edx
  800efe:	8b 00                	mov    (%eax),%eax
  800f00:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f03:	89 01                	mov    %eax,(%ecx)
  800f05:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f08:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f0c:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f10:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f14:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f18:	77 de                	ja     800ef8 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f1a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f1e:	74 31                	je     800f51 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f23:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f29:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f2c:	eb 16                	jmp    800f44 <memcpy+0x66>
			*d8++ = *s8++;
  800f2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f31:	8d 50 01             	lea    0x1(%eax),%edx
  800f34:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f3a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f3d:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f40:	8a 12                	mov    (%edx),%dl
  800f42:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f44:	8b 45 10             	mov    0x10(%ebp),%eax
  800f47:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f4a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f4d:	85 c0                	test   %eax,%eax
  800f4f:	75 dd                	jne    800f2e <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f54:	c9                   	leave  
  800f55:	c3                   	ret    

00800f56 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f56:	55                   	push   %ebp
  800f57:	89 e5                	mov    %esp,%ebp
  800f59:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f6b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f6e:	73 50                	jae    800fc0 <memmove+0x6a>
  800f70:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f73:	8b 45 10             	mov    0x10(%ebp),%eax
  800f76:	01 d0                	add    %edx,%eax
  800f78:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f7b:	76 43                	jbe    800fc0 <memmove+0x6a>
		s += n;
  800f7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f80:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f83:	8b 45 10             	mov    0x10(%ebp),%eax
  800f86:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f89:	eb 10                	jmp    800f9b <memmove+0x45>
			*--d = *--s;
  800f8b:	ff 4d f8             	decl   -0x8(%ebp)
  800f8e:	ff 4d fc             	decl   -0x4(%ebp)
  800f91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f94:	8a 10                	mov    (%eax),%dl
  800f96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f99:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa1:	89 55 10             	mov    %edx,0x10(%ebp)
  800fa4:	85 c0                	test   %eax,%eax
  800fa6:	75 e3                	jne    800f8b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fa8:	eb 23                	jmp    800fcd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800faa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fad:	8d 50 01             	lea    0x1(%eax),%edx
  800fb0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fb3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fb9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fbc:	8a 12                	mov    (%edx),%dl
  800fbe:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc6:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc9:	85 c0                	test   %eax,%eax
  800fcb:	75 dd                	jne    800faa <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd0:	c9                   	leave  
  800fd1:	c3                   	ret    

00800fd2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fe4:	eb 2a                	jmp    801010 <memcmp+0x3e>
		if (*s1 != *s2)
  800fe6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe9:	8a 10                	mov    (%eax),%dl
  800feb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fee:	8a 00                	mov    (%eax),%al
  800ff0:	38 c2                	cmp    %al,%dl
  800ff2:	74 16                	je     80100a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ff4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	0f b6 d0             	movzbl %al,%edx
  800ffc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	0f b6 c0             	movzbl %al,%eax
  801004:	29 c2                	sub    %eax,%edx
  801006:	89 d0                	mov    %edx,%eax
  801008:	eb 18                	jmp    801022 <memcmp+0x50>
		s1++, s2++;
  80100a:	ff 45 fc             	incl   -0x4(%ebp)
  80100d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801010:	8b 45 10             	mov    0x10(%ebp),%eax
  801013:	8d 50 ff             	lea    -0x1(%eax),%edx
  801016:	89 55 10             	mov    %edx,0x10(%ebp)
  801019:	85 c0                	test   %eax,%eax
  80101b:	75 c9                	jne    800fe6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80101d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801022:	c9                   	leave  
  801023:	c3                   	ret    

00801024 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801024:	55                   	push   %ebp
  801025:	89 e5                	mov    %esp,%ebp
  801027:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80102a:	8b 55 08             	mov    0x8(%ebp),%edx
  80102d:	8b 45 10             	mov    0x10(%ebp),%eax
  801030:	01 d0                	add    %edx,%eax
  801032:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801035:	eb 15                	jmp    80104c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	0f b6 d0             	movzbl %al,%edx
  80103f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801042:	0f b6 c0             	movzbl %al,%eax
  801045:	39 c2                	cmp    %eax,%edx
  801047:	74 0d                	je     801056 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801049:	ff 45 08             	incl   0x8(%ebp)
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801052:	72 e3                	jb     801037 <memfind+0x13>
  801054:	eb 01                	jmp    801057 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801056:	90                   	nop
	return (void *) s;
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80105a:	c9                   	leave  
  80105b:	c3                   	ret    

0080105c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
  80105f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801062:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801069:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801070:	eb 03                	jmp    801075 <strtol+0x19>
		s++;
  801072:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	8a 00                	mov    (%eax),%al
  80107a:	3c 20                	cmp    $0x20,%al
  80107c:	74 f4                	je     801072 <strtol+0x16>
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 09                	cmp    $0x9,%al
  801085:	74 eb                	je     801072 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	3c 2b                	cmp    $0x2b,%al
  80108e:	75 05                	jne    801095 <strtol+0x39>
		s++;
  801090:	ff 45 08             	incl   0x8(%ebp)
  801093:	eb 13                	jmp    8010a8 <strtol+0x4c>
	else if (*s == '-')
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	3c 2d                	cmp    $0x2d,%al
  80109c:	75 0a                	jne    8010a8 <strtol+0x4c>
		s++, neg = 1;
  80109e:	ff 45 08             	incl   0x8(%ebp)
  8010a1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ac:	74 06                	je     8010b4 <strtol+0x58>
  8010ae:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010b2:	75 20                	jne    8010d4 <strtol+0x78>
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	3c 30                	cmp    $0x30,%al
  8010bb:	75 17                	jne    8010d4 <strtol+0x78>
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	40                   	inc    %eax
  8010c1:	8a 00                	mov    (%eax),%al
  8010c3:	3c 78                	cmp    $0x78,%al
  8010c5:	75 0d                	jne    8010d4 <strtol+0x78>
		s += 2, base = 16;
  8010c7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010cb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010d2:	eb 28                	jmp    8010fc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d8:	75 15                	jne    8010ef <strtol+0x93>
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dd:	8a 00                	mov    (%eax),%al
  8010df:	3c 30                	cmp    $0x30,%al
  8010e1:	75 0c                	jne    8010ef <strtol+0x93>
		s++, base = 8;
  8010e3:	ff 45 08             	incl   0x8(%ebp)
  8010e6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010ed:	eb 0d                	jmp    8010fc <strtol+0xa0>
	else if (base == 0)
  8010ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f3:	75 07                	jne    8010fc <strtol+0xa0>
		base = 10;
  8010f5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	8a 00                	mov    (%eax),%al
  801101:	3c 2f                	cmp    $0x2f,%al
  801103:	7e 19                	jle    80111e <strtol+0xc2>
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	8a 00                	mov    (%eax),%al
  80110a:	3c 39                	cmp    $0x39,%al
  80110c:	7f 10                	jg     80111e <strtol+0xc2>
			dig = *s - '0';
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	0f be c0             	movsbl %al,%eax
  801116:	83 e8 30             	sub    $0x30,%eax
  801119:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80111c:	eb 42                	jmp    801160 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	8a 00                	mov    (%eax),%al
  801123:	3c 60                	cmp    $0x60,%al
  801125:	7e 19                	jle    801140 <strtol+0xe4>
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
  80112a:	8a 00                	mov    (%eax),%al
  80112c:	3c 7a                	cmp    $0x7a,%al
  80112e:	7f 10                	jg     801140 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	8a 00                	mov    (%eax),%al
  801135:	0f be c0             	movsbl %al,%eax
  801138:	83 e8 57             	sub    $0x57,%eax
  80113b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80113e:	eb 20                	jmp    801160 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
  801143:	8a 00                	mov    (%eax),%al
  801145:	3c 40                	cmp    $0x40,%al
  801147:	7e 39                	jle    801182 <strtol+0x126>
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	8a 00                	mov    (%eax),%al
  80114e:	3c 5a                	cmp    $0x5a,%al
  801150:	7f 30                	jg     801182 <strtol+0x126>
			dig = *s - 'A' + 10;
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
  801155:	8a 00                	mov    (%eax),%al
  801157:	0f be c0             	movsbl %al,%eax
  80115a:	83 e8 37             	sub    $0x37,%eax
  80115d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801163:	3b 45 10             	cmp    0x10(%ebp),%eax
  801166:	7d 19                	jge    801181 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801168:	ff 45 08             	incl   0x8(%ebp)
  80116b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80116e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801172:	89 c2                	mov    %eax,%edx
  801174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801177:	01 d0                	add    %edx,%eax
  801179:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80117c:	e9 7b ff ff ff       	jmp    8010fc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801181:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801182:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801186:	74 08                	je     801190 <strtol+0x134>
		*endptr = (char *) s;
  801188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118b:	8b 55 08             	mov    0x8(%ebp),%edx
  80118e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801190:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801194:	74 07                	je     80119d <strtol+0x141>
  801196:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801199:	f7 d8                	neg    %eax
  80119b:	eb 03                	jmp    8011a0 <strtol+0x144>
  80119d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011a0:	c9                   	leave  
  8011a1:	c3                   	ret    

008011a2 <ltostr>:

void
ltostr(long value, char *str)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
  8011a5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011ba:	79 13                	jns    8011cf <ltostr+0x2d>
	{
		neg = 1;
  8011bc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011c9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011cc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011d7:	99                   	cltd   
  8011d8:	f7 f9                	idiv   %ecx
  8011da:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e0:	8d 50 01             	lea    0x1(%eax),%edx
  8011e3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011e6:	89 c2                	mov    %eax,%edx
  8011e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011eb:	01 d0                	add    %edx,%eax
  8011ed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011f0:	83 c2 30             	add    $0x30,%edx
  8011f3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011f8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011fd:	f7 e9                	imul   %ecx
  8011ff:	c1 fa 02             	sar    $0x2,%edx
  801202:	89 c8                	mov    %ecx,%eax
  801204:	c1 f8 1f             	sar    $0x1f,%eax
  801207:	29 c2                	sub    %eax,%edx
  801209:	89 d0                	mov    %edx,%eax
  80120b:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80120e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801212:	75 bb                	jne    8011cf <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801214:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80121b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121e:	48                   	dec    %eax
  80121f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801222:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801226:	74 3d                	je     801265 <ltostr+0xc3>
		start = 1 ;
  801228:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80122f:	eb 34                	jmp    801265 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801231:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801234:	8b 45 0c             	mov    0xc(%ebp),%eax
  801237:	01 d0                	add    %edx,%eax
  801239:	8a 00                	mov    (%eax),%al
  80123b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80123e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801241:	8b 45 0c             	mov    0xc(%ebp),%eax
  801244:	01 c2                	add    %eax,%edx
  801246:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124c:	01 c8                	add    %ecx,%eax
  80124e:	8a 00                	mov    (%eax),%al
  801250:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801252:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801255:	8b 45 0c             	mov    0xc(%ebp),%eax
  801258:	01 c2                	add    %eax,%edx
  80125a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80125d:	88 02                	mov    %al,(%edx)
		start++ ;
  80125f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801262:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801268:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80126b:	7c c4                	jl     801231 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80126d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801270:	8b 45 0c             	mov    0xc(%ebp),%eax
  801273:	01 d0                	add    %edx,%eax
  801275:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801278:	90                   	nop
  801279:	c9                   	leave  
  80127a:	c3                   	ret    

0080127b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
  80127e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801281:	ff 75 08             	pushl  0x8(%ebp)
  801284:	e8 c4 f9 ff ff       	call   800c4d <strlen>
  801289:	83 c4 04             	add    $0x4,%esp
  80128c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80128f:	ff 75 0c             	pushl  0xc(%ebp)
  801292:	e8 b6 f9 ff ff       	call   800c4d <strlen>
  801297:	83 c4 04             	add    $0x4,%esp
  80129a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80129d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012ab:	eb 17                	jmp    8012c4 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b3:	01 c2                	add    %eax,%edx
  8012b5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	01 c8                	add    %ecx,%eax
  8012bd:	8a 00                	mov    (%eax),%al
  8012bf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012c1:	ff 45 fc             	incl   -0x4(%ebp)
  8012c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012ca:	7c e1                	jl     8012ad <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012d3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012da:	eb 1f                	jmp    8012fb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012df:	8d 50 01             	lea    0x1(%eax),%edx
  8012e2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012e5:	89 c2                	mov    %eax,%edx
  8012e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ea:	01 c2                	add    %eax,%edx
  8012ec:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f2:	01 c8                	add    %ecx,%eax
  8012f4:	8a 00                	mov    (%eax),%al
  8012f6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012f8:	ff 45 f8             	incl   -0x8(%ebp)
  8012fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801301:	7c d9                	jl     8012dc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801303:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801306:	8b 45 10             	mov    0x10(%ebp),%eax
  801309:	01 d0                	add    %edx,%eax
  80130b:	c6 00 00             	movb   $0x0,(%eax)
}
  80130e:	90                   	nop
  80130f:	c9                   	leave  
  801310:	c3                   	ret    

00801311 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801314:	8b 45 14             	mov    0x14(%ebp),%eax
  801317:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80131d:	8b 45 14             	mov    0x14(%ebp),%eax
  801320:	8b 00                	mov    (%eax),%eax
  801322:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801329:	8b 45 10             	mov    0x10(%ebp),%eax
  80132c:	01 d0                	add    %edx,%eax
  80132e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801334:	eb 0c                	jmp    801342 <strsplit+0x31>
			*string++ = 0;
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	8d 50 01             	lea    0x1(%eax),%edx
  80133c:	89 55 08             	mov    %edx,0x8(%ebp)
  80133f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801342:	8b 45 08             	mov    0x8(%ebp),%eax
  801345:	8a 00                	mov    (%eax),%al
  801347:	84 c0                	test   %al,%al
  801349:	74 18                	je     801363 <strsplit+0x52>
  80134b:	8b 45 08             	mov    0x8(%ebp),%eax
  80134e:	8a 00                	mov    (%eax),%al
  801350:	0f be c0             	movsbl %al,%eax
  801353:	50                   	push   %eax
  801354:	ff 75 0c             	pushl  0xc(%ebp)
  801357:	e8 83 fa ff ff       	call   800ddf <strchr>
  80135c:	83 c4 08             	add    $0x8,%esp
  80135f:	85 c0                	test   %eax,%eax
  801361:	75 d3                	jne    801336 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	8a 00                	mov    (%eax),%al
  801368:	84 c0                	test   %al,%al
  80136a:	74 5a                	je     8013c6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80136c:	8b 45 14             	mov    0x14(%ebp),%eax
  80136f:	8b 00                	mov    (%eax),%eax
  801371:	83 f8 0f             	cmp    $0xf,%eax
  801374:	75 07                	jne    80137d <strsplit+0x6c>
		{
			return 0;
  801376:	b8 00 00 00 00       	mov    $0x0,%eax
  80137b:	eb 66                	jmp    8013e3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80137d:	8b 45 14             	mov    0x14(%ebp),%eax
  801380:	8b 00                	mov    (%eax),%eax
  801382:	8d 48 01             	lea    0x1(%eax),%ecx
  801385:	8b 55 14             	mov    0x14(%ebp),%edx
  801388:	89 0a                	mov    %ecx,(%edx)
  80138a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801391:	8b 45 10             	mov    0x10(%ebp),%eax
  801394:	01 c2                	add    %eax,%edx
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80139b:	eb 03                	jmp    8013a0 <strsplit+0x8f>
			string++;
  80139d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8a 00                	mov    (%eax),%al
  8013a5:	84 c0                	test   %al,%al
  8013a7:	74 8b                	je     801334 <strsplit+0x23>
  8013a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ac:	8a 00                	mov    (%eax),%al
  8013ae:	0f be c0             	movsbl %al,%eax
  8013b1:	50                   	push   %eax
  8013b2:	ff 75 0c             	pushl  0xc(%ebp)
  8013b5:	e8 25 fa ff ff       	call   800ddf <strchr>
  8013ba:	83 c4 08             	add    $0x8,%esp
  8013bd:	85 c0                	test   %eax,%eax
  8013bf:	74 dc                	je     80139d <strsplit+0x8c>
			string++;
	}
  8013c1:	e9 6e ff ff ff       	jmp    801334 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013c6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ca:	8b 00                	mov    (%eax),%eax
  8013cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d6:	01 d0                	add    %edx,%eax
  8013d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013de:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013e3:	c9                   	leave  
  8013e4:	c3                   	ret    

008013e5 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013e5:	55                   	push   %ebp
  8013e6:	89 e5                	mov    %esp,%ebp
  8013e8:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f8:	eb 4a                	jmp    801444 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8013fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801400:	01 c2                	add    %eax,%edx
  801402:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801405:	8b 45 0c             	mov    0xc(%ebp),%eax
  801408:	01 c8                	add    %ecx,%eax
  80140a:	8a 00                	mov    (%eax),%al
  80140c:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80140e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801411:	8b 45 0c             	mov    0xc(%ebp),%eax
  801414:	01 d0                	add    %edx,%eax
  801416:	8a 00                	mov    (%eax),%al
  801418:	3c 40                	cmp    $0x40,%al
  80141a:	7e 25                	jle    801441 <str2lower+0x5c>
  80141c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80141f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801422:	01 d0                	add    %edx,%eax
  801424:	8a 00                	mov    (%eax),%al
  801426:	3c 5a                	cmp    $0x5a,%al
  801428:	7f 17                	jg     801441 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80142a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	01 d0                	add    %edx,%eax
  801432:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801435:	8b 55 08             	mov    0x8(%ebp),%edx
  801438:	01 ca                	add    %ecx,%edx
  80143a:	8a 12                	mov    (%edx),%dl
  80143c:	83 c2 20             	add    $0x20,%edx
  80143f:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801441:	ff 45 fc             	incl   -0x4(%ebp)
  801444:	ff 75 0c             	pushl  0xc(%ebp)
  801447:	e8 01 f8 ff ff       	call   800c4d <strlen>
  80144c:	83 c4 04             	add    $0x4,%esp
  80144f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801452:	7f a6                	jg     8013fa <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801454:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801457:	c9                   	leave  
  801458:	c3                   	ret    

00801459 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801459:	55                   	push   %ebp
  80145a:	89 e5                	mov    %esp,%ebp
  80145c:	57                   	push   %edi
  80145d:	56                   	push   %esi
  80145e:	53                   	push   %ebx
  80145f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	8b 55 0c             	mov    0xc(%ebp),%edx
  801468:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80146b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80146e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801471:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801474:	cd 30                	int    $0x30
  801476:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801479:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80147c:	83 c4 10             	add    $0x10,%esp
  80147f:	5b                   	pop    %ebx
  801480:	5e                   	pop    %esi
  801481:	5f                   	pop    %edi
  801482:	5d                   	pop    %ebp
  801483:	c3                   	ret    

00801484 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	83 ec 04             	sub    $0x4,%esp
  80148a:	8b 45 10             	mov    0x10(%ebp),%eax
  80148d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801490:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801493:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
  80149a:	6a 00                	push   $0x0
  80149c:	51                   	push   %ecx
  80149d:	52                   	push   %edx
  80149e:	ff 75 0c             	pushl  0xc(%ebp)
  8014a1:	50                   	push   %eax
  8014a2:	6a 00                	push   $0x0
  8014a4:	e8 b0 ff ff ff       	call   801459 <syscall>
  8014a9:	83 c4 18             	add    $0x18,%esp
}
  8014ac:	90                   	nop
  8014ad:	c9                   	leave  
  8014ae:	c3                   	ret    

008014af <sys_cgetc>:

int
sys_cgetc(void)
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014b2:	6a 00                	push   $0x0
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 02                	push   $0x2
  8014be:	e8 96 ff ff ff       	call   801459 <syscall>
  8014c3:	83 c4 18             	add    $0x18,%esp
}
  8014c6:	c9                   	leave  
  8014c7:	c3                   	ret    

008014c8 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014c8:	55                   	push   %ebp
  8014c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014cb:	6a 00                	push   $0x0
  8014cd:	6a 00                	push   $0x0
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 03                	push   $0x3
  8014d7:	e8 7d ff ff ff       	call   801459 <syscall>
  8014dc:	83 c4 18             	add    $0x18,%esp
}
  8014df:	90                   	nop
  8014e0:	c9                   	leave  
  8014e1:	c3                   	ret    

008014e2 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8014e2:	55                   	push   %ebp
  8014e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 04                	push   $0x4
  8014f1:	e8 63 ff ff ff       	call   801459 <syscall>
  8014f6:	83 c4 18             	add    $0x18,%esp
}
  8014f9:	90                   	nop
  8014fa:	c9                   	leave  
  8014fb:	c3                   	ret    

008014fc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	52                   	push   %edx
  80150c:	50                   	push   %eax
  80150d:	6a 08                	push   $0x8
  80150f:	e8 45 ff ff ff       	call   801459 <syscall>
  801514:	83 c4 18             	add    $0x18,%esp
}
  801517:	c9                   	leave  
  801518:	c3                   	ret    

00801519 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
  80151c:	56                   	push   %esi
  80151d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80151e:	8b 75 18             	mov    0x18(%ebp),%esi
  801521:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801524:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801527:	8b 55 0c             	mov    0xc(%ebp),%edx
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	56                   	push   %esi
  80152e:	53                   	push   %ebx
  80152f:	51                   	push   %ecx
  801530:	52                   	push   %edx
  801531:	50                   	push   %eax
  801532:	6a 09                	push   $0x9
  801534:	e8 20 ff ff ff       	call   801459 <syscall>
  801539:	83 c4 18             	add    $0x18,%esp
}
  80153c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80153f:	5b                   	pop    %ebx
  801540:	5e                   	pop    %esi
  801541:	5d                   	pop    %ebp
  801542:	c3                   	ret    

00801543 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	6a 00                	push   $0x0
  80154e:	ff 75 08             	pushl  0x8(%ebp)
  801551:	6a 0a                	push   $0xa
  801553:	e8 01 ff ff ff       	call   801459 <syscall>
  801558:	83 c4 18             	add    $0x18,%esp
}
  80155b:	c9                   	leave  
  80155c:	c3                   	ret    

0080155d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80155d:	55                   	push   %ebp
  80155e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	ff 75 0c             	pushl  0xc(%ebp)
  801569:	ff 75 08             	pushl  0x8(%ebp)
  80156c:	6a 0b                	push   $0xb
  80156e:	e8 e6 fe ff ff       	call   801459 <syscall>
  801573:	83 c4 18             	add    $0x18,%esp
}
  801576:	c9                   	leave  
  801577:	c3                   	ret    

00801578 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 0c                	push   $0xc
  801587:	e8 cd fe ff ff       	call   801459 <syscall>
  80158c:	83 c4 18             	add    $0x18,%esp
}
  80158f:	c9                   	leave  
  801590:	c3                   	ret    

00801591 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	6a 0d                	push   $0xd
  8015a0:	e8 b4 fe ff ff       	call   801459 <syscall>
  8015a5:	83 c4 18             	add    $0x18,%esp
}
  8015a8:	c9                   	leave  
  8015a9:	c3                   	ret    

008015aa <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 0e                	push   $0xe
  8015b9:	e8 9b fe ff ff       	call   801459 <syscall>
  8015be:	83 c4 18             	add    $0x18,%esp
}
  8015c1:	c9                   	leave  
  8015c2:	c3                   	ret    

008015c3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 0f                	push   $0xf
  8015d2:	e8 82 fe ff ff       	call   801459 <syscall>
  8015d7:	83 c4 18             	add    $0x18,%esp
}
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	ff 75 08             	pushl  0x8(%ebp)
  8015ea:	6a 10                	push   $0x10
  8015ec:	e8 68 fe ff ff       	call   801459 <syscall>
  8015f1:	83 c4 18             	add    $0x18,%esp
}
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 11                	push   $0x11
  801605:	e8 4f fe ff ff       	call   801459 <syscall>
  80160a:	83 c4 18             	add    $0x18,%esp
}
  80160d:	90                   	nop
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    

00801610 <sys_cputc>:

void
sys_cputc(const char c)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
  801613:	83 ec 04             	sub    $0x4,%esp
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80161c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	50                   	push   %eax
  801629:	6a 01                	push   $0x1
  80162b:	e8 29 fe ff ff       	call   801459 <syscall>
  801630:	83 c4 18             	add    $0x18,%esp
}
  801633:	90                   	nop
  801634:	c9                   	leave  
  801635:	c3                   	ret    

00801636 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 14                	push   $0x14
  801645:	e8 0f fe ff ff       	call   801459 <syscall>
  80164a:	83 c4 18             	add    $0x18,%esp
}
  80164d:	90                   	nop
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    

00801650 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	83 ec 04             	sub    $0x4,%esp
  801656:	8b 45 10             	mov    0x10(%ebp),%eax
  801659:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80165c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80165f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
  801666:	6a 00                	push   $0x0
  801668:	51                   	push   %ecx
  801669:	52                   	push   %edx
  80166a:	ff 75 0c             	pushl  0xc(%ebp)
  80166d:	50                   	push   %eax
  80166e:	6a 15                	push   $0x15
  801670:	e8 e4 fd ff ff       	call   801459 <syscall>
  801675:	83 c4 18             	add    $0x18,%esp
}
  801678:	c9                   	leave  
  801679:	c3                   	ret    

0080167a <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80167d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	52                   	push   %edx
  80168a:	50                   	push   %eax
  80168b:	6a 16                	push   $0x16
  80168d:	e8 c7 fd ff ff       	call   801459 <syscall>
  801692:	83 c4 18             	add    $0x18,%esp
}
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80169a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80169d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	51                   	push   %ecx
  8016a8:	52                   	push   %edx
  8016a9:	50                   	push   %eax
  8016aa:	6a 17                	push   $0x17
  8016ac:	e8 a8 fd ff ff       	call   801459 <syscall>
  8016b1:	83 c4 18             	add    $0x18,%esp
}
  8016b4:	c9                   	leave  
  8016b5:	c3                   	ret    

008016b6 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	52                   	push   %edx
  8016c6:	50                   	push   %eax
  8016c7:	6a 18                	push   $0x18
  8016c9:	e8 8b fd ff ff       	call   801459 <syscall>
  8016ce:	83 c4 18             	add    $0x18,%esp
}
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d9:	6a 00                	push   $0x0
  8016db:	ff 75 14             	pushl  0x14(%ebp)
  8016de:	ff 75 10             	pushl  0x10(%ebp)
  8016e1:	ff 75 0c             	pushl  0xc(%ebp)
  8016e4:	50                   	push   %eax
  8016e5:	6a 19                	push   $0x19
  8016e7:	e8 6d fd ff ff       	call   801459 <syscall>
  8016ec:	83 c4 18             	add    $0x18,%esp
}
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	50                   	push   %eax
  801700:	6a 1a                	push   $0x1a
  801702:	e8 52 fd ff ff       	call   801459 <syscall>
  801707:	83 c4 18             	add    $0x18,%esp
}
  80170a:	90                   	nop
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801710:	8b 45 08             	mov    0x8(%ebp),%eax
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	50                   	push   %eax
  80171c:	6a 1b                	push   $0x1b
  80171e:	e8 36 fd ff ff       	call   801459 <syscall>
  801723:	83 c4 18             	add    $0x18,%esp
}
  801726:	c9                   	leave  
  801727:	c3                   	ret    

00801728 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 05                	push   $0x5
  801737:	e8 1d fd ff ff       	call   801459 <syscall>
  80173c:	83 c4 18             	add    $0x18,%esp
}
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 06                	push   $0x6
  801750:	e8 04 fd ff ff       	call   801459 <syscall>
  801755:	83 c4 18             	add    $0x18,%esp
}
  801758:	c9                   	leave  
  801759:	c3                   	ret    

0080175a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 07                	push   $0x7
  801769:	e8 eb fc ff ff       	call   801459 <syscall>
  80176e:	83 c4 18             	add    $0x18,%esp
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <sys_exit_env>:


void sys_exit_env(void)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 1c                	push   $0x1c
  801782:	e8 d2 fc ff ff       	call   801459 <syscall>
  801787:	83 c4 18             	add    $0x18,%esp
}
  80178a:	90                   	nop
  80178b:	c9                   	leave  
  80178c:	c3                   	ret    

0080178d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801793:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801796:	8d 50 04             	lea    0x4(%eax),%edx
  801799:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	52                   	push   %edx
  8017a3:	50                   	push   %eax
  8017a4:	6a 1d                	push   $0x1d
  8017a6:	e8 ae fc ff ff       	call   801459 <syscall>
  8017ab:	83 c4 18             	add    $0x18,%esp
	return result;
  8017ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b7:	89 01                	mov    %eax,(%ecx)
  8017b9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bf:	c9                   	leave  
  8017c0:	c2 04 00             	ret    $0x4

008017c3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	ff 75 10             	pushl  0x10(%ebp)
  8017cd:	ff 75 0c             	pushl  0xc(%ebp)
  8017d0:	ff 75 08             	pushl  0x8(%ebp)
  8017d3:	6a 13                	push   $0x13
  8017d5:	e8 7f fc ff ff       	call   801459 <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
	return ;
  8017dd:	90                   	nop
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <sys_rcr2>:
uint32 sys_rcr2()
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 1e                	push   $0x1e
  8017ef:	e8 65 fc ff ff       	call   801459 <syscall>
  8017f4:	83 c4 18             	add    $0x18,%esp
}
  8017f7:	c9                   	leave  
  8017f8:	c3                   	ret    

008017f9 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
  8017fc:	83 ec 04             	sub    $0x4,%esp
  8017ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801802:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801805:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	50                   	push   %eax
  801812:	6a 1f                	push   $0x1f
  801814:	e8 40 fc ff ff       	call   801459 <syscall>
  801819:	83 c4 18             	add    $0x18,%esp
	return ;
  80181c:	90                   	nop
}
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    

0080181f <rsttst>:
void rsttst()
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 21                	push   $0x21
  80182e:	e8 26 fc ff ff       	call   801459 <syscall>
  801833:	83 c4 18             	add    $0x18,%esp
	return ;
  801836:	90                   	nop
}
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
  80183c:	83 ec 04             	sub    $0x4,%esp
  80183f:	8b 45 14             	mov    0x14(%ebp),%eax
  801842:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801845:	8b 55 18             	mov    0x18(%ebp),%edx
  801848:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80184c:	52                   	push   %edx
  80184d:	50                   	push   %eax
  80184e:	ff 75 10             	pushl  0x10(%ebp)
  801851:	ff 75 0c             	pushl  0xc(%ebp)
  801854:	ff 75 08             	pushl  0x8(%ebp)
  801857:	6a 20                	push   $0x20
  801859:	e8 fb fb ff ff       	call   801459 <syscall>
  80185e:	83 c4 18             	add    $0x18,%esp
	return ;
  801861:	90                   	nop
}
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <chktst>:
void chktst(uint32 n)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	ff 75 08             	pushl  0x8(%ebp)
  801872:	6a 22                	push   $0x22
  801874:	e8 e0 fb ff ff       	call   801459 <syscall>
  801879:	83 c4 18             	add    $0x18,%esp
	return ;
  80187c:	90                   	nop
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <inctst>:

void inctst()
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 23                	push   $0x23
  80188e:	e8 c6 fb ff ff       	call   801459 <syscall>
  801893:	83 c4 18             	add    $0x18,%esp
	return ;
  801896:	90                   	nop
}
  801897:	c9                   	leave  
  801898:	c3                   	ret    

00801899 <gettst>:
uint32 gettst()
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 24                	push   $0x24
  8018a8:	e8 ac fb ff ff       	call   801459 <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 25                	push   $0x25
  8018c1:	e8 93 fb ff ff       	call   801459 <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
  8018c9:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8018ce:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8018d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018db:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	ff 75 08             	pushl  0x8(%ebp)
  8018eb:	6a 26                	push   $0x26
  8018ed:	e8 67 fb ff ff       	call   801459 <syscall>
  8018f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f5:	90                   	nop
}
  8018f6:	c9                   	leave  
  8018f7:	c3                   	ret    

008018f8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
  8018fb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018fc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801902:	8b 55 0c             	mov    0xc(%ebp),%edx
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	6a 00                	push   $0x0
  80190a:	53                   	push   %ebx
  80190b:	51                   	push   %ecx
  80190c:	52                   	push   %edx
  80190d:	50                   	push   %eax
  80190e:	6a 27                	push   $0x27
  801910:	e8 44 fb ff ff       	call   801459 <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
}
  801918:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801920:	8b 55 0c             	mov    0xc(%ebp),%edx
  801923:	8b 45 08             	mov    0x8(%ebp),%eax
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	52                   	push   %edx
  80192d:	50                   	push   %eax
  80192e:	6a 28                	push   $0x28
  801930:	e8 24 fb ff ff       	call   801459 <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80193d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801940:	8b 55 0c             	mov    0xc(%ebp),%edx
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	6a 00                	push   $0x0
  801948:	51                   	push   %ecx
  801949:	ff 75 10             	pushl  0x10(%ebp)
  80194c:	52                   	push   %edx
  80194d:	50                   	push   %eax
  80194e:	6a 29                	push   $0x29
  801950:	e8 04 fb ff ff       	call   801459 <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
}
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	ff 75 10             	pushl  0x10(%ebp)
  801964:	ff 75 0c             	pushl  0xc(%ebp)
  801967:	ff 75 08             	pushl  0x8(%ebp)
  80196a:	6a 12                	push   $0x12
  80196c:	e8 e8 fa ff ff       	call   801459 <syscall>
  801971:	83 c4 18             	add    $0x18,%esp
	return ;
  801974:	90                   	nop
}
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80197a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	52                   	push   %edx
  801987:	50                   	push   %eax
  801988:	6a 2a                	push   $0x2a
  80198a:	e8 ca fa ff ff       	call   801459 <syscall>
  80198f:	83 c4 18             	add    $0x18,%esp
	return;
  801992:	90                   	nop
}
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 2b                	push   $0x2b
  8019a4:	e8 b0 fa ff ff       	call   801459 <syscall>
  8019a9:	83 c4 18             	add    $0x18,%esp
}
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ba:	ff 75 08             	pushl  0x8(%ebp)
  8019bd:	6a 2d                	push   $0x2d
  8019bf:	e8 95 fa ff ff       	call   801459 <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
	return;
  8019c7:	90                   	nop
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	ff 75 0c             	pushl  0xc(%ebp)
  8019d6:	ff 75 08             	pushl  0x8(%ebp)
  8019d9:	6a 2c                	push   $0x2c
  8019db:	e8 79 fa ff ff       	call   801459 <syscall>
  8019e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e3:	90                   	nop
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8019ec:	83 ec 04             	sub    $0x4,%esp
  8019ef:	68 08 23 80 00       	push   $0x802308
  8019f4:	68 25 01 00 00       	push   $0x125
  8019f9:	68 3b 23 80 00       	push   $0x80233b
  8019fe:	e8 a3 e8 ff ff       	call   8002a6 <_panic>
  801a03:	90                   	nop

00801a04 <__udivdi3>:
  801a04:	55                   	push   %ebp
  801a05:	57                   	push   %edi
  801a06:	56                   	push   %esi
  801a07:	53                   	push   %ebx
  801a08:	83 ec 1c             	sub    $0x1c,%esp
  801a0b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a0f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a17:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a1b:	89 ca                	mov    %ecx,%edx
  801a1d:	89 f8                	mov    %edi,%eax
  801a1f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a23:	85 f6                	test   %esi,%esi
  801a25:	75 2d                	jne    801a54 <__udivdi3+0x50>
  801a27:	39 cf                	cmp    %ecx,%edi
  801a29:	77 65                	ja     801a90 <__udivdi3+0x8c>
  801a2b:	89 fd                	mov    %edi,%ebp
  801a2d:	85 ff                	test   %edi,%edi
  801a2f:	75 0b                	jne    801a3c <__udivdi3+0x38>
  801a31:	b8 01 00 00 00       	mov    $0x1,%eax
  801a36:	31 d2                	xor    %edx,%edx
  801a38:	f7 f7                	div    %edi
  801a3a:	89 c5                	mov    %eax,%ebp
  801a3c:	31 d2                	xor    %edx,%edx
  801a3e:	89 c8                	mov    %ecx,%eax
  801a40:	f7 f5                	div    %ebp
  801a42:	89 c1                	mov    %eax,%ecx
  801a44:	89 d8                	mov    %ebx,%eax
  801a46:	f7 f5                	div    %ebp
  801a48:	89 cf                	mov    %ecx,%edi
  801a4a:	89 fa                	mov    %edi,%edx
  801a4c:	83 c4 1c             	add    $0x1c,%esp
  801a4f:	5b                   	pop    %ebx
  801a50:	5e                   	pop    %esi
  801a51:	5f                   	pop    %edi
  801a52:	5d                   	pop    %ebp
  801a53:	c3                   	ret    
  801a54:	39 ce                	cmp    %ecx,%esi
  801a56:	77 28                	ja     801a80 <__udivdi3+0x7c>
  801a58:	0f bd fe             	bsr    %esi,%edi
  801a5b:	83 f7 1f             	xor    $0x1f,%edi
  801a5e:	75 40                	jne    801aa0 <__udivdi3+0x9c>
  801a60:	39 ce                	cmp    %ecx,%esi
  801a62:	72 0a                	jb     801a6e <__udivdi3+0x6a>
  801a64:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a68:	0f 87 9e 00 00 00    	ja     801b0c <__udivdi3+0x108>
  801a6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a73:	89 fa                	mov    %edi,%edx
  801a75:	83 c4 1c             	add    $0x1c,%esp
  801a78:	5b                   	pop    %ebx
  801a79:	5e                   	pop    %esi
  801a7a:	5f                   	pop    %edi
  801a7b:	5d                   	pop    %ebp
  801a7c:	c3                   	ret    
  801a7d:	8d 76 00             	lea    0x0(%esi),%esi
  801a80:	31 ff                	xor    %edi,%edi
  801a82:	31 c0                	xor    %eax,%eax
  801a84:	89 fa                	mov    %edi,%edx
  801a86:	83 c4 1c             	add    $0x1c,%esp
  801a89:	5b                   	pop    %ebx
  801a8a:	5e                   	pop    %esi
  801a8b:	5f                   	pop    %edi
  801a8c:	5d                   	pop    %ebp
  801a8d:	c3                   	ret    
  801a8e:	66 90                	xchg   %ax,%ax
  801a90:	89 d8                	mov    %ebx,%eax
  801a92:	f7 f7                	div    %edi
  801a94:	31 ff                	xor    %edi,%edi
  801a96:	89 fa                	mov    %edi,%edx
  801a98:	83 c4 1c             	add    $0x1c,%esp
  801a9b:	5b                   	pop    %ebx
  801a9c:	5e                   	pop    %esi
  801a9d:	5f                   	pop    %edi
  801a9e:	5d                   	pop    %ebp
  801a9f:	c3                   	ret    
  801aa0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801aa5:	89 eb                	mov    %ebp,%ebx
  801aa7:	29 fb                	sub    %edi,%ebx
  801aa9:	89 f9                	mov    %edi,%ecx
  801aab:	d3 e6                	shl    %cl,%esi
  801aad:	89 c5                	mov    %eax,%ebp
  801aaf:	88 d9                	mov    %bl,%cl
  801ab1:	d3 ed                	shr    %cl,%ebp
  801ab3:	89 e9                	mov    %ebp,%ecx
  801ab5:	09 f1                	or     %esi,%ecx
  801ab7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801abb:	89 f9                	mov    %edi,%ecx
  801abd:	d3 e0                	shl    %cl,%eax
  801abf:	89 c5                	mov    %eax,%ebp
  801ac1:	89 d6                	mov    %edx,%esi
  801ac3:	88 d9                	mov    %bl,%cl
  801ac5:	d3 ee                	shr    %cl,%esi
  801ac7:	89 f9                	mov    %edi,%ecx
  801ac9:	d3 e2                	shl    %cl,%edx
  801acb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801acf:	88 d9                	mov    %bl,%cl
  801ad1:	d3 e8                	shr    %cl,%eax
  801ad3:	09 c2                	or     %eax,%edx
  801ad5:	89 d0                	mov    %edx,%eax
  801ad7:	89 f2                	mov    %esi,%edx
  801ad9:	f7 74 24 0c          	divl   0xc(%esp)
  801add:	89 d6                	mov    %edx,%esi
  801adf:	89 c3                	mov    %eax,%ebx
  801ae1:	f7 e5                	mul    %ebp
  801ae3:	39 d6                	cmp    %edx,%esi
  801ae5:	72 19                	jb     801b00 <__udivdi3+0xfc>
  801ae7:	74 0b                	je     801af4 <__udivdi3+0xf0>
  801ae9:	89 d8                	mov    %ebx,%eax
  801aeb:	31 ff                	xor    %edi,%edi
  801aed:	e9 58 ff ff ff       	jmp    801a4a <__udivdi3+0x46>
  801af2:	66 90                	xchg   %ax,%ax
  801af4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801af8:	89 f9                	mov    %edi,%ecx
  801afa:	d3 e2                	shl    %cl,%edx
  801afc:	39 c2                	cmp    %eax,%edx
  801afe:	73 e9                	jae    801ae9 <__udivdi3+0xe5>
  801b00:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b03:	31 ff                	xor    %edi,%edi
  801b05:	e9 40 ff ff ff       	jmp    801a4a <__udivdi3+0x46>
  801b0a:	66 90                	xchg   %ax,%ax
  801b0c:	31 c0                	xor    %eax,%eax
  801b0e:	e9 37 ff ff ff       	jmp    801a4a <__udivdi3+0x46>
  801b13:	90                   	nop

00801b14 <__umoddi3>:
  801b14:	55                   	push   %ebp
  801b15:	57                   	push   %edi
  801b16:	56                   	push   %esi
  801b17:	53                   	push   %ebx
  801b18:	83 ec 1c             	sub    $0x1c,%esp
  801b1b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b27:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b2f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b33:	89 f3                	mov    %esi,%ebx
  801b35:	89 fa                	mov    %edi,%edx
  801b37:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b3b:	89 34 24             	mov    %esi,(%esp)
  801b3e:	85 c0                	test   %eax,%eax
  801b40:	75 1a                	jne    801b5c <__umoddi3+0x48>
  801b42:	39 f7                	cmp    %esi,%edi
  801b44:	0f 86 a2 00 00 00    	jbe    801bec <__umoddi3+0xd8>
  801b4a:	89 c8                	mov    %ecx,%eax
  801b4c:	89 f2                	mov    %esi,%edx
  801b4e:	f7 f7                	div    %edi
  801b50:	89 d0                	mov    %edx,%eax
  801b52:	31 d2                	xor    %edx,%edx
  801b54:	83 c4 1c             	add    $0x1c,%esp
  801b57:	5b                   	pop    %ebx
  801b58:	5e                   	pop    %esi
  801b59:	5f                   	pop    %edi
  801b5a:	5d                   	pop    %ebp
  801b5b:	c3                   	ret    
  801b5c:	39 f0                	cmp    %esi,%eax
  801b5e:	0f 87 ac 00 00 00    	ja     801c10 <__umoddi3+0xfc>
  801b64:	0f bd e8             	bsr    %eax,%ebp
  801b67:	83 f5 1f             	xor    $0x1f,%ebp
  801b6a:	0f 84 ac 00 00 00    	je     801c1c <__umoddi3+0x108>
  801b70:	bf 20 00 00 00       	mov    $0x20,%edi
  801b75:	29 ef                	sub    %ebp,%edi
  801b77:	89 fe                	mov    %edi,%esi
  801b79:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b7d:	89 e9                	mov    %ebp,%ecx
  801b7f:	d3 e0                	shl    %cl,%eax
  801b81:	89 d7                	mov    %edx,%edi
  801b83:	89 f1                	mov    %esi,%ecx
  801b85:	d3 ef                	shr    %cl,%edi
  801b87:	09 c7                	or     %eax,%edi
  801b89:	89 e9                	mov    %ebp,%ecx
  801b8b:	d3 e2                	shl    %cl,%edx
  801b8d:	89 14 24             	mov    %edx,(%esp)
  801b90:	89 d8                	mov    %ebx,%eax
  801b92:	d3 e0                	shl    %cl,%eax
  801b94:	89 c2                	mov    %eax,%edx
  801b96:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b9a:	d3 e0                	shl    %cl,%eax
  801b9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ba4:	89 f1                	mov    %esi,%ecx
  801ba6:	d3 e8                	shr    %cl,%eax
  801ba8:	09 d0                	or     %edx,%eax
  801baa:	d3 eb                	shr    %cl,%ebx
  801bac:	89 da                	mov    %ebx,%edx
  801bae:	f7 f7                	div    %edi
  801bb0:	89 d3                	mov    %edx,%ebx
  801bb2:	f7 24 24             	mull   (%esp)
  801bb5:	89 c6                	mov    %eax,%esi
  801bb7:	89 d1                	mov    %edx,%ecx
  801bb9:	39 d3                	cmp    %edx,%ebx
  801bbb:	0f 82 87 00 00 00    	jb     801c48 <__umoddi3+0x134>
  801bc1:	0f 84 91 00 00 00    	je     801c58 <__umoddi3+0x144>
  801bc7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bcb:	29 f2                	sub    %esi,%edx
  801bcd:	19 cb                	sbb    %ecx,%ebx
  801bcf:	89 d8                	mov    %ebx,%eax
  801bd1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bd5:	d3 e0                	shl    %cl,%eax
  801bd7:	89 e9                	mov    %ebp,%ecx
  801bd9:	d3 ea                	shr    %cl,%edx
  801bdb:	09 d0                	or     %edx,%eax
  801bdd:	89 e9                	mov    %ebp,%ecx
  801bdf:	d3 eb                	shr    %cl,%ebx
  801be1:	89 da                	mov    %ebx,%edx
  801be3:	83 c4 1c             	add    $0x1c,%esp
  801be6:	5b                   	pop    %ebx
  801be7:	5e                   	pop    %esi
  801be8:	5f                   	pop    %edi
  801be9:	5d                   	pop    %ebp
  801bea:	c3                   	ret    
  801beb:	90                   	nop
  801bec:	89 fd                	mov    %edi,%ebp
  801bee:	85 ff                	test   %edi,%edi
  801bf0:	75 0b                	jne    801bfd <__umoddi3+0xe9>
  801bf2:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf7:	31 d2                	xor    %edx,%edx
  801bf9:	f7 f7                	div    %edi
  801bfb:	89 c5                	mov    %eax,%ebp
  801bfd:	89 f0                	mov    %esi,%eax
  801bff:	31 d2                	xor    %edx,%edx
  801c01:	f7 f5                	div    %ebp
  801c03:	89 c8                	mov    %ecx,%eax
  801c05:	f7 f5                	div    %ebp
  801c07:	89 d0                	mov    %edx,%eax
  801c09:	e9 44 ff ff ff       	jmp    801b52 <__umoddi3+0x3e>
  801c0e:	66 90                	xchg   %ax,%ax
  801c10:	89 c8                	mov    %ecx,%eax
  801c12:	89 f2                	mov    %esi,%edx
  801c14:	83 c4 1c             	add    $0x1c,%esp
  801c17:	5b                   	pop    %ebx
  801c18:	5e                   	pop    %esi
  801c19:	5f                   	pop    %edi
  801c1a:	5d                   	pop    %ebp
  801c1b:	c3                   	ret    
  801c1c:	3b 04 24             	cmp    (%esp),%eax
  801c1f:	72 06                	jb     801c27 <__umoddi3+0x113>
  801c21:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c25:	77 0f                	ja     801c36 <__umoddi3+0x122>
  801c27:	89 f2                	mov    %esi,%edx
  801c29:	29 f9                	sub    %edi,%ecx
  801c2b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c2f:	89 14 24             	mov    %edx,(%esp)
  801c32:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c36:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c3a:	8b 14 24             	mov    (%esp),%edx
  801c3d:	83 c4 1c             	add    $0x1c,%esp
  801c40:	5b                   	pop    %ebx
  801c41:	5e                   	pop    %esi
  801c42:	5f                   	pop    %edi
  801c43:	5d                   	pop    %ebp
  801c44:	c3                   	ret    
  801c45:	8d 76 00             	lea    0x0(%esi),%esi
  801c48:	2b 04 24             	sub    (%esp),%eax
  801c4b:	19 fa                	sbb    %edi,%edx
  801c4d:	89 d1                	mov    %edx,%ecx
  801c4f:	89 c6                	mov    %eax,%esi
  801c51:	e9 71 ff ff ff       	jmp    801bc7 <__umoddi3+0xb3>
  801c56:	66 90                	xchg   %ax,%ax
  801c58:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c5c:	72 ea                	jb     801c48 <__umoddi3+0x134>
  801c5e:	89 d9                	mov    %ebx,%ecx
  801c60:	e9 62 ff ff ff       	jmp    801bc7 <__umoddi3+0xb3>

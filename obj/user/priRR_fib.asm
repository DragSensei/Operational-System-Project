
obj/user/priRR_fib:     file format elf32-i386


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
  800031:	e8 aa 00 00 00       	call   8000e0 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int fibonacci(int n);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	i1 = 38;
  800048:	c7 45 f4 26 00 00 00 	movl   $0x26,-0xc(%ebp)

	int res = fibonacci(i1) ;
  80004f:	83 ec 0c             	sub    $0xc,%esp
  800052:	ff 75 f4             	pushl  -0xc(%ebp)
  800055:	e8 47 00 00 00       	call   8000a1 <fibonacci>
  80005a:	83 c4 10             	add    $0x10,%esp
  80005d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("Fibonacci #%d = %d\n",i1, res);
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	ff 75 f0             	pushl  -0x10(%ebp)
  800066:	ff 75 f4             	pushl  -0xc(%ebp)
  800069:	68 60 1c 80 00       	push   $0x801c60
  80006e:	e8 5d 05 00 00       	call   8005d0 <atomic_cprintf>
  800073:	83 c4 10             	add    $0x10,%esp

	if (res != 63245986)
  800076:	81 7d f0 a2 0e c5 03 	cmpl   $0x3c50ea2,-0x10(%ebp)
  80007d:	74 1a                	je     800099 <_main+0x61>
		panic("[envID %d] wrong result!", myEnv->env_id);
  80007f:	a1 20 30 80 00       	mov    0x803020,%eax
  800084:	8b 40 10             	mov    0x10(%eax),%eax
  800087:	50                   	push   %eax
  800088:	68 74 1c 80 00       	push   $0x801c74
  80008d:	6a 13                	push   $0x13
  80008f:	68 8d 1c 80 00       	push   $0x801c8d
  800094:	e8 f7 01 00 00       	call   800290 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800099:	e8 cb 17 00 00       	call   801869 <inctst>

	return;
  80009e:	90                   	nop
}
  80009f:	c9                   	leave  
  8000a0:	c3                   	ret    

008000a1 <fibonacci>:


int fibonacci(int n)
{
  8000a1:	55                   	push   %ebp
  8000a2:	89 e5                	mov    %esp,%ebp
  8000a4:	53                   	push   %ebx
  8000a5:	83 ec 04             	sub    $0x4,%esp
	if (n <= 1)
  8000a8:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ac:	7f 07                	jg     8000b5 <fibonacci+0x14>
		return 1 ;
  8000ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b3:	eb 26                	jmp    8000db <fibonacci+0x3a>
	return fibonacci(n-1) + fibonacci(n-2) ;
  8000b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8000b8:	48                   	dec    %eax
  8000b9:	83 ec 0c             	sub    $0xc,%esp
  8000bc:	50                   	push   %eax
  8000bd:	e8 df ff ff ff       	call   8000a1 <fibonacci>
  8000c2:	83 c4 10             	add    $0x10,%esp
  8000c5:	89 c3                	mov    %eax,%ebx
  8000c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8000ca:	83 e8 02             	sub    $0x2,%eax
  8000cd:	83 ec 0c             	sub    $0xc,%esp
  8000d0:	50                   	push   %eax
  8000d1:	e8 cb ff ff ff       	call   8000a1 <fibonacci>
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	01 d8                	add    %ebx,%eax
}
  8000db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000de:	c9                   	leave  
  8000df:	c3                   	ret    

008000e0 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	57                   	push   %edi
  8000e4:	56                   	push   %esi
  8000e5:	53                   	push   %ebx
  8000e6:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000e9:	e8 3d 16 00 00       	call   80172b <sys_getenvindex>
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000f4:	89 d0                	mov    %edx,%eax
  8000f6:	c1 e0 02             	shl    $0x2,%eax
  8000f9:	01 d0                	add    %edx,%eax
  8000fb:	c1 e0 03             	shl    $0x3,%eax
  8000fe:	01 d0                	add    %edx,%eax
  800100:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800107:	01 d0                	add    %edx,%eax
  800109:	c1 e0 02             	shl    $0x2,%eax
  80010c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800111:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800116:	a1 20 30 80 00       	mov    0x803020,%eax
  80011b:	8a 40 20             	mov    0x20(%eax),%al
  80011e:	84 c0                	test   %al,%al
  800120:	74 0d                	je     80012f <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800122:	a1 20 30 80 00       	mov    0x803020,%eax
  800127:	83 c0 20             	add    $0x20,%eax
  80012a:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800133:	7e 0a                	jle    80013f <libmain+0x5f>
		binaryname = argv[0];
  800135:	8b 45 0c             	mov    0xc(%ebp),%eax
  800138:	8b 00                	mov    (%eax),%eax
  80013a:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80013f:	83 ec 08             	sub    $0x8,%esp
  800142:	ff 75 0c             	pushl  0xc(%ebp)
  800145:	ff 75 08             	pushl  0x8(%ebp)
  800148:	e8 eb fe ff ff       	call   800038 <_main>
  80014d:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800150:	a1 00 30 80 00       	mov    0x803000,%eax
  800155:	85 c0                	test   %eax,%eax
  800157:	0f 84 01 01 00 00    	je     80025e <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80015d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800163:	bb 98 1d 80 00       	mov    $0x801d98,%ebx
  800168:	ba 0e 00 00 00       	mov    $0xe,%edx
  80016d:	89 c7                	mov    %eax,%edi
  80016f:	89 de                	mov    %ebx,%esi
  800171:	89 d1                	mov    %edx,%ecx
  800173:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800175:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800178:	b9 56 00 00 00       	mov    $0x56,%ecx
  80017d:	b0 00                	mov    $0x0,%al
  80017f:	89 d7                	mov    %edx,%edi
  800181:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800183:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80018a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	50                   	push   %eax
  800191:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800197:	50                   	push   %eax
  800198:	e8 c4 17 00 00       	call   801961 <sys_utilities>
  80019d:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001a0:	e8 0d 13 00 00       	call   8014b2 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001a5:	83 ec 0c             	sub    $0xc,%esp
  8001a8:	68 b8 1c 80 00       	push   $0x801cb8
  8001ad:	e8 ac 03 00 00       	call   80055e <cprintf>
  8001b2:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001b8:	85 c0                	test   %eax,%eax
  8001ba:	74 18                	je     8001d4 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001bc:	e8 be 17 00 00       	call   80197f <sys_get_optimal_num_faults>
  8001c1:	83 ec 08             	sub    $0x8,%esp
  8001c4:	50                   	push   %eax
  8001c5:	68 e0 1c 80 00       	push   $0x801ce0
  8001ca:	e8 8f 03 00 00       	call   80055e <cprintf>
  8001cf:	83 c4 10             	add    $0x10,%esp
  8001d2:	eb 59                	jmp    80022d <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001d4:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d9:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8001df:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e4:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8001ea:	83 ec 04             	sub    $0x4,%esp
  8001ed:	52                   	push   %edx
  8001ee:	50                   	push   %eax
  8001ef:	68 04 1d 80 00       	push   $0x801d04
  8001f4:	e8 65 03 00 00       	call   80055e <cprintf>
  8001f9:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001fc:	a1 20 30 80 00       	mov    0x803020,%eax
  800201:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800207:	a1 20 30 80 00       	mov    0x803020,%eax
  80020c:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800212:	a1 20 30 80 00       	mov    0x803020,%eax
  800217:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80021d:	51                   	push   %ecx
  80021e:	52                   	push   %edx
  80021f:	50                   	push   %eax
  800220:	68 2c 1d 80 00       	push   $0x801d2c
  800225:	e8 34 03 00 00       	call   80055e <cprintf>
  80022a:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80022d:	a1 20 30 80 00       	mov    0x803020,%eax
  800232:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800238:	83 ec 08             	sub    $0x8,%esp
  80023b:	50                   	push   %eax
  80023c:	68 84 1d 80 00       	push   $0x801d84
  800241:	e8 18 03 00 00       	call   80055e <cprintf>
  800246:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800249:	83 ec 0c             	sub    $0xc,%esp
  80024c:	68 b8 1c 80 00       	push   $0x801cb8
  800251:	e8 08 03 00 00       	call   80055e <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800259:	e8 6e 12 00 00       	call   8014cc <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80025e:	e8 1f 00 00 00       	call   800282 <exit>
}
  800263:	90                   	nop
  800264:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800267:	5b                   	pop    %ebx
  800268:	5e                   	pop    %esi
  800269:	5f                   	pop    %edi
  80026a:	5d                   	pop    %ebp
  80026b:	c3                   	ret    

0080026c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	6a 00                	push   $0x0
  800277:	e8 7b 14 00 00       	call   8016f7 <sys_destroy_env>
  80027c:	83 c4 10             	add    $0x10,%esp
}
  80027f:	90                   	nop
  800280:	c9                   	leave  
  800281:	c3                   	ret    

00800282 <exit>:

void
exit(void)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800288:	e8 d0 14 00 00       	call   80175d <sys_exit_env>
}
  80028d:	90                   	nop
  80028e:	c9                   	leave  
  80028f:	c3                   	ret    

00800290 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800296:	8d 45 10             	lea    0x10(%ebp),%eax
  800299:	83 c0 04             	add    $0x4,%eax
  80029c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80029f:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002a4:	85 c0                	test   %eax,%eax
  8002a6:	74 16                	je     8002be <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002a8:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002ad:	83 ec 08             	sub    $0x8,%esp
  8002b0:	50                   	push   %eax
  8002b1:	68 fc 1d 80 00       	push   $0x801dfc
  8002b6:	e8 a3 02 00 00       	call   80055e <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8002be:	a1 04 30 80 00       	mov    0x803004,%eax
  8002c3:	83 ec 0c             	sub    $0xc,%esp
  8002c6:	ff 75 0c             	pushl  0xc(%ebp)
  8002c9:	ff 75 08             	pushl  0x8(%ebp)
  8002cc:	50                   	push   %eax
  8002cd:	68 04 1e 80 00       	push   $0x801e04
  8002d2:	6a 74                	push   $0x74
  8002d4:	e8 b2 02 00 00       	call   80058b <cprintf_colored>
  8002d9:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8002dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8002df:	83 ec 08             	sub    $0x8,%esp
  8002e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8002e5:	50                   	push   %eax
  8002e6:	e8 04 02 00 00       	call   8004ef <vcprintf>
  8002eb:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002ee:	83 ec 08             	sub    $0x8,%esp
  8002f1:	6a 00                	push   $0x0
  8002f3:	68 2c 1e 80 00       	push   $0x801e2c
  8002f8:	e8 f2 01 00 00       	call   8004ef <vcprintf>
  8002fd:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800300:	e8 7d ff ff ff       	call   800282 <exit>

	// should not return here
	while (1) ;
  800305:	eb fe                	jmp    800305 <_panic+0x75>

00800307 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80030d:	a1 20 30 80 00       	mov    0x803020,%eax
  800312:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800318:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031b:	39 c2                	cmp    %eax,%edx
  80031d:	74 14                	je     800333 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80031f:	83 ec 04             	sub    $0x4,%esp
  800322:	68 30 1e 80 00       	push   $0x801e30
  800327:	6a 26                	push   $0x26
  800329:	68 7c 1e 80 00       	push   $0x801e7c
  80032e:	e8 5d ff ff ff       	call   800290 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800333:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80033a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800341:	e9 c5 00 00 00       	jmp    80040b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800346:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800349:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800350:	8b 45 08             	mov    0x8(%ebp),%eax
  800353:	01 d0                	add    %edx,%eax
  800355:	8b 00                	mov    (%eax),%eax
  800357:	85 c0                	test   %eax,%eax
  800359:	75 08                	jne    800363 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80035b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80035e:	e9 a5 00 00 00       	jmp    800408 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800363:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80036a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800371:	eb 69                	jmp    8003dc <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800373:	a1 20 30 80 00       	mov    0x803020,%eax
  800378:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80037e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800381:	89 d0                	mov    %edx,%eax
  800383:	01 c0                	add    %eax,%eax
  800385:	01 d0                	add    %edx,%eax
  800387:	c1 e0 03             	shl    $0x3,%eax
  80038a:	01 c8                	add    %ecx,%eax
  80038c:	8a 40 04             	mov    0x4(%eax),%al
  80038f:	84 c0                	test   %al,%al
  800391:	75 46                	jne    8003d9 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800393:	a1 20 30 80 00       	mov    0x803020,%eax
  800398:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80039e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003a1:	89 d0                	mov    %edx,%eax
  8003a3:	01 c0                	add    %eax,%eax
  8003a5:	01 d0                	add    %edx,%eax
  8003a7:	c1 e0 03             	shl    $0x3,%eax
  8003aa:	01 c8                	add    %ecx,%eax
  8003ac:	8b 00                	mov    (%eax),%eax
  8003ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003b9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003be:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c8:	01 c8                	add    %ecx,%eax
  8003ca:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003cc:	39 c2                	cmp    %eax,%edx
  8003ce:	75 09                	jne    8003d9 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003d0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003d7:	eb 15                	jmp    8003ee <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d9:	ff 45 e8             	incl   -0x18(%ebp)
  8003dc:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ea:	39 c2                	cmp    %eax,%edx
  8003ec:	77 85                	ja     800373 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003f2:	75 14                	jne    800408 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003f4:	83 ec 04             	sub    $0x4,%esp
  8003f7:	68 88 1e 80 00       	push   $0x801e88
  8003fc:	6a 3a                	push   $0x3a
  8003fe:	68 7c 1e 80 00       	push   $0x801e7c
  800403:	e8 88 fe ff ff       	call   800290 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800408:	ff 45 f0             	incl   -0x10(%ebp)
  80040b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80040e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800411:	0f 8c 2f ff ff ff    	jl     800346 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800417:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80041e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800425:	eb 26                	jmp    80044d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800427:	a1 20 30 80 00       	mov    0x803020,%eax
  80042c:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800432:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800435:	89 d0                	mov    %edx,%eax
  800437:	01 c0                	add    %eax,%eax
  800439:	01 d0                	add    %edx,%eax
  80043b:	c1 e0 03             	shl    $0x3,%eax
  80043e:	01 c8                	add    %ecx,%eax
  800440:	8a 40 04             	mov    0x4(%eax),%al
  800443:	3c 01                	cmp    $0x1,%al
  800445:	75 03                	jne    80044a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800447:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80044a:	ff 45 e0             	incl   -0x20(%ebp)
  80044d:	a1 20 30 80 00       	mov    0x803020,%eax
  800452:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800458:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80045b:	39 c2                	cmp    %eax,%edx
  80045d:	77 c8                	ja     800427 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80045f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800462:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800465:	74 14                	je     80047b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800467:	83 ec 04             	sub    $0x4,%esp
  80046a:	68 dc 1e 80 00       	push   $0x801edc
  80046f:	6a 44                	push   $0x44
  800471:	68 7c 1e 80 00       	push   $0x801e7c
  800476:	e8 15 fe ff ff       	call   800290 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80047b:	90                   	nop
  80047c:	c9                   	leave  
  80047d:	c3                   	ret    

0080047e <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80047e:	55                   	push   %ebp
  80047f:	89 e5                	mov    %esp,%ebp
  800481:	53                   	push   %ebx
  800482:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800485:	8b 45 0c             	mov    0xc(%ebp),%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	8d 48 01             	lea    0x1(%eax),%ecx
  80048d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800490:	89 0a                	mov    %ecx,(%edx)
  800492:	8b 55 08             	mov    0x8(%ebp),%edx
  800495:	88 d1                	mov    %dl,%cl
  800497:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80049e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a1:	8b 00                	mov    (%eax),%eax
  8004a3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004a8:	75 30                	jne    8004da <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004aa:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004b0:	a0 44 30 80 00       	mov    0x803044,%al
  8004b5:	0f b6 c0             	movzbl %al,%eax
  8004b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004bb:	8b 09                	mov    (%ecx),%ecx
  8004bd:	89 cb                	mov    %ecx,%ebx
  8004bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004c2:	83 c1 08             	add    $0x8,%ecx
  8004c5:	52                   	push   %edx
  8004c6:	50                   	push   %eax
  8004c7:	53                   	push   %ebx
  8004c8:	51                   	push   %ecx
  8004c9:	e8 a0 0f 00 00       	call   80146e <sys_cputs>
  8004ce:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004dd:	8b 40 04             	mov    0x4(%eax),%eax
  8004e0:	8d 50 01             	lea    0x1(%eax),%edx
  8004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e6:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004e9:	90                   	nop
  8004ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004ed:	c9                   	leave  
  8004ee:	c3                   	ret    

008004ef <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004ef:	55                   	push   %ebp
  8004f0:	89 e5                	mov    %esp,%ebp
  8004f2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004f8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004ff:	00 00 00 
	b.cnt = 0;
  800502:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800509:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80050c:	ff 75 0c             	pushl  0xc(%ebp)
  80050f:	ff 75 08             	pushl  0x8(%ebp)
  800512:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800518:	50                   	push   %eax
  800519:	68 7e 04 80 00       	push   $0x80047e
  80051e:	e8 5a 02 00 00       	call   80077d <vprintfmt>
  800523:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800526:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80052c:	a0 44 30 80 00       	mov    0x803044,%al
  800531:	0f b6 c0             	movzbl %al,%eax
  800534:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80053a:	52                   	push   %edx
  80053b:	50                   	push   %eax
  80053c:	51                   	push   %ecx
  80053d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800543:	83 c0 08             	add    $0x8,%eax
  800546:	50                   	push   %eax
  800547:	e8 22 0f 00 00       	call   80146e <sys_cputs>
  80054c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80054f:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800556:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    

0080055e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800564:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80056b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800571:	8b 45 08             	mov    0x8(%ebp),%eax
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	ff 75 f4             	pushl  -0xc(%ebp)
  80057a:	50                   	push   %eax
  80057b:	e8 6f ff ff ff       	call   8004ef <vcprintf>
  800580:	83 c4 10             	add    $0x10,%esp
  800583:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800586:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800589:	c9                   	leave  
  80058a:	c3                   	ret    

0080058b <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80058b:	55                   	push   %ebp
  80058c:	89 e5                	mov    %esp,%ebp
  80058e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800591:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800598:	8b 45 08             	mov    0x8(%ebp),%eax
  80059b:	c1 e0 08             	shl    $0x8,%eax
  80059e:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8005a3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a6:	83 c0 04             	add    $0x4,%eax
  8005a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005af:	83 ec 08             	sub    $0x8,%esp
  8005b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b5:	50                   	push   %eax
  8005b6:	e8 34 ff ff ff       	call   8004ef <vcprintf>
  8005bb:	83 c4 10             	add    $0x10,%esp
  8005be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8005c1:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8005c8:	07 00 00 

	return cnt;
  8005cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005ce:	c9                   	leave  
  8005cf:	c3                   	ret    

008005d0 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8005d0:	55                   	push   %ebp
  8005d1:	89 e5                	mov    %esp,%ebp
  8005d3:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8005d6:	e8 d7 0e 00 00       	call   8014b2 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005db:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005de:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e4:	83 ec 08             	sub    $0x8,%esp
  8005e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ea:	50                   	push   %eax
  8005eb:	e8 ff fe ff ff       	call   8004ef <vcprintf>
  8005f0:	83 c4 10             	add    $0x10,%esp
  8005f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8005f6:	e8 d1 0e 00 00       	call   8014cc <sys_unlock_cons>
	return cnt;
  8005fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005fe:	c9                   	leave  
  8005ff:	c3                   	ret    

00800600 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800600:	55                   	push   %ebp
  800601:	89 e5                	mov    %esp,%ebp
  800603:	53                   	push   %ebx
  800604:	83 ec 14             	sub    $0x14,%esp
  800607:	8b 45 10             	mov    0x10(%ebp),%eax
  80060a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80060d:	8b 45 14             	mov    0x14(%ebp),%eax
  800610:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800613:	8b 45 18             	mov    0x18(%ebp),%eax
  800616:	ba 00 00 00 00       	mov    $0x0,%edx
  80061b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80061e:	77 55                	ja     800675 <printnum+0x75>
  800620:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800623:	72 05                	jb     80062a <printnum+0x2a>
  800625:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800628:	77 4b                	ja     800675 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80062a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80062d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800630:	8b 45 18             	mov    0x18(%ebp),%eax
  800633:	ba 00 00 00 00       	mov    $0x0,%edx
  800638:	52                   	push   %edx
  800639:	50                   	push   %eax
  80063a:	ff 75 f4             	pushl  -0xc(%ebp)
  80063d:	ff 75 f0             	pushl  -0x10(%ebp)
  800640:	e8 ab 13 00 00       	call   8019f0 <__udivdi3>
  800645:	83 c4 10             	add    $0x10,%esp
  800648:	83 ec 04             	sub    $0x4,%esp
  80064b:	ff 75 20             	pushl  0x20(%ebp)
  80064e:	53                   	push   %ebx
  80064f:	ff 75 18             	pushl  0x18(%ebp)
  800652:	52                   	push   %edx
  800653:	50                   	push   %eax
  800654:	ff 75 0c             	pushl  0xc(%ebp)
  800657:	ff 75 08             	pushl  0x8(%ebp)
  80065a:	e8 a1 ff ff ff       	call   800600 <printnum>
  80065f:	83 c4 20             	add    $0x20,%esp
  800662:	eb 1a                	jmp    80067e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800664:	83 ec 08             	sub    $0x8,%esp
  800667:	ff 75 0c             	pushl  0xc(%ebp)
  80066a:	ff 75 20             	pushl  0x20(%ebp)
  80066d:	8b 45 08             	mov    0x8(%ebp),%eax
  800670:	ff d0                	call   *%eax
  800672:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800675:	ff 4d 1c             	decl   0x1c(%ebp)
  800678:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80067c:	7f e6                	jg     800664 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80067e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800681:	bb 00 00 00 00       	mov    $0x0,%ebx
  800686:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800689:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80068c:	53                   	push   %ebx
  80068d:	51                   	push   %ecx
  80068e:	52                   	push   %edx
  80068f:	50                   	push   %eax
  800690:	e8 6b 14 00 00       	call   801b00 <__umoddi3>
  800695:	83 c4 10             	add    $0x10,%esp
  800698:	05 54 21 80 00       	add    $0x802154,%eax
  80069d:	8a 00                	mov    (%eax),%al
  80069f:	0f be c0             	movsbl %al,%eax
  8006a2:	83 ec 08             	sub    $0x8,%esp
  8006a5:	ff 75 0c             	pushl  0xc(%ebp)
  8006a8:	50                   	push   %eax
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	ff d0                	call   *%eax
  8006ae:	83 c4 10             	add    $0x10,%esp
}
  8006b1:	90                   	nop
  8006b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006b5:	c9                   	leave  
  8006b6:	c3                   	ret    

008006b7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006b7:	55                   	push   %ebp
  8006b8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006ba:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006be:	7e 1c                	jle    8006dc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	8d 50 08             	lea    0x8(%eax),%edx
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	89 10                	mov    %edx,(%eax)
  8006cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	83 e8 08             	sub    $0x8,%eax
  8006d5:	8b 50 04             	mov    0x4(%eax),%edx
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	eb 40                	jmp    80071c <getuint+0x65>
	else if (lflag)
  8006dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006e0:	74 1e                	je     800700 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	8d 50 04             	lea    0x4(%eax),%edx
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	89 10                	mov    %edx,(%eax)
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	83 e8 04             	sub    $0x4,%eax
  8006f7:	8b 00                	mov    (%eax),%eax
  8006f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fe:	eb 1c                	jmp    80071c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800700:	8b 45 08             	mov    0x8(%ebp),%eax
  800703:	8b 00                	mov    (%eax),%eax
  800705:	8d 50 04             	lea    0x4(%eax),%edx
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	89 10                	mov    %edx,(%eax)
  80070d:	8b 45 08             	mov    0x8(%ebp),%eax
  800710:	8b 00                	mov    (%eax),%eax
  800712:	83 e8 04             	sub    $0x4,%eax
  800715:	8b 00                	mov    (%eax),%eax
  800717:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80071c:	5d                   	pop    %ebp
  80071d:	c3                   	ret    

0080071e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800721:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800725:	7e 1c                	jle    800743 <getint+0x25>
		return va_arg(*ap, long long);
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	8b 00                	mov    (%eax),%eax
  80072c:	8d 50 08             	lea    0x8(%eax),%edx
  80072f:	8b 45 08             	mov    0x8(%ebp),%eax
  800732:	89 10                	mov    %edx,(%eax)
  800734:	8b 45 08             	mov    0x8(%ebp),%eax
  800737:	8b 00                	mov    (%eax),%eax
  800739:	83 e8 08             	sub    $0x8,%eax
  80073c:	8b 50 04             	mov    0x4(%eax),%edx
  80073f:	8b 00                	mov    (%eax),%eax
  800741:	eb 38                	jmp    80077b <getint+0x5d>
	else if (lflag)
  800743:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800747:	74 1a                	je     800763 <getint+0x45>
		return va_arg(*ap, long);
  800749:	8b 45 08             	mov    0x8(%ebp),%eax
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	8d 50 04             	lea    0x4(%eax),%edx
  800751:	8b 45 08             	mov    0x8(%ebp),%eax
  800754:	89 10                	mov    %edx,(%eax)
  800756:	8b 45 08             	mov    0x8(%ebp),%eax
  800759:	8b 00                	mov    (%eax),%eax
  80075b:	83 e8 04             	sub    $0x4,%eax
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	99                   	cltd   
  800761:	eb 18                	jmp    80077b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	8b 00                	mov    (%eax),%eax
  800768:	8d 50 04             	lea    0x4(%eax),%edx
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	89 10                	mov    %edx,(%eax)
  800770:	8b 45 08             	mov    0x8(%ebp),%eax
  800773:	8b 00                	mov    (%eax),%eax
  800775:	83 e8 04             	sub    $0x4,%eax
  800778:	8b 00                	mov    (%eax),%eax
  80077a:	99                   	cltd   
}
  80077b:	5d                   	pop    %ebp
  80077c:	c3                   	ret    

0080077d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80077d:	55                   	push   %ebp
  80077e:	89 e5                	mov    %esp,%ebp
  800780:	56                   	push   %esi
  800781:	53                   	push   %ebx
  800782:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800785:	eb 17                	jmp    80079e <vprintfmt+0x21>
			if (ch == '\0')
  800787:	85 db                	test   %ebx,%ebx
  800789:	0f 84 c1 03 00 00    	je     800b50 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80078f:	83 ec 08             	sub    $0x8,%esp
  800792:	ff 75 0c             	pushl  0xc(%ebp)
  800795:	53                   	push   %ebx
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	ff d0                	call   *%eax
  80079b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80079e:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a1:	8d 50 01             	lea    0x1(%eax),%edx
  8007a4:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a7:	8a 00                	mov    (%eax),%al
  8007a9:	0f b6 d8             	movzbl %al,%ebx
  8007ac:	83 fb 25             	cmp    $0x25,%ebx
  8007af:	75 d6                	jne    800787 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007b1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007b5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007bc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007c3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007ca:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d4:	8d 50 01             	lea    0x1(%eax),%edx
  8007d7:	89 55 10             	mov    %edx,0x10(%ebp)
  8007da:	8a 00                	mov    (%eax),%al
  8007dc:	0f b6 d8             	movzbl %al,%ebx
  8007df:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007e2:	83 f8 5b             	cmp    $0x5b,%eax
  8007e5:	0f 87 3d 03 00 00    	ja     800b28 <vprintfmt+0x3ab>
  8007eb:	8b 04 85 78 21 80 00 	mov    0x802178(,%eax,4),%eax
  8007f2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007f4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007f8:	eb d7                	jmp    8007d1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007fa:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007fe:	eb d1                	jmp    8007d1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800800:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800807:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80080a:	89 d0                	mov    %edx,%eax
  80080c:	c1 e0 02             	shl    $0x2,%eax
  80080f:	01 d0                	add    %edx,%eax
  800811:	01 c0                	add    %eax,%eax
  800813:	01 d8                	add    %ebx,%eax
  800815:	83 e8 30             	sub    $0x30,%eax
  800818:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80081b:	8b 45 10             	mov    0x10(%ebp),%eax
  80081e:	8a 00                	mov    (%eax),%al
  800820:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800823:	83 fb 2f             	cmp    $0x2f,%ebx
  800826:	7e 3e                	jle    800866 <vprintfmt+0xe9>
  800828:	83 fb 39             	cmp    $0x39,%ebx
  80082b:	7f 39                	jg     800866 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80082d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800830:	eb d5                	jmp    800807 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	83 c0 04             	add    $0x4,%eax
  800838:	89 45 14             	mov    %eax,0x14(%ebp)
  80083b:	8b 45 14             	mov    0x14(%ebp),%eax
  80083e:	83 e8 04             	sub    $0x4,%eax
  800841:	8b 00                	mov    (%eax),%eax
  800843:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800846:	eb 1f                	jmp    800867 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800848:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084c:	79 83                	jns    8007d1 <vprintfmt+0x54>
				width = 0;
  80084e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800855:	e9 77 ff ff ff       	jmp    8007d1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80085a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800861:	e9 6b ff ff ff       	jmp    8007d1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800866:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800867:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80086b:	0f 89 60 ff ff ff    	jns    8007d1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800871:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800874:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800877:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80087e:	e9 4e ff ff ff       	jmp    8007d1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800883:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800886:	e9 46 ff ff ff       	jmp    8007d1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80088b:	8b 45 14             	mov    0x14(%ebp),%eax
  80088e:	83 c0 04             	add    $0x4,%eax
  800891:	89 45 14             	mov    %eax,0x14(%ebp)
  800894:	8b 45 14             	mov    0x14(%ebp),%eax
  800897:	83 e8 04             	sub    $0x4,%eax
  80089a:	8b 00                	mov    (%eax),%eax
  80089c:	83 ec 08             	sub    $0x8,%esp
  80089f:	ff 75 0c             	pushl  0xc(%ebp)
  8008a2:	50                   	push   %eax
  8008a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a6:	ff d0                	call   *%eax
  8008a8:	83 c4 10             	add    $0x10,%esp
			break;
  8008ab:	e9 9b 02 00 00       	jmp    800b4b <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b3:	83 c0 04             	add    $0x4,%eax
  8008b6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bc:	83 e8 04             	sub    $0x4,%eax
  8008bf:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008c1:	85 db                	test   %ebx,%ebx
  8008c3:	79 02                	jns    8008c7 <vprintfmt+0x14a>
				err = -err;
  8008c5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008c7:	83 fb 64             	cmp    $0x64,%ebx
  8008ca:	7f 0b                	jg     8008d7 <vprintfmt+0x15a>
  8008cc:	8b 34 9d c0 1f 80 00 	mov    0x801fc0(,%ebx,4),%esi
  8008d3:	85 f6                	test   %esi,%esi
  8008d5:	75 19                	jne    8008f0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008d7:	53                   	push   %ebx
  8008d8:	68 65 21 80 00       	push   $0x802165
  8008dd:	ff 75 0c             	pushl  0xc(%ebp)
  8008e0:	ff 75 08             	pushl  0x8(%ebp)
  8008e3:	e8 70 02 00 00       	call   800b58 <printfmt>
  8008e8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008eb:	e9 5b 02 00 00       	jmp    800b4b <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008f0:	56                   	push   %esi
  8008f1:	68 6e 21 80 00       	push   $0x80216e
  8008f6:	ff 75 0c             	pushl  0xc(%ebp)
  8008f9:	ff 75 08             	pushl  0x8(%ebp)
  8008fc:	e8 57 02 00 00       	call   800b58 <printfmt>
  800901:	83 c4 10             	add    $0x10,%esp
			break;
  800904:	e9 42 02 00 00       	jmp    800b4b <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800909:	8b 45 14             	mov    0x14(%ebp),%eax
  80090c:	83 c0 04             	add    $0x4,%eax
  80090f:	89 45 14             	mov    %eax,0x14(%ebp)
  800912:	8b 45 14             	mov    0x14(%ebp),%eax
  800915:	83 e8 04             	sub    $0x4,%eax
  800918:	8b 30                	mov    (%eax),%esi
  80091a:	85 f6                	test   %esi,%esi
  80091c:	75 05                	jne    800923 <vprintfmt+0x1a6>
				p = "(null)";
  80091e:	be 71 21 80 00       	mov    $0x802171,%esi
			if (width > 0 && padc != '-')
  800923:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800927:	7e 6d                	jle    800996 <vprintfmt+0x219>
  800929:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80092d:	74 67                	je     800996 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80092f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800932:	83 ec 08             	sub    $0x8,%esp
  800935:	50                   	push   %eax
  800936:	56                   	push   %esi
  800937:	e8 1e 03 00 00       	call   800c5a <strnlen>
  80093c:	83 c4 10             	add    $0x10,%esp
  80093f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800942:	eb 16                	jmp    80095a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800944:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800948:	83 ec 08             	sub    $0x8,%esp
  80094b:	ff 75 0c             	pushl  0xc(%ebp)
  80094e:	50                   	push   %eax
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	ff d0                	call   *%eax
  800954:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800957:	ff 4d e4             	decl   -0x1c(%ebp)
  80095a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095e:	7f e4                	jg     800944 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800960:	eb 34                	jmp    800996 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800962:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800966:	74 1c                	je     800984 <vprintfmt+0x207>
  800968:	83 fb 1f             	cmp    $0x1f,%ebx
  80096b:	7e 05                	jle    800972 <vprintfmt+0x1f5>
  80096d:	83 fb 7e             	cmp    $0x7e,%ebx
  800970:	7e 12                	jle    800984 <vprintfmt+0x207>
					putch('?', putdat);
  800972:	83 ec 08             	sub    $0x8,%esp
  800975:	ff 75 0c             	pushl  0xc(%ebp)
  800978:	6a 3f                	push   $0x3f
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	ff d0                	call   *%eax
  80097f:	83 c4 10             	add    $0x10,%esp
  800982:	eb 0f                	jmp    800993 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800984:	83 ec 08             	sub    $0x8,%esp
  800987:	ff 75 0c             	pushl  0xc(%ebp)
  80098a:	53                   	push   %ebx
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	ff d0                	call   *%eax
  800990:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800993:	ff 4d e4             	decl   -0x1c(%ebp)
  800996:	89 f0                	mov    %esi,%eax
  800998:	8d 70 01             	lea    0x1(%eax),%esi
  80099b:	8a 00                	mov    (%eax),%al
  80099d:	0f be d8             	movsbl %al,%ebx
  8009a0:	85 db                	test   %ebx,%ebx
  8009a2:	74 24                	je     8009c8 <vprintfmt+0x24b>
  8009a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009a8:	78 b8                	js     800962 <vprintfmt+0x1e5>
  8009aa:	ff 4d e0             	decl   -0x20(%ebp)
  8009ad:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009b1:	79 af                	jns    800962 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009b3:	eb 13                	jmp    8009c8 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009b5:	83 ec 08             	sub    $0x8,%esp
  8009b8:	ff 75 0c             	pushl  0xc(%ebp)
  8009bb:	6a 20                	push   $0x20
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	ff d0                	call   *%eax
  8009c2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009c5:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009cc:	7f e7                	jg     8009b5 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009ce:	e9 78 01 00 00       	jmp    800b4b <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8009d9:	8d 45 14             	lea    0x14(%ebp),%eax
  8009dc:	50                   	push   %eax
  8009dd:	e8 3c fd ff ff       	call   80071e <getint>
  8009e2:	83 c4 10             	add    $0x10,%esp
  8009e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009f1:	85 d2                	test   %edx,%edx
  8009f3:	79 23                	jns    800a18 <vprintfmt+0x29b>
				putch('-', putdat);
  8009f5:	83 ec 08             	sub    $0x8,%esp
  8009f8:	ff 75 0c             	pushl  0xc(%ebp)
  8009fb:	6a 2d                	push   $0x2d
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	ff d0                	call   *%eax
  800a02:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a0b:	f7 d8                	neg    %eax
  800a0d:	83 d2 00             	adc    $0x0,%edx
  800a10:	f7 da                	neg    %edx
  800a12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a15:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a18:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a1f:	e9 bc 00 00 00       	jmp    800ae0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a24:	83 ec 08             	sub    $0x8,%esp
  800a27:	ff 75 e8             	pushl  -0x18(%ebp)
  800a2a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a2d:	50                   	push   %eax
  800a2e:	e8 84 fc ff ff       	call   8006b7 <getuint>
  800a33:	83 c4 10             	add    $0x10,%esp
  800a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a39:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a3c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a43:	e9 98 00 00 00       	jmp    800ae0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a48:	83 ec 08             	sub    $0x8,%esp
  800a4b:	ff 75 0c             	pushl  0xc(%ebp)
  800a4e:	6a 58                	push   $0x58
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	ff d0                	call   *%eax
  800a55:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a58:	83 ec 08             	sub    $0x8,%esp
  800a5b:	ff 75 0c             	pushl  0xc(%ebp)
  800a5e:	6a 58                	push   $0x58
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	ff d0                	call   *%eax
  800a65:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	ff 75 0c             	pushl  0xc(%ebp)
  800a6e:	6a 58                	push   $0x58
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	ff d0                	call   *%eax
  800a75:	83 c4 10             	add    $0x10,%esp
			break;
  800a78:	e9 ce 00 00 00       	jmp    800b4b <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a7d:	83 ec 08             	sub    $0x8,%esp
  800a80:	ff 75 0c             	pushl  0xc(%ebp)
  800a83:	6a 30                	push   $0x30
  800a85:	8b 45 08             	mov    0x8(%ebp),%eax
  800a88:	ff d0                	call   *%eax
  800a8a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a8d:	83 ec 08             	sub    $0x8,%esp
  800a90:	ff 75 0c             	pushl  0xc(%ebp)
  800a93:	6a 78                	push   $0x78
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	ff d0                	call   *%eax
  800a9a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa0:	83 c0 04             	add    $0x4,%eax
  800aa3:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa6:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa9:	83 e8 04             	sub    $0x4,%eax
  800aac:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800aae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ab8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800abf:	eb 1f                	jmp    800ae0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ac1:	83 ec 08             	sub    $0x8,%esp
  800ac4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ac7:	8d 45 14             	lea    0x14(%ebp),%eax
  800aca:	50                   	push   %eax
  800acb:	e8 e7 fb ff ff       	call   8006b7 <getuint>
  800ad0:	83 c4 10             	add    $0x10,%esp
  800ad3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ad9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ae0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ae4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ae7:	83 ec 04             	sub    $0x4,%esp
  800aea:	52                   	push   %edx
  800aeb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800aee:	50                   	push   %eax
  800aef:	ff 75 f4             	pushl  -0xc(%ebp)
  800af2:	ff 75 f0             	pushl  -0x10(%ebp)
  800af5:	ff 75 0c             	pushl  0xc(%ebp)
  800af8:	ff 75 08             	pushl  0x8(%ebp)
  800afb:	e8 00 fb ff ff       	call   800600 <printnum>
  800b00:	83 c4 20             	add    $0x20,%esp
			break;
  800b03:	eb 46                	jmp    800b4b <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b05:	83 ec 08             	sub    $0x8,%esp
  800b08:	ff 75 0c             	pushl  0xc(%ebp)
  800b0b:	53                   	push   %ebx
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	ff d0                	call   *%eax
  800b11:	83 c4 10             	add    $0x10,%esp
			break;
  800b14:	eb 35                	jmp    800b4b <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b16:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b1d:	eb 2c                	jmp    800b4b <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b1f:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b26:	eb 23                	jmp    800b4b <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b28:	83 ec 08             	sub    $0x8,%esp
  800b2b:	ff 75 0c             	pushl  0xc(%ebp)
  800b2e:	6a 25                	push   $0x25
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	ff d0                	call   *%eax
  800b35:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b38:	ff 4d 10             	decl   0x10(%ebp)
  800b3b:	eb 03                	jmp    800b40 <vprintfmt+0x3c3>
  800b3d:	ff 4d 10             	decl   0x10(%ebp)
  800b40:	8b 45 10             	mov    0x10(%ebp),%eax
  800b43:	48                   	dec    %eax
  800b44:	8a 00                	mov    (%eax),%al
  800b46:	3c 25                	cmp    $0x25,%al
  800b48:	75 f3                	jne    800b3d <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b4a:	90                   	nop
		}
	}
  800b4b:	e9 35 fc ff ff       	jmp    800785 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b50:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b51:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b54:	5b                   	pop    %ebx
  800b55:	5e                   	pop    %esi
  800b56:	5d                   	pop    %ebp
  800b57:	c3                   	ret    

00800b58 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b5e:	8d 45 10             	lea    0x10(%ebp),%eax
  800b61:	83 c0 04             	add    $0x4,%eax
  800b64:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b67:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6d:	50                   	push   %eax
  800b6e:	ff 75 0c             	pushl  0xc(%ebp)
  800b71:	ff 75 08             	pushl  0x8(%ebp)
  800b74:	e8 04 fc ff ff       	call   80077d <vprintfmt>
  800b79:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b7c:	90                   	nop
  800b7d:	c9                   	leave  
  800b7e:	c3                   	ret    

00800b7f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b7f:	55                   	push   %ebp
  800b80:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b85:	8b 40 08             	mov    0x8(%eax),%eax
  800b88:	8d 50 01             	lea    0x1(%eax),%edx
  800b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b94:	8b 10                	mov    (%eax),%edx
  800b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b99:	8b 40 04             	mov    0x4(%eax),%eax
  800b9c:	39 c2                	cmp    %eax,%edx
  800b9e:	73 12                	jae    800bb2 <sprintputch+0x33>
		*b->buf++ = ch;
  800ba0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba3:	8b 00                	mov    (%eax),%eax
  800ba5:	8d 48 01             	lea    0x1(%eax),%ecx
  800ba8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bab:	89 0a                	mov    %ecx,(%edx)
  800bad:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb0:	88 10                	mov    %dl,(%eax)
}
  800bb2:	90                   	nop
  800bb3:	5d                   	pop    %ebp
  800bb4:	c3                   	ret    

00800bb5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	01 d0                	add    %edx,%eax
  800bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bd6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bda:	74 06                	je     800be2 <vsnprintf+0x2d>
  800bdc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be0:	7f 07                	jg     800be9 <vsnprintf+0x34>
		return -E_INVAL;
  800be2:	b8 03 00 00 00       	mov    $0x3,%eax
  800be7:	eb 20                	jmp    800c09 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800be9:	ff 75 14             	pushl  0x14(%ebp)
  800bec:	ff 75 10             	pushl  0x10(%ebp)
  800bef:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bf2:	50                   	push   %eax
  800bf3:	68 7f 0b 80 00       	push   $0x800b7f
  800bf8:	e8 80 fb ff ff       	call   80077d <vprintfmt>
  800bfd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c03:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c09:	c9                   	leave  
  800c0a:	c3                   	ret    

00800c0b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c11:	8d 45 10             	lea    0x10(%ebp),%eax
  800c14:	83 c0 04             	add    $0x4,%eax
  800c17:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c1a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c20:	50                   	push   %eax
  800c21:	ff 75 0c             	pushl  0xc(%ebp)
  800c24:	ff 75 08             	pushl  0x8(%ebp)
  800c27:	e8 89 ff ff ff       	call   800bb5 <vsnprintf>
  800c2c:	83 c4 10             	add    $0x10,%esp
  800c2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c35:	c9                   	leave  
  800c36:	c3                   	ret    

00800c37 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c44:	eb 06                	jmp    800c4c <strlen+0x15>
		n++;
  800c46:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c49:	ff 45 08             	incl   0x8(%ebp)
  800c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4f:	8a 00                	mov    (%eax),%al
  800c51:	84 c0                	test   %al,%al
  800c53:	75 f1                	jne    800c46 <strlen+0xf>
		n++;
	return n;
  800c55:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c58:	c9                   	leave  
  800c59:	c3                   	ret    

00800c5a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c67:	eb 09                	jmp    800c72 <strnlen+0x18>
		n++;
  800c69:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c6c:	ff 45 08             	incl   0x8(%ebp)
  800c6f:	ff 4d 0c             	decl   0xc(%ebp)
  800c72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c76:	74 09                	je     800c81 <strnlen+0x27>
  800c78:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7b:	8a 00                	mov    (%eax),%al
  800c7d:	84 c0                	test   %al,%al
  800c7f:	75 e8                	jne    800c69 <strnlen+0xf>
		n++;
	return n;
  800c81:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c84:	c9                   	leave  
  800c85:	c3                   	ret    

00800c86 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c92:	90                   	nop
  800c93:	8b 45 08             	mov    0x8(%ebp),%eax
  800c96:	8d 50 01             	lea    0x1(%eax),%edx
  800c99:	89 55 08             	mov    %edx,0x8(%ebp)
  800c9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ca2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ca5:	8a 12                	mov    (%edx),%dl
  800ca7:	88 10                	mov    %dl,(%eax)
  800ca9:	8a 00                	mov    (%eax),%al
  800cab:	84 c0                	test   %al,%al
  800cad:	75 e4                	jne    800c93 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800caf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb2:	c9                   	leave  
  800cb3:	c3                   	ret    

00800cb4 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cc0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cc7:	eb 1f                	jmp    800ce8 <strncpy+0x34>
		*dst++ = *src;
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	8d 50 01             	lea    0x1(%eax),%edx
  800ccf:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd5:	8a 12                	mov    (%edx),%dl
  800cd7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdc:	8a 00                	mov    (%eax),%al
  800cde:	84 c0                	test   %al,%al
  800ce0:	74 03                	je     800ce5 <strncpy+0x31>
			src++;
  800ce2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ce5:	ff 45 fc             	incl   -0x4(%ebp)
  800ce8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ceb:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cee:	72 d9                	jb     800cc9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cf0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cf3:	c9                   	leave  
  800cf4:	c3                   	ret    

00800cf5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
  800cf8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d05:	74 30                	je     800d37 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d07:	eb 16                	jmp    800d1f <strlcpy+0x2a>
			*dst++ = *src++;
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	8d 50 01             	lea    0x1(%eax),%edx
  800d0f:	89 55 08             	mov    %edx,0x8(%ebp)
  800d12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d15:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d18:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d1b:	8a 12                	mov    (%edx),%dl
  800d1d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d1f:	ff 4d 10             	decl   0x10(%ebp)
  800d22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d26:	74 09                	je     800d31 <strlcpy+0x3c>
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	8a 00                	mov    (%eax),%al
  800d2d:	84 c0                	test   %al,%al
  800d2f:	75 d8                	jne    800d09 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d37:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d3d:	29 c2                	sub    %eax,%edx
  800d3f:	89 d0                	mov    %edx,%eax
}
  800d41:	c9                   	leave  
  800d42:	c3                   	ret    

00800d43 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d46:	eb 06                	jmp    800d4e <strcmp+0xb>
		p++, q++;
  800d48:	ff 45 08             	incl   0x8(%ebp)
  800d4b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	84 c0                	test   %al,%al
  800d55:	74 0e                	je     800d65 <strcmp+0x22>
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	8a 10                	mov    (%eax),%dl
  800d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	38 c2                	cmp    %al,%dl
  800d63:	74 e3                	je     800d48 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8a 00                	mov    (%eax),%al
  800d6a:	0f b6 d0             	movzbl %al,%edx
  800d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d70:	8a 00                	mov    (%eax),%al
  800d72:	0f b6 c0             	movzbl %al,%eax
  800d75:	29 c2                	sub    %eax,%edx
  800d77:	89 d0                	mov    %edx,%eax
}
  800d79:	5d                   	pop    %ebp
  800d7a:	c3                   	ret    

00800d7b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d7e:	eb 09                	jmp    800d89 <strncmp+0xe>
		n--, p++, q++;
  800d80:	ff 4d 10             	decl   0x10(%ebp)
  800d83:	ff 45 08             	incl   0x8(%ebp)
  800d86:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d8d:	74 17                	je     800da6 <strncmp+0x2b>
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	8a 00                	mov    (%eax),%al
  800d94:	84 c0                	test   %al,%al
  800d96:	74 0e                	je     800da6 <strncmp+0x2b>
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	8a 10                	mov    (%eax),%dl
  800d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da0:	8a 00                	mov    (%eax),%al
  800da2:	38 c2                	cmp    %al,%dl
  800da4:	74 da                	je     800d80 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800da6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800daa:	75 07                	jne    800db3 <strncmp+0x38>
		return 0;
  800dac:	b8 00 00 00 00       	mov    $0x0,%eax
  800db1:	eb 14                	jmp    800dc7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	8a 00                	mov    (%eax),%al
  800db8:	0f b6 d0             	movzbl %al,%edx
  800dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbe:	8a 00                	mov    (%eax),%al
  800dc0:	0f b6 c0             	movzbl %al,%eax
  800dc3:	29 c2                	sub    %eax,%edx
  800dc5:	89 d0                	mov    %edx,%eax
}
  800dc7:	5d                   	pop    %ebp
  800dc8:	c3                   	ret    

00800dc9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	83 ec 04             	sub    $0x4,%esp
  800dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dd5:	eb 12                	jmp    800de9 <strchr+0x20>
		if (*s == c)
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	8a 00                	mov    (%eax),%al
  800ddc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ddf:	75 05                	jne    800de6 <strchr+0x1d>
			return (char *) s;
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	eb 11                	jmp    800df7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800de6:	ff 45 08             	incl   0x8(%ebp)
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dec:	8a 00                	mov    (%eax),%al
  800dee:	84 c0                	test   %al,%al
  800df0:	75 e5                	jne    800dd7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800df2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800df7:	c9                   	leave  
  800df8:	c3                   	ret    

00800df9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	83 ec 04             	sub    $0x4,%esp
  800dff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e02:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e05:	eb 0d                	jmp    800e14 <strfind+0x1b>
		if (*s == c)
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8a 00                	mov    (%eax),%al
  800e0c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e0f:	74 0e                	je     800e1f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e11:	ff 45 08             	incl   0x8(%ebp)
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	8a 00                	mov    (%eax),%al
  800e19:	84 c0                	test   %al,%al
  800e1b:	75 ea                	jne    800e07 <strfind+0xe>
  800e1d:	eb 01                	jmp    800e20 <strfind+0x27>
		if (*s == c)
			break;
  800e1f:	90                   	nop
	return (char *) s;
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e23:	c9                   	leave  
  800e24:	c3                   	ret    

00800e25 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e31:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e35:	76 63                	jbe    800e9a <memset+0x75>
		uint64 data_block = c;
  800e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3a:	99                   	cltd   
  800e3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e3e:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e47:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e4b:	c1 e0 08             	shl    $0x8,%eax
  800e4e:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e51:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e5a:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e5e:	c1 e0 10             	shl    $0x10,%eax
  800e61:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e64:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e6d:	89 c2                	mov    %eax,%edx
  800e6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e74:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e77:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e7a:	eb 18                	jmp    800e94 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e7c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e7f:	8d 41 08             	lea    0x8(%ecx),%eax
  800e82:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e8b:	89 01                	mov    %eax,(%ecx)
  800e8d:	89 51 04             	mov    %edx,0x4(%ecx)
  800e90:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e94:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e98:	77 e2                	ja     800e7c <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9e:	74 23                	je     800ec3 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800ea0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ea6:	eb 0e                	jmp    800eb6 <memset+0x91>
			*p8++ = (uint8)c;
  800ea8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eab:	8d 50 01             	lea    0x1(%eax),%edx
  800eae:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb4:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800eb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebc:	89 55 10             	mov    %edx,0x10(%ebp)
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	75 e5                	jne    800ea8 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec6:	c9                   	leave  
  800ec7:	c3                   	ret    

00800ec8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ec8:	55                   	push   %ebp
  800ec9:	89 e5                	mov    %esp,%ebp
  800ecb:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800eda:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ede:	76 24                	jbe    800f04 <memcpy+0x3c>
		while(n >= 8){
  800ee0:	eb 1c                	jmp    800efe <memcpy+0x36>
			*d64 = *s64;
  800ee2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee5:	8b 50 04             	mov    0x4(%eax),%edx
  800ee8:	8b 00                	mov    (%eax),%eax
  800eea:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800eed:	89 01                	mov    %eax,(%ecx)
  800eef:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800ef2:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800ef6:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800efa:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800efe:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f02:	77 de                	ja     800ee2 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f04:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f08:	74 31                	je     800f3b <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f10:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f13:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f16:	eb 16                	jmp    800f2e <memcpy+0x66>
			*d8++ = *s8++;
  800f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f1b:	8d 50 01             	lea    0x1(%eax),%edx
  800f1e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f24:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f27:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f2a:	8a 12                	mov    (%edx),%dl
  800f2c:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f34:	89 55 10             	mov    %edx,0x10(%ebp)
  800f37:	85 c0                	test   %eax,%eax
  800f39:	75 dd                	jne    800f18 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3e:	c9                   	leave  
  800f3f:	c3                   	ret    

00800f40 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f55:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f58:	73 50                	jae    800faa <memmove+0x6a>
  800f5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f60:	01 d0                	add    %edx,%eax
  800f62:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f65:	76 43                	jbe    800faa <memmove+0x6a>
		s += n;
  800f67:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f70:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f73:	eb 10                	jmp    800f85 <memmove+0x45>
			*--d = *--s;
  800f75:	ff 4d f8             	decl   -0x8(%ebp)
  800f78:	ff 4d fc             	decl   -0x4(%ebp)
  800f7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f7e:	8a 10                	mov    (%eax),%dl
  800f80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f83:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f85:	8b 45 10             	mov    0x10(%ebp),%eax
  800f88:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f8b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f8e:	85 c0                	test   %eax,%eax
  800f90:	75 e3                	jne    800f75 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f92:	eb 23                	jmp    800fb7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f97:	8d 50 01             	lea    0x1(%eax),%edx
  800f9a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f9d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fa3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fa6:	8a 12                	mov    (%edx),%dl
  800fa8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800faa:	8b 45 10             	mov    0x10(%ebp),%eax
  800fad:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb0:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb3:	85 c0                	test   %eax,%eax
  800fb5:	75 dd                	jne    800f94 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fba:	c9                   	leave  
  800fbb:	c3                   	ret    

00800fbc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcb:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fce:	eb 2a                	jmp    800ffa <memcmp+0x3e>
		if (*s1 != *s2)
  800fd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd3:	8a 10                	mov    (%eax),%dl
  800fd5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	38 c2                	cmp    %al,%dl
  800fdc:	74 16                	je     800ff4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fde:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	0f b6 d0             	movzbl %al,%edx
  800fe6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	0f b6 c0             	movzbl %al,%eax
  800fee:	29 c2                	sub    %eax,%edx
  800ff0:	89 d0                	mov    %edx,%eax
  800ff2:	eb 18                	jmp    80100c <memcmp+0x50>
		s1++, s2++;
  800ff4:	ff 45 fc             	incl   -0x4(%ebp)
  800ff7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffd:	8d 50 ff             	lea    -0x1(%eax),%edx
  801000:	89 55 10             	mov    %edx,0x10(%ebp)
  801003:	85 c0                	test   %eax,%eax
  801005:	75 c9                	jne    800fd0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801007:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80100c:	c9                   	leave  
  80100d:	c3                   	ret    

0080100e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80100e:	55                   	push   %ebp
  80100f:	89 e5                	mov    %esp,%ebp
  801011:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801014:	8b 55 08             	mov    0x8(%ebp),%edx
  801017:	8b 45 10             	mov    0x10(%ebp),%eax
  80101a:	01 d0                	add    %edx,%eax
  80101c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80101f:	eb 15                	jmp    801036 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
  801024:	8a 00                	mov    (%eax),%al
  801026:	0f b6 d0             	movzbl %al,%edx
  801029:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102c:	0f b6 c0             	movzbl %al,%eax
  80102f:	39 c2                	cmp    %eax,%edx
  801031:	74 0d                	je     801040 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801033:	ff 45 08             	incl   0x8(%ebp)
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80103c:	72 e3                	jb     801021 <memfind+0x13>
  80103e:	eb 01                	jmp    801041 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801040:	90                   	nop
	return (void *) s;
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801044:	c9                   	leave  
  801045:	c3                   	ret    

00801046 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80104c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801053:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80105a:	eb 03                	jmp    80105f <strtol+0x19>
		s++;
  80105c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	8a 00                	mov    (%eax),%al
  801064:	3c 20                	cmp    $0x20,%al
  801066:	74 f4                	je     80105c <strtol+0x16>
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
  80106b:	8a 00                	mov    (%eax),%al
  80106d:	3c 09                	cmp    $0x9,%al
  80106f:	74 eb                	je     80105c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	8a 00                	mov    (%eax),%al
  801076:	3c 2b                	cmp    $0x2b,%al
  801078:	75 05                	jne    80107f <strtol+0x39>
		s++;
  80107a:	ff 45 08             	incl   0x8(%ebp)
  80107d:	eb 13                	jmp    801092 <strtol+0x4c>
	else if (*s == '-')
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	8a 00                	mov    (%eax),%al
  801084:	3c 2d                	cmp    $0x2d,%al
  801086:	75 0a                	jne    801092 <strtol+0x4c>
		s++, neg = 1;
  801088:	ff 45 08             	incl   0x8(%ebp)
  80108b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801092:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801096:	74 06                	je     80109e <strtol+0x58>
  801098:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80109c:	75 20                	jne    8010be <strtol+0x78>
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8a 00                	mov    (%eax),%al
  8010a3:	3c 30                	cmp    $0x30,%al
  8010a5:	75 17                	jne    8010be <strtol+0x78>
  8010a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010aa:	40                   	inc    %eax
  8010ab:	8a 00                	mov    (%eax),%al
  8010ad:	3c 78                	cmp    $0x78,%al
  8010af:	75 0d                	jne    8010be <strtol+0x78>
		s += 2, base = 16;
  8010b1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010b5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010bc:	eb 28                	jmp    8010e6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010c2:	75 15                	jne    8010d9 <strtol+0x93>
  8010c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c7:	8a 00                	mov    (%eax),%al
  8010c9:	3c 30                	cmp    $0x30,%al
  8010cb:	75 0c                	jne    8010d9 <strtol+0x93>
		s++, base = 8;
  8010cd:	ff 45 08             	incl   0x8(%ebp)
  8010d0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010d7:	eb 0d                	jmp    8010e6 <strtol+0xa0>
	else if (base == 0)
  8010d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010dd:	75 07                	jne    8010e6 <strtol+0xa0>
		base = 10;
  8010df:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	3c 2f                	cmp    $0x2f,%al
  8010ed:	7e 19                	jle    801108 <strtol+0xc2>
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	8a 00                	mov    (%eax),%al
  8010f4:	3c 39                	cmp    $0x39,%al
  8010f6:	7f 10                	jg     801108 <strtol+0xc2>
			dig = *s - '0';
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	8a 00                	mov    (%eax),%al
  8010fd:	0f be c0             	movsbl %al,%eax
  801100:	83 e8 30             	sub    $0x30,%eax
  801103:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801106:	eb 42                	jmp    80114a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	3c 60                	cmp    $0x60,%al
  80110f:	7e 19                	jle    80112a <strtol+0xe4>
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	8a 00                	mov    (%eax),%al
  801116:	3c 7a                	cmp    $0x7a,%al
  801118:	7f 10                	jg     80112a <strtol+0xe4>
			dig = *s - 'a' + 10;
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
  80111d:	8a 00                	mov    (%eax),%al
  80111f:	0f be c0             	movsbl %al,%eax
  801122:	83 e8 57             	sub    $0x57,%eax
  801125:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801128:	eb 20                	jmp    80114a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	3c 40                	cmp    $0x40,%al
  801131:	7e 39                	jle    80116c <strtol+0x126>
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	3c 5a                	cmp    $0x5a,%al
  80113a:	7f 30                	jg     80116c <strtol+0x126>
			dig = *s - 'A' + 10;
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	0f be c0             	movsbl %al,%eax
  801144:	83 e8 37             	sub    $0x37,%eax
  801147:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80114a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80114d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801150:	7d 19                	jge    80116b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801152:	ff 45 08             	incl   0x8(%ebp)
  801155:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801158:	0f af 45 10          	imul   0x10(%ebp),%eax
  80115c:	89 c2                	mov    %eax,%edx
  80115e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801161:	01 d0                	add    %edx,%eax
  801163:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801166:	e9 7b ff ff ff       	jmp    8010e6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80116b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80116c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801170:	74 08                	je     80117a <strtol+0x134>
		*endptr = (char *) s;
  801172:	8b 45 0c             	mov    0xc(%ebp),%eax
  801175:	8b 55 08             	mov    0x8(%ebp),%edx
  801178:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80117a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80117e:	74 07                	je     801187 <strtol+0x141>
  801180:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801183:	f7 d8                	neg    %eax
  801185:	eb 03                	jmp    80118a <strtol+0x144>
  801187:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80118a:	c9                   	leave  
  80118b:	c3                   	ret    

0080118c <ltostr>:

void
ltostr(long value, char *str)
{
  80118c:	55                   	push   %ebp
  80118d:	89 e5                	mov    %esp,%ebp
  80118f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801192:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801199:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011a4:	79 13                	jns    8011b9 <ltostr+0x2d>
	{
		neg = 1;
  8011a6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011b3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011b6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011c1:	99                   	cltd   
  8011c2:	f7 f9                	idiv   %ecx
  8011c4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ca:	8d 50 01             	lea    0x1(%eax),%edx
  8011cd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011d0:	89 c2                	mov    %eax,%edx
  8011d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d5:	01 d0                	add    %edx,%eax
  8011d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011da:	83 c2 30             	add    $0x30,%edx
  8011dd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011e2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011e7:	f7 e9                	imul   %ecx
  8011e9:	c1 fa 02             	sar    $0x2,%edx
  8011ec:	89 c8                	mov    %ecx,%eax
  8011ee:	c1 f8 1f             	sar    $0x1f,%eax
  8011f1:	29 c2                	sub    %eax,%edx
  8011f3:	89 d0                	mov    %edx,%eax
  8011f5:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8011f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011fc:	75 bb                	jne    8011b9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801205:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801208:	48                   	dec    %eax
  801209:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80120c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801210:	74 3d                	je     80124f <ltostr+0xc3>
		start = 1 ;
  801212:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801219:	eb 34                	jmp    80124f <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80121b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80121e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801221:	01 d0                	add    %edx,%eax
  801223:	8a 00                	mov    (%eax),%al
  801225:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801228:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122e:	01 c2                	add    %eax,%edx
  801230:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801233:	8b 45 0c             	mov    0xc(%ebp),%eax
  801236:	01 c8                	add    %ecx,%eax
  801238:	8a 00                	mov    (%eax),%al
  80123a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80123c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80123f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801242:	01 c2                	add    %eax,%edx
  801244:	8a 45 eb             	mov    -0x15(%ebp),%al
  801247:	88 02                	mov    %al,(%edx)
		start++ ;
  801249:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80124c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80124f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801252:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801255:	7c c4                	jl     80121b <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801257:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80125a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125d:	01 d0                	add    %edx,%eax
  80125f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801262:	90                   	nop
  801263:	c9                   	leave  
  801264:	c3                   	ret    

00801265 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
  801268:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80126b:	ff 75 08             	pushl  0x8(%ebp)
  80126e:	e8 c4 f9 ff ff       	call   800c37 <strlen>
  801273:	83 c4 04             	add    $0x4,%esp
  801276:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801279:	ff 75 0c             	pushl  0xc(%ebp)
  80127c:	e8 b6 f9 ff ff       	call   800c37 <strlen>
  801281:	83 c4 04             	add    $0x4,%esp
  801284:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801287:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80128e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801295:	eb 17                	jmp    8012ae <strcconcat+0x49>
		final[s] = str1[s] ;
  801297:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80129a:	8b 45 10             	mov    0x10(%ebp),%eax
  80129d:	01 c2                	add    %eax,%edx
  80129f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	01 c8                	add    %ecx,%eax
  8012a7:	8a 00                	mov    (%eax),%al
  8012a9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012ab:	ff 45 fc             	incl   -0x4(%ebp)
  8012ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012b4:	7c e1                	jl     801297 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012b6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012bd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012c4:	eb 1f                	jmp    8012e5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c9:	8d 50 01             	lea    0x1(%eax),%edx
  8012cc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012cf:	89 c2                	mov    %eax,%edx
  8012d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d4:	01 c2                	add    %eax,%edx
  8012d6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012dc:	01 c8                	add    %ecx,%eax
  8012de:	8a 00                	mov    (%eax),%al
  8012e0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012e2:	ff 45 f8             	incl   -0x8(%ebp)
  8012e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012eb:	7c d9                	jl     8012c6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f3:	01 d0                	add    %edx,%eax
  8012f5:	c6 00 00             	movb   $0x0,(%eax)
}
  8012f8:	90                   	nop
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    

008012fb <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801301:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801307:	8b 45 14             	mov    0x14(%ebp),%eax
  80130a:	8b 00                	mov    (%eax),%eax
  80130c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801313:	8b 45 10             	mov    0x10(%ebp),%eax
  801316:	01 d0                	add    %edx,%eax
  801318:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80131e:	eb 0c                	jmp    80132c <strsplit+0x31>
			*string++ = 0;
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	8d 50 01             	lea    0x1(%eax),%edx
  801326:	89 55 08             	mov    %edx,0x8(%ebp)
  801329:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	8a 00                	mov    (%eax),%al
  801331:	84 c0                	test   %al,%al
  801333:	74 18                	je     80134d <strsplit+0x52>
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	8a 00                	mov    (%eax),%al
  80133a:	0f be c0             	movsbl %al,%eax
  80133d:	50                   	push   %eax
  80133e:	ff 75 0c             	pushl  0xc(%ebp)
  801341:	e8 83 fa ff ff       	call   800dc9 <strchr>
  801346:	83 c4 08             	add    $0x8,%esp
  801349:	85 c0                	test   %eax,%eax
  80134b:	75 d3                	jne    801320 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80134d:	8b 45 08             	mov    0x8(%ebp),%eax
  801350:	8a 00                	mov    (%eax),%al
  801352:	84 c0                	test   %al,%al
  801354:	74 5a                	je     8013b0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801356:	8b 45 14             	mov    0x14(%ebp),%eax
  801359:	8b 00                	mov    (%eax),%eax
  80135b:	83 f8 0f             	cmp    $0xf,%eax
  80135e:	75 07                	jne    801367 <strsplit+0x6c>
		{
			return 0;
  801360:	b8 00 00 00 00       	mov    $0x0,%eax
  801365:	eb 66                	jmp    8013cd <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801367:	8b 45 14             	mov    0x14(%ebp),%eax
  80136a:	8b 00                	mov    (%eax),%eax
  80136c:	8d 48 01             	lea    0x1(%eax),%ecx
  80136f:	8b 55 14             	mov    0x14(%ebp),%edx
  801372:	89 0a                	mov    %ecx,(%edx)
  801374:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80137b:	8b 45 10             	mov    0x10(%ebp),%eax
  80137e:	01 c2                	add    %eax,%edx
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801385:	eb 03                	jmp    80138a <strsplit+0x8f>
			string++;
  801387:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80138a:	8b 45 08             	mov    0x8(%ebp),%eax
  80138d:	8a 00                	mov    (%eax),%al
  80138f:	84 c0                	test   %al,%al
  801391:	74 8b                	je     80131e <strsplit+0x23>
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	8a 00                	mov    (%eax),%al
  801398:	0f be c0             	movsbl %al,%eax
  80139b:	50                   	push   %eax
  80139c:	ff 75 0c             	pushl  0xc(%ebp)
  80139f:	e8 25 fa ff ff       	call   800dc9 <strchr>
  8013a4:	83 c4 08             	add    $0x8,%esp
  8013a7:	85 c0                	test   %eax,%eax
  8013a9:	74 dc                	je     801387 <strsplit+0x8c>
			string++;
	}
  8013ab:	e9 6e ff ff ff       	jmp    80131e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013b0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b4:	8b 00                	mov    (%eax),%eax
  8013b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c0:	01 d0                	add    %edx,%eax
  8013c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013c8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013cd:	c9                   	leave  
  8013ce:	c3                   	ret    

008013cf <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
  8013d2:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8013d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013e2:	eb 4a                	jmp    80142e <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8013e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ea:	01 c2                	add    %eax,%edx
  8013ec:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f2:	01 c8                	add    %ecx,%eax
  8013f4:	8a 00                	mov    (%eax),%al
  8013f6:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8013f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fe:	01 d0                	add    %edx,%eax
  801400:	8a 00                	mov    (%eax),%al
  801402:	3c 40                	cmp    $0x40,%al
  801404:	7e 25                	jle    80142b <str2lower+0x5c>
  801406:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801409:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140c:	01 d0                	add    %edx,%eax
  80140e:	8a 00                	mov    (%eax),%al
  801410:	3c 5a                	cmp    $0x5a,%al
  801412:	7f 17                	jg     80142b <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801414:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	01 d0                	add    %edx,%eax
  80141c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80141f:	8b 55 08             	mov    0x8(%ebp),%edx
  801422:	01 ca                	add    %ecx,%edx
  801424:	8a 12                	mov    (%edx),%dl
  801426:	83 c2 20             	add    $0x20,%edx
  801429:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80142b:	ff 45 fc             	incl   -0x4(%ebp)
  80142e:	ff 75 0c             	pushl  0xc(%ebp)
  801431:	e8 01 f8 ff ff       	call   800c37 <strlen>
  801436:	83 c4 04             	add    $0x4,%esp
  801439:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80143c:	7f a6                	jg     8013e4 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80143e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801441:	c9                   	leave  
  801442:	c3                   	ret    

00801443 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
  801446:	57                   	push   %edi
  801447:	56                   	push   %esi
  801448:	53                   	push   %ebx
  801449:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80144c:	8b 45 08             	mov    0x8(%ebp),%eax
  80144f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801452:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801455:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801458:	8b 7d 18             	mov    0x18(%ebp),%edi
  80145b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80145e:	cd 30                	int    $0x30
  801460:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801463:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801466:	83 c4 10             	add    $0x10,%esp
  801469:	5b                   	pop    %ebx
  80146a:	5e                   	pop    %esi
  80146b:	5f                   	pop    %edi
  80146c:	5d                   	pop    %ebp
  80146d:	c3                   	ret    

0080146e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
  801471:	83 ec 04             	sub    $0x4,%esp
  801474:	8b 45 10             	mov    0x10(%ebp),%eax
  801477:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80147a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80147d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	6a 00                	push   $0x0
  801486:	51                   	push   %ecx
  801487:	52                   	push   %edx
  801488:	ff 75 0c             	pushl  0xc(%ebp)
  80148b:	50                   	push   %eax
  80148c:	6a 00                	push   $0x0
  80148e:	e8 b0 ff ff ff       	call   801443 <syscall>
  801493:	83 c4 18             	add    $0x18,%esp
}
  801496:	90                   	nop
  801497:	c9                   	leave  
  801498:	c3                   	ret    

00801499 <sys_cgetc>:

int
sys_cgetc(void)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 02                	push   $0x2
  8014a8:	e8 96 ff ff ff       	call   801443 <syscall>
  8014ad:	83 c4 18             	add    $0x18,%esp
}
  8014b0:	c9                   	leave  
  8014b1:	c3                   	ret    

008014b2 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014b2:	55                   	push   %ebp
  8014b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 03                	push   $0x3
  8014c1:	e8 7d ff ff ff       	call   801443 <syscall>
  8014c6:	83 c4 18             	add    $0x18,%esp
}
  8014c9:	90                   	nop
  8014ca:	c9                   	leave  
  8014cb:	c3                   	ret    

008014cc <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 04                	push   $0x4
  8014db:	e8 63 ff ff ff       	call   801443 <syscall>
  8014e0:	83 c4 18             	add    $0x18,%esp
}
  8014e3:	90                   	nop
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	52                   	push   %edx
  8014f6:	50                   	push   %eax
  8014f7:	6a 08                	push   $0x8
  8014f9:	e8 45 ff ff ff       	call   801443 <syscall>
  8014fe:	83 c4 18             	add    $0x18,%esp
}
  801501:	c9                   	leave  
  801502:	c3                   	ret    

00801503 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
  801506:	56                   	push   %esi
  801507:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801508:	8b 75 18             	mov    0x18(%ebp),%esi
  80150b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80150e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801511:	8b 55 0c             	mov    0xc(%ebp),%edx
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	56                   	push   %esi
  801518:	53                   	push   %ebx
  801519:	51                   	push   %ecx
  80151a:	52                   	push   %edx
  80151b:	50                   	push   %eax
  80151c:	6a 09                	push   $0x9
  80151e:	e8 20 ff ff ff       	call   801443 <syscall>
  801523:	83 c4 18             	add    $0x18,%esp
}
  801526:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801529:	5b                   	pop    %ebx
  80152a:	5e                   	pop    %esi
  80152b:	5d                   	pop    %ebp
  80152c:	c3                   	ret    

0080152d <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801530:	6a 00                	push   $0x0
  801532:	6a 00                	push   $0x0
  801534:	6a 00                	push   $0x0
  801536:	6a 00                	push   $0x0
  801538:	ff 75 08             	pushl  0x8(%ebp)
  80153b:	6a 0a                	push   $0xa
  80153d:	e8 01 ff ff ff       	call   801443 <syscall>
  801542:	83 c4 18             	add    $0x18,%esp
}
  801545:	c9                   	leave  
  801546:	c3                   	ret    

00801547 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80154a:	6a 00                	push   $0x0
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	ff 75 0c             	pushl  0xc(%ebp)
  801553:	ff 75 08             	pushl  0x8(%ebp)
  801556:	6a 0b                	push   $0xb
  801558:	e8 e6 fe ff ff       	call   801443 <syscall>
  80155d:	83 c4 18             	add    $0x18,%esp
}
  801560:	c9                   	leave  
  801561:	c3                   	ret    

00801562 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 0c                	push   $0xc
  801571:	e8 cd fe ff ff       	call   801443 <syscall>
  801576:	83 c4 18             	add    $0x18,%esp
}
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 0d                	push   $0xd
  80158a:	e8 b4 fe ff ff       	call   801443 <syscall>
  80158f:	83 c4 18             	add    $0x18,%esp
}
  801592:	c9                   	leave  
  801593:	c3                   	ret    

00801594 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 0e                	push   $0xe
  8015a3:	e8 9b fe ff ff       	call   801443 <syscall>
  8015a8:	83 c4 18             	add    $0x18,%esp
}
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    

008015ad <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 0f                	push   $0xf
  8015bc:	e8 82 fe ff ff       	call   801443 <syscall>
  8015c1:	83 c4 18             	add    $0x18,%esp
}
  8015c4:	c9                   	leave  
  8015c5:	c3                   	ret    

008015c6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	ff 75 08             	pushl  0x8(%ebp)
  8015d4:	6a 10                	push   $0x10
  8015d6:	e8 68 fe ff ff       	call   801443 <syscall>
  8015db:	83 c4 18             	add    $0x18,%esp
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 11                	push   $0x11
  8015ef:	e8 4f fe ff ff       	call   801443 <syscall>
  8015f4:	83 c4 18             	add    $0x18,%esp
}
  8015f7:	90                   	nop
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <sys_cputc>:

void
sys_cputc(const char c)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
  8015fd:	83 ec 04             	sub    $0x4,%esp
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
  801603:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801606:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	50                   	push   %eax
  801613:	6a 01                	push   $0x1
  801615:	e8 29 fe ff ff       	call   801443 <syscall>
  80161a:	83 c4 18             	add    $0x18,%esp
}
  80161d:	90                   	nop
  80161e:	c9                   	leave  
  80161f:	c3                   	ret    

00801620 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 14                	push   $0x14
  80162f:	e8 0f fe ff ff       	call   801443 <syscall>
  801634:	83 c4 18             	add    $0x18,%esp
}
  801637:	90                   	nop
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	83 ec 04             	sub    $0x4,%esp
  801640:	8b 45 10             	mov    0x10(%ebp),%eax
  801643:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801646:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801649:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80164d:	8b 45 08             	mov    0x8(%ebp),%eax
  801650:	6a 00                	push   $0x0
  801652:	51                   	push   %ecx
  801653:	52                   	push   %edx
  801654:	ff 75 0c             	pushl  0xc(%ebp)
  801657:	50                   	push   %eax
  801658:	6a 15                	push   $0x15
  80165a:	e8 e4 fd ff ff       	call   801443 <syscall>
  80165f:	83 c4 18             	add    $0x18,%esp
}
  801662:	c9                   	leave  
  801663:	c3                   	ret    

00801664 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801667:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	52                   	push   %edx
  801674:	50                   	push   %eax
  801675:	6a 16                	push   $0x16
  801677:	e8 c7 fd ff ff       	call   801443 <syscall>
  80167c:	83 c4 18             	add    $0x18,%esp
}
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801684:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801687:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168a:	8b 45 08             	mov    0x8(%ebp),%eax
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	51                   	push   %ecx
  801692:	52                   	push   %edx
  801693:	50                   	push   %eax
  801694:	6a 17                	push   $0x17
  801696:	e8 a8 fd ff ff       	call   801443 <syscall>
  80169b:	83 c4 18             	add    $0x18,%esp
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	52                   	push   %edx
  8016b0:	50                   	push   %eax
  8016b1:	6a 18                	push   $0x18
  8016b3:	e8 8b fd ff ff       	call   801443 <syscall>
  8016b8:	83 c4 18             	add    $0x18,%esp
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	6a 00                	push   $0x0
  8016c5:	ff 75 14             	pushl  0x14(%ebp)
  8016c8:	ff 75 10             	pushl  0x10(%ebp)
  8016cb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ce:	50                   	push   %eax
  8016cf:	6a 19                	push   $0x19
  8016d1:	e8 6d fd ff ff       	call   801443 <syscall>
  8016d6:	83 c4 18             	add    $0x18,%esp
}
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <sys_run_env>:

void sys_run_env(int32 envId)
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016de:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	50                   	push   %eax
  8016ea:	6a 1a                	push   $0x1a
  8016ec:	e8 52 fd ff ff       	call   801443 <syscall>
  8016f1:	83 c4 18             	add    $0x18,%esp
}
  8016f4:	90                   	nop
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8016fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	50                   	push   %eax
  801706:	6a 1b                	push   $0x1b
  801708:	e8 36 fd ff ff       	call   801443 <syscall>
  80170d:	83 c4 18             	add    $0x18,%esp
}
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 05                	push   $0x5
  801721:	e8 1d fd ff ff       	call   801443 <syscall>
  801726:	83 c4 18             	add    $0x18,%esp
}
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 06                	push   $0x6
  80173a:	e8 04 fd ff ff       	call   801443 <syscall>
  80173f:	83 c4 18             	add    $0x18,%esp
}
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 07                	push   $0x7
  801753:	e8 eb fc ff ff       	call   801443 <syscall>
  801758:	83 c4 18             	add    $0x18,%esp
}
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <sys_exit_env>:


void sys_exit_env(void)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 1c                	push   $0x1c
  80176c:	e8 d2 fc ff ff       	call   801443 <syscall>
  801771:	83 c4 18             	add    $0x18,%esp
}
  801774:	90                   	nop
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80177d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801780:	8d 50 04             	lea    0x4(%eax),%edx
  801783:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	52                   	push   %edx
  80178d:	50                   	push   %eax
  80178e:	6a 1d                	push   $0x1d
  801790:	e8 ae fc ff ff       	call   801443 <syscall>
  801795:	83 c4 18             	add    $0x18,%esp
	return result;
  801798:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80179b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80179e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017a1:	89 01                	mov    %eax,(%ecx)
  8017a3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a9:	c9                   	leave  
  8017aa:	c2 04 00             	ret    $0x4

008017ad <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	ff 75 10             	pushl  0x10(%ebp)
  8017b7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ba:	ff 75 08             	pushl  0x8(%ebp)
  8017bd:	6a 13                	push   $0x13
  8017bf:	e8 7f fc ff ff       	call   801443 <syscall>
  8017c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c7:	90                   	nop
}
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    

008017ca <sys_rcr2>:
uint32 sys_rcr2()
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 1e                	push   $0x1e
  8017d9:	e8 65 fc ff ff       	call   801443 <syscall>
  8017de:	83 c4 18             	add    $0x18,%esp
}
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    

008017e3 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
  8017e6:	83 ec 04             	sub    $0x4,%esp
  8017e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8017ef:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	50                   	push   %eax
  8017fc:	6a 1f                	push   $0x1f
  8017fe:	e8 40 fc ff ff       	call   801443 <syscall>
  801803:	83 c4 18             	add    $0x18,%esp
	return ;
  801806:	90                   	nop
}
  801807:	c9                   	leave  
  801808:	c3                   	ret    

00801809 <rsttst>:
void rsttst()
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 21                	push   $0x21
  801818:	e8 26 fc ff ff       	call   801443 <syscall>
  80181d:	83 c4 18             	add    $0x18,%esp
	return ;
  801820:	90                   	nop
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	83 ec 04             	sub    $0x4,%esp
  801829:	8b 45 14             	mov    0x14(%ebp),%eax
  80182c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80182f:	8b 55 18             	mov    0x18(%ebp),%edx
  801832:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801836:	52                   	push   %edx
  801837:	50                   	push   %eax
  801838:	ff 75 10             	pushl  0x10(%ebp)
  80183b:	ff 75 0c             	pushl  0xc(%ebp)
  80183e:	ff 75 08             	pushl  0x8(%ebp)
  801841:	6a 20                	push   $0x20
  801843:	e8 fb fb ff ff       	call   801443 <syscall>
  801848:	83 c4 18             	add    $0x18,%esp
	return ;
  80184b:	90                   	nop
}
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <chktst>:
void chktst(uint32 n)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	ff 75 08             	pushl  0x8(%ebp)
  80185c:	6a 22                	push   $0x22
  80185e:	e8 e0 fb ff ff       	call   801443 <syscall>
  801863:	83 c4 18             	add    $0x18,%esp
	return ;
  801866:	90                   	nop
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <inctst>:

void inctst()
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 23                	push   $0x23
  801878:	e8 c6 fb ff ff       	call   801443 <syscall>
  80187d:	83 c4 18             	add    $0x18,%esp
	return ;
  801880:	90                   	nop
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <gettst>:
uint32 gettst()
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 24                	push   $0x24
  801892:	e8 ac fb ff ff       	call   801443 <syscall>
  801897:	83 c4 18             	add    $0x18,%esp
}
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 25                	push   $0x25
  8018ab:	e8 93 fb ff ff       	call   801443 <syscall>
  8018b0:	83 c4 18             	add    $0x18,%esp
  8018b3:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8018b8:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8018c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c5:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	ff 75 08             	pushl  0x8(%ebp)
  8018d5:	6a 26                	push   $0x26
  8018d7:	e8 67 fb ff ff       	call   801443 <syscall>
  8018dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8018df:	90                   	nop
}
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f2:	6a 00                	push   $0x0
  8018f4:	53                   	push   %ebx
  8018f5:	51                   	push   %ecx
  8018f6:	52                   	push   %edx
  8018f7:	50                   	push   %eax
  8018f8:	6a 27                	push   $0x27
  8018fa:	e8 44 fb ff ff       	call   801443 <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
}
  801902:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801905:	c9                   	leave  
  801906:	c3                   	ret    

00801907 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80190a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190d:	8b 45 08             	mov    0x8(%ebp),%eax
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	52                   	push   %edx
  801917:	50                   	push   %eax
  801918:	6a 28                	push   $0x28
  80191a:	e8 24 fb ff ff       	call   801443 <syscall>
  80191f:	83 c4 18             	add    $0x18,%esp
}
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801927:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80192a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192d:	8b 45 08             	mov    0x8(%ebp),%eax
  801930:	6a 00                	push   $0x0
  801932:	51                   	push   %ecx
  801933:	ff 75 10             	pushl  0x10(%ebp)
  801936:	52                   	push   %edx
  801937:	50                   	push   %eax
  801938:	6a 29                	push   $0x29
  80193a:	e8 04 fb ff ff       	call   801443 <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	ff 75 10             	pushl  0x10(%ebp)
  80194e:	ff 75 0c             	pushl  0xc(%ebp)
  801951:	ff 75 08             	pushl  0x8(%ebp)
  801954:	6a 12                	push   $0x12
  801956:	e8 e8 fa ff ff       	call   801443 <syscall>
  80195b:	83 c4 18             	add    $0x18,%esp
	return ;
  80195e:	90                   	nop
}
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801964:	8b 55 0c             	mov    0xc(%ebp),%edx
  801967:	8b 45 08             	mov    0x8(%ebp),%eax
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	52                   	push   %edx
  801971:	50                   	push   %eax
  801972:	6a 2a                	push   $0x2a
  801974:	e8 ca fa ff ff       	call   801443 <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
	return;
  80197c:	90                   	nop
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 2b                	push   $0x2b
  80198e:	e8 b0 fa ff ff       	call   801443 <syscall>
  801993:	83 c4 18             	add    $0x18,%esp
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	ff 75 0c             	pushl  0xc(%ebp)
  8019a4:	ff 75 08             	pushl  0x8(%ebp)
  8019a7:	6a 2d                	push   $0x2d
  8019a9:	e8 95 fa ff ff       	call   801443 <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
	return;
  8019b1:	90                   	nop
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	ff 75 0c             	pushl  0xc(%ebp)
  8019c0:	ff 75 08             	pushl  0x8(%ebp)
  8019c3:	6a 2c                	push   $0x2c
  8019c5:	e8 79 fa ff ff       	call   801443 <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8019cd:	90                   	nop
}
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
  8019d3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8019d6:	83 ec 04             	sub    $0x4,%esp
  8019d9:	68 e8 22 80 00       	push   $0x8022e8
  8019de:	68 25 01 00 00       	push   $0x125
  8019e3:	68 1b 23 80 00       	push   $0x80231b
  8019e8:	e8 a3 e8 ff ff       	call   800290 <_panic>
  8019ed:	66 90                	xchg   %ax,%ax
  8019ef:	90                   	nop

008019f0 <__udivdi3>:
  8019f0:	55                   	push   %ebp
  8019f1:	57                   	push   %edi
  8019f2:	56                   	push   %esi
  8019f3:	53                   	push   %ebx
  8019f4:	83 ec 1c             	sub    $0x1c,%esp
  8019f7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019fb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a03:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a07:	89 ca                	mov    %ecx,%edx
  801a09:	89 f8                	mov    %edi,%eax
  801a0b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a0f:	85 f6                	test   %esi,%esi
  801a11:	75 2d                	jne    801a40 <__udivdi3+0x50>
  801a13:	39 cf                	cmp    %ecx,%edi
  801a15:	77 65                	ja     801a7c <__udivdi3+0x8c>
  801a17:	89 fd                	mov    %edi,%ebp
  801a19:	85 ff                	test   %edi,%edi
  801a1b:	75 0b                	jne    801a28 <__udivdi3+0x38>
  801a1d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a22:	31 d2                	xor    %edx,%edx
  801a24:	f7 f7                	div    %edi
  801a26:	89 c5                	mov    %eax,%ebp
  801a28:	31 d2                	xor    %edx,%edx
  801a2a:	89 c8                	mov    %ecx,%eax
  801a2c:	f7 f5                	div    %ebp
  801a2e:	89 c1                	mov    %eax,%ecx
  801a30:	89 d8                	mov    %ebx,%eax
  801a32:	f7 f5                	div    %ebp
  801a34:	89 cf                	mov    %ecx,%edi
  801a36:	89 fa                	mov    %edi,%edx
  801a38:	83 c4 1c             	add    $0x1c,%esp
  801a3b:	5b                   	pop    %ebx
  801a3c:	5e                   	pop    %esi
  801a3d:	5f                   	pop    %edi
  801a3e:	5d                   	pop    %ebp
  801a3f:	c3                   	ret    
  801a40:	39 ce                	cmp    %ecx,%esi
  801a42:	77 28                	ja     801a6c <__udivdi3+0x7c>
  801a44:	0f bd fe             	bsr    %esi,%edi
  801a47:	83 f7 1f             	xor    $0x1f,%edi
  801a4a:	75 40                	jne    801a8c <__udivdi3+0x9c>
  801a4c:	39 ce                	cmp    %ecx,%esi
  801a4e:	72 0a                	jb     801a5a <__udivdi3+0x6a>
  801a50:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a54:	0f 87 9e 00 00 00    	ja     801af8 <__udivdi3+0x108>
  801a5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a5f:	89 fa                	mov    %edi,%edx
  801a61:	83 c4 1c             	add    $0x1c,%esp
  801a64:	5b                   	pop    %ebx
  801a65:	5e                   	pop    %esi
  801a66:	5f                   	pop    %edi
  801a67:	5d                   	pop    %ebp
  801a68:	c3                   	ret    
  801a69:	8d 76 00             	lea    0x0(%esi),%esi
  801a6c:	31 ff                	xor    %edi,%edi
  801a6e:	31 c0                	xor    %eax,%eax
  801a70:	89 fa                	mov    %edi,%edx
  801a72:	83 c4 1c             	add    $0x1c,%esp
  801a75:	5b                   	pop    %ebx
  801a76:	5e                   	pop    %esi
  801a77:	5f                   	pop    %edi
  801a78:	5d                   	pop    %ebp
  801a79:	c3                   	ret    
  801a7a:	66 90                	xchg   %ax,%ax
  801a7c:	89 d8                	mov    %ebx,%eax
  801a7e:	f7 f7                	div    %edi
  801a80:	31 ff                	xor    %edi,%edi
  801a82:	89 fa                	mov    %edi,%edx
  801a84:	83 c4 1c             	add    $0x1c,%esp
  801a87:	5b                   	pop    %ebx
  801a88:	5e                   	pop    %esi
  801a89:	5f                   	pop    %edi
  801a8a:	5d                   	pop    %ebp
  801a8b:	c3                   	ret    
  801a8c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a91:	89 eb                	mov    %ebp,%ebx
  801a93:	29 fb                	sub    %edi,%ebx
  801a95:	89 f9                	mov    %edi,%ecx
  801a97:	d3 e6                	shl    %cl,%esi
  801a99:	89 c5                	mov    %eax,%ebp
  801a9b:	88 d9                	mov    %bl,%cl
  801a9d:	d3 ed                	shr    %cl,%ebp
  801a9f:	89 e9                	mov    %ebp,%ecx
  801aa1:	09 f1                	or     %esi,%ecx
  801aa3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801aa7:	89 f9                	mov    %edi,%ecx
  801aa9:	d3 e0                	shl    %cl,%eax
  801aab:	89 c5                	mov    %eax,%ebp
  801aad:	89 d6                	mov    %edx,%esi
  801aaf:	88 d9                	mov    %bl,%cl
  801ab1:	d3 ee                	shr    %cl,%esi
  801ab3:	89 f9                	mov    %edi,%ecx
  801ab5:	d3 e2                	shl    %cl,%edx
  801ab7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801abb:	88 d9                	mov    %bl,%cl
  801abd:	d3 e8                	shr    %cl,%eax
  801abf:	09 c2                	or     %eax,%edx
  801ac1:	89 d0                	mov    %edx,%eax
  801ac3:	89 f2                	mov    %esi,%edx
  801ac5:	f7 74 24 0c          	divl   0xc(%esp)
  801ac9:	89 d6                	mov    %edx,%esi
  801acb:	89 c3                	mov    %eax,%ebx
  801acd:	f7 e5                	mul    %ebp
  801acf:	39 d6                	cmp    %edx,%esi
  801ad1:	72 19                	jb     801aec <__udivdi3+0xfc>
  801ad3:	74 0b                	je     801ae0 <__udivdi3+0xf0>
  801ad5:	89 d8                	mov    %ebx,%eax
  801ad7:	31 ff                	xor    %edi,%edi
  801ad9:	e9 58 ff ff ff       	jmp    801a36 <__udivdi3+0x46>
  801ade:	66 90                	xchg   %ax,%ax
  801ae0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ae4:	89 f9                	mov    %edi,%ecx
  801ae6:	d3 e2                	shl    %cl,%edx
  801ae8:	39 c2                	cmp    %eax,%edx
  801aea:	73 e9                	jae    801ad5 <__udivdi3+0xe5>
  801aec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801aef:	31 ff                	xor    %edi,%edi
  801af1:	e9 40 ff ff ff       	jmp    801a36 <__udivdi3+0x46>
  801af6:	66 90                	xchg   %ax,%ax
  801af8:	31 c0                	xor    %eax,%eax
  801afa:	e9 37 ff ff ff       	jmp    801a36 <__udivdi3+0x46>
  801aff:	90                   	nop

00801b00 <__umoddi3>:
  801b00:	55                   	push   %ebp
  801b01:	57                   	push   %edi
  801b02:	56                   	push   %esi
  801b03:	53                   	push   %ebx
  801b04:	83 ec 1c             	sub    $0x1c,%esp
  801b07:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b0b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b13:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b17:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b1b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b1f:	89 f3                	mov    %esi,%ebx
  801b21:	89 fa                	mov    %edi,%edx
  801b23:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b27:	89 34 24             	mov    %esi,(%esp)
  801b2a:	85 c0                	test   %eax,%eax
  801b2c:	75 1a                	jne    801b48 <__umoddi3+0x48>
  801b2e:	39 f7                	cmp    %esi,%edi
  801b30:	0f 86 a2 00 00 00    	jbe    801bd8 <__umoddi3+0xd8>
  801b36:	89 c8                	mov    %ecx,%eax
  801b38:	89 f2                	mov    %esi,%edx
  801b3a:	f7 f7                	div    %edi
  801b3c:	89 d0                	mov    %edx,%eax
  801b3e:	31 d2                	xor    %edx,%edx
  801b40:	83 c4 1c             	add    $0x1c,%esp
  801b43:	5b                   	pop    %ebx
  801b44:	5e                   	pop    %esi
  801b45:	5f                   	pop    %edi
  801b46:	5d                   	pop    %ebp
  801b47:	c3                   	ret    
  801b48:	39 f0                	cmp    %esi,%eax
  801b4a:	0f 87 ac 00 00 00    	ja     801bfc <__umoddi3+0xfc>
  801b50:	0f bd e8             	bsr    %eax,%ebp
  801b53:	83 f5 1f             	xor    $0x1f,%ebp
  801b56:	0f 84 ac 00 00 00    	je     801c08 <__umoddi3+0x108>
  801b5c:	bf 20 00 00 00       	mov    $0x20,%edi
  801b61:	29 ef                	sub    %ebp,%edi
  801b63:	89 fe                	mov    %edi,%esi
  801b65:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b69:	89 e9                	mov    %ebp,%ecx
  801b6b:	d3 e0                	shl    %cl,%eax
  801b6d:	89 d7                	mov    %edx,%edi
  801b6f:	89 f1                	mov    %esi,%ecx
  801b71:	d3 ef                	shr    %cl,%edi
  801b73:	09 c7                	or     %eax,%edi
  801b75:	89 e9                	mov    %ebp,%ecx
  801b77:	d3 e2                	shl    %cl,%edx
  801b79:	89 14 24             	mov    %edx,(%esp)
  801b7c:	89 d8                	mov    %ebx,%eax
  801b7e:	d3 e0                	shl    %cl,%eax
  801b80:	89 c2                	mov    %eax,%edx
  801b82:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b86:	d3 e0                	shl    %cl,%eax
  801b88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b8c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b90:	89 f1                	mov    %esi,%ecx
  801b92:	d3 e8                	shr    %cl,%eax
  801b94:	09 d0                	or     %edx,%eax
  801b96:	d3 eb                	shr    %cl,%ebx
  801b98:	89 da                	mov    %ebx,%edx
  801b9a:	f7 f7                	div    %edi
  801b9c:	89 d3                	mov    %edx,%ebx
  801b9e:	f7 24 24             	mull   (%esp)
  801ba1:	89 c6                	mov    %eax,%esi
  801ba3:	89 d1                	mov    %edx,%ecx
  801ba5:	39 d3                	cmp    %edx,%ebx
  801ba7:	0f 82 87 00 00 00    	jb     801c34 <__umoddi3+0x134>
  801bad:	0f 84 91 00 00 00    	je     801c44 <__umoddi3+0x144>
  801bb3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bb7:	29 f2                	sub    %esi,%edx
  801bb9:	19 cb                	sbb    %ecx,%ebx
  801bbb:	89 d8                	mov    %ebx,%eax
  801bbd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bc1:	d3 e0                	shl    %cl,%eax
  801bc3:	89 e9                	mov    %ebp,%ecx
  801bc5:	d3 ea                	shr    %cl,%edx
  801bc7:	09 d0                	or     %edx,%eax
  801bc9:	89 e9                	mov    %ebp,%ecx
  801bcb:	d3 eb                	shr    %cl,%ebx
  801bcd:	89 da                	mov    %ebx,%edx
  801bcf:	83 c4 1c             	add    $0x1c,%esp
  801bd2:	5b                   	pop    %ebx
  801bd3:	5e                   	pop    %esi
  801bd4:	5f                   	pop    %edi
  801bd5:	5d                   	pop    %ebp
  801bd6:	c3                   	ret    
  801bd7:	90                   	nop
  801bd8:	89 fd                	mov    %edi,%ebp
  801bda:	85 ff                	test   %edi,%edi
  801bdc:	75 0b                	jne    801be9 <__umoddi3+0xe9>
  801bde:	b8 01 00 00 00       	mov    $0x1,%eax
  801be3:	31 d2                	xor    %edx,%edx
  801be5:	f7 f7                	div    %edi
  801be7:	89 c5                	mov    %eax,%ebp
  801be9:	89 f0                	mov    %esi,%eax
  801beb:	31 d2                	xor    %edx,%edx
  801bed:	f7 f5                	div    %ebp
  801bef:	89 c8                	mov    %ecx,%eax
  801bf1:	f7 f5                	div    %ebp
  801bf3:	89 d0                	mov    %edx,%eax
  801bf5:	e9 44 ff ff ff       	jmp    801b3e <__umoddi3+0x3e>
  801bfa:	66 90                	xchg   %ax,%ax
  801bfc:	89 c8                	mov    %ecx,%eax
  801bfe:	89 f2                	mov    %esi,%edx
  801c00:	83 c4 1c             	add    $0x1c,%esp
  801c03:	5b                   	pop    %ebx
  801c04:	5e                   	pop    %esi
  801c05:	5f                   	pop    %edi
  801c06:	5d                   	pop    %ebp
  801c07:	c3                   	ret    
  801c08:	3b 04 24             	cmp    (%esp),%eax
  801c0b:	72 06                	jb     801c13 <__umoddi3+0x113>
  801c0d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c11:	77 0f                	ja     801c22 <__umoddi3+0x122>
  801c13:	89 f2                	mov    %esi,%edx
  801c15:	29 f9                	sub    %edi,%ecx
  801c17:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c1b:	89 14 24             	mov    %edx,(%esp)
  801c1e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c22:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c26:	8b 14 24             	mov    (%esp),%edx
  801c29:	83 c4 1c             	add    $0x1c,%esp
  801c2c:	5b                   	pop    %ebx
  801c2d:	5e                   	pop    %esi
  801c2e:	5f                   	pop    %edi
  801c2f:	5d                   	pop    %ebp
  801c30:	c3                   	ret    
  801c31:	8d 76 00             	lea    0x0(%esi),%esi
  801c34:	2b 04 24             	sub    (%esp),%eax
  801c37:	19 fa                	sbb    %edi,%edx
  801c39:	89 d1                	mov    %edx,%ecx
  801c3b:	89 c6                	mov    %eax,%esi
  801c3d:	e9 71 ff ff ff       	jmp    801bb3 <__umoddi3+0xb3>
  801c42:	66 90                	xchg   %ax,%ax
  801c44:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c48:	72 ea                	jb     801c34 <__umoddi3+0x134>
  801c4a:	89 d9                	mov    %ebx,%ecx
  801c4c:	e9 62 ff ff ff       	jmp    801bb3 <__umoddi3+0xb3>

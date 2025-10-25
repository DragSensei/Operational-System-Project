
obj/user/priRR_fib_small:     file format elf32-i386


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
  800031:	e8 a7 00 00 00       	call   8000dd <libmain>
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
	i1 = 8;
  800048:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)

	int res = fibonacci(i1) ;
  80004f:	83 ec 0c             	sub    $0xc,%esp
  800052:	ff 75 f4             	pushl  -0xc(%ebp)
  800055:	e8 44 00 00 00       	call   80009e <fibonacci>
  80005a:	83 c4 10             	add    $0x10,%esp
  80005d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("Fibonacci #%d = %d\n",i1, res);
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	ff 75 f0             	pushl  -0x10(%ebp)
  800066:	ff 75 f4             	pushl  -0xc(%ebp)
  800069:	68 60 1c 80 00       	push   $0x801c60
  80006e:	e8 5a 05 00 00       	call   8005cd <atomic_cprintf>
  800073:	83 c4 10             	add    $0x10,%esp

	if (res != 34)
  800076:	83 7d f0 22          	cmpl   $0x22,-0x10(%ebp)
  80007a:	74 1a                	je     800096 <_main+0x5e>
		panic("[envID %d] wrong result!", myEnv->env_id);
  80007c:	a1 20 30 80 00       	mov    0x803020,%eax
  800081:	8b 40 10             	mov    0x10(%eax),%eax
  800084:	50                   	push   %eax
  800085:	68 74 1c 80 00       	push   $0x801c74
  80008a:	6a 13                	push   $0x13
  80008c:	68 8d 1c 80 00       	push   $0x801c8d
  800091:	e8 f7 01 00 00       	call   80028d <_panic>

	//To indicate that it's completed successfully
	inctst();
  800096:	e8 cb 17 00 00       	call   801866 <inctst>

	return;
  80009b:	90                   	nop
}
  80009c:	c9                   	leave  
  80009d:	c3                   	ret    

0080009e <fibonacci>:


int fibonacci(int n)
{
  80009e:	55                   	push   %ebp
  80009f:	89 e5                	mov    %esp,%ebp
  8000a1:	53                   	push   %ebx
  8000a2:	83 ec 04             	sub    $0x4,%esp
	if (n <= 1)
  8000a5:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000a9:	7f 07                	jg     8000b2 <fibonacci+0x14>
		return 1 ;
  8000ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b0:	eb 26                	jmp    8000d8 <fibonacci+0x3a>
	return fibonacci(n-1) + fibonacci(n-2) ;
  8000b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8000b5:	48                   	dec    %eax
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	50                   	push   %eax
  8000ba:	e8 df ff ff ff       	call   80009e <fibonacci>
  8000bf:	83 c4 10             	add    $0x10,%esp
  8000c2:	89 c3                	mov    %eax,%ebx
  8000c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8000c7:	83 e8 02             	sub    $0x2,%eax
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	50                   	push   %eax
  8000ce:	e8 cb ff ff ff       	call   80009e <fibonacci>
  8000d3:	83 c4 10             	add    $0x10,%esp
  8000d6:	01 d8                	add    %ebx,%eax
}
  8000d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000db:	c9                   	leave  
  8000dc:	c3                   	ret    

008000dd <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000dd:	55                   	push   %ebp
  8000de:	89 e5                	mov    %esp,%ebp
  8000e0:	57                   	push   %edi
  8000e1:	56                   	push   %esi
  8000e2:	53                   	push   %ebx
  8000e3:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000e6:	e8 3d 16 00 00       	call   801728 <sys_getenvindex>
  8000eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8000ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8000f1:	89 d0                	mov    %edx,%eax
  8000f3:	c1 e0 02             	shl    $0x2,%eax
  8000f6:	01 d0                	add    %edx,%eax
  8000f8:	c1 e0 03             	shl    $0x3,%eax
  8000fb:	01 d0                	add    %edx,%eax
  8000fd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800104:	01 d0                	add    %edx,%eax
  800106:	c1 e0 02             	shl    $0x2,%eax
  800109:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80010e:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800113:	a1 20 30 80 00       	mov    0x803020,%eax
  800118:	8a 40 20             	mov    0x20(%eax),%al
  80011b:	84 c0                	test   %al,%al
  80011d:	74 0d                	je     80012c <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80011f:	a1 20 30 80 00       	mov    0x803020,%eax
  800124:	83 c0 20             	add    $0x20,%eax
  800127:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800130:	7e 0a                	jle    80013c <libmain+0x5f>
		binaryname = argv[0];
  800132:	8b 45 0c             	mov    0xc(%ebp),%eax
  800135:	8b 00                	mov    (%eax),%eax
  800137:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80013c:	83 ec 08             	sub    $0x8,%esp
  80013f:	ff 75 0c             	pushl  0xc(%ebp)
  800142:	ff 75 08             	pushl  0x8(%ebp)
  800145:	e8 ee fe ff ff       	call   800038 <_main>
  80014a:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80014d:	a1 00 30 80 00       	mov    0x803000,%eax
  800152:	85 c0                	test   %eax,%eax
  800154:	0f 84 01 01 00 00    	je     80025b <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80015a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800160:	bb 9c 1d 80 00       	mov    $0x801d9c,%ebx
  800165:	ba 0e 00 00 00       	mov    $0xe,%edx
  80016a:	89 c7                	mov    %eax,%edi
  80016c:	89 de                	mov    %ebx,%esi
  80016e:	89 d1                	mov    %edx,%ecx
  800170:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800172:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800175:	b9 56 00 00 00       	mov    $0x56,%ecx
  80017a:	b0 00                	mov    $0x0,%al
  80017c:	89 d7                	mov    %edx,%edi
  80017e:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800180:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800187:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80018a:	83 ec 08             	sub    $0x8,%esp
  80018d:	50                   	push   %eax
  80018e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800194:	50                   	push   %eax
  800195:	e8 c4 17 00 00       	call   80195e <sys_utilities>
  80019a:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80019d:	e8 0d 13 00 00       	call   8014af <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001a2:	83 ec 0c             	sub    $0xc,%esp
  8001a5:	68 bc 1c 80 00       	push   $0x801cbc
  8001aa:	e8 ac 03 00 00       	call   80055b <cprintf>
  8001af:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8001b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001b5:	85 c0                	test   %eax,%eax
  8001b7:	74 18                	je     8001d1 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8001b9:	e8 be 17 00 00       	call   80197c <sys_get_optimal_num_faults>
  8001be:	83 ec 08             	sub    $0x8,%esp
  8001c1:	50                   	push   %eax
  8001c2:	68 e4 1c 80 00       	push   $0x801ce4
  8001c7:	e8 8f 03 00 00       	call   80055b <cprintf>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	eb 59                	jmp    80022a <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001d1:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d6:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8001dc:	a1 20 30 80 00       	mov    0x803020,%eax
  8001e1:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	52                   	push   %edx
  8001eb:	50                   	push   %eax
  8001ec:	68 08 1d 80 00       	push   $0x801d08
  8001f1:	e8 65 03 00 00       	call   80055b <cprintf>
  8001f6:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f9:	a1 20 30 80 00       	mov    0x803020,%eax
  8001fe:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800204:	a1 20 30 80 00       	mov    0x803020,%eax
  800209:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80020f:	a1 20 30 80 00       	mov    0x803020,%eax
  800214:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80021a:	51                   	push   %ecx
  80021b:	52                   	push   %edx
  80021c:	50                   	push   %eax
  80021d:	68 30 1d 80 00       	push   $0x801d30
  800222:	e8 34 03 00 00       	call   80055b <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80022a:	a1 20 30 80 00       	mov    0x803020,%eax
  80022f:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800235:	83 ec 08             	sub    $0x8,%esp
  800238:	50                   	push   %eax
  800239:	68 88 1d 80 00       	push   $0x801d88
  80023e:	e8 18 03 00 00       	call   80055b <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	68 bc 1c 80 00       	push   $0x801cbc
  80024e:	e8 08 03 00 00       	call   80055b <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800256:	e8 6e 12 00 00       	call   8014c9 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80025b:	e8 1f 00 00 00       	call   80027f <exit>
}
  800260:	90                   	nop
  800261:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800264:	5b                   	pop    %ebx
  800265:	5e                   	pop    %esi
  800266:	5f                   	pop    %edi
  800267:	5d                   	pop    %ebp
  800268:	c3                   	ret    

00800269 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800269:	55                   	push   %ebp
  80026a:	89 e5                	mov    %esp,%ebp
  80026c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	6a 00                	push   $0x0
  800274:	e8 7b 14 00 00       	call   8016f4 <sys_destroy_env>
  800279:	83 c4 10             	add    $0x10,%esp
}
  80027c:	90                   	nop
  80027d:	c9                   	leave  
  80027e:	c3                   	ret    

0080027f <exit>:

void
exit(void)
{
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
  800282:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800285:	e8 d0 14 00 00       	call   80175a <sys_exit_env>
}
  80028a:	90                   	nop
  80028b:	c9                   	leave  
  80028c:	c3                   	ret    

0080028d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80028d:	55                   	push   %ebp
  80028e:	89 e5                	mov    %esp,%ebp
  800290:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800293:	8d 45 10             	lea    0x10(%ebp),%eax
  800296:	83 c0 04             	add    $0x4,%eax
  800299:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80029c:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002a1:	85 c0                	test   %eax,%eax
  8002a3:	74 16                	je     8002bb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002a5:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8002aa:	83 ec 08             	sub    $0x8,%esp
  8002ad:	50                   	push   %eax
  8002ae:	68 00 1e 80 00       	push   $0x801e00
  8002b3:	e8 a3 02 00 00       	call   80055b <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8002bb:	a1 04 30 80 00       	mov    0x803004,%eax
  8002c0:	83 ec 0c             	sub    $0xc,%esp
  8002c3:	ff 75 0c             	pushl  0xc(%ebp)
  8002c6:	ff 75 08             	pushl  0x8(%ebp)
  8002c9:	50                   	push   %eax
  8002ca:	68 08 1e 80 00       	push   $0x801e08
  8002cf:	6a 74                	push   $0x74
  8002d1:	e8 b2 02 00 00       	call   800588 <cprintf_colored>
  8002d6:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8002d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002dc:	83 ec 08             	sub    $0x8,%esp
  8002df:	ff 75 f4             	pushl  -0xc(%ebp)
  8002e2:	50                   	push   %eax
  8002e3:	e8 04 02 00 00       	call   8004ec <vcprintf>
  8002e8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002eb:	83 ec 08             	sub    $0x8,%esp
  8002ee:	6a 00                	push   $0x0
  8002f0:	68 30 1e 80 00       	push   $0x801e30
  8002f5:	e8 f2 01 00 00       	call   8004ec <vcprintf>
  8002fa:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002fd:	e8 7d ff ff ff       	call   80027f <exit>

	// should not return here
	while (1) ;
  800302:	eb fe                	jmp    800302 <_panic+0x75>

00800304 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800304:	55                   	push   %ebp
  800305:	89 e5                	mov    %esp,%ebp
  800307:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80030a:	a1 20 30 80 00       	mov    0x803020,%eax
  80030f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800315:	8b 45 0c             	mov    0xc(%ebp),%eax
  800318:	39 c2                	cmp    %eax,%edx
  80031a:	74 14                	je     800330 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80031c:	83 ec 04             	sub    $0x4,%esp
  80031f:	68 34 1e 80 00       	push   $0x801e34
  800324:	6a 26                	push   $0x26
  800326:	68 80 1e 80 00       	push   $0x801e80
  80032b:	e8 5d ff ff ff       	call   80028d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800330:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800337:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80033e:	e9 c5 00 00 00       	jmp    800408 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800343:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800346:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034d:	8b 45 08             	mov    0x8(%ebp),%eax
  800350:	01 d0                	add    %edx,%eax
  800352:	8b 00                	mov    (%eax),%eax
  800354:	85 c0                	test   %eax,%eax
  800356:	75 08                	jne    800360 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800358:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80035b:	e9 a5 00 00 00       	jmp    800405 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800360:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800367:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80036e:	eb 69                	jmp    8003d9 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800370:	a1 20 30 80 00       	mov    0x803020,%eax
  800375:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80037b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80037e:	89 d0                	mov    %edx,%eax
  800380:	01 c0                	add    %eax,%eax
  800382:	01 d0                	add    %edx,%eax
  800384:	c1 e0 03             	shl    $0x3,%eax
  800387:	01 c8                	add    %ecx,%eax
  800389:	8a 40 04             	mov    0x4(%eax),%al
  80038c:	84 c0                	test   %al,%al
  80038e:	75 46                	jne    8003d6 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800390:	a1 20 30 80 00       	mov    0x803020,%eax
  800395:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80039b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80039e:	89 d0                	mov    %edx,%eax
  8003a0:	01 c0                	add    %eax,%eax
  8003a2:	01 d0                	add    %edx,%eax
  8003a4:	c1 e0 03             	shl    $0x3,%eax
  8003a7:	01 c8                	add    %ecx,%eax
  8003a9:	8b 00                	mov    (%eax),%eax
  8003ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003b1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003b6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003bb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c5:	01 c8                	add    %ecx,%eax
  8003c7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003c9:	39 c2                	cmp    %eax,%edx
  8003cb:	75 09                	jne    8003d6 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003cd:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003d4:	eb 15                	jmp    8003eb <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d6:	ff 45 e8             	incl   -0x18(%ebp)
  8003d9:	a1 20 30 80 00       	mov    0x803020,%eax
  8003de:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8003e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003e7:	39 c2                	cmp    %eax,%edx
  8003e9:	77 85                	ja     800370 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003ef:	75 14                	jne    800405 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003f1:	83 ec 04             	sub    $0x4,%esp
  8003f4:	68 8c 1e 80 00       	push   $0x801e8c
  8003f9:	6a 3a                	push   $0x3a
  8003fb:	68 80 1e 80 00       	push   $0x801e80
  800400:	e8 88 fe ff ff       	call   80028d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800405:	ff 45 f0             	incl   -0x10(%ebp)
  800408:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80040b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80040e:	0f 8c 2f ff ff ff    	jl     800343 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800414:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80041b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800422:	eb 26                	jmp    80044a <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800424:	a1 20 30 80 00       	mov    0x803020,%eax
  800429:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80042f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800432:	89 d0                	mov    %edx,%eax
  800434:	01 c0                	add    %eax,%eax
  800436:	01 d0                	add    %edx,%eax
  800438:	c1 e0 03             	shl    $0x3,%eax
  80043b:	01 c8                	add    %ecx,%eax
  80043d:	8a 40 04             	mov    0x4(%eax),%al
  800440:	3c 01                	cmp    $0x1,%al
  800442:	75 03                	jne    800447 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800444:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800447:	ff 45 e0             	incl   -0x20(%ebp)
  80044a:	a1 20 30 80 00       	mov    0x803020,%eax
  80044f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800455:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800458:	39 c2                	cmp    %eax,%edx
  80045a:	77 c8                	ja     800424 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80045c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80045f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800462:	74 14                	je     800478 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800464:	83 ec 04             	sub    $0x4,%esp
  800467:	68 e0 1e 80 00       	push   $0x801ee0
  80046c:	6a 44                	push   $0x44
  80046e:	68 80 1e 80 00       	push   $0x801e80
  800473:	e8 15 fe ff ff       	call   80028d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800478:	90                   	nop
  800479:	c9                   	leave  
  80047a:	c3                   	ret    

0080047b <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80047b:	55                   	push   %ebp
  80047c:	89 e5                	mov    %esp,%ebp
  80047e:	53                   	push   %ebx
  80047f:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800482:	8b 45 0c             	mov    0xc(%ebp),%eax
  800485:	8b 00                	mov    (%eax),%eax
  800487:	8d 48 01             	lea    0x1(%eax),%ecx
  80048a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048d:	89 0a                	mov    %ecx,(%edx)
  80048f:	8b 55 08             	mov    0x8(%ebp),%edx
  800492:	88 d1                	mov    %dl,%cl
  800494:	8b 55 0c             	mov    0xc(%ebp),%edx
  800497:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80049b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049e:	8b 00                	mov    (%eax),%eax
  8004a0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004a5:	75 30                	jne    8004d7 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8004a7:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8004ad:	a0 44 30 80 00       	mov    0x803044,%al
  8004b2:	0f b6 c0             	movzbl %al,%eax
  8004b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004b8:	8b 09                	mov    (%ecx),%ecx
  8004ba:	89 cb                	mov    %ecx,%ebx
  8004bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004bf:	83 c1 08             	add    $0x8,%ecx
  8004c2:	52                   	push   %edx
  8004c3:	50                   	push   %eax
  8004c4:	53                   	push   %ebx
  8004c5:	51                   	push   %ecx
  8004c6:	e8 a0 0f 00 00       	call   80146b <sys_cputs>
  8004cb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004da:	8b 40 04             	mov    0x4(%eax),%eax
  8004dd:	8d 50 01             	lea    0x1(%eax),%edx
  8004e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004e6:	90                   	nop
  8004e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004ea:	c9                   	leave  
  8004eb:	c3                   	ret    

008004ec <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004ec:	55                   	push   %ebp
  8004ed:	89 e5                	mov    %esp,%ebp
  8004ef:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004f5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004fc:	00 00 00 
	b.cnt = 0;
  8004ff:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800506:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800509:	ff 75 0c             	pushl  0xc(%ebp)
  80050c:	ff 75 08             	pushl  0x8(%ebp)
  80050f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800515:	50                   	push   %eax
  800516:	68 7b 04 80 00       	push   $0x80047b
  80051b:	e8 5a 02 00 00       	call   80077a <vprintfmt>
  800520:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800523:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800529:	a0 44 30 80 00       	mov    0x803044,%al
  80052e:	0f b6 c0             	movzbl %al,%eax
  800531:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800537:	52                   	push   %edx
  800538:	50                   	push   %eax
  800539:	51                   	push   %ecx
  80053a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800540:	83 c0 08             	add    $0x8,%eax
  800543:	50                   	push   %eax
  800544:	e8 22 0f 00 00       	call   80146b <sys_cputs>
  800549:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80054c:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800553:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800559:	c9                   	leave  
  80055a:	c3                   	ret    

0080055b <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80055b:	55                   	push   %ebp
  80055c:	89 e5                	mov    %esp,%ebp
  80055e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800561:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800568:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80056e:	8b 45 08             	mov    0x8(%ebp),%eax
  800571:	83 ec 08             	sub    $0x8,%esp
  800574:	ff 75 f4             	pushl  -0xc(%ebp)
  800577:	50                   	push   %eax
  800578:	e8 6f ff ff ff       	call   8004ec <vcprintf>
  80057d:	83 c4 10             	add    $0x10,%esp
  800580:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800583:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800586:	c9                   	leave  
  800587:	c3                   	ret    

00800588 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800588:	55                   	push   %ebp
  800589:	89 e5                	mov    %esp,%ebp
  80058b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80058e:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800595:	8b 45 08             	mov    0x8(%ebp),%eax
  800598:	c1 e0 08             	shl    $0x8,%eax
  80059b:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8005a0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a3:	83 c0 04             	add    $0x4,%eax
  8005a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ac:	83 ec 08             	sub    $0x8,%esp
  8005af:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b2:	50                   	push   %eax
  8005b3:	e8 34 ff ff ff       	call   8004ec <vcprintf>
  8005b8:	83 c4 10             	add    $0x10,%esp
  8005bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8005be:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8005c5:	07 00 00 

	return cnt;
  8005c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005cb:	c9                   	leave  
  8005cc:	c3                   	ret    

008005cd <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8005cd:	55                   	push   %ebp
  8005ce:	89 e5                	mov    %esp,%ebp
  8005d0:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8005d3:	e8 d7 0e 00 00       	call   8014af <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005d8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005db:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005de:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e1:	83 ec 08             	sub    $0x8,%esp
  8005e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e7:	50                   	push   %eax
  8005e8:	e8 ff fe ff ff       	call   8004ec <vcprintf>
  8005ed:	83 c4 10             	add    $0x10,%esp
  8005f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8005f3:	e8 d1 0e 00 00       	call   8014c9 <sys_unlock_cons>
	return cnt;
  8005f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005fb:	c9                   	leave  
  8005fc:	c3                   	ret    

008005fd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005fd:	55                   	push   %ebp
  8005fe:	89 e5                	mov    %esp,%ebp
  800600:	53                   	push   %ebx
  800601:	83 ec 14             	sub    $0x14,%esp
  800604:	8b 45 10             	mov    0x10(%ebp),%eax
  800607:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800610:	8b 45 18             	mov    0x18(%ebp),%eax
  800613:	ba 00 00 00 00       	mov    $0x0,%edx
  800618:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80061b:	77 55                	ja     800672 <printnum+0x75>
  80061d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800620:	72 05                	jb     800627 <printnum+0x2a>
  800622:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800625:	77 4b                	ja     800672 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800627:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80062a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80062d:	8b 45 18             	mov    0x18(%ebp),%eax
  800630:	ba 00 00 00 00       	mov    $0x0,%edx
  800635:	52                   	push   %edx
  800636:	50                   	push   %eax
  800637:	ff 75 f4             	pushl  -0xc(%ebp)
  80063a:	ff 75 f0             	pushl  -0x10(%ebp)
  80063d:	e8 aa 13 00 00       	call   8019ec <__udivdi3>
  800642:	83 c4 10             	add    $0x10,%esp
  800645:	83 ec 04             	sub    $0x4,%esp
  800648:	ff 75 20             	pushl  0x20(%ebp)
  80064b:	53                   	push   %ebx
  80064c:	ff 75 18             	pushl  0x18(%ebp)
  80064f:	52                   	push   %edx
  800650:	50                   	push   %eax
  800651:	ff 75 0c             	pushl  0xc(%ebp)
  800654:	ff 75 08             	pushl  0x8(%ebp)
  800657:	e8 a1 ff ff ff       	call   8005fd <printnum>
  80065c:	83 c4 20             	add    $0x20,%esp
  80065f:	eb 1a                	jmp    80067b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	ff 75 0c             	pushl  0xc(%ebp)
  800667:	ff 75 20             	pushl  0x20(%ebp)
  80066a:	8b 45 08             	mov    0x8(%ebp),%eax
  80066d:	ff d0                	call   *%eax
  80066f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800672:	ff 4d 1c             	decl   0x1c(%ebp)
  800675:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800679:	7f e6                	jg     800661 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80067b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80067e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800683:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800686:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800689:	53                   	push   %ebx
  80068a:	51                   	push   %ecx
  80068b:	52                   	push   %edx
  80068c:	50                   	push   %eax
  80068d:	e8 6a 14 00 00       	call   801afc <__umoddi3>
  800692:	83 c4 10             	add    $0x10,%esp
  800695:	05 54 21 80 00       	add    $0x802154,%eax
  80069a:	8a 00                	mov    (%eax),%al
  80069c:	0f be c0             	movsbl %al,%eax
  80069f:	83 ec 08             	sub    $0x8,%esp
  8006a2:	ff 75 0c             	pushl  0xc(%ebp)
  8006a5:	50                   	push   %eax
  8006a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a9:	ff d0                	call   *%eax
  8006ab:	83 c4 10             	add    $0x10,%esp
}
  8006ae:	90                   	nop
  8006af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006b2:	c9                   	leave  
  8006b3:	c3                   	ret    

008006b4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006b4:	55                   	push   %ebp
  8006b5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006bb:	7e 1c                	jle    8006d9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	8d 50 08             	lea    0x8(%eax),%edx
  8006c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c8:	89 10                	mov    %edx,(%eax)
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	8b 00                	mov    (%eax),%eax
  8006cf:	83 e8 08             	sub    $0x8,%eax
  8006d2:	8b 50 04             	mov    0x4(%eax),%edx
  8006d5:	8b 00                	mov    (%eax),%eax
  8006d7:	eb 40                	jmp    800719 <getuint+0x65>
	else if (lflag)
  8006d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006dd:	74 1e                	je     8006fd <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006df:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	8d 50 04             	lea    0x4(%eax),%edx
  8006e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ea:	89 10                	mov    %edx,(%eax)
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	8b 00                	mov    (%eax),%eax
  8006f1:	83 e8 04             	sub    $0x4,%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fb:	eb 1c                	jmp    800719 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	8b 00                	mov    (%eax),%eax
  800702:	8d 50 04             	lea    0x4(%eax),%edx
  800705:	8b 45 08             	mov    0x8(%ebp),%eax
  800708:	89 10                	mov    %edx,(%eax)
  80070a:	8b 45 08             	mov    0x8(%ebp),%eax
  80070d:	8b 00                	mov    (%eax),%eax
  80070f:	83 e8 04             	sub    $0x4,%eax
  800712:	8b 00                	mov    (%eax),%eax
  800714:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800719:	5d                   	pop    %ebp
  80071a:	c3                   	ret    

0080071b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80071b:	55                   	push   %ebp
  80071c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80071e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800722:	7e 1c                	jle    800740 <getint+0x25>
		return va_arg(*ap, long long);
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	8b 00                	mov    (%eax),%eax
  800729:	8d 50 08             	lea    0x8(%eax),%edx
  80072c:	8b 45 08             	mov    0x8(%ebp),%eax
  80072f:	89 10                	mov    %edx,(%eax)
  800731:	8b 45 08             	mov    0x8(%ebp),%eax
  800734:	8b 00                	mov    (%eax),%eax
  800736:	83 e8 08             	sub    $0x8,%eax
  800739:	8b 50 04             	mov    0x4(%eax),%edx
  80073c:	8b 00                	mov    (%eax),%eax
  80073e:	eb 38                	jmp    800778 <getint+0x5d>
	else if (lflag)
  800740:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800744:	74 1a                	je     800760 <getint+0x45>
		return va_arg(*ap, long);
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	8d 50 04             	lea    0x4(%eax),%edx
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	89 10                	mov    %edx,(%eax)
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	8b 00                	mov    (%eax),%eax
  800758:	83 e8 04             	sub    $0x4,%eax
  80075b:	8b 00                	mov    (%eax),%eax
  80075d:	99                   	cltd   
  80075e:	eb 18                	jmp    800778 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	8b 00                	mov    (%eax),%eax
  800765:	8d 50 04             	lea    0x4(%eax),%edx
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
  80076b:	89 10                	mov    %edx,(%eax)
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	83 e8 04             	sub    $0x4,%eax
  800775:	8b 00                	mov    (%eax),%eax
  800777:	99                   	cltd   
}
  800778:	5d                   	pop    %ebp
  800779:	c3                   	ret    

0080077a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80077a:	55                   	push   %ebp
  80077b:	89 e5                	mov    %esp,%ebp
  80077d:	56                   	push   %esi
  80077e:	53                   	push   %ebx
  80077f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800782:	eb 17                	jmp    80079b <vprintfmt+0x21>
			if (ch == '\0')
  800784:	85 db                	test   %ebx,%ebx
  800786:	0f 84 c1 03 00 00    	je     800b4d <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80078c:	83 ec 08             	sub    $0x8,%esp
  80078f:	ff 75 0c             	pushl  0xc(%ebp)
  800792:	53                   	push   %ebx
  800793:	8b 45 08             	mov    0x8(%ebp),%eax
  800796:	ff d0                	call   *%eax
  800798:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80079b:	8b 45 10             	mov    0x10(%ebp),%eax
  80079e:	8d 50 01             	lea    0x1(%eax),%edx
  8007a1:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a4:	8a 00                	mov    (%eax),%al
  8007a6:	0f b6 d8             	movzbl %al,%ebx
  8007a9:	83 fb 25             	cmp    $0x25,%ebx
  8007ac:	75 d6                	jne    800784 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007ae:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007b2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007b9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007c0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007c7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d1:	8d 50 01             	lea    0x1(%eax),%edx
  8007d4:	89 55 10             	mov    %edx,0x10(%ebp)
  8007d7:	8a 00                	mov    (%eax),%al
  8007d9:	0f b6 d8             	movzbl %al,%ebx
  8007dc:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007df:	83 f8 5b             	cmp    $0x5b,%eax
  8007e2:	0f 87 3d 03 00 00    	ja     800b25 <vprintfmt+0x3ab>
  8007e8:	8b 04 85 78 21 80 00 	mov    0x802178(,%eax,4),%eax
  8007ef:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007f1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007f5:	eb d7                	jmp    8007ce <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007f7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007fb:	eb d1                	jmp    8007ce <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007fd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800804:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800807:	89 d0                	mov    %edx,%eax
  800809:	c1 e0 02             	shl    $0x2,%eax
  80080c:	01 d0                	add    %edx,%eax
  80080e:	01 c0                	add    %eax,%eax
  800810:	01 d8                	add    %ebx,%eax
  800812:	83 e8 30             	sub    $0x30,%eax
  800815:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800818:	8b 45 10             	mov    0x10(%ebp),%eax
  80081b:	8a 00                	mov    (%eax),%al
  80081d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800820:	83 fb 2f             	cmp    $0x2f,%ebx
  800823:	7e 3e                	jle    800863 <vprintfmt+0xe9>
  800825:	83 fb 39             	cmp    $0x39,%ebx
  800828:	7f 39                	jg     800863 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80082a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80082d:	eb d5                	jmp    800804 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80082f:	8b 45 14             	mov    0x14(%ebp),%eax
  800832:	83 c0 04             	add    $0x4,%eax
  800835:	89 45 14             	mov    %eax,0x14(%ebp)
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	83 e8 04             	sub    $0x4,%eax
  80083e:	8b 00                	mov    (%eax),%eax
  800840:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800843:	eb 1f                	jmp    800864 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800845:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800849:	79 83                	jns    8007ce <vprintfmt+0x54>
				width = 0;
  80084b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800852:	e9 77 ff ff ff       	jmp    8007ce <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800857:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80085e:	e9 6b ff ff ff       	jmp    8007ce <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800863:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800864:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800868:	0f 89 60 ff ff ff    	jns    8007ce <vprintfmt+0x54>
				width = precision, precision = -1;
  80086e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800871:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800874:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80087b:	e9 4e ff ff ff       	jmp    8007ce <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800880:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800883:	e9 46 ff ff ff       	jmp    8007ce <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800888:	8b 45 14             	mov    0x14(%ebp),%eax
  80088b:	83 c0 04             	add    $0x4,%eax
  80088e:	89 45 14             	mov    %eax,0x14(%ebp)
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	83 e8 04             	sub    $0x4,%eax
  800897:	8b 00                	mov    (%eax),%eax
  800899:	83 ec 08             	sub    $0x8,%esp
  80089c:	ff 75 0c             	pushl  0xc(%ebp)
  80089f:	50                   	push   %eax
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	ff d0                	call   *%eax
  8008a5:	83 c4 10             	add    $0x10,%esp
			break;
  8008a8:	e9 9b 02 00 00       	jmp    800b48 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b0:	83 c0 04             	add    $0x4,%eax
  8008b3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b9:	83 e8 04             	sub    $0x4,%eax
  8008bc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008be:	85 db                	test   %ebx,%ebx
  8008c0:	79 02                	jns    8008c4 <vprintfmt+0x14a>
				err = -err;
  8008c2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008c4:	83 fb 64             	cmp    $0x64,%ebx
  8008c7:	7f 0b                	jg     8008d4 <vprintfmt+0x15a>
  8008c9:	8b 34 9d c0 1f 80 00 	mov    0x801fc0(,%ebx,4),%esi
  8008d0:	85 f6                	test   %esi,%esi
  8008d2:	75 19                	jne    8008ed <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008d4:	53                   	push   %ebx
  8008d5:	68 65 21 80 00       	push   $0x802165
  8008da:	ff 75 0c             	pushl  0xc(%ebp)
  8008dd:	ff 75 08             	pushl  0x8(%ebp)
  8008e0:	e8 70 02 00 00       	call   800b55 <printfmt>
  8008e5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008e8:	e9 5b 02 00 00       	jmp    800b48 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008ed:	56                   	push   %esi
  8008ee:	68 6e 21 80 00       	push   $0x80216e
  8008f3:	ff 75 0c             	pushl  0xc(%ebp)
  8008f6:	ff 75 08             	pushl  0x8(%ebp)
  8008f9:	e8 57 02 00 00       	call   800b55 <printfmt>
  8008fe:	83 c4 10             	add    $0x10,%esp
			break;
  800901:	e9 42 02 00 00       	jmp    800b48 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800906:	8b 45 14             	mov    0x14(%ebp),%eax
  800909:	83 c0 04             	add    $0x4,%eax
  80090c:	89 45 14             	mov    %eax,0x14(%ebp)
  80090f:	8b 45 14             	mov    0x14(%ebp),%eax
  800912:	83 e8 04             	sub    $0x4,%eax
  800915:	8b 30                	mov    (%eax),%esi
  800917:	85 f6                	test   %esi,%esi
  800919:	75 05                	jne    800920 <vprintfmt+0x1a6>
				p = "(null)";
  80091b:	be 71 21 80 00       	mov    $0x802171,%esi
			if (width > 0 && padc != '-')
  800920:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800924:	7e 6d                	jle    800993 <vprintfmt+0x219>
  800926:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80092a:	74 67                	je     800993 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80092c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092f:	83 ec 08             	sub    $0x8,%esp
  800932:	50                   	push   %eax
  800933:	56                   	push   %esi
  800934:	e8 1e 03 00 00       	call   800c57 <strnlen>
  800939:	83 c4 10             	add    $0x10,%esp
  80093c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80093f:	eb 16                	jmp    800957 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800941:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800945:	83 ec 08             	sub    $0x8,%esp
  800948:	ff 75 0c             	pushl  0xc(%ebp)
  80094b:	50                   	push   %eax
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	ff d0                	call   *%eax
  800951:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800954:	ff 4d e4             	decl   -0x1c(%ebp)
  800957:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095b:	7f e4                	jg     800941 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80095d:	eb 34                	jmp    800993 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80095f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800963:	74 1c                	je     800981 <vprintfmt+0x207>
  800965:	83 fb 1f             	cmp    $0x1f,%ebx
  800968:	7e 05                	jle    80096f <vprintfmt+0x1f5>
  80096a:	83 fb 7e             	cmp    $0x7e,%ebx
  80096d:	7e 12                	jle    800981 <vprintfmt+0x207>
					putch('?', putdat);
  80096f:	83 ec 08             	sub    $0x8,%esp
  800972:	ff 75 0c             	pushl  0xc(%ebp)
  800975:	6a 3f                	push   $0x3f
  800977:	8b 45 08             	mov    0x8(%ebp),%eax
  80097a:	ff d0                	call   *%eax
  80097c:	83 c4 10             	add    $0x10,%esp
  80097f:	eb 0f                	jmp    800990 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800981:	83 ec 08             	sub    $0x8,%esp
  800984:	ff 75 0c             	pushl  0xc(%ebp)
  800987:	53                   	push   %ebx
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	ff d0                	call   *%eax
  80098d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800990:	ff 4d e4             	decl   -0x1c(%ebp)
  800993:	89 f0                	mov    %esi,%eax
  800995:	8d 70 01             	lea    0x1(%eax),%esi
  800998:	8a 00                	mov    (%eax),%al
  80099a:	0f be d8             	movsbl %al,%ebx
  80099d:	85 db                	test   %ebx,%ebx
  80099f:	74 24                	je     8009c5 <vprintfmt+0x24b>
  8009a1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009a5:	78 b8                	js     80095f <vprintfmt+0x1e5>
  8009a7:	ff 4d e0             	decl   -0x20(%ebp)
  8009aa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ae:	79 af                	jns    80095f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009b0:	eb 13                	jmp    8009c5 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009b2:	83 ec 08             	sub    $0x8,%esp
  8009b5:	ff 75 0c             	pushl  0xc(%ebp)
  8009b8:	6a 20                	push   $0x20
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	ff d0                	call   *%eax
  8009bf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009c2:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c9:	7f e7                	jg     8009b2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009cb:	e9 78 01 00 00       	jmp    800b48 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009d0:	83 ec 08             	sub    $0x8,%esp
  8009d3:	ff 75 e8             	pushl  -0x18(%ebp)
  8009d6:	8d 45 14             	lea    0x14(%ebp),%eax
  8009d9:	50                   	push   %eax
  8009da:	e8 3c fd ff ff       	call   80071b <getint>
  8009df:	83 c4 10             	add    $0x10,%esp
  8009e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ee:	85 d2                	test   %edx,%edx
  8009f0:	79 23                	jns    800a15 <vprintfmt+0x29b>
				putch('-', putdat);
  8009f2:	83 ec 08             	sub    $0x8,%esp
  8009f5:	ff 75 0c             	pushl  0xc(%ebp)
  8009f8:	6a 2d                	push   $0x2d
  8009fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fd:	ff d0                	call   *%eax
  8009ff:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a08:	f7 d8                	neg    %eax
  800a0a:	83 d2 00             	adc    $0x0,%edx
  800a0d:	f7 da                	neg    %edx
  800a0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a12:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a15:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a1c:	e9 bc 00 00 00       	jmp    800add <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a21:	83 ec 08             	sub    $0x8,%esp
  800a24:	ff 75 e8             	pushl  -0x18(%ebp)
  800a27:	8d 45 14             	lea    0x14(%ebp),%eax
  800a2a:	50                   	push   %eax
  800a2b:	e8 84 fc ff ff       	call   8006b4 <getuint>
  800a30:	83 c4 10             	add    $0x10,%esp
  800a33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a36:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a39:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a40:	e9 98 00 00 00       	jmp    800add <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a45:	83 ec 08             	sub    $0x8,%esp
  800a48:	ff 75 0c             	pushl  0xc(%ebp)
  800a4b:	6a 58                	push   $0x58
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	ff d0                	call   *%eax
  800a52:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a55:	83 ec 08             	sub    $0x8,%esp
  800a58:	ff 75 0c             	pushl  0xc(%ebp)
  800a5b:	6a 58                	push   $0x58
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	ff d0                	call   *%eax
  800a62:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a65:	83 ec 08             	sub    $0x8,%esp
  800a68:	ff 75 0c             	pushl  0xc(%ebp)
  800a6b:	6a 58                	push   $0x58
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	ff d0                	call   *%eax
  800a72:	83 c4 10             	add    $0x10,%esp
			break;
  800a75:	e9 ce 00 00 00       	jmp    800b48 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a7a:	83 ec 08             	sub    $0x8,%esp
  800a7d:	ff 75 0c             	pushl  0xc(%ebp)
  800a80:	6a 30                	push   $0x30
  800a82:	8b 45 08             	mov    0x8(%ebp),%eax
  800a85:	ff d0                	call   *%eax
  800a87:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a8a:	83 ec 08             	sub    $0x8,%esp
  800a8d:	ff 75 0c             	pushl  0xc(%ebp)
  800a90:	6a 78                	push   $0x78
  800a92:	8b 45 08             	mov    0x8(%ebp),%eax
  800a95:	ff d0                	call   *%eax
  800a97:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9d:	83 c0 04             	add    $0x4,%eax
  800aa0:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa6:	83 e8 04             	sub    $0x4,%eax
  800aa9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800aab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ab5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800abc:	eb 1f                	jmp    800add <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800abe:	83 ec 08             	sub    $0x8,%esp
  800ac1:	ff 75 e8             	pushl  -0x18(%ebp)
  800ac4:	8d 45 14             	lea    0x14(%ebp),%eax
  800ac7:	50                   	push   %eax
  800ac8:	e8 e7 fb ff ff       	call   8006b4 <getuint>
  800acd:	83 c4 10             	add    $0x10,%esp
  800ad0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ad6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800add:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ae1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ae4:	83 ec 04             	sub    $0x4,%esp
  800ae7:	52                   	push   %edx
  800ae8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800aeb:	50                   	push   %eax
  800aec:	ff 75 f4             	pushl  -0xc(%ebp)
  800aef:	ff 75 f0             	pushl  -0x10(%ebp)
  800af2:	ff 75 0c             	pushl  0xc(%ebp)
  800af5:	ff 75 08             	pushl  0x8(%ebp)
  800af8:	e8 00 fb ff ff       	call   8005fd <printnum>
  800afd:	83 c4 20             	add    $0x20,%esp
			break;
  800b00:	eb 46                	jmp    800b48 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b02:	83 ec 08             	sub    $0x8,%esp
  800b05:	ff 75 0c             	pushl  0xc(%ebp)
  800b08:	53                   	push   %ebx
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	ff d0                	call   *%eax
  800b0e:	83 c4 10             	add    $0x10,%esp
			break;
  800b11:	eb 35                	jmp    800b48 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b13:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b1a:	eb 2c                	jmp    800b48 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b1c:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b23:	eb 23                	jmp    800b48 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b25:	83 ec 08             	sub    $0x8,%esp
  800b28:	ff 75 0c             	pushl  0xc(%ebp)
  800b2b:	6a 25                	push   $0x25
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	ff d0                	call   *%eax
  800b32:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b35:	ff 4d 10             	decl   0x10(%ebp)
  800b38:	eb 03                	jmp    800b3d <vprintfmt+0x3c3>
  800b3a:	ff 4d 10             	decl   0x10(%ebp)
  800b3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b40:	48                   	dec    %eax
  800b41:	8a 00                	mov    (%eax),%al
  800b43:	3c 25                	cmp    $0x25,%al
  800b45:	75 f3                	jne    800b3a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b47:	90                   	nop
		}
	}
  800b48:	e9 35 fc ff ff       	jmp    800782 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b4d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b51:	5b                   	pop    %ebx
  800b52:	5e                   	pop    %esi
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b5b:	8d 45 10             	lea    0x10(%ebp),%eax
  800b5e:	83 c0 04             	add    $0x4,%eax
  800b61:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b64:	8b 45 10             	mov    0x10(%ebp),%eax
  800b67:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6a:	50                   	push   %eax
  800b6b:	ff 75 0c             	pushl  0xc(%ebp)
  800b6e:	ff 75 08             	pushl  0x8(%ebp)
  800b71:	e8 04 fc ff ff       	call   80077a <vprintfmt>
  800b76:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b79:	90                   	nop
  800b7a:	c9                   	leave  
  800b7b:	c3                   	ret    

00800b7c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b82:	8b 40 08             	mov    0x8(%eax),%eax
  800b85:	8d 50 01             	lea    0x1(%eax),%edx
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b91:	8b 10                	mov    (%eax),%edx
  800b93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b96:	8b 40 04             	mov    0x4(%eax),%eax
  800b99:	39 c2                	cmp    %eax,%edx
  800b9b:	73 12                	jae    800baf <sprintputch+0x33>
		*b->buf++ = ch;
  800b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba0:	8b 00                	mov    (%eax),%eax
  800ba2:	8d 48 01             	lea    0x1(%eax),%ecx
  800ba5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba8:	89 0a                	mov    %ecx,(%edx)
  800baa:	8b 55 08             	mov    0x8(%ebp),%edx
  800bad:	88 10                	mov    %dl,(%eax)
}
  800baf:	90                   	nop
  800bb0:	5d                   	pop    %ebp
  800bb1:	c3                   	ret    

00800bb2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc7:	01 d0                	add    %edx,%eax
  800bc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bd3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bd7:	74 06                	je     800bdf <vsnprintf+0x2d>
  800bd9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bdd:	7f 07                	jg     800be6 <vsnprintf+0x34>
		return -E_INVAL;
  800bdf:	b8 03 00 00 00       	mov    $0x3,%eax
  800be4:	eb 20                	jmp    800c06 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800be6:	ff 75 14             	pushl  0x14(%ebp)
  800be9:	ff 75 10             	pushl  0x10(%ebp)
  800bec:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bef:	50                   	push   %eax
  800bf0:	68 7c 0b 80 00       	push   $0x800b7c
  800bf5:	e8 80 fb ff ff       	call   80077a <vprintfmt>
  800bfa:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c00:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c06:	c9                   	leave  
  800c07:	c3                   	ret    

00800c08 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c08:	55                   	push   %ebp
  800c09:	89 e5                	mov    %esp,%ebp
  800c0b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c0e:	8d 45 10             	lea    0x10(%ebp),%eax
  800c11:	83 c0 04             	add    $0x4,%eax
  800c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c17:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c1d:	50                   	push   %eax
  800c1e:	ff 75 0c             	pushl  0xc(%ebp)
  800c21:	ff 75 08             	pushl  0x8(%ebp)
  800c24:	e8 89 ff ff ff       	call   800bb2 <vsnprintf>
  800c29:	83 c4 10             	add    $0x10,%esp
  800c2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c32:	c9                   	leave  
  800c33:	c3                   	ret    

00800c34 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c41:	eb 06                	jmp    800c49 <strlen+0x15>
		n++;
  800c43:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c46:	ff 45 08             	incl   0x8(%ebp)
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	8a 00                	mov    (%eax),%al
  800c4e:	84 c0                	test   %al,%al
  800c50:	75 f1                	jne    800c43 <strlen+0xf>
		n++;
	return n;
  800c52:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c55:	c9                   	leave  
  800c56:	c3                   	ret    

00800c57 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c5d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c64:	eb 09                	jmp    800c6f <strnlen+0x18>
		n++;
  800c66:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c69:	ff 45 08             	incl   0x8(%ebp)
  800c6c:	ff 4d 0c             	decl   0xc(%ebp)
  800c6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c73:	74 09                	je     800c7e <strnlen+0x27>
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	8a 00                	mov    (%eax),%al
  800c7a:	84 c0                	test   %al,%al
  800c7c:	75 e8                	jne    800c66 <strnlen+0xf>
		n++;
	return n;
  800c7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

00800c83 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c8f:	90                   	nop
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8d 50 01             	lea    0x1(%eax),%edx
  800c96:	89 55 08             	mov    %edx,0x8(%ebp)
  800c99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c9f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ca2:	8a 12                	mov    (%edx),%dl
  800ca4:	88 10                	mov    %dl,(%eax)
  800ca6:	8a 00                	mov    (%eax),%al
  800ca8:	84 c0                	test   %al,%al
  800caa:	75 e4                	jne    800c90 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800caf:	c9                   	leave  
  800cb0:	c3                   	ret    

00800cb1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cc4:	eb 1f                	jmp    800ce5 <strncpy+0x34>
		*dst++ = *src;
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	8d 50 01             	lea    0x1(%eax),%edx
  800ccc:	89 55 08             	mov    %edx,0x8(%ebp)
  800ccf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd2:	8a 12                	mov    (%edx),%dl
  800cd4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd9:	8a 00                	mov    (%eax),%al
  800cdb:	84 c0                	test   %al,%al
  800cdd:	74 03                	je     800ce2 <strncpy+0x31>
			src++;
  800cdf:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ce2:	ff 45 fc             	incl   -0x4(%ebp)
  800ce5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ceb:	72 d9                	jb     800cc6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ced:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cf0:	c9                   	leave  
  800cf1:	c3                   	ret    

00800cf2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cfe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d02:	74 30                	je     800d34 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d04:	eb 16                	jmp    800d1c <strlcpy+0x2a>
			*dst++ = *src++;
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	8d 50 01             	lea    0x1(%eax),%edx
  800d0c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d12:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d15:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d18:	8a 12                	mov    (%edx),%dl
  800d1a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d1c:	ff 4d 10             	decl   0x10(%ebp)
  800d1f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d23:	74 09                	je     800d2e <strlcpy+0x3c>
  800d25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d28:	8a 00                	mov    (%eax),%al
  800d2a:	84 c0                	test   %al,%al
  800d2c:	75 d8                	jne    800d06 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d34:	8b 55 08             	mov    0x8(%ebp),%edx
  800d37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d3a:	29 c2                	sub    %eax,%edx
  800d3c:	89 d0                	mov    %edx,%eax
}
  800d3e:	c9                   	leave  
  800d3f:	c3                   	ret    

00800d40 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d43:	eb 06                	jmp    800d4b <strcmp+0xb>
		p++, q++;
  800d45:	ff 45 08             	incl   0x8(%ebp)
  800d48:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8a 00                	mov    (%eax),%al
  800d50:	84 c0                	test   %al,%al
  800d52:	74 0e                	je     800d62 <strcmp+0x22>
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	8a 10                	mov    (%eax),%dl
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	38 c2                	cmp    %al,%dl
  800d60:	74 e3                	je     800d45 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	0f b6 d0             	movzbl %al,%edx
  800d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	0f b6 c0             	movzbl %al,%eax
  800d72:	29 c2                	sub    %eax,%edx
  800d74:	89 d0                	mov    %edx,%eax
}
  800d76:	5d                   	pop    %ebp
  800d77:	c3                   	ret    

00800d78 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d7b:	eb 09                	jmp    800d86 <strncmp+0xe>
		n--, p++, q++;
  800d7d:	ff 4d 10             	decl   0x10(%ebp)
  800d80:	ff 45 08             	incl   0x8(%ebp)
  800d83:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d86:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d8a:	74 17                	je     800da3 <strncmp+0x2b>
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	84 c0                	test   %al,%al
  800d93:	74 0e                	je     800da3 <strncmp+0x2b>
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8a 10                	mov    (%eax),%dl
  800d9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9d:	8a 00                	mov    (%eax),%al
  800d9f:	38 c2                	cmp    %al,%dl
  800da1:	74 da                	je     800d7d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800da3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da7:	75 07                	jne    800db0 <strncmp+0x38>
		return 0;
  800da9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dae:	eb 14                	jmp    800dc4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	8a 00                	mov    (%eax),%al
  800db5:	0f b6 d0             	movzbl %al,%edx
  800db8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbb:	8a 00                	mov    (%eax),%al
  800dbd:	0f b6 c0             	movzbl %al,%eax
  800dc0:	29 c2                	sub    %eax,%edx
  800dc2:	89 d0                	mov    %edx,%eax
}
  800dc4:	5d                   	pop    %ebp
  800dc5:	c3                   	ret    

00800dc6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	83 ec 04             	sub    $0x4,%esp
  800dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dd2:	eb 12                	jmp    800de6 <strchr+0x20>
		if (*s == c)
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ddc:	75 05                	jne    800de3 <strchr+0x1d>
			return (char *) s;
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	eb 11                	jmp    800df4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800de3:	ff 45 08             	incl   0x8(%ebp)
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	8a 00                	mov    (%eax),%al
  800deb:	84 c0                	test   %al,%al
  800ded:	75 e5                	jne    800dd4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800def:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800df4:	c9                   	leave  
  800df5:	c3                   	ret    

00800df6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
  800df9:	83 ec 04             	sub    $0x4,%esp
  800dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dff:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e02:	eb 0d                	jmp    800e11 <strfind+0x1b>
		if (*s == c)
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	8a 00                	mov    (%eax),%al
  800e09:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e0c:	74 0e                	je     800e1c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e0e:	ff 45 08             	incl   0x8(%ebp)
  800e11:	8b 45 08             	mov    0x8(%ebp),%eax
  800e14:	8a 00                	mov    (%eax),%al
  800e16:	84 c0                	test   %al,%al
  800e18:	75 ea                	jne    800e04 <strfind+0xe>
  800e1a:	eb 01                	jmp    800e1d <strfind+0x27>
		if (*s == c)
			break;
  800e1c:	90                   	nop
	return (char *) s;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e20:	c9                   	leave  
  800e21:	c3                   	ret    

00800e22 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800e2e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e32:	76 63                	jbe    800e97 <memset+0x75>
		uint64 data_block = c;
  800e34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e37:	99                   	cltd   
  800e38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e44:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800e48:	c1 e0 08             	shl    $0x8,%eax
  800e4b:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e4e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e57:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800e5b:	c1 e0 10             	shl    $0x10,%eax
  800e5e:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e61:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e6a:	89 c2                	mov    %eax,%edx
  800e6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e71:	09 45 f0             	or     %eax,-0x10(%ebp)
  800e74:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800e77:	eb 18                	jmp    800e91 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800e79:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800e7c:	8d 41 08             	lea    0x8(%ecx),%eax
  800e7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e88:	89 01                	mov    %eax,(%ecx)
  800e8a:	89 51 04             	mov    %edx,0x4(%ecx)
  800e8d:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800e91:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800e95:	77 e2                	ja     800e79 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800e97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9b:	74 23                	je     800ec0 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800e9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ea3:	eb 0e                	jmp    800eb3 <memset+0x91>
			*p8++ = (uint8)c;
  800ea5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea8:	8d 50 01             	lea    0x1(%eax),%edx
  800eab:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb1:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800eb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb9:	89 55 10             	mov    %edx,0x10(%ebp)
  800ebc:	85 c0                	test   %eax,%eax
  800ebe:	75 e5                	jne    800ea5 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec3:	c9                   	leave  
  800ec4:	c3                   	ret    

00800ec5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ece:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800ed7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800edb:	76 24                	jbe    800f01 <memcpy+0x3c>
		while(n >= 8){
  800edd:	eb 1c                	jmp    800efb <memcpy+0x36>
			*d64 = *s64;
  800edf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee2:	8b 50 04             	mov    0x4(%eax),%edx
  800ee5:	8b 00                	mov    (%eax),%eax
  800ee7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800eea:	89 01                	mov    %eax,(%ecx)
  800eec:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800eef:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800ef3:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800ef7:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800efb:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800eff:	77 de                	ja     800edf <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f05:	74 31                	je     800f38 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f10:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f13:	eb 16                	jmp    800f2b <memcpy+0x66>
			*d8++ = *s8++;
  800f15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f18:	8d 50 01             	lea    0x1(%eax),%edx
  800f1b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f21:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f24:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800f27:	8a 12                	mov    (%edx),%dl
  800f29:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800f2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f31:	89 55 10             	mov    %edx,0x10(%ebp)
  800f34:	85 c0                	test   %eax,%eax
  800f36:	75 dd                	jne    800f15 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3b:	c9                   	leave  
  800f3c:	c3                   	ret    

00800f3d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f52:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f55:	73 50                	jae    800fa7 <memmove+0x6a>
  800f57:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5d:	01 d0                	add    %edx,%eax
  800f5f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f62:	76 43                	jbe    800fa7 <memmove+0x6a>
		s += n;
  800f64:	8b 45 10             	mov    0x10(%ebp),%eax
  800f67:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f70:	eb 10                	jmp    800f82 <memmove+0x45>
			*--d = *--s;
  800f72:	ff 4d f8             	decl   -0x8(%ebp)
  800f75:	ff 4d fc             	decl   -0x4(%ebp)
  800f78:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f7b:	8a 10                	mov    (%eax),%dl
  800f7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f80:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f82:	8b 45 10             	mov    0x10(%ebp),%eax
  800f85:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f88:	89 55 10             	mov    %edx,0x10(%ebp)
  800f8b:	85 c0                	test   %eax,%eax
  800f8d:	75 e3                	jne    800f72 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f8f:	eb 23                	jmp    800fb4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f94:	8d 50 01             	lea    0x1(%eax),%edx
  800f97:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f9a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f9d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fa0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fa3:	8a 12                	mov    (%edx),%dl
  800fa5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fa7:	8b 45 10             	mov    0x10(%ebp),%eax
  800faa:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fad:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb0:	85 c0                	test   %eax,%eax
  800fb2:	75 dd                	jne    800f91 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb7:	c9                   	leave  
  800fb8:	c3                   	ret    

00800fb9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fb9:	55                   	push   %ebp
  800fba:	89 e5                	mov    %esp,%ebp
  800fbc:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fcb:	eb 2a                	jmp    800ff7 <memcmp+0x3e>
		if (*s1 != *s2)
  800fcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd0:	8a 10                	mov    (%eax),%dl
  800fd2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	38 c2                	cmp    %al,%dl
  800fd9:	74 16                	je     800ff1 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	0f b6 d0             	movzbl %al,%edx
  800fe3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	0f b6 c0             	movzbl %al,%eax
  800feb:	29 c2                	sub    %eax,%edx
  800fed:	89 d0                	mov    %edx,%eax
  800fef:	eb 18                	jmp    801009 <memcmp+0x50>
		s1++, s2++;
  800ff1:	ff 45 fc             	incl   -0x4(%ebp)
  800ff4:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ff7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffa:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ffd:	89 55 10             	mov    %edx,0x10(%ebp)
  801000:	85 c0                	test   %eax,%eax
  801002:	75 c9                	jne    800fcd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801004:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801009:	c9                   	leave  
  80100a:	c3                   	ret    

0080100b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80100b:	55                   	push   %ebp
  80100c:	89 e5                	mov    %esp,%ebp
  80100e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801011:	8b 55 08             	mov    0x8(%ebp),%edx
  801014:	8b 45 10             	mov    0x10(%ebp),%eax
  801017:	01 d0                	add    %edx,%eax
  801019:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80101c:	eb 15                	jmp    801033 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	0f b6 d0             	movzbl %al,%edx
  801026:	8b 45 0c             	mov    0xc(%ebp),%eax
  801029:	0f b6 c0             	movzbl %al,%eax
  80102c:	39 c2                	cmp    %eax,%edx
  80102e:	74 0d                	je     80103d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801030:	ff 45 08             	incl   0x8(%ebp)
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801039:	72 e3                	jb     80101e <memfind+0x13>
  80103b:	eb 01                	jmp    80103e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80103d:	90                   	nop
	return (void *) s;
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801041:	c9                   	leave  
  801042:	c3                   	ret    

00801043 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801043:	55                   	push   %ebp
  801044:	89 e5                	mov    %esp,%ebp
  801046:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801049:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801050:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801057:	eb 03                	jmp    80105c <strtol+0x19>
		s++;
  801059:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	3c 20                	cmp    $0x20,%al
  801063:	74 f4                	je     801059 <strtol+0x16>
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	3c 09                	cmp    $0x9,%al
  80106c:	74 eb                	je     801059 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	8a 00                	mov    (%eax),%al
  801073:	3c 2b                	cmp    $0x2b,%al
  801075:	75 05                	jne    80107c <strtol+0x39>
		s++;
  801077:	ff 45 08             	incl   0x8(%ebp)
  80107a:	eb 13                	jmp    80108f <strtol+0x4c>
	else if (*s == '-')
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	8a 00                	mov    (%eax),%al
  801081:	3c 2d                	cmp    $0x2d,%al
  801083:	75 0a                	jne    80108f <strtol+0x4c>
		s++, neg = 1;
  801085:	ff 45 08             	incl   0x8(%ebp)
  801088:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80108f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801093:	74 06                	je     80109b <strtol+0x58>
  801095:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801099:	75 20                	jne    8010bb <strtol+0x78>
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	8a 00                	mov    (%eax),%al
  8010a0:	3c 30                	cmp    $0x30,%al
  8010a2:	75 17                	jne    8010bb <strtol+0x78>
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	40                   	inc    %eax
  8010a8:	8a 00                	mov    (%eax),%al
  8010aa:	3c 78                	cmp    $0x78,%al
  8010ac:	75 0d                	jne    8010bb <strtol+0x78>
		s += 2, base = 16;
  8010ae:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010b2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010b9:	eb 28                	jmp    8010e3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010bf:	75 15                	jne    8010d6 <strtol+0x93>
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	3c 30                	cmp    $0x30,%al
  8010c8:	75 0c                	jne    8010d6 <strtol+0x93>
		s++, base = 8;
  8010ca:	ff 45 08             	incl   0x8(%ebp)
  8010cd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010d4:	eb 0d                	jmp    8010e3 <strtol+0xa0>
	else if (base == 0)
  8010d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010da:	75 07                	jne    8010e3 <strtol+0xa0>
		base = 10;
  8010dc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	3c 2f                	cmp    $0x2f,%al
  8010ea:	7e 19                	jle    801105 <strtol+0xc2>
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	3c 39                	cmp    $0x39,%al
  8010f3:	7f 10                	jg     801105 <strtol+0xc2>
			dig = *s - '0';
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	8a 00                	mov    (%eax),%al
  8010fa:	0f be c0             	movsbl %al,%eax
  8010fd:	83 e8 30             	sub    $0x30,%eax
  801100:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801103:	eb 42                	jmp    801147 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	8a 00                	mov    (%eax),%al
  80110a:	3c 60                	cmp    $0x60,%al
  80110c:	7e 19                	jle    801127 <strtol+0xe4>
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	3c 7a                	cmp    $0x7a,%al
  801115:	7f 10                	jg     801127 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	0f be c0             	movsbl %al,%eax
  80111f:	83 e8 57             	sub    $0x57,%eax
  801122:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801125:	eb 20                	jmp    801147 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
  80112a:	8a 00                	mov    (%eax),%al
  80112c:	3c 40                	cmp    $0x40,%al
  80112e:	7e 39                	jle    801169 <strtol+0x126>
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	8a 00                	mov    (%eax),%al
  801135:	3c 5a                	cmp    $0x5a,%al
  801137:	7f 30                	jg     801169 <strtol+0x126>
			dig = *s - 'A' + 10;
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8a 00                	mov    (%eax),%al
  80113e:	0f be c0             	movsbl %al,%eax
  801141:	83 e8 37             	sub    $0x37,%eax
  801144:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80114a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80114d:	7d 19                	jge    801168 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80114f:	ff 45 08             	incl   0x8(%ebp)
  801152:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801155:	0f af 45 10          	imul   0x10(%ebp),%eax
  801159:	89 c2                	mov    %eax,%edx
  80115b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80115e:	01 d0                	add    %edx,%eax
  801160:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801163:	e9 7b ff ff ff       	jmp    8010e3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801168:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801169:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80116d:	74 08                	je     801177 <strtol+0x134>
		*endptr = (char *) s;
  80116f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801172:	8b 55 08             	mov    0x8(%ebp),%edx
  801175:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801177:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80117b:	74 07                	je     801184 <strtol+0x141>
  80117d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801180:	f7 d8                	neg    %eax
  801182:	eb 03                	jmp    801187 <strtol+0x144>
  801184:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801187:	c9                   	leave  
  801188:	c3                   	ret    

00801189 <ltostr>:

void
ltostr(long value, char *str)
{
  801189:	55                   	push   %ebp
  80118a:	89 e5                	mov    %esp,%ebp
  80118c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80118f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801196:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80119d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011a1:	79 13                	jns    8011b6 <ltostr+0x2d>
	{
		neg = 1;
  8011a3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ad:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011b0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011b3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011be:	99                   	cltd   
  8011bf:	f7 f9                	idiv   %ecx
  8011c1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ca:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011cd:	89 c2                	mov    %eax,%edx
  8011cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d2:	01 d0                	add    %edx,%eax
  8011d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011d7:	83 c2 30             	add    $0x30,%edx
  8011da:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011df:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011e4:	f7 e9                	imul   %ecx
  8011e6:	c1 fa 02             	sar    $0x2,%edx
  8011e9:	89 c8                	mov    %ecx,%eax
  8011eb:	c1 f8 1f             	sar    $0x1f,%eax
  8011ee:	29 c2                	sub    %eax,%edx
  8011f0:	89 d0                	mov    %edx,%eax
  8011f2:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8011f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011f9:	75 bb                	jne    8011b6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801202:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801205:	48                   	dec    %eax
  801206:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801209:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80120d:	74 3d                	je     80124c <ltostr+0xc3>
		start = 1 ;
  80120f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801216:	eb 34                	jmp    80124c <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801218:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80121b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121e:	01 d0                	add    %edx,%eax
  801220:	8a 00                	mov    (%eax),%al
  801222:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801225:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122b:	01 c2                	add    %eax,%edx
  80122d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801230:	8b 45 0c             	mov    0xc(%ebp),%eax
  801233:	01 c8                	add    %ecx,%eax
  801235:	8a 00                	mov    (%eax),%al
  801237:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801239:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80123c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123f:	01 c2                	add    %eax,%edx
  801241:	8a 45 eb             	mov    -0x15(%ebp),%al
  801244:	88 02                	mov    %al,(%edx)
		start++ ;
  801246:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801249:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80124c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801252:	7c c4                	jl     801218 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801254:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125a:	01 d0                	add    %edx,%eax
  80125c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80125f:	90                   	nop
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801268:	ff 75 08             	pushl  0x8(%ebp)
  80126b:	e8 c4 f9 ff ff       	call   800c34 <strlen>
  801270:	83 c4 04             	add    $0x4,%esp
  801273:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801276:	ff 75 0c             	pushl  0xc(%ebp)
  801279:	e8 b6 f9 ff ff       	call   800c34 <strlen>
  80127e:	83 c4 04             	add    $0x4,%esp
  801281:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801284:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80128b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801292:	eb 17                	jmp    8012ab <strcconcat+0x49>
		final[s] = str1[s] ;
  801294:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801297:	8b 45 10             	mov    0x10(%ebp),%eax
  80129a:	01 c2                	add    %eax,%edx
  80129c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80129f:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a2:	01 c8                	add    %ecx,%eax
  8012a4:	8a 00                	mov    (%eax),%al
  8012a6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012a8:	ff 45 fc             	incl   -0x4(%ebp)
  8012ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ae:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012b1:	7c e1                	jl     801294 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012b3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012ba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012c1:	eb 1f                	jmp    8012e2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c6:	8d 50 01             	lea    0x1(%eax),%edx
  8012c9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012cc:	89 c2                	mov    %eax,%edx
  8012ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d1:	01 c2                	add    %eax,%edx
  8012d3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d9:	01 c8                	add    %ecx,%eax
  8012db:	8a 00                	mov    (%eax),%al
  8012dd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012df:	ff 45 f8             	incl   -0x8(%ebp)
  8012e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012e8:	7c d9                	jl     8012c3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f0:	01 d0                	add    %edx,%eax
  8012f2:	c6 00 00             	movb   $0x0,(%eax)
}
  8012f5:	90                   	nop
  8012f6:	c9                   	leave  
  8012f7:	c3                   	ret    

008012f8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801304:	8b 45 14             	mov    0x14(%ebp),%eax
  801307:	8b 00                	mov    (%eax),%eax
  801309:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801310:	8b 45 10             	mov    0x10(%ebp),%eax
  801313:	01 d0                	add    %edx,%eax
  801315:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80131b:	eb 0c                	jmp    801329 <strsplit+0x31>
			*string++ = 0;
  80131d:	8b 45 08             	mov    0x8(%ebp),%eax
  801320:	8d 50 01             	lea    0x1(%eax),%edx
  801323:	89 55 08             	mov    %edx,0x8(%ebp)
  801326:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8a 00                	mov    (%eax),%al
  80132e:	84 c0                	test   %al,%al
  801330:	74 18                	je     80134a <strsplit+0x52>
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	8a 00                	mov    (%eax),%al
  801337:	0f be c0             	movsbl %al,%eax
  80133a:	50                   	push   %eax
  80133b:	ff 75 0c             	pushl  0xc(%ebp)
  80133e:	e8 83 fa ff ff       	call   800dc6 <strchr>
  801343:	83 c4 08             	add    $0x8,%esp
  801346:	85 c0                	test   %eax,%eax
  801348:	75 d3                	jne    80131d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	8a 00                	mov    (%eax),%al
  80134f:	84 c0                	test   %al,%al
  801351:	74 5a                	je     8013ad <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801353:	8b 45 14             	mov    0x14(%ebp),%eax
  801356:	8b 00                	mov    (%eax),%eax
  801358:	83 f8 0f             	cmp    $0xf,%eax
  80135b:	75 07                	jne    801364 <strsplit+0x6c>
		{
			return 0;
  80135d:	b8 00 00 00 00       	mov    $0x0,%eax
  801362:	eb 66                	jmp    8013ca <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801364:	8b 45 14             	mov    0x14(%ebp),%eax
  801367:	8b 00                	mov    (%eax),%eax
  801369:	8d 48 01             	lea    0x1(%eax),%ecx
  80136c:	8b 55 14             	mov    0x14(%ebp),%edx
  80136f:	89 0a                	mov    %ecx,(%edx)
  801371:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801378:	8b 45 10             	mov    0x10(%ebp),%eax
  80137b:	01 c2                	add    %eax,%edx
  80137d:	8b 45 08             	mov    0x8(%ebp),%eax
  801380:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801382:	eb 03                	jmp    801387 <strsplit+0x8f>
			string++;
  801384:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	84 c0                	test   %al,%al
  80138e:	74 8b                	je     80131b <strsplit+0x23>
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	0f be c0             	movsbl %al,%eax
  801398:	50                   	push   %eax
  801399:	ff 75 0c             	pushl  0xc(%ebp)
  80139c:	e8 25 fa ff ff       	call   800dc6 <strchr>
  8013a1:	83 c4 08             	add    $0x8,%esp
  8013a4:	85 c0                	test   %eax,%eax
  8013a6:	74 dc                	je     801384 <strsplit+0x8c>
			string++;
	}
  8013a8:	e9 6e ff ff ff       	jmp    80131b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013ad:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b1:	8b 00                	mov    (%eax),%eax
  8013b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bd:	01 d0                	add    %edx,%eax
  8013bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013c5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013ca:	c9                   	leave  
  8013cb:	c3                   	ret    

008013cc <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
  8013cf:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8013d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8013d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013df:	eb 4a                	jmp    80142b <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8013e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	01 c2                	add    %eax,%edx
  8013e9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ef:	01 c8                	add    %ecx,%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8013f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fb:	01 d0                	add    %edx,%eax
  8013fd:	8a 00                	mov    (%eax),%al
  8013ff:	3c 40                	cmp    $0x40,%al
  801401:	7e 25                	jle    801428 <str2lower+0x5c>
  801403:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801406:	8b 45 0c             	mov    0xc(%ebp),%eax
  801409:	01 d0                	add    %edx,%eax
  80140b:	8a 00                	mov    (%eax),%al
  80140d:	3c 5a                	cmp    $0x5a,%al
  80140f:	7f 17                	jg     801428 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801411:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	01 d0                	add    %edx,%eax
  801419:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80141c:	8b 55 08             	mov    0x8(%ebp),%edx
  80141f:	01 ca                	add    %ecx,%edx
  801421:	8a 12                	mov    (%edx),%dl
  801423:	83 c2 20             	add    $0x20,%edx
  801426:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801428:	ff 45 fc             	incl   -0x4(%ebp)
  80142b:	ff 75 0c             	pushl  0xc(%ebp)
  80142e:	e8 01 f8 ff ff       	call   800c34 <strlen>
  801433:	83 c4 04             	add    $0x4,%esp
  801436:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801439:	7f a6                	jg     8013e1 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80143b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    

00801440 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
  801443:	57                   	push   %edi
  801444:	56                   	push   %esi
  801445:	53                   	push   %ebx
  801446:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801452:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801455:	8b 7d 18             	mov    0x18(%ebp),%edi
  801458:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80145b:	cd 30                	int    $0x30
  80145d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801460:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801463:	83 c4 10             	add    $0x10,%esp
  801466:	5b                   	pop    %ebx
  801467:	5e                   	pop    %esi
  801468:	5f                   	pop    %edi
  801469:	5d                   	pop    %ebp
  80146a:	c3                   	ret    

0080146b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80146b:	55                   	push   %ebp
  80146c:	89 e5                	mov    %esp,%ebp
  80146e:	83 ec 04             	sub    $0x4,%esp
  801471:	8b 45 10             	mov    0x10(%ebp),%eax
  801474:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801477:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80147a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	6a 00                	push   $0x0
  801483:	51                   	push   %ecx
  801484:	52                   	push   %edx
  801485:	ff 75 0c             	pushl  0xc(%ebp)
  801488:	50                   	push   %eax
  801489:	6a 00                	push   $0x0
  80148b:	e8 b0 ff ff ff       	call   801440 <syscall>
  801490:	83 c4 18             	add    $0x18,%esp
}
  801493:	90                   	nop
  801494:	c9                   	leave  
  801495:	c3                   	ret    

00801496 <sys_cgetc>:

int
sys_cgetc(void)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801499:	6a 00                	push   $0x0
  80149b:	6a 00                	push   $0x0
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 02                	push   $0x2
  8014a5:	e8 96 ff ff ff       	call   801440 <syscall>
  8014aa:	83 c4 18             	add    $0x18,%esp
}
  8014ad:	c9                   	leave  
  8014ae:	c3                   	ret    

008014af <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014b2:	6a 00                	push   $0x0
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 03                	push   $0x3
  8014be:	e8 7d ff ff ff       	call   801440 <syscall>
  8014c3:	83 c4 18             	add    $0x18,%esp
}
  8014c6:	90                   	nop
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    

008014c9 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 04                	push   $0x4
  8014d8:	e8 63 ff ff ff       	call   801440 <syscall>
  8014dd:	83 c4 18             	add    $0x18,%esp
}
  8014e0:	90                   	nop
  8014e1:	c9                   	leave  
  8014e2:	c3                   	ret    

008014e3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	52                   	push   %edx
  8014f3:	50                   	push   %eax
  8014f4:	6a 08                	push   $0x8
  8014f6:	e8 45 ff ff ff       	call   801440 <syscall>
  8014fb:	83 c4 18             	add    $0x18,%esp
}
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    

00801500 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
  801503:	56                   	push   %esi
  801504:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801505:	8b 75 18             	mov    0x18(%ebp),%esi
  801508:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80150b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80150e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
  801514:	56                   	push   %esi
  801515:	53                   	push   %ebx
  801516:	51                   	push   %ecx
  801517:	52                   	push   %edx
  801518:	50                   	push   %eax
  801519:	6a 09                	push   $0x9
  80151b:	e8 20 ff ff ff       	call   801440 <syscall>
  801520:	83 c4 18             	add    $0x18,%esp
}
  801523:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801526:	5b                   	pop    %ebx
  801527:	5e                   	pop    %esi
  801528:	5d                   	pop    %ebp
  801529:	c3                   	ret    

0080152a <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	ff 75 08             	pushl  0x8(%ebp)
  801538:	6a 0a                	push   $0xa
  80153a:	e8 01 ff ff ff       	call   801440 <syscall>
  80153f:	83 c4 18             	add    $0x18,%esp
}
  801542:	c9                   	leave  
  801543:	c3                   	ret    

00801544 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801544:	55                   	push   %ebp
  801545:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	ff 75 0c             	pushl  0xc(%ebp)
  801550:	ff 75 08             	pushl  0x8(%ebp)
  801553:	6a 0b                	push   $0xb
  801555:	e8 e6 fe ff ff       	call   801440 <syscall>
  80155a:	83 c4 18             	add    $0x18,%esp
}
  80155d:	c9                   	leave  
  80155e:	c3                   	ret    

0080155f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	6a 0c                	push   $0xc
  80156e:	e8 cd fe ff ff       	call   801440 <syscall>
  801573:	83 c4 18             	add    $0x18,%esp
}
  801576:	c9                   	leave  
  801577:	c3                   	ret    

00801578 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 0d                	push   $0xd
  801587:	e8 b4 fe ff ff       	call   801440 <syscall>
  80158c:	83 c4 18             	add    $0x18,%esp
}
  80158f:	c9                   	leave  
  801590:	c3                   	ret    

00801591 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	6a 0e                	push   $0xe
  8015a0:	e8 9b fe ff ff       	call   801440 <syscall>
  8015a5:	83 c4 18             	add    $0x18,%esp
}
  8015a8:	c9                   	leave  
  8015a9:	c3                   	ret    

008015aa <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 0f                	push   $0xf
  8015b9:	e8 82 fe ff ff       	call   801440 <syscall>
  8015be:	83 c4 18             	add    $0x18,%esp
}
  8015c1:	c9                   	leave  
  8015c2:	c3                   	ret    

008015c3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	ff 75 08             	pushl  0x8(%ebp)
  8015d1:	6a 10                	push   $0x10
  8015d3:	e8 68 fe ff ff       	call   801440 <syscall>
  8015d8:	83 c4 18             	add    $0x18,%esp
}
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 11                	push   $0x11
  8015ec:	e8 4f fe ff ff       	call   801440 <syscall>
  8015f1:	83 c4 18             	add    $0x18,%esp
}
  8015f4:	90                   	nop
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <sys_cputc>:

void
sys_cputc(const char c)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 04             	sub    $0x4,%esp
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801603:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	50                   	push   %eax
  801610:	6a 01                	push   $0x1
  801612:	e8 29 fe ff ff       	call   801440 <syscall>
  801617:	83 c4 18             	add    $0x18,%esp
}
  80161a:	90                   	nop
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 14                	push   $0x14
  80162c:	e8 0f fe ff ff       	call   801440 <syscall>
  801631:	83 c4 18             	add    $0x18,%esp
}
  801634:	90                   	nop
  801635:	c9                   	leave  
  801636:	c3                   	ret    

00801637 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	83 ec 04             	sub    $0x4,%esp
  80163d:	8b 45 10             	mov    0x10(%ebp),%eax
  801640:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801643:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801646:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80164a:	8b 45 08             	mov    0x8(%ebp),%eax
  80164d:	6a 00                	push   $0x0
  80164f:	51                   	push   %ecx
  801650:	52                   	push   %edx
  801651:	ff 75 0c             	pushl  0xc(%ebp)
  801654:	50                   	push   %eax
  801655:	6a 15                	push   $0x15
  801657:	e8 e4 fd ff ff       	call   801440 <syscall>
  80165c:	83 c4 18             	add    $0x18,%esp
}
  80165f:	c9                   	leave  
  801660:	c3                   	ret    

00801661 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801664:	8b 55 0c             	mov    0xc(%ebp),%edx
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	52                   	push   %edx
  801671:	50                   	push   %eax
  801672:	6a 16                	push   $0x16
  801674:	e8 c7 fd ff ff       	call   801440 <syscall>
  801679:	83 c4 18             	add    $0x18,%esp
}
  80167c:	c9                   	leave  
  80167d:	c3                   	ret    

0080167e <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801681:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801684:	8b 55 0c             	mov    0xc(%ebp),%edx
  801687:	8b 45 08             	mov    0x8(%ebp),%eax
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	51                   	push   %ecx
  80168f:	52                   	push   %edx
  801690:	50                   	push   %eax
  801691:	6a 17                	push   $0x17
  801693:	e8 a8 fd ff ff       	call   801440 <syscall>
  801698:	83 c4 18             	add    $0x18,%esp
}
  80169b:	c9                   	leave  
  80169c:	c3                   	ret    

0080169d <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	52                   	push   %edx
  8016ad:	50                   	push   %eax
  8016ae:	6a 18                	push   $0x18
  8016b0:	e8 8b fd ff ff       	call   801440 <syscall>
  8016b5:	83 c4 18             	add    $0x18,%esp
}
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    

008016ba <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c0:	6a 00                	push   $0x0
  8016c2:	ff 75 14             	pushl  0x14(%ebp)
  8016c5:	ff 75 10             	pushl  0x10(%ebp)
  8016c8:	ff 75 0c             	pushl  0xc(%ebp)
  8016cb:	50                   	push   %eax
  8016cc:	6a 19                	push   $0x19
  8016ce:	e8 6d fd ff ff       	call   801440 <syscall>
  8016d3:	83 c4 18             	add    $0x18,%esp
}
  8016d6:	c9                   	leave  
  8016d7:	c3                   	ret    

008016d8 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	50                   	push   %eax
  8016e7:	6a 1a                	push   $0x1a
  8016e9:	e8 52 fd ff ff       	call   801440 <syscall>
  8016ee:	83 c4 18             	add    $0x18,%esp
}
  8016f1:	90                   	nop
  8016f2:	c9                   	leave  
  8016f3:	c3                   	ret    

008016f4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	50                   	push   %eax
  801703:	6a 1b                	push   $0x1b
  801705:	e8 36 fd ff ff       	call   801440 <syscall>
  80170a:	83 c4 18             	add    $0x18,%esp
}
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 05                	push   $0x5
  80171e:	e8 1d fd ff ff       	call   801440 <syscall>
  801723:	83 c4 18             	add    $0x18,%esp
}
  801726:	c9                   	leave  
  801727:	c3                   	ret    

00801728 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 06                	push   $0x6
  801737:	e8 04 fd ff ff       	call   801440 <syscall>
  80173c:	83 c4 18             	add    $0x18,%esp
}
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 07                	push   $0x7
  801750:	e8 eb fc ff ff       	call   801440 <syscall>
  801755:	83 c4 18             	add    $0x18,%esp
}
  801758:	c9                   	leave  
  801759:	c3                   	ret    

0080175a <sys_exit_env>:


void sys_exit_env(void)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 1c                	push   $0x1c
  801769:	e8 d2 fc ff ff       	call   801440 <syscall>
  80176e:	83 c4 18             	add    $0x18,%esp
}
  801771:	90                   	nop
  801772:	c9                   	leave  
  801773:	c3                   	ret    

00801774 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
  801777:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80177a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80177d:	8d 50 04             	lea    0x4(%eax),%edx
  801780:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	52                   	push   %edx
  80178a:	50                   	push   %eax
  80178b:	6a 1d                	push   $0x1d
  80178d:	e8 ae fc ff ff       	call   801440 <syscall>
  801792:	83 c4 18             	add    $0x18,%esp
	return result;
  801795:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801798:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80179b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80179e:	89 01                	mov    %eax,(%ecx)
  8017a0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a6:	c9                   	leave  
  8017a7:	c2 04 00             	ret    $0x4

008017aa <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	ff 75 10             	pushl  0x10(%ebp)
  8017b4:	ff 75 0c             	pushl  0xc(%ebp)
  8017b7:	ff 75 08             	pushl  0x8(%ebp)
  8017ba:	6a 13                	push   $0x13
  8017bc:	e8 7f fc ff ff       	call   801440 <syscall>
  8017c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c4:	90                   	nop
}
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 1e                	push   $0x1e
  8017d6:	e8 65 fc ff ff       	call   801440 <syscall>
  8017db:	83 c4 18             	add    $0x18,%esp
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 04             	sub    $0x4,%esp
  8017e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8017ec:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	50                   	push   %eax
  8017f9:	6a 1f                	push   $0x1f
  8017fb:	e8 40 fc ff ff       	call   801440 <syscall>
  801800:	83 c4 18             	add    $0x18,%esp
	return ;
  801803:	90                   	nop
}
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <rsttst>:
void rsttst()
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 21                	push   $0x21
  801815:	e8 26 fc ff ff       	call   801440 <syscall>
  80181a:	83 c4 18             	add    $0x18,%esp
	return ;
  80181d:	90                   	nop
}
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	83 ec 04             	sub    $0x4,%esp
  801826:	8b 45 14             	mov    0x14(%ebp),%eax
  801829:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80182c:	8b 55 18             	mov    0x18(%ebp),%edx
  80182f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801833:	52                   	push   %edx
  801834:	50                   	push   %eax
  801835:	ff 75 10             	pushl  0x10(%ebp)
  801838:	ff 75 0c             	pushl  0xc(%ebp)
  80183b:	ff 75 08             	pushl  0x8(%ebp)
  80183e:	6a 20                	push   $0x20
  801840:	e8 fb fb ff ff       	call   801440 <syscall>
  801845:	83 c4 18             	add    $0x18,%esp
	return ;
  801848:	90                   	nop
}
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <chktst>:
void chktst(uint32 n)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	ff 75 08             	pushl  0x8(%ebp)
  801859:	6a 22                	push   $0x22
  80185b:	e8 e0 fb ff ff       	call   801440 <syscall>
  801860:	83 c4 18             	add    $0x18,%esp
	return ;
  801863:	90                   	nop
}
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <inctst>:

void inctst()
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 23                	push   $0x23
  801875:	e8 c6 fb ff ff       	call   801440 <syscall>
  80187a:	83 c4 18             	add    $0x18,%esp
	return ;
  80187d:	90                   	nop
}
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <gettst>:
uint32 gettst()
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 24                	push   $0x24
  80188f:	e8 ac fb ff ff       	call   801440 <syscall>
  801894:	83 c4 18             	add    $0x18,%esp
}
  801897:	c9                   	leave  
  801898:	c3                   	ret    

00801899 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 25                	push   $0x25
  8018a8:	e8 93 fb ff ff       	call   801440 <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
  8018b0:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  8018b5:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8018bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c2:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	ff 75 08             	pushl  0x8(%ebp)
  8018d2:	6a 26                	push   $0x26
  8018d4:	e8 67 fb ff ff       	call   801440 <syscall>
  8018d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8018dc:	90                   	nop
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
  8018e2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018e3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	6a 00                	push   $0x0
  8018f1:	53                   	push   %ebx
  8018f2:	51                   	push   %ecx
  8018f3:	52                   	push   %edx
  8018f4:	50                   	push   %eax
  8018f5:	6a 27                	push   $0x27
  8018f7:	e8 44 fb ff ff       	call   801440 <syscall>
  8018fc:	83 c4 18             	add    $0x18,%esp
}
  8018ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801907:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	52                   	push   %edx
  801914:	50                   	push   %eax
  801915:	6a 28                	push   $0x28
  801917:	e8 24 fb ff ff       	call   801440 <syscall>
  80191c:	83 c4 18             	add    $0x18,%esp
}
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801924:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801927:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	6a 00                	push   $0x0
  80192f:	51                   	push   %ecx
  801930:	ff 75 10             	pushl  0x10(%ebp)
  801933:	52                   	push   %edx
  801934:	50                   	push   %eax
  801935:	6a 29                	push   $0x29
  801937:	e8 04 fb ff ff       	call   801440 <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
}
  80193f:	c9                   	leave  
  801940:	c3                   	ret    

00801941 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	ff 75 10             	pushl  0x10(%ebp)
  80194b:	ff 75 0c             	pushl  0xc(%ebp)
  80194e:	ff 75 08             	pushl  0x8(%ebp)
  801951:	6a 12                	push   $0x12
  801953:	e8 e8 fa ff ff       	call   801440 <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
	return ;
  80195b:	90                   	nop
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801961:	8b 55 0c             	mov    0xc(%ebp),%edx
  801964:	8b 45 08             	mov    0x8(%ebp),%eax
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	52                   	push   %edx
  80196e:	50                   	push   %eax
  80196f:	6a 2a                	push   $0x2a
  801971:	e8 ca fa ff ff       	call   801440 <syscall>
  801976:	83 c4 18             	add    $0x18,%esp
	return;
  801979:	90                   	nop
}
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 2b                	push   $0x2b
  80198b:	e8 b0 fa ff ff       	call   801440 <syscall>
  801990:	83 c4 18             	add    $0x18,%esp
}
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	ff 75 0c             	pushl  0xc(%ebp)
  8019a1:	ff 75 08             	pushl  0x8(%ebp)
  8019a4:	6a 2d                	push   $0x2d
  8019a6:	e8 95 fa ff ff       	call   801440 <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
	return;
  8019ae:	90                   	nop
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	ff 75 0c             	pushl  0xc(%ebp)
  8019bd:	ff 75 08             	pushl  0x8(%ebp)
  8019c0:	6a 2c                	push   $0x2c
  8019c2:	e8 79 fa ff ff       	call   801440 <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ca:	90                   	nop
}
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
  8019d0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8019d3:	83 ec 04             	sub    $0x4,%esp
  8019d6:	68 e8 22 80 00       	push   $0x8022e8
  8019db:	68 25 01 00 00       	push   $0x125
  8019e0:	68 1b 23 80 00       	push   $0x80231b
  8019e5:	e8 a3 e8 ff ff       	call   80028d <_panic>
  8019ea:	66 90                	xchg   %ax,%ax

008019ec <__udivdi3>:
  8019ec:	55                   	push   %ebp
  8019ed:	57                   	push   %edi
  8019ee:	56                   	push   %esi
  8019ef:	53                   	push   %ebx
  8019f0:	83 ec 1c             	sub    $0x1c,%esp
  8019f3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019f7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019fb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019ff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a03:	89 ca                	mov    %ecx,%edx
  801a05:	89 f8                	mov    %edi,%eax
  801a07:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a0b:	85 f6                	test   %esi,%esi
  801a0d:	75 2d                	jne    801a3c <__udivdi3+0x50>
  801a0f:	39 cf                	cmp    %ecx,%edi
  801a11:	77 65                	ja     801a78 <__udivdi3+0x8c>
  801a13:	89 fd                	mov    %edi,%ebp
  801a15:	85 ff                	test   %edi,%edi
  801a17:	75 0b                	jne    801a24 <__udivdi3+0x38>
  801a19:	b8 01 00 00 00       	mov    $0x1,%eax
  801a1e:	31 d2                	xor    %edx,%edx
  801a20:	f7 f7                	div    %edi
  801a22:	89 c5                	mov    %eax,%ebp
  801a24:	31 d2                	xor    %edx,%edx
  801a26:	89 c8                	mov    %ecx,%eax
  801a28:	f7 f5                	div    %ebp
  801a2a:	89 c1                	mov    %eax,%ecx
  801a2c:	89 d8                	mov    %ebx,%eax
  801a2e:	f7 f5                	div    %ebp
  801a30:	89 cf                	mov    %ecx,%edi
  801a32:	89 fa                	mov    %edi,%edx
  801a34:	83 c4 1c             	add    $0x1c,%esp
  801a37:	5b                   	pop    %ebx
  801a38:	5e                   	pop    %esi
  801a39:	5f                   	pop    %edi
  801a3a:	5d                   	pop    %ebp
  801a3b:	c3                   	ret    
  801a3c:	39 ce                	cmp    %ecx,%esi
  801a3e:	77 28                	ja     801a68 <__udivdi3+0x7c>
  801a40:	0f bd fe             	bsr    %esi,%edi
  801a43:	83 f7 1f             	xor    $0x1f,%edi
  801a46:	75 40                	jne    801a88 <__udivdi3+0x9c>
  801a48:	39 ce                	cmp    %ecx,%esi
  801a4a:	72 0a                	jb     801a56 <__udivdi3+0x6a>
  801a4c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a50:	0f 87 9e 00 00 00    	ja     801af4 <__udivdi3+0x108>
  801a56:	b8 01 00 00 00       	mov    $0x1,%eax
  801a5b:	89 fa                	mov    %edi,%edx
  801a5d:	83 c4 1c             	add    $0x1c,%esp
  801a60:	5b                   	pop    %ebx
  801a61:	5e                   	pop    %esi
  801a62:	5f                   	pop    %edi
  801a63:	5d                   	pop    %ebp
  801a64:	c3                   	ret    
  801a65:	8d 76 00             	lea    0x0(%esi),%esi
  801a68:	31 ff                	xor    %edi,%edi
  801a6a:	31 c0                	xor    %eax,%eax
  801a6c:	89 fa                	mov    %edi,%edx
  801a6e:	83 c4 1c             	add    $0x1c,%esp
  801a71:	5b                   	pop    %ebx
  801a72:	5e                   	pop    %esi
  801a73:	5f                   	pop    %edi
  801a74:	5d                   	pop    %ebp
  801a75:	c3                   	ret    
  801a76:	66 90                	xchg   %ax,%ax
  801a78:	89 d8                	mov    %ebx,%eax
  801a7a:	f7 f7                	div    %edi
  801a7c:	31 ff                	xor    %edi,%edi
  801a7e:	89 fa                	mov    %edi,%edx
  801a80:	83 c4 1c             	add    $0x1c,%esp
  801a83:	5b                   	pop    %ebx
  801a84:	5e                   	pop    %esi
  801a85:	5f                   	pop    %edi
  801a86:	5d                   	pop    %ebp
  801a87:	c3                   	ret    
  801a88:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a8d:	89 eb                	mov    %ebp,%ebx
  801a8f:	29 fb                	sub    %edi,%ebx
  801a91:	89 f9                	mov    %edi,%ecx
  801a93:	d3 e6                	shl    %cl,%esi
  801a95:	89 c5                	mov    %eax,%ebp
  801a97:	88 d9                	mov    %bl,%cl
  801a99:	d3 ed                	shr    %cl,%ebp
  801a9b:	89 e9                	mov    %ebp,%ecx
  801a9d:	09 f1                	or     %esi,%ecx
  801a9f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801aa3:	89 f9                	mov    %edi,%ecx
  801aa5:	d3 e0                	shl    %cl,%eax
  801aa7:	89 c5                	mov    %eax,%ebp
  801aa9:	89 d6                	mov    %edx,%esi
  801aab:	88 d9                	mov    %bl,%cl
  801aad:	d3 ee                	shr    %cl,%esi
  801aaf:	89 f9                	mov    %edi,%ecx
  801ab1:	d3 e2                	shl    %cl,%edx
  801ab3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ab7:	88 d9                	mov    %bl,%cl
  801ab9:	d3 e8                	shr    %cl,%eax
  801abb:	09 c2                	or     %eax,%edx
  801abd:	89 d0                	mov    %edx,%eax
  801abf:	89 f2                	mov    %esi,%edx
  801ac1:	f7 74 24 0c          	divl   0xc(%esp)
  801ac5:	89 d6                	mov    %edx,%esi
  801ac7:	89 c3                	mov    %eax,%ebx
  801ac9:	f7 e5                	mul    %ebp
  801acb:	39 d6                	cmp    %edx,%esi
  801acd:	72 19                	jb     801ae8 <__udivdi3+0xfc>
  801acf:	74 0b                	je     801adc <__udivdi3+0xf0>
  801ad1:	89 d8                	mov    %ebx,%eax
  801ad3:	31 ff                	xor    %edi,%edi
  801ad5:	e9 58 ff ff ff       	jmp    801a32 <__udivdi3+0x46>
  801ada:	66 90                	xchg   %ax,%ax
  801adc:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ae0:	89 f9                	mov    %edi,%ecx
  801ae2:	d3 e2                	shl    %cl,%edx
  801ae4:	39 c2                	cmp    %eax,%edx
  801ae6:	73 e9                	jae    801ad1 <__udivdi3+0xe5>
  801ae8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801aeb:	31 ff                	xor    %edi,%edi
  801aed:	e9 40 ff ff ff       	jmp    801a32 <__udivdi3+0x46>
  801af2:	66 90                	xchg   %ax,%ax
  801af4:	31 c0                	xor    %eax,%eax
  801af6:	e9 37 ff ff ff       	jmp    801a32 <__udivdi3+0x46>
  801afb:	90                   	nop

00801afc <__umoddi3>:
  801afc:	55                   	push   %ebp
  801afd:	57                   	push   %edi
  801afe:	56                   	push   %esi
  801aff:	53                   	push   %ebx
  801b00:	83 ec 1c             	sub    $0x1c,%esp
  801b03:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b07:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b0b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b0f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b13:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b17:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b1b:	89 f3                	mov    %esi,%ebx
  801b1d:	89 fa                	mov    %edi,%edx
  801b1f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b23:	89 34 24             	mov    %esi,(%esp)
  801b26:	85 c0                	test   %eax,%eax
  801b28:	75 1a                	jne    801b44 <__umoddi3+0x48>
  801b2a:	39 f7                	cmp    %esi,%edi
  801b2c:	0f 86 a2 00 00 00    	jbe    801bd4 <__umoddi3+0xd8>
  801b32:	89 c8                	mov    %ecx,%eax
  801b34:	89 f2                	mov    %esi,%edx
  801b36:	f7 f7                	div    %edi
  801b38:	89 d0                	mov    %edx,%eax
  801b3a:	31 d2                	xor    %edx,%edx
  801b3c:	83 c4 1c             	add    $0x1c,%esp
  801b3f:	5b                   	pop    %ebx
  801b40:	5e                   	pop    %esi
  801b41:	5f                   	pop    %edi
  801b42:	5d                   	pop    %ebp
  801b43:	c3                   	ret    
  801b44:	39 f0                	cmp    %esi,%eax
  801b46:	0f 87 ac 00 00 00    	ja     801bf8 <__umoddi3+0xfc>
  801b4c:	0f bd e8             	bsr    %eax,%ebp
  801b4f:	83 f5 1f             	xor    $0x1f,%ebp
  801b52:	0f 84 ac 00 00 00    	je     801c04 <__umoddi3+0x108>
  801b58:	bf 20 00 00 00       	mov    $0x20,%edi
  801b5d:	29 ef                	sub    %ebp,%edi
  801b5f:	89 fe                	mov    %edi,%esi
  801b61:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b65:	89 e9                	mov    %ebp,%ecx
  801b67:	d3 e0                	shl    %cl,%eax
  801b69:	89 d7                	mov    %edx,%edi
  801b6b:	89 f1                	mov    %esi,%ecx
  801b6d:	d3 ef                	shr    %cl,%edi
  801b6f:	09 c7                	or     %eax,%edi
  801b71:	89 e9                	mov    %ebp,%ecx
  801b73:	d3 e2                	shl    %cl,%edx
  801b75:	89 14 24             	mov    %edx,(%esp)
  801b78:	89 d8                	mov    %ebx,%eax
  801b7a:	d3 e0                	shl    %cl,%eax
  801b7c:	89 c2                	mov    %eax,%edx
  801b7e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b82:	d3 e0                	shl    %cl,%eax
  801b84:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b88:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b8c:	89 f1                	mov    %esi,%ecx
  801b8e:	d3 e8                	shr    %cl,%eax
  801b90:	09 d0                	or     %edx,%eax
  801b92:	d3 eb                	shr    %cl,%ebx
  801b94:	89 da                	mov    %ebx,%edx
  801b96:	f7 f7                	div    %edi
  801b98:	89 d3                	mov    %edx,%ebx
  801b9a:	f7 24 24             	mull   (%esp)
  801b9d:	89 c6                	mov    %eax,%esi
  801b9f:	89 d1                	mov    %edx,%ecx
  801ba1:	39 d3                	cmp    %edx,%ebx
  801ba3:	0f 82 87 00 00 00    	jb     801c30 <__umoddi3+0x134>
  801ba9:	0f 84 91 00 00 00    	je     801c40 <__umoddi3+0x144>
  801baf:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bb3:	29 f2                	sub    %esi,%edx
  801bb5:	19 cb                	sbb    %ecx,%ebx
  801bb7:	89 d8                	mov    %ebx,%eax
  801bb9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bbd:	d3 e0                	shl    %cl,%eax
  801bbf:	89 e9                	mov    %ebp,%ecx
  801bc1:	d3 ea                	shr    %cl,%edx
  801bc3:	09 d0                	or     %edx,%eax
  801bc5:	89 e9                	mov    %ebp,%ecx
  801bc7:	d3 eb                	shr    %cl,%ebx
  801bc9:	89 da                	mov    %ebx,%edx
  801bcb:	83 c4 1c             	add    $0x1c,%esp
  801bce:	5b                   	pop    %ebx
  801bcf:	5e                   	pop    %esi
  801bd0:	5f                   	pop    %edi
  801bd1:	5d                   	pop    %ebp
  801bd2:	c3                   	ret    
  801bd3:	90                   	nop
  801bd4:	89 fd                	mov    %edi,%ebp
  801bd6:	85 ff                	test   %edi,%edi
  801bd8:	75 0b                	jne    801be5 <__umoddi3+0xe9>
  801bda:	b8 01 00 00 00       	mov    $0x1,%eax
  801bdf:	31 d2                	xor    %edx,%edx
  801be1:	f7 f7                	div    %edi
  801be3:	89 c5                	mov    %eax,%ebp
  801be5:	89 f0                	mov    %esi,%eax
  801be7:	31 d2                	xor    %edx,%edx
  801be9:	f7 f5                	div    %ebp
  801beb:	89 c8                	mov    %ecx,%eax
  801bed:	f7 f5                	div    %ebp
  801bef:	89 d0                	mov    %edx,%eax
  801bf1:	e9 44 ff ff ff       	jmp    801b3a <__umoddi3+0x3e>
  801bf6:	66 90                	xchg   %ax,%ax
  801bf8:	89 c8                	mov    %ecx,%eax
  801bfa:	89 f2                	mov    %esi,%edx
  801bfc:	83 c4 1c             	add    $0x1c,%esp
  801bff:	5b                   	pop    %ebx
  801c00:	5e                   	pop    %esi
  801c01:	5f                   	pop    %edi
  801c02:	5d                   	pop    %ebp
  801c03:	c3                   	ret    
  801c04:	3b 04 24             	cmp    (%esp),%eax
  801c07:	72 06                	jb     801c0f <__umoddi3+0x113>
  801c09:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c0d:	77 0f                	ja     801c1e <__umoddi3+0x122>
  801c0f:	89 f2                	mov    %esi,%edx
  801c11:	29 f9                	sub    %edi,%ecx
  801c13:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c17:	89 14 24             	mov    %edx,(%esp)
  801c1a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c1e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c22:	8b 14 24             	mov    (%esp),%edx
  801c25:	83 c4 1c             	add    $0x1c,%esp
  801c28:	5b                   	pop    %ebx
  801c29:	5e                   	pop    %esi
  801c2a:	5f                   	pop    %edi
  801c2b:	5d                   	pop    %ebp
  801c2c:	c3                   	ret    
  801c2d:	8d 76 00             	lea    0x0(%esi),%esi
  801c30:	2b 04 24             	sub    (%esp),%eax
  801c33:	19 fa                	sbb    %edi,%edx
  801c35:	89 d1                	mov    %edx,%ecx
  801c37:	89 c6                	mov    %eax,%esi
  801c39:	e9 71 ff ff ff       	jmp    801baf <__umoddi3+0xb3>
  801c3e:	66 90                	xchg   %ax,%ax
  801c40:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c44:	72 ea                	jb     801c30 <__umoddi3+0x134>
  801c46:	89 d9                	mov    %ebx,%ecx
  801c48:	e9 62 ff ff ff       	jmp    801baf <__umoddi3+0xb3>

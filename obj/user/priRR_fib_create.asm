
obj/user/priRR_fib_create:     file format elf32-i386


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
  800031:	e8 23 01 00 00       	call   800159 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

extern void sys_env_set_priority(int , int );

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	int32 envIdFib1 = sys_create_env("priRR_fib", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80003e:	a1 20 30 80 00       	mov    0x803020,%eax
  800043:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800049:	a1 20 30 80 00       	mov    0x803020,%eax
  80004e:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  800054:	89 c1                	mov    %eax,%ecx
  800056:	a1 20 30 80 00       	mov    0x803020,%eax
  80005b:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800061:	52                   	push   %edx
  800062:	51                   	push   %ecx
  800063:	50                   	push   %eax
  800064:	68 e0 1c 80 00       	push   $0x801ce0
  800069:	e8 c8 16 00 00       	call   801736 <sys_create_env>
  80006e:	83 c4 10             	add    $0x10,%esp
  800071:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (envIdFib1 == E_ENV_CREATION_ERROR)
  800074:	83 7d f4 ef          	cmpl   $0xffffffef,-0xc(%ebp)
  800078:	75 14                	jne    80008e <_main+0x56>
		panic("Loading programs failed\n");
  80007a:	83 ec 04             	sub    $0x4,%esp
  80007d:	68 ea 1c 80 00       	push   $0x801cea
  800082:	6a 0b                	push   $0xb
  800084:	68 03 1d 80 00       	push   $0x801d03
  800089:	e8 7b 02 00 00       	call   800309 <_panic>

	int32 envIdFib2 = sys_create_env("priRR_fib", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80008e:	a1 20 30 80 00       	mov    0x803020,%eax
  800093:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800099:	a1 20 30 80 00       	mov    0x803020,%eax
  80009e:	8b 80 8c 05 00 00    	mov    0x58c(%eax),%eax
  8000a4:	89 c1                	mov    %eax,%ecx
  8000a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ab:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000b1:	52                   	push   %edx
  8000b2:	51                   	push   %ecx
  8000b3:	50                   	push   %eax
  8000b4:	68 e0 1c 80 00       	push   $0x801ce0
  8000b9:	e8 78 16 00 00       	call   801736 <sys_create_env>
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (envIdFib2 == E_ENV_CREATION_ERROR)
  8000c4:	83 7d f0 ef          	cmpl   $0xffffffef,-0x10(%ebp)
  8000c8:	75 14                	jne    8000de <_main+0xa6>
		panic("Loading programs failed\n");
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	68 ea 1c 80 00       	push   $0x801cea
  8000d2:	6a 0f                	push   $0xf
  8000d4:	68 03 1d 80 00       	push   $0x801d03
  8000d9:	e8 2b 02 00 00       	call   800309 <_panic>

	sys_run_env(envIdFib1);
  8000de:	83 ec 0c             	sub    $0xc,%esp
  8000e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8000e4:	e8 6b 16 00 00       	call   801754 <sys_run_env>
  8000e9:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdFib2);
  8000ec:	83 ec 0c             	sub    $0xc,%esp
  8000ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8000f2:	e8 5d 16 00 00       	call   801754 <sys_run_env>
  8000f7:	83 c4 10             	add    $0x10,%esp

	int priority = 2;
  8000fa:	c7 45 ec 02 00 00 00 	movl   $0x2,-0x14(%ebp)
	cprintf("process %d will be added to ready queue at priority %d\n", envIdFib1, priority);
  800101:	83 ec 04             	sub    $0x4,%esp
  800104:	ff 75 ec             	pushl  -0x14(%ebp)
  800107:	ff 75 f4             	pushl  -0xc(%ebp)
  80010a:	68 1c 1d 80 00       	push   $0x801d1c
  80010f:	e8 c3 04 00 00       	call   8005d7 <cprintf>
  800114:	83 c4 10             	add    $0x10,%esp
	sys_env_set_priority(envIdFib1, priority);
  800117:	83 ec 08             	sub    $0x8,%esp
  80011a:	ff 75 ec             	pushl  -0x14(%ebp)
  80011d:	ff 75 f4             	pushl  -0xc(%ebp)
  800120:	e8 24 19 00 00       	call   801a49 <sys_env_set_priority>
  800125:	83 c4 10             	add    $0x10,%esp

	priority = 9;
  800128:	c7 45 ec 09 00 00 00 	movl   $0x9,-0x14(%ebp)
	cprintf("process %d will be added to ready queue at priority %d\n", envIdFib2, priority);
  80012f:	83 ec 04             	sub    $0x4,%esp
  800132:	ff 75 ec             	pushl  -0x14(%ebp)
  800135:	ff 75 f0             	pushl  -0x10(%ebp)
  800138:	68 1c 1d 80 00       	push   $0x801d1c
  80013d:	e8 95 04 00 00       	call   8005d7 <cprintf>
  800142:	83 c4 10             	add    $0x10,%esp
	sys_env_set_priority(envIdFib2, priority);
  800145:	83 ec 08             	sub    $0x8,%esp
  800148:	ff 75 ec             	pushl  -0x14(%ebp)
  80014b:	ff 75 f0             	pushl  -0x10(%ebp)
  80014e:	e8 f6 18 00 00       	call   801a49 <sys_env_set_priority>
  800153:	83 c4 10             	add    $0x10,%esp
return;
  800156:	90                   	nop
}
  800157:	c9                   	leave  
  800158:	c3                   	ret    

00800159 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800159:	55                   	push   %ebp
  80015a:	89 e5                	mov    %esp,%ebp
  80015c:	57                   	push   %edi
  80015d:	56                   	push   %esi
  80015e:	53                   	push   %ebx
  80015f:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800162:	e8 3d 16 00 00       	call   8017a4 <sys_getenvindex>
  800167:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80016a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80016d:	89 d0                	mov    %edx,%eax
  80016f:	c1 e0 02             	shl    $0x2,%eax
  800172:	01 d0                	add    %edx,%eax
  800174:	c1 e0 03             	shl    $0x3,%eax
  800177:	01 d0                	add    %edx,%eax
  800179:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800180:	01 d0                	add    %edx,%eax
  800182:	c1 e0 02             	shl    $0x2,%eax
  800185:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80018a:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80018f:	a1 20 30 80 00       	mov    0x803020,%eax
  800194:	8a 40 20             	mov    0x20(%eax),%al
  800197:	84 c0                	test   %al,%al
  800199:	74 0d                	je     8001a8 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80019b:	a1 20 30 80 00       	mov    0x803020,%eax
  8001a0:	83 c0 20             	add    $0x20,%eax
  8001a3:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001ac:	7e 0a                	jle    8001b8 <libmain+0x5f>
		binaryname = argv[0];
  8001ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b1:	8b 00                	mov    (%eax),%eax
  8001b3:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8001b8:	83 ec 08             	sub    $0x8,%esp
  8001bb:	ff 75 0c             	pushl  0xc(%ebp)
  8001be:	ff 75 08             	pushl  0x8(%ebp)
  8001c1:	e8 72 fe ff ff       	call   800038 <_main>
  8001c6:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001c9:	a1 00 30 80 00       	mov    0x803000,%eax
  8001ce:	85 c0                	test   %eax,%eax
  8001d0:	0f 84 01 01 00 00    	je     8002d7 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8001d6:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8001dc:	bb 4c 1e 80 00       	mov    $0x801e4c,%ebx
  8001e1:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001e6:	89 c7                	mov    %eax,%edi
  8001e8:	89 de                	mov    %ebx,%esi
  8001ea:	89 d1                	mov    %edx,%ecx
  8001ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001ee:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8001f1:	b9 56 00 00 00       	mov    $0x56,%ecx
  8001f6:	b0 00                	mov    $0x0,%al
  8001f8:	89 d7                	mov    %edx,%edi
  8001fa:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8001fc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800203:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800206:	83 ec 08             	sub    $0x8,%esp
  800209:	50                   	push   %eax
  80020a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800210:	50                   	push   %eax
  800211:	e8 c4 17 00 00       	call   8019da <sys_utilities>
  800216:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800219:	e8 0d 13 00 00       	call   80152b <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80021e:	83 ec 0c             	sub    $0xc,%esp
  800221:	68 6c 1d 80 00       	push   $0x801d6c
  800226:	e8 ac 03 00 00       	call   8005d7 <cprintf>
  80022b:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80022e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800231:	85 c0                	test   %eax,%eax
  800233:	74 18                	je     80024d <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800235:	e8 be 17 00 00       	call   8019f8 <sys_get_optimal_num_faults>
  80023a:	83 ec 08             	sub    $0x8,%esp
  80023d:	50                   	push   %eax
  80023e:	68 94 1d 80 00       	push   $0x801d94
  800243:	e8 8f 03 00 00       	call   8005d7 <cprintf>
  800248:	83 c4 10             	add    $0x10,%esp
  80024b:	eb 59                	jmp    8002a6 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80024d:	a1 20 30 80 00       	mov    0x803020,%eax
  800252:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800258:	a1 20 30 80 00       	mov    0x803020,%eax
  80025d:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800263:	83 ec 04             	sub    $0x4,%esp
  800266:	52                   	push   %edx
  800267:	50                   	push   %eax
  800268:	68 b8 1d 80 00       	push   $0x801db8
  80026d:	e8 65 03 00 00       	call   8005d7 <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800275:	a1 20 30 80 00       	mov    0x803020,%eax
  80027a:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800280:	a1 20 30 80 00       	mov    0x803020,%eax
  800285:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80028b:	a1 20 30 80 00       	mov    0x803020,%eax
  800290:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800296:	51                   	push   %ecx
  800297:	52                   	push   %edx
  800298:	50                   	push   %eax
  800299:	68 e0 1d 80 00       	push   $0x801de0
  80029e:	e8 34 03 00 00       	call   8005d7 <cprintf>
  8002a3:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ab:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8002b1:	83 ec 08             	sub    $0x8,%esp
  8002b4:	50                   	push   %eax
  8002b5:	68 38 1e 80 00       	push   $0x801e38
  8002ba:	e8 18 03 00 00       	call   8005d7 <cprintf>
  8002bf:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002c2:	83 ec 0c             	sub    $0xc,%esp
  8002c5:	68 6c 1d 80 00       	push   $0x801d6c
  8002ca:	e8 08 03 00 00       	call   8005d7 <cprintf>
  8002cf:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002d2:	e8 6e 12 00 00       	call   801545 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002d7:	e8 1f 00 00 00       	call   8002fb <exit>
}
  8002dc:	90                   	nop
  8002dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e0:	5b                   	pop    %ebx
  8002e1:	5e                   	pop    %esi
  8002e2:	5f                   	pop    %edi
  8002e3:	5d                   	pop    %ebp
  8002e4:	c3                   	ret    

008002e5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002e5:	55                   	push   %ebp
  8002e6:	89 e5                	mov    %esp,%ebp
  8002e8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002eb:	83 ec 0c             	sub    $0xc,%esp
  8002ee:	6a 00                	push   $0x0
  8002f0:	e8 7b 14 00 00       	call   801770 <sys_destroy_env>
  8002f5:	83 c4 10             	add    $0x10,%esp
}
  8002f8:	90                   	nop
  8002f9:	c9                   	leave  
  8002fa:	c3                   	ret    

008002fb <exit>:

void
exit(void)
{
  8002fb:	55                   	push   %ebp
  8002fc:	89 e5                	mov    %esp,%ebp
  8002fe:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800301:	e8 d0 14 00 00       	call   8017d6 <sys_exit_env>
}
  800306:	90                   	nop
  800307:	c9                   	leave  
  800308:	c3                   	ret    

00800309 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800309:	55                   	push   %ebp
  80030a:	89 e5                	mov    %esp,%ebp
  80030c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80030f:	8d 45 10             	lea    0x10(%ebp),%eax
  800312:	83 c0 04             	add    $0x4,%eax
  800315:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800318:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80031d:	85 c0                	test   %eax,%eax
  80031f:	74 16                	je     800337 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800321:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800326:	83 ec 08             	sub    $0x8,%esp
  800329:	50                   	push   %eax
  80032a:	68 b0 1e 80 00       	push   $0x801eb0
  80032f:	e8 a3 02 00 00       	call   8005d7 <cprintf>
  800334:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800337:	a1 04 30 80 00       	mov    0x803004,%eax
  80033c:	83 ec 0c             	sub    $0xc,%esp
  80033f:	ff 75 0c             	pushl  0xc(%ebp)
  800342:	ff 75 08             	pushl  0x8(%ebp)
  800345:	50                   	push   %eax
  800346:	68 b8 1e 80 00       	push   $0x801eb8
  80034b:	6a 74                	push   $0x74
  80034d:	e8 b2 02 00 00       	call   800604 <cprintf_colored>
  800352:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800355:	8b 45 10             	mov    0x10(%ebp),%eax
  800358:	83 ec 08             	sub    $0x8,%esp
  80035b:	ff 75 f4             	pushl  -0xc(%ebp)
  80035e:	50                   	push   %eax
  80035f:	e8 04 02 00 00       	call   800568 <vcprintf>
  800364:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800367:	83 ec 08             	sub    $0x8,%esp
  80036a:	6a 00                	push   $0x0
  80036c:	68 e0 1e 80 00       	push   $0x801ee0
  800371:	e8 f2 01 00 00       	call   800568 <vcprintf>
  800376:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800379:	e8 7d ff ff ff       	call   8002fb <exit>

	// should not return here
	while (1) ;
  80037e:	eb fe                	jmp    80037e <_panic+0x75>

00800380 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800380:	55                   	push   %ebp
  800381:	89 e5                	mov    %esp,%ebp
  800383:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800386:	a1 20 30 80 00       	mov    0x803020,%eax
  80038b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800391:	8b 45 0c             	mov    0xc(%ebp),%eax
  800394:	39 c2                	cmp    %eax,%edx
  800396:	74 14                	je     8003ac <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800398:	83 ec 04             	sub    $0x4,%esp
  80039b:	68 e4 1e 80 00       	push   $0x801ee4
  8003a0:	6a 26                	push   $0x26
  8003a2:	68 30 1f 80 00       	push   $0x801f30
  8003a7:	e8 5d ff ff ff       	call   800309 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003ba:	e9 c5 00 00 00       	jmp    800484 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cc:	01 d0                	add    %edx,%eax
  8003ce:	8b 00                	mov    (%eax),%eax
  8003d0:	85 c0                	test   %eax,%eax
  8003d2:	75 08                	jne    8003dc <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003d4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003d7:	e9 a5 00 00 00       	jmp    800481 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003dc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003ea:	eb 69                	jmp    800455 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003ec:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f1:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8003f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003fa:	89 d0                	mov    %edx,%eax
  8003fc:	01 c0                	add    %eax,%eax
  8003fe:	01 d0                	add    %edx,%eax
  800400:	c1 e0 03             	shl    $0x3,%eax
  800403:	01 c8                	add    %ecx,%eax
  800405:	8a 40 04             	mov    0x4(%eax),%al
  800408:	84 c0                	test   %al,%al
  80040a:	75 46                	jne    800452 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80040c:	a1 20 30 80 00       	mov    0x803020,%eax
  800411:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800417:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80041a:	89 d0                	mov    %edx,%eax
  80041c:	01 c0                	add    %eax,%eax
  80041e:	01 d0                	add    %edx,%eax
  800420:	c1 e0 03             	shl    $0x3,%eax
  800423:	01 c8                	add    %ecx,%eax
  800425:	8b 00                	mov    (%eax),%eax
  800427:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80042a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80042d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800432:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800434:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800437:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80043e:	8b 45 08             	mov    0x8(%ebp),%eax
  800441:	01 c8                	add    %ecx,%eax
  800443:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800445:	39 c2                	cmp    %eax,%edx
  800447:	75 09                	jne    800452 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800449:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800450:	eb 15                	jmp    800467 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800452:	ff 45 e8             	incl   -0x18(%ebp)
  800455:	a1 20 30 80 00       	mov    0x803020,%eax
  80045a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800460:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800463:	39 c2                	cmp    %eax,%edx
  800465:	77 85                	ja     8003ec <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800467:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80046b:	75 14                	jne    800481 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80046d:	83 ec 04             	sub    $0x4,%esp
  800470:	68 3c 1f 80 00       	push   $0x801f3c
  800475:	6a 3a                	push   $0x3a
  800477:	68 30 1f 80 00       	push   $0x801f30
  80047c:	e8 88 fe ff ff       	call   800309 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800481:	ff 45 f0             	incl   -0x10(%ebp)
  800484:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800487:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80048a:	0f 8c 2f ff ff ff    	jl     8003bf <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800490:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800497:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80049e:	eb 26                	jmp    8004c6 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004a0:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a5:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8004ab:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004ae:	89 d0                	mov    %edx,%eax
  8004b0:	01 c0                	add    %eax,%eax
  8004b2:	01 d0                	add    %edx,%eax
  8004b4:	c1 e0 03             	shl    $0x3,%eax
  8004b7:	01 c8                	add    %ecx,%eax
  8004b9:	8a 40 04             	mov    0x4(%eax),%al
  8004bc:	3c 01                	cmp    $0x1,%al
  8004be:	75 03                	jne    8004c3 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004c0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c3:	ff 45 e0             	incl   -0x20(%ebp)
  8004c6:	a1 20 30 80 00       	mov    0x803020,%eax
  8004cb:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d4:	39 c2                	cmp    %eax,%edx
  8004d6:	77 c8                	ja     8004a0 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004db:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004de:	74 14                	je     8004f4 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004e0:	83 ec 04             	sub    $0x4,%esp
  8004e3:	68 90 1f 80 00       	push   $0x801f90
  8004e8:	6a 44                	push   $0x44
  8004ea:	68 30 1f 80 00       	push   $0x801f30
  8004ef:	e8 15 fe ff ff       	call   800309 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004f4:	90                   	nop
  8004f5:	c9                   	leave  
  8004f6:	c3                   	ret    

008004f7 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004f7:	55                   	push   %ebp
  8004f8:	89 e5                	mov    %esp,%ebp
  8004fa:	53                   	push   %ebx
  8004fb:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8004fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800501:	8b 00                	mov    (%eax),%eax
  800503:	8d 48 01             	lea    0x1(%eax),%ecx
  800506:	8b 55 0c             	mov    0xc(%ebp),%edx
  800509:	89 0a                	mov    %ecx,(%edx)
  80050b:	8b 55 08             	mov    0x8(%ebp),%edx
  80050e:	88 d1                	mov    %dl,%cl
  800510:	8b 55 0c             	mov    0xc(%ebp),%edx
  800513:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051a:	8b 00                	mov    (%eax),%eax
  80051c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800521:	75 30                	jne    800553 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800523:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800529:	a0 44 30 80 00       	mov    0x803044,%al
  80052e:	0f b6 c0             	movzbl %al,%eax
  800531:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800534:	8b 09                	mov    (%ecx),%ecx
  800536:	89 cb                	mov    %ecx,%ebx
  800538:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80053b:	83 c1 08             	add    $0x8,%ecx
  80053e:	52                   	push   %edx
  80053f:	50                   	push   %eax
  800540:	53                   	push   %ebx
  800541:	51                   	push   %ecx
  800542:	e8 a0 0f 00 00       	call   8014e7 <sys_cputs>
  800547:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80054a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800553:	8b 45 0c             	mov    0xc(%ebp),%eax
  800556:	8b 40 04             	mov    0x4(%eax),%eax
  800559:	8d 50 01             	lea    0x1(%eax),%edx
  80055c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80055f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800562:	90                   	nop
  800563:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800566:	c9                   	leave  
  800567:	c3                   	ret    

00800568 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800568:	55                   	push   %ebp
  800569:	89 e5                	mov    %esp,%ebp
  80056b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800571:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800578:	00 00 00 
	b.cnt = 0;
  80057b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800582:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800585:	ff 75 0c             	pushl  0xc(%ebp)
  800588:	ff 75 08             	pushl  0x8(%ebp)
  80058b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800591:	50                   	push   %eax
  800592:	68 f7 04 80 00       	push   $0x8004f7
  800597:	e8 5a 02 00 00       	call   8007f6 <vprintfmt>
  80059c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80059f:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8005a5:	a0 44 30 80 00       	mov    0x803044,%al
  8005aa:	0f b6 c0             	movzbl %al,%eax
  8005ad:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8005b3:	52                   	push   %edx
  8005b4:	50                   	push   %eax
  8005b5:	51                   	push   %ecx
  8005b6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005bc:	83 c0 08             	add    $0x8,%eax
  8005bf:	50                   	push   %eax
  8005c0:	e8 22 0f 00 00       	call   8014e7 <sys_cputs>
  8005c5:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005c8:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8005cf:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005d5:	c9                   	leave  
  8005d6:	c3                   	ret    

008005d7 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005d7:	55                   	push   %ebp
  8005d8:	89 e5                	mov    %esp,%ebp
  8005da:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005dd:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8005e4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ed:	83 ec 08             	sub    $0x8,%esp
  8005f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f3:	50                   	push   %eax
  8005f4:	e8 6f ff ff ff       	call   800568 <vcprintf>
  8005f9:	83 c4 10             	add    $0x10,%esp
  8005fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800602:	c9                   	leave  
  800603:	c3                   	ret    

00800604 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800604:	55                   	push   %ebp
  800605:	89 e5                	mov    %esp,%ebp
  800607:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80060a:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800611:	8b 45 08             	mov    0x8(%ebp),%eax
  800614:	c1 e0 08             	shl    $0x8,%eax
  800617:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  80061c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80061f:	83 c0 04             	add    $0x4,%eax
  800622:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800625:	8b 45 0c             	mov    0xc(%ebp),%eax
  800628:	83 ec 08             	sub    $0x8,%esp
  80062b:	ff 75 f4             	pushl  -0xc(%ebp)
  80062e:	50                   	push   %eax
  80062f:	e8 34 ff ff ff       	call   800568 <vcprintf>
  800634:	83 c4 10             	add    $0x10,%esp
  800637:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80063a:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800641:	07 00 00 

	return cnt;
  800644:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800647:	c9                   	leave  
  800648:	c3                   	ret    

00800649 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800649:	55                   	push   %ebp
  80064a:	89 e5                	mov    %esp,%ebp
  80064c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80064f:	e8 d7 0e 00 00       	call   80152b <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800654:	8d 45 0c             	lea    0xc(%ebp),%eax
  800657:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80065a:	8b 45 08             	mov    0x8(%ebp),%eax
  80065d:	83 ec 08             	sub    $0x8,%esp
  800660:	ff 75 f4             	pushl  -0xc(%ebp)
  800663:	50                   	push   %eax
  800664:	e8 ff fe ff ff       	call   800568 <vcprintf>
  800669:	83 c4 10             	add    $0x10,%esp
  80066c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80066f:	e8 d1 0e 00 00       	call   801545 <sys_unlock_cons>
	return cnt;
  800674:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800677:	c9                   	leave  
  800678:	c3                   	ret    

00800679 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800679:	55                   	push   %ebp
  80067a:	89 e5                	mov    %esp,%ebp
  80067c:	53                   	push   %ebx
  80067d:	83 ec 14             	sub    $0x14,%esp
  800680:	8b 45 10             	mov    0x10(%ebp),%eax
  800683:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800686:	8b 45 14             	mov    0x14(%ebp),%eax
  800689:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80068c:	8b 45 18             	mov    0x18(%ebp),%eax
  80068f:	ba 00 00 00 00       	mov    $0x0,%edx
  800694:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800697:	77 55                	ja     8006ee <printnum+0x75>
  800699:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80069c:	72 05                	jb     8006a3 <printnum+0x2a>
  80069e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006a1:	77 4b                	ja     8006ee <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006a3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006a6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006a9:	8b 45 18             	mov    0x18(%ebp),%eax
  8006ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b1:	52                   	push   %edx
  8006b2:	50                   	push   %eax
  8006b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8006b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8006b9:	e8 aa 13 00 00       	call   801a68 <__udivdi3>
  8006be:	83 c4 10             	add    $0x10,%esp
  8006c1:	83 ec 04             	sub    $0x4,%esp
  8006c4:	ff 75 20             	pushl  0x20(%ebp)
  8006c7:	53                   	push   %ebx
  8006c8:	ff 75 18             	pushl  0x18(%ebp)
  8006cb:	52                   	push   %edx
  8006cc:	50                   	push   %eax
  8006cd:	ff 75 0c             	pushl  0xc(%ebp)
  8006d0:	ff 75 08             	pushl  0x8(%ebp)
  8006d3:	e8 a1 ff ff ff       	call   800679 <printnum>
  8006d8:	83 c4 20             	add    $0x20,%esp
  8006db:	eb 1a                	jmp    8006f7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006dd:	83 ec 08             	sub    $0x8,%esp
  8006e0:	ff 75 0c             	pushl  0xc(%ebp)
  8006e3:	ff 75 20             	pushl  0x20(%ebp)
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	ff d0                	call   *%eax
  8006eb:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006ee:	ff 4d 1c             	decl   0x1c(%ebp)
  8006f1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006f5:	7f e6                	jg     8006dd <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006f7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800702:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800705:	53                   	push   %ebx
  800706:	51                   	push   %ecx
  800707:	52                   	push   %edx
  800708:	50                   	push   %eax
  800709:	e8 6a 14 00 00       	call   801b78 <__umoddi3>
  80070e:	83 c4 10             	add    $0x10,%esp
  800711:	05 f4 21 80 00       	add    $0x8021f4,%eax
  800716:	8a 00                	mov    (%eax),%al
  800718:	0f be c0             	movsbl %al,%eax
  80071b:	83 ec 08             	sub    $0x8,%esp
  80071e:	ff 75 0c             	pushl  0xc(%ebp)
  800721:	50                   	push   %eax
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	ff d0                	call   *%eax
  800727:	83 c4 10             	add    $0x10,%esp
}
  80072a:	90                   	nop
  80072b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80072e:	c9                   	leave  
  80072f:	c3                   	ret    

00800730 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800730:	55                   	push   %ebp
  800731:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800733:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800737:	7e 1c                	jle    800755 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800739:	8b 45 08             	mov    0x8(%ebp),%eax
  80073c:	8b 00                	mov    (%eax),%eax
  80073e:	8d 50 08             	lea    0x8(%eax),%edx
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	89 10                	mov    %edx,(%eax)
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	83 e8 08             	sub    $0x8,%eax
  80074e:	8b 50 04             	mov    0x4(%eax),%edx
  800751:	8b 00                	mov    (%eax),%eax
  800753:	eb 40                	jmp    800795 <getuint+0x65>
	else if (lflag)
  800755:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800759:	74 1e                	je     800779 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	8d 50 04             	lea    0x4(%eax),%edx
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	89 10                	mov    %edx,(%eax)
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
  80076b:	8b 00                	mov    (%eax),%eax
  80076d:	83 e8 04             	sub    $0x4,%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	ba 00 00 00 00       	mov    $0x0,%edx
  800777:	eb 1c                	jmp    800795 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800779:	8b 45 08             	mov    0x8(%ebp),%eax
  80077c:	8b 00                	mov    (%eax),%eax
  80077e:	8d 50 04             	lea    0x4(%eax),%edx
  800781:	8b 45 08             	mov    0x8(%ebp),%eax
  800784:	89 10                	mov    %edx,(%eax)
  800786:	8b 45 08             	mov    0x8(%ebp),%eax
  800789:	8b 00                	mov    (%eax),%eax
  80078b:	83 e8 04             	sub    $0x4,%eax
  80078e:	8b 00                	mov    (%eax),%eax
  800790:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800795:	5d                   	pop    %ebp
  800796:	c3                   	ret    

00800797 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800797:	55                   	push   %ebp
  800798:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80079a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80079e:	7e 1c                	jle    8007bc <getint+0x25>
		return va_arg(*ap, long long);
  8007a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a3:	8b 00                	mov    (%eax),%eax
  8007a5:	8d 50 08             	lea    0x8(%eax),%edx
  8007a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ab:	89 10                	mov    %edx,(%eax)
  8007ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	83 e8 08             	sub    $0x8,%eax
  8007b5:	8b 50 04             	mov    0x4(%eax),%edx
  8007b8:	8b 00                	mov    (%eax),%eax
  8007ba:	eb 38                	jmp    8007f4 <getint+0x5d>
	else if (lflag)
  8007bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c0:	74 1a                	je     8007dc <getint+0x45>
		return va_arg(*ap, long);
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	8b 00                	mov    (%eax),%eax
  8007c7:	8d 50 04             	lea    0x4(%eax),%edx
  8007ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cd:	89 10                	mov    %edx,(%eax)
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	8b 00                	mov    (%eax),%eax
  8007d4:	83 e8 04             	sub    $0x4,%eax
  8007d7:	8b 00                	mov    (%eax),%eax
  8007d9:	99                   	cltd   
  8007da:	eb 18                	jmp    8007f4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	8b 00                	mov    (%eax),%eax
  8007e1:	8d 50 04             	lea    0x4(%eax),%edx
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	89 10                	mov    %edx,(%eax)
  8007e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ec:	8b 00                	mov    (%eax),%eax
  8007ee:	83 e8 04             	sub    $0x4,%eax
  8007f1:	8b 00                	mov    (%eax),%eax
  8007f3:	99                   	cltd   
}
  8007f4:	5d                   	pop    %ebp
  8007f5:	c3                   	ret    

008007f6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007f6:	55                   	push   %ebp
  8007f7:	89 e5                	mov    %esp,%ebp
  8007f9:	56                   	push   %esi
  8007fa:	53                   	push   %ebx
  8007fb:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007fe:	eb 17                	jmp    800817 <vprintfmt+0x21>
			if (ch == '\0')
  800800:	85 db                	test   %ebx,%ebx
  800802:	0f 84 c1 03 00 00    	je     800bc9 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800808:	83 ec 08             	sub    $0x8,%esp
  80080b:	ff 75 0c             	pushl  0xc(%ebp)
  80080e:	53                   	push   %ebx
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	ff d0                	call   *%eax
  800814:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800817:	8b 45 10             	mov    0x10(%ebp),%eax
  80081a:	8d 50 01             	lea    0x1(%eax),%edx
  80081d:	89 55 10             	mov    %edx,0x10(%ebp)
  800820:	8a 00                	mov    (%eax),%al
  800822:	0f b6 d8             	movzbl %al,%ebx
  800825:	83 fb 25             	cmp    $0x25,%ebx
  800828:	75 d6                	jne    800800 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80082a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80082e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800835:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80083c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800843:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80084a:	8b 45 10             	mov    0x10(%ebp),%eax
  80084d:	8d 50 01             	lea    0x1(%eax),%edx
  800850:	89 55 10             	mov    %edx,0x10(%ebp)
  800853:	8a 00                	mov    (%eax),%al
  800855:	0f b6 d8             	movzbl %al,%ebx
  800858:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80085b:	83 f8 5b             	cmp    $0x5b,%eax
  80085e:	0f 87 3d 03 00 00    	ja     800ba1 <vprintfmt+0x3ab>
  800864:	8b 04 85 18 22 80 00 	mov    0x802218(,%eax,4),%eax
  80086b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80086d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800871:	eb d7                	jmp    80084a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800873:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800877:	eb d1                	jmp    80084a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800879:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800880:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800883:	89 d0                	mov    %edx,%eax
  800885:	c1 e0 02             	shl    $0x2,%eax
  800888:	01 d0                	add    %edx,%eax
  80088a:	01 c0                	add    %eax,%eax
  80088c:	01 d8                	add    %ebx,%eax
  80088e:	83 e8 30             	sub    $0x30,%eax
  800891:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800894:	8b 45 10             	mov    0x10(%ebp),%eax
  800897:	8a 00                	mov    (%eax),%al
  800899:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80089c:	83 fb 2f             	cmp    $0x2f,%ebx
  80089f:	7e 3e                	jle    8008df <vprintfmt+0xe9>
  8008a1:	83 fb 39             	cmp    $0x39,%ebx
  8008a4:	7f 39                	jg     8008df <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008a9:	eb d5                	jmp    800880 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ae:	83 c0 04             	add    $0x4,%eax
  8008b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b7:	83 e8 04             	sub    $0x4,%eax
  8008ba:	8b 00                	mov    (%eax),%eax
  8008bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008bf:	eb 1f                	jmp    8008e0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c5:	79 83                	jns    80084a <vprintfmt+0x54>
				width = 0;
  8008c7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008ce:	e9 77 ff ff ff       	jmp    80084a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008d3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008da:	e9 6b ff ff ff       	jmp    80084a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008df:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e4:	0f 89 60 ff ff ff    	jns    80084a <vprintfmt+0x54>
				width = precision, precision = -1;
  8008ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008f7:	e9 4e ff ff ff       	jmp    80084a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008fc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008ff:	e9 46 ff ff ff       	jmp    80084a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800904:	8b 45 14             	mov    0x14(%ebp),%eax
  800907:	83 c0 04             	add    $0x4,%eax
  80090a:	89 45 14             	mov    %eax,0x14(%ebp)
  80090d:	8b 45 14             	mov    0x14(%ebp),%eax
  800910:	83 e8 04             	sub    $0x4,%eax
  800913:	8b 00                	mov    (%eax),%eax
  800915:	83 ec 08             	sub    $0x8,%esp
  800918:	ff 75 0c             	pushl  0xc(%ebp)
  80091b:	50                   	push   %eax
  80091c:	8b 45 08             	mov    0x8(%ebp),%eax
  80091f:	ff d0                	call   *%eax
  800921:	83 c4 10             	add    $0x10,%esp
			break;
  800924:	e9 9b 02 00 00       	jmp    800bc4 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800929:	8b 45 14             	mov    0x14(%ebp),%eax
  80092c:	83 c0 04             	add    $0x4,%eax
  80092f:	89 45 14             	mov    %eax,0x14(%ebp)
  800932:	8b 45 14             	mov    0x14(%ebp),%eax
  800935:	83 e8 04             	sub    $0x4,%eax
  800938:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80093a:	85 db                	test   %ebx,%ebx
  80093c:	79 02                	jns    800940 <vprintfmt+0x14a>
				err = -err;
  80093e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800940:	83 fb 64             	cmp    $0x64,%ebx
  800943:	7f 0b                	jg     800950 <vprintfmt+0x15a>
  800945:	8b 34 9d 60 20 80 00 	mov    0x802060(,%ebx,4),%esi
  80094c:	85 f6                	test   %esi,%esi
  80094e:	75 19                	jne    800969 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800950:	53                   	push   %ebx
  800951:	68 05 22 80 00       	push   $0x802205
  800956:	ff 75 0c             	pushl  0xc(%ebp)
  800959:	ff 75 08             	pushl  0x8(%ebp)
  80095c:	e8 70 02 00 00       	call   800bd1 <printfmt>
  800961:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800964:	e9 5b 02 00 00       	jmp    800bc4 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800969:	56                   	push   %esi
  80096a:	68 0e 22 80 00       	push   $0x80220e
  80096f:	ff 75 0c             	pushl  0xc(%ebp)
  800972:	ff 75 08             	pushl  0x8(%ebp)
  800975:	e8 57 02 00 00       	call   800bd1 <printfmt>
  80097a:	83 c4 10             	add    $0x10,%esp
			break;
  80097d:	e9 42 02 00 00       	jmp    800bc4 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800982:	8b 45 14             	mov    0x14(%ebp),%eax
  800985:	83 c0 04             	add    $0x4,%eax
  800988:	89 45 14             	mov    %eax,0x14(%ebp)
  80098b:	8b 45 14             	mov    0x14(%ebp),%eax
  80098e:	83 e8 04             	sub    $0x4,%eax
  800991:	8b 30                	mov    (%eax),%esi
  800993:	85 f6                	test   %esi,%esi
  800995:	75 05                	jne    80099c <vprintfmt+0x1a6>
				p = "(null)";
  800997:	be 11 22 80 00       	mov    $0x802211,%esi
			if (width > 0 && padc != '-')
  80099c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a0:	7e 6d                	jle    800a0f <vprintfmt+0x219>
  8009a2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009a6:	74 67                	je     800a0f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009ab:	83 ec 08             	sub    $0x8,%esp
  8009ae:	50                   	push   %eax
  8009af:	56                   	push   %esi
  8009b0:	e8 1e 03 00 00       	call   800cd3 <strnlen>
  8009b5:	83 c4 10             	add    $0x10,%esp
  8009b8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009bb:	eb 16                	jmp    8009d3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009bd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009c1:	83 ec 08             	sub    $0x8,%esp
  8009c4:	ff 75 0c             	pushl  0xc(%ebp)
  8009c7:	50                   	push   %eax
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	ff d0                	call   *%eax
  8009cd:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d0:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d7:	7f e4                	jg     8009bd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d9:	eb 34                	jmp    800a0f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009db:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009df:	74 1c                	je     8009fd <vprintfmt+0x207>
  8009e1:	83 fb 1f             	cmp    $0x1f,%ebx
  8009e4:	7e 05                	jle    8009eb <vprintfmt+0x1f5>
  8009e6:	83 fb 7e             	cmp    $0x7e,%ebx
  8009e9:	7e 12                	jle    8009fd <vprintfmt+0x207>
					putch('?', putdat);
  8009eb:	83 ec 08             	sub    $0x8,%esp
  8009ee:	ff 75 0c             	pushl  0xc(%ebp)
  8009f1:	6a 3f                	push   $0x3f
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	ff d0                	call   *%eax
  8009f8:	83 c4 10             	add    $0x10,%esp
  8009fb:	eb 0f                	jmp    800a0c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009fd:	83 ec 08             	sub    $0x8,%esp
  800a00:	ff 75 0c             	pushl  0xc(%ebp)
  800a03:	53                   	push   %ebx
  800a04:	8b 45 08             	mov    0x8(%ebp),%eax
  800a07:	ff d0                	call   *%eax
  800a09:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0c:	ff 4d e4             	decl   -0x1c(%ebp)
  800a0f:	89 f0                	mov    %esi,%eax
  800a11:	8d 70 01             	lea    0x1(%eax),%esi
  800a14:	8a 00                	mov    (%eax),%al
  800a16:	0f be d8             	movsbl %al,%ebx
  800a19:	85 db                	test   %ebx,%ebx
  800a1b:	74 24                	je     800a41 <vprintfmt+0x24b>
  800a1d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a21:	78 b8                	js     8009db <vprintfmt+0x1e5>
  800a23:	ff 4d e0             	decl   -0x20(%ebp)
  800a26:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a2a:	79 af                	jns    8009db <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a2c:	eb 13                	jmp    800a41 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a2e:	83 ec 08             	sub    $0x8,%esp
  800a31:	ff 75 0c             	pushl  0xc(%ebp)
  800a34:	6a 20                	push   $0x20
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	ff d0                	call   *%eax
  800a3b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a3e:	ff 4d e4             	decl   -0x1c(%ebp)
  800a41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a45:	7f e7                	jg     800a2e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a47:	e9 78 01 00 00       	jmp    800bc4 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a4c:	83 ec 08             	sub    $0x8,%esp
  800a4f:	ff 75 e8             	pushl  -0x18(%ebp)
  800a52:	8d 45 14             	lea    0x14(%ebp),%eax
  800a55:	50                   	push   %eax
  800a56:	e8 3c fd ff ff       	call   800797 <getint>
  800a5b:	83 c4 10             	add    $0x10,%esp
  800a5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a61:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a6a:	85 d2                	test   %edx,%edx
  800a6c:	79 23                	jns    800a91 <vprintfmt+0x29b>
				putch('-', putdat);
  800a6e:	83 ec 08             	sub    $0x8,%esp
  800a71:	ff 75 0c             	pushl  0xc(%ebp)
  800a74:	6a 2d                	push   $0x2d
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	ff d0                	call   *%eax
  800a7b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a84:	f7 d8                	neg    %eax
  800a86:	83 d2 00             	adc    $0x0,%edx
  800a89:	f7 da                	neg    %edx
  800a8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a8e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a91:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a98:	e9 bc 00 00 00       	jmp    800b59 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a9d:	83 ec 08             	sub    $0x8,%esp
  800aa0:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa3:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa6:	50                   	push   %eax
  800aa7:	e8 84 fc ff ff       	call   800730 <getuint>
  800aac:	83 c4 10             	add    $0x10,%esp
  800aaf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ab5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800abc:	e9 98 00 00 00       	jmp    800b59 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ac1:	83 ec 08             	sub    $0x8,%esp
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	6a 58                	push   $0x58
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	ff d0                	call   *%eax
  800ace:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ad1:	83 ec 08             	sub    $0x8,%esp
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	6a 58                	push   $0x58
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	ff d0                	call   *%eax
  800ade:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ae1:	83 ec 08             	sub    $0x8,%esp
  800ae4:	ff 75 0c             	pushl  0xc(%ebp)
  800ae7:	6a 58                	push   $0x58
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	ff d0                	call   *%eax
  800aee:	83 c4 10             	add    $0x10,%esp
			break;
  800af1:	e9 ce 00 00 00       	jmp    800bc4 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800af6:	83 ec 08             	sub    $0x8,%esp
  800af9:	ff 75 0c             	pushl  0xc(%ebp)
  800afc:	6a 30                	push   $0x30
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	ff d0                	call   *%eax
  800b03:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b06:	83 ec 08             	sub    $0x8,%esp
  800b09:	ff 75 0c             	pushl  0xc(%ebp)
  800b0c:	6a 78                	push   $0x78
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	ff d0                	call   *%eax
  800b13:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b16:	8b 45 14             	mov    0x14(%ebp),%eax
  800b19:	83 c0 04             	add    $0x4,%eax
  800b1c:	89 45 14             	mov    %eax,0x14(%ebp)
  800b1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b22:	83 e8 04             	sub    $0x4,%eax
  800b25:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b31:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b38:	eb 1f                	jmp    800b59 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b3a:	83 ec 08             	sub    $0x8,%esp
  800b3d:	ff 75 e8             	pushl  -0x18(%ebp)
  800b40:	8d 45 14             	lea    0x14(%ebp),%eax
  800b43:	50                   	push   %eax
  800b44:	e8 e7 fb ff ff       	call   800730 <getuint>
  800b49:	83 c4 10             	add    $0x10,%esp
  800b4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b52:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b59:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b60:	83 ec 04             	sub    $0x4,%esp
  800b63:	52                   	push   %edx
  800b64:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b67:	50                   	push   %eax
  800b68:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6b:	ff 75 f0             	pushl  -0x10(%ebp)
  800b6e:	ff 75 0c             	pushl  0xc(%ebp)
  800b71:	ff 75 08             	pushl  0x8(%ebp)
  800b74:	e8 00 fb ff ff       	call   800679 <printnum>
  800b79:	83 c4 20             	add    $0x20,%esp
			break;
  800b7c:	eb 46                	jmp    800bc4 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b7e:	83 ec 08             	sub    $0x8,%esp
  800b81:	ff 75 0c             	pushl  0xc(%ebp)
  800b84:	53                   	push   %ebx
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	ff d0                	call   *%eax
  800b8a:	83 c4 10             	add    $0x10,%esp
			break;
  800b8d:	eb 35                	jmp    800bc4 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b8f:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800b96:	eb 2c                	jmp    800bc4 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b98:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800b9f:	eb 23                	jmp    800bc4 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	ff 75 0c             	pushl  0xc(%ebp)
  800ba7:	6a 25                	push   $0x25
  800ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bac:	ff d0                	call   *%eax
  800bae:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bb1:	ff 4d 10             	decl   0x10(%ebp)
  800bb4:	eb 03                	jmp    800bb9 <vprintfmt+0x3c3>
  800bb6:	ff 4d 10             	decl   0x10(%ebp)
  800bb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbc:	48                   	dec    %eax
  800bbd:	8a 00                	mov    (%eax),%al
  800bbf:	3c 25                	cmp    $0x25,%al
  800bc1:	75 f3                	jne    800bb6 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800bc3:	90                   	nop
		}
	}
  800bc4:	e9 35 fc ff ff       	jmp    8007fe <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bc9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bcd:	5b                   	pop    %ebx
  800bce:	5e                   	pop    %esi
  800bcf:	5d                   	pop    %ebp
  800bd0:	c3                   	ret    

00800bd1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bd7:	8d 45 10             	lea    0x10(%ebp),%eax
  800bda:	83 c0 04             	add    $0x4,%eax
  800bdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800be0:	8b 45 10             	mov    0x10(%ebp),%eax
  800be3:	ff 75 f4             	pushl  -0xc(%ebp)
  800be6:	50                   	push   %eax
  800be7:	ff 75 0c             	pushl  0xc(%ebp)
  800bea:	ff 75 08             	pushl  0x8(%ebp)
  800bed:	e8 04 fc ff ff       	call   8007f6 <vprintfmt>
  800bf2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bf5:	90                   	nop
  800bf6:	c9                   	leave  
  800bf7:	c3                   	ret    

00800bf8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfe:	8b 40 08             	mov    0x8(%eax),%eax
  800c01:	8d 50 01             	lea    0x1(%eax),%edx
  800c04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c07:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0d:	8b 10                	mov    (%eax),%edx
  800c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c12:	8b 40 04             	mov    0x4(%eax),%eax
  800c15:	39 c2                	cmp    %eax,%edx
  800c17:	73 12                	jae    800c2b <sprintputch+0x33>
		*b->buf++ = ch;
  800c19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1c:	8b 00                	mov    (%eax),%eax
  800c1e:	8d 48 01             	lea    0x1(%eax),%ecx
  800c21:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c24:	89 0a                	mov    %ecx,(%edx)
  800c26:	8b 55 08             	mov    0x8(%ebp),%edx
  800c29:	88 10                	mov    %dl,(%eax)
}
  800c2b:	90                   	nop
  800c2c:	5d                   	pop    %ebp
  800c2d:	c3                   	ret    

00800c2e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c40:	8b 45 08             	mov    0x8(%ebp),%eax
  800c43:	01 d0                	add    %edx,%eax
  800c45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c4f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c53:	74 06                	je     800c5b <vsnprintf+0x2d>
  800c55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c59:	7f 07                	jg     800c62 <vsnprintf+0x34>
		return -E_INVAL;
  800c5b:	b8 03 00 00 00       	mov    $0x3,%eax
  800c60:	eb 20                	jmp    800c82 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c62:	ff 75 14             	pushl  0x14(%ebp)
  800c65:	ff 75 10             	pushl  0x10(%ebp)
  800c68:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c6b:	50                   	push   %eax
  800c6c:	68 f8 0b 80 00       	push   $0x800bf8
  800c71:	e8 80 fb ff ff       	call   8007f6 <vprintfmt>
  800c76:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c7c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    

00800c84 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c8a:	8d 45 10             	lea    0x10(%ebp),%eax
  800c8d:	83 c0 04             	add    $0x4,%eax
  800c90:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c93:	8b 45 10             	mov    0x10(%ebp),%eax
  800c96:	ff 75 f4             	pushl  -0xc(%ebp)
  800c99:	50                   	push   %eax
  800c9a:	ff 75 0c             	pushl  0xc(%ebp)
  800c9d:	ff 75 08             	pushl  0x8(%ebp)
  800ca0:	e8 89 ff ff ff       	call   800c2e <vsnprintf>
  800ca5:	83 c4 10             	add    $0x10,%esp
  800ca8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cae:	c9                   	leave  
  800caf:	c3                   	ret    

00800cb0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cbd:	eb 06                	jmp    800cc5 <strlen+0x15>
		n++;
  800cbf:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cc2:	ff 45 08             	incl   0x8(%ebp)
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	8a 00                	mov    (%eax),%al
  800cca:	84 c0                	test   %al,%al
  800ccc:	75 f1                	jne    800cbf <strlen+0xf>
		n++;
	return n;
  800cce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd1:	c9                   	leave  
  800cd2:	c3                   	ret    

00800cd3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce0:	eb 09                	jmp    800ceb <strnlen+0x18>
		n++;
  800ce2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ce5:	ff 45 08             	incl   0x8(%ebp)
  800ce8:	ff 4d 0c             	decl   0xc(%ebp)
  800ceb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cef:	74 09                	je     800cfa <strnlen+0x27>
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	8a 00                	mov    (%eax),%al
  800cf6:	84 c0                	test   %al,%al
  800cf8:	75 e8                	jne    800ce2 <strnlen+0xf>
		n++;
	return n;
  800cfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cfd:	c9                   	leave  
  800cfe:	c3                   	ret    

00800cff <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
  800d02:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d0b:	90                   	nop
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8d 50 01             	lea    0x1(%eax),%edx
  800d12:	89 55 08             	mov    %edx,0x8(%ebp)
  800d15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d18:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d1b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d1e:	8a 12                	mov    (%edx),%dl
  800d20:	88 10                	mov    %dl,(%eax)
  800d22:	8a 00                	mov    (%eax),%al
  800d24:	84 c0                	test   %al,%al
  800d26:	75 e4                	jne    800d0c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d28:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d2b:	c9                   	leave  
  800d2c:	c3                   	ret    

00800d2d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d39:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d40:	eb 1f                	jmp    800d61 <strncpy+0x34>
		*dst++ = *src;
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8d 50 01             	lea    0x1(%eax),%edx
  800d48:	89 55 08             	mov    %edx,0x8(%ebp)
  800d4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d4e:	8a 12                	mov    (%edx),%dl
  800d50:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	84 c0                	test   %al,%al
  800d59:	74 03                	je     800d5e <strncpy+0x31>
			src++;
  800d5b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d5e:	ff 45 fc             	incl   -0x4(%ebp)
  800d61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d64:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d67:	72 d9                	jb     800d42 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d69:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d6c:	c9                   	leave  
  800d6d:	c3                   	ret    

00800d6e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7e:	74 30                	je     800db0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d80:	eb 16                	jmp    800d98 <strlcpy+0x2a>
			*dst++ = *src++;
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8d 50 01             	lea    0x1(%eax),%edx
  800d88:	89 55 08             	mov    %edx,0x8(%ebp)
  800d8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d8e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d91:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d94:	8a 12                	mov    (%edx),%dl
  800d96:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d98:	ff 4d 10             	decl   0x10(%ebp)
  800d9b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d9f:	74 09                	je     800daa <strlcpy+0x3c>
  800da1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da4:	8a 00                	mov    (%eax),%al
  800da6:	84 c0                	test   %al,%al
  800da8:	75 d8                	jne    800d82 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dad:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800db0:	8b 55 08             	mov    0x8(%ebp),%edx
  800db3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db6:	29 c2                	sub    %eax,%edx
  800db8:	89 d0                	mov    %edx,%eax
}
  800dba:	c9                   	leave  
  800dbb:	c3                   	ret    

00800dbc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dbf:	eb 06                	jmp    800dc7 <strcmp+0xb>
		p++, q++;
  800dc1:	ff 45 08             	incl   0x8(%ebp)
  800dc4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	8a 00                	mov    (%eax),%al
  800dcc:	84 c0                	test   %al,%al
  800dce:	74 0e                	je     800dde <strcmp+0x22>
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	8a 10                	mov    (%eax),%dl
  800dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd8:	8a 00                	mov    (%eax),%al
  800dda:	38 c2                	cmp    %al,%dl
  800ddc:	74 e3                	je     800dc1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	8a 00                	mov    (%eax),%al
  800de3:	0f b6 d0             	movzbl %al,%edx
  800de6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de9:	8a 00                	mov    (%eax),%al
  800deb:	0f b6 c0             	movzbl %al,%eax
  800dee:	29 c2                	sub    %eax,%edx
  800df0:	89 d0                	mov    %edx,%eax
}
  800df2:	5d                   	pop    %ebp
  800df3:	c3                   	ret    

00800df4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800df7:	eb 09                	jmp    800e02 <strncmp+0xe>
		n--, p++, q++;
  800df9:	ff 4d 10             	decl   0x10(%ebp)
  800dfc:	ff 45 08             	incl   0x8(%ebp)
  800dff:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e02:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e06:	74 17                	je     800e1f <strncmp+0x2b>
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	8a 00                	mov    (%eax),%al
  800e0d:	84 c0                	test   %al,%al
  800e0f:	74 0e                	je     800e1f <strncmp+0x2b>
  800e11:	8b 45 08             	mov    0x8(%ebp),%eax
  800e14:	8a 10                	mov    (%eax),%dl
  800e16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e19:	8a 00                	mov    (%eax),%al
  800e1b:	38 c2                	cmp    %al,%dl
  800e1d:	74 da                	je     800df9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e1f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e23:	75 07                	jne    800e2c <strncmp+0x38>
		return 0;
  800e25:	b8 00 00 00 00       	mov    $0x0,%eax
  800e2a:	eb 14                	jmp    800e40 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	8a 00                	mov    (%eax),%al
  800e31:	0f b6 d0             	movzbl %al,%edx
  800e34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e37:	8a 00                	mov    (%eax),%al
  800e39:	0f b6 c0             	movzbl %al,%eax
  800e3c:	29 c2                	sub    %eax,%edx
  800e3e:	89 d0                	mov    %edx,%eax
}
  800e40:	5d                   	pop    %ebp
  800e41:	c3                   	ret    

00800e42 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	83 ec 04             	sub    $0x4,%esp
  800e48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e4e:	eb 12                	jmp    800e62 <strchr+0x20>
		if (*s == c)
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	8a 00                	mov    (%eax),%al
  800e55:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e58:	75 05                	jne    800e5f <strchr+0x1d>
			return (char *) s;
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	eb 11                	jmp    800e70 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e5f:	ff 45 08             	incl   0x8(%ebp)
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	8a 00                	mov    (%eax),%al
  800e67:	84 c0                	test   %al,%al
  800e69:	75 e5                	jne    800e50 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e70:	c9                   	leave  
  800e71:	c3                   	ret    

00800e72 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e72:	55                   	push   %ebp
  800e73:	89 e5                	mov    %esp,%ebp
  800e75:	83 ec 04             	sub    $0x4,%esp
  800e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e7e:	eb 0d                	jmp    800e8d <strfind+0x1b>
		if (*s == c)
  800e80:	8b 45 08             	mov    0x8(%ebp),%eax
  800e83:	8a 00                	mov    (%eax),%al
  800e85:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e88:	74 0e                	je     800e98 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e8a:	ff 45 08             	incl   0x8(%ebp)
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e90:	8a 00                	mov    (%eax),%al
  800e92:	84 c0                	test   %al,%al
  800e94:	75 ea                	jne    800e80 <strfind+0xe>
  800e96:	eb 01                	jmp    800e99 <strfind+0x27>
		if (*s == c)
			break;
  800e98:	90                   	nop
	return (char *) s;
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e9c:	c9                   	leave  
  800e9d:	c3                   	ret    

00800e9e <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800eaa:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800eae:	76 63                	jbe    800f13 <memset+0x75>
		uint64 data_block = c;
  800eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb3:	99                   	cltd   
  800eb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb7:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ebd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec0:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ec4:	c1 e0 08             	shl    $0x8,%eax
  800ec7:	09 45 f0             	or     %eax,-0x10(%ebp)
  800eca:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed3:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800ed7:	c1 e0 10             	shl    $0x10,%eax
  800eda:	09 45 f0             	or     %eax,-0x10(%ebp)
  800edd:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee6:	89 c2                	mov    %eax,%edx
  800ee8:	b8 00 00 00 00       	mov    $0x0,%eax
  800eed:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ef0:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ef3:	eb 18                	jmp    800f0d <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ef5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ef8:	8d 41 08             	lea    0x8(%ecx),%eax
  800efb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800efe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f04:	89 01                	mov    %eax,(%ecx)
  800f06:	89 51 04             	mov    %edx,0x4(%ecx)
  800f09:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800f0d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f11:	77 e2                	ja     800ef5 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800f13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f17:	74 23                	je     800f3c <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800f19:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f1f:	eb 0e                	jmp    800f2f <memset+0x91>
			*p8++ = (uint8)c;
  800f21:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f24:	8d 50 01             	lea    0x1(%eax),%edx
  800f27:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f2d:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800f2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f32:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f35:	89 55 10             	mov    %edx,0x10(%ebp)
  800f38:	85 c0                	test   %eax,%eax
  800f3a:	75 e5                	jne    800f21 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3f:	c9                   	leave  
  800f40:	c3                   	ret    

00800f41 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800f47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800f53:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f57:	76 24                	jbe    800f7d <memcpy+0x3c>
		while(n >= 8){
  800f59:	eb 1c                	jmp    800f77 <memcpy+0x36>
			*d64 = *s64;
  800f5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5e:	8b 50 04             	mov    0x4(%eax),%edx
  800f61:	8b 00                	mov    (%eax),%eax
  800f63:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f66:	89 01                	mov    %eax,(%ecx)
  800f68:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800f6b:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800f6f:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800f73:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800f77:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f7b:	77 de                	ja     800f5b <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800f7d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f81:	74 31                	je     800fb4 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800f83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f86:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800f89:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800f8f:	eb 16                	jmp    800fa7 <memcpy+0x66>
			*d8++ = *s8++;
  800f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f94:	8d 50 01             	lea    0x1(%eax),%edx
  800f97:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f9d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fa0:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800fa3:	8a 12                	mov    (%edx),%dl
  800fa5:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800fa7:	8b 45 10             	mov    0x10(%ebp),%eax
  800faa:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fad:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb0:	85 c0                	test   %eax,%eax
  800fb2:	75 dd                	jne    800f91 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb7:	c9                   	leave  
  800fb8:	c3                   	ret    

00800fb9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fb9:	55                   	push   %ebp
  800fba:	89 e5                	mov    %esp,%ebp
  800fbc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fd1:	73 50                	jae    801023 <memmove+0x6a>
  800fd3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd9:	01 d0                	add    %edx,%eax
  800fdb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fde:	76 43                	jbe    801023 <memmove+0x6a>
		s += n;
  800fe0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fe6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fec:	eb 10                	jmp    800ffe <memmove+0x45>
			*--d = *--s;
  800fee:	ff 4d f8             	decl   -0x8(%ebp)
  800ff1:	ff 4d fc             	decl   -0x4(%ebp)
  800ff4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff7:	8a 10                	mov    (%eax),%dl
  800ff9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ffc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ffe:	8b 45 10             	mov    0x10(%ebp),%eax
  801001:	8d 50 ff             	lea    -0x1(%eax),%edx
  801004:	89 55 10             	mov    %edx,0x10(%ebp)
  801007:	85 c0                	test   %eax,%eax
  801009:	75 e3                	jne    800fee <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80100b:	eb 23                	jmp    801030 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80100d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801010:	8d 50 01             	lea    0x1(%eax),%edx
  801013:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801016:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801019:	8d 4a 01             	lea    0x1(%edx),%ecx
  80101c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80101f:	8a 12                	mov    (%edx),%dl
  801021:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801023:	8b 45 10             	mov    0x10(%ebp),%eax
  801026:	8d 50 ff             	lea    -0x1(%eax),%edx
  801029:	89 55 10             	mov    %edx,0x10(%ebp)
  80102c:	85 c0                	test   %eax,%eax
  80102e:	75 dd                	jne    80100d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801033:	c9                   	leave  
  801034:	c3                   	ret    

00801035 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801035:	55                   	push   %ebp
  801036:	89 e5                	mov    %esp,%ebp
  801038:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801041:	8b 45 0c             	mov    0xc(%ebp),%eax
  801044:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801047:	eb 2a                	jmp    801073 <memcmp+0x3e>
		if (*s1 != *s2)
  801049:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104c:	8a 10                	mov    (%eax),%dl
  80104e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801051:	8a 00                	mov    (%eax),%al
  801053:	38 c2                	cmp    %al,%dl
  801055:	74 16                	je     80106d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801057:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80105a:	8a 00                	mov    (%eax),%al
  80105c:	0f b6 d0             	movzbl %al,%edx
  80105f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801062:	8a 00                	mov    (%eax),%al
  801064:	0f b6 c0             	movzbl %al,%eax
  801067:	29 c2                	sub    %eax,%edx
  801069:	89 d0                	mov    %edx,%eax
  80106b:	eb 18                	jmp    801085 <memcmp+0x50>
		s1++, s2++;
  80106d:	ff 45 fc             	incl   -0x4(%ebp)
  801070:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801073:	8b 45 10             	mov    0x10(%ebp),%eax
  801076:	8d 50 ff             	lea    -0x1(%eax),%edx
  801079:	89 55 10             	mov    %edx,0x10(%ebp)
  80107c:	85 c0                	test   %eax,%eax
  80107e:	75 c9                	jne    801049 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801080:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801085:	c9                   	leave  
  801086:	c3                   	ret    

00801087 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80108d:	8b 55 08             	mov    0x8(%ebp),%edx
  801090:	8b 45 10             	mov    0x10(%ebp),%eax
  801093:	01 d0                	add    %edx,%eax
  801095:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801098:	eb 15                	jmp    8010af <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	8a 00                	mov    (%eax),%al
  80109f:	0f b6 d0             	movzbl %al,%edx
  8010a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a5:	0f b6 c0             	movzbl %al,%eax
  8010a8:	39 c2                	cmp    %eax,%edx
  8010aa:	74 0d                	je     8010b9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010ac:	ff 45 08             	incl   0x8(%ebp)
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010b5:	72 e3                	jb     80109a <memfind+0x13>
  8010b7:	eb 01                	jmp    8010ba <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010b9:	90                   	nop
	return (void *) s;
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010bd:	c9                   	leave  
  8010be:	c3                   	ret    

008010bf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
  8010c2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010d3:	eb 03                	jmp    8010d8 <strtol+0x19>
		s++;
  8010d5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	3c 20                	cmp    $0x20,%al
  8010df:	74 f4                	je     8010d5 <strtol+0x16>
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	8a 00                	mov    (%eax),%al
  8010e6:	3c 09                	cmp    $0x9,%al
  8010e8:	74 eb                	je     8010d5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	8a 00                	mov    (%eax),%al
  8010ef:	3c 2b                	cmp    $0x2b,%al
  8010f1:	75 05                	jne    8010f8 <strtol+0x39>
		s++;
  8010f3:	ff 45 08             	incl   0x8(%ebp)
  8010f6:	eb 13                	jmp    80110b <strtol+0x4c>
	else if (*s == '-')
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	8a 00                	mov    (%eax),%al
  8010fd:	3c 2d                	cmp    $0x2d,%al
  8010ff:	75 0a                	jne    80110b <strtol+0x4c>
		s++, neg = 1;
  801101:	ff 45 08             	incl   0x8(%ebp)
  801104:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80110b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110f:	74 06                	je     801117 <strtol+0x58>
  801111:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801115:	75 20                	jne    801137 <strtol+0x78>
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	3c 30                	cmp    $0x30,%al
  80111e:	75 17                	jne    801137 <strtol+0x78>
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
  801123:	40                   	inc    %eax
  801124:	8a 00                	mov    (%eax),%al
  801126:	3c 78                	cmp    $0x78,%al
  801128:	75 0d                	jne    801137 <strtol+0x78>
		s += 2, base = 16;
  80112a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80112e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801135:	eb 28                	jmp    80115f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801137:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80113b:	75 15                	jne    801152 <strtol+0x93>
  80113d:	8b 45 08             	mov    0x8(%ebp),%eax
  801140:	8a 00                	mov    (%eax),%al
  801142:	3c 30                	cmp    $0x30,%al
  801144:	75 0c                	jne    801152 <strtol+0x93>
		s++, base = 8;
  801146:	ff 45 08             	incl   0x8(%ebp)
  801149:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801150:	eb 0d                	jmp    80115f <strtol+0xa0>
	else if (base == 0)
  801152:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801156:	75 07                	jne    80115f <strtol+0xa0>
		base = 10;
  801158:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	3c 2f                	cmp    $0x2f,%al
  801166:	7e 19                	jle    801181 <strtol+0xc2>
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	3c 39                	cmp    $0x39,%al
  80116f:	7f 10                	jg     801181 <strtol+0xc2>
			dig = *s - '0';
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	8a 00                	mov    (%eax),%al
  801176:	0f be c0             	movsbl %al,%eax
  801179:	83 e8 30             	sub    $0x30,%eax
  80117c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80117f:	eb 42                	jmp    8011c3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	3c 60                	cmp    $0x60,%al
  801188:	7e 19                	jle    8011a3 <strtol+0xe4>
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	3c 7a                	cmp    $0x7a,%al
  801191:	7f 10                	jg     8011a3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	8a 00                	mov    (%eax),%al
  801198:	0f be c0             	movsbl %al,%eax
  80119b:	83 e8 57             	sub    $0x57,%eax
  80119e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011a1:	eb 20                	jmp    8011c3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	8a 00                	mov    (%eax),%al
  8011a8:	3c 40                	cmp    $0x40,%al
  8011aa:	7e 39                	jle    8011e5 <strtol+0x126>
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	3c 5a                	cmp    $0x5a,%al
  8011b3:	7f 30                	jg     8011e5 <strtol+0x126>
			dig = *s - 'A' + 10;
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	0f be c0             	movsbl %al,%eax
  8011bd:	83 e8 37             	sub    $0x37,%eax
  8011c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011c9:	7d 19                	jge    8011e4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011cb:	ff 45 08             	incl   0x8(%ebp)
  8011ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011d5:	89 c2                	mov    %eax,%edx
  8011d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011da:	01 d0                	add    %edx,%eax
  8011dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011df:	e9 7b ff ff ff       	jmp    80115f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011e4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011e9:	74 08                	je     8011f3 <strtol+0x134>
		*endptr = (char *) s;
  8011eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011f7:	74 07                	je     801200 <strtol+0x141>
  8011f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011fc:	f7 d8                	neg    %eax
  8011fe:	eb 03                	jmp    801203 <strtol+0x144>
  801200:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801203:	c9                   	leave  
  801204:	c3                   	ret    

00801205 <ltostr>:

void
ltostr(long value, char *str)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80120b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801212:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801219:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80121d:	79 13                	jns    801232 <ltostr+0x2d>
	{
		neg = 1;
  80121f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801226:	8b 45 0c             	mov    0xc(%ebp),%eax
  801229:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80122c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80122f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
  801235:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80123a:	99                   	cltd   
  80123b:	f7 f9                	idiv   %ecx
  80123d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801240:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801243:	8d 50 01             	lea    0x1(%eax),%edx
  801246:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801249:	89 c2                	mov    %eax,%edx
  80124b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124e:	01 d0                	add    %edx,%eax
  801250:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801253:	83 c2 30             	add    $0x30,%edx
  801256:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801258:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80125b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801260:	f7 e9                	imul   %ecx
  801262:	c1 fa 02             	sar    $0x2,%edx
  801265:	89 c8                	mov    %ecx,%eax
  801267:	c1 f8 1f             	sar    $0x1f,%eax
  80126a:	29 c2                	sub    %eax,%edx
  80126c:	89 d0                	mov    %edx,%eax
  80126e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801271:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801275:	75 bb                	jne    801232 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801277:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80127e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801281:	48                   	dec    %eax
  801282:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801285:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801289:	74 3d                	je     8012c8 <ltostr+0xc3>
		start = 1 ;
  80128b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801292:	eb 34                	jmp    8012c8 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801294:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129a:	01 d0                	add    %edx,%eax
  80129c:	8a 00                	mov    (%eax),%al
  80129e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a7:	01 c2                	add    %eax,%edx
  8012a9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012af:	01 c8                	add    %ecx,%eax
  8012b1:	8a 00                	mov    (%eax),%al
  8012b3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bb:	01 c2                	add    %eax,%edx
  8012bd:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012c0:	88 02                	mov    %al,(%edx)
		start++ ;
  8012c2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012c5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012cb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012ce:	7c c4                	jl     801294 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012d0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d6:	01 d0                	add    %edx,%eax
  8012d8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012db:	90                   	nop
  8012dc:	c9                   	leave  
  8012dd:	c3                   	ret    

008012de <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012e4:	ff 75 08             	pushl  0x8(%ebp)
  8012e7:	e8 c4 f9 ff ff       	call   800cb0 <strlen>
  8012ec:	83 c4 04             	add    $0x4,%esp
  8012ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012f2:	ff 75 0c             	pushl  0xc(%ebp)
  8012f5:	e8 b6 f9 ff ff       	call   800cb0 <strlen>
  8012fa:	83 c4 04             	add    $0x4,%esp
  8012fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801300:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801307:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80130e:	eb 17                	jmp    801327 <strcconcat+0x49>
		final[s] = str1[s] ;
  801310:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801313:	8b 45 10             	mov    0x10(%ebp),%eax
  801316:	01 c2                	add    %eax,%edx
  801318:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80131b:	8b 45 08             	mov    0x8(%ebp),%eax
  80131e:	01 c8                	add    %ecx,%eax
  801320:	8a 00                	mov    (%eax),%al
  801322:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801324:	ff 45 fc             	incl   -0x4(%ebp)
  801327:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80132d:	7c e1                	jl     801310 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80132f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801336:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80133d:	eb 1f                	jmp    80135e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80133f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801342:	8d 50 01             	lea    0x1(%eax),%edx
  801345:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801348:	89 c2                	mov    %eax,%edx
  80134a:	8b 45 10             	mov    0x10(%ebp),%eax
  80134d:	01 c2                	add    %eax,%edx
  80134f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801352:	8b 45 0c             	mov    0xc(%ebp),%eax
  801355:	01 c8                	add    %ecx,%eax
  801357:	8a 00                	mov    (%eax),%al
  801359:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80135b:	ff 45 f8             	incl   -0x8(%ebp)
  80135e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801361:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801364:	7c d9                	jl     80133f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801366:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801369:	8b 45 10             	mov    0x10(%ebp),%eax
  80136c:	01 d0                	add    %edx,%eax
  80136e:	c6 00 00             	movb   $0x0,(%eax)
}
  801371:	90                   	nop
  801372:	c9                   	leave  
  801373:	c3                   	ret    

00801374 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801374:	55                   	push   %ebp
  801375:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801377:	8b 45 14             	mov    0x14(%ebp),%eax
  80137a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801380:	8b 45 14             	mov    0x14(%ebp),%eax
  801383:	8b 00                	mov    (%eax),%eax
  801385:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80138c:	8b 45 10             	mov    0x10(%ebp),%eax
  80138f:	01 d0                	add    %edx,%eax
  801391:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801397:	eb 0c                	jmp    8013a5 <strsplit+0x31>
			*string++ = 0;
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	8d 50 01             	lea    0x1(%eax),%edx
  80139f:	89 55 08             	mov    %edx,0x8(%ebp)
  8013a2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	8a 00                	mov    (%eax),%al
  8013aa:	84 c0                	test   %al,%al
  8013ac:	74 18                	je     8013c6 <strsplit+0x52>
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	8a 00                	mov    (%eax),%al
  8013b3:	0f be c0             	movsbl %al,%eax
  8013b6:	50                   	push   %eax
  8013b7:	ff 75 0c             	pushl  0xc(%ebp)
  8013ba:	e8 83 fa ff ff       	call   800e42 <strchr>
  8013bf:	83 c4 08             	add    $0x8,%esp
  8013c2:	85 c0                	test   %eax,%eax
  8013c4:	75 d3                	jne    801399 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	84 c0                	test   %al,%al
  8013cd:	74 5a                	je     801429 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d2:	8b 00                	mov    (%eax),%eax
  8013d4:	83 f8 0f             	cmp    $0xf,%eax
  8013d7:	75 07                	jne    8013e0 <strsplit+0x6c>
		{
			return 0;
  8013d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013de:	eb 66                	jmp    801446 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e3:	8b 00                	mov    (%eax),%eax
  8013e5:	8d 48 01             	lea    0x1(%eax),%ecx
  8013e8:	8b 55 14             	mov    0x14(%ebp),%edx
  8013eb:	89 0a                	mov    %ecx,(%edx)
  8013ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f7:	01 c2                	add    %eax,%edx
  8013f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fc:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013fe:	eb 03                	jmp    801403 <strsplit+0x8f>
			string++;
  801400:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	84 c0                	test   %al,%al
  80140a:	74 8b                	je     801397 <strsplit+0x23>
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	0f be c0             	movsbl %al,%eax
  801414:	50                   	push   %eax
  801415:	ff 75 0c             	pushl  0xc(%ebp)
  801418:	e8 25 fa ff ff       	call   800e42 <strchr>
  80141d:	83 c4 08             	add    $0x8,%esp
  801420:	85 c0                	test   %eax,%eax
  801422:	74 dc                	je     801400 <strsplit+0x8c>
			string++;
	}
  801424:	e9 6e ff ff ff       	jmp    801397 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801429:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80142a:	8b 45 14             	mov    0x14(%ebp),%eax
  80142d:	8b 00                	mov    (%eax),%eax
  80142f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801436:	8b 45 10             	mov    0x10(%ebp),%eax
  801439:	01 d0                	add    %edx,%eax
  80143b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801441:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801446:	c9                   	leave  
  801447:	c3                   	ret    

00801448 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801448:	55                   	push   %ebp
  801449:	89 e5                	mov    %esp,%ebp
  80144b:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80144e:	8b 45 08             	mov    0x8(%ebp),%eax
  801451:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801454:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80145b:	eb 4a                	jmp    8014a7 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80145d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801460:	8b 45 08             	mov    0x8(%ebp),%eax
  801463:	01 c2                	add    %eax,%edx
  801465:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146b:	01 c8                	add    %ecx,%eax
  80146d:	8a 00                	mov    (%eax),%al
  80146f:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801471:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801474:	8b 45 0c             	mov    0xc(%ebp),%eax
  801477:	01 d0                	add    %edx,%eax
  801479:	8a 00                	mov    (%eax),%al
  80147b:	3c 40                	cmp    $0x40,%al
  80147d:	7e 25                	jle    8014a4 <str2lower+0x5c>
  80147f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801482:	8b 45 0c             	mov    0xc(%ebp),%eax
  801485:	01 d0                	add    %edx,%eax
  801487:	8a 00                	mov    (%eax),%al
  801489:	3c 5a                	cmp    $0x5a,%al
  80148b:	7f 17                	jg     8014a4 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80148d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801490:	8b 45 08             	mov    0x8(%ebp),%eax
  801493:	01 d0                	add    %edx,%eax
  801495:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801498:	8b 55 08             	mov    0x8(%ebp),%edx
  80149b:	01 ca                	add    %ecx,%edx
  80149d:	8a 12                	mov    (%edx),%dl
  80149f:	83 c2 20             	add    $0x20,%edx
  8014a2:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8014a4:	ff 45 fc             	incl   -0x4(%ebp)
  8014a7:	ff 75 0c             	pushl  0xc(%ebp)
  8014aa:	e8 01 f8 ff ff       	call   800cb0 <strlen>
  8014af:	83 c4 04             	add    $0x4,%esp
  8014b2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014b5:	7f a6                	jg     80145d <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8014b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
  8014bf:	57                   	push   %edi
  8014c0:	56                   	push   %esi
  8014c1:	53                   	push   %ebx
  8014c2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014ce:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014d1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014d4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014d7:	cd 30                	int    $0x30
  8014d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8014dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014df:	83 c4 10             	add    $0x10,%esp
  8014e2:	5b                   	pop    %ebx
  8014e3:	5e                   	pop    %esi
  8014e4:	5f                   	pop    %edi
  8014e5:	5d                   	pop    %ebp
  8014e6:	c3                   	ret    

008014e7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
  8014ea:	83 ec 04             	sub    $0x4,%esp
  8014ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8014f3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014f6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fd:	6a 00                	push   $0x0
  8014ff:	51                   	push   %ecx
  801500:	52                   	push   %edx
  801501:	ff 75 0c             	pushl  0xc(%ebp)
  801504:	50                   	push   %eax
  801505:	6a 00                	push   $0x0
  801507:	e8 b0 ff ff ff       	call   8014bc <syscall>
  80150c:	83 c4 18             	add    $0x18,%esp
}
  80150f:	90                   	nop
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <sys_cgetc>:

int
sys_cgetc(void)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	6a 00                	push   $0x0
  80151f:	6a 02                	push   $0x2
  801521:	e8 96 ff ff ff       	call   8014bc <syscall>
  801526:	83 c4 18             	add    $0x18,%esp
}
  801529:	c9                   	leave  
  80152a:	c3                   	ret    

0080152b <sys_lock_cons>:

void sys_lock_cons(void)
{
  80152b:	55                   	push   %ebp
  80152c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	6a 00                	push   $0x0
  801534:	6a 00                	push   $0x0
  801536:	6a 00                	push   $0x0
  801538:	6a 03                	push   $0x3
  80153a:	e8 7d ff ff ff       	call   8014bc <syscall>
  80153f:	83 c4 18             	add    $0x18,%esp
}
  801542:	90                   	nop
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 04                	push   $0x4
  801554:	e8 63 ff ff ff       	call   8014bc <syscall>
  801559:	83 c4 18             	add    $0x18,%esp
}
  80155c:	90                   	nop
  80155d:	c9                   	leave  
  80155e:	c3                   	ret    

0080155f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801562:	8b 55 0c             	mov    0xc(%ebp),%edx
  801565:	8b 45 08             	mov    0x8(%ebp),%eax
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	52                   	push   %edx
  80156f:	50                   	push   %eax
  801570:	6a 08                	push   $0x8
  801572:	e8 45 ff ff ff       	call   8014bc <syscall>
  801577:	83 c4 18             	add    $0x18,%esp
}
  80157a:	c9                   	leave  
  80157b:	c3                   	ret    

0080157c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
  80157f:	56                   	push   %esi
  801580:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801581:	8b 75 18             	mov    0x18(%ebp),%esi
  801584:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801587:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80158a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
  801590:	56                   	push   %esi
  801591:	53                   	push   %ebx
  801592:	51                   	push   %ecx
  801593:	52                   	push   %edx
  801594:	50                   	push   %eax
  801595:	6a 09                	push   $0x9
  801597:	e8 20 ff ff ff       	call   8014bc <syscall>
  80159c:	83 c4 18             	add    $0x18,%esp
}
  80159f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015a2:	5b                   	pop    %ebx
  8015a3:	5e                   	pop    %esi
  8015a4:	5d                   	pop    %ebp
  8015a5:	c3                   	ret    

008015a6 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	ff 75 08             	pushl  0x8(%ebp)
  8015b4:	6a 0a                	push   $0xa
  8015b6:	e8 01 ff ff ff       	call   8014bc <syscall>
  8015bb:	83 c4 18             	add    $0x18,%esp
}
  8015be:	c9                   	leave  
  8015bf:	c3                   	ret    

008015c0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	ff 75 0c             	pushl  0xc(%ebp)
  8015cc:	ff 75 08             	pushl  0x8(%ebp)
  8015cf:	6a 0b                	push   $0xb
  8015d1:	e8 e6 fe ff ff       	call   8014bc <syscall>
  8015d6:	83 c4 18             	add    $0x18,%esp
}
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    

008015db <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 0c                	push   $0xc
  8015ea:	e8 cd fe ff ff       	call   8014bc <syscall>
  8015ef:	83 c4 18             	add    $0x18,%esp
}
  8015f2:	c9                   	leave  
  8015f3:	c3                   	ret    

008015f4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 0d                	push   $0xd
  801603:	e8 b4 fe ff ff       	call   8014bc <syscall>
  801608:	83 c4 18             	add    $0x18,%esp
}
  80160b:	c9                   	leave  
  80160c:	c3                   	ret    

0080160d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 0e                	push   $0xe
  80161c:	e8 9b fe ff ff       	call   8014bc <syscall>
  801621:	83 c4 18             	add    $0x18,%esp
}
  801624:	c9                   	leave  
  801625:	c3                   	ret    

00801626 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 0f                	push   $0xf
  801635:	e8 82 fe ff ff       	call   8014bc <syscall>
  80163a:	83 c4 18             	add    $0x18,%esp
}
  80163d:	c9                   	leave  
  80163e:	c3                   	ret    

0080163f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	ff 75 08             	pushl  0x8(%ebp)
  80164d:	6a 10                	push   $0x10
  80164f:	e8 68 fe ff ff       	call   8014bc <syscall>
  801654:	83 c4 18             	add    $0x18,%esp
}
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 11                	push   $0x11
  801668:	e8 4f fe ff ff       	call   8014bc <syscall>
  80166d:	83 c4 18             	add    $0x18,%esp
}
  801670:	90                   	nop
  801671:	c9                   	leave  
  801672:	c3                   	ret    

00801673 <sys_cputc>:

void
sys_cputc(const char c)
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
  801676:	83 ec 04             	sub    $0x4,%esp
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80167f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	50                   	push   %eax
  80168c:	6a 01                	push   $0x1
  80168e:	e8 29 fe ff ff       	call   8014bc <syscall>
  801693:	83 c4 18             	add    $0x18,%esp
}
  801696:	90                   	nop
  801697:	c9                   	leave  
  801698:	c3                   	ret    

00801699 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 14                	push   $0x14
  8016a8:	e8 0f fe ff ff       	call   8014bc <syscall>
  8016ad:	83 c4 18             	add    $0x18,%esp
}
  8016b0:	90                   	nop
  8016b1:	c9                   	leave  
  8016b2:	c3                   	ret    

008016b3 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	83 ec 04             	sub    $0x4,%esp
  8016b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016bf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016c2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c9:	6a 00                	push   $0x0
  8016cb:	51                   	push   %ecx
  8016cc:	52                   	push   %edx
  8016cd:	ff 75 0c             	pushl  0xc(%ebp)
  8016d0:	50                   	push   %eax
  8016d1:	6a 15                	push   $0x15
  8016d3:	e8 e4 fd ff ff       	call   8014bc <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
}
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	52                   	push   %edx
  8016ed:	50                   	push   %eax
  8016ee:	6a 16                	push   $0x16
  8016f0:	e8 c7 fd ff ff       	call   8014bc <syscall>
  8016f5:	83 c4 18             	add    $0x18,%esp
}
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801700:	8b 55 0c             	mov    0xc(%ebp),%edx
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	51                   	push   %ecx
  80170b:	52                   	push   %edx
  80170c:	50                   	push   %eax
  80170d:	6a 17                	push   $0x17
  80170f:	e8 a8 fd ff ff       	call   8014bc <syscall>
  801714:	83 c4 18             	add    $0x18,%esp
}
  801717:	c9                   	leave  
  801718:	c3                   	ret    

00801719 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80171c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171f:	8b 45 08             	mov    0x8(%ebp),%eax
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	52                   	push   %edx
  801729:	50                   	push   %eax
  80172a:	6a 18                	push   $0x18
  80172c:	e8 8b fd ff ff       	call   8014bc <syscall>
  801731:	83 c4 18             	add    $0x18,%esp
}
  801734:	c9                   	leave  
  801735:	c3                   	ret    

00801736 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	6a 00                	push   $0x0
  80173e:	ff 75 14             	pushl  0x14(%ebp)
  801741:	ff 75 10             	pushl  0x10(%ebp)
  801744:	ff 75 0c             	pushl  0xc(%ebp)
  801747:	50                   	push   %eax
  801748:	6a 19                	push   $0x19
  80174a:	e8 6d fd ff ff       	call   8014bc <syscall>
  80174f:	83 c4 18             	add    $0x18,%esp
}
  801752:	c9                   	leave  
  801753:	c3                   	ret    

00801754 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	50                   	push   %eax
  801763:	6a 1a                	push   $0x1a
  801765:	e8 52 fd ff ff       	call   8014bc <syscall>
  80176a:	83 c4 18             	add    $0x18,%esp
}
  80176d:	90                   	nop
  80176e:	c9                   	leave  
  80176f:	c3                   	ret    

00801770 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801773:	8b 45 08             	mov    0x8(%ebp),%eax
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	50                   	push   %eax
  80177f:	6a 1b                	push   $0x1b
  801781:	e8 36 fd ff ff       	call   8014bc <syscall>
  801786:	83 c4 18             	add    $0x18,%esp
}
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 05                	push   $0x5
  80179a:	e8 1d fd ff ff       	call   8014bc <syscall>
  80179f:	83 c4 18             	add    $0x18,%esp
}
  8017a2:	c9                   	leave  
  8017a3:	c3                   	ret    

008017a4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 06                	push   $0x6
  8017b3:	e8 04 fd ff ff       	call   8014bc <syscall>
  8017b8:	83 c4 18             	add    $0x18,%esp
}
  8017bb:	c9                   	leave  
  8017bc:	c3                   	ret    

008017bd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 07                	push   $0x7
  8017cc:	e8 eb fc ff ff       	call   8014bc <syscall>
  8017d1:	83 c4 18             	add    $0x18,%esp
}
  8017d4:	c9                   	leave  
  8017d5:	c3                   	ret    

008017d6 <sys_exit_env>:


void sys_exit_env(void)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 1c                	push   $0x1c
  8017e5:	e8 d2 fc ff ff       	call   8014bc <syscall>
  8017ea:	83 c4 18             	add    $0x18,%esp
}
  8017ed:	90                   	nop
  8017ee:	c9                   	leave  
  8017ef:	c3                   	ret    

008017f0 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017f6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017f9:	8d 50 04             	lea    0x4(%eax),%edx
  8017fc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	52                   	push   %edx
  801806:	50                   	push   %eax
  801807:	6a 1d                	push   $0x1d
  801809:	e8 ae fc ff ff       	call   8014bc <syscall>
  80180e:	83 c4 18             	add    $0x18,%esp
	return result;
  801811:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801814:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801817:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80181a:	89 01                	mov    %eax,(%ecx)
  80181c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	c9                   	leave  
  801823:	c2 04 00             	ret    $0x4

00801826 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	ff 75 10             	pushl  0x10(%ebp)
  801830:	ff 75 0c             	pushl  0xc(%ebp)
  801833:	ff 75 08             	pushl  0x8(%ebp)
  801836:	6a 13                	push   $0x13
  801838:	e8 7f fc ff ff       	call   8014bc <syscall>
  80183d:	83 c4 18             	add    $0x18,%esp
	return ;
  801840:	90                   	nop
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <sys_rcr2>:
uint32 sys_rcr2()
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 1e                	push   $0x1e
  801852:	e8 65 fc ff ff       	call   8014bc <syscall>
  801857:	83 c4 18             	add    $0x18,%esp
}
  80185a:	c9                   	leave  
  80185b:	c3                   	ret    

0080185c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	83 ec 04             	sub    $0x4,%esp
  801862:	8b 45 08             	mov    0x8(%ebp),%eax
  801865:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801868:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	50                   	push   %eax
  801875:	6a 1f                	push   $0x1f
  801877:	e8 40 fc ff ff       	call   8014bc <syscall>
  80187c:	83 c4 18             	add    $0x18,%esp
	return ;
  80187f:	90                   	nop
}
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <rsttst>:
void rsttst()
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 21                	push   $0x21
  801891:	e8 26 fc ff ff       	call   8014bc <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
	return ;
  801899:	90                   	nop
}
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	83 ec 04             	sub    $0x4,%esp
  8018a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018a5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8018a8:	8b 55 18             	mov    0x18(%ebp),%edx
  8018ab:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018af:	52                   	push   %edx
  8018b0:	50                   	push   %eax
  8018b1:	ff 75 10             	pushl  0x10(%ebp)
  8018b4:	ff 75 0c             	pushl  0xc(%ebp)
  8018b7:	ff 75 08             	pushl  0x8(%ebp)
  8018ba:	6a 20                	push   $0x20
  8018bc:	e8 fb fb ff ff       	call   8014bc <syscall>
  8018c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8018c4:	90                   	nop
}
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <chktst>:
void chktst(uint32 n)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	ff 75 08             	pushl  0x8(%ebp)
  8018d5:	6a 22                	push   $0x22
  8018d7:	e8 e0 fb ff ff       	call   8014bc <syscall>
  8018dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8018df:	90                   	nop
}
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <inctst>:

void inctst()
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 23                	push   $0x23
  8018f1:	e8 c6 fb ff ff       	call   8014bc <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f9:	90                   	nop
}
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <gettst>:
uint32 gettst()
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 24                	push   $0x24
  80190b:	e8 ac fb ff ff       	call   8014bc <syscall>
  801910:	83 c4 18             	add    $0x18,%esp
}
  801913:	c9                   	leave  
  801914:	c3                   	ret    

00801915 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 25                	push   $0x25
  801924:	e8 93 fb ff ff       	call   8014bc <syscall>
  801929:	83 c4 18             	add    $0x18,%esp
  80192c:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801931:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801936:	c9                   	leave  
  801937:	c3                   	ret    

00801938 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	ff 75 08             	pushl  0x8(%ebp)
  80194e:	6a 26                	push   $0x26
  801950:	e8 67 fb ff ff       	call   8014bc <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
	return ;
  801958:	90                   	nop
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80195f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801962:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801965:	8b 55 0c             	mov    0xc(%ebp),%edx
  801968:	8b 45 08             	mov    0x8(%ebp),%eax
  80196b:	6a 00                	push   $0x0
  80196d:	53                   	push   %ebx
  80196e:	51                   	push   %ecx
  80196f:	52                   	push   %edx
  801970:	50                   	push   %eax
  801971:	6a 27                	push   $0x27
  801973:	e8 44 fb ff ff       	call   8014bc <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
}
  80197b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801983:	8b 55 0c             	mov    0xc(%ebp),%edx
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	52                   	push   %edx
  801990:	50                   	push   %eax
  801991:	6a 28                	push   $0x28
  801993:	e8 24 fb ff ff       	call   8014bc <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8019a0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a9:	6a 00                	push   $0x0
  8019ab:	51                   	push   %ecx
  8019ac:	ff 75 10             	pushl  0x10(%ebp)
  8019af:	52                   	push   %edx
  8019b0:	50                   	push   %eax
  8019b1:	6a 29                	push   $0x29
  8019b3:	e8 04 fb ff ff       	call   8014bc <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
}
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	ff 75 10             	pushl  0x10(%ebp)
  8019c7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ca:	ff 75 08             	pushl  0x8(%ebp)
  8019cd:	6a 12                	push   $0x12
  8019cf:	e8 e8 fa ff ff       	call   8014bc <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d7:	90                   	nop
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8019dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	52                   	push   %edx
  8019ea:	50                   	push   %eax
  8019eb:	6a 2a                	push   $0x2a
  8019ed:	e8 ca fa ff ff       	call   8014bc <syscall>
  8019f2:	83 c4 18             	add    $0x18,%esp
	return;
  8019f5:	90                   	nop
}
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 2b                	push   $0x2b
  801a07:	e8 b0 fa ff ff       	call   8014bc <syscall>
  801a0c:	83 c4 18             	add    $0x18,%esp
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	ff 75 0c             	pushl  0xc(%ebp)
  801a1d:	ff 75 08             	pushl  0x8(%ebp)
  801a20:	6a 2d                	push   $0x2d
  801a22:	e8 95 fa ff ff       	call   8014bc <syscall>
  801a27:	83 c4 18             	add    $0x18,%esp
	return;
  801a2a:	90                   	nop
}
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    

00801a2d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	ff 75 0c             	pushl  0xc(%ebp)
  801a39:	ff 75 08             	pushl  0x8(%ebp)
  801a3c:	6a 2c                	push   $0x2c
  801a3e:	e8 79 fa ff ff       	call   8014bc <syscall>
  801a43:	83 c4 18             	add    $0x18,%esp
	return ;
  801a46:	90                   	nop
}
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
  801a4c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801a4f:	83 ec 04             	sub    $0x4,%esp
  801a52:	68 88 23 80 00       	push   $0x802388
  801a57:	68 25 01 00 00       	push   $0x125
  801a5c:	68 bb 23 80 00       	push   $0x8023bb
  801a61:	e8 a3 e8 ff ff       	call   800309 <_panic>
  801a66:	66 90                	xchg   %ax,%ax

00801a68 <__udivdi3>:
  801a68:	55                   	push   %ebp
  801a69:	57                   	push   %edi
  801a6a:	56                   	push   %esi
  801a6b:	53                   	push   %ebx
  801a6c:	83 ec 1c             	sub    $0x1c,%esp
  801a6f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a73:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a7b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a7f:	89 ca                	mov    %ecx,%edx
  801a81:	89 f8                	mov    %edi,%eax
  801a83:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a87:	85 f6                	test   %esi,%esi
  801a89:	75 2d                	jne    801ab8 <__udivdi3+0x50>
  801a8b:	39 cf                	cmp    %ecx,%edi
  801a8d:	77 65                	ja     801af4 <__udivdi3+0x8c>
  801a8f:	89 fd                	mov    %edi,%ebp
  801a91:	85 ff                	test   %edi,%edi
  801a93:	75 0b                	jne    801aa0 <__udivdi3+0x38>
  801a95:	b8 01 00 00 00       	mov    $0x1,%eax
  801a9a:	31 d2                	xor    %edx,%edx
  801a9c:	f7 f7                	div    %edi
  801a9e:	89 c5                	mov    %eax,%ebp
  801aa0:	31 d2                	xor    %edx,%edx
  801aa2:	89 c8                	mov    %ecx,%eax
  801aa4:	f7 f5                	div    %ebp
  801aa6:	89 c1                	mov    %eax,%ecx
  801aa8:	89 d8                	mov    %ebx,%eax
  801aaa:	f7 f5                	div    %ebp
  801aac:	89 cf                	mov    %ecx,%edi
  801aae:	89 fa                	mov    %edi,%edx
  801ab0:	83 c4 1c             	add    $0x1c,%esp
  801ab3:	5b                   	pop    %ebx
  801ab4:	5e                   	pop    %esi
  801ab5:	5f                   	pop    %edi
  801ab6:	5d                   	pop    %ebp
  801ab7:	c3                   	ret    
  801ab8:	39 ce                	cmp    %ecx,%esi
  801aba:	77 28                	ja     801ae4 <__udivdi3+0x7c>
  801abc:	0f bd fe             	bsr    %esi,%edi
  801abf:	83 f7 1f             	xor    $0x1f,%edi
  801ac2:	75 40                	jne    801b04 <__udivdi3+0x9c>
  801ac4:	39 ce                	cmp    %ecx,%esi
  801ac6:	72 0a                	jb     801ad2 <__udivdi3+0x6a>
  801ac8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801acc:	0f 87 9e 00 00 00    	ja     801b70 <__udivdi3+0x108>
  801ad2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad7:	89 fa                	mov    %edi,%edx
  801ad9:	83 c4 1c             	add    $0x1c,%esp
  801adc:	5b                   	pop    %ebx
  801add:	5e                   	pop    %esi
  801ade:	5f                   	pop    %edi
  801adf:	5d                   	pop    %ebp
  801ae0:	c3                   	ret    
  801ae1:	8d 76 00             	lea    0x0(%esi),%esi
  801ae4:	31 ff                	xor    %edi,%edi
  801ae6:	31 c0                	xor    %eax,%eax
  801ae8:	89 fa                	mov    %edi,%edx
  801aea:	83 c4 1c             	add    $0x1c,%esp
  801aed:	5b                   	pop    %ebx
  801aee:	5e                   	pop    %esi
  801aef:	5f                   	pop    %edi
  801af0:	5d                   	pop    %ebp
  801af1:	c3                   	ret    
  801af2:	66 90                	xchg   %ax,%ax
  801af4:	89 d8                	mov    %ebx,%eax
  801af6:	f7 f7                	div    %edi
  801af8:	31 ff                	xor    %edi,%edi
  801afa:	89 fa                	mov    %edi,%edx
  801afc:	83 c4 1c             	add    $0x1c,%esp
  801aff:	5b                   	pop    %ebx
  801b00:	5e                   	pop    %esi
  801b01:	5f                   	pop    %edi
  801b02:	5d                   	pop    %ebp
  801b03:	c3                   	ret    
  801b04:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b09:	89 eb                	mov    %ebp,%ebx
  801b0b:	29 fb                	sub    %edi,%ebx
  801b0d:	89 f9                	mov    %edi,%ecx
  801b0f:	d3 e6                	shl    %cl,%esi
  801b11:	89 c5                	mov    %eax,%ebp
  801b13:	88 d9                	mov    %bl,%cl
  801b15:	d3 ed                	shr    %cl,%ebp
  801b17:	89 e9                	mov    %ebp,%ecx
  801b19:	09 f1                	or     %esi,%ecx
  801b1b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b1f:	89 f9                	mov    %edi,%ecx
  801b21:	d3 e0                	shl    %cl,%eax
  801b23:	89 c5                	mov    %eax,%ebp
  801b25:	89 d6                	mov    %edx,%esi
  801b27:	88 d9                	mov    %bl,%cl
  801b29:	d3 ee                	shr    %cl,%esi
  801b2b:	89 f9                	mov    %edi,%ecx
  801b2d:	d3 e2                	shl    %cl,%edx
  801b2f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b33:	88 d9                	mov    %bl,%cl
  801b35:	d3 e8                	shr    %cl,%eax
  801b37:	09 c2                	or     %eax,%edx
  801b39:	89 d0                	mov    %edx,%eax
  801b3b:	89 f2                	mov    %esi,%edx
  801b3d:	f7 74 24 0c          	divl   0xc(%esp)
  801b41:	89 d6                	mov    %edx,%esi
  801b43:	89 c3                	mov    %eax,%ebx
  801b45:	f7 e5                	mul    %ebp
  801b47:	39 d6                	cmp    %edx,%esi
  801b49:	72 19                	jb     801b64 <__udivdi3+0xfc>
  801b4b:	74 0b                	je     801b58 <__udivdi3+0xf0>
  801b4d:	89 d8                	mov    %ebx,%eax
  801b4f:	31 ff                	xor    %edi,%edi
  801b51:	e9 58 ff ff ff       	jmp    801aae <__udivdi3+0x46>
  801b56:	66 90                	xchg   %ax,%ax
  801b58:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b5c:	89 f9                	mov    %edi,%ecx
  801b5e:	d3 e2                	shl    %cl,%edx
  801b60:	39 c2                	cmp    %eax,%edx
  801b62:	73 e9                	jae    801b4d <__udivdi3+0xe5>
  801b64:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b67:	31 ff                	xor    %edi,%edi
  801b69:	e9 40 ff ff ff       	jmp    801aae <__udivdi3+0x46>
  801b6e:	66 90                	xchg   %ax,%ax
  801b70:	31 c0                	xor    %eax,%eax
  801b72:	e9 37 ff ff ff       	jmp    801aae <__udivdi3+0x46>
  801b77:	90                   	nop

00801b78 <__umoddi3>:
  801b78:	55                   	push   %ebp
  801b79:	57                   	push   %edi
  801b7a:	56                   	push   %esi
  801b7b:	53                   	push   %ebx
  801b7c:	83 ec 1c             	sub    $0x1c,%esp
  801b7f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b83:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b87:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b93:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b97:	89 f3                	mov    %esi,%ebx
  801b99:	89 fa                	mov    %edi,%edx
  801b9b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b9f:	89 34 24             	mov    %esi,(%esp)
  801ba2:	85 c0                	test   %eax,%eax
  801ba4:	75 1a                	jne    801bc0 <__umoddi3+0x48>
  801ba6:	39 f7                	cmp    %esi,%edi
  801ba8:	0f 86 a2 00 00 00    	jbe    801c50 <__umoddi3+0xd8>
  801bae:	89 c8                	mov    %ecx,%eax
  801bb0:	89 f2                	mov    %esi,%edx
  801bb2:	f7 f7                	div    %edi
  801bb4:	89 d0                	mov    %edx,%eax
  801bb6:	31 d2                	xor    %edx,%edx
  801bb8:	83 c4 1c             	add    $0x1c,%esp
  801bbb:	5b                   	pop    %ebx
  801bbc:	5e                   	pop    %esi
  801bbd:	5f                   	pop    %edi
  801bbe:	5d                   	pop    %ebp
  801bbf:	c3                   	ret    
  801bc0:	39 f0                	cmp    %esi,%eax
  801bc2:	0f 87 ac 00 00 00    	ja     801c74 <__umoddi3+0xfc>
  801bc8:	0f bd e8             	bsr    %eax,%ebp
  801bcb:	83 f5 1f             	xor    $0x1f,%ebp
  801bce:	0f 84 ac 00 00 00    	je     801c80 <__umoddi3+0x108>
  801bd4:	bf 20 00 00 00       	mov    $0x20,%edi
  801bd9:	29 ef                	sub    %ebp,%edi
  801bdb:	89 fe                	mov    %edi,%esi
  801bdd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801be1:	89 e9                	mov    %ebp,%ecx
  801be3:	d3 e0                	shl    %cl,%eax
  801be5:	89 d7                	mov    %edx,%edi
  801be7:	89 f1                	mov    %esi,%ecx
  801be9:	d3 ef                	shr    %cl,%edi
  801beb:	09 c7                	or     %eax,%edi
  801bed:	89 e9                	mov    %ebp,%ecx
  801bef:	d3 e2                	shl    %cl,%edx
  801bf1:	89 14 24             	mov    %edx,(%esp)
  801bf4:	89 d8                	mov    %ebx,%eax
  801bf6:	d3 e0                	shl    %cl,%eax
  801bf8:	89 c2                	mov    %eax,%edx
  801bfa:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bfe:	d3 e0                	shl    %cl,%eax
  801c00:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c04:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c08:	89 f1                	mov    %esi,%ecx
  801c0a:	d3 e8                	shr    %cl,%eax
  801c0c:	09 d0                	or     %edx,%eax
  801c0e:	d3 eb                	shr    %cl,%ebx
  801c10:	89 da                	mov    %ebx,%edx
  801c12:	f7 f7                	div    %edi
  801c14:	89 d3                	mov    %edx,%ebx
  801c16:	f7 24 24             	mull   (%esp)
  801c19:	89 c6                	mov    %eax,%esi
  801c1b:	89 d1                	mov    %edx,%ecx
  801c1d:	39 d3                	cmp    %edx,%ebx
  801c1f:	0f 82 87 00 00 00    	jb     801cac <__umoddi3+0x134>
  801c25:	0f 84 91 00 00 00    	je     801cbc <__umoddi3+0x144>
  801c2b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c2f:	29 f2                	sub    %esi,%edx
  801c31:	19 cb                	sbb    %ecx,%ebx
  801c33:	89 d8                	mov    %ebx,%eax
  801c35:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c39:	d3 e0                	shl    %cl,%eax
  801c3b:	89 e9                	mov    %ebp,%ecx
  801c3d:	d3 ea                	shr    %cl,%edx
  801c3f:	09 d0                	or     %edx,%eax
  801c41:	89 e9                	mov    %ebp,%ecx
  801c43:	d3 eb                	shr    %cl,%ebx
  801c45:	89 da                	mov    %ebx,%edx
  801c47:	83 c4 1c             	add    $0x1c,%esp
  801c4a:	5b                   	pop    %ebx
  801c4b:	5e                   	pop    %esi
  801c4c:	5f                   	pop    %edi
  801c4d:	5d                   	pop    %ebp
  801c4e:	c3                   	ret    
  801c4f:	90                   	nop
  801c50:	89 fd                	mov    %edi,%ebp
  801c52:	85 ff                	test   %edi,%edi
  801c54:	75 0b                	jne    801c61 <__umoddi3+0xe9>
  801c56:	b8 01 00 00 00       	mov    $0x1,%eax
  801c5b:	31 d2                	xor    %edx,%edx
  801c5d:	f7 f7                	div    %edi
  801c5f:	89 c5                	mov    %eax,%ebp
  801c61:	89 f0                	mov    %esi,%eax
  801c63:	31 d2                	xor    %edx,%edx
  801c65:	f7 f5                	div    %ebp
  801c67:	89 c8                	mov    %ecx,%eax
  801c69:	f7 f5                	div    %ebp
  801c6b:	89 d0                	mov    %edx,%eax
  801c6d:	e9 44 ff ff ff       	jmp    801bb6 <__umoddi3+0x3e>
  801c72:	66 90                	xchg   %ax,%ax
  801c74:	89 c8                	mov    %ecx,%eax
  801c76:	89 f2                	mov    %esi,%edx
  801c78:	83 c4 1c             	add    $0x1c,%esp
  801c7b:	5b                   	pop    %ebx
  801c7c:	5e                   	pop    %esi
  801c7d:	5f                   	pop    %edi
  801c7e:	5d                   	pop    %ebp
  801c7f:	c3                   	ret    
  801c80:	3b 04 24             	cmp    (%esp),%eax
  801c83:	72 06                	jb     801c8b <__umoddi3+0x113>
  801c85:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c89:	77 0f                	ja     801c9a <__umoddi3+0x122>
  801c8b:	89 f2                	mov    %esi,%edx
  801c8d:	29 f9                	sub    %edi,%ecx
  801c8f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c93:	89 14 24             	mov    %edx,(%esp)
  801c96:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c9a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c9e:	8b 14 24             	mov    (%esp),%edx
  801ca1:	83 c4 1c             	add    $0x1c,%esp
  801ca4:	5b                   	pop    %ebx
  801ca5:	5e                   	pop    %esi
  801ca6:	5f                   	pop    %edi
  801ca7:	5d                   	pop    %ebp
  801ca8:	c3                   	ret    
  801ca9:	8d 76 00             	lea    0x0(%esi),%esi
  801cac:	2b 04 24             	sub    (%esp),%eax
  801caf:	19 fa                	sbb    %edi,%edx
  801cb1:	89 d1                	mov    %edx,%ecx
  801cb3:	89 c6                	mov    %eax,%esi
  801cb5:	e9 71 ff ff ff       	jmp    801c2b <__umoddi3+0xb3>
  801cba:	66 90                	xchg   %ax,%ax
  801cbc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801cc0:	72 ea                	jb     801cac <__umoddi3+0x134>
  801cc2:	89 d9                	mov    %ebx,%ecx
  801cc4:	e9 62 ff ff ff       	jmp    801c2b <__umoddi3+0xb3>
